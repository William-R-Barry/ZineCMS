<cfcomponent extends="v1.Controller.View">
	<cffunction name="outputView" access="private" returntype="string">
		<cfargument name="url" type="any" required="yes" />
    	<!--- - process a view request by getting object and navigation data then 
				calling the Template controller to generate the HTML output - --->
		<cfscript>
        var htmlOutput="";
		var objTemplate={};
		var stDataObject={};
		
		stDataObject=this.retrieveViewData(arguments.url);
		
		// *** retrieve HTML view output ***
		objTemplate=createObject("component","v1.Controller.TemplatePublic");
		
		htmlOutput=objTemplate.outputHTMLPage(
			stDataObject.object,
			stDataObject.arNavSiteData,
			stDataObject.arCrumbTrailData,
			stDataObject.arNavContextualData
		);
		
		return htmlOutput;
		</cfscript>
	</cffunction>
    
    <cffunction name="outputViewJSON" access="private" returntype="string">
		<cfargument name="url" type="any" required="yes" />
    	<!--- - process a view request by getting object and navigation data then 
				calling the Template controller to generate the HTML output - --->
		<cfscript>
        var jsonOutput="";
		var objTemplate={};
		var stDataObject={};
		
		stDataObject=this.retrieveViewData(arguments.url);
		
		// *** retrieve HTML view output ***
		objJSONData=createObject("component","v1.Controller.JSONData");
		
		jsonOutput=objJSONData.outputJSONData(
			stDataObject.object,
			stDataObject.arNavSiteData,
			stDataObject.arCrumbTrailData,
			stDataObject.arNavContextualData
		);
		
		return jsonOutput;
		</cfscript>
	</cffunction>
    
    <cffunction name="retrieveViewData" access="package" returntype="struct">
		<cfargument name="url" type="any" required="yes" />
        
    	<cfscript>
		var objTemplate={};
		var defaultAction=false;
		var htmlOutput="";
		var arNavSiteData=[];
		var arCrumbTrailData=[];
		var arNavContextualData=[];
		var htmlBody="";
		var action=(isDefined("arguments.url.action")) ? arguments.url.action : "";
		var objectType=(isDefined("arguments.url.type")) ? arguments.url.type : "";
		var objectId=(isDefined("arguments.url.id")) ? arguments.url.id : 0;
		var object={};
		var relatedObjectType="";
		var objectRecordFound=false;
		var arRelatedType=[];
		var stDataObject={};
		var i=0;
		
		// *** retrieve view data ***
		if(action=="" || objectType=="" || objectId==0 ){
			defaultAction=true;
		}
		
		if(defaultAction){
			// find featured Section
			objectType="Section";
			objectId=super.retrieveDefaultObjectId(objectType);
		}
		
		object=createObject("component","v1.Model." & objectType);
		object.setId(objectId);
		
		try{
			object.retrieve();
			objectRecordFound=true;
		}
		catch(Any error){
			// do nothing
		}
		
		if(objectRecordFound){		
			relatedObjectType=super.retrieveDefaultRelatedObjectType(objectType);
			
			if(uCase(relatedObjectType)=="SECTION" || uCase(relatedObjectType)=="CONTENT")
				
			if(uCase(relatedObjectType)=="CONTENT"){
				arNavContextualData=super.retrieveArMapChild(
					objectType,
					objectId,
					relatedObjectType,
					"writtenDate",
					"DESC"
				);
			}
			else{
				arNavContextualData=super.retrieveArMapChild(
					objectType,
					objectId,
					relatedObjectType
				);
			}
			
			if(arrayLen(arNavContextualData)==0){
				arRelatedType=object.getRelatedTo();
				arrayDelete(arRelatedType,relatedObjectType);
				// check other related objects
				for(i=1;i<=arrayLen(arRelatedType);i++){
					relatedObjectType=arRelatedType[i];
					
					if(uCase(relatedObjectType)=="CONTENT"){
						arNavContextualData=super.retrieveArMapChild(
							objectType,
							objectId,
							relatedObjectType,
							"writtenDate",
							"DESC"
						);
					}
					else{
						arNavContextualData=super.retrieveArMapChild(
							objectType,
							objectId,
							relatedObjectType
						);
					}
					
					if(arrayLen(arNavContextualData)>0) break;
				}
			}
		}
		
		arCrumbTrailData=this.retrieveArCrumbTrail(objectType,objectId);
		
		arNavSiteData=super.retrieveArMapParent("Section");
		
		stDataObject.object=object;
		stDataObject.arNavSiteData=arNavSiteData;
		stDataObject.arCrumbTrailData=arCrumbTrailData;
		stDataObject.arNavContextualData=arNavContextualData;
		
		return stDataObject;
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieveArCrumbTrail" access="public" returntype="array">
    	<cfargument name="objectType" type="string" required="yes" />
        <cfargument name="objectId" type="numeric" required="yes" />
        <cfargument name="arMapTrail" type="array" required="no" />
        <!--- - recursive function that determines the top level object
				based on the child object record type and id - --->
        <cfscript>
		var arMapTrail=(isDefined("arguments.arMapTrail")) ? arguments.arMapTrail : [];
		var stTrailItem={};
		var type=arguments.objectType;
		var id=arguments.objectId;
		var object={};
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
			arMapTrail=this.retrieveArCrumbTrail(
				qryResult.parentType[1],
				qryResult.parentId[1],
				arMapTrail
			);
		}
		
		if(id>0){
			object=createObject("component","v1.Model." & type);
			object.setId(id)
			object.retrieve();
			
			stTrailItem.title=object.getTitle();
			stTrailItem.type=type;
			stTrailItem.id=id;
			
			arrayAppend(arMapTrail,stTrailItem);
		}
		
		return arMapTrail;
		</cfscript>
    </cffunction>
</cfcomponent>