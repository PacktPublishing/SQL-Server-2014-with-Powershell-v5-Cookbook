<#============================================================================
  File:     B04525 - Ch04 - 15 - Creating a Database Role.ps1
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

#role
$rolename = "Custom Role"
if($database.Roles[$rolename])
{
   $database.Roles[$rolename].Drop()
}

#let’s assume this custom role, we want to grant
#everyone in this role select, insert access 
#to the HumanResources Schema, in addition to the 
#CreateTable permission

$dbrole = New-Object Microsoft.SqlServer.Management.Smo.DatabaseRole -ArgumentList $database, $rolename
$dbrole.Create()

#verify; list database roles
$database.Roles

#create a permission set to contain SELECT permissions
#for the HumanResources schema
$permissionset1 = New-Object Microsoft.SqlServer.Management.Smo.ObjectPermissionSet([Microsoft.SqlServer.Management.Smo.ObjectPermission]::Select)
$permissionset1.Add([Microsoft.SqlServer.Management.Smo.ObjectPermission]::Select)
$hrschema = $database.Schemas["HumanResources"] 
$hrschema.Grant($permissionset1, $dbrole.Name)

#create another permission set that contains 
#CREATE TABLE and ALTER on this database
$permissionset2 = New-Object Microsoft.SqlServer.Management.Smo.DatabasePermissionSet([Microsoft.SqlServer.Management.Smo.DatabasePermission]::CreateTable)
$permissionset2.Add([Microsoft.SqlServer.Management.Smo.DatabasePermission]::Alter)
$database.Grant($permissionset2, $dbrole.Name)

#to add member
#assume eric is already a user in the database
$username = "eric"
$dbrole.AddMember($username)

#confirm members of new role
$database.Roles[$rolename].EnumMembers()

#confirm permissions of new role
$database.EnumDatabasePermissions($dbrole.Name) |
Select-Object PermissionState, PermissionType,
              PermissionType, Grantee |
Format-Table -AutoSize

