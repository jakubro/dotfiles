Set-StrictMode -Version 2.0

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
