<#
DadOverflow.com

Date: 6 May 2018
Description: I have a large music catalog.  I'd like to listen to as much of that catalog as possible in my car via a flash drive.  The problem is, 
my car seems to not like it when I pack thousands of songs in sub-directories and so forth on the flash drive.  One way I thought I could better
manage this problem is to develop a script that would first inventory my music catalog.  Then, I could set up specific selection criteria fo the songs
I'd really like to listen to in the car.  One criteria that comes to mind is genre: my script could grab all the songs belonging to the genres I want
to listen to and copy those songs to my flash drive.  This script creates an inventory file of my music that includes properties like "genre".
I will then write another script that will load that inventory file and decide which songs should go on my flashdrive.

Note: between the large amount of files I have and invoke the COM object shell.application, this script does take a very long time to run.  
Originally, I tried several of the .NET open source APIs on github.com, nuget.org, and sourceforge.net that purport to read the ID3 tags of MP3s but 
could not get any of them to work.  Finally, I resorted to the COM object shell.application to read the ID3 tags, like genre, I need to read and filter on.
Also, I strongly recommend you walk through the script first and maybe even only run small portions at a time.  You will likely have to adjust many of these
settings to your specific environment.
#>

# inspiration for using shell.application came from here:
# http://www.powershellmagazine.com/2015/04/13/pstip-use-shell-application-to-display-extended-file-attributes/

$music_folder = "$Env:USERPROFILE\Music"  # path to my music files
$dirs_to_exclude = "$Env:USERPROFILE\Music\soundclips"  # sub-dirs to exclude from the music collection
$mp3_collection = @()

$sw = [system.diagnostics.stopwatch]::StartNew()

# get a list of all the sub-directories containing MP3 files
$mp3_folders = dir "$music_folder\*.mp3" -Recurse | select Directory -Unique | where {$dirs_to_exclude -notcontains $_.Directory.FullName}

# magic numbers used by the shell.application (had to figure out by trial and error)
# 0: file name
# 1: file size
# 2: "MP3 File"
# 3: create date
# 4: modify date
# 5: modify date
# 6: "A"
# 7: nothing
# 8: "Available offline"
# 9: "Audio"
# 10: user info
# 11: "Music"
# 12: nothing
# 13: artist
# 14: album name
# 15: album date
# 16: genre
# 19: rating
# 20: band name
# 21: name of song
# 26: song number on album
# 27: song length
# 28: bit rate

# now, loop through all my music folders to collect all the MP3s I want to process; store them in the $mp3_collection collection object
foreach($mp3_folder in $mp3_folders){
    $shell = (New-Object -ComObject Shell.Application).NameSpace($mp3_folder.Directory.FullName)
    foreach($mp3_object in $shell.Items()){
        if($shell.GetDetailsOf($mp3_object, 2) -like "MP3 File"){
            $mp3_file = [pscustomobject]@{'file' = $mp3_folder.Directory.FullName + '\' + $shell.GetDetailsOf($mp3_object, 0); 
                                          'artist' = $shell.GetDetailsOf($mp3_object, 13);
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

# save collection to json object
$mp3_collection | ConvertTo-Json -Depth 5 | Out-File ($music_folder + "\mp3_collection.json")

Write-Host 'Song count: ' $mp3_collection.Count
Write-Host 'Album count: ' ($mp3_collection | select album -Unique).Count
Write-Host 'Number of genres: ' ($mp3_collection | select genre -Unique).Count
Write-Host 'Size of catalog in GB: ' (($total_size * 1024 * 1024) / 1GB)
Write-Host 'Total hours of listening time: ' ([timespan]::fromseconds($total_length_seconds).TotalHours)

$sw.Stop()
"This script took {0} minutes and {1} seconds to run" -f [math]::floor($sw.Elapsed.TotalMinutes), $sw.Elapsed.Seconds