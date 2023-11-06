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
    <li><input type="checkbox" name="object_#local.i#" id="object_#local.i#" value="#local.arObject[local.i].getId()#::#local.arObject[local.i].getObjectType()#" />#local.arObject[local.i].getTitle()#</li>
</cfloop>
</ul>
</cfoutput>