Set-StrictMode -Version 2.0

function Set-CondaEnvironment {
  $name = $args[0]
  cmd /C (
    "C:\ProgramData\Anaconda3\Scripts\activate.bat $name && " +
    "set ParentPS=true && " +
    "set ParentPSPromptName=$name && " +
    "powershell -NoExit -NoLogo"
  )
}
