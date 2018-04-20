Set-StrictMode -Version 2.0

function Get-RandomString($Length) {
  # all printable ascii characters: from char 33 (!) to char 126 (~)
  return -join ((33..126) | Get-Random -Count $Length | % { [char]$_ })
}
