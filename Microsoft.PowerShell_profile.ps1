#Requires -Modules Merge-Hashtables, Checkpoint-EnvironmentVariable
Set-StrictMode -Version 2.0

# load workspace (i.e. settings shared across multiple PS sessions)
& {
  $defaultWorkspace = @{ CWD = "~" }
  $workspace = $defaultWorkspace
  if (Test-Path "~\.env") {
    $importedWorkspace = Get-Content "~\.env" | ConvertFrom-StringData
    $workspace = Merge-Hashtables $defaultWorkspace $importedWorkspace
  }

  # current working directory
  if (Test-Path $workspace.CWD) {
    cd $workspace.CWD
  } else {
    cd $defaultWorkspace.CWD
  }
}

# check changes in %PATH%
if (!$env:SupressEnvironmentVariableCheckpoint) {
  Checkpoint-EnvironmentVariable -Name "PATH" -File "~\.path.txt"
}

# chocolatey
& {
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
  }
}

# PowerShell prompt
function Prompt {
  $date = Get-Date -Format "HH:mm:ss"
  $location = $PWD.ProviderPath
  $promptName = ""
  if (![string]::IsNullOrWhiteSpace($env:ParentPSPromptName)) {
    $name = $env:ParentPSPromptName.Trim()
    $promptName = "($name) "
  }
  Write-Host -NoNewline -ForegroundColor White "$date "
  Write-Host -NoNewline -ForegroundColor White $promptName
  Write-Host -NoNewline -ForegroundColor White $location
  return "> "
}

# conda
function Set-CondaEnvironment {
  cmd /C (
    "C:\ProgramData\Anaconda3\Scripts\activate $args && " +
    "set SupressEnvironmentVariableCheckpoint=true && " +
    "set ParentPSPromptName=$args && " +
    "powershell -NoExit -NoLogo"
  )
}

Set-Alias conda "C:\ProgramData\Anaconda3\Scripts\conda.exe"
Set-Alias conda-activate Set-CondaEnvironment

# editors
Set-Alias devenv "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe"
Set-Alias sublime_text "C:\Program Files\Sublime Text 3\subl.exe"
Set-Alias vim "C:\Program Files (x86)\Vim\vim80"

# dev
Set-Alias codecompare "C:\Program Files\Devart\Code Compare\CodeCompare.exe"
Set-Alias codemerge "C:\Program Files\Devart\Code Compare\CodeMerge.exe"

# hashicorp
Set-Alias terraform "C:\tools\terraform\terraform.exe"

# win utils
Set-Alias totalcmd "C:\tools\totalcmd\TOTALCMD64.EXE"
Set-Alias winrar "C:\Program Files\WinRAR\WinRAR.exe"

# misc
Set-Alias de4dot "C:\tools\de4dot\de4dot-x64.exe"
Set-Alias openssl "C:\tools\OpenSSL-Win32\bin\openssl.exe"
Set-Alias wireshark "C:\Program Files\Wireshark\Wireshark.exe"
