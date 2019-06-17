Set-StrictMode -Version 2.0

function Get-DevToolsInfo {
  Write-Host -ForegroundColor Magenta -NoNewline "python"
  Write-Host -ForegroundColor White "`t$( (Get-Command python).Source )"

  Write-Host -ForegroundColor Magenta -NoNewline "pip"
  Write-Host -ForegroundColor White "`t$( (Get-Command pip).Source )"

  Write-Host -ForegroundColor Magenta -NoNewline "node"
  Write-Host -ForegroundColor White "`t$( (Get-Command node).Source )"

  Write-Host -ForegroundColor Magenta -NoNewline "npm"
  Write-Host -ForegroundColor White "`t$( (Get-Command npm).Source )"
}
