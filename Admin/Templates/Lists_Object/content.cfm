<!--- - 

This template is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

 - --->
<cfscript>
local.postButtonTitle="Attach";

switch(uCase(local.action)){
	case "ATTACH":
		local.postButtonTitle="Attach";
		
		include "Common/unrelated_object_retrieve.cfm";
	 break;
	case "DETACH":
		local.postButtonTitle="Detach";
		
		include "Common/related_object_retrieve.cfm";
	 break;
}
</cfscript>

<cfsaveContent variable="local.formListOuput">
<cfoutput>
<form action="#local.formActionURL#" method="post">
	<!--- - gui form elements - --->
    <cfinclude template="Common/object_display_title.cfm" />
    <input type="button" name="Content_execute_action" id="Content_execute_action" onClick="javascript:submit();" value="#local.postButtonTitle#" />
</form>
</cfoutput>
</cfsaveContent>