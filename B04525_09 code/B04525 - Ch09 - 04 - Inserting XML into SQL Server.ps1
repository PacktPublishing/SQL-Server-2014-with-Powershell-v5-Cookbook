<#============================================================================
  File:     B04525 - Ch09 - 04 - Inserting XML into SQL Server.ps1
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

#define variables for directory, instance, database
$xmlDirectory = "C:\DATA\"
$instanceName = "localhost"
$databaseName = "SampleDB"

#get all XML files from your XML directory
Get-ChildItem $xmlDirectory -Filter "*.xml" | 
ForEach-Object {

    $xmlFile = $_

    #display XML file currently being imported
    Write-Verbose "Importing  $($xmlFile.FullName) ..."

    #escape single quotes 
    #because we are passing the
    #XML content to a T-SQL statement
    [string]$xml = (Get-Content $xmlFile.FullName) -replace "'", "''"

$query = @"
INSERT INTO SampleXML
(FileName,XMLStuff,FileExtension) 
VALUES('$($_.Name)','$xml','.xml')
"@

    Invoke-Sqlcmd -ServerInstance $instanceName -Database $databaseName -Query $query

}

$VerbosePreference = "SilentlyContinue"

