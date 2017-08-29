# import workspace
$workspace = @{ CWD = "~" }
if (Test-Path("~\.env")) {
  $workspace = Get-Content "~\.env" | ConvertFrom-StringData
}

 # current working directory (across multiple sessions)
if($workspace.CWD -and (Test-Path $workspace.CWD)) {
  cd $workspace.CWD
} else {
  cd "~"
}

# set aliases
Set-Alias codecompare "${env:ProgramFiles}\Devart\Code Compare\CodeCompare.exe"
Set-Alias codemerge "${env:ProgramFiles}\Devart\Code Compare\CodeMerge.exe"
Set-Alias de4dot "C:\tools\de4dot\de4dot-x64.exe"
Set-Alias devenv "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe"
Set-Alias openssl "C:\tools\OpenSSL-Win32\bin\openssl.exe"
Set-Alias sublime_text "${env:ProgramFiles}\Sublime Text 3\subl.exe"
Set-Alias totalcmd "C:\tools\totalcmd\TOTALCMD64.EXE"
Set-Alias winrar "${env:ProgramFiles}\WinRAR\WinRAR.exe"

# check changes in %PATH%
Invoke-Command -ScriptBlock {

  $PathFile = "~\.path.txt"

  function Format-Color([hashtable] $Colors = @{}, [switch] $SimpleMatch) {
    $lines = ($input | Out-String) -replace "`r", "" -split "`n"
    foreach($line in $lines) {
      $color = ''
      foreach($pattern in $Colors.Keys){
        if(!$SimpleMatch -and $line -match $pattern) { $color = $Colors[$pattern] }
        elseif ($SimpleMatch -and $line -like $pattern) { $color = $Colors[$pattern] }
      }
      if($color) {
        Write-Host -ForegroundColor $color $line
      } else {
        Write-Host $line
      }
    }
  }
  
  function Create-PathDump {
    $Timestamp = [DateTime]::UtcNow.ToString('o').Replace(':','.')
    $TimestampFile = Join-Path (Get-Item $Profile).Directory.FullName "backup\.path.$Timestamp.txt"
    
    $ResultMessage = "Current %PATH% was saved to $PathFile"

    $showDiff = $false;
    if(Test-Path $PathFile) {
      mv $PathFile $TimestampFile
      $ResultMessage += ", previous dump was moved to $TimestampFile"
      $showDiff = $true;
    }

    echo $Env:Path > $PathFile
    Write-Host $ResultMessage
    if($showDiff) {
      $Current = ((gc $PathFile) -split ';');
      $Previous = ((gc $TimestampFile) -split ';');
      (compare-object $Current $Previous) | Format-Color @{'=>' = 'Red'; '<=' = 'Green'}
    }
  }

  if(Test-Path $PathFile) {
    if($Env:Path -eq (gc $PathFile)) {
      Write-Host -ForegroundColor Green "Changes in %PATH%: None"
    } else {
      Write-Warning "Changes in %PATH%: Detected"
      Create-PathDump
    }
  } else {
    Write-Warning "Changes in %PATH%: Path file $PathFile does not exist"
    Create-PathDump
  }
}

# chocolatey
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}