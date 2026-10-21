Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$srcDir = Join-Path $root 'assets\screenshots'
$outDir = Join-Path $srcDir 'store'
New-Item -ItemType Directory -Force $outDir | Out-Null

$slides = @(
  @{ File = 'IMG_5311.PNG'; Main = '成長がひと目でわかる'; Sub = '重量と回数の推移を自動でグラフ化' },
  @{ File = 'IMG_5309.PNG'; Main = '毎日の記録をカレンダーで'; Sub = '鍛えた部位がひと目でわかる' },
  @{ File = 'IMG_5310.PNG'; Main = '記録は重量と回数だけ'; Sub = 'その日のメニューをかんたん管理' },
  @{ File = 'IMG_5312.PNG'; Main = '毎月の成長を分析'; Sub = '伸びた種目・停滞した種目をランクで評価' },
  @{ File = 'IMG_5313.PNG'; Main = 'PROで全期間を見放題'; Sub = '広告なし・月額250円' }
)

$W = 1206
$H = 2622
$fontName = 'Yu Gothic UI'
$gold = [System.Drawing.Color]::FromArgb(255, 255, 193, 7)
$white = [System.Drawing.Color]::FromArgb(235, 255, 255, 255)

function New-RoundedPath([float]$x, [float]$y, [float]$w, [float]$h, [float]$r) {
  $p = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = $r * 2
  $p.AddArc($x, $y, $d, $d, 180, 90)
  $p.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
  $p.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
  $p.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
  $p.CloseFigure()
  return $p
}

function Draw-FittedText($g, [string]$text, [float]$maxSize, [float]$maxWidth, [float]$centerY, $color, $style) {
  $size = $maxSize
  $fmt = [System.Drawing.StringFormat]::GenericTypographic
  while ($true) {
    $font = New-Object System.Drawing.Font($fontName, $size, $style, [System.Drawing.GraphicsUnit]::Pixel)
    $m = $g.MeasureString($text, $font, 10000, $fmt)
    if ($m.Width -le $maxWidth -or $size -le 20) { break }
    $font.Dispose()
    $size -= 2
  }
  $brush = New-Object System.Drawing.SolidBrush($color)
  $x = ($W - $m.Width) / 2
  $y = $centerY - $m.Height / 2
  $g.DrawString($text, $font, $brush, $x, $y, $fmt)
  $brush.Dispose(); $font.Dispose()
}

$i = 1
foreach ($s in $slides) {
  $src = [System.Drawing.Image]::FromFile((Join-Path $srcDir $s.File))
  $bmp = New-Object System.Drawing.Bitmap $W, $H, ([System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.InterpolationMode = 'HighQualityBicubic'
  $g.TextRenderingHint = 'AntiAliasGridFit'

  $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point 0, 0), (New-Object System.Drawing.Point 0, $H),
    [System.Drawing.Color]::FromArgb(255, 27, 35, 64), [System.Drawing.Color]::FromArgb(255, 10, 13, 22))
  $g.FillRectangle($bg, 0, 0, $W, $H)
  $bg.Dispose()

  Draw-FittedText $g $s.Main 104 1080 250 $gold ([System.Drawing.FontStyle]::Bold)
  Draw-FittedText $g $s.Sub 52 1080 400 $white ([System.Drawing.FontStyle]::Regular)

  $shotW = 940
  $shotH = [int]($shotW * $src.Height / $src.Width)
  $shotX = ($W - $shotW) / 2
  $shotY = 540
  $path = New-RoundedPath $shotX $shotY $shotW $shotH 56
  $glow = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(110, 255, 193, 7), 6)
  $g.DrawPath($glow, $path)
  $g.SetClip($path)
  $g.DrawImage($src, [float]$shotX, [float]$shotY, [float]$shotW, [float]$shotH)
  $g.ResetClip()
  $glow.Dispose(); $path.Dispose()

  $out = Join-Path $outDir ('{0:D2}_{1}' -f $i, $s.File.ToLower())
  $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
  Write-Output ("{0} src={1}x{2}" -f $out, $src.Width, $src.Height)
  $src.Dispose()
  $i++
}
