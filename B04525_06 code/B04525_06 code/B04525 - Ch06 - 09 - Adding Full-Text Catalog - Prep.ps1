<#============================================================================
  File:     B04525 - Ch06 - 10 - Addng Full-Text Catalog - Prep.ps1
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

$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName


$databaseName = "FullTextCatalogDB"

#for this recipe only
#drop if it exists
if($server.Databases[$databaseName])
{
    $server.KillDatabase($databaseName)
}
   
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $server, $databaseName
$db.Create()

$sql = @"
CREATE TABLE Documents
(
   DocumentID UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
   Name NVARCHAR(50),
   Extension NVARCHAR(10),
   Content VARBINARY(MAX),
   CONSTRAINT PK_Documents_DocumentID
   PRIMARY KEY(DocumentID)
)
"@

Invoke-Sqlcmd -ServerInstance $server -Database $databaseName -Query $sql
