Set-StrictMode -Version 2.0

function Get-GitStatus {
  $status = git status --porcelain --branch 2> $null
  if ($LASTEXITCODE) {
    return $null  # not inside a git work tree
  }

  $status = $status -split [Environment]::NewLine

  if ($result = Get-BranchTrackingInfo $status[0]) {
    $result.Modified = $status.Length -gt 1
    return $result
  }

  return $null
}

function Get-BranchTrackingInfo($line) {
  $result = @{
    Local = $null;
    Remote = $null;
    Ahead = 0;
    Behind = 0;
  }

  if ($line -match "## No commits yet on (.*)") {
    $result.Local = $Matches[1]
    return $result
  }

  if ($line -match "## ([^.]+)(?:\.{3}([^.]+)(?: \[([^\]]+)\]))?") {
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

Export-ModuleMember -Function Get-GitStatus
