<cfcomponent extends="v1.Model.DisplayObject">
	<cfscript>
	variables.objectType="Image";
	variables.arRelatedTo=["Image"];
	variables.fileName="";
	variables.filePath="";
	variables.width=0;
	variables.height=0;
    </cfscript>

	<cffunction name="attachThumb" access="public" returntype="void">
		<cfargument name="Image" type="v1.Model.Image" required="yes" />
	    
		<cfscript>
		super.clearRelativesByType("Image");
		
		super.attachRelative(arguments.Image);
		</cfscript>
	</cffunction>
    
    <cffunction name="retrieveThumb" access="public" returntype="v1.Model.Image">
		<cfscript>
		var arImage=super.retrieveRelativesByType("Image");
		var ImageThumb={};
		
		if(arrayLen(arImage)!=1){
			// an Image should have a single thumb nail
			throw(
				type=application.error.object.singleChildNotfound.type,
				message=application.error.object.singleChildNotfound.message,
				errorcode=application.error.object.singleChildNotfound.errorCode
			);
		}
		
		ImageThumb=arImage[1];
		
		return ImageThumb;
		</cfscript>
	</cffunction>
    
    <cffunction name="retrieveScaledDimensions" access="public" returntype="struct">
    	<cfargument name="maxDimension" type="numeric" required="yes" />
        
        <cfscript>
		var stScaledDimensions={};
		var divider=0;
		var width=this.getWidth();
		var height=this.getHeight();
		
		if(arguments.maxDimension>0 && (width>arguments.maxDimension || height>arguments.maxDimension)){
			if(width>=height){
				divider=width/arguments.maxDimension;
			}
			else{
				divider=height/arguments.maxDimension;
			}
			
			width=int(width/divider);
			height=int(height/divider);
		}
		
		stScaledDimensions.width=width;
		stScaledDimensions.height=height;
		
		return stScaledDimensions;
		</cfscript>
    </cffunction>
    
    <!--- - CRUD methods - --->
    <cffunction name="create" access="public" returntype="string">
    	<cfargument name="user" type="v1.Model.UserLoginAccount" required="yes" />
        
    	<cfscript>
		var result={};
		var qryImageRetrieve=new Query();
		var sqlStatement="INSERT INTO Image(
				Image.title,
				Image.fileName,
				Image.filePath,
				Image.width,
				Image.height,
				Image.published,
				Image.featured,
				Image.createdDate,
				Image.createdBy,
				Image.updatedDate,
				Image.updatedBy
			)
			VALUES(
				:title,
				:fileName,
				:filePath,
				:width,
				:height,
				:published,
				:featured,
				:createdDate,
				:createdBy,
				:updatedDate,
				:updatedBy
			)";
		
		super.create(arguments.user);
		
		qryImageRetrieve.setName("ImageCreate");
		qryImageRetrieve.setSQL(sqlStatement);
		qryImageRetrieve.addParam(
			name="title",
			value=this.getTitle(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryImageRetrieve.addParam(
			name="fileName",
			value=this.getFileName(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryImageRetrieve.addParam(
			name="filePath",
			value=this.getFilePath(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryImageRetrieve.addParam(
			name="width",
			value=this.getWidth(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryImageRetrieve.addParam(
			name="height",
			value=this.getHeight(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryImageRetrieve.addParam(
			name="published",
			value=this.isPublished(),
			cfsqltype="CF_SQL_BIT"
		);
		qryImageRetrieve.addParam(
			name="featured",
			value=this.isFeatured(),
			cfsqltype="CF_SQL_BIT"
		);
		qryImageRetrieve.addParam(
			name="createdDate",
			value=this.getCreatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryImageRetrieve.addParam(
			name="createdBy",
			value=this.getCreatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryImageRetrieve.addParam(
			name="updatedDate",
			value=this.getUpdatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryImageRetrieve.addParam(
			name="updatedBy",
			value=this.getUpdatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		result=qryImageRetrieve.execute();
		
		this.setId(result.getPrefix().generatedKey);
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieve" access="public" returntype="string">
		<cfscript>
		var qryImageRetrieve=new Query();
		var sqlStatement="";
		var qryResultImage={};
		
		super.retrieve();
		
		sqlStatement="SELECT 
				Image.id,
				Image.title,
				Image.fileName,
				Image.filePath,
				Image.width,
				Image.height,
				Image.published,
				Image.featured,
				Image.createdDate,
				Image.createdBy,
				Image.updatedDate,
				Image.updatedBy
			FROM Image
			WHERE Image.id=:id";
		
		qryImageRetrieve.setName("ContentRetrieve");
		qryImageRetrieve.setSQL(sqlStatement);
		qryImageRetrieve.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryResultImage=qryImageRetrieve.execute().getResult();
        
        if(qryResultImage.recordCount==1){
			this.setId(qryResultImage.id);
			this.setTitle(qryResultImage.title);
			this.setFileName(qryResultImage.fileName);
			this.setFilePath(qryResultImage.filePath);
			this.setWidth(qryResultImage.width);
			this.setHeight(qryResultImage.height);
			this.setPublished(qryResultImage.published);
			this.setFeatured(qryResultImage.featured);
			this.setCreatedDate(qryResultImage.createdDate);
			this.setCreatedBy(qryResultImage.createdBy);
			this.setUpdatedDate(qryResultImage.updatedDate);
			this.setUpdatedBy(qryResultImage.updatedBy);
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
		var qryImageRetrieve=new Query();
		var sqlStatement="UPDATE Image
			SET Image.title=:title,
				Image.fileName=:fileName,
				Image.filePath=:filePath,
				Image.width=:width,
				Image.height=:height,
				Image.published=:published,
				Image.featured=:featured,
				Image.createdDate=:createdDate,
				Image.createdBy=:createdBy,
				Image.updatedDate=:updatedDate,
				Image.updatedBy=:updatedBy
			WHERE Image.id=:id";
		
		super.update(arguments.user);
		
		qryImageRetrieve.setName("SectionUpdate");
		qryImageRetrieve.setSQL(sqlStatement);
		qryImageRetrieve.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryImageRetrieve.addParam(
			name="title",
			value=this.getTitle(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryImageRetrieve.addParam(
			name="fileName",
			value=this.getFileName(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryImageRetrieve.addParam(
			name="filePath",
			value=this.getFilePath(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryImageRetrieve.addParam(
			name="width",
			value=this.getWidth(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryImageRetrieve.addParam(
			name="height",
			value=this.getHeight(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryImageRetrieve.addParam(
			name="published",
			value=this.isPublished(),
			cfsqltype="CF_SQL_BIT"
		);
		qryImageRetrieve.addParam(
			name="featured",
			value=this.isFeatured(),
			cfsqltype="CF_SQL_BIT"
		);
		qryImageRetrieve.addParam(
			name="createdDate",
			value=this.getCreatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryImageRetrieve.addParam(
			name="createdBy",
			value=this.getCreatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryImageRetrieve.addParam(
			name="updatedDate",
			value=this.getUpdatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryImageRetrieve.addParam(
			name="updatedBy",
			value=this.getUpdatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryImageRetrieve.execute();
		</cfscript>
    </cffunction>
    
    <cffunction name="delete" access="public" returntype="string">
		<cfscript>
		var qryImageRetrieve=new Query();
		var sqlStatement="DELETE FROM Image WHERE Image.id=:id";
		
		super.delete();
		
		qryImageRetrieve.setName("ContentDelete");
		qryImageRetrieve.setSQL(sqlStatement);
		qryImageRetrieve.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryImageRetrieve.execute();
		</cfscript>
    </cffunction>

    <cffunction name="setFileName" access="public" returntype="void">
		<cfargument name="fileName" type="string" required="yes">
	
    	<cfscript>
		variables.fileName=arguments.fileName;
		</cfscript>
    </cffunction>

    <cffunction name="getFileName" access="public" returntype="string">
		<cfscript>
		return variables.fileName;
		</cfscript>
    </cffunction>
    
    <cffunction name="setFilePath" access="public" returntype="void">
		<cfargument name="filePath" type="string" required="yes">
	
    	<cfscript>
		variables.filePath=arguments.filePath;
		</cfscript>
    </cffunction>

    <cffunction name="getFilePath" access="public" returntype="string">
		<cfscript>
		return variables.filePath;
		</cfscript>
    </cffunction>
    
    <cffunction name="setWidth" access="public" returntype="void">
		<cfargument name="width" type="numeric" required="yes">
	
    	<cfscript>
		variables.width=arguments.width;
		</cfscript>
    </cffunction>

    <cffunction name="getWidth" access="public" returntype="numeric">
		<cfscript>
		return variables.width;
		</cfscript>
    </cffunction>
    
    <cffunction name="setHeight" access="public" returntype="void">
		<cfargument name="height" type="numeric" required="yes">
	
    	<cfscript>
		variables.height=arguments.height;
		</cfscript>
    </cffunction>

    <cffunction name="getHeight" access="public" returntype="numeric">
		<cfscript>
		return variables.height;
		</cfscript>
    </cffunction>
</cfcomponent>