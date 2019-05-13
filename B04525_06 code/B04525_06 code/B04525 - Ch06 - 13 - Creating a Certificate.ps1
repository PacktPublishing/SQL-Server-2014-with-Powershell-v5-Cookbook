<#============================================================================
  File:     B04525 - Ch06 - 25 - Creating a Certificate.ps1
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

$certificateName = "Test Certificate"
$masterdb =  $server.Databases["master"]

if ($masterdb.Certificates[$certificateName])
{
  $masterdb.Certificates[$certificateName].Drop()
}
$certificate = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Certificate -argumentlist $masterdb, $certificateName

#set properties
$certificate.StartDate = "April 10, 2015"
$certificate.Subject = "This is a test certificate."
$certificate.ExpirationDate = "April 10, 2017"
$certificate.ActiveForServiceBrokerDialog = $false

#create certificate
#you can optionally provide a password, but this
#certificate we created is protected by the master key
$certificate.Create("SUppLYStr0NGPassw0RDH3r3")

#display all properties
$certificate | 
Select-Object *


