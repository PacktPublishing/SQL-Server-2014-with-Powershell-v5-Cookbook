<#============================================================================
  File:     B04525 - Ch04 - 13 - Creating a Database User.ps1
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

$loginName = "eric"

#get login
$login = $server.Logins[$loginName]

#add a database mapping
$databasename = "AdventureWorks2014"
$database = $server.Databases[$databasename]

if($database.Users[$dbUserName])
{
   $database.Users[$dbUserName].Drop()
}

$dbUserName = "eric"

#code to create database user is all in one line
$dbuser = New-Object -TypeName Microsoft.SqlServer.Management.Smo.User -ArgumentList $database, $dbUserName

$dbuser.Login = $loginName
$dbuser.Create()
