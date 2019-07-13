Set-StrictMode -Version 2.0

function Get-DefaultPython {
  $default = Get-OriginalCommand python
  if ($default -eq (Get-OriginalCommand python3)) {
    return 'python3'
  } elseif ($default -eq (Get-OriginalCommand python2)) {
    return 'python2'
  } else {
    return $null
  }
}
