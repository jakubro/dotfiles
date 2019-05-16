#Requires -Modules Get-Prompt, Enter-PythonEnvironment

# These settings controls how the prompt looks like and behaves.
$PSPromptSettings = @{
  # If $True, then display only "$ " as the prompt, otherwise display current time, working
  # directory, subshell, and other info.
  Compact = $false;

  # If $True, then display full path of the current working directory, otherwise display only the
  # directory name.
  FullPath = $false;
}

function Prompt {
  Enter-PythonEnvironment
  return Get-Prompt -Settings $PSPromptSettings
}

Export-ModuleMember -Variable PSPromptSettings
Export-ModuleMember -Function Prompt
