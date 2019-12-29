function Remove-RecursivelyNodeModules {
  ls -Force -Recurse -Directory -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty FullName |
  ? {
    $_.EndsWith('node_modules') -and -not $_.Substring(0, $_.LastIndexOf('node_modules')).Contains('node_modules')
  } |
  % {
    if (Test-Path $_) {
      rm -Recurse -Force $_
    }
  }
}
