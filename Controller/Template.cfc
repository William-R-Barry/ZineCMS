<cfcomponent>
	<cfscript>
	variables.objectTemplatePath="";
	variables.hrefTemplatePath="";
	variables.urlView="";
	
	variables.settings={};
	variables.settings.navSiteType="";
	variables.settings.navContectualType="";
	
	variables.tags={};
	</cfscript>
    
    <cffunction name="renderTemplate" access="private" returntype="string">
    	<cfargument name="stTagContentPair" default="" type="struct" required="no" />
        <!--- - replace known tags with HTML snippets in a template - --->
        <cfscript>
		var templateHTML="";
		var arTagName=[];
		var tagName="";
		var i=0;
		
		templateHTML=this.loadTemplateFile();
		
		if(isDefined("arguments.stTagContentPair") && !structIsEmpty(arguments.stTagContentPair)){
			arTagName=structKeyArray(arguments.stTagContentPair);
			
			for(i=1;i<=arrayLen(arTagName);i++){
				tagName=arTagName[i];
				
				templateHTML=replace(
					templateHTML,
					tagName,
					arguments.stTagContentPair[tagName]
				);	
			}
		}
		
		return templateHTML;
		</cfscript>
    </cffunction>
    
    <cffunction name="loadTemplateFile" access="private" returntype="string">
        <!--- - load a template file from disk - --->
		<cfscript>
		var templateHTML="";
        
		templateHTML=fileRead(variables.templateFilePath);
        
		return templateHTML;
        </cfscript>
    </cffunction>
    
	<cffunction name="outputHTMLObject" access="private" returntype="struct">
        <cfargument name="object" type="any" required="yes" />
        <!--- - create an HTML snippet based on a model object - --->
        <cfscript>
		var local={};
		
		local.stView={}
		local.jsOutput="";
		local.htmlOuput="";
		local.object=arguments.object;
		local.objectType=local.object.getObjectType();
		
		// include view template based on the object type
		include "../" & variables.objectTemplatePath & local.objectType & ".cfm";
		
		local.stView.js="<script language=""javascript"" type=""text/javascript"">" & local.jsOutput & "</script>";
		local.stView.html=local.htmlOuput;
		
		return local.stView;
		</cfscript>
    </cffunction>

    <cffunction name="outputHTMLNavigation" access="private" returntype="string">
        <cfargument name="navigationData" type="array" required="yes" />
        <cfargument name="navigationType" type="string" required="yes" />
        <cfargument name="action" type="string" required="no" />
        <cfargument name="currentNavHTML" type="string" required="no" />
        <!--- - recursive function that creates HTML anchors based on model objects - --->
        <cfscript>
		var arNavData=arguments.navigationData;
		var navHTML=(isDefined("arguments.currentNavHTML")) ? arguments.currentNavHTML : "";
		var action=(isDefined("arguments.action")) ? arguments.action : "view";
		var href="";
		var anchorHTML="";
		var numberOfNavItems=arrayLen(arNavData);
		var i=0;
		
		if(uCase(arguments.navigationType)=="TEXT") navHTML=navHTML & "<div class=""nav_block"">";
		
		for(i=1;i<=numberOfNavItems;i++){
			href=variables.urlView
				& "?action=" & action
				& "&type=" & arNavData[i].objectType 
				& "&id=" & arNavData[i].id;
			
			anchorHTML="<a href=""" & href & """ id=""" 
				& arNavData[i].objectType
				& "_" 
				& arNavData[i].id & """";
			
			switch(uCase(arguments.navigationType)){
				case "TEXT": anchorHTML=anchorHTML & ">" & arNavData[i].title;
				 break;
				case "CSS": anchorHTML=anchorHTML & " class=""nav_button"">&nbsp;";
				 break;
			}
			
			anchorHTML=anchorHTML & "</a>";
			
			navHTML=navHTML & anchorHTML;
			
			if(structKeyExists(arNavData[i],"arSubNavItem")){
				navHTML=this.outputHTMLNavigation(
					arNavData[i].arSubNavItem,
					arguments.navigationType,
					action,
					navHTML
				);
			}
		}
		
		if(uCase(arguments.navigationType)=="TEXT") navHTML=navHTML & "</div>";
		
		return navHTML;
		</cfscript>
    </cffunction>
</cfcomponent>