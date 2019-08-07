Set-StrictMode -Version 2.0

function Invoke-Pip3Do {
  Invoke-PipDo -Version 3 $args
}

function Invoke-Pip2Do {
  Invoke-PipDo -Version 2 $args
}

function Invoke-PipDo([int] $Version, $Arguments) {
  if ($Version -eq 3) {
    python3 -V
  } elseif ($Version -eq 2) {
    python2 -V
  } else {
    throw "$Version is not a valid Python version. Acceptable values are: 3, 2"
  }

  if (!$env:PythonEnvRoot -or !(Test-Path (Join-Path $env:PythonEnvRoot '.venv\Scripts\Activate.ps1'))) {
    Write-Host -ForegroundColor Yellow "Virtual environment does not exist. Creating new one ..."
    if ($Version -eq 3) {
      python3 -m venv .venv
    } elseif ($Version -eq 2) {
      python2 -m virtualenv .venv
    }
  } else {
    Write-Host -ForegroundColor Yellow "Using virtual environment from $env:PythonEnvRoot ..."
  }

  Enter-PythonEnvironment

  if (!(which python).Source.StartsWith((Join-Path $env:PythonEnvRoot '.venv')) -or
      !(which pip).Source.StartsWith((Join-Path $env:PythonEnvRoot '.venv'))) {
    throw "python.exe or pip.exe does not point to current virtual environment."
  }

  Write-Host -ForegroundColor Yellow "Running pip $Arguments ..."
  Invoke-Expression "pip $Arguments"

  Write-Host -ForegroundColor Yellow "Updating requirements.lock.txt ..."
  pip freeze | Out-File -Encoding ascii (Join-Path $env:PythonEnvRoot 'requirements.lock.txt')
}
