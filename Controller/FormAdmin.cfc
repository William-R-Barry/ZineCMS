<cfcomponent extends="v1.Controller.Form">
	<cffunction name="outputForm" access="public" returntype="string">
    	<cfargument name="url" type="any" required="yes" />
        
    	<cfscript>
		var htmlOutput="";
		var action=(isDefined("arguments.url.action")) ? arguments.url.action : "create";
		var parentId=(isDefined("arguments.url.id") && isNumeric(arguments.url.id)) ? arguments.url.id : 0;
		var parentType="";
		var arChildType=[];
		
		var i=0;
		
		// set parent and child type
		if(isDefined("url.type")){
			parentType=listFirst(arguments.url.type,"-");
		}
		else{
			parentType="Section";
		}
		
		objParent=createObject("component","v1.Model." & parentType);
		objParent.setId(parentId);
		if(uCase(action)!="CREATE") objParent.retrieve();
		
		htmlOutput=this.outputObejct(
			action,
			objParent,
			""
		);
		
		if(uCase(parentType)=="Section"
			|| uCase(parentType)=="Content" 
			|| uCase(parentType)=="ImageGallery"){
			arChildType=objParent.getRelatedTo();
		
			for(i=1;i<=arrayLen(arChildType);i++){
				htmlOutput=htmlOutput & this.outputRelatedObjectList("DETACH",objParent,arChildType[i]);
				htmlOutput=htmlOutput & this.outputRelatedObjectList("ATTACH",objParent,arChildType[i]);
			}
		}
		
		return htmlOutput;
		</cfscript>
    </cffunction>
    
	<cffunction name="processForm" access="public" returntype="any">
    	<cfargument name="url" type="any" required="yes" />
        <cfargument name="form" type="any" required="yes" />
    	<cfscript>
		var action=(isDefined("arguments.url.action")) ? arguments.url.action : "";
		var type=(isDefined("arguments.url.type")) ? arguments.url.type : "";
		var parentId=0;
		var parentType="";
		var childType="";
		
		if(action=="" || type==""){
			throw(
				type=application.error.url.variableNotFound.type,
				message=application.error.url.variableNotFound.message,
				errorcode=application.error.url.variableNotFound.errorCode
			);
		}
		
		if(action!="CREATE"
		&& action!="UPDATE"
		&& action!="DELETE"
		&& action!="ATTACH"
		&& action!="DETACH"){
			throw(
				type=application.error.object.actionUnknown.type,
				message=application.error.object.actionUnknown.message,
				errorcode=application.error.object.actionUnknown.errorCode
			);	
		}
		
		if(isDefined("arguments.url.id") && isNumeric(arguments.url.id)){
			 parentId=arguments.url.id;
		}
		else{
			// url.id must be defined and of type numeric
			throw(
				type=application.error.url.variableNotFound.type,
				message=application.error.url.variableNotFound.message,
				errorcode=application.error.url.variableNotFound.errorCode
			);
		}
		
		// set parent and child type
		parentType=listFirst(type,"-");
		if(listLen(type,"-")>=2) childType=listGetAt(type,2,"-");
		
		if(childType=="") childType=this.retrieveDefaultRelatedObjectType(parentType);
		
		objParent=createObject("component","v1.Model." & parentType);
		objParent.setId(parentId);
		
		if(action=="CREATE" || action=="UPDATE" || action=="DELETE"){ 
			objParent=this.processObject(action,objParent,arguments.form);
		}
		else if(action=="ATTACH" || action=="DETACH"){
			this.processRelatedObjectList(action,objParent,arguments.form);
		}
		
		return objParent;
		</cfscript>
    </cffunction>

	<cffunction name="outputObejct" access="private" returntype="string">
		<cfargument name="action" type="string" required="yes" />
        <cfargument name="object" type="any" required="yes" />
        <cfargument name="formActionURL" type="string" required="no" />

		<cfscript>
		var local={}; // define local scope
		
		if(uCase(arguments.action)!="CREATE"
		&& uCase(arguments.action)!="UPDATE"
		&& uCase(arguments.action)!="DELETE"){
			// an invalid action was used
			throw(
				type=application.error.object.actionUnknown.type,
				message=application.error.object.actionUnknown.message,
				errorcode=application.error.object.actionUnknown.errorCode
			);
		}
		
		local.formOuput="";
		local.action=arguments.action;
		local.object=arguments.object;
		local.objectType=local.object.getObjectType();
		if(isDefined("arguments.formActionURL")){
			local.formActionURL=arguments.formActionURL;
		}
		else{
			local.formActionURL=application.url.admin.form;
		}
		local.formActionURL="?action=" & local.action 
			& "&type=" & local.objectType
			& "&id=" & local.object.getId();
		
		// include form template based on the object type
		include "../" & application.templates.admin.form & lCase(local.objectType) & ".cfm";
		
		return local.formOuput;
        </cfscript>
	</cffunction>
    
    <cffunction name="outputRelatedObjectList" access="private" returntype="string">
		<cfargument name="action" type="string" required="yes" />
        <cfargument name="object" type="any" required="yes" />
        <cfargument name="relatedObjectType" type="string" required="yes" />
        <cfargument name="formActionURL" type="string" required="no" />

		<cfscript>
		var local={}; // define local scope
		
		if(uCase(arguments.action)!="ATTACH" && uCase(arguments.action)!="DETACH"){
			// an invalid action was used
			throw(
				type=application.error.object.actionUnknown.type,
				message=application.error.object.actionUnknown.message,
				errorcode=application.error.object.actionUnknown.errorCode
			);
		}
		
		local.formListOuput="";
		local.action=arguments.action;
		local.object=arguments.object;
		local.objectType=local.object.getObjectType();
		local.relatedObjectType=arguments.relatedObjectType;
		
		if(isDefined("arguments.formActionURL")){
			local.formActionURL=arguments.formActionURL;
		}
		else{
			local.formActionURL=application.url.admin.form;
		}
		local.formActionURL="?action=" & local.action 
			& "&type=" & local.objectType
			& "&id=" & local.object.getId();
		
		// include form template based on the object type
		include "../" & application.templates.admin.listObject & lCase(local.objectType) & ".cfm";
		
		return local.formListOuput;
        </cfscript>
	</cffunction>
    
    <cffunction name="processObject" access="private" returntype="any">
		<cfargument name="action" type="string" required="yes" />
        <cfargument name="object" type="any" required="yes" />
        <cfargument name="data" type="any" required="yes" />

		<cfscript>
		var local={}; // define local scope
		
		if(uCase(arguments.action)!="CREATE"
		&& uCase(arguments.action)!="UPDATE"
		&& uCase(arguments.action)!="DELETE"){
			// an invalid action was used
			throw(
				type=application.error.object.actionUnknown.type,
				message=application.error.object.actionUnknown.message,
				errorcode=application.error.object.actionUnknown.errorCode
			);
		}
		
		local.action=arguments.action;
		local.data=arguments.data;
		local.object=arguments.object;
		local.objectType=local.object.getObjectType();
		
		if(uCase(local.action)=="UPDATE" || uCase(local.action)=="DELETE"){
			if(!local.object.isDataLoaded()) local.object.retrieve();
		}
		
		if(uCase(local.action)=="CREATE" || uCase(local.action)=="UPDATE"){
			// include script template to set object attributes
			include "../" & application.processing.admin.form & lCase(local.objectType) & ".cfm";
		}
		
		if(uCase(local.action)=="DELETE") local.object.delete();
        
        return local.object;
        </cfscript>
	</cffunction>
    
    <cffunction name="processRelatedObjectList" access="private" returntype="void">
    	<cfargument name="action" type="string" required="yes" />
        <cfargument name="object" type="any" required="yes" />
        <cfargument name="data" type="any" required="yes" />
        
        <cfscript>
		var local={}; // define local scope
		
		if(uCase(arguments.action)!="ATTACH" && uCase(arguments.action)!="DETACH"){
			// an invalid action was used
			throw(
				type=application.error.object.actionUnknown.type,
				message=application.error.object.actionUnknown.message,
				errorcode=application.error.object.actionUnknown.errorCode
			);
		}
		
		local.action=arguments.action;
		local.data=arguments.data;
		local.object=arguments.object;
		local.objectType=local.object.getObjectType();
		
		if(!local.object.isDataLoaded()) local.object.retrieve();
		
		// include script template to set object attributes
		include "../" & application.processing.admin.listObject & lCase(local.objectType) & ".cfm";
		
		</cfscript>
    </cffunction>
</cfcomponent>