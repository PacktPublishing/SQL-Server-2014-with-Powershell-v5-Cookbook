<#============================================================================
  File:     B04525 - Ch08 - 07 - Joining Secondary Replicas to Availability Group.ps1
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

#execute command for each node
foreach ($secondary in $secondaryList)
{
   Invoke-Command -ComputerName $secondary -Credential $cred -ScriptBlock {
        Import-Module SQLPS -DisableNameChecking
        $instance = $env:COMPUTERNAME
        $path = "SQLSERVER:\SQL\$($instance)\DEFAULT"
        $AGName = "SQLAG"

        #join current node to availability group
        Join-SqlAvailabilityGroup `
        -Path $path `
        -Name $AGName 
    }
}

