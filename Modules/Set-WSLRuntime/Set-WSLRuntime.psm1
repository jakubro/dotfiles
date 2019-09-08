Set-StrictMode -Version 2.0

$original = (Get-Command wsl).Source

function Invoke-WSL() {
  $cmd = "$original"
  if (![string]::IsNullOrWhiteSpace($env:Distribution)) {
    $cmd += " -d $env:Distribution"
    if (![string]::IsNullOrWhiteSpace($env:User)) {
      $cmd += " -u $env:User"
    }
  }
  Invoke-Expression "$cmd $args"
}

function Set-WSLRuntime([string] $Distribution, [string] $User) {
  if ([string]::IsNullOrWhiteSpace($Distribution) -and
      [string]::IsNullOrWhiteSpace($User)) {
    $env:WSLDistribution = $null
    $env:WSLUser = $null

    if (Test-Path Alias:\wsl) {
      Remove-Item Alias:\wsl
    }
  }
  else {
    $env:WSLDistribution = $Distribution
    $env:WSLUser = $User

    Set-Alias wsl Invoke-WSL -Scope Global
    Export-ModuleMember -Alias wsl
  }
}

Export-ModuleMember -Function Invoke-WSL
Export-ModuleMember -Function Set-WSLRuntime
