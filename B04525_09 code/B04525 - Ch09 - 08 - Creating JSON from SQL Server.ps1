<#============================================================================
  File:     B04525 - Ch09 - 08 - Creating JSON from SQL Server.ps1
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

$VerbosePreference = "Continue"

$instanceName = "localhost"
$databaseName = "SampleDB"
$fileName = "C:\DATA\Customers.json"

Invoke-SqlCmd -Query "SELECT * FROM SampleText" -ServerInstance $instanceName -Database $databaseName |
ConvertTo-Json -Depth 1  |
Out-File -FilePath $fileName

$VerbosePreference = "SilentlyContinue"
