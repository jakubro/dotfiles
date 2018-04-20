Set-StrictMode -Version 2.0

function Import-PSWorkspace {
  param(
    [Parameter(Mandatory=$true)]
    [string]    $Path,
    [hashtable] $Default
  )
  if ($Default -eq $null) {
    $Default = @{}
  }
  $workspace = $Default
  if (Test-Path $Path) {
    $imported = Get-Content $Path | Out-String | ConvertFrom-StringData
    $workspace = Merge-Hashtables -IgnoreNullOrWhiteSpace $Default $imported
  }
  return $workspace
}
