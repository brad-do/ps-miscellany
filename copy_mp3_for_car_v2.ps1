<#
DadOverflow.com

Date: 28 April 2019
Using a CSV file I created to represent my MP3 inventory, this script will copy select mp3s to a thumb drive
based on genre or whatever other song characteristics I choose.

This script is a new version over one I wrote a year ago.  The slight improvements include:
1. It will exclude not only certain artists but also certain albums
2. It will automatically include songs with "speech" in the title (I seem to have a lot of albums that include speech audio from the artist)
3. It writes out a few more details to the screen like how many files were written to the USB drive, the total size of those files, and how
long it took to run the script.
#>

$runtime = [System.Diagnostics.Stopwatch]::StartNew()

$music_collection = ipcsv "$Env:USERPROFILE\Music\music_collection.csv" -Encoding UTF8
$flashdrive_location = "L:\"
$flashdrive_size = 14250MB  # my song selections will likely exceed the size of the flash drive, so set that size limit here

# $genres_to_include = "Pop", "Rock", "Hard Rock & Metal"
$genres_to_include = "Metal", "Hard Rock & Metal"

$album_artists_to_exclude = "ABBA", "Disney", "High School Musical Cast", "The Beach Boys"
$albums_to_exclude = "Frozen [Original Motion Picture Soundtrack]", "High School Musical 2 [Original Soundtrack]", "The Smurfs 2- Music from and Inspired By"

function Convert-FileSizeToMB($size){
    $return_val = 0

    switch ( $size.split(" ")[1] ){
        "GB" { $return_val = [double]$size.split(" ")[0] * 1GB }
        "MB" { $return_val = [double]$size.split(" ")[0] * 1MB }
        "KB" { $return_val = [double]$size.split(" ")[0] * 1KB }
    }

    return $return_val
}

$mp3s_to_write_to_drive = $music_collection | where {$genres_to_include -contains $_.genre} | where {$album_artists_to_exclude -notcontains $_.album_artist} | 
    where {$albums_to_exclude -notcontains $_.album} | where {$_.song -notlike "*speech*"} | sort {random}

$size_of_files = 0
$nbr_of_songs_written = 0

foreach ($mp3 in $mp3s_to_write_to_drive){
    if ($size_of_files -le $flashdrive_size){
        $size_of_files += Convert-FileSizeToMB $mp3.file_size
        Copy-Item -LiteralPath $mp3.file $flashdrive_location
        $nbr_of_songs_written++
    }else{
        break
    }
}

Write-Host "Nbr of songs written to flash drive: " $nbr_of_songs_written
Write-Host "Total size of files written to flash drive: " $size_of_files
Write-Host "Total number of minutes the script ran for: " $runtime.Elapsed.TotalMinutes