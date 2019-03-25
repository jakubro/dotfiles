Set-StrictMode -Version 2.0

function Get-RandomString($Length) {
  $rv = ""
  # all printable ascii characters: from char 33 (!) to char 126 (~)
  do {
    $rv += -join ((33..126) | Get-Random -Count $Length | % { [char]$_ })
  } while($rv.Length -le $Length)
  return $rv
}
