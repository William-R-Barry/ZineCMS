<!--- - 

This template is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

 - --->

<cfscript>
local.postButtonTitle="Save";

local.imageGalleryTitle=local.object.getTitle();

if(uCase(local.action)=="CREATE"){
	local.imageGalleryIsPublished=true;
}
else{
	local.imageGalleryIsPublished=local.object.isPublished();
}

// create form HTML output
local.formOuput="<form action=""" & local.formActionURL & """ method=""post"">"
	& "Image gallery title"
    & "<input type=""text"" name=""Image_gallery_title"" id=""image_gallery_title"" value=""" & local.imageGalleryTitle & """ />"
    & "<input type=""checkbox"" name=""Image_gallery_published"" id=""image_gallery_published"" value=""published""";
	if(local.imageGalleryIsPublished) local.formOuput=local.formOuput & " checked=""checked""";
	local.formOuput=local.formOuput & " /> Published<br />"
	& "<input type=""button"" name=""Image_gallery_execute_save"" id=""image_gallery_execute_save"" onClick=""javascript:submit();"" value=""" & local.postButtonTitle & """ />"
	& "</form>";
</cfscript>
