<#============================================================================
  File:     B04525 - Ch03 - 12 - Creating a Filegroup.ps1
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
$database = $server.Databases[$databasename]
$fgname = "FGActive"

#For purposes of this recipe, we are going to drop this
#filegroup if it exists, so we can recreate it without
#any issues
if ($database.FileGroups[$fgname])
{
   $database.FileGroups[$fgname].Drop()
}

#create the filegroup
$fg = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Filegroup -Argumentlist $database, $fgname 
$fg.Create()

