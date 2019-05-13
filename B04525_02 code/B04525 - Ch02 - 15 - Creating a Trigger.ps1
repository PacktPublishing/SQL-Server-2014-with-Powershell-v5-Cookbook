<#============================================================================
  File:     B04525 - Ch02 - 15 - Creating a Trigger.ps1
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
$tableName = "Person"
$schemaName = "Person" 

#get a handle to the Person.Person table
$table = $db.Tables | 
         Where-Object Schema -like "$schemaName" |  
         Where-Object Name -like "$tableName"

$triggerName = "tr_u_Person"
#note here we need to check triggers attached to table
$trigger = $table.Triggers[$triggerName]

#if trigger exists, drop it
if ($trigger)
{
   $trigger.Drop()
}

$trigger = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Trigger -ArgumentList $table, $triggerName 
$trigger.TextMode = $false

#this is just an update trigger
$trigger.Update = $true
$trigger.Insert = $false
$trigger.Delete = $false

#3 options for ActivationOrder: First, Last, None
$trigger.InsertOrder = [Microsoft.SqlServer.Management.SMO.Agent.ActivationOrder]::None
$trigger.ImplementationType = [Microsoft.SqlServer.Management.SMO.ImplementationType]::TransactSql

#simple example
$trigger.TextBody = @"
  SELECT 
     GETDATE() AS UpdatedOn,
     SYSTEM_USER AS UpdatedBy,
     i.LastName AS NewLastName,
     i.FirstName AS NewFirstName,
     d.LastName AS OldLastName,
     d.FirstName AS OldFirstName
  FROM 
     inserted i
     INNER JOIN deleted d
     ON i.BusinessEntityID = d.BusinessEntityID
"@

$trigger.Create()


