Set-StrictMode -Version 2.0

function Restart-IISAppPool($Name = "DefaultAppPool") {
  appcmd recycle apppool /apppool.name:$Name
}
