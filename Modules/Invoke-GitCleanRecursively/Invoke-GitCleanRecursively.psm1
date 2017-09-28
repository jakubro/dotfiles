Set-StrictMode -Version 2.0

function Invoke-GitCleanRecursively($Level, $Path) {
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

