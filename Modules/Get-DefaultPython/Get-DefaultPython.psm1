Set-StrictMode -Version 2.0

function Get-DefaultPython {
  $default = Get-OriginalCommand python
  if ($default -eq (Get-OriginalCommand python38)) {
    return 'python38'
  } elseif ($default -eq (Get-OriginalCommand python37)) {
    return 'python37'
  } elseif ($default -eq (Get-OriginalCommand python36)) {
    return 'python36'
  } elseif ($default -eq (Get-OriginalCommand python27)) {
    return 'python27'
  } else {
    return $null
  }
}
