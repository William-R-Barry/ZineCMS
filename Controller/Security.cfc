<cfcomponent>
	<cffunction name="isUserLoggedIn" access="public" returntype="boolean">
    	<cfscript>
		var userIsLoggedIn=false;
		
		if(!structIsEmpty(session)
		&& structKeyExists(session,"userLoginDateTime")
		&& structKeyExists(session,"userAccount")
		){
			userIsLoggedIn=true;
		}
		
		return userIsLoggedIn;
		</cfscript>
    </cffunction>

	<cffunction name="loginUser" access="public" returntype="boolean">
		<cfargument name="userName" type="string" required="yes">
        <cfargument name="password" type="string" required="yes">
        
    	<cfscript>
		var loginSuccessful=false;
		var objUser=createObject("component","v1.Model.UserLoginAccount");
		
		objUser.setUserName(arguments.userName);
		objUser.setPassword(arguments.password);
		
		try{
			objUser.retrieve();
			
			loginSuccessful=true;
		}
		catch(Any error){
			// do nothing
		}
		
		if(loginSuccessful){
			this.setupUserSession(objUser);	
		}
		
		return loginSuccessful;
		</cfscript>
	</cffunction>

	<cffunction name="logOutUser" access="public" returntype="void">
		<cfscript>
		structClear(session);
		</cfscript>
	</cffunction>
    
    <cffunction name="setupUserSession" access="public" returntype="void">
		<cfargument name="user" type="v1.Model.UserLoginAccount" required="yes" />
        
    	<cfscript>
		structClear(session);
		
		session.userLoginDateTime=now();
		session.userAccount=arguments.user;
		</cfscript>
	</cffunction>

    <cffunction name="retrieveUser" access="public" returntype="v1.Model.UserLoginAccount">
		<cfscript>
		return session.userAccount;
		</cfscript>
	</cffunction>
</cfcomponent>