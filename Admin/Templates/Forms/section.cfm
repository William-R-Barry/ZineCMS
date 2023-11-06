<!--- - 

This template is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

 - --->

<cfscript>
local.postButtonTitle="Save";

local.sectionId=local.object.getId();
local.sectionTitle=local.object.getTitle();

if(uCase(local.action)=="CREATE"){
	local.sectionIsPublished=true;
	local.sectionIsFeatured=false;
}
else{
	local.sectionIsPublished=local.object.isPublished();
	local.sectionIsFeatured=local.object.isFeatured();
}

local.formOuput="<form action=""" & local.formActionURL & """ method=""post"">"
    & "Section title"
	& "<input type=""text"" name=""section_title"" id=""section_title"" value=""" & local.sectionTitle & """ />"
	& "<input type=""checkbox"" name=""section_published"" id=""section_published"" value=""published""";
	if(local.sectionIsPublished) local.formOuput=local.formOuput & " checked=""checked""";
	local.formOuput=local.formOuput & " /> Published"
	& " <input type=""checkbox"" name=""section_featured"" id=""section_featured"" value=""featured""";
	if(local.sectionIsFeatured) local.formOuput=local.formOuput & " checked=""checked""";
	local.formOuput=local.formOuput & " /> Featured<br />"
	& "<input type=""button"" name=""section_execute_save"" id=""section_execute_save"" onClick=""javascript:submit();"" value=""Save"" />";
</cfscript>