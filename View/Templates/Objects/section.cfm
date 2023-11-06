<!--- - 

This template is intended to be used in conjuction with Controller.ViewPublic
The "local" scope and contained variables are defeind in Controller.ViewPublic

 - --->

<cfscript>
local.jsOutput="";
local.htmlOuput="";
local.sectionJsOutput="";
local.sectionHtmlOutput="";

local.sectionId=local.object.getId();
local.sectionTitle=local.object.getTitle();
local.sectionArContent=local.object.retrieveRelativesByTypeSortedBy("Content","DATEWRITTEN");
</cfscript>

<cfsaveContent variable="local.htmlOuput">
<cfoutput>
<div class="section" id="section_#local.sectionId#">
	<h1>#local.sectionTitle#</h1>
</cfoutput>
</cfsaveContent>
	<cfscript>
	local.sectionHtmlOutput=local.sectionHtmlOutput & local.htmlOuput;
	// retrieve Content items
	for(local.sectionIndex=1;local.sectionIndex<=arrayLen(local.sectionArContent);local.sectionIndex++){
		// set Content as local object for use in the Content template
		local.object=local.sectionArContent[local.sectionIndex];
		local.object.retrieve();
		
		if(local.object.isPublished()){
			// include Content template
			include "Content.cfm";
			// add Image Gallery JS to Content JS
			local.sectionJsOutput=local.sectionJsOutput & local.contentJsOutput;
			// add Content html to Section html
			local.sectionHtmlOutput=local.sectionHtmlOutput & local.htmlOuput;
		}
	}
	</cfscript>
<cfsaveContent variable="local.htmlOuput">
<cfoutput>
</div>
</cfoutput>
</cfsaveContent>

<cfscript>
local.sectionHtmlOutput=local.sectionHtmlOutput & local.htmlOuput;

local.jsOutput=local.sectionJsOutput;
local.htmlOuput=local.sectionHtmlOutput;
</cfscript>
