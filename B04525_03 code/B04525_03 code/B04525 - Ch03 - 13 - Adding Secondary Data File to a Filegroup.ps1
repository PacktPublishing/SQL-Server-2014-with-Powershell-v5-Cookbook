<#============================================================================
  File:     B04525 - Ch03 - 13 - Adding Secondary Data File to a Filegroup.ps1
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

$databasename = "TestDB"
$fgname = "FGActive"

$database = $server.Databases[$databasename]
$fg = $database.FileGroups[$fgname]

#Define a DataFile object on the file group and set the logical file name. 
$df = New-Object -TypeName Microsoft.SqlServer.Management.SMO.DataFile -ArgumentList $fg, "datafile1"

#Make sure to have a directory created to hold the designated data file
$df.FileName = "c:\\Temp\\datafile1.ndf"

#Call the Create method to create the data file on the instance of SQL Server. 
$df.Create()

