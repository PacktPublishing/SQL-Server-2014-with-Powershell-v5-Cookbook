<#============================================================================
  File:     B04525 - Ch02 -07 - Scripting SQL Server Stored Procedures.ps1
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

$dbName = "AdventureWorks2014"
$db = $server.Databases[$dbName]

#create a Scripter object
$script = New-Object Microsoft.SqlServer.Management.Smo.Scripter $server 

#create a ScriptingOptions object 
$scriptOptions = New-Object Microsoft.SqlServer.Management.Smo.ScriptingOptions

$scriptOptions.AllowSystemObjects = $false
$scriptOptions.ScriptSchema = $true
$scriptOptions.IncludeDatabaseContext = $true 
$scriptOptions.SchemaQualify = $true 
$scriptOptions.ScriptBatchTerminator = $true 
$scriptOptions.NoExecuteAs = $true 
$scriptOptions.Permissions = $true
$scriptOptions.ToFileOnly = $true 

#assign the options to the Scripter object
$script.Options = $scriptOptions 

#iterate over the objects you want to script
#in our case, stored procedures
#exclude any system objects or encrypted stored procedures
$db.StoredProcedures | 
Where-Object IsSystemObject -eq $false |
Where-Object IsEncrypted -eq $false |
Foreach-Object {

    #current stored procedure
    $sp = $_  
 
    #specify one file per stored procedure
    $filename = "C:\DATA\$($dbname)_$($sp.Name).sql"
    $script.Options.FileName = $filename

    #script current object
    $script.Script($sp)

}


