<cfcomponent output="false">
	<!---// SET APPLICATION MAPPINGS //--->
	<cfset this.mappings["/tests"] = getDirectoryFromPath(getCurrentTemplatePath()) />
	<cfset this.mappings["/project"] = this.mappings["/tests"] & "../" />
	<cfset this.mappings["/com/utils"] = this.mappings["/project"] />

	<!---// APPLICATION CFC PROPERTIES //--->
	<cfset this.name = hash(this.mappings["/project"], "sha") />
	<cfset this.applicationTimeout = createTimespan(0, 0, 1, 0) />
	<cfset this.serverSideFormValidation = false />
	<cfset this.clientManagement = false />
	<cfset this.setClientCookies = false />
	<cfset this.setDomainCookies = false />
	<cfset this.sessionManagement = false />
	<cfset this.sessionTimeout = createTimeSpan(0, 0, 30, 0) />

</cfcomponent>