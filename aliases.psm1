Set-StrictMode -Version 2.0

# sys
Set-Alias which Get-Command
Set-Alias grep sls

# editors
Set-Alias devenv "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe"
Set-Alias sublime_text "$env:ProgramFiles\Sublime Text 3\subl.exe"
Set-Alias vim "${env:ProgramFiles(x86)}\Vim\vim80\vim.exe"

# python
Set-Alias python3 "C:\tools\python37\python.exe"
Set-Alias pip3 "C:\tools\python37\Scripts\pip.exe"
Set-Alias python2 "C:\tools\python27\python.exe"
Set-Alias pip2 "C:\tools\python27\Scripts\pip.exe"
if (!(Test-Command python)) {
  Set-Alias python python3
  Set-Alias pip pip3
}
Set-Alias pip3-do Invoke-Pip3Do
Set-Alias pip2-do Invoke-Pip2Do
Set-Alias pip-do Invoke-Pip3Do
Set-Alias conda "C:\ProgramData\Miniconda3\Scripts\conda.exe"
Set-Alias conda-activate Set-CondaEnvironment

# node
Set-Alias node-activate Set-NodeRuntime
Set-Alias node12 "$env:NODEJS12_HOME\node.exe"
Set-Alias npm12 "$env:NODEJS12_HOME\npm.cmd"
Set-Alias node8 "$env:NODEJS8_HOME\node.exe"
Set-Alias npm8 "$env:NODEJS8_HOME\npm.cmd"

# dev
Set-Alias codecompare "$env:ProgramFiles\Devart\Code Compare\CodeCompare.exe"
Set-Alias codemerge "$env:ProgramFiles\Devart\Code Compare\CodeMerge.exe"
Set-Alias ngrok "C:\tools\ngrok.exe"

# hashicorp
Set-Alias terraform "C:\tools\terraform\terraform.exe"

# ssh
Set-Alias ssh "$env:ProgramFiles\Git\usr\bin\ssh.exe"
Set-Alias ssh-keygen "$env:ProgramFiles\Git\usr\bin\ssh-keygen.exe"

# win utils
Set-Alias totalcmd "C:\tools\totalcmd\TOTALCMD64.EXE"
Set-Alias winrar "$env:ProgramFiles\WinRAR\WinRAR.exe"
Set-Alias appcmd "C:\Windows\System32\inetsrv\appcmd.exe"

# misc
Set-Alias adb "$env:LocalAppData\Android\Sdk\platform-tools\adb.exe"
Set-Alias de4dot "C:\tools\de4dot\de4dot-x64.exe"
Set-Alias openssl "C:\tools\OpenSSL-Win32\bin\openssl.exe"
Set-Alias wireshark "$env:ProgramFiles\Wireshark\Wireshark.exe"
