<#
DadOverflow.com

Date: 28 April 2019
Description: I have a large music catalog.  I'd like to listen to as much of that catalog as possible in my car via a flash drive.  The problem is, 
my car seems to not like it when I pack thousands of songs in sub-directories and so forth on the flash drive.  One way I thought I could better
manage this problem is to develop a script that would first inventory my music catalog.  Then, I could set up specific selection criteria fo the songs
I'd really like to listen to in the car.  One criteria that comes to mind is genre: my script could grab all the songs belonging to the genres I want
to listen to and copy those songs to my flash drive.  This script creates an inventory file of my music that includes properties like "genre".
I will then write another script that will load that inventory file and decide which songs should go on my flashdrive.

This script is a newer version to one I previously wrote.  It makes a few slight improvements:
1. Occasionally, there will be brackets, ampersands, or other odd characters in my filepaths that PowerShell's Select-Object cmdlet seems to have 
challenges with.  So, to speed up the "select -Unique" operation, I escape all those odd characters.  However, later, the Shell.Application object
has trouble processing filepaths with escaped characters, so I make sure to unescape my filepaths before passing those paths to Shell.Application.
2. I added both contributing artist and album artist fields to the inventory so that I have more filtering options.
3. I write the inventory to a CSV instead of JSON file so that I can easily open the CSV in Excel to do data quality checks.
4. Since some of my music includes artists with accented characters in their names, I encode the CSV in UTF8 to preserve that information.
#>

# https://devblogs.microsoft.com/scripting/list-music-file-metadata-in-a-csv-and-open-in-excel-with-powershell/
$runtime = [System.Diagnostics.Stopwatch]::StartNew()

$music_folder = "$Env:USERPROFILE\Music"
$dirs_to_exclude = "$music_folder\soundclips", "$music_folder"
$mp3_collection = @()

$mp3_folders = dir "$music_folder\*.mp3" -Recurse | where {$dirs_to_exclude -notcontains $_.Directory.FullName} | select Directory | %{[RegEx]::Escape($_.Directory)} | select -Unique | %{[RegEx]::Unescape($_)}

foreach($mp3_folder in $mp3_folders){
    $shell = (New-Object -ComObject Shell.Application).NameSpace($mp3_folder)
    foreach($mp3_object in $shell.Items()){
        if($shell.GetDetailsOf($mp3_object, 2) -like "MP3 File"){
            $mp3_file = [pscustomobject]@{'file' = $mp3_folder + '\' + $shell.GetDetailsOf($mp3_object, 0); 
                                          'contributing_artist' = $shell.GetDetailsOf($mp3_object, 13);
                                          'album_artist' = $shell.GetDetailsOf($mp3_object, 238);
                                          'album' = $shell.GetDetailsOf($mp3_object, 14);
                                          'album_year' = $shell.GetDetailsOf($mp3_object, 15);
                                          'genre' = $shell.GetDetailsOf($mp3_object, 16);
                                          'song' = $shell.GetDetailsOf($mp3_object, 21);
                                          'file_size' = $shell.GetDetailsOf($mp3_object, 1);
                                          'length' = $shell.GetDetailsOf($mp3_object, 27)}
            $mp3_collection += $mp3_file
        }
    }
    $shell = $null
}

# collect and write out some stats about my music catalog
$total_size = 0
$mp3_collection | select file_size | where {!$_.file_size.EndsWith('KB') } |  % {$total_size += [double]($_.file_size.Replace('MB', '').Trim())}

$total_length_seconds = 0
$mp3_collection | select length | % {$total_length_seconds += [timespan]::Parse($_.length).TotalSeconds}

Write-Host 'Song count: ' $mp3_collection.Count
Write-Host 'Album count: ' ($mp3_collection | select album -Unique).Count
Write-Host 'Number of genres: ' ($mp3_collection | select genre -Unique).Count
Write-Host 'Size of catalog in GB: ' (($total_size * 1024 * 1024) / 1GB)
Write-Host 'Total hours of listening time: ' ([timespan]::fromseconds($total_length_seconds).TotalHours)
Write-Host 'Total runtime for script (in minutes): ' $runtime.Elapsed.TotalMinutes

$mp3_collection | Export-Csv -Path "$music_folder\music_collection.csv" -NoTypeInformation -Encoding UTF8