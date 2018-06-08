#Requires -Modules Import-DotEnv, Merge-Hashtables, Checkpoint-EnvironmentVariable, Set-CondaEnvironment
Set-StrictMode -Version 2.0

# Boostrap
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

# PowerShell prompt

$PSPromptSettings = @{
  Compact = $false;
  FullPath = $false;
}

function Prompt {
  if ($PSPromptSettings.Compact) {
    return "$ "
  }

  function _getDate {
    return Get-Date -Format "HH:mm:ss"
  }


  function _getLocation {
    if ($PSPromptSettings.FullPath) {
      return $PWD.ProviderPath
    } else {
      return Split-Path -Leaf $PWD.ProviderPath
    }
  }

  function _getPromptName {
    $promptName = $null
    if (![string]::IsNullOrWhiteSpace($env:ParentPSPromptName)) {
      $promptName = $env:ParentPSPromptName.Trim()
    }
  }

  function _getGitStatus {
    $status = git status --porcelain --branch 2> $null
    if ($LASTEXITCODE) {
      return $null  # not inside a git work tree
    }

    # todo: include worktree stats (files staged/added/removed/conflicted)

    $result = @{
      Local = $null;
      Remote = $null;
      Ahead = 0;
      Behind = 0;
    }

    $status = $status -split [Environment]::NewLine

    if ($status[0] -match "## No commits yet on (.*)") {
      $result.Local = $Matches[1]
      return $result
    }

    if ($status[0] -match "## ([^.]+)(?:\.{3}([^.]+)(?: \[([^\]]+)\]))?") {
      $result.Local = $Matches[1]

      if ($result.Local -eq "HEAD (no branch)") {
        $hash = git rev-parse --short HEAD
        $result.Local = ":$hash"
      }
      if ($Matches.Count -gt 2) {
        $result.Remote = $Matches[2]

        $Matches[3] -split ", " | % {
          $direction, $count = $_ -split " "
          switch ($direction) {
            "ahead" { $result.Ahead = $count }
            "behind" { $result.Behind = $count }
          }
        }
      }

      return $result
    }

    return $null
  }

  $date = _getDate
  Write-Host -NoNewline $date

  $name = _getPromptName
  if (!($name -eq $null)) {
    Write-Host -NoNewline " ($name)"
  }

  $location = _getLocation
  Write-Host -NoNewline " $location"

  $repo = _getGitStatus
  if ($repo) {
    $gstr = "["
    $gstr += $repo.Local
    if (-not $repo.Remote) {
      $gstr += " ?"
    } else {
      $gstr += " "
      if ($repo.Ahead) {
        $gstr += $repo.Ahead
        $gstr += [char]::ConvertFromUtf32(0x2192)  # rightwards arrow
      }
      if ($repo.Behind) {
        $gstr += [char]::ConvertFromUtf32(0x2190)  # leftwards arrow
        $gstr += $repo.Behind
      }
    }
    $gstr += "]"

    Write-Host -NoNewline -ForegroundColor Gray " $gstr"
  }

  return " $ "
}

# Third-party Modules
###############################################################################

# chocolatey
& {
  $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
  }
}

# Aliases
###############################################################################

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
