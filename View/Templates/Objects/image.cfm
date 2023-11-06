<!--- - 

This template is intended to be used in conjuction with Controller.ViewPublic
The "local" scope and contained variables are defeind in Controller.ViewPublic

 - --->

<cfscript>
local.htmlOuput="";
local.imageHtmlOuput="";

local.imageId=local.object.getId();
local.imageTitle=local.object.getTitle();
local.imageUrlSrc=application.url.public.contentImageFolder & local.object.getFileName();
local.imageWidth=object.getWidth();
local.imageHeight=local.object.getHeight();

local.imageTagId="image_" & local.imageId;

if(isDefined("local.maxWHDimension")){
	local.stImageDimension=local.object.retrieveScaledDimensions(local.maxWHDimension);
	
	local.imageWidth=local.stImageDimension.width;
	local.imageHeight=local.stImageDimension.height;
}

local.imageHtmlOuput="<img alt=""" & local.imageTitle & """"
	& " src=""" & local.imageUrlSrc & """"
	& " class=""image"""
	& " width=""" & local.imageWidth & """"
	& " height=""" & local.imageHeight & """"
	&  " id=""" & local.imageTagId & """ />";

local.htmlOuput=local.imageHtmlOuput;
</cfscript>