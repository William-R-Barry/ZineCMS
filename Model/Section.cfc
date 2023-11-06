<cfcomponent extends="v1.Model.DisplayObject">
	<cfscript>
	variables.objectType="Section";
	variables.arRelatedTo=["Section","Image","Content"];
    </cfscript>
	
    <cffunction name="attachSubSection" access="public" returntype="void">
		<cfargument name="Section" type="v1.Model.Section" required="yes" />
	    
		<cfscript>
		if(this.isSubSection()){
			throw(
				application.error.object.invalidRelationship.type,
				application.error.object.invalidRelationship.message,
				application.error.object.invalidRelationship.errorCode
			);
		}
		
		super.attachRelative(arguments.Section);
		</cfscript>
	</cffunction>
    
    <cffunction name="retrieveSubSectionArray" access="public" returntype="array">
		<cfscript>
		var arSection=super.retrieveRelativesByType("Section");
		
		return arSection;
		</cfscript>
	</cffunction>
    
    <cffunction name="isSubSection" access="public" returntype="void">
		<cfscript>
		var isSubSection=false;
		
		var qryRetrieveRelationship=new Query();
		var qryResultRelationship={};
		var sqlStatement="SELECT 
				ObjectRelationship.id
			FROM ObjectRelationship
			WHERE
				ObjectRelationship.parentType=:type
				AND ObjectRelationship.childType=:type
				AND ObjectRelationship.childId=:id";
			
		qryRetrieveRelationship.setName("retrieveSectionRelationship");
		qryRetrieveRelationship.setSQL(sqlStatement);
		qryRetrieveRelationship.addParam(
			name="type",
			value=this.getObjectType(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryRetrieveRelationship.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		
		qryResultRelationship=qryRetrieveRelationship.execute().getResult();
		
		isSubSection=(qryResultRelationship.recordCount>0);
		
		return isSubSection;
		</cfscript>
	</cffunction>
    
	<cffunction name="retrieveContentArray" access="public" returntype="array">
		<cfscript>
	    var arContent=[];
		
		arContent=super.retrieveRelativesByType("Content");
		
        return arContent;
        </cfscript>
	</cffunction>
    
    <cffunction name="retrieveAllRelatedContent" access="private" returntype="array">
    	<!--- - recursive function that creates a map based on model objects - --->
		<cfscript>
		var arSection=[];
		var relatedSections=0;
		var objSection={};
		var arRelatedContent=[];
		var arContent=[];
		var objContent={};
		var arSortedContentItem=[];
		var numberOfSortedContentItem=0;
		var insertDone=false;
		var numberContentItems=0;
		var i=0;
		var j=0;
		
		// *** retrieve content related to the first subsection of this section ***
		arSection=super.retrieveRelativesByType("Section");
        
		relatedSections=arrayLen(arSection);
		
		for(i=1;i<=relatedSections;i++){
			objSection=arSection[i];
			objSection.retrieve();
			
			arRelatedContent=objSection.retrieveRelativesByType("Content");
			arContent=arrayMerge(arContent,arRelatedContent)
		}
		
		// *** sort content items by date written ***
		numberContentItems=arrayLen(arContent);
		
		for(i=1;i<=numberContentItems;i++){
			objContent=arContent[i];
			
			numberOfSortedContentItem=arrayLen(arSortedContentItem);
			
			for(j=1;j<=numberOfSortedContentItem;j++){
				if(this.sortCriteriaMatched(
					objContent,
					arSortedContentItem[j],
					"DATEWRITTEN",
					"DESC"
				)){
					arrayInsertAt(arSortedContentItem,j,objContent);
					insertDone=true;
					break;
				}
			}
			
			if(!insertDone){
				arrayAppend(arSortedContentItem,objContent);
			}
			
			insertDone=false; // reset insert flag
		}
		
		return arSortedContentItem;
        </cfscript>
    </cffunction>
    
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
    
	<cffunction name="attachContent" access="public" returntype="void">
		<cfargument name="Content" type="v1.Model.Content" required="yes" />
	    
		<cfscript>
		super.attachRelative(arguments.Content);
		</cfscript>
	</cffunction>
    
    <cffunction name="detachContent" access="public" returntype="void">
		<cfargument name="Content" type="v1.Model.Content" required="yes" />
        
		<cfscript>
		super.detachRelative(arguments.Content);
        </cfscript>
	</cffunction>
    
    <!--- - CRUD methods - --->
    <cffunction name="create" access="public" returntype="string">
    	<cfargument name="user" type="v1.Model.UserLoginAccount" required="yes">
        
    	<cfscript>
		var result={};
		var qrySectionRetrieve=new Query();
		var sqlStatement="INSERT INTO Section(
				Section.title,
				Section.featured,
				Section.published,
				Section.createdDate,
				Section.createdBy,
				Section.updatedDate,
				Section.updatedBy
			)
			VALUES(
				:title,
				:featured,
				:published,
				:createdDate,
				:createdBy,
				:updatedDate,
				:updatedBy
			)";
		
		super.create(arguments.user);
		
		qrySectionRetrieve.setName("SectionCreate");
		qrySectionRetrieve.setSQL(sqlStatement);
		qrySectionRetrieve.addParam(
			name="title",
			value=this.getTitle(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qrySectionRetrieve.addParam(
			name="featured",
			value=this.isFeatured(),
			cfsqltype="CF_SQL_BIT"
		);
		qrySectionRetrieve.addParam(
			name="published",
			value=this.isPublished(),
			cfsqltype="CF_SQL_BIT"
		);
		qrySectionRetrieve.addParam(
			name="createdDate",
			value=this.getCreatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qrySectionRetrieve.addParam(
			name="createdBy",
			value=this.getCreatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qrySectionRetrieve.addParam(
			name="updatedDate",
			value=this.getUpdatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qrySectionRetrieve.addParam(
			name="updatedBy",
			value=this.getUpdatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		result=qrySectionRetrieve.execute();
		
		this.setId(result.getPrefix().generatedKey);
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieve" access="public" returntype="string">
		<cfscript>
		var qrySectionRetrieve=new Query();
		var sqlStatement="";
		var qryResultSection={};
		
		super.retrieve();
		
		sqlStatement="SELECT 
				Section.id,
				Section.title,
				Section.featured,
				Section.published,
				Section.createdDate,
				Section.createdBy,
				Section.updatedDate,
				Section.updatedBy
			FROM Section
			WHERE Section.id=:id";
		
		qrySectionRetrieve.setName("SectionRetrieve");
		qrySectionRetrieve.setSQL(sqlStatement);
		qrySectionRetrieve.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryResultSection=qrySectionRetrieve.execute().getResult();
        
        if(qryResultSection.recordCount==1){
			this.setId(qryResultSection.id);
			this.setTitle(qryResultSection.title);
			this.setFeatured(qryResultSection.featured);
			this.setPublished(qryResultSection.published);
			this.setCreatedDate(qryResultSection.createdDate);
			this.setCreatedBy(qryResultSection.createdBy);
			this.setUpdatedDate(qryResultSection.updatedDate);
			this.setUpdatedBy(qryResultSection.updatedBy);
		}
		else {
			throw(
				type=application.error.db.recordNotFound.type,
				message=application.error.db.recordNotFound.message,
				errorcode=application.error.db.recordNotFound.errorcode
			);
		}
		
		super.setDataLoaded(true);
        	
		if(!super.hasParent() && hasRelativesOfType("Section")){	
			maxLatestContentItems=5;
			
			arRelatedContent=this.retrieveAllRelatedContent();
			
			numberOfContentItems=arrayLen(arRelatedContent);
			
			if(numberOfContentItems>maxLatestContentItems){
				numberOfContentItems=maxLatestContentItems
			}
			
			for(i=1;i<=numberOfContentItems;i++){
				super.attachRelative(arRelatedContent[i]);
			}
		}
        </cfscript>
    </cffunction>
    
    <cffunction name="update" access="public" returntype="string">
    	<cfargument name="user" type="v1.Model.UserLoginAccount" required="yes">
        
		<cfscript>
		var qrySectionRetrieve=new Query();
		var sqlStatement="UPDATE Section
			SET Section.title=:title,
				Section.featured=:featured,
				Section.published=:published,
				Section.createdDate=:createdDate,
				Section.createdBy=:createdBy,
				Section.updatedDate=:updatedDate,
				Section.updatedBy=:updatedBy
			WHERE Section.id=:id";
		
		super.update(arguments.user);
		
		qrySectionRetrieve.setName("SectionUpdate");
		qrySectionRetrieve.setSQL(sqlStatement);
		qrySectionRetrieve.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qrySectionRetrieve.addParam(
			name="title",
			value=this.getTitle(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qrySectionRetrieve.addParam(
			name="featured",
			value=this.isFeatured(),
			cfsqltype="CF_SQL_BIT"
		);
		qrySectionRetrieve.addParam(
			name="published",
			value=this.isPublished(),
			cfsqltype="CF_SQL_BIT"
		);
		qrySectionRetrieve.addParam(
			name="createdDate",
			value=this.getCreatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qrySectionRetrieve.addParam(
			name="createdBy",
			value=this.getCreatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qrySectionRetrieve.addParam(
			name="updatedDate",
			value=this.getUpdatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qrySectionRetrieve.addParam(
			name="updatedBy",
			value=this.getUpdatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qrySectionRetrieve.execute();
		</cfscript>
    </cffunction>
    
    <cffunction name="delete" access="public" returntype="string">
		<cfscript>
		var qrySectionRetrieve=new Query();
		var sqlStatement="DELETE FROM Section WHERE Section.id=:id";
		
		super.delete();
		
		qrySectionRetrieve.setName("SectionDelete");
		qrySectionRetrieve.setSQL(sqlStatement);
		qrySectionRetrieve.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qrySectionRetrieve.execute();
		</cfscript>
    </cffunction>

	<!--- - object methods - --->
    <cffunction name="saveContentRelationships" access="public" returntype="void">
    	<cfscript>
		var arContent=[];
		var i=0;
		
		arContent=super.retrieveRelativesByType("Content");
		
        for(i=1;i<=arrayLen(arContent);i++){
			arContent[i].save();
		}
        </cfscript>
    </cffunction>

	<!--- - set and get methods - --->
	<cffunction name="setImageId" access="public" returntype="void">
    	<cfargument name="ImageId" type="numeric" required="yes" />
        
		<cfscript>
		super.clearRelativesByType("Image");
		
		
		</cfscript>
    </cffunction>
    
    <cffunction name="getImageId" access="public" returntype="numeric">
		<cfscript>
		var ImageId=0;
		var arRelatives=[];
		
		arRelatives=super.retrieveRelativesByType("Image");
		
		if(arrayLen(arRelatives)>1){
			// Content should only be related to 1 Section	
		}
		else if(arrayLen(arRelatives)==1){
			ImageId=arRelatives[1].getId();
		}
		
		
		return ImageId;
		</cfscript>
    </cffunction>

    <cffunction name="setPageId" access="public" returntype="void">
		<cfargument name="pageId" type="numeric" required="yes">
	
    	<cfscript>
		variables.pageId=arguments.pageId;
		</cfscript>
    </cffunction>

    <cffunction name="getPageId" access="public" returntype="numeric">
		<cfscript>
		return variables.pageId;
		</cfscript>
    </cffunction>
</cfcomponent>