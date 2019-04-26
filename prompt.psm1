#Requires -Modules Get-Prompt, Enter-PythonEnvironment

$PSPromptSettings = @{
  Compact = $false;
  FullPath = $false;
}

function Prompt {
  Enter-PythonEnvironment
  return Get-Prompt
}

Export-ModuleMember -Variable PSPromptSettings
Export-ModuleMember -Function Prompt
