Set-StrictMode -Version 2.0

<#
.SYNOPSIS
Changes text color on lines in input that matched specified pattern.

.PARAMETER colors
Hashtable with keys containing the pattern and values containing name of the color.

.EXAMPLE
Get-Content c:\names.txt | Format-Color -Colors @{ good = 'green'; bad = 'red' }
#>

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
