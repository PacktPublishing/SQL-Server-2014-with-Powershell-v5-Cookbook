<#============================================================================
  File:     B04525 - Ch09 - 13 - Extracting User-Defined Assemblies.ps1
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

$timestamp = Get-Date -format "yyyy-MMM-dd-hhmmtt"
$emptyBLOB = "SampleDB.dbo.EmptyBLOB"

$formatFileName = "C:\CLR Files\clr$($timestamp).fmt"

$fmtcmd = "bcp `"$emptyBLOB`" format nul -T -N  -f `"$formatfilename`" -S $instanceName"

#create the format file
Invoke-Expression -Command	$fmtcmd

#now there is a problem, by default the format file
#will use 8 as prefix length for varbinary
#we need this to be zero, so we will replace
(Get-Content $formatFileName) | 
ForEach-Object { 
   $_ -replace "8", "0" 
} | 
Set-Content $formatFileName

$databaseName = "SampleDB"
$folderName = "C:\CLR Files\"
$newFolderName = "Retrieved CLR $timestamp"

$newFolder = Join-Path -Path "$($folderName)" -ChildPath $newFolderName

#if the path exists, will error silently and continue
New-Item -ItemType directory -Path $newfolder -ErrorAction SilentlyContinue

#get all user defined assemblies
$query = @"
SELECT  
        af.file_id AS ID,
        a.name + '.dll' AS FileName
FROM    
        sys.assembly_files af
        INNER JOIN sys.assemblies a 
        ON af.assembly_id = a.assembly_id
WHERE   
        a.is_user_defined  = 1 
"@

Invoke-Sqlcmd -ServerInstance $instanceName -Database $databaseName -Query $query | 
ForEach-Object {
    $item = $_
	 Write-Verbose "Retrieving $($item.FileName) ..."

    $newFileName = Join-Path $newFolder $item.FileName

$blobQuery = @"
SELECT  
        af.content
FROM    
        sys.assembly_files af
WHERE   
        af.file_id = $($item.ID)
"@

#bcp command
$cmd = "bcp `"$blobQuery`" queryout `"$newFileName`" -S $instanceName -T -d $databaseName -f `"$formatFileName`""

Invoke-Expression $cmd

}

#display files
explorer $newFolder
$VerbosePreference = "SilentlyContinue" 
