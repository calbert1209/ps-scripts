

$times = "0:3:45,0:2:30,0:10:45"

$total = New-TimeSpan

foreach ($time in $times.split(',')) {
  $length = [timespan]$time
  Write-Host "start: $($total.toString()) length: $($length.toString())"
  $total = $total.Add([timespan]$time)
}