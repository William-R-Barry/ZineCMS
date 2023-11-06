<cfcomponent extends="v1.Controller.DisplayController">
	<cffunction name="processRequest" access="public" returntype="any">
		<cfargument name="url" type="any" required="yes" />
        <cfargument name="form" type="any" required="yes" />
        <!--- - process a form request - --->
        <cfscript>
		var object={};
		
		parentObject=this.processForm(arguments.url,arguments.form);
		
        return object;
        </cfscript>
	</cffunction>
    
    <cffunction name="outputForm" access="public" returntype="string">
    	<cfargument name="url" type="any" required="yes" />
    	<!--- - place holder to be defined in child form object - --->
    </cffunction>
    
	<cffunction name="processForm" access="public" returntype="void">
    	<cfargument name="url" type="any" required="yes" />
        <cfargument name="form" type="any" required="yes" />
    	<!--- - place holder to be defined in child form object - --->
    </cffunction>
    
    <cffunction name="outputObejct" access="private" returntype="string">
		<cfargument name="action" type="string" required="yes" />
        <cfargument name="object" type="any" required="yes" />
        <cfargument name="formActionURL" type="string" required="no" />
		<!--- - place holder to be defined in child form object - --->
    	<cfreturn "" />
    </cffunction>
    
    <cffunction name="outputRelatedObjectList" access="private" returntype="string">
		<cfargument name="action" type="string" required="yes" />
        <cfargument name="object" type="any" required="yes" />
        <cfargument name="relatedObjectType" type="string" required="yes" />
        <cfargument name="formActionURL" type="string" required="no" />
		<!--- - place holder to be defined in child form object - --->
    	<cfreturn "" />
    </cffunction>
    
    <cffunction name="processObject" access="private" returntype="void">
		<cfargument name="action" type="string" required="yes" />
        <cfargument name="object" type="any" required="yes" />
        <cfargument name="data" type="any" required="yes" />
		<!--- - place holder to be defined in child form object - --->
    </cffunction>
    
	<cffunction name="processRelatedObjectList" access="private" returntype="void">
    	<cfargument name="action" type="string" required="yes" />
        <cfargument name="object" type="any" required="yes" />
        <cfargument name="data" type="any" required="yes" />
		<!--- - place holder to be defined in child form object - --->
    </cffunction>
</cfcomponent>