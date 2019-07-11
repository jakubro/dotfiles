Set-StrictMode -Version 2.0

# python
$env:Path = "$env:APPDATA\Python\Python37\Scripts;$env:Path"
$env:Path = "$env:APPDATA\Python\Python37\site-packages;$env:Path"

# node
$env:NODEJS12_HOME = "C:\Users\jakub\AppData\Roaming\nvm\v12.5.0"
$env:NODEJS8_HOME = "C:\Users\jakub\AppData\Roaming\nvm\v8.16.0"

# android
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$env:ANDROID_SDK = "$env:LOCALAPPDATA\Android\Sdk"

# msbuild
$env:Path = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin;$env:Path"

# cuda
$env:Path = "$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0\bin;$env:Path"
$env:Path = "$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0\extras\CUPTI\libx64;$env:Path"
$env:Path = "$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0\include;$env:Path"
$env:Path = "$env:ProgramFiles\NVIDIA GPU Computing Toolkit\CUDA\v10.0\libnvvp;$env:Path"
$env:Path = "C:\tools\cudnn-8.0-windows10-x64-v6.0\cuda\bin;$env:Path"

# misc
$env:Path = "C:\tools\ffmpeg\bin;$env:Path"
$env:OPENCV_DIR = "C:\tools\opencv-3.4.6\build\x64\vc15\"

# aws
$env:Path = "$env:ProgramFiles\Amazon\ECSCLI;$env:Path"
