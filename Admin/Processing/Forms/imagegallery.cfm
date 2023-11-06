<!--- - 

This processing script is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

 - --->

<cfscript>
local.published=(isDefined("local.data.Image_gallery_published"));

local.object.setTitle(local.data.Image_gallery_title);
local.object.setPublished(local.published);

objSecurity=createObject("component","v1.Controller.Security");
objUser=objSecurity.retrieveUser();

local.object.save(objUser);
</cfscript>