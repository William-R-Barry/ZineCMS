<cfcomponent extends="v1.Controller.DisplayController">
    <cffunction name="processRequest" access="public" returntype="string">
		<cfargument name="url" type="any" required="yes" />
        <cfargument name="viewType" default="VIEW" type="string" required="no" />
        <cfargument name="form" default="" type="any" required="no" />
        <cfargument name="areaType" default="PUBLIC" type="string" required="no" />
    	<!--- - process a view request by calling the appropriate function based on the
				requested action - --->
        <cfscript>
		var action=(isDefined("arguments.url.action")) ? arguments.url.action : "view";
		var output="";
		
		switch(uCase(arguments.viewType)){
			case "VIEW": output=this.outputView(
					arguments.url
				);
			 break;
			case "FORM": 
				output=this.outputViewForm(
					arguments.url
				);
			 break;
			case "JSON":
				output=this.outputViewJSON(
					arguments.url
				);
			default:
				// an invalid action was used
				throw(
					type=application.error.object.actionUnknown.type,
					message=application.error.object.actionUnknown.message,
					errorcode=application.error.object.actionUnknown.errorCode
				);
		}
		
		return output;
		</cfscript>
    </cffunction>

	<cffunction name="retrieveArCrumbTrail" access="public" returntype="array">
    	<cfargument name="objectType" type="string" required="yes" />
        <cfargument name="objectId" type="numeric" required="yes" />
        <cfargument name="arMapTrail" type="array" required="no" />
        <!--- - place holder to be defined in child form object - --->
        <cfreturn [] />
    </cffunction>
    
    <cffunction name="outputView" access="private" returntype="string">
		<cfargument name="url" type="any" required="yes" />
        <!--- - place holder to be defined in child form object - --->
    	<cfreturn "" />
    </cffunction>
    
    <cffunction name="outputViewJSON" access="private" returntype="string">
		<cfargument name="url" type="any" required="yes" />
        <!--- - place holder to be defined in child form object - --->
    	<cfreturn "" />
    </cffunction>
    
    <cffunction name="outputViewForm" access="private" returntype="string">
		<cfargument name="url" type="any" required="yes" />
        <!--- - place holder to be defined in child form object - --->
    	<cfreturn "" />
    </cffunction>
</cfcomponent>