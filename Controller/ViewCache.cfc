<cfcomponent extends="v1.Controller.View">
	<cffunction name="get" access="public" returntype="string">
		<cfargument name="url" type="any" required="yes" />
        <cfargument name="dataType" default="HTML" type="string" required="no" />
    	<!--- - attempt to retrieve the requested view data from the cache. If not found
				generate the requested view data and save it to the cache - --->
        <cfscript>
		var objectType=(isDefined("arguments.url.type")) ? arguments.url.type : "";
		var objectId=(isDefined("arguments.url.id")) ? arguments.url.id : 0;
		var defaultAction=false;
		var cacheData="";
		var objView={};
		
		if(objectType=="" || objectId==0 ){
			defaultAction=true;
		}
		
		if(defaultAction){
			// find featured Section
			objectType="Section";
			objectId=super.retrieveDefaultObjectId(objectType);
		}
		
		try{
			cacheData=this.retrieve(
				objectType,
				objectId,
				arguments.dataType
			);
		}
		catch(Any error){
			// retrieve view data
			objView=createObject("component","v1.Controller.ViewPublic");
			cacheData=objView.processRequest(url);
			// create cache entry
			this.put(
				objectType,
				objectId,
				cacheData,
				arguments.dataType
			);
		}
		
		return cacheData;
		</cfscript>
	</cffunction>

    <cffunction name="put" access="public" returntype="void">
		<cfargument name="objectType" type="string" required="yes" />
        <cfargument name="objectId" type="numeric" required="yes" />
        <cfargument name="data" type="string" required="yes" />
        <cfargument name="dataType" default="HTML" type="string" required="no" />
    	<!--- - save view data by inserting a record if it does not exist or
				updating a record if it does - --->
        <cfscript>
		var entryExists=false;
		
		entryExists=this.entryExists(
			arguments.objectType,
			arguments.objectId,
			arguments.dataType
		);
		
		if(!entryExists){
			this.create(
				arguments.objectType,
				arguments.objectId,
				arguments.data,
				arguments.dataType
			);
		}
		else{
			this.update(
				arguments.objectType,
				arguments.objectId,
				arguments.data,
				arguments.dataType
			);
		}
		</cfscript>
	</cffunction>
    
    <cffunction name="entryExists" access="public" returntype="boolean">
		<cfargument name="objectType" type="string" required="yes" />
        <cfargument name="objectId" type="numeric" required="yes" />
        <cfargument name="dataType" type="string" required="yes" />
    	<!--- - check whether a particular cache entry exists based on view request details - --->
        <cfscript>
		var sqlStatement="";
		var qryViewCache=new Query();
		var qryResult={};
		var cacheEntryExists=false;
		
		qryViewCache.setName("ViewCacheExists");
		
		sqlStatement="SELECT data
			FROM ViewCache
			WHERE ViewCache.dataType=:dataType
				AND ViewCache.objectId=:objectId
				AND ViewCache.objectType=:objectType";
		
        qryViewCache.setSQL(sqlStatement);
		
		qryViewCache.addParam(
			name="dataType",
			value=arguments.dataType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryViewCache.addParam(
			name="objectId",
			value=arguments.objectId,
			cfsqltype="CF_SQL_INTEGER"
		);
		qryViewCache.addParam(
			name="objectType",
			value=arguments.objectType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		
		qryResult=qryViewCache.execute().getResult();
		
		if(qryResult.recordCount>1){
			// there is an error in the cache as multiple cache entries were found
			throw(
				type=application.error.cache.multipleEntriesFound.type,
				message=application.error.cache.multipleEntriesFound.message,
				errorcode=application.error.cache.multipleEntriesFound.errorCode
			);
		}
		
		cacheEntryExists=(qryResult.recordCount==1);
		
		return cacheEntryExists;
        </cfscript>
	</cffunction>
    
    <cffunction name="clearByDataType" access="public" returntype="boolean">
		<cfargument name="dataType" type="string" required="yes" />   
    	<!--- - clear all cache entries based on the data type e.g. 'HTML', 'JSON' - --->
        <cfscript>
        var qryViewCache=new Query();
		var sqlStatement="";
		
		qryViewCache.setName("ViewCacheClear");
		
		sqlStatement="DELETE FROM ViewCache WHERE ViewCache.dataType=:dataType";
		
		qryViewCache.setSQL(sqlStatement);
		qryViewCache.addParam(
			name="dataType",
			value=arguments.dataType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryViewCache.execute();
    	</cfscript>
    </cffunction>
    
    <cffunction name="bubbleUpdate" access="public" returntype="void">
    	<cfargument name="objectType" type="string" required="yes" />
        <cfargument name="objectId" type="numeric" required="yes" />
        <cfargument name="dataType" default="HTML" type="string" required="no" />
        <!--- - recursive function that updates parent cache up to the top level parent - --->
		<cfscript>
		var type=arguments.objectType;
		var id=arguments.objectId;
		var dataType=arguments.dataType;
		
    	var sqlStatement="";
		var qryViewCache={};
		var qryResult={};
		
		var objView={};
		var viewParams={};
		var cacheData="";
		
		var i=0;
		
		qryViewCache=new Query();
		qryViewCache.setName("retrieveParentRecord");
		
		sqlStatement="SELECT ObjectRelationship.parentId,
				ObjectRelationship.parentType
			FROM ObjectRelationship
			WHERE ObjectRelationship.childId=:objectId
				AND ObjectRelationship.childType=:objectType";
		
		qryViewCache.setSQL(sqlStatement);
		
		qryViewCache.addParam(
			name="objectId",
			value=id,
			cfsqltype="CF_SQL_INTEGER"
		);
		qryViewCache.addParam(
			name="objectType",
			value=type,
			cfsqltype="CF_SQL_VARCHAR"
		);
		
		qryResult=qryViewCache.execute().getResult();
		
		// setup parameters for ViewPublic processRequest call
		// this mimics what woudl normally be contained in URL
		viewParams.action="view";
		viewParams.type=type;
		viewParams.id=id;
		
		// retrieve view data
		objView=createObject("component","v1.Controller.ViewPublic");
		
		cacheData=objView.processRequest(viewParams);
		// create cache entry
		this.put(
			type,
			id,
			cacheData,
			dataType
		);
		
		for(i=1;i<=qryResult.recordCount;i++){
			
			this.bubbleUpdate(
				qryResult.parentType[i],
				qryResult.parentId[i],
				dataType
			)
		}
		
		
		</cfscript>
    </cffunction>    
    
	<!--- - CRUD methods - --->
    <cffunction name="create" access="private" returntype="void">
		<cfargument name="objectType" type="string" required="yes" />
        <cfargument name="objectId" type="numeric" required="yes" />
        <cfargument name="data" type="string" required="yes" />
        <cfargument name="dataType" type="string" required="yes" />
    	<!--- - create a cache record associated with view reqest details - --->
        <cfscript>
		var sqlStatement="";
		var qryViewCache=new Query();
		
		qryViewCache.setName("ViewCacheCreate");
		
		sqlStatement="INSERT INTO ViewCache(
				ViewCache.data ,
				ViewCache.dataType,
				ViewCache.objectId,
				ViewCache.objectType,
				ViewCache.createdDate,
				ViewCache.updatedDate
			)
			VALUES(
				:data ,
				:dataType,
				:objectId,
				:objectType,
				:createdDate,
				:updatedDate
			)
		";
					
        qryViewCache.setSQL(sqlStatement);
		
		qryViewCache.addParam(
			name="data",
			value=arguments.data,
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryViewCache.addParam(
			name="dataType",
			value=arguments.dataType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryViewCache.addParam(
			name="objectId",
			value=arguments.objectId,
			cfsqltype="CF_SQL_INTEGER"
		);
		qryViewCache.addParam(
			name="objectType",
			value=arguments.objectType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryViewCache.addParam(
			name="createdDate",
			value=now(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryViewCache.addParam(
			name="updatedDate",
			value=now(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		
		qryViewCache.execute();
		</cfscript>
	</cffunction>

	<cffunction name="retrieve" access="private" returntype="string">
		<cfargument name="objectType" type="string" required="yes" />
        <cfargument name="objectId" type="numeric" required="yes" />
        <cfargument name="dataType" default="HTML" type="string" required="no" />
    	<!--- - retrieve a cache record based on the view reqest details - --->
        <cfscript>
		var sqlStatement="";
		var qryViewCache=new Query();
		var qryResult={};
		var cacheData="";
		
		qryViewCache.setName("ViewCacheRetrieve");
		
		sqlStatement="SELECT ViewCache.data
			FROM ViewCache
			WHERE ViewCache.dataType=:dataType
				AND ViewCache.objectId=:objectId
				AND ViewCache.objectType=:objectType";
		
        qryViewCache.setSQL(sqlStatement);
		
		qryViewCache.addParam(
			name="dataType",
			value=arguments.dataType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryViewCache.addParam(
			name="objectId",
			value=arguments.objectId,
			cfsqltype="CF_SQL_INTEGER"
		);
		qryViewCache.addParam(
			name="objectType",
			value=arguments.objectType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		
		qryResult=qryViewCache.execute().getResult();
		
		if(qryResult.recordCount==0){
			// no cache entry could be found
			throw(
				type=application.error.cache.noEntryFound.type,
				message=application.error.cache.noEntryFound.message,
				errorcode=application.error.cache.noEntryFound.errorCode
			);
		}
		else if(qryResult.recordCount>1){
			// there is an error in the cache as multiple cache entries were found
			throw(
				type=application.error.cache.multipleEntriesFound.type,
				message=application.error.cache.multipleEntriesFound.message,
				errorcode=application.error.cache.multipleEntriesFound.errorCode
			);
		}
		
		cacheData=qryResult.data[1];
		
		return cacheData;
        </cfscript>
	</cffunction>
    
	<cffunction name="update" access="private" returntype="void">
		<cfargument name="objectType" type="string" required="yes" />
        <cfargument name="objectId" type="numeric" required="yes" />
        <cfargument name="data" type="string" required="yes" />
        <cfargument name="dataType" type="string" required="yes" />
    	<!--- - update a cache record associated with view reqest details - --->
        <cfscript>
		var sqlStatement="";
		var qryViewCache=new Query();
		
		qryViewCache.setName("ViewCacheUpdate");
		
		sqlStatement="UPDATE ViewCache
			SET ViewCache.data=:data,
				ViewCache.dataType=:dataType,
				ViewCache.objectId=:objectId,
				ViewCache.objectType=:objectType,
				ViewCache.updatedDate=:updatedDate
			WHERE ViewCache.dataType=:dataType
				AND ViewCache.objectId=:objectId
				AND ViewCache.objectType=:objectType";
		
		qryViewCache.setSQL(sqlStatement);
		
		qryViewCache.addParam(
			name="data",
			value=arguments.data,
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryViewCache.addParam(
			name="dataType",
			value=arguments.dataType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryViewCache.addParam(
			name="objectId",
			value=arguments.objectId,
			cfsqltype="CF_SQL_INTEGER"
		);
		qryViewCache.addParam(
			name="objectType",
			value=arguments.objectType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryViewCache.addParam(
			name="updatedDate",
			value=now(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		
		qryViewCache.execute();
		</cfscript>
	</cffunction>

	<cffunction name="delete" access="private" returntype="void">
    	<cfargument name="dataType" type="string" required="yes" />
		<cfargument name="objectType" type="string" required="yes" />
    	<cfargument name="objectId" type="numeric" required="yes" />
        <!--- - delete a cache record associated with view reqest details - --->
        <cfscript>
		var qryViewCache=new Query();
		var sqlStatement="";
		
		qryViewCache.setName("ViewCacheDelete");
		
		sqlStatement="DELETE FROM ViewCache 
			WHERE ViewCache.dataType=:dataType
				AND ViewCache.objectId=:objectId
				AND ViewCache.objectType=:objectType";
		
		qryViewCache.setSQL(sqlStatement);
		qryViewCache.addParam(
			name="dataType",
			value=arguments.dataType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryViewCache.addParam(
			name="objectId",
			value=arguments.objectId,
			cfsqltype="CF_SQL_INTEGER"
		);
		qryViewCache.addParam(
			name="objectType",
			value=arguments.objectType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryViewCache.execute();
		</cfscript>
	</cffunction>
</cfcomponent>