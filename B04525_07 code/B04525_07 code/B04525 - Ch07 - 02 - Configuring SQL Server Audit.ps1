<#============================================================================
  File:     B04525 - Ch07 - 02 - Configuring SQL Server Audit.ps1
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

$auditName = "FileAudit"

#if it exists, disable then drop
if($server.Audits[$auditName])
{
   $server.Audits[$auditName].Disable()
   $server.Audits[$auditName].Drop()
}

$serverAudit = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Audit $server, $auditName

#set the destination as file
$serverAudit.DestinationType = [Microsoft.SqlServer.Management.Smo.AuditDestinationType]::File

#specify the folder where audit will be saved
$serverAudit.FilePath = "C:\Audit\"

#create
$serverAudit.Create()

#enable
$serverAudit.Enable()

4.	Create a Server Audit Specification using the following script:
$serverAuditSpecName = "FileSpecAudit"

#if exists, disable then drop
if($server.ServerAuditSpecifications[$serverAuditSpecName])
{
   $server.ServerAuditSpecifications[$serverAuditSpecName].Disable()
   $server.ServerAuditSpecifications[$serverAuditSpecName].Drop()
}

$serverAuditSpec = New-Object Microsoft.SqlServer.Management.Smo.ServerAuditSpecification $server, $serverAuditSpecName

#which Audit does this belong to?
$serverAuditSpec.AuditName = $auditName 

#set up which server event will be monitored/audited
$auditActionType = [Microsoft.SqlServer.Management.Smo.AuditActionType]::FailedLoginGroup

#create the specification detail
$serverAuditSpecDetail = New-Object Microsoft.SqlServer.Management.Smo.AuditSpecificationDetail($auditActionType)

#add specification detail to audit specification
$serverAuditSpec.AddAuditSpecificationDetail($serverAuditSpecDetail)

#create
$serverAuditSpec.Create()

#enable
$serverAuditSpec.Enable()

