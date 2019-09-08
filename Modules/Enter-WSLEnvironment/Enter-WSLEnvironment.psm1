Set-StrictMode -Version 2.0

function Enter-WSLEnvironment {
  # Automatically switch WSL distro, depending on the current location.

  # deactivate
  if ($env:WSLEnvRoot) {
    Deactivate-WSLEnvironment $PWD.Path
  }

  # activate
  if (!$env:WSLEnvRoot) {
    $path = $PWD.Path
    while ($path) {
      if (Activate-WSLEnvironment $path) {
        break
      }
      $path = Split-Path -Parent $path
    }
  }
}

function Deactivate-WSLEnvironment($Path) {
  if (!$Path.StartsWith($env:WSLEnvRoot) -or
      !(Test-Path (Join-Path $env:WSLEnvRoot '.wslrc'))) {
    Set-WSLRuntime
    $env:WSLEnvRoot = $null
  }
}

function Activate-WSLEnvironment($Path) {
  $nvmrc = Join-Path $Path '.wslrc'
  if (Test-Path $nvmrc) {
    $env:WSLEnvRoot = $Path
    $distro = Get-Content $nvmrc
    if (![string]::IsNullOrWhiteSpace($distro)) {
      Set-WSLRuntime -Distribution $distro -User $env:USERNAME
      return $true
    }
  }
  return $false
}

Export-ModuleMember -Function Enter-WSLEnvironment
