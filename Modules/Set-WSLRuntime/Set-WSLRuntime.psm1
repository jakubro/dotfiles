Set-StrictMode -Version 2.0

$original = (Get-Command wsl).Source

function Invoke-WSL() {
  $cmd = "$original"
  if (![string]::IsNullOrWhiteSpace($env:PSWSLDistribution)) {
    $cmd += " -d $env:PSWSLDistribution"
  }
  Invoke-Expression "$cmd $args"
}

function Set-WSLRuntime([string] $Distribution) {
  if ( [string]::IsNullOrWhiteSpace($Distribution)) {
    $env:PSWSLDistribution = $null

    if (Test-Path Alias:\wsl) {
      Remove-Item Alias:\wsl
    }
  } else {
    $env:PSWSLDistribution = $Distribution

    Set-Alias wsl Invoke-WSL -Scope Global
    Export-ModuleMember -Alias wsl
  }
}

Export-ModuleMember -Function Invoke-WSL
Export-ModuleMember -Function Set-WSLRuntime
