<cfcomponent extends="v1.Controller.Template">
	<cfscript>
	variables.objectTemplatePath=application.templates.public.object;
	variables.urlView=application.url.public.view;
	variables.templateFilePath="../View/Templates/Pages/template_01.cfm";
	
	variables.settings.navSiteType="CSS";
	variables.settings.navContectualType="TEXT";
	
    variables.tags.ContentBody="<$cms_content>";
	variables.tags.navSite="<$cms_site_navigation>";
	variables.tags.crumbTrail="<$cms_crumb_trail>";
	variables.tags.navContextual="<$cms_sub_navigation>";
	variables.tags.supportingJs="<$cms_supporting_js>";
    </cfscript>
    
    <cffunction name="outputHTMLPage" access="public" returntype="string">
		<cfargument name="object" type="any" required="yes" />
        <cfargument name="arNavSiteData" type="array" required="no" />
        <cfargument name="arCrumbTrailData" type="array" required="no" />
        <cfargument name="arNavContextualData" type="array" required="no" />
    	<!--- - create HTML based on a parent model object, navigation
				data and a template - --->
        <cfscript>
		var stTagContentPair={};
		var htmlOutput="";
		var htmlSupportingJs="";
		var htmlContent="";
		var createNavSite=(isDefined("arguments.arNavSiteData"));
		var htmlNavSite="";
		var createCrumbTrail=(isDefined("arguments.arCrumbTrailData"));
		var htmlCrumbTrail="";
		var createNavContextual=(isDefined("arguments.arNavContextualData"));
		var htmlNavContextual="";
		
		if(arguments.object.getId()>0){
			if(!arguments.object.isDataLoaded()) arguments.object.retrieve();
			stView=super.outputHTMLObject(arguments.object);
			htmlSupportingJs=stView.js;
			htmlContent=stView.html;
		}
		else{
			htmlContent="Record not found";
		}
		
		if(createNavSite){
			htmlNavSite=super.outputHTMLNavigation(
				arguments.arNavSiteData,
				variables.settings.navSiteType
			);
		}
		
		if(createCrumbTrail){
			htmlCrumbTrail=this.outputHTMLCrumbTrail(
				arguments.arCrumbTrailData
			);
		}
		
		if(createNavContextual){
			htmlNavContextual=super.outputHTMLNavigation(
				arguments.arNavContextualData,
				variables.settings.navContectualType
			);
		}
		
		stTagContentPair[variables.tags.ContentBody]=htmlContent;
		stTagContentPair[variables.tags.navSite]=htmlNavSite;
		stTagContentPair[variables.tags.crumbTrail]=htmlCrumbTrail;
		stTagContentPair[variables.tags.navContextual]=htmlNavContextual;
		stTagContentPair[variables.tags.supportingJs]=htmlSupportingJs;
		
		htmlOutput=super.renderTemplate(stTagContentPair);
		
		return htmlOutput;
		</cfscript>
    </cffunction>
    
    <cffunction name="outputHTMLCrumbTrail" access="private" returntype="string">
        <cfargument name="arCrumbTrailData" type="array" required="yes" />
        
        <cfscript>
		var arCTData=arguments.arCrumbTrailData;
		var numberOfItems=arrayLen(arCTData);
		var action="view";
		var href="";
		var anchorHTML="";
		var navHTML="";
		
		navHTML="<div class=""crumb_trail"">";
		
		for(i=1;i<=numberOfItems;i++){
			href=variables.urlView
				& "?action=" & action
				& "&type=" &  arCTData[i].type
				& "&id=" & arCTData[i].id;
			
			anchorHTML="<a href=""" & href & """ id=""" 
				& arCTData[i].type
				& "_" 
				& arCTData[i].id & """"
				& ">" & arCTData[i].title
				& "</a>";
			
			navHTML=navHTML & anchorHTML;
		}
		
		navHTML=navHTML & "</div>";
		
		return navHTML;
		</cfscript>
	</cffunction>
</cfcomponent>