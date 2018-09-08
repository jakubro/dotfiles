#Requires -Modules Import-DotEnv, Checkpoint-EnvironmentVariable
Set-StrictMode -Version 2.0

# Bootstrap
###############################################################################

# load workspace (i.e. settings shared across multiple PS sessions)
Import-DotEnv -Path "~\.env" -Default @{ INITIAL_CWD = "~" }

# current working directory
if (!$env:ParentPS) {
  cd $env:INITIAL_CWD
}

# backup any changes made to %PATH%
if (!$env:ParentPS) {
  Checkpoint-EnvironmentVariable -Name "PATH" -File "~\.path.txt"
}

# expose this directory
$ProfileDirectory = Split-Path $PROFILE

# load customized prompt and set aliases
Import-Module "$ProfileDirectory\prompt.psm1"
Import-Module "$ProfileDirectory\aliases.psm1"

# python
$env:Path= "$env:APPDATA\Python\Python36\site-packages\;$env:Path"

# Third-party Modules
###############################################################################

# chocolatey
& {
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
  }
}
