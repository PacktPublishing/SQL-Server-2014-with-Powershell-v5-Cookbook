<#============================================================================
  File:     B04525 - Ch03 - 00 - Name.ps1
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

#replace this with your actual server name
$instanceName = "localhost"
#replace this with your SQL Server name
$instanceName = "localhost"

$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#enable DatabaseMail
#this is similar to an sp_configure TSQL command
$server.Configuration.DatabaseMailEnabled.ConfigValue = 1
$server.Configuration.Alter()
$server.Refresh()

#set up account
$accountName = "DBMail"
$accountDescription = "QUERYWORKS Database Mail"
$displayName = "QUERYWORKS mail"
$emailAddress = "dbmail@queryworks.local"
$replyToAddress = "dbmail@queryworks.local"
$mailServerAddress = "mail.queryworks.local"

$account = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Mail.MailAccount -Argumentlist $server.Mail, $accountName, $accountDescription, $displayName, $emailAddress 
$account.ReplyToAddress = $replyToAddress
$account.Create()


#configure account to use

#default mail server that was saved in previous script
#was the server name, we need to change this to the 
#appropriate mail server
$mailserver = $account.MailServers[$instanceName]
$mailserver.Rename($mailServerAddress)
$mailserver.Alter()

#default SMTP authentication is Anonymous Authentication
#we need to set this to use proper authentication
$mailserver.SetAccount("dbmail@queryworks.local", "some password")
$mailserver.Port = 25
$mailserver.Alter()

#create a profile
$profileName = "DB Mail Profile"
$profileDescription= "Default DB Mail Profile"

if($mailProfile)
{
  $mailProfile.Drop()
}

$mailProfile = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Mail.MailProfile -ArgumentList $server.Mail, $profileName, $profileDescription
$mailProfile.Create()
$mailProfile.Refresh()


#add account to the profile
$mailProfile.AddAccount($accountName, 0)
$mailProfile.AddPrincipal('public', 1)
$mailProfile.Alter()

#link this mail profile to SQL Server Agent
$server.JobServer.AgentMailType = 'DatabaseMail'
$server.JobServer.DatabaseMailProfile = $profileName
$server.JobServer.Alter()

#restart SQL Server Agent
$managedComputer = New-Object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer $instanceName     
$servicename = "SQLSERVERAGENT" 
$service = $managedComputer.Services[$servicename]
$service.Stop()
$service.Start()

