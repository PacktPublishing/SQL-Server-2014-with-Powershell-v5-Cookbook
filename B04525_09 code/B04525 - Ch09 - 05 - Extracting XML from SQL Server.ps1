<#============================================================================
  File:     B04525 - Ch09 - 05 - Extracting XML from SQL Server.ps1
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
$sourceFolder = "C:\XML Files\"
$destinationFolder = "C:\XML Files\"

#we will save all retrieved files in a new folder
$newFolder = "XML $(Get-Date -format 'yyyy-MMM-dd-hhmmtt')"
$newfolder = Join-Path -Path "$($destinationFolder)" -ChildPath $newFolder

#if the path exists, will error silently and continue
New-Item -ItemType directory -Path $newFolder -ErrorAction SilentlyContinue

#query to get XML content from database 
$query = @"
SELECT FileName, XMLStuff
FROM SampleXML 
WHERE XMLStuff IS NOT NULL
"@

Invoke-Sqlcmd -ServerInstance $instanceName -Database $databaseName -Query $query -MaxCharLength 99999999 | 
ForEach-Object {
   $record = $_
	Write-Verbose "Retrieving $($record.FileName) ..."
	[xml]$xml = $record.XmlStuff 
	$xml.Save((Join-Path -Path $newfolder -ChildPath "$($record.FileName)"))	
}

#open folder with the files
explorer $newFolder

$VerbosePreference = "SilentlyContinue"



