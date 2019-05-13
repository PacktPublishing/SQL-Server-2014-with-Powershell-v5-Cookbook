<#============================================================================
  File:     B04525 - Ch09 - 09 - Storing Binary Data into SQL Server.ps1
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

$VerbosePreference = "Continue"
$instanceName = "localhost"
$databaseName = "SampleDB"
$folderName = "C:\DATA\"

#get all files
Get-ChildItem $folderName | 
Where-Object PSIsContainer -eq $false |
ForEach-Object {
   $blobFile = $_
   $fileExtension = $blobFile.Extension
   #learn more about Write-Verbose from Appendix A and
   #https://technet.microsoft.com/en-us/library/hh849951.aspx
   Write-Verbose "Importing file $($blobFile.FullName)..."

$query = @"
INSERT INTO SampleBLOB 
(FileName, FileExtension, BLOBStuff) 
SELECT '$blobFile','$fileExtension',*
FROM OPENROWSET(BULK N'$folderName$blobFile', SINGLE_BLOB) as tmpImage 
"@

Invoke-Sqlcmd -ServerInstance $instanceName -Database $databaseName -Query $query

#wait for query to finish
Start-Sleep -Seconds 2

}
$VerbosePreference = "SilentlyContinue"


