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
Checkpoint-EnvironmentVariable -Name "PATH" -File "~\.path.txt"

# chocolatey
& {
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
  }
}

# aliases
Set-Alias codecompare "${env:ProgramFiles}\Devart\Code Compare\CodeCompare.exe"
Set-Alias codemerge "${env:ProgramFiles}\Devart\Code Compare\CodeMerge.exe"
Set-Alias de4dot "C:\tools\de4dot\de4dot-x64.exe"
Set-Alias devenv "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe"
Set-Alias openssl "C:\tools\OpenSSL-Win32\bin\openssl.exe"
Set-Alias sublime_text "${env:ProgramFiles}\Sublime Text 3\subl.exe"
Set-Alias terraform "C:\tools\terraform_0.10.8_windows_amd64\terraform.exe"
Set-Alias totalcmd "C:\tools\totalcmd\TOTALCMD64.EXE"
Set-Alias vim "${env:ProgramFiles(x86)}\Vim\vim80"
Set-Alias winrar "${env:ProgramFiles}\WinRAR\WinRAR.exe"
Set-Alias wireshark "${env:ProgramFiles}\Wireshark\Wireshark.exe"
