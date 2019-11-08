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
  Enter-PythonScope
  Enter-NodeScope
#  Enter-NodeModulesScope # todo: turned off since it breaks a lot of stuff, e.g. `npm i husky` fails
  Enter-WSLScope
  return Get-Prompt -Settings $PSPromptSettings
}

Export-ModuleMember -Variable PSPromptSettings
Export-ModuleMember -Function Prompt
