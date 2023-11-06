<cfcomponent>
	<cfscript>
	variables.objectType="UserLoginAccount";
	variables.id=0;
	variables.userName=""
	variables.password="";
	variables.createdBy=0
	variables.createdDate="";
	variables.updatedBy=0;
	variables.updatedDate="";
	</cfscript>
    
    <cffunction name="hashPassword" access="private" returntype="string">
    	<cfargument name="password" type="string" required="yes">
        
    	<cfscript>
		var hashedPassword=hash(
			arguments.password
		)
		
		return hashedPassword;
		</cfscript>
    </cffunction>
    
    <!--- - CRUD methods - --->    
    <cffunction name="create" access="public" returntype="string">
    	<cfargument name="user" type="v1.Model.UserLoginAccount" required="no">
        
    	<cfscript>
		var result={};
		var qryUserLoginAccountRetrieve=new Query();
		var sqlStatement="INSERT INTO UserLoginAccount(
				UserLoginAccount.userName,
				UserLoginAccount.password,
				UserLoginAccount.createdBy,
				UserLoginAccount.createdDate,
				UserLoginAccount.updatedBy,
				UserLoginAccount.updatedDate
			)
			VALUES(
				:userName,
				:password,
				:createdBy,
				:createdDate,
				:updatedBy,
				:updatedDate
			)";
		
		qryUserLoginAccountRetrieve.setName("UserLoginAccountCreate");
		qryUserLoginAccountRetrieve.setSQL(sqlStatement);
		qryUserLoginAccountRetrieve.addParam(
			name="userName",
			value=this.getUserName(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryUserLoginAccountRetrieve.addParam(
			name="password",
			value=this.getPassword(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryUserLoginAccountRetrieve.addParam(
			name="createdBy",
			value=this.getCreatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryUserLoginAccountRetrieve.addParam(
			name="createdDate",
			value=this.getCreatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryUserLoginAccountRetrieve.addParam(
			name="updatedDate",
			value=this.getUpdatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryUserLoginAccountRetrieve.addParam(
			name="updatedBy",
			value=this.getUpdatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		result=qryUserLoginAccountRetrieve.execute();
		
		this.setId(result.getPrefix().generatedKey);
		</cfscript>
    </cffunction>
    
    <cffunction name="retrieve" access="public" returntype="void">
		<cfscript>
		var qryUserLoginAccountRetrieve=new Query();
		var sqlStatement="";
		var qryResultUserLoginAccount={};
		
		sqlStatement="SELECT 
				UserLoginAccount.id,
				UserLoginAccount.userName,
				UserLoginAccount.password,
				UserLoginAccount.createdBy,
				UserLoginAccount.createdDate,
				UserLoginAccount.updatedBy,
				UserLoginAccount.updatedDate
			FROM UserLoginAccount
			WHERE UserLoginAccount.userName=:userName
				AND UserLoginAccount.password=:password";
		
		qryUserLoginAccountRetrieve.setName("UserLoginAccountRetrieve");
		qryUserLoginAccountRetrieve.setSQL(sqlStatement);
		qryUserLoginAccountRetrieve.addParam(
			name="userName",
			value=this.getUserName(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryUserLoginAccountRetrieve.addParam(
			name="password",
			value=this.getPassword(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryResultUserLoginAccount=qryUserLoginAccountRetrieve.execute().getResult();
        
		if(qryResultUserLoginAccount.recordCount==1){
			this.setId(qryResultUserLoginAccount.id);
			this.setUserName(qryResultUserLoginAccount.userName);
			this.setPassword(qryResultUserLoginAccount.password);
			this.setCreatedBy(qryResultUserLoginAccount.createdBy);
			this.setCreatedDate(qryResultUserLoginAccount.createdDate);
			this.setUpdatedBy(qryResultUserLoginAccount.updatedBy);
			this.setUpdatedDate(qryResultUserLoginAccount.updatedDate);
		}
		else {
			throw(
				type=application.error.db.recordNotFound.type,
				message=application.error.db.recordNotFound.message,
				errorcode=application.error.db.recordNotFound.errorcode
			);
		}
		</cfscript>
    </cffunction>
    
    <cffunction name="update" access="public" returntype="string">
    	<cfargument name="user" type="v1.Model.UserLoginAccount" required="yes">
        
		<cfscript>
		var qryUserLoginAccountRetrieve=new Query();
		var sqlStatement="UPDATE UserLoginAccount
			SET UserLoginAccount.userName=:userName,
				UserLoginAccount.password=:password,
				UserLoginAccount.createdBy=:createdBy,
				UserLoginAccount.createdDate=:createdDate,
				UserLoginAccount.updatedBy=:updatedBy,
				UserLoginAccount.updatedDate=:updatedDate
			WHERE UserLoginAccount.id=:id";
		
		qryUserLoginAccountRetrieve.setName("UserLoginAccountUpdate");
		qryUserLoginAccountRetrieve.setSQL(sqlStatement);
		qryUserLoginAccountRetrieve.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryUserLoginAccountRetrieve.addParam(
			name="userName",
			value=this.getUserName(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryUserLoginAccountRetrieve.addParam(
			name="password",
			value=this.getPassword(),
			cfsqltype="CF_SQL_VARCHAR"
		);
		qryUserLoginAccountRetrieve.addParam(
			name="createdBy",
			value=this.getCreatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryUserLoginAccountRetrieve.addParam(
			name="createdDate",
			value=this.getCreatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryUserLoginAccountRetrieve.addParam(
			name="updatedDate",
			value=this.getUpdatedDate(),
			cfsqltype="CF_SQL_TIMESTAMP"
		);
		qryUserLoginAccountRetrieve.addParam(
			name="updatedBy",
			value=this.getUpdatedBy(),
			cfsqltype="CF_SQL_SMALLINT"
		);
		qryUserLoginAccountRetrieve.execute();
		</cfscript>
    </cffunction>
    
    <cffunction name="delete" access="public" returntype="string">
		<cfscript>
		var qryUserLoginAccountRetrieve=new Query();
		var sqlStatement="DELETE FROM UserLoginAccount WHERE UserLoginAccount.id=:id";
		
		qryUserLoginAccountRetrieve.setName("UserLoginAccountDelete");
		qryUserLoginAccountRetrieve.setSQL(sqlStatement);
		qryUserLoginAccountRetrieve.addParam(
			name="id",
			value=this.getId(),
			cfsqltype="CF_SQL_INTEGER"
		);
		qryUserLoginAccountRetrieve.execute();
		</cfscript>
    </cffunction>
    
    <!--- - Set/Get methods - --->
    <cffunction name="setId" access="public" returntype="void">
		<cfargument name="id" type="numeric" required="yes">
	
    	<cfscript>
		variables.id=arguments.id;
		</cfscript>
    </cffunction>

    <cffunction name="getId" access="public" returntype="numeric">
		<cfscript>
		return variables.id
		</cfscript>
    </cffunction>

    <cffunction name="setUserName" access="public" returntype="void">
		<cfargument name="userName" type="string" required="yes">
	
    	<cfscript>
		variables.userName=arguments.userName;
		</cfscript>
    </cffunction>

    <cffunction name="getUserName" access="public" returntype="string">
		<cfscript>
		return variables.userName
		</cfscript>
    </cffunction>

    <cffunction name="setPassword" access="public" returntype="void">
		<cfargument name="password" type="string" required="yes">
	
    	<cfscript>
		variables.password=this.hashPassword(arguments.password);
		</cfscript>
    </cffunction>

    <cffunction name="getPassword" access="public" returntype="string">
		<cfscript>
		return variables.password
		</cfscript>
    </cffunction>

    <cffunction name="setCreatedBy" access="public" returntype="void">
		<cfargument name="createdBy" type="numeric" required="yes">
	
    	<cfscript>
		variables.createdBy=arguments.createdBy;
		</cfscript>
    </cffunction>

    <cffunction name="getCreatedBy" access="public" returntype="numeric">
		<cfscript>
		return variables.createdBy
		</cfscript>
    </cffunction>

    <cffunction name="setCreatedDate" access="public" returntype="void">
		<cfargument name="createdDate" type="date" required="yes">
	
    	<cfscript>
		variables.createdDate=arguments.createdDate;
		</cfscript>
    </cffunction>

    <cffunction name="getCreatedDate" access="public" returntype="date">
		<cfscript>
		return variables.createdDate
		</cfscript>
    </cffunction>

    <cffunction name="setUpdatedBy" access="public" returntype="void">
		<cfargument name="updatedBy" type="numeric" required="yes">
	
    	<cfscript>
		variables.updatedBy=arguments.updatedBy;
		</cfscript>
    </cffunction>

    <cffunction name="getUpdatedBy" access="public" returntype="numeric">
		<cfscript>
		return variables.updatedBy
		</cfscript>
    </cffunction>

    <cffunction name="setUpdatedDate" access="public" returntype="void">
		<cfargument name="updatedDate" type="date" required="yes">
	
    	<cfscript>
		variables.updatedDate=arguments.updatedDate;
		</cfscript>
    </cffunction>

    <cffunction name="getUpdatedDate" access="public" returntype="date">
		<cfscript>
		return variables.updatedDate
		</cfscript>
    </cffunction>
</cfcomponent>