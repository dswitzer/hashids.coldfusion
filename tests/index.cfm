<cfinvoke component="mxunit.runner.DirectoryTestSuite"
			method="run"
			directory="#expandPath('/tests')#"
			componentPath="tests"
			recurse="true"
			returnvariable="results" />

<cfoutput>#results.getResultsOutput('extjs')# </cfoutput>
