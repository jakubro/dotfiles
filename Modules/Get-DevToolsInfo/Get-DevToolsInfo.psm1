Set-StrictMode -Version 2.0

function Get-DevToolsInfo([switch] $All, [switch] $Version, $Commands = $null) {
  if (!$Commands) {
    $Commands = (
      ('python', { python -V }, $true),
      ('pip', { pip -V }, $true),
      ('python3', { python3 -V }, $false),
      ('pip3', { pip3 -V }, $false),
      ('python2', { python2 -V }, $false),
      ('pip2', { pip2 -V }, $false),
      ('node', { node -v }, $true),
      ('npm', { npm -v }, $true),
      ('node12', { node12 -v }, $false),
      ('npm12', { npm12 -v }, $false),
      ('node8', { node8 -v }, $false),
      ('npm8', { npm8 -v }, $false)
    )
  }

  foreach ($it in $Commands) {

    if ($it -is [string]) {
      $command = $it
      $versionGetter = $null
      $onlyInAll = $true
    } else {
      $command = $it[0]
      $versionGetter = $it[1]
      $onlyInAll = $it[2]
    }

    if (!$onlyInAll -and !$All) {
      continue
    }

    Write-Host -ForegroundColor Magenta -NoNewline $command

    try {
      $path = Get-OriginalCommand $command
      Write-Host -ForegroundColor White -NoNewline "`t$( $path )"
      if ($Version -and $versionGetter) {
        Write-Host -ForegroundColor White -NoNewline "`t$( Invoke-Command $versionGetter )"
      }
    } catch {
      Write-Host -ForegroundColor White -NoNewline "`tn/a"
    } finally {
      Write-Host
    }

  }
}
