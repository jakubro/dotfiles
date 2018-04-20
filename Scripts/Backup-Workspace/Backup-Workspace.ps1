#Requires -Modules TryCreate-EventLog, Import-PSWorkspace
Set-StrictMode -Version 2.0

$logName = "@jakubro/dotfiles"
$logSource = Split-Path $PSCommandPath -Leaf
TryCreate-EventLog -LogName $logName -Source $logSource

# load backup configuration from workspace (this script is running
# in "-NoProfile" environment, so we have to load this manually)

$PSWorkspace = Import-PSWorkspace -Path "~\.env" -Default @{
  BACKUP_SOURCE = $null;
  BACKUP_DESTINATION = $null;
}

# what to backup & where to save the backup

$timestamp = [DateTime]::UtcNow.ToString("yyyyMMddHHmmssZ")

if ([string]::IsNullOrWhiteSpace($PSWorkspace.BACKUP_SOURCE) -or
    [string]::IsNullOrWhiteSpace($PSWorkspace.BACKUP_DESTINATION)) {
  Write-EventLog -LogName $logName -Source $logSource -EventID 2001 -EntryType Error `
    -Message "One of specified directories does not exist."
  return
}

$source = $PSWorkspace.BACKUP_SOURCE.Trim("\", "/") # trailing slash causes arguments to be interpreted incorrectly
$destination = Join-Path $PSWorkspace.BACKUP_DESTINATION "backup_$timestamp.rar"

Write-EventLog -LogName $logName -Source $logSource -EventID 1000 -EntryType Information -Message "Backup started."

# WinRar arguments explanation:
#     a                 create archive
#     -t                test files after archiving
#     -k                lock archive
#     -ibck             run in background
#     -ma5              use RAR5.0 archive format
#     -m5               use best compression method
#     -md1024m          use dictionary of size 1024MB
#     -htb              use BLAKE2 hash
#     -oi:131072        save identical files larger than 128KB as references
#     -qo-              don't add quick open information
#     --                stop switches scanning

& "${env:ProgramFiles}\WinRAR\WinRAR.exe" a -t -k -ibck -ma5 -m5 -md1024m -htb -oi:131072 -qo- -- $destination $source

Write-EventLog -LogName $logName -Source $logSource -EventID 1000 -EntryType Information -Message "Backup finished."
