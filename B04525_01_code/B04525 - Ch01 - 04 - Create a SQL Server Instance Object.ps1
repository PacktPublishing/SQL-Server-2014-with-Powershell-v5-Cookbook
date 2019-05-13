<#============================================================================
  File:     B04525 - Ch01 - 04 - Create a SQL Server Instance Object.ps1
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
#import SQLPS module
Import-Module SQLPS –DisableNameChecking

#create a variable for your instance name
$instanceName = "localhost"

#create your server instance
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#set connection to mixed mode
$server.ConnectionContext.set_LoginSecure($false)

#set the login name
#of course we don’t want to hardcode credentials here
#so we will prompt the user
#note password is passed as a SecureString type
$credentials = Get-Credential

#remove leading backslash in username
$login = $credentials.UserName -replace("\\", "")
$server.ConnectionContext.set_Login($login) 
$server.ConnectionContext.set_SecurePassword($credentials.Password)

#check connection string
$server.ConnectionContext.ConnectionString

Write-Verbose "Connected to $($server.Name)" 
Write-Verbose "Logged in as $($server.ConnectionContext.TrueLogin)"


