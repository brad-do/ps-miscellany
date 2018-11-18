<#
Brad, DadOverflow.com
This is a quick and dirty script to launch a few WSL Ubuntu instances and position them nicely in the left-most
monitor of a multi-monitor system.  This script leverages the Set-Window script
(https://gallery.technet.microsoft.com/scriptcenter/Set-the-position-and-size-54853527) with a few small modifications:
1. I saved the Set-Window script as a module (PSM1) so that I can easily load it into multiple PowerShell scripts
2. I changed the parameter ProcessName to ProcessId and changed associated functionality.  That way, I can be a little
more targetted in what I position, passing in a PID that's unique to the process I want to position.
#>

Import-Module Set-Window
Add-Type -AssemblyName System.Windows.Forms

$nbr_of_windows_to_open = 2
$ubuntu_path = "C:\Users\brad\AppData\Local\Microsoft\WindowsApps\ubuntu.exe"
$left_most_screen = [System.Windows.Forms.Screen]::AllScreens|sort -Property {$_.WorkingArea.X}|select -First 1
$x = $left_most_screen.WorkingArea.X
$screen_width = $left_most_screen.WorkingArea.Width
$screen_height = $left_most_screen.WorkingArea.Height

1..$nbr_of_windows_to_open|%{
    $app = Start-Process $ubuntu_path -PassThru
    Start-Sleep -Seconds 3
    $y = ( ($_ - 1) * ($screen_height / $nbr_of_windows_to_open) )
    $h = ( $screen_height / $nbr_of_windows_to_open )
    Set-Window -ProcessId $app.Id -X $x -Y $y -Width $screen_width -Height $h -Passthru
    # strangely, on some monitors, the first Set-Window doesn't quite take, but setting it again seems to work
    Set-Window -ProcessId $app.Id -X $x -Y $y -Width $screen_width -Height $h -Passthru
}

