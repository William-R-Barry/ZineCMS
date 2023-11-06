<!--- -

This template is intended to be used in conjuction with Controller.View
The "local" scope and contained variables are defeind in Controller.View

- --->

<cfscript>
include "object_retrieve_display_href.cfm";

local.arObject=local.object.retrieveRelativesByType(local.relatedObjectType);

if(arrayLen(local.arObject)>=1){
	local.htmlOuput=local.htmlOuput & "<ul>";
	
	// create related object link
	for(local.i=1;local.i<=arrayLen(local.arObject);local.i++){
		local.relatedObject=local.arObject[local.i];
		local.relatedObject.retrieve();
		
		local.relatedObjectId=local.relatedObject.getId();
		local.relatedObjectTitle=local.relatedObject.getTitle();
		
		local.hrefUrl=local.viewUrl & "?action=view&type=" & local.relatedObjectType & "&id=" & local.relatedObjectId;
		
		local.htmlOuput=local.htmlOuput & "<li><a href=""" & local.hrefUrl & """"
			& " id=""" & local.relatedObjectType & "_" & local.relatedObjectId & """>" 
			& local.relatedObjectTitle 
			& "</a></li>";
	}

	local.htmlOuput=local.htmlOuput & "</ul>";
}
</cfscript>