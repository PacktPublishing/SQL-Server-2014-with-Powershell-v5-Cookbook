<#============================================================================
  File:     B04525 - Ch07 - 09 - Creating a Policy.ps1
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

$connectionString = "server='localhost';Trusted_Connection=true"
$conn = New-Object Microsoft.SQlServer.Management.Sdk.Sfc.SqlStoreConnection($connectionString)
$policyStore = New-Object Microsoft.SqlServer.Management.DMF.PolicyStore($conn)


$policyName = "xp_cmdshell must be disabled"
$conditionName = "xp_cmdshell is disabled"

if ($policyStore.Policies[$policyName])
{
   $policyStore.Policies[$policyName].Drop()
} 

#facet name this policy refers to
$selectedFacetDisplayName = "Server Security"
$selectedFacet = [Microsoft.SqlServer.Management.Dmf.PolicyStore]::Facets |
Where-Object DisplayName -eq $selectedFacetDisplayName

#create objectset
#objectset represents a policy-based management 
#set of objects
$objectsetName = "$($policyName)_ObjectSet"
$objectset = New-Object  Microsoft.SqlServer.Management.Dmf.ObjectSet($policyStore, $objectsetName)
$objectset.Facet = $selectedFacet.Name
$objectset.Create()
        
#to confirm, display objectset name
$objectset.Name
$policyStore.ObjectSets | 
Where-Object Name -eq $objectsetName | 
Format-List

#create policy
$policy = New-Object Microsoft.SQLServer.Management.Dmf.Policy ($conn, $policyName)

#assumption here is condition has been pre-created
#if not, see recipe for creating a condition
$policy.Condition=$conditionName
$policy.ObjectSet = $objectsetName
$policy.AutomatedPolicyEvaluationMode=[Microsoft.SqlServer.Management.Dmf.AutomatedPolicyEvaluationMode]::None
$policy.Create()

#confirm, display policies
$policyStore.Policies |
Where-Object Name -eq $policyName

