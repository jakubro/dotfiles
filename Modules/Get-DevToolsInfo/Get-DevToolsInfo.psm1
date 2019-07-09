#Requires -Modules Get-OriginalCommand

Set-StrictMode -Version 2.0

function Get-DevToolsInfo([switch] $Version, $Commands = $null) {
  $defaultCommands = (
    ('python', { python -V }),
    ('pip', { pip -V }),
    ('python3', { python3 -V }),
    ('pip3', { pip3 -V }),
    ('python2', { python2 -V }),
    ('pip2', { pip2 -V }),
    ('node', { node -v }),
    ('npm', { npm -v }),
    ('node12', { node12 -v }),
    ('npm12', { npm12 -v }),
    ('node8', { node8 -v }),
    ('npm8', { npm8 -v })
  )

  if (!$Commands) {
    $Commands = $defaultCommands
  }

  foreach ($k in $Commands) {

    if ($k -is [string]) {
      $command = $k
      $versionGetter = $null
    } else {
      $command = $k[0]
      $versionGetter = $k[1]
    }

    Write-Host -ForegroundColor Magenta -NoNewline $command

    try {
      $cmd = Get-OriginalCommand $command
      Write-Host -ForegroundColor White -NoNewline "`t$( $cmd )"
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
