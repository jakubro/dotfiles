Set-StrictMode -Version 2.0

function Test-Command($Command) {
  try {
    Get-Command $command -ErrorAction Stop
    return $true
  } catch {
    return $false
  }
}
