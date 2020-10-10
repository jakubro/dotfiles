Set-StrictMode -Version 2.0

function Invoke-Pip38Do {
  Invoke-PipDo -Version '3.8' $args
}

function Invoke-Pip37Do {
  Invoke-PipDo -Version '3.7' $args
}

function Invoke-Pip36Do {
  Invoke-PipDo -Version '3.6' $args
}

function Invoke-Pip27Do {
  Invoke-PipDo -Version '2.7' $args
}

function Invoke-PipDo($Version, $Arguments) {
  if ($Version -eq '3.8') {
    python38 -V
  } elseif ($Version -eq '3.7') {
    python37 -V
  } elseif ($Version -eq '3.6') {
    python36 -V
  } elseif ($Version -eq '2.7') {
    python27 -V
  } else {
    throw "$Version is not a valid Python version"
  }

  if (!$env:PSPythonScopeRoot -or !(Test-Path (Join-Path $env:PSPythonScopeRoot '.venv\Scripts\Activate.ps1'))) {
    Write-Host -ForegroundColor Yellow "Virtual environment does not exist. Creating new one ..."
    if ($Version -eq '3.8') {
      python38 -m venv .venv
    } elseif ($Version -eq '3.7') {
      python37 -m venv .venv
    } elseif ($Version -eq '3.6') {
      python36 -m venv .venv
    } elseif ($Version -eq '2.7') {
      python27 -m virtualenv .venv
    } else {
      throw "$Version is not a valid Python version"
    }
  } else {
    Write-Host -ForegroundColor Yellow "Using virtual environment from $env:PSPythonScopeRoot ..."
  }

  Enter-PythonScope

  try {
    if (!(which python).Source.StartsWith((Join-Path $env:PSPythonScopeRoot '.venv')) -or
        !(which pip).Source.StartsWith((Join-Path $env:PSPythonScopeRoot '.venv'))) {
      throw "python.exe or pip.exe does not point to current virtual environment."
    }
  } catch {
    throw $_
    return
  }

  Write-Host -ForegroundColor Yellow "Running pip $Arguments ..."
  Invoke-Expression "pip $Arguments"

  Write-Host -ForegroundColor Yellow "Updating requirements.lock.txt ..."
  pip freeze | Out-File -Encoding ascii (Join-Path $env:PSPythonScopeRoot 'requirements.lock.txt')
}
