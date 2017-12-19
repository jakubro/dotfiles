#Requires -Modules Merge-Hashtables, Checkpoint-EnvironmentVariable
Set-StrictMode -Version 2.0

& {
  # import workspace
  $defaultWorkspace = @{ CWD = "~" }
  $workspace = $defaultWorkspace
  if (Test-Path "~\.env") {
    $importedWorkspace = Get-Content "~\.env" | ConvertFrom-StringData
    $workspace = Merge-Hashtables $defaultWorkspace $importedWorkspace
  }

  # current working directory (across multiple sessions)
  if (Test-Path $workspace.CWD) {
    cd $workspace.CWD
  } else {
    cd $defaultWorkspace.CWD
  }
}

# check changes in %PATH%
if (-not $env:SupressEnvCheckpoint) {
  Checkpoint-EnvironmentVariable -Name "PATH" -File "~\.path.txt"
}

# chocolatey
& {
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
  }
}

# prompt
function Prompt {
  $prefix = ""
  if (-not [string]::IsNullOrWhiteSpace($env:ParentPromptName)) {
    $name = $env:ParentPromptName.Trim()
    $prefix = "($name) "
  }
  "PS " + $prefix + (Get-Date -Format "HH:mm") + " " + (Get-Location) + ">"
}

# conda
function Set-CondaEnvironment {
  cmd /C (
    "C:\ProgramData\Anaconda3\Scripts\activate $args && " +
    "set SupressEnvCheckpoint=true && " +
    "set ParentPromptName=$args && " +
    "powershell -NoExit -NoLogo"
  )
}

Set-Alias conda "C:\ProgramData\Anaconda3\Scripts\conda.exe"
Set-Alias conda-activate Set-CondaEnvironment

# aliases
Set-Alias codecompare "C:\Program Files\Devart\Code Compare\CodeCompare.exe"
Set-Alias codemerge "C:\Program Files\Devart\Code Compare\CodeMerge.exe"
Set-Alias de4dot "C:\tools\de4dot\de4dot-x64.exe"
Set-Alias devenv "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe"
Set-Alias openssl "C:\tools\OpenSSL-Win32\bin\openssl.exe"
Set-Alias sublime_text "C:\Program Files\Sublime Text 3\subl.exe"
Set-Alias terraform "C:\tools\terraform_0.10.8_windows_amd64\terraform.exe"
Set-Alias totalcmd "C:\tools\totalcmd\TOTALCMD64.EXE"
Set-Alias vim "C:\Program Files (x86)\Vim\vim80"
Set-Alias winrar "C:\Program Files\WinRAR\WinRAR.exe"
Set-Alias wireshark "C:\Program Files\Wireshark\Wireshark.exe"
