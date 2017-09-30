Set-StrictMode -Version 2.0

<#
.SYNOPSIS
Merges two or more hashtables and returns the merged hashtable.

.EXAMPLE
Merge-Hashtables @{ alpha = 1 } @{ beta = 2 }
#>

Function Merge-Hashtables {
    $output = @{}
    foreach ($table in ($input + $args)) {
      if ($table -is [hashtable]) {
        foreach ($key in $table.Keys) {
          $output.$key = $table.$key
        }
      }
    }
    $output
}
