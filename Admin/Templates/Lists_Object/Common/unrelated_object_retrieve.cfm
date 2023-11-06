<!--- -

This template is intended to be used in conjuction with object list templates.
It supplies generic related object list code. Any changes must be checked for
compatibilty with the object list templates.

This template is intended to be used in conjuction with Controller.Form
The "local" scope and contained variables are defeind in Controller.Form

- --->
<cfscript>
local.arObject=[];

local.arRelatedTo=[];

// check that the type is valid for the parent object
if(arrayContainsNoCase(local.object.getRelatedTo(),local.relatedObjectType)>0){
	arrayAppend(local.arRelatedTo,local.relatedObjectType);
}

// retrieve related object not currently in a relationship with the parent
for(local.i=1;local.i<=arrayLen(local.arRelatedTo);local.i++){
	local.relatedObjectType=local.arRelatedTo[local.i];
	
	local.qryRelatives=new Query();
	local.sqlStatement="
		SELECT " & local.relatedObjectType & ".id
		FROM " & local.relatedObjectType & "
		WHERE " & local.relatedObjectType & ".id NOT IN(
			SELECT ObjectRelationship.childId
				FROM  ObjectRelationship
				WHERE ObjectRelationship.childType=:childType
			)";
	
	if(local.object.isIdValid()){ 
		
		// filter query by the parent object's ID
		local.sqlStatement=local.sqlStatement & " AND " & local.relatedObjectType & ".id NOT IN(
			SELECT ObjectRelationship.childId
				FROM  ObjectRelationship
				WHERE
					ObjectRelationship.parentId=:parentId
					AND ObjectRelationship.parentType=:parentType
					AND ObjectRelationship.childType=:childType
			)";
	}
	
	local.qryRelatives.setName("retrieveRelatives");
	local.qryRelatives.setSQL(sqlStatement);
	
	local.qryRelatives.addParam(
		name="parentId",
		value=local.object.getId(),
		cfsqltype="CF_SQL_SMALLINT"
	);
	local.qryRelatives.addParam(
		name="parentType",
		value=local.object.getObjectType(),
		cfsqltype="CF_SQL_VARCHAR"
	);
	local.qryRelatives.addParam(
		name="childType",
		value=local.relatedObjectType,
		cfsqltype="CF_SQL_VARCHAR"
	);
	
	local.qryResult=local.qryRelatives.execute().getResult();
	
	for(local.j=1;local.j<=local.qryResult.recordCount;local.j++){
		local.objRelative=createObject("component","v1.Model." & local.relatedObjectType);
		local.objRelative.setId(qryResult.id[local.j]);
		local.objRelative.retrieve();
		
		arrayAppend(local.arObject,local.objRelative);
	}
}
</cfscript>