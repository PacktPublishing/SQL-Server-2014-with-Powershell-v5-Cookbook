<#============================================================================
  File:     B04525 - Ch10 - 03 - Using ReportViewer to View Your SSRS Report.ps1
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

#load the ReportViewer WinForms assembly
Add-Type -AssemblyName "Microsoft.ReportViewer.WinForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91""

#load the Windows.Forms assembly
Add-Type -AssemblyName "System.Windows.Forms"

$reportViewer = New-Object Microsoft.Reporting.WinForms.ReportViewer
$reportViewer.ProcessingMode = "Remote"
$reportViewer.ServerReport.ReportServerUrl = "http://localhost/ReportServer"
$reportViewer.ServerReport.ReportPath = "/Customer Reports/Customer List"

#adjust report size
$reportViewer.Height = 600
$reportViewer.Width = 800
$reportViewer.RefreshReport()

#create a windows new form
$form = New-Object Windows.Forms.Form

#we're going to make the just slightly bigger 
#than the ReportViewer
$form.Height = 610
$form.Width= 810

#form is not resizable
$form.FormBorderStyle = "FixedSingle"

#do not allow user to maximize
$form.MaximizeBox = $false

$form.Controls.Add($reportViewer)

#show the report in the form
$reportViewer.Show()

#show the form
$form.ShowDialog()
