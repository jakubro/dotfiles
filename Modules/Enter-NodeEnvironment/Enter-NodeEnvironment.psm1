Set-StrictMode -Version 2.0

function Enter-NodeEnvironment {
  # Automatically switch Node.js interpreter, depending on the current location.

  # deactivate
  if ($env:NodeEnvRoot) {
    Deactivate-NodeEnvironment $PWD.Path
  }

  # activate
  if (!$env:NodeEnvRoot) {
    $path = $PWD.Path
    while ($path) {
      if (Activate-NodeEnvironment $path) {
        break
      }
      $path = Split-Path -Parent $path
    }
  }
}

function Deactivate-NodeEnvironment($Path) {
  if (!$Path.StartsWith($env:NodeEnvRoot) -or
      !(Test-Path (Join-Path $env:NodeEnvRoot '.nvmrc'))) {
    Set-NodeRuntime
    $env:NodeEnvRoot = $null
  }
}

function Activate-NodeEnvironment($Path) {
  $nvmrc = Join-Path $Path '.nvmrc'
  if (Test-Path $nvmrc) {
    $env:NodeEnvRoot = $Path
    $version = Get-Content $nvmrc
    if (![string]::IsNullOrWhiteSpace($version)) {
      $version = $version.TrimStart('v')
      Set-NodeRuntime $version
      return $true
    }
  }
  return $false
}

Export-ModuleMember -Function Enter-NodeEnvironment
