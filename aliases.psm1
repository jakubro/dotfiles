#Requires -Modules Set-CondaEnvironment, Invoke-PipInstall
Set-StrictMode -Version 2.0

# sys
Set-Alias which Get-Command
Set-Alias grep sls

# editors
Set-Alias devenv "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe"
Set-Alias sublime_text "C:\Program Files\Sublime Text 3\subl.exe"
Set-Alias vim "C:\Program Files (x86)\Vim\vim80\vim.exe"

# python
Set-Alias conda "C:\ProgramData\Miniconda3\Scripts\conda.exe"
Set-Alias conda-activate Set-CondaEnvironment
Set-Alias pip-add Invoke-PipInstall

# dev
Set-Alias codecompare "C:\Program Files\Devart\Code Compare\CodeCompare.exe"
Set-Alias codemerge "C:\Program Files\Devart\Code Compare\CodeMerge.exe"
Set-Alias msbuild "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe"

# hashicorp
Set-Alias terraform "C:\tools\terraform\terraform.exe"

# ssh
Set-Alias ssh "C:\Program Files\Git\usr\bin\ssh.exe"
Set-Alias ssh-keygen "C:\Program Files\Git\usr\bin\ssh-keygen.exe"

# win utils
Set-Alias totalcmd "C:\tools\totalcmd\TOTALCMD64.EXE"
Set-Alias winrar "C:\Program Files\WinRAR\WinRAR.exe"
Set-Alias appcmd "C:\Windows\System32\inetsrv\appcmd.exe"

# misc
Set-Alias adb "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
Set-Alias de4dot "C:\tools\de4dot\de4dot-x64.exe"
Set-Alias openssl "C:\tools\OpenSSL-Win32\bin\openssl.exe"
Set-Alias wireshark "C:\Program Files\Wireshark\Wireshark.exe"
