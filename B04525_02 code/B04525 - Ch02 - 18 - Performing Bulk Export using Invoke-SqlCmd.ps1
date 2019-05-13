<#============================================================================
  File:     B04525 - Ch02 - 18 - Performing Bulk Export using Invoke-Sqlcmd.ps1
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

#replace this with your instance name
$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#database handle
$dbName = "AdventureWorks2014"
$db = $server.Databases[$dbName]

#export file name
$exportfile = "C:\Temp\Person_Person.csv"

$query = @"
SELECT 
   * 
FROM 
   Person.Person
"@
Invoke-Sqlcmd -Query $query -ServerInstance "$instanceName" -Database $dbName | 
Export-Csv -LiteralPath $exportfile -NoTypeInformation


