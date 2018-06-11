#Requires -Modules Get-GitStatus

$PSPromptSettings = @{
  Compact = $false;
  FullPath = $false;
}

function Prompt {
  if ($PSPromptSettings.Compact) {
    return "$ "
  }

  $date = Get-PromptDate
  Write-Host -NoNewline $date

  if ($name = Get-PromptName) {
    Write-Host -NoNewline " ($name)"
  }

  $location = Get-PromptLocation
  Write-Host -NoNewline " $location"

  if ($status = Get-PromptGitStatus) {
    Write-Host -NoNewline -ForegroundColor $status.Color " [$($status.String)]"
  }

  return " $ "
}

function Get-PromptDate {
  return Get-Date -Format "HH:mm:ss"
}

function Get-PromptLocation {
  if ($PSPromptSettings.FullPath) {
    return $PWD.ProviderPath
  } else {
    return Split-Path -Leaf $PWD.ProviderPath
  }
}

function Get-PromptName {
  if ([string]::IsNullOrWhiteSpace($env:ParentPSPromptName)) {
    return $null
  } else {
    return $env:ParentPSPromptName.Trim()
  }
}

function Get-PromptGitStatus {
  $status = Get-GitStatus
  if (!$status) {
    return $null
  }

  return @{
    String = Get-PromptGitStatusString $status;
    Color = Get-PromptGitStatusColor $status;
  }
}

function Get-PromptGitStatusString($status) {
  $str = $status.Local

  if (!$status.IsBranch) {
     return ":" + $str
  }

  if (!$status.Remote) {
    return $str + " ?"
  }

  if ($status.Ahead -or $status.Behind) {
    $str += " "
  }
  if ($status.Ahead) {
    $str += $status.Ahead
    $str += [char]::ConvertFromUtf32(0x2192)  # rightwards arrow
  }
  if ($status.Behind) {
    $str += [char]::ConvertFromUtf32(0x2190)  # leftwards arrow
    $str += $status.Behind
  }

  return $str
}

function Get-PromptGitStatusColor($status) {
  if ($status.Modified) {
    return "Red"
  } else {
    return "Gray"
  }
}


Export-ModuleMember -Variable PSPromptSettings
Export-ModuleMember -Function Prompt
