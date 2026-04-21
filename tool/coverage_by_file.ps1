$records = @()
$currentFile = $null
$lf = 0
$lh = 0

Get-Content "coverage/lcov.info" | ForEach-Object {
  if ($_ -like "SF:*") {
    if ($currentFile) {
      $pct = if ($lf -eq 0) { 0 } else { [math]::Round(($lh * 100.0 / $lf), 2) }
      $records += [pscustomobject]@{
        File = $currentFile
        LF = $lf
        LH = $lh
        Coverage = $pct
      }
    }
    $currentFile = $_.Substring(3)
    $lf = 0
    $lh = 0
  } elseif ($_ -like "LF:*") {
    $lf = [int]$_.Substring(3)
  } elseif ($_ -like "LH:*") {
    $lh = [int]$_.Substring(3)
  }
}

if ($currentFile) {
  $pct = if ($lf -eq 0) { 0 } else { [math]::Round(($lh * 100.0 / $lf), 2) }
  $records += [pscustomobject]@{
    File = $currentFile
    LF = $lf
    LH = $lh
    Coverage = $pct
  }
}

$records |
  Sort-Object Coverage, LF |
  Select-Object -First 40 |
  Format-Table -AutoSize
