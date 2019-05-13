<#============================================================================
  File:     B04525 - Ch10 - 04 - Downloading an SSRS Report in Excel and PDF.ps1
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

Add-Type -AssemblyName "Microsoft.ReportViewer.WinForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"

$reportViewer = New-Object Microsoft.Reporting.WinForms.ReportViewer

$reportViewer.ProcessingMode = "Remote"

$reportViewer.ServerReport.ReportServerUrl = "http://localhost/ReportServer"

$reportViewer.ServerReport.ReportPath = "/Customer Reports/Customer List"

#required variables for rendering
$mimeType = $null
$encoding = $null
$extension = $null
$streamids = $null
$warnings = $null

#export to Excel
$excelFile = "C:\Temp\Customer List.xls"
$bytes = $reportViewer.ServerReport.Render("Excel", $null, 
                  [ref] $mimeType, 
                  [ref] $encoding, 
						[ref] $extension, 
						[ref] $streamids, 
						[ref] $warnings)
$fileStream = New-Object System.IO.FileStream($excelFile, [System.IO.FileMode]::OpenOrCreate)
$fileStream.Write($bytes, 0, $bytes.Length)
$fileStream.Close()

#open the generated excel document
$excel = New-Object -comObject Excel.Application
$excel.visible = $true
$excel.Workbooks.Open($excelFile) | Out-Null

#export to PDF
$pdfFile = "C:\Temp\Customer List.pdf"
$bytes = $reportViewer.ServerReport.Render("PDF", $null, 
                  [ref] $mimeType, 
                  [ref] $encoding, 
						[ref] $extension, 
						[ref] $streamids, 
						[ref] $warnings)

$fileStream = New-Object System.IO.FileStream($pdfFile, [System.IO.FileMode]::OpenOrCreate)
$fileStream.Write($bytes, 0, $bytes.Length)
$fileStream.Close()

#open the PDF file using the default PDF application
[System.Diagnostics.Process]::Start($pdfFile)
