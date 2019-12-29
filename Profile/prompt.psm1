# These settings controls how the prompt looks like and behaves.
$PSPromptSettings = @{
  # If $True, then display only "$ " as the prompt, otherwise display bunch of other info.
  HideAll = $false;

  # Hide individual info from the prompt.
  # todo:
  HideDate = $false;
  HidePromptName = $false;
  HidePythonEnvironment = $false;
  HideNodeEnvironment = $false;
  HideWSLEnvironment = $false;
  HideAWSProfile = $false;
  HideLocation = $false;
  HideGitStatus = $false;

  # If $True, then display full path of the current directory, otherwise display only the directory name.
  FullPath = $false;
}

function Prompt {
  # Run individual customizations that depends on the current location or external filesystem changes.
  Enter-PythonScope
  Enter-NodeScope
  Enter-WSLScope

  ## todo: turned off since it breaks a lot of stuff, e.g. `npm i husky` fails
  # Enter-NodeModulesScope
  ## todo:
  # Enter-DotEnvScope

  # write propmpt string to console
  return Get-Prompt -Settings $PSPromptSettings
}

Export-ModuleMember -Variable PSPromptSettings
Export-ModuleMember -Function Prompt
