# workspace
$workspace = @{
  location = Join-Path (Get-Item $Profile).Directory.FullName ".env"
  env = @{ root = "~"; aliases = @{} }
}

function Export-WorkspaceEnv {
  $workspace.env | ConvertTo-Json | Out-File -Encoding utf8 $workspace.location
}

# import workspace
if (-not (Test-Path($workspace.location))) {
  Export-WorkspaceEnv
} else {
  $workspace.env = Get-Content $workspace.location | ConvertFrom-Json
}

# set aliases
if($workspace.env.PSobject.Properties.Name -contains "aliases") {
  $aliases = $workspace.env.aliases
  foreach($alias in $aliases) {
    Set-Alias $alias.name $alias.value
  }
}

# cd to current project
cd $workspace.env.root

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
    $TimestampFile = "~\.path.$Timestamp.txt"
    
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