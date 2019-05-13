<#============================================================================
  File:     B04525 - Ch06 - 11 - Adding Full-Text Index.ps1
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
Import-Module SQLPS –DisableNameChecking

$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#database
$databaseName = "FullTextCatalogDB"
$db = $server.Databases[$databaseName]

#catalog
$catalogName = "FTC"
$catalog = $db.FullTextCatalogs[$catalogName]

#table
$tableName = "Documents"
$table = $db.Tables[$tableName]

#create full-text index
$fullTextIndex = New-Object -TypeName Microsoft.SqlServer.Management.SMO.FullTextIndex 

#set full-text index properties
$fullTextIndex.Parent = $table
$fullTextIndex.CatalogName = $catalogName
$fulltextIndex.StopListName = "SYSTEM"

#need to establish unique ID for base table
$fullTextIndex.UniqueIndexName = "PK_Documents_DocumentID"
$fullTextIndex.Create()

#specify index column
$documentNameCol = New-Object -TypeName Microsoft.SqlServer.Management.Smo.FullTextIndexColumn -ArgumentList $fullTextIndex, "Name"
$documentNameCol.Language = "English"
$documentNameCol.Create()

#specify a type column
$documentContentCol = New-Object -TypeName Microsoft.SqlServer.Management.Smo.FullTextIndexColumn -ArgumentList $fullTextIndex, "Content"
$documentContentCol.Language = "English"
$documentContentCol.TypeColumnName = "Extension"

#create
$documentContentCol.Create()

