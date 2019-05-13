<#============================================================================
  File:     B04525 - Ch08 - 02 - Enable TCP and Named Pipes in SQL Server.ps1
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
$cred = Get-Credential
foreach ($node in Get-ClusterNode)
{
   Write-Host "Processing $($node.Name)"

   #execute command on the remote hosts
   Invoke-Command -ComputerName $node.Name -Credential $cred -ScriptBlock {
       Import-Module SQLPS -DisableNameChecking

       #create ManagedComputer object
       $wmi = New-Object Microsoft.SqlServer.Management.Smo.WMI.ManagedComputer

       #get current machine name
       $computerName = $env:COMPUTERNAME

       #compose URI to the server protocol
       $uri = "ManagedComputer[@Name='$($computerName)']/ServerInstance[@Name='MSSQLSERVER']/ServerProtocol"       

       #enable TCP
       $tcp = $wmi.GetSmoObject($uri + "[@Name='Tcp']")
       $tcp.IsEnabled = $true 
       $tcp.Alter()
       $tcp.Refresh()

       #enabled named pipe
       $np = $wmi.GetSmoObject($uri + "[@Name='Np']")
       $np.IsEnabled = $true 
       $np.Alter()
       $np.Refresh()

   }
}