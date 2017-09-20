Set-StrictMode -Version 2.0

function Format-Color([hashtable] $Colors = @{}) {
  $lines = ($input | Out-String) -replace "`r", "" -split "`n"
  foreach ($line in $lines) {
    $color = ""
    foreach ($pattern in $Colors.Keys){
      if ($line -match $pattern) {
        $color = $Colors[$pattern]
      }
    }
    if ($color) {
      Write-Host -ForegroundColor $color $line
    } else {
      Write-Host $line
    }
  }
}
