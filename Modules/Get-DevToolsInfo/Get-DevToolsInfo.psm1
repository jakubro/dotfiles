Set-StrictMode -Version 2.0

function Get-DevToolsInfo([switch] $Version) {
  $commands = (
    ('python', { python -V }),
    ('pip', { pip -V }),
    ('python2', { python2 -V }),
    ('pip2', { pip2 -V }),
    ('python3', { python3 -V }),
    ('pip3', { pip3 -V }),
    ('node', { node -v }),
    ('npm', { npm -v })
  )

  foreach ($k in $commands) {
    $command = $k[0]
    $versionGetter = $k[1]
    Write-Host -ForegroundColor Magenta -NoNewline $command
    try {
      $cmd = Get-Command $command -ErrorAction Stop
      if ($cmd.CommandType -eq "Alias") {
        $cmd = (Get-Alias $command).Definition
      } else {
        $cmd = $cmd.Source
      }
      Write-Host -ForegroundColor White -NoNewline "`t$( $cmd )"
      if ($Version) {
        Write-Host -ForegroundColor White -NoNewline "`t$( Invoke-Command $versionGetter )"
      }
    } catch {
      Write-Host -ForegroundColor White -NoNewline "`tn/a"
    } finally {
      Write-Host
    }
  }
}
