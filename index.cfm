<cfsetting enablecfoutputonly="yes" />
<cfscript>
application.settings.cache.active=false;
if(application.settings.cache.active){
	objViewCache=createObject("component","v1.Controller.ViewCache");
	htmlOutput=objViewCache.get(url);
}
else{
	objView=createObject("component","v1.Controller.ViewPublic");
	htmlOutput=objView.processRequest(url);
}
</cfscript>
<cfsetting enablecfoutputonly="no" />

<cfscript>
writeOutput(htmlOutput);
</cfscript>