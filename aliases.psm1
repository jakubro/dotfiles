#Requires -Modules Set-CondaEnvironment

# sys
Set-Alias which Get-Command

# editors
Set-Alias devenv "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe"
Set-Alias sublime_text "C:\Program Files\Sublime Text 3\subl.exe"
Set-Alias vim "C:\Program Files (x86)\Vim\vim80\vim.exe"

# conda
Set-Alias conda "C:\ProgramData\Anaconda3\Scripts\conda.exe"
Set-Alias conda-activate Set-CondaEnvironment

# dev
Set-Alias codecompare "C:\Program Files\Devart\Code Compare\CodeCompare.exe"
Set-Alias codemerge "C:\Program Files\Devart\Code Compare\CodeMerge.exe"
Set-Alias msbuild "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe"

# hashicorp
Set-Alias terraform "C:\tools\terraform\terraform.exe"

# aws
Set-Alias eb "$env:APPDATA\Python\Python36\Scripts\eb.exe"

# ssh
Set-Alias ssh "C:\Program Files\Git\usr\bin\ssh.exe"
Set-Alias ssh-keygen "C:\Program Files\Git\usr\bin\ssh-keygen.exe"

# win utils
Set-Alias totalcmd "C:\tools\totalcmd\TOTALCMD64.EXE"
Set-Alias winrar "C:\Program Files\WinRAR\WinRAR.exe"

# misc
Set-Alias de4dot "C:\tools\de4dot\de4dot-x64.exe"
Set-Alias openssl "C:\tools\OpenSSL-Win32\bin\openssl.exe"
Set-Alias wireshark "C:\Program Files\Wireshark\Wireshark.exe"
