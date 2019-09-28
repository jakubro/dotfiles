Set-StrictMode -Version 2.0

function Get-Prompt($Settings) {
  if ($Settings.Compact) {
    return "$ "
  }

  # Date

  $date = Get-PromptDate
  Write-Host -NoNewline $date

  # Named prompt

  if (![string]::IsNullOrWhiteSpace($env:PSPromptName)) {
    $name = $env:PSPromptName.Trim()
    Write-Host -NoNewline -ForegroundColor Green " ($name)"
  }

  # Python, Node.js environments

  $envs = ""

  if (![string]::IsNullOrWhiteSpace($envs)) {
    $envs += " | "
  }
  $envs += "py"
  if (![string]::IsNullOrWhiteSpace($env:PSPythonScopeRoot)) {
    $envs += "@" + (Split-Path -Leaf $env:PSPythonScopeRoot)
  } else {
    $envs += "#" + (Get-DefaultPython) -replace 'python', ''
  }

  if (![string]::IsNullOrWhiteSpace($envs)) {
    $envs += " | "
  }
  $envs += "node"
  if (![string]::IsNullOrWhiteSpace($env:PSNodeScopeRoot)) {
    $envs += "@" + (Split-Path -Leaf $env:PSNodeScopeRoot)
  }
  $envs += "#" + (Get-DefaultNode) -replace 'node', ''

  Write-Host -NoNewline -ForegroundColor Magenta " [$envs]"

  # WSL

  if (![string]::IsNullOrWhiteSpace($env:PSWSLDistribution)) {
    $wsl = $env:PSWSLDistribution
    Write-Host -NoNewline -ForegroundColor Yellow " $wsl"
  }

  # AWS

  if ($aws = Get-AwsCliCurrentProfile) {
    Write-Host -NoNewline -ForegroundColor Yellow " ($aws)"
  }

  # Location

  $location = Get-PromptLocation
  Write-Host -NoNewline " $location"

  # Git

  if ($status = Get-PromptGitStatus) {
    Write-Host -NoNewline -ForegroundColor $status.Color " [$( $status.String )]"
  }

  return " $ "
}

function Get-PromptDate {
  return Get-Date -Format "HH:mm:ss"
}

function Get-PromptLocation {
  if ($Settings.FullPath) {
    return $PWD.ProviderPath
  } else {
    return Split-Path -Leaf $PWD.ProviderPath
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

function Get-AwsCliCurrentProfile {
  $profile = $env:AWS_DEFAULT_PROFILE
  if ($profile) {
    return $profile
  } else {
    return $null
  }
}

Export-ModuleMember -Function Get-Prompt
