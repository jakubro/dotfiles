#Requires -Modules Get-OriginalCommand

Set-StrictMode -Version 2.0

function Set-ActiveNodejs([int] $Version) {
  $node = (Get-OriginalCommand "node$Version")
  $npm = (Get-OriginalCommand "npm$Version")

  Set-Alias -Scope Global node $node
  Set-Alias -Scope Global npm $npm
}
