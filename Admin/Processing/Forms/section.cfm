<!--- - 

This processing script is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

 - --->

<cfscript>
local.published=(isDefined("local.data.Section_published"));
local.featured=(isDefined("local.data.Section_featured"));

local.object.setTitle(local.data.Section_title);
local.object.setPublished(local.published);
local.object.setFeatured(local.featured);

objSecurity=createObject("component","v1.Controller.Security");
objUser=objSecurity.retrieveUser();

local.object.save(objUser);
</cfscript>