<cfcomponent extends="v1.Controller.View">
	<cffunction name="outputViewForm" access="private" returntype="string">
		<cfargument name="url" type="any" required="yes" />
        <cfscript>
		var htmlOutput="";
		var htmlForm="";
		var arNavSiteData=[];
		var arNavContextualData=[];
		var objTemplate={};
		var objForm={};
		var arObjectType=["Section","Content","Image","ImageGallery"];
		var arObjectTypeTitle=["New Section","New Content","New Image","New Image gallery"];
		
		objTemplate=createObject("component","v1.Controller.TemplateAdmin");
		objForm=createObject("component","v1.Controller.FormAdmin");
		
		htmlForm=objForm.outputForm(
			arguments.url
		)
		
		arNavSiteData=super.retrieveRelationshipMap(arExcludeType=["Image"]);
		
		// quick and nasty solution for Admin object creation menu
		for(i=1;i<=arrayLen(arObjectType);i++){
			arNavContextualData[i]=structNew();
			arNavContextualData[i].id=0;
			arNavContextualData[i].objectType=arObjectType[i];
			arNavContextualData[i].title=arObjectTypeTitle[i];
		}
		
		htmlOutput=objTemplate.outputHTMLPageForm(
			htmlForm,
			arNavSiteData,
			arNavContextualData
		);
		
		return htmlOutput;
		</cfscript>
    </cffunction>
</cfcomponent>