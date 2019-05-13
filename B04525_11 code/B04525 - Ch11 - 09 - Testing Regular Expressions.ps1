<#============================================================================
  File:     B04525 - Ch11 - 09 - Testing Regular Expressions.ps1
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

$VerbosePreference = "Continue"

#check if valid email address
$str = "info@sqlbelle.com"
$pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.(?:[A-Z]{2}|com|org|net|gov|ca|mil|biz|info|mobi|name|aero|jobs|museum)$"

if ($str -match $pattern)
{
   Write-Verbose "Valid Email Address"
}
else
{ 
	Write-Verbose "Invalid Email Address"
}

#another way to test 
[Regex]::Match($str, $pattern)

#can also use regex in switch
$str = "V1A 2V1"
$str = "90250"

switch -regex ($str)
{
   "(^\d{5}$)|(^\d{5}-\d{4}$)" 
   { 
        Write-Verbose "Valid US Postal Code" 
   }
   "[A-Za-z]\d[A-Za-z]\s*\d[A-Za-z]\d"
   {
        Write-Verbose "Valid Canadian Postal Code" 
   }
   default 
   { 
        Write-Verbose "Don't Know" 
   }
}

#use regex and extract matches
#to create named groups - use format ?<groupname>
$str = "Her number is (604)100-1004. Sometimes she can be reached at (604)100-1005."

$pattern = @"
(?<phone>\(\d{3}\)\d{3}-\d{4})
"@

$m = [regex]::Matches($str, $pattern)

#list individual phones
$m | 
Foreach-Object {
   Write-Verbose "$($_.Groups["phone"].Value)"
}

$VerbosePreference = "SilentlyContinue"

