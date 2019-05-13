<#============================================================================
  File:     B04525 - Ch02 - 23 - Creating a Table in Azure SQL Database.ps1
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
Import-Module SQLPS -DisableNameChecking

$query = @"
CREATE TABLE Student 
( 
   ID INT PRIMARY KEY,
   FName VARCHAR(100),
   LName VARCHAR(100)
)
"@

$azureserver = "yourAzureServer.database.windows.net"
$database = "School"
$username = "yourusername"
$password = "yourpassword"

Invoke-SqlCmd -ServerInstance $azureserver -Database $database -Username $username -Password $password -Query $query

#Check that the table has been created.
$query = @"
SELECT * 
FROM INFORMATION_SCHEMA.TABLES
"@

Invoke-SqlCmd -ServerInstance $azureserver -Database $database -Username $username -Password $password -Query $query


