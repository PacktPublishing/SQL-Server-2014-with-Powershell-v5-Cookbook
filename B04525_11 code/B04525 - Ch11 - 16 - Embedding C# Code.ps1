<#============================================================================
  File:     B04525 - Ch11 - 16 - Embedding C# Code.ps1
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

#define code
#note this can also come from a file

$code = @"
using System;
public class HelloWorld
{
   public static string SayHello(string name)
   {
      return (String.Format("Hello there {0}", name));
   }
   public string GetLuckyNumber(string name)
   {
      Random random = new Random();
      int randomNumber = random.Next(0, 100);
      string message = String.Format("{0}, your lucky" +
                       " number for today is {1}", 
                       name, randomNumber);
      return message;
   }
}
"@

#add this code to current session
Add-Type -TypeDefinition $code

#call static method
[HelloWorld]::SayHello("belle")

#create instance
$instance = New-Object HelloWorld

#call instance method
$instance.GetLuckyNumber("belle")
