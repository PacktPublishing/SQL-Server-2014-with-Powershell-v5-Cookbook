<#============================================================================
  File:     B04525 - Ch07 - 08 - Creating a Condition.ps1
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

$conditionName = "xp_cmdshell is disabled"

if ($policyStore.Conditions[$conditionName])
{
   $policyStore.Conditions[$conditionName].Drop()
}

#facet name 
#we are retrieving facet name in this manner because
#some facet names are different from the display names
#note this is PowerShell V3 syntax Where-Object syntax
$selectedFacetDisplayName = "Server Security"
$selectedFacet = [Microsoft.SqlServer.Management.Dmf.PolicyStore]::Facets |
Where-Object DisplayName -eq $selectedFacetDisplayName

#display, for visual reference
$selectedfacet.Name

#create condition
$condition = New-Object Microsoft.SqlServer.Management.Dmf.Condition($conn, $conditionName)
$condition.Facet = $selectedFacet.Name 

#a condition consists of a facet, an operator, 
#and a value to compare to
$op = [Microsoft.SqlServer.Management.Dmf.OperatorType]::EQ
$attr = New-Object Microsoft.SqlServer.Management.Dmf.ExpressionNodeAttribute("XPCmdShellEnabled")
$value = [Microsoft.SqlServer.Management.Dmf.ExpressionNode]::ConstructNode($false)

#create the expression node
#this is equivalent to “@XPCmdShellEnabled = false” 
$expressionNode = New-Object Microsoft.SqlServer.Management.Dmf.ExpressionNodeOperator($op, $attr, $value)

#display expression node that was constructed
$expressionNode

#assign the expression node to the condition, and create
$condition.ExpressionNode = $expressionNode
$condition.Create()

#confirm by displaying  conditions in PolicyStore
$policyStore.Conditions | 
Where-Object Name -eq $conditionName |
Select-Object Name, Facet, ExpressionNode |
Format-Table -AutoSize


