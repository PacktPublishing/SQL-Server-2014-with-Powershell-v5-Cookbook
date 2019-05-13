<#============================================================================
  File:     B04525 - Ch04 - 09 - Listing Login User Roles and Permissions.ps1
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

#list all databases you want to query in an array
#alternatively you can read this from a file
$databases = @("AdventureWorks2014")

#we will temporarily store results in an array
#so it will easier to read and export
$results = @()

$databases |
ForEach-Object {
   #capture current database object
   $database = $server.Databases[$_]

   #capture users in this database
   $users = $database.Users

   #get all database users and list 
   #their properties and permissions
   $users | 
   Sort-Object -Property Name | 
   Where-Object IsSystemObject -eq $false |
   ForEach-Object {
      $user = $_

      #list all object permissions of current user
      $database.EnumObjectPermissions($user.Name) |
      ForEach-Object {
          $perm = $_
          $item = [PSCustomObject] @{
             Login = $user.Login 
             DBUser = $user.Name 
             DBName = $database.Name
             DBRoles = ($user.EnumRoles())
             Object = $perm.ObjectName
             Permission = $perm.PermissionType
          }
          #display current object
          $results += $item
      }
   }
} 

#display results
$results |
Format-Table -AutoSize
