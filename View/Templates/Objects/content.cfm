<!--- - 

This template is intended to be used in conjuction with Controller.ViewPublic
The "local" scope and contained variables are defeind in Controller.ViewPublic

 - --->

<cfscript>
local.jsOutput="";
local.htmlOuput="";
local.contentJsOutput="";
local.contentHtmlOutput="";

// retrieve object data
local.contentId=local.object.getId();
local.contentTitle=local.object.getTitle();
local.contentBody=local.object.getBody();
local.contentQuote=local.object.getQuote();
local.writtenBy=local.object.getWrittenBy();
local.writtenDate=local.object.getWrittenDate();
local.contentArImageGallery=local.object.retrieveRelativesByType("ImageGallery");

// construct HTML
local.contentHtmlOutput="<div class=""content"" id=""content_" & local.contentId & """>"
	& "<h1>" & local.contentTitle & "</h1>";
if(local.contentQuote!=""){
	local.contentHtmlOutput=local.contentHtmlOutput & "<p class=""quote"">" & local.contentQuote & "</p>";
}
local.contentHtmlOutput=local.contentHtmlOutput & "<p class=""article"">" & local.contentBody & "</p>";
if(local.writtenBy!="" && local.writtenDate!=""){
	local.contentHtmlOutput=local.contentHtmlOutput & "<p class=""credit_writer"">"
		& "Written by " & local.writtenBy & ", " & local.writtenDate
		& "</p>";	
}
local.contentHtmlOutput=local.contentHtmlOutput & "</div>"
	& "<div class=""content_gallery"" id=""content_gallery_" & local.contentId & """>";
	
	// retrieve Content items
for(local.imageGalleryIndex=1;local.imageGalleryIndex<=arrayLen(local.contentArImageGallery);local.imageGalleryIndex++){
	// set Content as local object for use in the Content template
	local.object=local.contentArImageGallery[local.imageGalleryIndex];
	local.object.retrieve();
	
	if(local.object.isPublished()){
		// include Image Gallery template
		include "ImageGallery.cfm";
		// add Image Gallery JS to Content JS
		local.contentJsOutput=local.contentJsOutput & local.imageGalleryJsOutput;
		// add Image Gallery html to Content html
		local.contentHtmlOutput=local.contentHtmlOutput & local.imageGalleryHtmlOutput;
	}
}

local.contentHtmlOutput=local.contentHtmlOutput & "</div><br clear=""all"" />";

local.jsOutput=local.contentJsOutput;
local.htmlOuput=local.contentHtmlOutput;
</cfscript>
