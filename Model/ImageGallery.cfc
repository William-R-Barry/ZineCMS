<cfcomponent extends="v1.Model.DisplayObject">
	<cfscript>
	variables.objectType="ImageGallery";
	variables.arRelatedTo=["Image"];
	</cfscript>
	
    <cffunction name="attachImage" access="public" returntype="void">
		<cfargument name="Image" type="v1.Model.Image" required="yes" />
	    
		<cfscript>
		super.attachRelative(arguments.Image);
		</cfscript>
	</cffunction>
    
    <cffunction name="detachImage" access="public" returntype="void">
		<cfargument name="Image" type="v1.Model.Image" required="yes" />
        
		<cfscript>
		super.detachRelative(arguments.Image);
        </cfscript>
	</cffunction>
    
    <!--- - CRUD methods - --->
    <cffunction name="create" access="public" returntype="string">
    	<cfargument name="user" type="v1.Model.UserLoginAccount" required="yes">
        
    	<cfscript>
		var result={};
		var qryImageGalleryCreate=new Query();
		var sqlStatement="INSERT INTO ImageGallery(
				ImageGallery.title,
				ImageGallery.published,
				ImageGallery.featured,
				ImageGallery.createdBy,
				ImageGallery.createdDate,
				ImageGallery.updatedBy,
				ImageGallery.updatedDate
			)
			VALUES(
				:title,
				:published,
				:featured,
				:createdBy,
				:createdDate,
				:updatedBy,
				:updatedDate
			)";
		
		super.create(arguments.user);
		
		qryImageGalleryCreate.setName("ImageGalleryCreate");
		qryImageGalleryCreate.setSQL(sqlStatement);
		qryImageGalleryCreate.addParam(
			name="title",
			value=this.getTitle(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryImageGalleryCreate.addParam(
			name="published",
			value=this.isPublished(),
			cfsqltype="CF_SQL_BIT"
		);
		qryImageGalleryCreate.addParam(
			name="featured",
			value=this.isFeatured(),
			cfsqltype="CF_SQL_BIT"
		);
		qryImageGalleryCreate.addParam(
			name="createdBy",
			value=arguments.user.getId(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryImageGalleryCreate.addParam(
			name="createdDate",
			value=this.getCreatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryImageGalleryCreate.addParam(
			name="updatedBy",
			value=arguments.user.getId(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryImageGalleryCreate.addParam(
			name="updatedDate",
			value=this.getUpdatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		result=qryImageGalleryCreate.execute();
		
		this.setId(result.getPrefix().generatedKey);
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieve" access="public" returntype="string">
		<cfscript>
		var qryImageGalleryRetrieve=new Query();
		var sqlStatement="";
		var qryResultImageGallery={};
		
		super.retrieve();
		
		sqlStatement="SELECT 
				ImageGallery.id,
				ImageGallery.title,
				ImageGallery.published,
				ImageGallery.featured,
				ImageGallery.createdBy,
				ImageGallery.createdDate,
				ImageGallery.updatedBy,
				ImageGallery.updatedDate
			FROM ImageGallery
			WHERE ImageGallery.id=:id";
		
		qryImageGalleryRetrieve.setName("ImageGalleryRetrieve");
		qryImageGalleryRetrieve.setSQL(sqlStatement);
		qryImageGalleryRetrieve.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryResultImageGallery=qryImageGalleryRetrieve.execute().getResult();
        
        if(qryResultImageGallery.recordCount==1){
			this.setId(qryResultImageGallery.id);
			this.setTitle(qryResultImageGallery.title);
			this.setPublished(qryResultImageGallery.published);
			this.setFeatured(qryResultImageGallery.featured);
			this.setCreatedBy(qryResultImageGallery.createdBy);
			this.setCreatedDate(qryResultImageGallery.createdDate);
			this.setUpdatedBy(qryResultImageGallery.updatedBy);
			this.setUpdatedDate(qryResultImageGallery.updatedDate);
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
		var qryImageGalleryUpdate=new Query();
		var sqlStatement="UPDATE ImageGallery
			SET ImageGallery.title=:title,
				ImageGallery.published=:published,
				ImageGallery.featured=:featured,
				ImageGallery.createdBy=:createdBy,
				ImageGallery.createdDate=:createdDate,
				ImageGallery.updatedBy=:updatedBy,
				ImageGallery.updatedDate=:updatedDate
			WHERE ImageGallery.id=:id";
		
		super.update(arguments.user);
		
		qryImageGalleryUpdate.setName("ImageGalleryUpdate");
		qryImageGalleryUpdate.setSQL(sqlStatement);
		qryImageGalleryUpdate.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryImageGalleryUpdate.addParam(
			name="title",
			value=this.getTitle(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryImageGalleryUpdate.addParam(
			name="published",
			value=this.isPublished(),
			cfsqltype="CF_SQL_BIT"
		);
		qryImageGalleryUpdate.addParam(
			name="featured",
			value=this.isFeatured(),
			cfsqltype="CF_SQL_BIT"
		);
		qryImageGalleryUpdate.addParam(
			name="createdBy",
			value=arguments.user.getId(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryImageGalleryUpdate.addParam(
			name="createdDate",
			value=this.getCreatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryImageGalleryUpdate.addParam(
			name="updatedBy",
			value=arguments.user.getId(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryImageGalleryUpdate.addParam(
			name="updatedDate",
			value=this.getUpdatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryImageGalleryUpdate.execute();
		</cfscript>
    </cffunction>
    
    <cffunction name="delete" access="public" returntype="string">
		<cfscript>
		var qryImageGalleryDelete=new Query();
		var sqlStatement="DELETE FROM ImageGallery WHERE ImageGallery.id=:id";
		
		super.delete();
		
		qryImageGalleryDelete.setName("ImageGalleryDelete");
		qryImageGalleryDelete.setSQL(sqlStatement);
		qryImageGalleryDelete.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryImageGalleryDelete.execute();
		</cfscript>
    </cffunction>
</cfcomponent>