<#============================================================================
  File:     B04525 - Ch04 - 14 - Assigning Permissions to a Database User.ps1
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

$databasename = "AdventureWorks2014"
$database = $server.Databases[$databasename]

#get a handle to the database user we want 
#to assign permissions to
$dbusername = "eric"
$dbuser = $database.Users[$dbusername]

#assign ALTER DATABASE permission
$permissionset = New-Object Microsoft.SqlServer.Management.Smo.DatabasePermissionSet([Microsoft.SqlServer.Management.Smo.DatabasePermission]::Alter)

#assign CREATE TABLE permission
$permissionset.Add([Microsoft.SqlServer.Management.Smo.DatabasePermission]::CreateTable) | Out-Null

#grant the permissions
$database.Grant($permissionset, $dbuser.Name)

#confirm permissions
$database.EnumDatabasePermissions($dbuser.Name) |
Select-Object PermissionState, PermissionType, Grantee 
