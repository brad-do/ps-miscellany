<#
Brad, DadOverflow.com
Has this ever happened to you: you have a nice multi-monitor set up at either work or home.
You take a lot of time carefully moving particular apps to particular monitors: maybe maximizing
some apps or mounting them to one side or another.  You are then drawn away from your workstation, 
say to get some coffee, and lock your workstation before you leave.  When you return and unlock
your workstation, all your carefully positioned applications across your multiple monitors are
all sitting on your primary monitor and your other monitors are empty.  So now, do you go back to
carefully arranging all your applications again?  No, you write a script to do that!  In a previous
script, launch_ubuntu_windows.ps1, I had PowerShell launch N number of WSL Ubuntu instances and
evenly position them on the left most monitor of my multi-monitor system.  Yet many times, when
I lock my system and come back after time, all that hard work is undone as I described above.
In those circumstances, this script will find all open WSL Ubuntu instances and carefully
reposition them in my lef-most monitor.
#>

Import-Module Set-Window
Add-Type -AssemblyName System.Windows.Forms

$nbr_of_windows_to_open = 2
$ubuntu_path = "C:\Users\brad\AppData\Local\Microsoft\WindowsApps\ubuntu.exe"
$left_most_screen = [System.Windows.Forms.Screen]::AllScreens|sort -Property {$_.WorkingArea.X}|select -First 1
$x = $left_most_screen.WorkingArea.X
$screen_width = $left_most_screen.WorkingArea.Width
$screen_height = $left_most_screen.WorkingArea.Height

$running_ubuntu_pids = Get-Process|?{$_.Name -eq "Ubuntu"}|select Id
$count = 1
foreach($uPid in $running_ubuntu_pids){
    $y = ( ($_ - 1) * ($screen_height / $nbr_of_windows_to_open) )
    $h = ( $screen_height / $nbr_of_windows_to_open )
    Set-Window -ProcessId $app.Id -X $x -Y $y -Width $screen_width -Height $h -Passthru
    # strangely, on some monitors, the first Set-Window doesn't quite take, but setting it again seems to work
    Set-Window -ProcessId $app.Id -X $x -Y $y -Width $screen_width -Height $h -Passthru
}