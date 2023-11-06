<cfsetting enablecfoutputonly="yes" />
<cfscript>
objSecurity=createObject("component","v1.Controller.Security");

htmlOutput="";
userName="";

if(isDefined("form.fieldNames")){
	userLoggedIn=objSecurity.loginUser(
		form.user_name,
		form.user_password
	);
	
	if(userLoggedIn){
		location(application.url.admin.view,false);
	}
	else{
		userName=form.user_name;
	}
}

htmlOutput=htmlOutput & "<div class=""user_login"">"
	& "<form action=""" & application.url.admin.processLoginAttempt & """ enctype=""multipart/form-data"" id=""user_login"" method=""post"" name=""user_login"">"
	& "User name"
	& "<input type=""text"" id=""user_name"" name=""user_name"" value=""" & userName & """ />"
	& "Password"
	& "<input type=""password"" id=""user_password"" name=""user_password"" />"
	& "<input type=""submit"" id=""user_login_submit"" name=""user_login_submit"" value=""Login"" />"	
	& "</form>"

if(isDefined("loginFailed")){
	htmlOutput=htmlOutput & "<p class=""alert""><strong>Login failed!</strong></p>"
		& "<p class=""alert"">Please check you user name and password and try again.</p>";
}

htmlOutput=htmlOutput & "</div>";

</cfscript>
<cfsetting enablecfoutputonly="no" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" Content="text/html; charset=utf-8" />
<title>::User login</title>
<link href="<cfoutput>#application.url.public.base#</cfoutput>Login/Resources/CSS/default.css" type="text/css" rel="stylesheet" />
</head>
<body>
<cfscript>
    writeOutput(htmlOutput);
</cfscript>
</body>
</html>

