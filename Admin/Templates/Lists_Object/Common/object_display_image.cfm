<!--- -

This template is intended to be used in conjuction with object list templates.
It supplies generic related object list code. Any changes must be checked for
compatibilty with the object list templates.

This template is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

- --->
<cfoutput>
<ul>
<cfloop from="1" to="#arrayLen(local.arObject)#" index="local.i">
    <cfscript>
	local.thumb=local.arObject[local.i].retrieveThumb();
	if(!local.thumb.isDataLoaded()) local.thumb.retrieve();
	
	local.imageTitle=local.thumb.getTitle();
	local.imageUrlSrc=application.url.public.contentImageThumbFolder & local.thumb.getFileName();
	local.imageWidth=local.thumb.getWidth();
	local.imageHeight=local.thumb.getHeight();
    </cfscript>
    <li><input type="checkbox" name="object_#local.i#" id="object_#local.i#" value="#local.arObject[local.i].getId()#::#local.arObject[local.i].getObjectType()#" /> <img alt="#local.imageTitle#" src="#local.imageUrlSrc#" width="#local.imageWidth#" height="#local.imageHeight#" /></li>
</cfloop>
</ul>
</cfoutput>