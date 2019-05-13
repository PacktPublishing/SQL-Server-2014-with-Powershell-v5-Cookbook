<#============================================================================
  File:     B04525 - Ch07 - 06 - Importing a Policy.ps1
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

#set up connection
$conn = New-Object Microsoft.SQlServer.Management.Sdk.Sfc.SqlStoreConnection($connectionString)

#NOTE this is still called DMF, which stands for
#PBM’s old name, Declarative Management Framework
$policyStore = New-Object Microsoft.SqlServer.Management.DMF.PolicyStore($conn)

#you can replace this with your own file 
$policyXmlPath = "C:\Program Files (x86)\Microsoft SQL Server\120\Tools\Policies\DatabaseEngine\1033\Database Page Verification.xml"

$xmlReader = [System.Xml.XmlReader]::Create($policyXmlPath)

#ready to import
$policyStore.ImportPolicy($xmlReader, [Microsoft.SqlServer.Management.Dmf.ImportPolicyEnabledState]::Unchanged, $true, $true)

#list policies to confirm
$policyStore.Policies

