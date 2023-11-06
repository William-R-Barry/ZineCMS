<cfcomponent displayname="Application" output="true" hint="Handle the application.">
 
	<!--- - set up the application - --->
    <cfscript>
    this.name="ZineCMS";
    this.applicationTimeout=CreateTimeSpan(1,0,0,0);
    this.sessionManagement=true;
    this.setClientCookies=true;
	
	this.mappings.v1=getDirectoryFromPath(getCurrentTemplatePath());
	
	this.datasource="ZineCMS";
    </cfscript> 
     
    <!--- - define the page request properties - --->
    <cfsetting requesttimeout="20" showdebugoutput="true" enablecfoutputonly="false" />
     
    <cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false" hint="Fires when the application is first created.">
        <cfscript>
		// *** define global application settings ***
		application.settings={};
		
		application.settings.cache={};
		application.settings.cache.active=true;
		
		// *** define global application attributes ***
		application.attribute={};

		application.attribute.ImageThumb={};
		application.attribute.ImageThumb.maxWidth=75;
		application.attribute.ImageThumb.maxHeight=75;
		
		application.attribute.gallery={};
		application.attribute.gallery.maxWHDimension=383;
		
		// *** define application path parts ***
		application.path={};
		
		application.path.view="View/";
		application.path.fileUpload="File_Upload/";
		application.path.ContentResources="Resources/";
		application.path.ContentImage="Content/Images/";
		application.path.ContentImageThumb=application.path.ContentImage & "Thumbs/";
		application.path.admin="Admin/";
		application.path.login="Login/";
		
		// *** define application resource folders ***
		application.resource={};
		
		application.resource.uploadFolder=getDirectoryFromPath(getCurrentTemplatePath())
			& application.path.admin
			& application.path.fileUpload;
		application.resource.Content=getDirectoryFromPath(getCurrentTemplatePath())
			& application.path.view
			& application.path.ContentResources;
		application.resource.ContentImageFolder=application.resource.Content 
			& application.path.ContentImage;
		application.resource.ContentImageThumbFolder=application.resource.Content 
			& application.path.ContentImageThumb
		
		// *** define URLs ***
		application.url={};
		
		// local test URL
		application.url.base="http://" & cgi.server_name & "/";
		application.url.stagingFolder="ZineCMS/v1/";
		// live URL
		/*
		application.url.base="http://www.ZineCMS.com/";
		application.url.stagingFolder="";
		*/
		
		application.url.public={};
		application.url.public.base=application.url.base 
			& application.url.stagingFolder;
		application.url.public.view={};
		application.url.public.view=application.url.public.base
			& "index.cfm";
		application.url.public.form={};
		application.url.public.form=application.url.public.base
			& "index.cfm";
		application.url.public.contentImageFolder=application.url.public.base
			& application.path.view
			& application.path.ContentResources
			& application.path.ContentImage;
		application.url.public.contentImageThumbFolder=application.url.public.base
			& application.path.view
			& application.path.ContentResources
			& application.path.ContentImageThumb;
		
		application.url.admin={};
		application.url.admin.base=application.url.base 
			& application.url.stagingFolder
			& application.path.admin;
		application.url.admin.view={};
		application.url.admin.view=application.url.admin.base
			& "index.cfm";
		application.url.admin.form={};
		application.url.admin.form=application.url.admin.base
			& "index.cfm";
		application.url.admin.login={};
		application.url.admin.login=application.url.public.base
			& application.path.login
			& "login.cfm";
		application.url.admin.processLoginAttempt={};
		application.url.admin.processLoginAttempt=application.url.public.base
			& application.path.login
			& "process_user_login_attempt.cfm";
		
		// *** define template & code snippets ***
		application.templates={};
		
		application.templates.public={};
		application.templates.public.object=application.path.view & "Templates/Objects/";
		application.templates.public.listObject=application.path.view & "Templates/Lists_Object/";
		
		application.templates.admin={};
		application.templates.admin.form=application.path.admin & "Templates/Forms/";
		application.templates.admin.listObject=application.path.admin & "Templates/Lists_Object/";
		
		application.processing={};
		
		application.processing.admin={};
		application.processing.admin.form=application.path.admin & "Processing/Forms/";
		application.processing.admin.listObject=application.path.admin & "Processing/List_Object/";
		
		
		// *** define application errors *** 
		application.error={};
		
		application.error.db={};
	
		application.error.db.recordNotFound={};
		application.error.db.recordNotFound.type="RecordNotFound";
		application.error.db.recordNotFound.message="The database record was not found";
		application.error.db.recordNotFound.errorCode="1000";
		
		application.error.db.invalidRecordId={};
		application.error.db.invalidRecordId.type="InvalidRecordId";
		application.error.db.invalidRecordId.message="The record ID is invalid";
		application.error.db.invalidRecordId.errorCode="1001";
		
		application.error.cache={};

		application.error.cache.noEntryFound={}
		application.error.cache.noEntryFound.type="NoEntriesFound";
		application.error.cache.noEntryFound.message="No cache entries could be found";
		application.error.cache.noEntryFound.errorCode="2000";
		
		application.error.cache.multipleEntriesFound={}
		application.error.cache.multipleEntriesFound.type="MultipleEntriesFound";
		application.error.cache.multipleEntriesFound.message="Multiple cache entries were found";
		application.error.cache.multipleEntriesFound.errorCode="2001";
		
		application.error.object={};

		application.error.object.actionUnknown={}
		application.error.object.actionUnknown.type="ActionUnknown";
		application.error.object.actionUnknown.message="The requested action is unknown";
		application.error.object.actionUnknown.errorCode="3000";
		
		application.error.object.invalidRelationship={}
		application.error.object.invalidRelationship.type="InvalidRelationship";
		application.error.object.invalidRelationship.message="The object relationship is invalid";
		application.error.object.invalidRelationship.errorCode="3001";
		
		application.error.object.singleChildNotfound={}
		application.error.object.singleChildNotfound.type="SingleChildNotfound";
		application.error.object.singleChildNotfound.message="A single child was expected but not found";
		application.error.object.singleChildNotfound.errorCode="3002";
		
		application.error.url={};
		
		application.error.url.variableNotFound={}
		application.error.url.variableNotFound.type="VariableNotFound";
		application.error.url.variableNotFound.message="A required URL variable could not be found";
		application.error.url.variableNotFound.errorCode="4000";
		
		application.error.form={};
		
		application.error.form.variableNotFound={}
		application.error.form.variableNotFound.type="VariableNotFound";
		application.error.form.variableNotFound.message="A required form variable could not be found";
		application.error.form.variableNotFound.errorCode="5000";
		
        return true;
        </cfscript>
    </cffunction>
     
     
    <cffunction name="onSessionStart" access="public" returntype="void" output="false" hint="Fires when the session is first created.">
        <cfscript>
        return;
        </cfscript>
    </cffunction>
     
    <cffunction name="onRequestStart" access="public" returntype="boolean" output="false" hint="Fires at first part of page processing.">
        <cfargument name="targetPage" type="string" required="true" />
    
        <cfscript>
        return true;
        </cfscript>
    </cffunction>
    
    <cffunction name="OnRequest" access="public" returntype="void" output="true" hint="Fires after pre page processing is complete.">
        <cfargument name="targetPage" type="string" required="true" />
     
        <!--- Include the requested page. --->
        <cfinclude template="#arguments.targetPage#" />
    
        <cfscript>
        return;
        </cfscript>
    </cffunction>
     
     
    <cffunction name="OnRequestEnd" access="public" returntype="void" output="true" hint="Fires after the page processing is complete.">
    
        <cfscript>
        return;
        </cfscript>
    </cffunction>
    
    <cffunction name="OnSessionEnd" access="public" returntype="void" output="false" hint="Fires when the session is terminated.">
        <cfargument name="SessionScope" type="struct" required="true" />
        <cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
    
        <cfscript>
        return;
        </cfscript>
    </cffunction>
    
    <cffunction name="OnApplicationEnd" access="public" returntype="void" output="false" hint="Fires when the application is terminated.">
        <cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
     
        <cfscript>
        return;
        </cfscript>
    </cffunction>
    
<!---    <cffunction name="OnError" access="public" returntype="void" output="true" hint="Fires when an exception occures that is not caught by a try/catch.">
        <cfargument name="Exception" type="any" required="true" />
        <cfargument name="EventName" type="string" required="false" default="" />
    	
        <cfoutput>
        <cfinclude template="View/Templates/Pages/general_error.cfm" />
        </cfoutput>
    </cffunction> --->
	
</cfcomponent>