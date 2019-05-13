<#============================================================================
  File:     B04525 - Ch09 - 01 - Importing Data from Text File.ps1
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

$VerbosePreference = "Continue"

#change this to the path where you have Customers.txt
$file = "C:\DATA\Customers.txt"
$fieldDelimiter = "|"
$rowDelimiter = "\n"
$instanceName = "localhost"
$databaseName = "SampleDB"

#compose the bcp command
$bcpcmd = "bcp SampleText in `"$file`" -S $instanceName -d $databaseName -T -t `"$fieldDelimiter`" -r `"$rowDelimiter`" -c "

#execute the bcp command
Invoke-Expression -Command $bcpcmd

$VerbosePreference = "SilentlyContinue"
