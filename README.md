# Overview
This project represents a collection of different PowerShell scripts I've written to solve various problems.  It didn't seem to make sense to create new projects for each one, so I've included all of them together into one, miscellaneous project.  I'll be adding more scripts over time, more than likely.

## Calculate-Age.ps1
Suppose I want to calculate how old someone was at the time of a particular event, such as when that person died?  Well, getting the "years old" is relatively easy; however, it takes a little bit more effort to calculate the remaining months and days after that.  Here's a script that does just that.

## Convert-ExcelToCSV.psm1
PowerShell module to make it easy to convert Excel worksheets to CSV files.  To add even more convenience, check out the files *ConvertToCSV.reg* and *ConvertToCSV_Excel.Sheet.8.reg*.  These files will modify your Registry such that, when you right click on an Excel file, you'll get the option *ConvertToCSV* in the context menu.  Selecting that option will then kick off the Convert-ExcelToCSV cmdlet and convert the worksheets within the selected Excel file to CSV files.

## copy_mp3s_for_car.ps1
This script reads an inventory file of my music catalog, applies whatever filters I want to it, and writes the results to a destination path such as a flash drive.  It works in conjunction with the script, *generate_music_inventory_file.ps1*.

## copy_mp3s_for_car_v2.ps1
A newer version of copy_mp3s_for_car.ps1 with a few additional features.

## generate_music_inventory_file.ps1
This script is a modified version of the script, *organize_mp3s.ps1*.  The script basically has a single purpose: it inventories my digitized music and writes information on each song to a single JSON file.  Check out my [sample inventory file](../blob/master/sample_mp3_collection.json) for an example.

## generate_music_inventory_file_v2.ps1
A newer version of generate_music_inventory_file.ps1 with a few addtional features.

## launch_ubuntu_windows.ps1
This is a quick and dirty script to launch a few WSL Ubuntu instances and position them nicely in the left-most
monitor of a multi-monitor system.  This script leverages the [Set-Window script](https://gallery.technet.microsoft.com/scriptcenter/Set-the-position-and-size-54853527) with a few small modifications:
1. I saved the Set-Window script as a module (PSM1) so that I can easily load it into multiple PowerShell scripts
2. I changed the parameter ProcessName to ProcessId and changed associated functionality.  That way, I can be a little
more targetted in what I position, passing in a PID that's unique to the process I want to position.

Originally, I wrote this functionality in an AutoIt script called launch_ubuntu.au3, but I found PowerShell a little more flexible.

## organize_mp3s.ps1
This script catalogs my entire digitized music catalog and then allows me copy certain files over to a flash drive by whatever selection criteria I choose, such as genre.  This script has no third party dependencies: I use the shell.application COM object to gather ID3 tag information on all my MP3 files (not for a lack of trying: I tried to use several of the open source .NET ID3 libraries out on github, nuget, and sourceforge, but could get none of them to work).

## reposition_ubuntu_windows.ps1
Has this ever happened to you: you have a nice multi-monitor set up at either work or home. You take a lot of time carefully moving particular apps to particular monitors: maybe maximizing some apps or mounting them to one side or another.  You are then drawn away from your workstation, say to get some coffee, and lock your workstation before you leave.  When you return and unlock your workstation, all your carefully positioned applications across your multiple monitors are all sitting on your primary monitor and your other monitors are empty.  So now, do you go back to carefully arranging all your applications again?  No, you write a script to do that!  In a previous script, launch_ubuntu_windows.ps1, I had PowerShell launch N number of WSL Ubuntu instances and evenly position them on the left most monitor of my multi-monitor system.  Yet many times, when I lock my system and come back after time, all that hard work is undone as I described above. In those circumstances, this script will find all open WSL Ubuntu instances and carefully reposition them in my lef-most monitor.
