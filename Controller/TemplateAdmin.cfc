<cfcomponent extends="v1.Controller.Template">
	<cfscript>
	variables.listObjectTemplatePath=application.templates.admin.listObject;
	variables.urlView=application.url.admin.view;
	variables.templateFilePath="../Admin/Templates/Pages/template_01.cfm";
	
	variables.settings.navSiteType="TEXT";
	variables.settings.navContectualType="TEXT";
	
	variables.tags.ContentBody="<$cms_admin_content>";
	variables.tags.navSite="<$cms_admin_site_navigation>";
	variables.tags.navContextual="<$cms_admin_sub_navigation>";
	</cfscript>
    
    <cffunction name="outputHTMLPageForm" access="public" returntype="string">
    	<cfargument name="formHTML" type="string" required="no" />
    	<cfargument name="arNavSiteData" type="array" required="no" />
        <cfargument name="arNavContextualData" type="array" required="no" />
    	<!--- - create HTML based on a form html, navigation data and a template - --->
        <cfscript>
		var htmlOutput="";
		var htmlNavSite="";
		var htmlNavContextual="";
		var stTagContentPair={};
		
		htmlNavSite=super.outputHTMLNavigation(
			arguments.arNavSiteData,
			variables.settings.navSiteType,
			"update"
		);
		
		htmlNavContextual=super.outputHTMLNavigation(
			arguments.arNavContextualData,
			variables.settings.navContectualType,
			"create"
		);
		
		stTagContentPair[variables.tags.ContentBody]=arguments.formHTML;
		stTagContentPair[variables.tags.navSite]=htmlNavSite;
		stTagContentPair[variables.tags.navContextual]=htmlNavContextual;
		
		htmlOutput=super.renderTemplate(stTagContentPair);
		
		return htmlOutput;
		</cfscript>
    </cffunction>
</cfcomponent>