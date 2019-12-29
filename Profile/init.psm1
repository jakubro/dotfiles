# Bootstrap
# -----------------------------------------------------------------------------------------------------------------

# Backup any changes made to %PATH%.
if (!$env:ParentPS) {
  Checkpoint-EnvironmentVariable -Name "PATH" -File "~\.path.txt"
}

# Load settings shared across multiple PS sessions.
Import-DotEnv -Path "~\.env" -Default @{ INITIAL_CWD = "~" }

# Current working directory.
if (!$env:ParentPS) {
  cd $env:INITIAL_CWD
}

# Expose this directory.
$ProfileDirectory = Split-Path $PROFILE

# Load customized prompt, set aliases and other environment variables.
Import-Module "$ProfileDirectory\Profile\env.psm1"
Import-Module "$ProfileDirectory\Profile\aliases.psm1"
Import-Module "$ProfileDirectory\Profile\prompt.psm1"

Set-NodeRuntime 12

# Print startup info.
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
