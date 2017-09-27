#Requires -Modules Merge-Hashtables
Set-StrictMode -Version 2.0

# import workspace
$workspace = @{ CWD = "~" }
if (Test-Path "~\.env") {
  $temp = Get-Content "~\.env" | ConvertFrom-StringData
  $workspace = Merge-Hashtables $workspace $temp
}

 # current working directory (across multiple sessions)
if (Test-Path $workspace.CWD) {
  cd $workspace.CWD
} else {
  cd "~"
}

# check changes in %PATH%
Invoke-Command -ScriptBlock {
  Import-Module Checkpoint-EnvironmentVariable
  Checkpoint-EnvironmentVariable -Name "PATH" -File "~\.path.txt"
}

# chocolatey
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# aliases
Set-Alias codecompare "${env:ProgramFiles}\Devart\Code Compare\CodeCompare.exe"
Set-Alias codemerge "${env:ProgramFiles}\Devart\Code Compare\CodeMerge.exe"
Set-Alias de4dot "C:\tools\de4dot\de4dot-x64.exe"
Set-Alias devenv "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe"
Set-Alias openssl "C:\tools\OpenSSL-Win32\bin\openssl.exe"
Set-Alias sublime_text "${env:ProgramFiles}\Sublime Text 3\subl.exe"
Set-Alias totalcmd "C:\tools\totalcmd\TOTALCMD64.EXE"
Set-Alias winrar "${env:ProgramFiles}\WinRAR\WinRAR.exe"
