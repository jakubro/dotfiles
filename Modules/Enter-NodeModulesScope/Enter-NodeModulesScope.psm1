Set-StrictMode -Version 2.0

function Enter-NodeModulesScope {
  # Automatically prepend node_modules/.bin to the PATH

  $roots = $env:PSNodeModulesScopeRoot
  if (!$roots) {
    $roots = $env:PSNodeModulesScopeRoot = New-Object Collections.Generic.List[string]
  }

  # deactivate
  Deactivate-NodeModulesScope $roots
  $roots.Clear()

  # activate
  $path = $PWD.Path
  while ($path) {
    $root = Activate-NodeModulesScope $path
    if ($root) {
      $roots.Add($root)
    }
    $path = Split-Path -Parent $path
  }
}

function Activate-NodeModulesScope($Path) {
  $root = Get-NodeModulesBinPath $Path
  if (!($root -eq $null)) {
    PrependTo-Path $root
    return $root
  }
  return $null
}

function Deactivate-NodeModulesScope($Roots) {
  foreach ($root in $Roots) {
    RemoveFrom-Path $root
  }
}

function Get-NodeModulesBinPath($Path) {
  $bin = Join-Path $Path 'node_modules\.bin'
  if (Test-Path $bin) {
    return $bin
  } else {
    return $null
  }
}

function PrependTo-Path([string] $Value) {
  $env:Path = "${Value};${env:Path}"
}

function RemoveFrom-Path([string] $Value) {
  $env:Path = $env:Path -replace "${Value};", ""
  $env:Path = $env:Path -replace $Value, ""
}

Export-ModuleMember -Function Enter-NodeModulesScope
