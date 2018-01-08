Set-StrictMode -Version 2.0

function TryCreate-EventLog {
  param(
    [Parameter(Mandatory=$true)]
    [string]   $LogName,
    [Parameter(Mandatory=$true)]
    [string[]] $Source
  )

  $register = @()
  foreach ($sourceName in $Source) {
    # register this source if it does not exist yet
    if (![System.Diagnostics.EventLog]::SourceExists($sourceName)) {
      $register += $sourceName
      continue
    }

    # abort if the source is already registered with another log
    $logFromSource = [System.Diagnostics.EventLog]::LogNameFromSourceName($sourceName, ".")
    if (!($logFromSource -eq $LogName)) {
      throw "The '$sourceName' source is already registered to '$logFromSource' log."
    }
  }

  # create log and register provided sources
  if (![System.Diagnostics.EventLog]::Exists($LogName) -or
      $register.Length -gt 0) {
    New-EventLog -LogName $LogName -Source $register
  }
}
