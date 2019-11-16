
$i = 0
while ($true) {
  $i = (($i + 1) % 100) 
  Write-Progress -Activity "Doin' work, okay" -PercentComplete $i;
}