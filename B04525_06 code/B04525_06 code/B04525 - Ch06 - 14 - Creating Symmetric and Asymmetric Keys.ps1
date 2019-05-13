<#============================================================================
  File:     B04525 - Ch06 - 26 - Creating Symmetric and Asymmetric Keys.ps1
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

#database handle
$databasename = "TestDB"
$database = $server.Databases[$databasename]

#========================================================
# Create Database Master Key
#========================================================
#create (user) database master key
#if this doesn’t exist yet
$dbmk = New-Object Microsoft.SqlServer.Management.Smo.MasterKey -ArgumentList $database
$dbmk.Create("P@ssword")

#========================================================
# Create Asymmetric Key
#========================================================
$asymk = New-Object Microsoft.SqlServer.Management.Smo.AsymmetricKey -ArgumentList $database, "EncryptionAsymmetricKey"

#replace this with a known database user in the 
#database you are using for this recipe
$asymk.Owner = "eric"
$asymk.Create([Microsoft.SqlServer.Management.Smo.AsymmetricKeyEncryptionAlgorithm]::Rsa2048) 


#========================================================
# Create Symmetric Key
#========================================================
#create certificate first to be used for Symmetric Key
$cert = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Certificate -argumentlist $database, "Encryption"
$cert.StartDate = "April 10, 2017"
$cert.Subject = "This is a test certificate."
$cert.ExpirationDate = "April 10, 2017"
$cert.Create()

#create a symmetric key based on certificate
$symk = New-Object Microsoft.SqlServer.Management.Smo.SymmetricKey -ArgumentList $database, "EncryptionSymmetricKey"
$symkenc = New-Object Microsoft.SqlServer.Management.Smo.SymmetricKeyEncryption ([Microsoft.SqlServer.Management.Smo.KeyEncryptionType]::Certificate, "Encryption")
$symk.Create($symkenc, [Microsoft.SqlServer.Management.Smo.SymmetricKeyEncryptionAlgorithm]::TripleDes)

#list each object we created
$dbmk
$cert.Name
$asymk
$symk


