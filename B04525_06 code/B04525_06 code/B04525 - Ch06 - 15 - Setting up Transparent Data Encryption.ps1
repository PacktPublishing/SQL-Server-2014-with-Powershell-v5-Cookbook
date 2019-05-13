<#============================================================================
  File:     B04525 - Ch06 - 27 Setting up Transparent Data Encryption - .ps1
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

#if not yet created, create a master key
$masterdb =  $server.Databases["master"]

if($masterdb.MasterKey -eq $null)
{
   $masterkey = New-Object Microsoft.SqlServer.Management.Smo.MasterKey -ArgumentList $masterdb
   $masterkey.Create("P@ssword")
}

#if not yet created, create or obtain a certificate 
#protected by the master key
$certificateName = "Test Certificate"

if ($masterdb.Certificates[$certificateName])
{
  $masterdb.Certificates[$certificateName].Drop()
}
$certificate = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Certificate -argumentlist $masterdb, $certificateName

#create certificate protected by the master key
$certificate.StartDate = "April 10, 2015"
$certificate.Subject = "This is a test certificate."
$certificate.ExpirationDate = "April 10, 2017"

#you can optionally provide a password, but this
#certificate we created is protected by the master key
$certificate.Create()

#create a database encryption key
$databaseName = "TestDB"
$database = $server.Databases[$databaseName]

$dbencryption = New-Object Microsoft.SqlServer.Management.Smo.DatabaseEncryptionKey
$dbencryption.Parent = $database
$dbencryption.EncryptionAlgorithm = [Microsoft.SqlServer.Management.Smo.DatabaseEncryptionAlgorithm]::Aes256
$dbencryption.EncryptionType =  [Microsoft.SqlServer.Management.Smo.DatabaseEncryptionType]::ServerCertificate

#associate certificate name
$dbencryption.EncryptorName = $certificateName
$dbencryption.Create()

#enable TDE
$database.EncryptionEnabled = $true
$database.Alter()
$database.Refresh()

#display TDE setting
$database.EncryptionEnabled

$databasename = "TestDB"
$database = $server.Databases[$databasename]


