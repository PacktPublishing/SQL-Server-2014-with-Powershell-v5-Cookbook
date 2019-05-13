<#============================================================================
  File:     B04525 - Ch05 - 13 - Restoring database from Azure BLOB Storage.ps1
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

$AzureStorageAccount = "yourAzureStorageAccount"
$credentialName = "AzureCredential"

#replace values specific to your Azure account
$blobContainer = "replaceWithYourContainerName"
$backupUrlContainer = "https://$AzureStorageAccount.blob.core.windows.net/$blobContainer/"
	
$backupfile = "replacethiswithyourazurefilename.bak"
$backupfileURL = $backupUrlContainer + $backupfile

$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
$databaseName = "SampleDB"


#restore database
#note there are backticks in this command
#so we can place each parameter in its line to 
#make the command more readable
Restore-SqlDatabase `
-ServerInstance $instanceName `
-Database $databaseName `
-SqlCredential $credentialName `
-BackupFile $backupfileURL `
-Verbose

