
function Out-Voice {

  Param (
    [parameter(ValueFromPipeline=$true, Mandatory=$true, Position=0)]
    [String]
    $Message,

    [parameter(Position=1)]
    [int]
    $Rate = 0,

    [parameter(Position=2)]
    [String]
    $Language = "EN-US",

    [parameter(Position=3)]
    [int]
    $Volume = 100
  )

  $speaker = New-Object -ComObject SAPI.SpVoice

  if ($Rate -ne 0) {
    $speaker.Rate = $rate
  }

  if ($Volume -ne 0) {
    $speaker.Volume = $Volume
  }

  $ucLang = $Language.ToUpperInvariant()
  $voices = $speaker.GetVoices()
  $voice = $speaker.GetVoices() | Select-Object -First 1

  if ($voices.Count -gt 1) {
    $voice = $voices | Where-Object { $_.Id -match $ucLang } | Select-Object -First 1
  }

  $speaker.Voice = $voice

  $speaker.Speak($Message) | Out-Null
}