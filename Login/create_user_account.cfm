<cfsetting enablecfoutputonly="yes" />
<cfscript>
objUser=createObject("component","v1.Model.UserLoginAccount");

objUser.setUserName("administrator");
objUser.setPassword("d3p3ch3m0d3");
objUser.setCreatedDate(now());
objUser.setUpdatedDate(now());
objUser.create();
</cfscript>
<cfsetting enablecfoutputonly="no" />
