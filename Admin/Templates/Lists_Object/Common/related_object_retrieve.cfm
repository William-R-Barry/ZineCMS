<!--- -

This template is intended to be used in conjuction with object list templates.
It supplies generic related object list code. Any changes must be checked for
compatibilty with the object list templates.

This template is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

- --->
<cfscript>
local.arObject=[];

local.arObject=local.object.retrieveRelativesByType(local.relatedObjectType);

for(local.i=1;local.i<=arrayLen(local.arObject);local.i++){
	local.arObject[local.i].retrieve();
}
</cfscript>