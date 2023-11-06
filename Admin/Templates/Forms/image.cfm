<!--- - 

This template is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

 - --->

<cfscript>
local.postButtonTitle="Save";

local.imageId=local.object.getId();
local.imageTitle=local.object.getTitle();

if(uCase(local.action)=="CREATE"){
	local.imageIsPublished=true;
}
else{
	local.imageIsPublished=local.object.isPublished();
}

// create form HTML output
local.formOuput="<form action=""" & local.formActionURL & """ method=""post"" enctype=""multipart/form-data"">"
	& "Image title"
	& "<input type=""text"" name=""Image_title"" id=""image_title"" value=""" & local.imageTitle & """ />";
if(uCase(local.action)=="CREATE"){
	local.formOuput=local.formOuput & "Image file"
    	& "<input type=""file"" name=""Image_file_upload"" id=""image_file_upload"" />";
}
else{
	// get thumb for Image display
	local.thumb=local.object.retrieveThumb();
	
	local.thumbTitle=local.thumb.getTitle();
	local.thumbUrlSrc=application.url.public.contentImageThumbFolder & local.thumb.getFileName();
	local.thumbWidth=local.thumb.getWidth();
	local.thumbHeight=local.thumb.getHeight();

    local.formOuput=local.formOuput & "<img alt=""" 
		& local.thumbTitle & """"
		& " src=""" & local.thumbUrlSrc & """"
		& " width=""" & local.thumbWidth & """"
		& " height=""" & local.thumbHeight & """"
		& " />";
}

local.formOuput=local.formOuput & "<input type=""checkbox"" name=""Image_published"" id=""image_published"" value=""published""";
	if(local.imageIsPublished) local.formOuput=local.formOuput & " checked=""checked""";
	local.formOuput=local.formOuput & " /> Published<br />"
	& "<input type=""button"" name=""Image_execute_save"" id=""image_execute_save"" onClick=""javascript:submit();"" value=""" & local.postButtonTitle & """ />"
	& "</form>";
</cfscript>
