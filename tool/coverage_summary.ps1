$lf = (Select-String -Path "coverage/lcov.info" -Pattern '^LF:' | ForEach-Object {
  [int]($_.Line -replace 'LF:', '')
} | Measure-Object -Sum).Sum

$lh = (Select-String -Path "coverage/lcov.info" -Pattern '^LH:' | ForEach-Object {
  [int]($_.Line -replace 'LH:', '')
} | Measure-Object -Sum).Sum

$pct = [math]::Round(($lh * 100.0 / $lf), 2)
Write-Output "LF=$lf LH=$lh COVERAGE=$pct%"
