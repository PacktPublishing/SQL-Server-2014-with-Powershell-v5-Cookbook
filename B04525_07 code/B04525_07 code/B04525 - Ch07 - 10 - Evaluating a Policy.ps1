<#============================================================================
  File:     B04525 - Ch07 - 10 - Evaluating a Policy.ps1
  Author:   Donabel Santos (@sqlbelle | sqlbelle.com)
  Version:  SQL Server 2014, PowerShell V5
  Copyright: 2015
  ----------------------------------------------------------------------------

  This script is intended only as supplementary material to Packt's SQL Server 2014
  and PowerShell V5 book, and is downloadable from http://www.packtpub.com/
  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================#>

#import SQL Server module
Import-Module SQLPS -DisableNameChecking

$instanceName = "localhost"

$connectionString = "server='localhost';Trusted_Connection=true"

$conn = New-Object Microsoft.SQlServer.Management.Sdk.Sfc.SqlStoreConnection($connectionString)

$policyStore = New-Object Microsoft.SqlServer.Management.DMF.PolicyStore($conn)

$policyName = "xp_cmdshell must be disabled"

$policy = $policyStore.Policies[$policyName]

#evaluate using the Evaluate() method
$policy.Evaluate([Microsoft.SqlServer.Management.DMF.AdHocPolicyEvaluationMode]::Check,$conn)

#check evaluation history
Write-Host "$("=" * 100)`n Evaluation Histories`n$("=" * 100)" 
$policy.EvaluationHistories

#an alternative way to invoke a policy is 
#to use the Invoke-PolicyEvaluation cmdlet instead
#of using the Evaluate() method
#however you need to have a handle to the actual XML file
#this alternative way allows you to capture the results 
#which you can save to another XML file
#assuming we have this policy definition in 
$file = "C:\Temp\$($policyName).xml"
$result = Invoke-PolicyEvaluation -Policy $file -TargetServer $instanceName


#display results
Write-Host "$("=" * 100)`n Invocation Result`n$("=" * 100)" 
$result
