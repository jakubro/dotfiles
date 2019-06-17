Set-StrictMode -Version 2.0

function Invoke-PipInstall {
  iex "pip install $args"
  pip freeze | Out-File -Encoding ascii .\requirements.lock.txt
}
