<#============================================================================
  File:     B04525 - Ch11 - 20 - Using PowerShell Remoting.ps1
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

#on your local server
Invoke-Command -ComputerName <Remote Machine Name> -Credential "QUERYWORKS\Administrator" -ScriptBlock {
   Get-Wmiobject win32_computersystem
}

#Next let’s start an interactive remoting session 
#to the remote machine name
Enter-PSSession -ComputerName <Remote Machine Name> -Credential "QUERYWORKS\Administrator" 

#Note that as soon as you are authenticated, the prompt changes to 
#indicate we are now in the remote machine.
#Let’s execute a simple command in our remoting session
Get-Wmiobject win32_computersystem
