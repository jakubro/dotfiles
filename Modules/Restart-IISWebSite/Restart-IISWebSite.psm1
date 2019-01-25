Set-StrictMode -Version 2.0

function Restart-IISWebSite($Name = "Default Web Site") {
  appcmd start site $Name
  appcmd stop site $Name
}
