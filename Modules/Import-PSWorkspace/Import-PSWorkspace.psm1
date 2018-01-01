Set-StrictMode -Version 2.0

function Import-PSWorkspace {
  param(
    [Parameter(Mandatory=$true)]
    [string]    $Path,
    [hashtable] $Initial
  )
  if ($Initial -eq $null) {
    $Initial = @{}
  }
  $workspace = $Initial
  if (Test-Path $Path) {
    $imported = Get-Content $Path | Out-String | ConvertFrom-StringData
    $workspace = Merge-Hashtables -IgnoreNullOrWhiteSpace $Initial $imported
  }
  return $workspace
}
