<#============================================================================
  File:     B04525 - Ch11 - 15 - Sending Email.ps1
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

$file = "C:\Temp\processes.csv"
$timestamp = Get-Date -format "yyyy-MMM-dd-hhmmtt"

#note we are using backticks to put each parameter
#in its own line to make code more readable
Send-MailMessage `
-SmtpServer "queryworks.local" `
-To "administrator@queryworks.local" `
-From "powershell@sqlbelle.local" `
-Subject "Process Email - $file - $timestamp" `
-Body "Here ya go" `
-Attachments $file
