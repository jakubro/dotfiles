Set-StrictMode -Version 2.0

function Invoke-PipInstall {
  if (!$env:VirtualEnvRoot -or !(Test-Path (Join-Path $env:VirtualEnvRoot '.venv\Scripts\Activate.ps1'))) {
    Write-Host -ForegroundColor Yellow "Virtual environment does not exist. Creating new one ..."
    python -m venv .venv
  } else {
    Write-Host -ForegroundColor Yellow "Using virtual environment from $env:VirtualEnvRoot ..."
  }

  Enter-PythonEnvironment

  if (!(which python).Source.StartsWith((Join-Path $env:VirtualEnvRoot '.venv')) -or
      !(which pip).Source.StartsWith((Join-Path $env:VirtualEnvRoot '.venv'))) {
    throw "python.exe or pip.exe does not point to current virtual environment."
  }

  Write-Host -ForegroundColor Yellow "Installing $args ..."
  iex "pip install $args"

  Write-Host -ForegroundColor Yellow "Installed $args. Updating requirements.lock.txt ..."
  pip freeze | Out-File -Encoding ascii (Join-Path $env:VirtualEnvRoot 'requirements.lock.txt')
}
