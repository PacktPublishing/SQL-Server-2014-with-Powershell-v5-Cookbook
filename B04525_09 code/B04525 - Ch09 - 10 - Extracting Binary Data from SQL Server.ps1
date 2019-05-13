<#============================================================================
  File:     B04525 - Ch09 - 10 - Extracting Binary Data from SQL Server.ps1
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

$instanceName = "localhost"
$databaseName = "SampleDB"

$timestamp = Get-Date -format "yyyy-MMM-dd-hhmmtt"
$emptyBLOB = "SampleDB.dbo.EmptyBLOB"
$formatFileName = "C:\DATA\blob$($timestamp).fmt"
$fmtcmd = "bcp `"$emptyBLOB`" format nul -T -N  -f `"$formatFilename`" -S $instanceName"

#create the format file
Invoke-Expression -Command $fmtcmd

#now there is a problem, by default the format file
#will use 8 as prefix length for varbinary
#we need this to be zero, so we will replace
(Get-Content $formatFileName) | 
ForEach-Object { 
   $_ -replace "8", "0" 
} | 
Set-Content $formatFileName

#After our format file is created, export our BLOB content from SQL Server to files in our file system
$folderName = "C:\DATA\"
$newFolderName = "Retrieved BLOB $timestamp"

$newFolder = Join-Path -Path "$($folderName)" -ChildPath $newFolderName

#if folder does not exist, create
if(!(Test-Path -Path $newFolder))
{
   New-Item -ItemType directory -Path $newFolder 
}

$query = @"
SELECT ID, FileName
FROM SampleBLOB
"@

Invoke-Sqlcmd -ServerInstance $instanceName -Database $databaseName -Query $query | 
ForEach-Object {
    $item = $_
	 Write-Verbose "Retrieving $($item.FileName) ..."

    $newFileName = Join-Path $newFolder $item.FileName

#query
$blobQuery = @"
SELECT BLOBStuff
FROM SampleBLOB
WHERE ID = $($item.ID)
"@

#bcp command
$cmd = "bcp `"$blobQuery`" queryout `"$newFileName`" -S $instanceName -T -d $databaseName -f `"$formatFileName`""

Invoke-Expression $cmd

}

#show retrieved files
explorer $newFolder
$VerbosePreference = "SilentlyContinue"  
