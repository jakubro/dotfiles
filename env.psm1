Set-StrictMode -Version 2.0

# python
$env:Path = "$env:APPDATA\Python\Python37\Scripts;$env:Path"
$env:Path = "$env:APPDATA\Python\Python37\site-packages;$env:Path"

# android
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$env:ANDROID_SDK = "$env:LOCALAPPDATA\Android\Sdk"

# cuda
$env:Path = "$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0\bin;$env:Path"
$env:Path = "$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0\extras\CUPTI\libx64;$env:Path"
$env:Path = "$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0\include;$env:Path"
$env:Path = "$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0\libnvvp;$env:Path"
$env:Path = "C:\tools\cudnn-8.0-windows10-x64-v6.0\cuda\bin;$env:Path"
