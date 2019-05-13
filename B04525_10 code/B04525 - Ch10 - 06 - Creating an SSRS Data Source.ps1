<#============================================================================
  File:     B04525 - Ch10 - 06 - Creating an SSRS Data Source.ps1
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
$type = $Proxy.GetType().Namespace

#create a DataSourceDefinition
$dataSourceDefinitionType = ($type + '.DataSourceDefinition')
$dataSourceDefinition = New-Object($dataSourceDefinitionType)
$dataSourceDefinition.CredentialRetrieval = "Integrated"
$dataSourceDefinition.ConnectString = "Data Source=localhost;Initial Catalog=AdventureWorks2014"
$dataSourceDefinition.extension = "SQL"
$dataSourceDefinition.enabled = $true
$dataSourceDefinition.Prompt = $null
$dataSourceDefinition.WindowsCredentials = $false

#NOTE this is SSRS native mode
#CreateDataSource method accepts the following parameters:
# 1. datasource name
# 2. parent (data folder) – must already exist
# 3. overwrite
# 4. data source definition
# 5. properties

$dataSource = "Sample"
$parent = "/Data Sources"
$overwrite = $true

$newDataSource = $proxy.CreateDataSource($dataSource, $parent, $overwrite,$dataSourceDefinition, $null)


