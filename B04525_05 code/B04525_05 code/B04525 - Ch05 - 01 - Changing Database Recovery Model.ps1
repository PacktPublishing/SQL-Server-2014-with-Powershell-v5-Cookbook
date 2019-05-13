<#============================================================================
  File:     B04525 - Ch05 - 01 - Changing Database Recovery Model.ps1
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
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$databasename = "AdventureWorks2014"
$database = $server.Databases[$databasename]

#possible values for RecoveryModel are
#Full, Simple and BulkLogged
$database.DatabaseOptions.RecoveryModel = [Microsoft.SqlServer.Management.Smo.RecoveryModel]::Simple
$database.Alter()
$database.Refresh()

#list Recovery Model again
$database.DatabaseOptions.RecoveryModel

#remember to change the recovery model back 
#to full for the next recipes
