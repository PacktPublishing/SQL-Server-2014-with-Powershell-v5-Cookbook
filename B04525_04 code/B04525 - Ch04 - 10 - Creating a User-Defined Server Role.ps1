<#============================================================================
  File:     B04525 - Ch04 - 00 - Name.ps1
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
$serverRoleName = "impersonator"

#for our exercise, we will drop the role
#if it already exists
if ($server.Roles[$serverRoleName])
{
   "Dropping"
   $server.Roles[$serverRoleName].Drop()
}

#create new server role
$serverRole = New-Object -TypeName Microsoft.SqlServer.Management.Smo.ServerRole -ArgumentList $server, $serverRoleName
$serverRole.Owner = "QUERYWORKS\Administrator"
$serverRole.Create()

#add member to this server role
$serverRole.AddMember("QUERYWORKS\tstark")

#assign permissions to this server role
$permissionset = New-Object Microsoft.SqlServer.Management.Smo.ServerPermissionSet([Microsoft.SqlServer.Management.Smo.ServerPermission]::ImpersonateAnyLogin)
$permissionset.Add([Microsoft.SqlServer.Management.Smo.ServerPermission]::UnsafeAssembly)
$server.Grant($permissionset, $serverRoleName)
$server.Alter()
$server.Refresh()

#list all custom server roles
$server.Roles | 
Where-Object IsFixedRole -eq $false 
