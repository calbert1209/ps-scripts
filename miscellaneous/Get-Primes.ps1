
function Get-Primes {
  Param (
    # Parameter help description
    [Parameter(Mandatory=$true)]
    [int]
    $Limit
  )

  $primes = @(2,3,5,7,11,13,19,23,29);
  for ($i = 30; $i -lt $Limit; $i++) {
    foreach ($prime in $primes) {
      if ($i % $prime -eq 0){
        continue;
      }
    }
    $primes += $i
  }

  return $primes
}

