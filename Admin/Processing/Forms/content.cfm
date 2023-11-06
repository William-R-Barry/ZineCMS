<!--- - 

This processing script is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

 - --->

<cfscript>
local.published=(isDefined("local.data.content_published"));
local.featured=(isDefined("local.data.content_featured"));

local.object.setTitle(local.data.content_title);
local.object.setBody(local.data.content_body);
local.object.setQuote(local.data.content_quote);
local.object.setWrittenBy(local.data.content_written_by);
local.object.setWrittenDate(local.data.content_written_date);
local.object.setPublished(local.published);
local.object.setFeatured(local.featured);

objSecurity=createObject("component","v1.Controller.Security");
objUser=objSecurity.retrieveUser();

local.object.save(objUser);
</cfscript>