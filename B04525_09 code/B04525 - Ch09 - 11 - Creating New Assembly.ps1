<#============================================================================
  File:     B04525 - Ch09 - 11 - Creating New Assembly.ps1
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
$databaseName = "SampleDB"
$assemblyName = "QueryWorksCLR"
$assemblyFile = "C:\CLR Files\QueryWorksCLR.dll"

#this is for SAFE assemblies only
$query = @"
CREATE ASSEMBLY $assemblyName 
FROM '$assemblyFile'
WITH PERMISSION_SET = SAFE
"@

Invoke-Sqlcmd -ServerInstance $instanceName -Database $databaseName -Query $query
