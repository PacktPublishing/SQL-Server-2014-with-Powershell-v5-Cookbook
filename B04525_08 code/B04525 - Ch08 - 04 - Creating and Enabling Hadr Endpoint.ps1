<#============================================================================
  File:     B04525 - Ch08 - 04 - Creating and Enabling Hadr Endpoint.ps1
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
#prompt for credential
$cred = Get-Credential

#process each node
foreach ($node in Get-ClusterNode)
{
   Write-Host "Processing $($node.Name)"

   #execute command on remote hosts
   Invoke-Command -ComputerName $node.Name -Credential $cred -ScriptBlock {

       Import-Module SQLPS -DisableNameChecking
       $instance = $env:COMPUTERNAME

       #create server object
       $server = New-Object Microsoft.SqlServer.Management.Smo.Server $instance 

       #get a handle to the “AlwaysOnEndpoint”
       $endpoint = $null
       $endpoint = $server.Endpoints | 
       Where-Object EndpointType -eq "DatabaseMirroring" |
       Where-Object Name -eq "AlwaysOnEndpoint" |
       Select-Object -First 1

       #drop if endpoint exists
       if($endpoint -ne $null)
       {
          #drop endpoint
          Write-Host "Dropping endpoint ..."
          $endpoint.Drop()
       }
       
       $port = 5022
       $owner = "QUERYWORKS\Administrator"
       $endpointName = "AlwaysOnEndpoint"      
       $path = "SQLSERVER:\SQL\$($instance)\DEFAULT"
          
       $endpoint = New-SqlHADREndpoint -Port $port `
                 -Owner $owner -Encryption Supported `
                 -EncryptionAlgorithm Aes `
                 -Name $endpointName `
                 -Path $path 
       #if successfully created, start the endpoint
       if($endpoint -ne $null)
       {
          Set-SqlHADREndpoint -InputObject $endpoint `
          -State "Started" 

          #make sure this account is added as principal
          #to the SQL Server instance
          $endpointAccount = "QUERYWORKS\sqlservice"

          #assign CONNECT permission to the endpoint
          $permissionSet = New-Object Microsoft.SqlServer.Management.Smo.ObjectPermissionSet([Microsoft.SqlServer.Management.Smo.ObjectPermission]::Connect)
                
          $endpoint.Grant($permissionSet,$endpointAccount)
       }

   }
}
