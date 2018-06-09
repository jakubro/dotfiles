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

  $name = Get-PromptName
  if (!($name -eq $null)) {
    Write-Host -NoNewline " ($name)"
  }

  $location = Get-PromptLocation
  Write-Host -NoNewline " $location"

  $status = Get-PromptGitStatus
  if ($status) {
    Write-Host -NoNewline -ForegroundColor Gray " [$status]"
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
  $repo = Get-GitStatus
  if (!$repo) {
    return $null
  }

  $str = $repo.Local + " "

  if ($repo.Remote) {
    if ($repo.Ahead) {
      $str += $repo.Ahead
      $str += [char]::ConvertFromUtf32(0x2192)  # rightwards arrow
    }
    if ($repo.Behind) {
      $str += [char]::ConvertFromUtf32(0x2190)  # leftwards arrow
      $str += $repo.Behind
    }
  } else {
    $str += "?"
  }

  return $str
}


Export-ModuleMember -Variable PSPromptSettings
Export-ModuleMember -Function Prompt
