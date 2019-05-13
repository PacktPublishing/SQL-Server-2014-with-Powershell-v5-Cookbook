<#============================================================================
  File:     B04525 - Ch04 - 18 - Creating a Proxy.ps1
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

$proxyName = "filemanagerproxy"
$credentialName = "filemanagercredential"
$jobServer = $server.JobServer

#for purposes of our recipe
#we will drop the proxy account if it already exists 
if($jobServer.ProxyAccounts[$proxyName])
{
   $jobServer.ProxyAccounts[$proxyName].Drop()
}

#line below to create proxy object 
#should be in one line
$proxy = New-Object Microsoft.SqlServer.Management.Smo.Agent.ProxyAccount -ArgumentList $jobServer, $proxyName, $credentialName, $true, "Proxy Account for PowerShell Agent Job steps"

#create the proxy on the server 
$proxy.Create()

#add sql server agent account - QUERYWORKS\sqlagent
$agentLogin = "QUERYWORKS\sqlagent"
$proxy.AddLogin($agentLogin)

#add PowerShell and CmdExec Subsystems
$proxy.AddSubSystem([Microsoft.SqlServer.Management.Smo.Agent.AgentSubsystem]::PowerShell)
$proxy.AddSubSystem([Microsoft.SqlServer.Management.Smo.Agent.AgentSubsystem]::CmdExec)

#confirm, list proxy accounts
$jobserver.ProxyAccounts | 
ForEach-Object {
   $currProxy = $_

   #put all subsystems in a single string
   $subsytems = ($currProxy.EnumSubSystems() | 
                 Select -ExpandProperty Name) -Join ","

   $item = [PSCustomObject] @{
      Proxy = $currProxy.Name
      Credential = $currProxy.CredentialName
      Identity = $currProxy.CredentialIdentity
      Subsystems = $subsytems
   }

   #display
   $item
}
