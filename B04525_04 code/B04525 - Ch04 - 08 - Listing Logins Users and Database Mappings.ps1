<#============================================================================
  File:     B04525 - Ch04 - 08 - Listing Logins Users and Database Mappings.ps1
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

#display login info
#these are two different ways of displaying login info
$server.Logins
$server.EnumWindowsUserInfo()

#List users, and database mappings
$server.Databases |
ForEach-Object {
   #capture database object
   $database = $_

   #capture users in this database
   $users = $database.Users

	#get only non-system objects
   $users | 
   Where-Object IsSystemObject -eq $false | 
   ForEach-Object {
      $result = [PSCustomObject] @{
         Login = $_.Login 
         User = $_.Name 
         DBName = $database.Name
         LoginType = $_.LoginType
         UserType = $_.UserType
      }
      #display current object
      $result
   }
} |
Format-Table -AutoSize
