Set-StrictMode -Version 2.0

function Enter-PythonScope {
  # Automatically switch Python virtual environment, depending on the current location.

  # deactivate
  if ($env:PSPythonScopeRoot) {
    Deactivate-PythonScope $PWD.Path
  }

  # activate
  if (!$env:PSPythonScopeRoot) {
    $path = $PWD.Path
    while ($path) {
      if (Activate-PythonScope $path) {
        break
      }
      $path = Split-Path -Parent $path
    }
  }
}

function Activate-PythonScope($Path) {
  $activate = Join-Path $Path '.venv\Scripts\Activate.ps1'
  if (Test-Path $activate) {
    $env:PSPythonScopeRoot = $Path
    $env:VIRTUAL_ENV_DISABLE_PROMPT = $true  # disable Activate.ps1 to edit the prompt
    & $activate
    return $true
  }
  return $false
}

function Deactivate-PythonScope($Path) {
  deactivate
  $env:PSPythonScopeRoot = $null
}

Export-ModuleMember -Function Enter-PythonScope
