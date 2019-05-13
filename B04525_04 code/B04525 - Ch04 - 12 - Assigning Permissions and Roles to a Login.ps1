<#============================================================================
  File:     B04525 - Ch04 - 12 - Assigning Permissions and Roles to a Login.ps1
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

#assumption is this login already exists
$loginName = "eric"
 
#assign server level roles
$login = $server.Logins[$loginName]
$login.AddToRole("dbcreator")
$login.AddToRole("setupadmin")
$login.Alter()

#grant server level permissions
$permissionset = New-Object Microsoft.SqlServer.Management.Smo.ServerPermissionSet([Microsoft.SqlServer.Management.Smo.ServerPermission]::AlterAnyDatabase)
$permissionset.Add([Microsoft.SqlServer.Management.Smo.ServerPermission]::AlterSettings)
$server.Grant($permissionset, $loginName)

#confirm server roles
Write-Output "Memberships:"
$login.ListMembers()

#confirm permissions
$server.EnumServerPermissions($loginName) | 
Select-Object Grantee, PermissionType, PermissionState | 
Format-Table -AutoSize
