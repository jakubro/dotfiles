Set-StrictMode -Version 2.0

function Import-DotEnv {
  param(
    [Parameter(Mandatory=$true)]
    [string]    $Path,
    [hashtable] $Default
  )
  if ($Default -eq $null) {
    $Default = @{}
  }
  if (Test-Path $Path) {
    $imported = Get-Content $Path | Out-String | ConvertFrom-StringData
    foreach ($table in ($imported, $Default)) {
      if ($table -is [hashtable]) {
        foreach ($key in $table.Keys) {
          # exclude empty values
          if (![string]::IsNullOrWhiteSpace($table.$key)) {
            # don't overwrite existing
            $var = [System.Environment]::GetEnvironmentVariable($key)
            if ($var -eq $null) {
              [System.Environment]::SetEnvironmentVariable($key, $table.$key)
            }
          }
        }
      }
    }
  }
}
