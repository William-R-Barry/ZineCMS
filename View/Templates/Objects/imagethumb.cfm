<!--- - 

This template is intended to be used in conjuction with Controller.ViewPublic
The "local" scope and contained variables are defeind in Controller.ViewPublic

 - --->

<cfscript>
local.imageThumbHtmlOutput="";

local.thumb=local.object.retrieveThumb();
local.thumb.retrieve();

local.imageId=local.thumb.getId();
local.imageTitle=local.thumb.getTitle();
local.imageUrlSrc=application.url.public.contentImageThumbFolder & local.thumb.getFileName();
local.imageWidth=local.thumb.getWidth();
local.imageHeight=local.thumb.getHeight();

local.imageTagId="thumb_" & local.imageId;

local.imageThumbHtmlOutput="<img alt=""" & local.imageTitle & """"
	& " src=""" & local.imageUrlSrc & """"
    & " class=""image"""
    & " height=""" & local.imageHeight & """"
    & " width=""" & local.imageWidth & """"
    & " id=""" & local.imageTagId & """ />";
</cfscript>