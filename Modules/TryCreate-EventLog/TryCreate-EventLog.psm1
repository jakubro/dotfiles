Set-StrictMode -Version 2.0

function TryCreate-EventLog {
  param(
    [Parameter(Mandatory=$true)]
    [string]   $LogName,
    [Parameter(Mandatory=$true)]
    [string[]] $Source
  )
  if (![System.Diagnostics.EventLog]::Exists($LogName) -or
      ![System.Diagnostics.EventLog]::SourceExists($Source)) {
    New-EventLog -LogName $LogName -Source $Source
  }
}
