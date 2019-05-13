<#============================================================================
  File:     B04525 - Ch10 - 08 - Uploading an SSRS Report to Report Manager.ps1
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

$reportServerUri  = "http://localhost/ReportServer/ReportService2010.asmx"
$proxy = New-WebServiceProxy -Uri $reportServerUri -UseDefaultCredential 
$type = $proxy.GetType().Namespace

#specify where the RDL file is 
$rdl = "C:\SSRS\Customer Contact List.rdl"

#extract report name from the RDL file
$reportName =  [System.IO.Path]::GetFileNameWithoutExtension($rdl)

#get contents of the RDL
$byteArray = Get-Content $rdl -Encoding Byte

#The fully qualified URL for the parent folder that will contain the item.
$parent = "/Customer Reports"
$overwrite = $true
$warnings = $null

#create report
$report = $proxy.CreateCatalogItem("Report", $reportName, $parent, $overwrite, $byteArray, $null, [ref]$warnings )

#data source name must match what's in the RDL
$dataSourceName = "DS_CUSTOMERLIST"

#data source path should match what's in the report server
$dataSourcePath = "/Data Sources/AdventureWorks2014"

#when we upload the report, if the 
#data source from the source is different
#or has a different path from what’s in the 
#report manager, the data source will be broken
#and we will need to update

#create our data type references
$dataSourceArrayType = ($type + '.DataSource[]')
$dataSourceType = ($type + '.DataSource')
$dataSourceReferenceType = ($type + '.DataSourceReference')

#create data source array
$numDataSources = 1
$dataSourceArray = New-Object ($dataSourceArrayType)$numDataSources
$dataSourceReference = New-Object ($dataSourceReferenceType)

#update data source
$dataSourceArray[0] = New-Object ($dataSourceType)
$dataSourceArray[0].Name = $dataSourceName
$dataSourceArray[0].Item = New-Object ($dataSourceReferenceType)
$dataSourcearray[0].Item.Reference = $dataSourcePath
$proxy.SetItemDataSources($report.Path, $dataSourceArray)
