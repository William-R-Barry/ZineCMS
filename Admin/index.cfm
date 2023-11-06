<cfsetting enablecfoutputonly="yes" />
<cfscript>
objSecurity=createObject("component","v1.Controller.Security");

userIsLoggedIn=objSecurity.isUserLoggedIn();

if(!userIsLoggedIn){
	location(application.url.admin.login & "?userLoggedIn=false",false);	
}

if(isDefined("form.fieldNames")){
	object={};
	
	objForm=createObject("component","v1.Controller.FormAdmin");
	object=objForm.processForm(url,form);
	
	if(url.action!="DELETE"){
		if(application.settings.cache.active){
			// *** start cache update
			objectType=object.getObjectType();
			objectId=object.getId();
			
			// setup parameters for ViewPublic processRequest call
			// this mimics what woudl normally be contained in URL
			viewParams={};
			viewParams.action="view";
			viewParams.type=objectType;
			viewParams.id=objectId;
			
			objView=createObject("component","v1.Controller.ViewPublic");
			viewData=objView.processRequest(viewParams);
			
			// update public view cache
			objViewCache=createObject("component","v1.Controller.ViewCache");
			// update the cache for the current object
			objViewCache.put(
				objectType,
				objectId,
				viewData
			);
			// update the cache for all parent objects up to the top level parent object
			objViewCache.bubbleUpdate(
				objectType,
				objectId
			);
			// *** end cache update
		}
		
		// after performing an action of attach detach,
		// the view form process will always be update.
		url.action="UPDATE";
		url.id=object.getId();
	}	
}

objView=createObject("component","v1.Controller.ViewAdmin");
htmlOutput=objView.processRequest(url,"FORM",form);
</cfscript>
<cfsetting enablecfoutputonly="no" />
<cfscript>
writeOutput(htmlOutput);
</cfscript>
