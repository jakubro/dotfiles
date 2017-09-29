#Requires -Modules Format-Color
Set-StrictMode -Version 2.0

function Compare-EnvironmentVariable([string] $Name, [string] $OldValue, [string] $NewValue) {
  $Name = $Name.ToUpper()
  if ([string]::IsNullOrEmpty($OldValue)) {
    Write-Warning "Changes in %$Name%: Dump does not exist"
    return -1
  }
  elseif ($OldValue -eq $NewValue) {
    Write-Host -ForegroundColor Green "Changes in %$Name%: None"
    return 0
  }
  else {
    Write-Warning "Changes in %$Name%: Detected"
    $a = $OldValue -split ";"
    $b = $NewValue -split ";"
    Compare-Object $a $b | Format-Color @{"=>" = "Red"; "<=" = "Green"}
    return 1
  }
}

function Get-EnvironmentVariableBackupFile([string] $Name) {
  $Name = $Name.ToLower()
  $timestamp = [DateTime]::UtcNow.ToString("yyyyMMddHHmmssZ")
  $parent = Join-Path (Get-Item $Profile).Directory.FullName ".backup"
  $file = Join-Path $parent ".$Name.$timestamp.txt"
  if (-not (Test-Path $parent)) {
    mkdir $parent
  }
  return $file
}

function Checkpoint-EnvironmentVariable(
  [parameter(Mandatory=$true)] [string] $Name,
  [parameter(Mandatory=$true)] [string] $File
) {
  $Name = $Name.ToUpper()
  $newValue = (Get-Item env:$Name).Value
  $oldValue = $null
  if (Test-Path $File) {
    $oldValue = Get-Content $File
  }

  $result = Compare-EnvironmentVariable -Name $Name -OldValue $oldValue -NewValue $newValue
  if ($result -eq 0) {
    return
  }

  if ($result -gt 0) {
    $backup = Get-EnvironmentVariableBackupFile -Name $Name
    Write-Host "Previous %$Name% dump was moved to $backup"
    mv $File $backup
  }

  Write-Host "Current %$Name% was saved to $File"
  echo $newValue > $File
}

Export-ModuleMember -Function Checkpoint-EnvironmentVariable
