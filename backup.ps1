Set-StrictMode -Version 2.0

try {
  Remove-Item D:\archive\* -Include "*.rar"
} catch { }

$timestamp = [DateTime]::UtcNow.ToString("yyyyMMddHHmmssZ")

$source = "C:\dev\src"
$destination = "D:\archive\src_$timestamp.rar"

& "${env:ProgramFiles}\WinRAR\WinRAR.exe" a -t -k -ibck -ma5 -m5 -md1024m -htb-oi:131072 -qo- $destination $source
