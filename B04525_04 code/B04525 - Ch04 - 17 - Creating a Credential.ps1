<#============================================================================
  File:     B04525 - Ch04 - 17 - Creating a Credential.ps1
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

$identity = "QUERYWORKS\filemanager"
$credentialName = "filemanagercredential"

#for purposes of our recipe
#we will drop the credential if it already exists if($server.Credentials[$credentialName])
{
 $server.Credentials[$credentialName].Drop()  
}
$credential=New-Object Microsoft.SqlServer.Management.Smo.Credential -ArgumentList  $server, $credentialName

#create credential
$credential.Create($identity, "YourSuperStrongPassword")

#list credentials
#confirm new credential is listed
$server.Credentials
