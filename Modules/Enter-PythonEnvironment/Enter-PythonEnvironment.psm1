Set-StrictMode -Version 2.0

function Enter-PythonEnvironment {
  # Automatically (de/)activate Python virtual environment (venv),
  # depending on the current location.

  # deactivate
  if ($env:PythonEnvRoot) {
    Deactivate-PythonEnvironment $PWD.Path
  }

  # activate
  if (!$env:PythonEnvRoot) {
    $path = $PWD.Path
    while ($path) {
      if (Activate-PythonEnvironment $path) {
        break
      }
      $path = Split-Path -Parent $path
    }
  }
}

function Deactivate-PythonEnvironment($Path) {
  if (!$Path.StartsWith($env:PythonEnvRoot) -or
      !(Test-Path (Join-Path $env:PythonEnvRoot '.venv'))) {
    deactivate
    $env:PythonEnvRoot = $null
  }
}

function Activate-PythonEnvironment($Path) {
  $activate = Join-Path $Path '.venv\Scripts\Activate.ps1'
  if (Test-Path $activate) {
    $env:PythonEnvRoot = $Path
    $env:VIRTUAL_ENV_DISABLE_PROMPT = $true  # disable Activate.ps1 to edit the prompt
    & $activate
    return $true
  }
  return $false
}

Export-ModuleMember -Function Enter-PythonEnvironment
