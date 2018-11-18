$new_width = 500

<#
$wia = New-Object -com wia.imagefile
$wia.LoadFile("C:\data_files\qsync_laptop\website_posts\nss2sDD.jpg")

$wip = New-Object -ComObject wia.imageprocess
$scale = $wip.FilterInfos.Item("Scale").FilterId                    
$wip.Filters.Add($scale)
$wip.Filters[1].Properties("MaximumWidth") = $new_width
$wip.Filters[1].Properties("MaximumHeight") = ($new_width / $wia.Width) * $wia.Height
#aspect ratio should be set as false if you want the pics in exact size 
$wip.Filters[1].Properties("PreserveAspectRatio") = $false
$wip.Apply($wia) 
$newimg = $wip.Apply($wia)
$newimg.SaveFile("C:\data_files\qsync_laptop\website_posts\ttt.jpg")
#>

Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile((Get-Item "C:\data_files\qsync_laptop\website_posts\nss2sDD.jpg"))
[int32]$new_height = ($new_width / $img.Width) * $img.Height

#$img2 = New-Object System.Drawing.Bitmap($img, $new_width, $new_height)
$img2 = New-Object System.Drawing.Bitmap($new_width, $new_height, $img.PixelFormat)

#$img2 = New-Object System.Drawing.Bitmap($new_width, $new_height)
$img2.SetResolution($img.HorizontalResolution, $img.VerticalResolution)

$graph = [System.Drawing.Graphics]::FromImage($img2)
$graph.DrawImage($img, 0, 0, $new_width, $new_height)


$img2.Save("C:\data_files\qsync_laptop\website_posts\ttt.jpg")

# ($new_width / $wia.Width) * $wia.Height