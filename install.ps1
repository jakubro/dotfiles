try {
  $temp = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid().Guid)
  mkdir $temp

  git clone https://github.com/jakubro/dotfiles $temp
  mv $temp\* (Split-Path $PROFILE)
} finally {
  if (Test-Path $temp) {
    rm -Recurse -Force $temp
  }
}
