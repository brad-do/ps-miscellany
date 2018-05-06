<#
DadOverflow.com

Date: 6 May 2018
Using a json file I created to represent my MP3 inventory, this script will copy select mp3s to a thumb drive
based on genre or whatever other song characteristics I choose.
#>
function Convert-FileSizeToMB($size){
    $return_val = 0

    switch ( $size.split(" ")[1] ){
        "GB" { $return_val = [double]$size.split(" ")[0] * 1GB }
        "MB" { $return_val = [double]$size.split(" ")[0] * 1MB }
        "KB" { $return_val = [double]$size.split(" ")[0] * 1KB }
    }

    return $return_val
}

$sw = [system.diagnostics.stopwatch]::StartNew()

$music_folder = "$Env:USERPROFILE\Music"  # path to my music files
$mp3_col = Get-Content ($music_folder + "\mp3_collection.json") | Out-String | ConvertFrom-Json
$flashdrive_location = "C:\temp_music_folder"  # set the location of your flashdrive here
$flashdrive_size = 14250MB  # my song selections will likely exceed the size of the flash drive, so set that size limit here

# song selection criteria
$genres_i_want = "Metal", "Hard Rock & Metal", "Rock", "Rock; Hard Rock & Metal"
$bands_to_skip = "Mel Tormé", "Starland Vocal Band", "Burt Bacharach"

# apply my selection criteria and get a list of the songs to copy over to the flashdrive
$mp3s_to_write_to_drive = $mp3_col | where {$genres_i_want -contains $_.genre} | where {$bands_to_skip -notcontains $_.artist}

$size_of_files = 0
foreach ($mp3 in $mp3s_to_write_to_drive){
    if ($size_of_files -le $flashdrive_size){
        $size_of_files += Convert-FileSizeToMB $mp3.file_size
        Copy-Item -LiteralPath $mp3.file $flashdrive_location
    }else{
        break
    }
}


$sw.Stop()
"This script took {0} minutes and {1} seconds to run" -f [math]::floor($sw.Elapsed.TotalMinutes), $sw.Elapsed.Seconds