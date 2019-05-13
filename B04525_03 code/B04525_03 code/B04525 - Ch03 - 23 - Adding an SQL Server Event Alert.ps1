<#============================================================================
  File:     B04525 - Ch03 - 23 - Adding a SQL Server Event Alert.ps1
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

$jobserver = $server.JobServer
#for purposes of our exercise, we will drop this 
#alert if it  already exists
$alertname = "Test Alert"
$alert = $jobserver.Alerts[$alertname]

#if our test alert exists, we will drop it first
if($alert)
{
  $alert.Drop()
}

#Alert accepts a JobServer and an alert name
$alert  = New-Object  Microsoft.SqlServer.Management.Smo.Agent.Alert $jobserver, $alertname 
$alert.Severity = 10

#Raise Alert when Message contains
$alert.EventDescriptionKeyword = "failed"

#Set notification message
$alert.NotificationMessage = "This is a test alert, dont worry"

$alert.Create()

