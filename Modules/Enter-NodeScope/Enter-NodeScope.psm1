Set-StrictMode -Version 2.0

function Enter-NodeScope {
  # Automatically switch Node.js interpreter, depending on the current location.

  # deactivate
  if ($env:PSNodeScopeRoot) {
    Deactivate-NodeScope
  }

  # activate
  if (!$env:PSNodeScopeRoot) {
    $path = $PWD.Path
    while ($path) {
      if (Activate-NodeScope $path) {
        break
      }
      $path = Split-Path -Parent $path
    }
  }
}

function Activate-NodeScope($Path) {
  $config = Import-NodeScopeConfig $Path
  $version = $config.version
  if (!($version -eq $null)) {
    $env:PSNodeScopeRoot = $Path
    Set-NodeRuntime -Version $version
    return $true
  }
  return $false
}

function Deactivate-NodeScope() {
  Set-NodeRuntime
  $env:PSNodeScopeRoot = $null
}

function Import-NodeScopeConfig($Path) {
  $rv = @{ version = $null }
  try {
    $config = Join-Path $Path '.nvmrc'
    if (Test-Path $config) {
      $config = Get-Content $config | Out-String | ConvertFrom-StringData
      $version = $config.version
      if (![string]::IsNullOrWhiteSpace($version)) {
        $rv.version = $version.Trim()
      }
    }
    return $rv
  }
  catch {
    return $rv
  }
}

Export-ModuleMember -Function Enter-NodeScope
