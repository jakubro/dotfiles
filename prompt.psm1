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
    Write-Host -NoNewline -ForegroundColor $status.Color " [$($status.String))]"
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

  $result = @{
    String = "";
    Color = $null;
  }

  $result.String = $status.Local + " "

  if ($status.Remote) {
    if ($status.Ahead) {
      $result.String += $status.Ahead
      $result.String += [char]::ConvertFromUtf32(0x2192)  # rightwards arrow
    }
    if ($status.Behind) {
      $result.String += [char]::ConvertFromUtf32(0x2190)  # leftwards arrow
      $result.String += $status.Behind
    }
  } else {
    $result.String += "?"
  }

  if ($status.Modified) {
    $result.Color = "Red"
  } else {
    $result.Color = "Gray"
  }

  return $result
}


Export-ModuleMember -Variable PSPromptSettings
Export-ModuleMember -Function Prompt
