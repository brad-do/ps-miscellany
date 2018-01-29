# Overview
This project represents a collection of different PowerShell scripts I've written to solve various problems.  It didn't seem to make sense to create new projects for each one, so I've included all of them together into one, miscellaneous project.  I'll be adding more scripts over time, more than likely.

## Calculate-Age.ps1
Suppose I want to calculate how old someone was at the time of a particular event, such as when that person died?  Well, getting the "years old" is relatively easy; however, it takes a little bit more effort to calculate the remaining months and days after that.  Here's a script that does just that.

## Convert-ExcelToCSV.psm1
PowerShell module to make it easy to convert Excel worksheets to CSV files.  To add even more convenience, check out the files *ConvertToCSV.reg* and *ConvertToCSV_Excel.Sheet.8.reg*.  These files will modify your Registry such that, when you right click on an Excel file, you'll get the option *ConvertToCSV* in the context menu.  Selecting that option will then kick off the Convert-ExcelToCSV cmdlet and convert the worksheets within the selected Excel file to CSV files.

## organize_mp3s.ps1
This script catalogs my entire digitized music catalog and then allows me copy certain files over to a flash drive by whatever selection criteria I choose, such as genre.  This script has no third party dependencies: I use the shell.application COM object to gather ID3 tag information on all my MP3 files (not for a lack of trying: I tried to use several of the open source .NET ID3 libraries out on github, nuget, and sourceforge, but could get none of them to work).

