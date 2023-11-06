<!--- - 

This template is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

 - --->

<cfscript>
local.postButtonTitle="Save";

local.contentId=local.object.getId();
local.contentTitle=local.object.getTitle();
local.contentQuote=local.object.getQuote();
local.contentBody=local.object.getBody();
local.contentWrittenBy=local.object.getWrittenBy();
local.contentWrittenDate=local.object.getWrittenDate();

if(uCase(local.action)=="CREATE"){
	local.contentIsPublished=true;
	local.contentIsFeatured=false;
}
else{
	local.contentIsPublished=local.object.isPublished();
	local.contentIsFeatured=local.object.isFeatured();
}

// create form HTML output
local.formOuput="<form action=""" & local.formActionURL & """ method=""post"">"
	& "Article title"
	& "<input type=""text"" name=""content_title"" id=""content_title"" value=""" & local.contentTitle & """ />"
    & "Article quote"
    & "<textarea name=""content_quote"" id=""content_quote"">" & local.contentQuote & "</textarea>"
    & "Article Content" 
    & "<textarea name=""content_body"" id=""content_body"">" & local.contentBody & "</textarea>"
	& "<input type=""text"" name=""content_written_by"" id=""content_written_by"" value=""" & local.contentWrittenBy & """ />"
	& "<input type=""text"" name=""content_written_date"" id=""content_written_date"" value=""" & local.contentWrittenDate & """ />"
	& "<input type=""checkbox"" name=""content_published"" id=""content_published"" value=""published""";
	if(local.contentIsPublished) local.formOuput=local.formOuput & " checked=""checked""";
	local.formOuput=local.formOuput & " /> Published"
	& " <input type=""checkbox"" name=""content_featured"" id=""content_featured"" value=""featured""";
	if(local.contentIsFeatured) local.formOuput=local.formOuput & " checked=""checked""";
	local.formOuput=local.formOuput & " /> Featured<br />"
	& "<input type=""button"" name=""content_execute_save"" id=""content_execute_save"" onClick=""javascript:submit();"" value=""" & local.postButtonTitle & """ />"
	& "</form>";
</cfscript>
