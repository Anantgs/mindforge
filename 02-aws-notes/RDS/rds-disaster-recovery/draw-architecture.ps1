Add-Type -AssemblyName System.Drawing
$bitmap = New-Object System.Drawing.Bitmap 1800, 1120
$g = [System.Drawing.Graphics]::FromImage($bitmap)
$g.SmoothingMode = 'AntiAlias'
$g.TextRenderingHint = 'AntiAliasGridFit'
$g.Clear([System.Drawing.Color]::White)
$ink = [System.Drawing.Color]::FromArgb(35,50,70)
$muted = [System.Drawing.Color]::FromArgb(87,104,125)
$border = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(185,198,212)), 2
$edge = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(91,113,137)), 3
$edge.CustomEndCap = New-Object System.Drawing.Drawing2D.AdjustableArrowCap 5, 6
$heading = New-Object System.Drawing.Font 'Segoe UI', 25, ([System.Drawing.FontStyle]::Bold)
$subheading = New-Object System.Drawing.Font 'Segoe UI', 16, ([System.Drawing.FontStyle]::Bold)
$font = New-Object System.Drawing.Font 'Segoe UI', 14
$small = New-Object System.Drawing.Font 'Segoe UI', 11
$format = New-Object System.Drawing.StringFormat
$format.Alignment = 'Center'
$format.LineAlignment = 'Center'
$textBrush = New-Object System.Drawing.SolidBrush $ink
$mutedBrush = New-Object System.Drawing.SolidBrush $muted
function Text($text,$font,$brush,$x,$y,$w,$h) {
  $rect = New-Object System.Drawing.RectangleF ([single]$x),([single]$y),([single]$w),([single]$h)
  $g.DrawString($text,$font,$brush,$rect,$format)
}
function Box($x,$y,$w,$h,$text,$color) {
  $fill = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml($color))
  $g.FillRectangle($fill,$x,$y,$w,$h)
  $g.DrawRectangle($border,$x,$y,$w,$h)
  Text $text $font $textBrush $x $y $w $h
  $fill.Dispose()
}
function Arrow($x1,$y1,$x2,$y2) { $g.DrawLine($edge,$x1,$y1,$x2,$y2) }
Text 'Commerce application - disaster recovery architecture' $heading $textBrush 100 20 1600 55
Box 690 90 420 55 'Users / Browser  |  HTTPS :443' '#EDF4FB'
Box 635 180 530 65 'Route 53 - manual primary / DR cutover' '#EDF4FB'
Arrow 900 145 900 180

foreach ($region in @(@{X=35; Name='PRIMARY  |  us-east-1'; Role='Primary writer - Multi-AZ'}, @{X=925; Name='DISASTER RECOVERY  |  us-west-2'; Role='Read replica - promote during DR'})) {
  $x = $region.X
  $fill = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml('#F7F9FC'))
  $g.FillRectangle($fill,$x,300,840,690); $g.DrawRectangle($border,$x,300,840,690); $fill.Dispose()
  Text $region.Name $subheading $textBrush ($x+20) 310 800 45
  Text 'VPC  |  two Availability Zones' $small $mutedBrush ($x+20) 350 800 28
  Box ($x+155) 405 530 82 "Public ALB in two public subnets`nACM HTTPS termination  |  HTTP -> HTTPS" '#E1ECFA'
  Text 'HTTP :80' $small $mutedBrush ($x+340) 490 160 28
  Box ($x+55) 555 315 90 "Private app subnet - AZ 1`nEC2 commerce application" '#E7F3E8'
  Box ($x+470) 555 315 90 "Private app subnet - AZ 2`nEC2 commerce application" '#E7F3E8'
  Box ($x+155) 755 530 100 "Isolated database subnets - 2 AZs`nRDS PostgreSQL: $($region.Role)" '#FFF0E1'
  Arrow ($x+300) 487 ($x+215) 555
  Arrow ($x+540) 487 ($x+625) 555
  Arrow ($x+215) 645 ($x+300) 755
  Arrow ($x+625) 645 ($x+540) 755
  Text 'TLS :5432' $small $mutedBrush ($x+340) 695 160 28
}
Arrow 760 245 455 405
Arrow 1040 245 1345 405
Arrow 720 805 1080 805
Text 'Asynchronous replication' $small $mutedBrush 735 765 330 32
Text 'Recovery: stop primary writes, promote the replica, verify the app, then switch DNS.' $font $textBrush 160 1030 1480 45
$bitmap.Save((Join-Path $PSScriptRoot 'architecture.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bitmap.Dispose(); $border.Dispose(); $edge.Dispose(); $heading.Dispose(); $subheading.Dispose(); $font.Dispose(); $small.Dispose(); $format.Dispose(); $textBrush.Dispose(); $mutedBrush.Dispose()
