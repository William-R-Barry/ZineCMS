<cfcomponent extends="v1.Model.DisplayObject">
	<cfscript>
	variables.objectType="Content";
	variables.arRelatedTo=["ImageGallery"];
	variables.body="";
	variables.quote="";
	variables.writtenBy="";
	variables.writtenDate="";
    </cfscript>
    
    <cffunction name="attachImageGallery" access="public" returntype="void">
		<cfargument name="ImageGallery" type="v1.Model.ImageGallery" required="yes" />
	    
		<cfscript>
		super.attachRelative(arguments.ImageGallery);
		</cfscript>
	</cffunction>
    
    <cffunction name="detachImageGallery" access="public" returntype="void">
		<cfargument name="ImageGallery" type="v1.Model.ImageGallery" required="yes" />
        
		<cfscript>
		super.detachRelative(arguments.ImageGallery);
        </cfscript>
	</cffunction>
    
    <!--- - CRUD methods - --->
    <cffunction name="create" access="public" returntype="string">
    	<cfargument name="user" type="v1.Model.UserLoginAccount" required="yes">
        
    	<cfscript>
		var result={};
		var qryContentCreate=new Query();
		var sqlStatement="INSERT INTO Content(
				Content.title,
				Content.body,
				Content.quote,
				Content.featured,
				Content.published,
				Content.createdDate,
				Content.createdBy,
				Content.updatedDate,
				Content.updatedBy,
				Content.writtenBy,
				Content.writtenDate
			)
			VALUES(
				:title,
				:body,
				:quote,
				:featured,
				:published,
				:createdDate,
				:createdBy,
				:updatedDate,
				:updatedBy,
				:writtenBy,
				:writtenDate
			)";
		
		super.create(arguments.user);
		
		qryContentCreate.setName("ContentCreate");
		qryContentCreate.setSQL(sqlStatement);
		qryContentCreate.addParam(
			name="title",
			value=this.getTitle(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryContentCreate.addParam(
			name="body",
			value=this.getBody(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryContentCreate.addParam(
			name="quote",
			value=this.getQuote(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryContentCreate.addParam(
			name="featured",
			value=this.isFeatured(),
			cfsqltype="CF_SQL_BIT"
		);
		qryContentCreate.addParam(
			name="published",
			value=this.isPublished(),
			cfsqltype="CF_SQL_BIT"
		);
		qryContentCreate.addParam(
			name="createdDate",
			value=this.getCreatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryContentCreate.addParam(
			name="createdBy",
			value=this.getCreatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryContentCreate.addParam(
			name="updatedDate",
			value=this.getUpdatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryContentCreate.addParam(
			name="updatedBy",
			value=this.getUpdatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryContentCreate.addParam(
			name="writtenBy",
			value=this.getWrittenBy(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryContentCreate.addParam(
			name="writtenDate",
			value=this.getWrittenDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		result=qryContentCreate.execute();
		
		this.setId(result.getPrefix().generatedKey);
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieve" access="public" returntype="string">
		<cfscript>
		var qryContentRetrieve=new Query();
		var sqlStatement="";
		var qryResultContent={};
		
		super.retrieve();
		
		sqlStatement="SELECT 
				Content.id,
				Content.title,
				Content.body,
				Content.quote,
				Content.featured,
				Content.published,
				Content.createdDate,
				Content.createdBy,
				Content.updatedDate,
				Content.updatedBy,
				Content.writtenBy,
				Content.writtenDate
			FROM Content
			WHERE Content.id=:id";
		
		qryContentRetrieve.setName("ContentRetrieve");
		qryContentRetrieve.setSQL(sqlStatement);
		qryContentRetrieve.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryResultContent=qryContentRetrieve.execute().getResult();
        
        if(qryResultContent.recordCount==1){
			this.setId(qryResultContent.id);
			this.setTitle(qryResultContent.title);
			this.setBody(qryResultContent.body);
			this.setQuote(qryResultContent.quote);
			this.setFeatured(qryResultContent.featured);
			this.setPublished(qryResultContent.published);
			this.setCreatedDate(qryResultContent.createdDate);
			this.setCreatedBy(qryResultContent.createdBy);
			this.setUpdatedDate(qryResultContent.updatedDate);
			this.setUpdatedBy(qryResultContent.updatedBy);
			this.setWrittenBy(qryResultContent.writtenBy);
			this.setWrittenDate(qryResultContent.writtenDate);
		}
		else {
			throw(
				type=application.error.db.recordNotFound.type,
				message=application.error.db.recordNotFound.message,
				errorcode=application.error.db.recordNotFound.errorCode
			);
		}
		
		super.setDataLoaded(true);
        </cfscript>
    </cffunction>
    
    <cffunction name="update" access="public" returntype="string">
    	<cfargument name="user" type="v1.Model.UserLoginAccount" required="yes">
        
		<cfscript>
		var qryContentUpdate=new Query();
		var sqlStatement="UPDATE Content
			SET Content.title=:title,
				Content.body=:body,
				Content.quote=:quote,
				Content.featured=:featured,
				Content.published=:published,
				Content.createdDate=:createdDate,
				Content.createdBy=:createdBy,
				Content.updatedDate=:updatedDate,
				Content.updatedBy=:updatedBy,
				Content.writtenBy=:writtenBy,
				Content.writtenDate=:writtenDate
			WHERE Content.id=:id";
		
		super.update(arguments.user);
		
		qryContentUpdate.setName("SectionUpdate");
		qryContentUpdate.setSQL(sqlStatement);
		qryContentUpdate.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryContentUpdate.addParam(
			name="title",
			value=this.getTitle(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryContentUpdate.addParam(
			name="body",
			value=this.getBody(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryContentUpdate.addParam(
			name="quote",
			value=this.getQuote(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryContentUpdate.addParam(
			name="featured",
			value=this.isFeatured(),
			cfsqltype="CF_SQL_BIT"
		);
		qryContentUpdate.addParam(
			name="published",
			value=this.isPublished(),
			cfsqltype="CF_SQL_BIT"
		);
		qryContentUpdate.addParam(
			name="createdDate",
			value=this.getCreatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryContentUpdate.addParam(
			name="createdBy",
			value=this.getCreatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryContentUpdate.addParam(
			name="updatedDate",
			value=this.getUpdatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryContentUpdate.addParam(
			name="updatedBy",
			value=this.getUpdatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryContentUpdate.addParam(
			name="writtenBy",
			value=this.getWrittenBy(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryContentUpdate.addParam(
			name="writtenDate",
			value=this.getWrittenDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryContentUpdate.execute();
		</cfscript>
    </cffunction>
    
    <cffunction name="delete" access="public" returntype="string">
		<cfscript>
		var qryContentDelete=new Query();
		var sqlStatement="DELETE FROM Content WHERE Content.id=:id";
		
		super.delete();
		
		qryContentDelete.setName("ContentDelete");
		qryContentDelete.setSQL(sqlStatement);
		qryContentDelete.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryContentDelete.execute();
		</cfscript>
    </cffunction>

    <cffunction name="setBody" access="public" returntype="void">
		<cfargument name="body" type="string" required="yes">
	
    	<cfscript>
		variables.body=arguments.body;
		</cfscript>
    </cffunction>

    <cffunction name="getBody" access="public" returntype="string">
		<cfscript>
		return variables.body;
		</cfscript>
    </cffunction>
    
    <cffunction name="setQuote" access="public" returntype="void">
		<cfargument name="quote" type="string" required="yes">
	
    	<cfscript>
		variables.quote=arguments.quote;
		</cfscript>
    </cffunction>

    <cffunction name="getQuote" access="public" returntype="string">
		<cfscript>
		return variables.quote;
		</cfscript>
    </cffunction>
    
    <cffunction name="setWrittenBy" access="public" returntype="void">
		<cfargument name="writtenBy" type="string" required="yes">
	
    	<cfscript>
		variables.writtenBy=arguments.writtenBy;
		</cfscript>
    </cffunction>

    <cffunction name="getWrittenBy" access="public" returntype="string">
		<cfscript>
		return variables.writtenBy;
		</cfscript>
    </cffunction>
    
    <cffunction name="setWrittenDate" access="public" returntype="void">
		<cfargument name="writtenDate" type="string" required="yes">
	
    	<cfscript>
		var dateParts=[];
		
		if(!isDate(arguments.writtenDate)){
			// attempt to parse date string
			arguments.writtenDate=replace(arguments.writtenDate,".","-");
			arguments.writtenDate=replace(arguments.writtenDate,"/","-");
			
			dateParts=listToArray(arguments.writtenDate,"-");
			
			arguments.writtenDate=createDate(val(dateParts[1]),val(dateParts[2]),val(dateParts[3]));
		}
		
		variables.writtenDate=arguments.writtenDate;
		</cfscript>
    </cffunction>

    <cffunction name="getWrittenDate" access="public" returntype="string">
		<cfscript>
		var writtenDate=dateFormat(variables.writtenDate,"yyyy-mm-dd");
		
		return writtenDate;
		</cfscript>
    </cffunction>
</cfcomponent>