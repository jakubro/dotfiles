Set-StrictMode -Version 2.0

<#
.SYNOPSIS
Merges two or more hashtables and returns the merged hashtable.

.PARAMETER IgnoreNullOrWhiteSpace
Whether to omit null or whitespace values.

.EXAMPLE
Merge-Hashtables @{ alpha = 1 } @{ beta = 2 }
#>

Function Merge-Hashtables([switch] $IgnoreNullOrWhiteSpace = $false) {
    $output = @{}
    foreach ($table in ($input + $args)) {
      if ($table -is [hashtable]) {
        foreach ($key in $table.Keys) {
          if (!$IgnoreNullOrWhiteSpace -or ![string]::IsNullOrWhiteSpace($table.$key)) {
            $output.$key = $table.$key
          }
        }
      }
    }
    $output
}
