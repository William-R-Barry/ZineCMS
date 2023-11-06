<!--- - 

This processing script is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

 - --->

<cfscript>
local.published=(isDefined("local.data.Image_published"));

if(isDefined("local.data.Image_file_upload")){
	// an Image file has been submited
	ImageUploadFile=fileUpload(
		destination=application.resource.ContentImageFolder,
		fileField=local.data.Image_file_upload,
		nameConflict="MakeUnique"
	);
	
	// *** set Image record attributes ***	
	ImageFile=ImageRead(ImageUploadFile.serverDirectory & "\" & ImageUploadFile.serverFile);
	
	local.object.setFileName(ImageUploadFile.serverFile);
	local.object.setFilePath(application.resource.ContentImageFolder);
	local.object.setWidth(ImageGetWidth(ImageFile));
	local.object.setHeight(ImageGetHeight(ImageFile));
	
	// save Image record to ensure the parent Image has lower Id than the thumb
	objSecurity=createObject("component","v1.Controller.Security");
	objUser=objSecurity.retrieveUser();
	
	local.object.save(objUser);
	
	// *** create Image thumb nail file and record ***
	ImageScaleToFit(
		ImageFile,
		application.attribute.ImageThumb.maxWidth,
		application.attribute.ImageThumb.maxHeight
	);
	
	ImageWrite(
		ImageFile,
		application.resource.ContentImageThumbFolder & ImageUploadFile.serverFile
	);
	
	local.imageThumb=createObject("component","v1.Model.Image");
	
	local.imageThumb.setTitle(local.data.Image_title & " - Thumbnail");
	local.imageThumb.setFileName(ImageUploadFile.serverFile);
	local.imageThumb.setFilePath(application.resource.ContentImageThumbFolder);
	local.imageThumb.setWidth(ImageGetWidth(ImageFile));
	local.imageThumb.setHeight(ImageGetHeight(ImageFile));
	
	objSecurity=createObject("component","v1.Controller.Security");
	objUser=objSecurity.retrieveUser();

	local.imageThumb.save(objUser);
	
	local.object.attachThumb(local.imageThumb);
}

local.object.setTitle(local.data.Image_title);
local.object.setPublished(local.published);

local.object.save();
</cfscript>