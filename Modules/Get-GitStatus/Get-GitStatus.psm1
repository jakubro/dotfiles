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

function Get-BranchTrackingInfo($trackingInfo) {
  $result = @{
    IsBranch = $true;
    Local = $null;
    Remote = $null;
    Ahead = 0;
    Behind = 0;
  }

  if ($trackingInfo -match "## No commits yet on (.*)") {
    $result.Local = $Matches[1]  # empty git repo
    return $result
  }

  if ($trackingInfo -match "^## ([^.]+)(?:\.{3}([^ ]+)(?: \[([^\]]+)\])?)?$") {

    if ($Matches[1] -eq "HEAD (no branch)") {
      $result.IsBranch = $false
      $result.Local = git rev-parse --short HEAD  # hash
    } else {
      $result.Local = $Matches[1]  # local branch
    }

    if ($Matches.Count -gt 2) {
      $result.Remote = $Matches[2]  # tracked remote branch
    }

    if ($Matches.Count -gt 3) {
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

  return $null  # unrecognized tracking info format
}

Export-ModuleMember -Function Get-GitStatus
