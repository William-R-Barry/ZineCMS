<!--- -

This template is intended to be used in conjuction with Controller.View
The "local" scope and contained variables are defeind in Controller.View

- --->

<cfscript>
local.objectId=local.object.getId();
local.objectTitle=local.object.getTitle();

local.hrefUrl=local.viewUrl & "?action=update&type=" & local.objectType & "&id=" & local.objectId;

// create object link
local.htmlOuput=local.htmlOuput & "<a href=""" & local.hrefUrl & """"
	& " id=""" & local.objectType & "_" & local.objectId & """>" 
	& local.objectTitle 
	& "</a>";
</cfscript>