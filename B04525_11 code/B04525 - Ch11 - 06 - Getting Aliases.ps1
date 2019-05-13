<#============================================================================
  File:     B04525 - Ch11 - 06 - Getting Aliases.ps1
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

#list all aliases 
Get-Alias

#get members of Get-Alias
Get-Alias | 
Get-Member

#list cmdlet that is aliased as dir
$alias:dir

#list cmdlet that is aliased as ls
$alias:ls

#get all aliases of Get-ChildItem
Get-Alias -Definition "Get-ChildItem"
