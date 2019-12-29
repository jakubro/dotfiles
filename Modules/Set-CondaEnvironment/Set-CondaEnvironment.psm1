Set-StrictMode -Version 2.0

function Set-CondaEnvironment {
  $name = $args[0]
  cmd /C (
    "C:\tools\Miniconda3\Scripts\activate.bat $name && " +
    "set ParentPS=true && " +
    "set PSPromptName=$name && " +
    "powershell -NoExit -NoLogo"
  )
}
