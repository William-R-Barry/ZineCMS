<!--- - 

This processing script is intended to be used in conjuction with object list processing
scripts. It supplies generic related object list processing code. Any changes must be 
checked for compatibilty with the object list processing scripts.

This processing script is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

 - --->

<cfscript>
local.formFieldName="";
local.arFormFieldNames=listToArray(local.data.fieldnames);

local.relativeObjectId=0;
local.relativeObjectType="";
local.relatedObject={};
local.arRelatedObject=[];

for(local.i=1;local.i<=arrayLen(local.arFormFieldNames);local.i++){
	local.formFieldName=local.arFormFieldNames[local.i];
	
	if(findNoCase("object_",local.formFieldName)>0){
		local.relativeObjectId=trim(listGetAt(local.data[local.formFieldName],1,"::"));
		local.relativeObjectType=trim(listGetAt(local.data[local.formFieldName],2,"::"));
		
		local.relatedObject=createObject("component","v1.Model." & local.relativeObjectType);
		local.relatedObject.setId(local.relativeObjectId)
		local.relatedObject.retrieve();
		
		arrayAppend(local.arRelatedObject,local.relatedObject);
	}
}

if(arrayLen(local.arRelatedObject)>0) {
	switch(ucase(local.action)){
		case "ATTACH":
			local.object.attachRelative(local.arRelatedObject);
		 break;
		case "DETACH":
			local.object.detachRelative(local.arRelatedObject);
		 break;
	}
	
	objSecurity=createObject("component","v1.Controller.Security");
	objUser=objSecurity.retrieveUser();
	
	local.object.save(objUser);
}
</cfscript>