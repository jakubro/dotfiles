Set-StrictMode -Version 2.0

function Enter-PythonEnvironment {
  # Automatically (de/)activate Python virtual environment (venv),
  # depending on the current location.

  # deactivate
  if ($env:VirtualEnvRoot) {
    Deactivate-PythonEnvironment $PWD.Path
  }

  # activate
  if (!$env:VirtualEnvRoot) {
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
  if (!$Path.StartsWith($env:VirtualEnvRoot) -or
      !(Test-Path (Join-Path $env:VirtualEnvRoot '.venv'))) {
    deactivate
    $env:VirtualEnvRoot = $null
    $env:ParentPSPromptName = $null
  }
}

function Activate-PythonEnvironment($Path) {
  $activate = Join-Path $Path '.venv\Scripts\Activate.ps1'
  if (Test-Path $activate) {
    $env:VirtualEnvRoot = $Path
    $env:VIRTUAL_ENV_DISABLE_PROMPT = $true
    $env:ParentPSPromptName = Split-Path -Leaf $Path
    & $activate
    return $true
  }
  return $false
}

Export-ModuleMember -Function Enter-PythonEnvironment
