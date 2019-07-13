Set-StrictMode -Version 2.0

# compares two values and prints a diff if they differ
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
    $a = $NewValue -split ";"
    $b = $OldValue -split ";"
    Compare-Object $a $b | Format-Color @{"=>" = "Red"; "<=" = "Green"}
    return 1
  }
}

# returns path to file where to store dump file that is no longer relevant
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

<#
.SYNOPSIS
Compares current value of environment variable with the saved one and prints a diff if they differ.

.PARAMETER name
Name of environment variable.

.PARAMETER file
Path to file that contains the last dump of environment variable.

.EXAMPLE
Creates a checkpoint for environment variable $env:PATH and loads/saves the last dump from/to file "~\.path.txt"

Checkpoint-EnvironmentVariable -Name "PATH" -File "~\.path.txt"
#>

function Checkpoint-EnvironmentVariable(
  [parameter(Mandatory=$true)] [string] $Name,
  [parameter(Mandatory=$true)] [string] $File
) {

  $Name = $Name.ToUpper()

  # Loads new value (the one currently being used)
  # and old value (the last known value stored in the "dump file").

  $newValue = (Get-Item env:$Name).Value
  $oldValue = $null
  if (Test-Path $File) {
    $oldValue = Get-Content $File
  }

  # Compare loaded values.

  $result = Compare-EnvironmentVariable -Name $Name -OldValue $oldValue -NewValue $newValue
  if ($result -eq 0) {
    return
  }

  # Values differ. Backup "dump file", since it's content is no longer up-to-date
  # and create new dump.

  if ($result -gt 0) {
    $backup = Get-EnvironmentVariableBackupFile -Name $Name
    Write-Host "Previous %$Name% dump was moved to $backup"
    mv $File $backup
  }

  Write-Host "Current %$Name% was saved to $File"
  echo $newValue > $File
}

Export-ModuleMember -Function Checkpoint-EnvironmentVariable
