; Brad, DadOverflow.com
; AutoIt script to launch N number of Ubuntu instances and attempt
; to position them in my left-most monitor.

#include <AutoItConstants.au3>

Local $nbr_of_windows_to_open = 2
Local $in_office = True

Local $screen_width = 1536  ; for home
Local $screen_height = 824  ; for home

If $in_office Then
	$screen_width = 1934  ; for office
	$screen_height = 1150 ; for office
EndIf

For $i = 1 To $nbr_of_windows_to_open
	Run ("C:\Users\bvbutts\AppData\Local\Microsoft\WindowsApps\ubuntu.exe")
	Sleep(3000)
Next

Local $ubuntu_handles = WinList("[TITLE:brad@laptop: ~]")

For $i = 1 To ubuntu_handles[0][0]
	Local $x = 0
	Local $y = 0
	Local $w = 0
	Local $h = 0
	
	If $nbr_of_windows_to_open < 4 Then
		$x = 0
		$y = (($i - 1) * ($screen_height / $nbr_of_windows_to_open))
		$w = $screen_width
		$h = ($screen_height / $nbr_of_windows_to_open)
		
		If $in_office Then
			$x = -1928
		EndIf
	Else
		; need a plan to do a grid layout for 4 or more windows
	EndIf
	
	WinMove($ubuntu_handles[$i][1], "", $x, $y, $w, $h)
Next