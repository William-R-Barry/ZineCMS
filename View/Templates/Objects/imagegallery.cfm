<!--- - 

This template is intended to be used in conjuction with Controller.ViewPublic
The "local" scope and contained variables are defeind in Controller.ViewPublic

 - --->

<cfscript>
local.jsOutput="";
local.htmlOuput="";

local.imageJson="";
local.imageGalleryJsOutput=""
local.imageGalleryHtmlOutput="";

local.displayImageMaxDimension=application.attribute.gallery.maxWHDimension;

local.imageGalleryId=local.object.getId();
local.imageGalleryTitle=local.object.getTitle();
local.imageGalleryArImage=local.object.retrieveRelativesByType("Image");
local.numberOfImages=arrayLen(local.imageGalleryArImage);
local.imageIndex=0;

if(local.numberOfImages>1){
	
	local.imageGalleryJsOutput=local.imageGalleryJsOutput 
		& "var imageGallery_" & local.imageGalleryId & "=[";
	
	// add silent gallery image loading js to js ouput
	for(local.imageIndex=1;local.imageIndex<=local.numberOfImages;local.imageIndex++){
		local.imageGalleryArImage[local.imageIndex].retrieve();
		local.imageUrlSrc=application.url.public.contentImageFolder
			& local.imageGalleryArImage[local.imageIndex].getFileName();
		local.thumbUrlSrc=application.url.public.contentImageThumbFolder
			& local.imageGalleryArImage[local.imageIndex].getFileName();
		local.imageTitle=local.imageGalleryArImage[local.imageIndex].getTitle();
		
		local.imageJson="{"
			& "image:""" & local.imageUrlSrc & ""","
			& "thumb:""" & local.thumbUrlSrc & ""","
			& "title:""" & local.imageTitle & """"
			& "}";
		
		local.imageGalleryJsOutput=local.imageGalleryJsOutput & local.imageJson;
		
		if(local.imageIndex<local.numberOfImages) local.imageGalleryJsOutput=local.imageGalleryJsOutput & ",";
	}
	
	local.imageGalleryJsOutput=local.imageGalleryJsOutput & "];"
		& "Galleria.run('##display_image_" & local.imageGalleryId & "',"
		& "{dataSource: imageGallery_" & local.imageGalleryId & "}); ";
}

local.imageGalleryHtmlOutput="<div class=""image_gallery"" id=""imageGallery_" & local.imageGalleryId & """>"
	& "<h1>" & local.imageGalleryTitle & "</h1>";
	
if(local.numberOfImages>0){
	local.object=local.imageGalleryArImage[1];
	local.object.retrieve();
	local.maxWHDimension=application.attribute.gallery.maxWHDimension;
	
	// include Image template
	include "Image.cfm";
	local.displayImageId=local.imageTagId;
	
	// add display image html to html output
	local.imageGalleryHtmlOutput=local.imageGalleryHtmlOutput & "<div class=""display_image""  id=""display_image_" & local.imageGalleryId & """>";
	local.imageGalleryHtmlOutput=local.imageGalleryHtmlOutput & local.imageHtmlOuput;
	local.imageGalleryHtmlOutput=local.imageGalleryHtmlOutput & "</div>";
}
	
local.imageGalleryHtmlOutput=local.imageGalleryHtmlOutput & "</div>";
local.jsOutput=local.imageGalleryJsOutput;
local.htmlOuput=local.imageGalleryHtmlOutput;
</cfscript>
