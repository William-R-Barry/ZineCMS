<!--- - 

This template is intended to be used in conjuction with Controller.ViewAdmin
The "local" scope and contained variables are defeind in Controller.ViewAdmin

 - --->
<cfscript>
local.navigationOuput="";
local.arObjectType=["Section","Content","ImageGallery","Image"];
local.arObjectTitle=["Section","Content","Image Gallery","Image"];
local.i=0;

for(local.i=1;local.i<=arrayLen(local.arObjectType);local.i++){
	local.navigationOuput=local.navigationOuput & "<a href="""
		& application.url.admin.form
		& "?action=create"
		& "&type=" & local.arObjectType[local.i]
		& "&id=0"
		& """>Create " & local.arObjectTitle[local.i] &"</a>";
}
</cfscript>