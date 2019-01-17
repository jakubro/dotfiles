Set-StrictMode -Version 2.0

function ConvertFrom-Base64 {
  [CmdletBinding()]
  Param (
    [parameter(ValueFromPipeline=$true)]
    $Value,
    $Encoding = "UTF-8"
  )

  $enc = [System.Text.Encoding]::GetEncoding($Encoding)
  $bytes = [System.Convert]::FromBase64String($Value)
  return $enc.GetString($bytes)
}
