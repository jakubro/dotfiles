Set-StrictMode -Version 2.0

function Get-OriginalCommand($Command) {
  $cmd = Get-Command $Command -ErrorAction Stop
  if ($cmd.CommandType -eq "Alias") {
    return (Get-Alias $Command).Definition
  } else {
    return $cmd.Source
  }
}
