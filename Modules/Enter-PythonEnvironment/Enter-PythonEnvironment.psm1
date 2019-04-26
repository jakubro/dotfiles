Set-StrictMode -Version 2.0

function Enter-PythonEnvironment {
  # Automatically (de/)activate Python virtual environment (venv),
  # depending on the current location.

  if ($env:VirtualEnvRoot) {
    # deactivate
    if (!$PWD.Path.StartsWith($env:VirtualEnvRoot)) {
      deactivate
      $env:VirtualEnvRoot = $null
      $env:ParentPSPromptName = $null
    }
  }

  if (!$env:VirtualEnvRoot) {
    # activate
    if (Test-Path .\.venv\Scripts\Activate.ps1) {
      $env:VirtualEnvRoot = $PWD.Path
      $env:VIRTUAL_ENV_DISABLE_PROMPT = $true
      $env:ParentPSPromptName = Split-Path -Leaf $PWD.ProviderPath
      .\.venv\Scripts\Activate.ps1
    }
  }
}
