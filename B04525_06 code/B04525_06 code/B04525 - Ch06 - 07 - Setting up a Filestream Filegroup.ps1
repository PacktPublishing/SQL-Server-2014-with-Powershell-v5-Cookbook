<#============================================================================
  File:     B04525 - Ch06 - 07 - Setting up a Filestream Filegroup.ps1
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

#Create a sample database for this recipe
$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$databaseName = "FileStreamDB"

#for this recipe only
#drop if it exists
if($server.Databases[$databaseName])
{
    $server.KillDatabase($databaseName)
}
   
#create the database
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $server, $databaseName
$db.Create()

#Add filestream filegroup
$filegroupname = "FilestreamData"
$fg = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Filegroup -Argumentlist $db, $filegroupname 

#change the filegroup type
$fg.FileGroupType = [Microsoft.SqlServer.Management.Smo.FileGroupType]::FileStreamDataFileGroup
$fg.IsFileStream = $true

#create the filegroup
$fg.Create()

#add data file
$datafilename = "C:\DATA\FilestreamData"
$datafile = New-Object -TypeName Microsoft.SqlServer.Management.SMO.DataFile -ArgumentList $fg, $datafilename

$datafile.FileName = $datafilename

#create data file
$datafile.Create()

