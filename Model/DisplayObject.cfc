<cfcomponent>
	<cfscript>
	variables.id=0;
	variables.arRelativeObject=[];
	variables.title="";
	variables.featured=false;
	variables.published=false;
	variables.createdDate="";
	variables.updatedDate="";
	variables.createdBy=0;
	variables.updatedBy=0;
	variables.display="";
	variables.dataLoaded=false;
	variables.arRelatedTo=[];
	</cfscript>

	<cffunction name="isIdValid" access="public" returntype="string">
		<cfscript>
		var idIsValid=false;
		
		if(variables.id>0) idIsValid=true;
		
		return idIsValid;
		</cfscript>
    </cffunction>
    
    <cffunction name="isDataLoaded" access="public" returntype="string">
		<cfscript>
		return variables.dataLoaded;
		</cfscript>
    </cffunction>
    
    <cffunction name="isFeatured" access="public" returntype="boolean">
		<cfscript>
		return variables.featured;
		</cfscript>
    </cffunction>
    
    <cffunction name="isPublished" access="public" returntype="boolean">
		<cfscript>
		return variables.published;
		</cfscript>
    </cffunction>
    
    <cffunction name="hasParent" access="public" returntype="boolean">
		<cfscript>
		var hasParent=(this.retrieveParent().recordCount==1);
		
		return hasParent;
		</cfscript>
    </cffunction>
    
    <cffunction name="hasRelativesOfType" access="public" returntype="boolean">
		<cfargument name="type" type="string" required="yes" />
        
		<cfscript>
		var hasRelatives=(arrayLen(retrieveRelativesByType(arguments.type))>0);
		
		return hasRelatives;
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieveRelativesByType" access="public" returntype="array">
        <cfargument name="type" type="string" required="yes" />
		
		<cfscript>
		var arRelatives=[];
		var i=0;
		
		for(i=1;i<=arrayLen(variables.arRelativeObject);i++){
			if(variables.arRelativeObject[i].getObjectType()==arguments.type){
				arrayAppend(arRelatives,variables.arRelativeObject[i]);
			}
		}
		
		return arRelatives;
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieveRelativesByTypeSortedBy" access="public" returntype="array">
        <cfargument name="type" type="string" required="yes" />
        <cfargument name="sortBy" type="string" required="yes" />
        <cfargument name="sortDirection" default="DESC" type="string" required="no" />
		
		<cfscript>
		var arRelatives=this.sortRelativeType(
			arguments.type,
			arguments.sortBy,
			arguments.sortDirection
		);
		
		return arRelatives;
		</cfscript>
    </cffunction>

    <cffunction name="attachRelative" access="public" returntype="void">
		<cfargument name="relativeObject" type="any" required="yes" />
        <cfscript>
		var arRelativeObject=[];
		var attachedSuccessfully=false;
		var multipleObjects=(isArray(arguments.relativeObject));
		var relativeId=0;
		var relativeType="";
		var i=0;
		
		if(multipleObjects){
			arRelativeObject=arguments.relativeObject;
		}
		else{
			arrayAppend(arRelativeObject,arguments.relativeObject);
		}
		
		for(i=1;i<=arrayLen(arRelativeObject);i++){
			relativeId=arRelativeObject[i].getId();
			relativeType=arRelativeObject[i].getObjectType();
			
			if(!this.relativesExists(relativeId,relativeType)){
				attachedSuccessfully=this.addRelative(arRelativeObject[i]);
				
				if(!attachedSuccessfully){
					// either all relative object will be attached or none
					this.clearRelatives();
					break;
				}
			}
		}
		</cfscript>
    </cffunction>

    <cffunction name="detachRelative" access="public" returntype="void">
        <cfargument name="relativeObject" type="any" required="yes" />
		<cfscript>
		var arDetachRelativeObject=[];
		var multipleObjects=(isArray(arguments.relativeObject));
		var relativeId=0;
		var relativeType="";
		var relativeIndex=0;
		var i=0;
		
		if(multipleObjects){
			arDetachRelativeObject=arguments.relativeObject;
		}
		else{
			arrayAppend(arDetachRelativeObject,arguments.relativeObject);
		}
		
		for(i=1;i<=arrayLen(arDetachRelativeObject);i++){
			relativeId=arDetachRelativeObject[i].getId();
			relativeType=arDetachRelativeObject[i].getObjectType();
			relativeIndex=findRelativeIndex(relativeId,relativeType);
			
			if(relativeIndex>0){
				arrayDeleteAt(variables.arRelativeObject,relativeIndex);
			}
		}
		</cfscript>
    </cffunction>
    
    <cffunction name="isRelatedTo" access="private" returntype="boolean">
		<cfargument name="relativeObject" type="any" required="yes" />
        
		<cfscript>
		var related=this.isRelativeTypeValid(arguments.relativeObject.getObjectType());
		
		return related;
        </cfscript>
	</cffunction>
    
    <cffunction name="isRelativeTypeValid" access="private" returntype="boolean">
		<cfargument name="relativeType" type="string" required="yes" />
        
		<cfscript>
		var relatedIndex=arrayContains(variables.arRelatedTo,arguments.relativeType);
		var related=(relatedIndex>0);
		
		return related;
        </cfscript>
	</cffunction>
    
    <cffunction name="loadRelatives" access="private" returntype="void">
		<cfscript>
		var qryRelationships=this.retrieveRelationshipsByParent();
		var numberOfRelationships=0;
		var relative={};
		var relativeId=0;
		var relativeType="";
		var i=0;
		
		numberOfRelationships=qryRelationships.recordCount;
				
		for(i=1;i<=numberOfRelationships;i++){
			relativeId=qryRelationships.childId[i];
			relativeType=qryRelationships.childType[i];
			
			relative=createObject("component","v1.Model." & relativeType);
			relative.setId(relativeId);
			
			this.attachRelative(relative);
		}
		</cfscript>
    </cffunction>
    
    <cffunction name="loadRelativeByIdAndType" access="private" returntype="void">
    	<cfargument name="id" type="numeric" required="yes" />
        <cfargument name="type" type="string" required="yes" />
		<cfscript>
		var relative={};
		
		relative=createObject("component","v1.Model." & arguments.type);
		relative.setId(arguments.id);
		
		this.attachRelative(relative);
		</cfscript>
    </cffunction>
    
    <cffunction name="sortRelativeType" access="private" returntype="array">
    	<cfargument name="type" type="string" required="yes" />
		<cfargument name="sortBy" default="DATECREATED" type="string" required="no" />
        <cfargument name="sortDirection" default="DESC" type="string" required="no" />
        <cfargument name="prioritiseFeatured" default="true" type="boolean" required="no" />
        
		<cfscript>
		var objRelative={};
		var arRelative=[];
		var arFeaturedRelative=[];
		var arSortedRelative=[];
		var numberOfRelatives=0;
		var numberOfSortedRelatives=0;
		var insertDone=false;
		var i=0;
		var j=0;
		
		arRelative=this.retrieveRelativesByType(arguments.type);
		
		numberOfRelatives=arrayLen(arRelative);
		
		for(i=1;i<=numberOfRelatives;i++){
			objRelative=arRelative[i];
			
			objRelative.retrieve();
			
			if(arguments.prioritiseFeatured && objRelative.isFeatured()){
				arrayAppend(arFeaturedRelative,objRelative);
			}
			else{
				numberOfSortedRelatives=arrayLen(arSortedRelative);
				
				for(j=1;j<=numberOfSortedRelatives;j++){
					if(this.sortCriteriaMatched(
						objRelative,
						arSortedRelative[j],
						arguments.sortBy,
						arguments.sortDirection
					)){
						arrayInsertAt(arSortedRelative,j,objRelative);
						insertDone=true;
						break;
					}
				}
				
				if(!insertDone){
					arrayAppend(arSortedRelative,objRelative);
				}
				
				insertDone=false; // reset insert flag
			}
		}
		
		arSortedRelative=arrayMerge(arFeaturedRelative,arSortedRelative);
		
		return arSortedRelative;
    	</cfscript>
	</cffunction>
    
    <cffunction name="sortCriteriaMatched" access="private" returntype="boolean">
        <cfargument name="objCriteria" type="any" required="yes" />
        <cfargument name="objTest" type="any" required="yes" />
        <cfargument name="sortBy" type="string" required="yes" />
        <cfargument name="sortDirection" type="string" required="yes" />
        
		<cfscript>
		var citeriaMatched=false;
		var criteriaValue=0;
		var criteriaTest=0;
		
		if(!arguments.objCriteria.isDataLoaded()) arguments.objCriteria.retrieve();
		if(!arguments.objTest.isDataLoaded()) arguments.objTest.retrieve();
		
		switch(uCase(arguments.sortBy)){
			case "DATECREATED":
				criteriaValue=arguments.objCriteria.getCreatedDate();
				criteriaTest=arguments.objTest.getCreatedDate();
			 break;
			case "DATEUPDATED":
				criteriaValue=arguments.objCriteria.getUpdatedDate();
				criteriaTest=arguments.objTest.getUpdatedDate();
			 break;
			case "DATEWRITTEN":
				criteriaValue=arguments.objCriteria.getWrittenDate();
				criteriaTest=arguments.objTest.getWrittenDate();
			 break;
		}
		
		if(arguments.sortDirection=="DESC"){
			citeriaMatched=(criteriaTest<=criteriaValue);
		}
		else if(arguments.sortDirection=="ASC"){
			citeriaMatched=(criteriaTest>=criteriaValue);
		}
		
		return citeriaMatched;
    	</cfscript>
	</cffunction>
    
    <cffunction name="addRelative" access="private" returntype="boolean">
        <cfargument name="relativeObject" type="any" required="yes" />
		
		<cfscript>
		var attachedSuccessfully=false;
		
		if(arguments.relativeObject.isIdValid() && this.isRelatedTo(arguments.relativeObject)){
			arrayAppend(variables.arRelativeObject,arguments.relativeObject);
			attachedSuccessfully=true;
		}
		
		return attachedSuccessfully;
		</cfscript>
    </cffunction>
    
    <cffunction name="clearRelatives" access="private" returntype="void">
        <cfscript>
		this.setRelative=[];
		</cfscript>
    </cffunction>

    <cffunction name="clearRelativesByType" access="private" returntype="void">
        <cfargument name="type" type="string" required="yes" />
		
		<cfscript>
		var i=0;
		
		for(i=1;i<=arrayLen(variables.arRelativeObject);i++){
			if(variables.arRelativeObject[i].getObjectType()==arguments.type){
				this.detachRelative(variables.arRelativeObject[i]);
			}
		}
		</cfscript>
    </cffunction>
    
    <cffunction name="findRelativeIndex" access="private" returntype="numeric">
        <cfargument name="id" type="numeric" required="yes" />
        <cfargument name="type" type="string" required="yes" />
		
		<cfscript>
		var relativeIndex=-1;
		var relativeId=0;
		var relativeType="";
		var i=0;
		
		for(i=1;i<=arrayLen(variables.arRelativeObject);i++){
			relativeId=variables.arRelativeObject[i].getId();
			relativeType=variables.arRelativeObject[i].getObjectType();
			
			if(relativeType==arguments.type && relativeId==arguments.id){
				relativeIndex=i;
			}
		}
		
		return relativeIndex;
        </cfscript>
    </cffunction>
    
    <cffunction name="findRelative" access="private" returntype="any">
        <cfargument name="id" type="numeric" required="yes" />
        <cfargument name="type" type="string" required="yes" />
		
		<cfscript>
		var relative={};
		var relativeIndex=this.findRelativeIndex(arguments.id,arguments.type);
		
		if(relativeIndex>0) relative=variables.arRelativeObject[relativeIndex];
		
		return relative;
        </cfscript>
    </cffunction>    
    
    <cffunction name="relativesExists" access="private" returntype="boolean">
        <cfargument name="id" type="numeric" required="yes" />
        <cfargument name="type" type="string" required="yes" />
		
		<cfscript>
		var relativeExists=(this.findRelativeIndex(arguments.id,arguments.type)>0);
		
        return relativeExists;
        </cfscript>
    </cffunction>

    <cffunction name="saveRelationships" access="private" returntype="void">
		<cfscript>
		var numberOfRelatives=arrayLen(variables.arRelativeObject);
		var child={};
		var i=0;
		
		// clear existing relationships
		this.deleteRelationshipsByParent();
		
		// create relationsips
		for(i=1;i<=numberOfRelatives;i++){
			child=variables.arRelativeObject[i];
			
			if(child.isIdValid()){
				this.createRelationship(child);
			}
			else{
				// the child object has an invalid id
					
			}
		}
		</cfscript>
    </cffunction>
    
    <cffunction name="createRelationship" access="private" returntype="void">
    	<cfargument name="child" type="any" required="yes" />
    	
		<cfscript>
    	var qryCreateRelationship=new Query();
		var sqlStatement="INSERT INTO ObjectRelationship(
				ObjectRelationship.parentId,
				ObjectRelationship.parentType,
				ObjectRelationship.childId,
				ObjectRelationship.childType
			)
			VALUES(
				:parentId,
				:parentType,
				:childId,
				:childType
			)";
			
		qryCreateRelationship.setName("createRelationship");
		qryCreateRelationship.setSQL(sqlStatement);
		qryCreateRelationship.addParam(
			name="parentId",
			value=this.getId(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryCreateRelationship.addParam(
			name="parentType",
			value=this.getObjectType(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryCreateRelationship.addParam(
			name="childId",
			value=arguments.child.getId(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryCreateRelationship.addParam(
			name="childType",
			value=arguments.child.getObjectType(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		
		result=qryCreateRelationship.execute();
		</cfscript>
    </cffunction>

    <cffunction name="retrieveRelationshipsByParent" access="private" returntype="query">
    	<cfscript>
    	var qryRetrieveRelationship=new Query();
		var qryResultRelationship={};
		var sqlStatement="SELECT 
				ObjectRelationship.id,
				ObjectRelationship.parentId,
				ObjectRelationship.parentType,
				ObjectRelationship.childId,
				ObjectRelationship.childType
			FROM ObjectRelationship
			WHERE
				ObjectRelationship.parentId=:parentId AND
				ObjectRelationship.parentType=:parentType
			ORDER BY ObjectRelationship.childType, ObjectRelationship.childId ASC";
			
		qryRetrieveRelationship.setName("retrieveRelationship");
		qryRetrieveRelationship.setSQL(sqlStatement);
		qryRetrieveRelationship.addParam(
			name="parentId",
			value=this.getId(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryRetrieveRelationship.addParam(
			name="parentType",
			value=this.getObjectType(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		
		qryResultRelationship=qryRetrieveRelationship.execute().getResult();
        
		return qryResultRelationship;
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieveParent" access="private" returntype="query">
    	<cfscript>
    	var qryRetrieveParent=new Query();
		var qryResultParent={};
		var sqlStatement="SELECT 
				ObjectRelationship.id,
				ObjectRelationship.parentId,
				ObjectRelationship.parentType
			FROM ObjectRelationship
			WHERE
				ObjectRelationship.childId=:childId AND
				ObjectRelationship.childType=:childType";
			
		qryRetrieveParent.setName("retrieveParent");
		qryRetrieveParent.setSQL(sqlStatement);
		qryRetrieveParent.addParam(
			name="childId",
			value=this.getId(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryRetrieveParent.addParam(
			name="childType",
			value=this.getObjectType(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		
		qryResultParent=qryRetrieveParent.execute().getResult();
        
		return qryResultParent;
		</cfscript>
    </cffunction>
    
    <cffunction name="deleteRelationships" access="private" returntype="void">
    	<cfscript>
    	var qryRelationshipDelete=new Query();
		var sqlStatement="DELETE FROM ObjectRelationship
			WHERE (
				ObjectRelationship.parentId=:id 
				AND ObjectRelationship.parentType=:type
			) OR
			(
				ObjectRelationship.childId=:id 
				AND ObjectRelationship.childType=:type
			)";
		
		qryRelationshipDelete.setName("deleteRelationship");
		qryRelationshipDelete.setSQL(sqlStatement);
		qryRelationshipDelete.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryRelationshipDelete.addParam(
			name="type",
			value=this.getObjectType(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryRelationshipDelete.execute();
		</cfscript>
    </cffunction>
    
    <cffunction name="deleteRelationshipsByParent" access="private" returntype="void">
    	<cfscript>
    	var qryRelationshipDelete=new Query();
		var sqlStatement="DELETE FROM ObjectRelationship
			WHERE ObjectRelationship.parentId=:id 
			AND ObjectRelationship.parentType=:type";
		
		qryRelationshipDelete.setName("deleteRelationshipByParent");
		qryRelationshipDelete.setSQL(sqlStatement);
		qryRelationshipDelete.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryRelationshipDelete.addParam(
			name="type",
			value=this.getObjectType(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryRelationshipDelete.execute();
		</cfscript>
    </cffunction>
    
    <cffunction name="save" access="public" returntype="void">
		<cfargument name="user" type="v1.Model.UserLoginAccount" required="no" />
        
		<cfscript>
		if(!isDefined("arguments.user")) arguments.user=createObject("component","v1.Model.UserLoginAccount");
		
		if(this.getId()==0){
			this.create(arguments.user);
		}
		else{
			this.update(arguments.user);
		}
		
		this.saveRelationships();
		</cfscript>
    </cffunction>
    <!--- - CRUD methods - --->
    <cffunction name="create" access="public" returntype="void">
    	<cfargument name="user" type="v1.Model.UserLoginAccount" required="no" />
        
        <cfscript>
		var userId=arguments.user.getId();
		
		this.setCreatedDate(now());
        this.setCreatedBy(userId);
        this.setUpdatedDate(now());
        this.setUpdatedBy(userId);
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieve" access="public" returntype="void">
		<cfscript>
		if(!this.isIdValid()){
			throw(
				type=application.error.db.invalidRecordId.type,
				message=application.error.db.invalidRecordId.message,
				errorcode=application.error.db.invalidRecordId.errorCode
			);
		}
		
		// load all related objects
		this.loadRelatives();
		</cfscript>
    </cffunction>
    
    <cffunction name="update" access="public" returntype="void">
    	<cfargument name="user" type="v1.Model.UserLoginAccount" required="no" />
        
		<cfscript>
		var userId=arguments.user.getId();
		
		if(!this.isIdValid()){
			throw(
				type=application.error.db.invalidRecordId.type,
				message=application.error.db.invalidRecordId.message,
				errorcode=application.error.db.invalidRecordId.errorCode
			);
		}
		
        this.setUpdatedDate(now());
        this.setUpdatedBy(userId);
		</cfscript>
    </cffunction>
    
    <cffunction name="delete" access="public" returntype="void">
    	<cfargument name="user" type="v1.Model.UserLoginAccount" required="no" />
        
		<cfscript>
		if(!this.isIdValid()){
			throw(
				type=application.error.db.invalidRecordId.type,
				message=application.error.db.invalidRecordId.message,
				errorcode=application.error.db.invalidRecordId.errorCode
			);
		}
		
		this.deleteRelationships();
		</cfscript>
    </cffunction>
    <!--- - Set/Get methods - --->
    <cffunction name="getObjectType" access="public" returntype="string">
		<cfscript>
		return variables.objectType;
		</cfscript>
    </cffunction>
    
    <cffunction name="setId" access="public" returntype="void">
		<cfargument name="id" type="numeric" required="yes" />
	
    	<cfscript>
		variables.id=arguments.id;
		</cfscript>
    </cffunction>

    <cffunction name="getId" access="public" returntype="numeric">
		<cfscript>
		return variables.id;
		</cfscript>
    </cffunction>
    
    <cffunction name="getRelativeObjects" access="public" returntype="array">
		<cfscript>
    	return variables.arRelativeObject;
		</cfscript>
    </cffunction>
    
    <cffunction name="getRelatedTo" access="public" returntype="array">
		<cfscript>
    	return variables.arRelatedTo;
		</cfscript>
    </cffunction>
    
    <cffunction name="setTitle" access="public" returntype="void">
		<cfargument name="title" type="string" required="yes" />
	
    	<cfscript>
		variables.title=arguments.title;
		</cfscript>
    </cffunction>

    <cffunction name="getTitle" access="public" returntype="string">
		<cfscript>
		return variables.title;
		</cfscript>
    </cffunction>
    
    <cffunction name="setCreatedDate" access="public" returntype="void">
		<cfargument name="createdDate" type="date" required="yes" />
	
    	<cfscript>
		variables.createdDate=arguments.createdDate;
		</cfscript>
    </cffunction>

    <cffunction name="getCreatedDate" access="public" returntype="date">
    	<cfscript>
		return variables.createdDate
		</cfscript>
    </cffunction>
    
    <cffunction name="setUpdatedDate" access="public" returntype="void">
		<cfargument name="updatedDate" type="date" required="yes" />
	
    	<cfscript>
		variables.updatedDate=arguments.updatedDate;
		</cfscript>
    </cffunction>

    <cffunction name="getUpdatedDate" access="public" returntype="date">
    	<cfscript>
		return variables.updatedDate;
		</cfscript>
    </cffunction>
    
    <cffunction name="setCreatedBy" access="public" returntype="void">
		<cfargument name="createdBy" type="numeric" required="yes" />
	
    	<cfscript>
		variables.createdBy=arguments.createdBy;
		</cfscript>
    </cffunction>

    <cffunction name="getCreatedBy" access="public" returntype="numeric">
    	<cfscript>
		return variables.createdBy
		</cfscript>
    </cffunction>
    
    <cffunction name="setUpdatedBy" access="public" returntype="void">
		<cfargument name="updatedBy" type="numeric" required="yes" />
	
    	<cfscript>
		variables.updatedBy=arguments.updatedBy;
		</cfscript>
    </cffunction>

    <cffunction name="getUpdatedBy" access="public" returntype="numeric">
    	<cfscript>
		return variables.updatedBy;
		</cfscript>
    </cffunction>
    
    <cffunction name="setDataLoaded" access="public" returntype="void">
		<cfargument name="dataLoaded" type="boolean" required="yes" />
	
    	<cfscript>
		variables.dataLoaded=arguments.dataLoaded;
		</cfscript>
    </cffunction>
    
    <cffunction name="setFeatured" access="public" returntype="void">
		<cfargument name="featured" type="boolean" required="yes" />
	
    	<cfscript>
		variables.featured=arguments.featured;
		</cfscript>
    </cffunction>

    <cffunction name="setPublished" access="public" returntype="void">
    	<cfargument name="published" type="boolean" required="yes" />
	
    	<cfscript>
		variables.published=arguments.published;
		</cfscript>
    </cffunction>
</cfcomponent>