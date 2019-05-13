<#============================================================================
  File:     B04525 - Ch03 - 09 - Attaching a Database.ps1
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

$databasename = "TestDB"
$owner = "QUERYWORKS\srogers"

#identify the primary data file
#this typically has the .mdf extension
#copy this to an easily referenced location
$mdfname = "C:\DATA\TestDB.mdf"

#FYI only
#view detached database info
$server.DetachedDatabaseInfo($mdfname) | 
Format-Table

#attachdatabase accepts a StringCollection, so we need
#to add our files in this collection
$filecoll = New-Object System.Collections.Specialized.StringCollection

#add all data files
#this includes the primary data file
$server.EnumDetachedDatabaseFiles($mdfname) |
Foreach-Object {
   $filecoll.Add($_)
}

#add all log files

$server.EnumDetachedLogFiles($mdfname) |
ForEach-Object {
    $filecoll.Add($_)
}


<#
http://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.attachoptions.aspx
None				Value = 0. There are no attach options. 
EnableBroker	Value = 1. Enables Service Broker. 
NewBroker		Value = 2. Creates a new Service Broker . 
ErrorBrokerConversations	Value = 3. Stops all current active Service Broker conversations at the save point and issues an error message. 
RebuildLog		Value = 4. Rebuilds the log. 
#>

$server.AttachDatabase($databasename, $filecoll, $owner, [Microsoft.SqlServer.Management.Smo.AttachOptions]::None)


