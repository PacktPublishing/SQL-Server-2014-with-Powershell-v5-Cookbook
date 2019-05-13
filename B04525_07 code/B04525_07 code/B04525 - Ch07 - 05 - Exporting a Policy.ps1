<#============================================================================
  File:     B04525 - Ch07 - 05 - Exporting a Policy.ps1
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

#policy to export
$policyName = "Password Expiry"

#where to export
$exportFolder = "C:\Temp\"

#set up connection
$conn = New-Object Microsoft.SQlServer.Management.Sdk.Sfc.SqlStoreConnection($connectionString)

#NOTE this is still called DMF, which stands for
#PBM’s old name, Declarative Management Framework
$policyStore = New-Object Microsoft.SqlServer.Management.DMF.PolicyStore($conn)

#get handle to policy you want to export
$policy = $policyStore.Policies[$policyName]

#where to export
$policyFileName = "$($policy.Name).xml"
$exportPath = Join-Path $exportFolder $policyFileName

#create an XML writer, to enable us to 
#write an XML file
$XMLWriter = [System.Xml.XmlWriter]::Create($exportPath)
$policy.Serialize($XMLWriter)
$XMLWriter.Close()

