<#============================================================================
  File:     B04525 - Ch02 - 14 - Creating a Stored Procedure.ps1
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

#storedProcedure class on MSDN: 
#http://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.storedprocedure.aspx

$sprocName = "uspGetPersonByLastName"
$sproc = $db.StoredProcedures[$sprocName]
#if stored procedure exists, drop it
if ($sproc)
{
   $sproc.Drop()
}

$sproc = New-Object -TypeName Microsoft.SqlServer.Management.SMO.StoredProcedure -ArgumentList $db, $sprocName

#TextMode = false means stored procedure header 
#is not editable as text
#otherwise our text will contain the CREATE PROC block
$sproc.TextMode = $false
$sproc.IsEncrypted = $true

#specify parameter type
$paramtype = [Microsoft.SqlServer.Management.SMO.Datatype]::VarChar(50)

#create parameter using specified type
$param = New-Object -TypeName Microsoft.SqlServer.Management.SMO.StoredProcedureParameter -ArgumentList $sproc,"@LastName",$paramtype

#add parameter to stored procedure
$sproc.Parameters.Add($param)

#Set the TextBody property to define the stored procedure. 
$sproc.TextBody =  @" 
SELECT 
   TOP 10 
   BusinessEntityID,
   LastName
FROM 
   Person.Person
WHERE 
   LastName = @LastName
"@
      
# Create the stored procedure on the instance of SQL Server. 
$sproc.Create()

#if later on you need to change properties, can use the Alter method

