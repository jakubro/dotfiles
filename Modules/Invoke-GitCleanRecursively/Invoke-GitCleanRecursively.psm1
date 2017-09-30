Set-StrictMode -Version 2.0

<#
.SYNOPSIS
Invokes recursive git clean (git clean -xdf) in specified directory.

.PARAMETER level
How deep to recurse into subdirectories.

Default value is 1.

Note on values:
  Value 0 - this directory.
  Value 1 - this directory and all subdirectories.
  Value 2 - this directory, all subdirectories and all their subdirectories.
  ...

.PARAMETER path
Path to directory where to start recursive git clean.

Default value is current working directory.

.EXAMPLE
Start recursive git clean in current directory and recurse up to second level.

Invoke-GitCleanRecursively -Level 2

.EXAMPLE
Start recursive git clean in provided directory.

Invoke-GitCleanRecursively -Path ~\Projects\
#>

function Invoke-GitCleanRecursively([int] $Level = 1, [string] $Path) {
  if ($Level -lt 0) {
    return
  }
  if ([string]::IsNullOrWhiteSpace($Path)) {
    $Path = (Get-Location).Path
  }

  if (Test-Path (Join-Path $Path ".git")) {
    Write-Host "found '$Path'"
    cd $Path
    if ([string]::IsNullOrWhiteSpace((git status -s))) {
      Write-Host -ForegroundColor yellow "  cleaning"
      git clean -xdf
    }
  } elseif ($Level -gt 0) {
    Write-Host "recursing into '$Path'"
    $items = Get-ChildItem $Path
    foreach ($item in $items) {
      if ($item -is [System.IO.DirectoryInfo]) {
        Invoke-GitCleanRecursively -Level ($Level - 1) -Path $item.FullName
        cd $item.FullName
      }
    }
    cd $Path
  }
}

