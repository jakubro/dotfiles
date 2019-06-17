#Requires -Modules Checkpoint-EnvironmentVariable, Get-DevToolsInfo, Import-DotEnv, Set-CondaEnvironment
Set-StrictMode -Version 2.0

# Bootstrap
# -----------------------------------------------------------------------------------------------------------------

# Backup any changes made to %PATH%.
if (!$env:ParentPS) {
  Checkpoint-EnvironmentVariable -Name "PATH" -File "~\.path.txt"
}

# Load workspace, i.e. settings shared across multiple PS sessions.
Import-DotEnv -Path "~\.env" -Default @{ INITIAL_CWD = "~" }

# Current working directory.
if (!$env:ParentPS) {
  cd $env:INITIAL_CWD
}

# Expose this directory.
$ProfileDirectory = Split-Path $PROFILE

# Load customized prompt, set aliases and other environment variables.
Import-Module "$ProfileDirectory\prompt.psm1"
Import-Module "$ProfileDirectory\aliases.psm1"
Import-Module "$ProfileDirectory\env.psm1"

Write-Host
Get-DevToolsInfo
Write-Host

# Third-party Modules
# -----------------------------------------------------------------------------------------------------------------

# Chocolatey.
& {
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
  }
}
