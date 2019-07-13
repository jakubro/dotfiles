Set-StrictMode -Version 2.0

function Set-NodeRuntime([int] $Version = 12) {
  $nodePath = (Get-Item env:"NODEJS$( $Version )_HOME").Value
  if (!$nodePath) {
    throw "$Version is not a valid Node.js version."
  }
  $env:Path = "$nodePath;$env:Path"
}
