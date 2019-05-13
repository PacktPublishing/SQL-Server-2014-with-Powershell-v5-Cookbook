<#============================================================================
  File:     B04525 - Ch03 - 02 - Creating a SQL Server Database Inventory.ps1
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

#specify folder and filename to be produced
$folder = "C:\Temp"
$currdate = Get-Date -Format "yyyy-MM-dd_hmmtt"
$filename = "$($instanceName)_db_$($currdate).csv"
$fullpath = Join-Path $folder $filename

$result = @()

#get properties of all databases in instance
$server.Databases |
ForEach-Object {

   #current database in pipeline
   $db = $_

   #capture info you want to capture
   #into a PSCustomObject
   #this make it easier to export to CSV
   $item = [PSCustomObject] @{  
     DatabaseName       = $db.Name
     CreateDate         = $db.CreateDate
     Owner              = $db.Owner
     RecoveryModel      = $db.RecoveryModel
     SizeMB             = $db.Size
     DataSpaceUsage     = ($db.DataSpaceUsage/1MB).ToString("0.00")
     IndexSpaceUsage    = ($db.IndexSpaceUsage/1MB).ToString("0.00")
     Collation          = $db.Collation
     Users              = (($db.Users | ForEach-Object {$_.Name}) -Join ",")
     UserCount          = $db.Users.Count
     TableCount         = $db.Tables.Count
     SPCount            = $db.StoredProcedures.Count
     UDFCount           = $db.UserDefinedFunctions.Count
     ViewCount          = $db.Views.Count
     TriggerCount       = $db.Triggers.Count
     LastBackupDate     = $db.LastBackupDate
     LastDiffBackupDate = $db.LastDifferentialBackupDate
     LastLogBackupDate  = $db.LastBackupDate
   }
   #create a new "row" and add to the results array
   $result += $item
}

#export result to CSV
#note CSV can be opened in Excel, which is handy
$result | 
Export-Csv -Path $fullpath -NoTypeInformation

#view folder in Windows Explorer
explorer $folder


