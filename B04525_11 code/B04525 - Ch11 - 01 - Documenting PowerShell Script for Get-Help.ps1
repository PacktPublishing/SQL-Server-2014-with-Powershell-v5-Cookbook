<#============================================================================
  File:     B04525 - Ch11 - 01 - Documenting PowerShell Script for Get-Help.ps1
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

<#
.SYNOPSIS
   Creates a full database backup
.DESCRIPTION
   Creates a full database backup using specified instance name and database name
   This will place the backup file to the default backup directory of the instance
.PARAMETER instanceName
   instance where database to be backed up resides
.PARAMETER databaseName
   database to be backed up
.EXAMPLE
   PS C:\PowerShell> .\Backup-Database.ps1 -instanceName "QUERYWORKS\SQL01" -databaseName "pubs"
.EXAMPLE
   PS C:\PowerShell> .\Backup-Database.ps1 -instance "QUERYWORKS\SQL01" -database "pubs"
.NOTES

   To get help:
   Get-Help .\Backup-Database.ps1

#>

param
(
   [Parameter(Position=0)]
   [alias("instance")]
   [string]$instanceName,
   [Parameter(Position=1)]
   [alias("database")]
   [string]$databaseName
)
function main 
{
   #this is just a stub file
}

#clear the screen
cls

#get general help
Get-Help "C:\PowerShell\Backup-Database.ps1"

#get examples
Get-Help "C:\PowerShell\Backup-Database.ps1" -Examples
