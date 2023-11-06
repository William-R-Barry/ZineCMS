<cfcomponent>
	<cfscript>
	variables.mapDepth=0; // determine the relationship mapping depth (0=unlimited)
	</cfscript>
    
    <cffunction name="retrieveRelationshipMap" access="private" returntype="array">
    	<cfargument name="parentObjectType" default="Section" type="any" required="no" />
        <cfargument name="parentObjectId" default="0" type="string" required="no" />
        <cfargument name="arExcludeType" type="array" required="no" />
		<!--- - recursive function that creates a map based on model objects - --->
		<cfscript>
		var arExcludeType=(isDefined("arguments.arExcludeType")) ? arguments.arExcludeType : [];
		var parentType=arguments.parentObjectType;
		var parentId=arguments.parentObjectId;
		var arParentMap=[];
		
		var object={};
		var arChildType=[];
		var arChildObject=[];
		var arNavigationData=[];
		var stNavItem={};
		
		var i=0;
		var j=0;
		var k=0;
		
		arParentMap=this.retrieveArMapParent(parentType,parentId,false);
		
		for(i=1;i<=arrayLen(arParentMap);i++){
			// *** add parent ***
			object=createObject("component","v1.Model." & parentType);
			object.setId(arParentMap[i].id);
			object.retrieve();
			
			// clear struct before adding values
			stNavItem={};
			
			stNavItem.id=object.getId();
			stNavItem.objectType=object.getObjectType();
			stNavItem.title=object.getTitle();
			
			if(arrayContains(arExcludeType,parentObjectType)==0){
				arrayAppend(arNavigationData,stNavItem);
			}
			
			// *** add children ***
			arChildType=object.getRelatedTo();
			//arrayDelete(arChildType,parentType); // avoid reflective object relationships
		
			for(j=1;j<=arrayLen(arChildType);j++){
					arChildObject=object.retrieveRelativesByType(arChildType[j]);
						
					for(k=1;k<=arrayLen(arChildObject);k++){
						if(!isDefined("stNavItem.arSubNavItem")) stNavItem.arSubNavItem=[];
						
						arNavigationDataChild=this.retrieveRelationshipMap(
							arChildObject[k].getObjectType(),
							arChildObject[k].getId(),
							arExcludeType
						)
						
						if(arrayLen(arNavigationDataChild)>0){
							// when retrieving a relationship map and an id is specified, the map 
							// returned will be encapsulated in a single element array representing
							// the specified parent.
							arrayAppend(stNavItem.arSubNavItem,arNavigationDataChild[1]);
						}
					}
			}
		}
		
		return arNavigationData;
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieveArMapParent" access="private" returntype="array">
    	<cfargument name="objectType" default="Section" type="string" required="no" />
        <cfargument name="objectId" default="0" type="numeric" required="no" />
        <cfargument name="includeOnlyPublished" default="true" type="boolean" required="no" />
        <!--- - function that creates a parent level map based on object type and id - --->
		<cfscript>
		var arMapData=[];
		
		var sqlStatement="";
		var qryRelationshipMap={};
		var qryParentResult={};
		
		var parentType=arguments.objectType;
		var parentId=arguments.objectId;
		
		var i=0;
		
		// retrieve parent record(s)
		sqlStatement="SELECT " & parentType & ".id,"
			& " " & parentType & ".title"
			& " FROM " & parentType
			& " WHERE ";
		if(parentId==0){
			sqlStatement=sqlStatement & parentType & ".id NOT IN("
				& " SELECT ObjectRelationship.childId"
				& " FROM ObjectRelationship"
				& " WHERE ObjectRelationship.parentType=:parentType"
				& " AND ObjectRelationship.childId=" & parentType & ".id"
				& " AND ObjectRelationship.childType=:parentType"
			& ")";
		}
		else{
			sqlStatement=sqlStatement & " " & parentType & ".id=:parentId";
		}
		if(arguments.includeOnlyPublished){
			 sqlStatement=sqlStatement & " AND " & parentType & ".published=true";
		}
		sqlStatement=sqlStatement & " ORDER BY " & parentType & ".id";
		
		qryRelationshipMap=new Query();
		
		qryRelationshipMap.setName("retrieveRelationshipMap");
		qryRelationshipMap.setSQL(sqlStatement);
		qryRelationshipMap.addParam(
			name="parentId",
			value=parentId,
			cfsqltype="CF_SQL_INTEGER"
		);
		qryRelationshipMap.addParam(
			name="parentType",
			value=parentType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		
		qryParentResult=qryRelationshipMap.execute().getResult();
		
		for(i=1;i<=qryParentResult.recordCount;i++){
			// clear struct before adding values
			stNavItem={};
			// add parent record
			stNavItem.id=qryParentResult.id[i];
			stNavItem.objectType=parentType;
			stNavItem.title=qryParentResult.title[i];
			
			arrayAppend(arMapData,stNavItem);
		}
		
		return arMapData;
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieveArMapChild" access="private" returntype="array">
    	<cfargument name="parentObjectType" type="string" required="yes" />
        <cfargument name="parentObjectId" type="numeric" required="yes" />
        <cfargument name="childObjectType" type="string" required="yes" />
        <cfargument name="orderBy" default="createdDate" type="string" required="no" />
        <cfargument name="orderDirection" default="ASC" type="string" required="no" />
        <cfargument name="includeOnlyPublished" default="true" type="boolean" required="no" />
        <!--- - function that creates a child level map based on parent object type,
				parent object id and child object type - --->
		<cfscript>
		var arMapData=[];
		
		var sqlStatement="";
		var qryRelationshipMap={};
		var qryChildResult={};
		
		var parentType=arguments.parentObjectType;
		var parentId=arguments.parentObjectId;
		var childType=arguments.childObjectType;
		
		var i=0;
		// retrieve relationship types
		sqlStatement="SELECT " & childType & ".id,"
			& childType & ".title"
			& " FROM " & childType
			& " WHERE " & childType & ".id"
			& " IN ("
				& "SELECT ObjectRelationship.childId"
				& " FROM ObjectRelationship"
				& " WHERE ObjectRelationship.parentId=:parentId"
				& " AND ObjectRelationship.parentType=:parentType"
				& " AND ObjectRelationship.childType=:childType"
			& ")";
		
		if(arguments.includeOnlyPublished){
			 sqlStatement=sqlStatement & " AND " & childType & ".published=true";
		}
		
		sqlStatement=sqlStatement & " ORDER BY " & arguments.orderBy & " " & arguments.orderDirection;
		
		qryRelationshipMap=new Query();
		
		qryRelationshipMap.setName("retrieveRelationshipType");
		qryRelationshipMap.setSQL(sqlStatement);
		qryRelationshipMap.addParam(
			name="parentId",
			value=parentId,
			cfsqltype="CF_SQL_INTEGER"
		);
		qryRelationshipMap.addParam(
			name="parentType",
			value=parentType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryRelationshipMap.addParam(
			name="childType",
			value=childType,
			cfsqltype="CF_SQL_VARCHAR"
		);
		
		qryChildResult=qryRelationshipMap.execute().getResult();
		
		for(i=1;i<=qryChildResult.recordCount;i++){
			// clear struct before adding values
			stNavItem={};
			// add parent record
			stNavItem.id=qryChildResult.id[i];
			stNavItem.objectType=childType;
			stNavItem.title=qryChildResult.title[i];
			
			arrayAppend(arMapData,stNavItem);
		}
		
		return arMapData;
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieveDefaultRelatedObjectType" access="private" returntype="string">
    	<cfargument name="objectType" type="string" required="yes" />
    	<!--- - retrieve the default related object type based on the specified parent object type- --->
        <cfscript>
		var relatedObjectType="";
		
		switch(uCase(arguments.objectType)){
			case "Section": relatedObjectType="Section";
			 break;
			case "Content": relatedObjectType="ImageGallery";
			 break;
			case "ImageGallery": relatedObjectType="Image";
			 break;
		}
		
		return relatedObjectType;
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieveDefaultObjectId" access="private" returntype="numeric">
    	<cfargument name="objectType" type="string" required="yes" />
        <!--- - retrieve an object record ID based on the specified type- --->
		<cfscript>
        var objectId=0;
		var sqlSelect="";
		var sqlWhere="";
		var sqlOrderBy="";
		var sqlStatement="";
		var qryObject={};
		var qryResult={};
		
		sqlSelect="SELECT " & objectType & ".id FROM " & objectType;
		sqlWhere=" WHERE " & objectType & ".published=true";
		sqlOrderBy=" ORDER BY " & objectType & ".featured DESC, " & objectType & ".id";
		
		qryObject=new Query();
		sqlStatement=sqlSelect & sqlWhere & sqlOrderBy;
		
		qryObject.setName("retrieveDefaultObjectId");
		qryObject.setSQL(sqlStatement);
		
		qryResult=qryObject.execute().getResult();
        
        if(qryResult.recordCount==0){
			
			// no records found, try again without looking for featured objects
			qryObject=new Query();
			sqlStatement=sqlSelect & sqlOrderBy;
			
			qryObject.setName("retrieveDefaultObjectId");
			qryObject.setSQL(sqlStatement);
			
			qryResult=qryObject.execute().getResult();
		}
		
		if(qryResult.recordCount>=1){
			objectId=qryResult.id[1];
		}
		
		return objectId;
        </cfscript>
    </cffunction>
    
    <cffunction name="retrieveTopLevelParent" access="public" returntype="any">
    	<cfargument name="objectType" type="string" required="yes" />
        <cfargument name="objectId" type="numeric" required="yes" />
        <!--- - recursive function that determines the top level object based on the 
				child object record type and id - --->
		<!--- - NOTE: this function does not take into acount an object's published flag - --->
        <cfscript>
		var parentObject={};
		
		var type=arguments.objectType;
		var id=arguments.objectId;
		
    	var sqlStatement="";
		var qryObject={};
		var qryResult={};
		
		qryObject=new Query();
		qryObject.setName("retrieveParentRecord");
		
		sqlStatement="SELECT ObjectRelationship.parentId,"
			& " ObjectRelationship.parentType"
			& " FROM ObjectRelationship"
			& " WHERE ObjectRelationship.childId=:objectId"
			& " AND ObjectRelationship.childType=:objectType";
		
		qryObject.setSQL(sqlStatement);
		
		qryObject.addParam(
			name="objectId",
			value=id,
			cfsqltype="CF_SQL_INTEGER"
		);
		qryObject.addParam(
			name="objectType",
			value=type,
			cfsqltype="CF_SQL_VARCHAR"
		);
		
		qryResult=qryObject.execute().getResult();
		
		if(qryResult.recordCount==1){
			parentObject=this.retrieveTopLevelParent(
				qryResult.parentType[1],
				qryResult.parentId[1]
			)
		}
		else{
			parentObject=createObject("component","v1.model." & type);
			
			parentObject.setId(id);
			parentObject.retrieve();
		}
		
		return parentObject;
		</cfscript>
    </cffunction>
</cfcomponent>