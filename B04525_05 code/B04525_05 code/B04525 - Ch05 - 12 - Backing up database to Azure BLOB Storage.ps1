<#============================================================================
  File:     B04525 - Ch05 - 12 - Backing up database to Azure BLOB Storage.ps1
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

#If one does not already exist, create a credential to use for the remote backup:
$instanceName = "localhost"
$AzureStorageAccount = "yourAzureStorageAccount"
$storageKey = "replaceThisWithYourStorageKey"
$secureString = ConvertTo-SecureString $storageKey  -AsPlainText -Force
$credentialName = "AzureCredential"

$instanceName | 
New-SqlCredential -Name $credentialName  -Identity $AzureStorageAccount -Secret $secureString

#replace values specific to your Azure account
$blobContainer = "replaceWithYourContainerName"
$backupUrlContainer = "https://$AzureStorageAccount.blob.core.windows.net/$blobContainer/"

$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
$databaseName = "SampleDB"

Backup-SqlDatabase `
-ServerInstance $instanceName `
-Database $databaseName `
-BackupContainer $backupUrlContainer `
-SqlCredential $credentialName `
-Compression On 

