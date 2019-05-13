<#============================================================================
  File:     B04525 - Ch03 - 07 - Setting Up WMI Server Event Alerts.ps1
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

$namespace = "root\Microsoft\SqlServer\ServerEvents\MSSQLSERVER"

#WQL for Login Events
#note we will capture CREATE, DROP, ALTER
#if you want to more specific, use these events
#DROP_LOGIN, CREATE_LOGIN, ALTER_LOGIN
$query = "SELECT * FROM DDL_LOGIN_EVENTS"

#register the event
#if the event is triggered, it will respond by
#creating a timestamped file containing event 
#details
Register-WMIEvent -Namespace $namespace -Query $query -SourceIdentifier "SQLLoginEvent" -Action {
  $date = Get-Date -Format "yyyy-MM-dd_hmmtt"
  $filename = "C:\Temp\LoginEvent-$($date).txt"
  New-Item –ItemType file $filename

$msg = @"

DDL Login Event Occurred`n  
PostTime: $($event.SourceEventArgs.NewEvent.PostTime)
Instance: $($event.SourceEventArgs.NewEvent.SQLInstance)
LoginType: $($event.SourceEventArgs.NewEvent.LoginType)
LoginName: $($event.SourceEventArgs.NewEvent.LoginName)
SID:       $($event.SourceEventArgs.NewEvent.SID)
SPID:      $($event.SourceEventArgs.NewEvent.SPID)
TSQLCommand:  $($event.SourceEventArgs.NewEvent.TSQLCommand)

"@

$msg | 
Out-File -FilePath $filename -Append
}


