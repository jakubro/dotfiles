#Requires -Modules Checkpoint-EnvironmentVariable, Import-DotEnv, Set-CondaEnvironment
Set-StrictMode -Version 2.0

# Bootstrap
###############################################################################

# backup any changes made to %PATH%
if (!$env:ParentPS) {
  Checkpoint-EnvironmentVariable -Name "PATH" -File "~\.path.txt"
}

# load workspace (i.e. settings shared across multiple PS sessions)
Import-DotEnv -Path "~\.env" -Default @{ INITIAL_CWD = "~" }

# current working directory
if (!$env:ParentPS) {
  cd $env:INITIAL_CWD
}

# expose this directory
$ProfileDirectory = Split-Path $PROFILE

# load customized prompt and set aliases
Import-Module "$ProfileDirectory\prompt.psm1"
Import-Module "$ProfileDirectory\aliases.psm1"

# python
$env:Path = "$env:APPDATA\Python\Python37\Scripts\;$env:APPDATA\Python\Python37\site-packages\;$env:Path"

# activate conda environment
#
# todo: disabled, b/c Set-CondaEnvironment spawns new subshell, which does not work here
#
#  Obvious solution is to rework Set-CondaEnvironment to not create subshell, but that would
#  (probably?) mean to completely rework '\Anaconda3\Scripts\activate.bat' into PS.
#  Hint - virtualenv (or venv?) has something similar in 'activate.ps1'.
#
# if (![string]::IsNullOrWhiteSpace($env:INITIAL_CONDA_ENV)) {
#   Set-CondaEnvironment $env:INITIAL_CONDA_ENV
# }

# android
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$env:ANDROID_SDK = "$env:LOCALAPPDATA\Android\Sdk"

# Third-party Modules
###############################################################################

# chocolatey
& {
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
  }
}
