Set-StrictMode -Version 2.0

function ConvertFrom-Base64 {
  [CmdletBinding()]
  Param (
  # Either a string to decode, or a path to file.
    [parameter(ValueFromPipeline = $true)]
    $Value,

  # Encoding of the decoded $Value if it is a string.
    $Encoding = "UTF-8",

  # Whether to return array of bytes.
    [switch]
    $Raw = "UTF-8",

  # Whether the $Value is a path to file which content we should decode.
    [switch]
    $IsPath = $false,

    $OutFile = $null
  )

  if ($IsPath) {
    $path = Resolve-Path $Value
    $Value = [System.IO.File]::ReadAllText($path)
  }

  $bytes = [System.Convert]::FromBase64String($Value)
  if ($Raw) {
    $rv = $bytes
  } else {
    $enc = [System.Text.Encoding]::GetEncoding($Encoding)
    $rv = $enc.GetString($bytes)
  }

  if ($OutFile -eq $null) {
    return $rv
  } else {
    [System.IO.File]::WriteAllBytes($OutFile, $bytes)
  }
}
