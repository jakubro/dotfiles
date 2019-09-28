Set-StrictMode -Version 2.0

function Enter-WSLScope {
  # Automatically switch WSL distibution, depending on the current location.

  # deactivate
  if ($env:PSWSLScopeRoot) {
    Deactivate-WSLScope
  }

  # activate
  if (!$env:PSWSLScopeRoot) {
    $path = $PWD.Path
    while ($path) {
      if (Activate-WSLScope  $path) {
        break
      }
      $path = Split-Path -Parent $path
    }
  }
}

function Activate-WSLScope($Path) {
  $config = Import-WSLScopeConfig $Path
  $distribution = $config.distribution
  if (!($distribution -eq $null)) {
    $env:PSWSLScopeRoot = $Path
    Set-WSLRuntime -Distribution $distribution
    return $true
  }
  return $false
}

function Deactivate-WSLScope() {
  Set-WSLRuntime
  $env:PSWSLScopeRoot = $null
}

function Import-WSLScopeConfig($Path) {
  $rv = @{ distribution = $null }
  try {
    $config = Join-Path $Path '.wslrc'
    if (Test-Path $config) {
      $config = Get-Content $config | Out-String | ConvertFrom-StringData
      $distribution = $config.distribution
      if (![string]::IsNullOrWhiteSpace($distribution)) {
        $rv.distribution = $distribution.Trim()
      }
    }
    return $rv
  }
  catch {
    return $rv
  }
}

Export-ModuleMember -Function Enter-WSLScope
