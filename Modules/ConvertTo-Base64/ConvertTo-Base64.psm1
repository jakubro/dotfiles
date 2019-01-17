Set-StrictMode -Version 2.0

function ConvertTo-Base64 {
  [CmdletBinding()]
  Param (
    [parameter(ValueFromPipeline=$true)]
    $Value,
    $Encoding = "UTF-8"
  )

  $enc = [System.Text.Encoding]::GetEncoding($Encoding)
  $bytes = $enc.GetBytes($Value)
  return [System.Convert]::ToBase64String($bytes)
}
