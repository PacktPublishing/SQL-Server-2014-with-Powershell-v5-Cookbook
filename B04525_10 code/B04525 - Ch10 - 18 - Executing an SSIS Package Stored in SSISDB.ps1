<#============================================================================
  File:     B04525 - Ch10 - 18 - Executing an SSIS Package Stored in SSISDB.ps1
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

Add-Type -AssemblyName "Microsoft.SqlServer.Management.IntegrationServices, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"

$instanceName = "localhost"
$connectionString = "Data Source=$instanceName;Initial Catalog=master;Integrated Security=SSPI;"                       
$conn = New-Object System.Data.SqlClient.SqlConnection $constr            
$SSISServer = New-Object Microsoft.SqlServer.Management.IntegrationServices.IntegrationServices $conn    
$SSISDB = $SSISServer.Catalogs["SSISDB"]

$SSISDBFolderName = "QueryWorks"
$SSISDBFolder = $SSISDB.Folders[$SSISDBFolderName]
$projectName= "Customer Package Project"
$packageName= "Customer Package.dtsx"
$SSISDBFolder.Projects[$projectName].Packages[$packageName].Execute($false, $null)

