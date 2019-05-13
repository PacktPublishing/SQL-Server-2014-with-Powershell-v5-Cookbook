<#============================================================================
  File:     B04525 - Ch04 - 11 - Creating a Login.ps1
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

#for our recipe
#drop login if it exists
if ($server.Logins.Contains($loginName)) 
{    
   $server.Logins[$loginName].Drop() 
}

$login = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $server, $loginName

#specify SQL Login
$login.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::SqlLogin
$login.PasswordExpirationEnabled = $false

# prompt for password
$pw = Read-Host "Enter login password" –AsSecureString
$login.Create($pw)
