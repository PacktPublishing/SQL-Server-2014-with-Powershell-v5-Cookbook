<#============================================================================
  File:     B04525 - Ch03 - 17 - Reorganizing Rebuilding an Index.ps1
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

$VerbosePreference = "Continue"

$databasename = "AdventureWorks2014"
$database = $server.Databases[$databasename]

$tableName = "Person"
$schemaName = "Person" 

$table = $database.Tables | 
         Where-Object Schema -like $schemaName |  
         Where-Object Name -like $tableName

#From MSDN: 
#EnumFragmentation enumerates a list of 
#fragmentation information 
#for the index using the default fast fragmentation option.
$table.Indexes |
ForEach-Object {
   $index = $_
   $index.EnumFragmentation() |
   ForEach-Object {
        $item = $_
        #reorganize if 10 and 30% fragmentation
        if($item.AverageFragmentation -ge  10 -and 
           $item.AverageFragmentation -le 30  -and 
           $item.Pages -ge 1000)
        {
           Write-Verbose "Reorganizing $index.Name ... "
           $index.Reorganize()
        }
        #rebuild if more than 30%
        elseif ($item.AverageFragmentation -gt 30 -and 
                $item.Pages -ge 1000)
        {
           Write-Verbose "Rebuilding $index.Name ... "
           $index.Rebuild()
        }
   }
}

$VerbosePreference = "SilentlyContinue"
