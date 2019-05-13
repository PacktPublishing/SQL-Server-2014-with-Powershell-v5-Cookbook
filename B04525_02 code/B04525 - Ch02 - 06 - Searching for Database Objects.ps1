<#============================================================================
  File:     B04525 - Ch02 - 06 - Searching for Database Objects.ps1
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

$databaseName = "AdventureWorks2014"
$db = $server.Databases[$databaseName]

#what keyword are we looking for?
$searchString = "Product"

#create empty array, we will store results here
$results = @()

#now we will loop through all database SMO 
#properties and look of objects that match
#the search string
$db | 
Get-Member -MemberType Property |
Where-Object Definition -like "*Smo*" | 
ForEach-Object {
   $type = $_.Name
   $db.$type | 
   Where-Object Name -like "*$searchstring*" |
   ForEach-Object {
      $result = [PSCustomObject] @{
         ObjectType = $type 
         ObjectName = $_.Name 
      }
      $results += $result
   }
}

#display results
$results |
Format-Table -AutoSize

#export results to csv file
$file = "C:\Temp\SearchResults.csv"
$results | Export-Csv -Path $file -NoTypeInformation

#display file contents in notepad
notepad $file

