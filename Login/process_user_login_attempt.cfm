<cfsetting enablecfoutputonly="yes" />
<cfscript>
if(isDefined("form.fieldNames")){
	objSecurity=createObject("component","v1.Controller.Security");
	
	userLoggedIn=objSecurity.loginUser(
		form.user_name,
		form.user_password
	);
	
	if(userLoggedIn){
		location(application.url.admin.view,false);
	}
}

location(application.url.admin.login & "?loginFailed=true",false);
</cfscript>