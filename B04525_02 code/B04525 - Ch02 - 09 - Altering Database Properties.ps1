<#============================================================================
  File:     B04525 - Ch02 - 09 - Altering Database Properties.ps1
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

#database
$dbName = "TestDB"

#we are going to assume db exists
$db = $server.Databases[$dbName]

#DatabaseOptions
#change ANSI NULLS and ANSI PADDING
$db.DatabaseOptions.AnsiNullsEnabled = $false
$db.DatabaseOptions.AnsiPaddingEnabled = $false

#change compatibility level to SQL Server 2012
#available CompatibilityLevel values
#for SQL Server 2014 are 
#Version 2008 ('Version100')
#Version 2012 ('Version110')
#Version 2014 ('Version120')
$db.AutoUpdateStatisticsEnabled = $true
$db.CompatibilityLevel = [Microsoft.SqlServer.Management.Smo.CompatibilityLevel]::Version110
$db.Alter()

#Change database access
#DatabaseUserAccess enumeration values: 
#multiple, restricted, single

$db.DatabaseOptions.UserAccess = [Microsoft.SqlServer.Management.Smo.DatabaseUserAccess]::Restricted
$db.Alter()

#some options are not available through the 
#DatabaseOptions property
#so we will need to access the database object directly
#set to readonly
$db.DatabaseOptions.ReadOnly = $true
$db.Alter()

