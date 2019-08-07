Set-StrictMode -Version 2.0

function ConvertTo-Base64 {
  [CmdletBinding()]
  Param (
  # Either a string to encode, an array of bytes, or a path to file.
    [parameter(ValueFromPipeline = $true)]
    $Value,

  # Encoding of the $Value if it is a string.
    $Encoding = "UTF-8",

  # Whether the $Value is a path to file which content we should encode.
    [switch]
    $IsPath = $false,

    $OutFile = $null
  )

  if ($Value -is [array]) {
    $bytes = $Value
  } elseif ($IsPath) {
    $path = Resolve-Path $Value
    $bytes = [System.IO.File]::ReadAllBytes($path)
  } else {
    $enc = [System.Text.Encoding]::GetEncoding($Encoding)
    $bytes = $enc.GetBytes($Value)
  }

  $rv = [System.Convert]::ToBase64String($bytes)
  if ($OutFile -eq $null) {
    return $rv
  } else {
    [System.IO.File]::WriteAllText($OutFile, $rv)
  }
}
