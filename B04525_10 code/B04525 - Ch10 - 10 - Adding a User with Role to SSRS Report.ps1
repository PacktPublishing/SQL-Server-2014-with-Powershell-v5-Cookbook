<#============================================================================
  File:     B04525 - Ch10 - 10 - Adding a User with Role to SSRS Report.ps1
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

$itemPath = "/Customer Reports/Customer List"

#this will hold all the group/users for a report
$newPolicies = @()
$inherit = $null

#list current report users
$proxy.GetPolicies($itemPath, [ref]$inherit)
 
#NOTE that when we change policies, it will 
#automatically break inheritance
#ALSO NOTE that when you programmatically mess 
#with policies, you will need to "re-add" users that were 
#already there, if you want them to keep on having access
#to your reports 

#this gets all users who currently have 
#access to this report
#need pass $inherit by reference
$proxy.GetPolicies($itemPath, [ref]$inherit) |
ForEach-Object {
    #re-add existing policies
	$newPolicies += $_
}

$policyDataType = ($type + '.Policy')
$newPolicy = New-Object ($policyDataType)
$newPolicy.GroupUserName = "QUERYWORKS\tstark" 

#a policy must have roles
$roleDataType = ($type + '.Role')
$newRole = New-Object ($roleDataType)
$newRole.Name = "Browser"
 
#add the role to the policy
$newPolicy.roles += $newRole

#a policy must have roles
$roleDataType = ($type + '.Role')
$newRole = New-Object ($roleDataType)
$newRole.Name = "Content Manager"
 
#add the role to the policy
$newPolicy.roles += $newRole
 
#check if this user already exists in your policy array
#if user does not exist yet with current role, add policy
if ($($newPolicies | 
      ForEach-Object {$_.GroupUserName}) -notcontains $newPolicy.GroupUserName)
{
	$newPolicies += $newPolicy
}


#set the policies
$proxy.SetPolicies($itemPath,$newPolicies)

#list new report users
$proxy.GetPolicies($itemPath, [ref]$inherit)
