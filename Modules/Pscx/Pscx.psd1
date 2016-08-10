@{
    GUID               = '0fab0d39-2f29-4e79-ab9a-fd750c66e6c5'
    Author             = 'PowerShell Community Developers'
    CompanyName        = 'http://pscx.codeplex.com/'
    Copyright          = 'Copyright PowerShell Community Developers 2006 - 2012.'
    Description        = 'PowerShell Community Extensions (PSCX) base module which implements a general purpose set of Cmdlets.'
    PowerShellVersion  = '2.0'
    CLRVersion         = '2.0'
    ModuleVersion      = '2.1.1.0'
    RequiredAssemblies = 'Pscx.dll' # needed for [pscxmodules] type (does not import cmdlets/providers)
    ModuleToProcess    = 'Pscx.psm1'
    NestedModules      = 'Pscx.dll'    
    AliasesToExport    = '*'
    CmdletsToExport    = @(
        'Add-PathVariable',
        'Clear-MSMQueue',
        'ConvertFrom-Base64',
        'ConvertTo-Base64',
        'ConvertTo-MacOs9LineEnding',
        'ConvertTo-Metric',
        'ConvertTo-UnixLineEnding',
        'ConvertTo-WindowsLineEnding',
        'Convert-Xml',
        'Disconnect-TerminalSession',
        'Expand-Archive',
        'Export-Bitmap',
        'Format-Byte',
        'Format-Hex',
        'Format-Xml',
        'Get-ADObject',
        'Get-AdoConnection',
        'Get-AdoDataProvider',
        'Get-AlternateDataStream',
        'Get-Clipboard',
        'Get-DhcpServer',
        'Get-DomainController',
        'Get-DriveInfo',
        'Get-EnvironmentBlock',
        'Get-FileTail',
        'Get-FileVersionInfo',
        'Get-ForegroundWindow',
        'Get-Hash',
        'Get-HttpResource',
        'Get-LoremIpsum',
        'Get-MountPoint',
        'Get-MSMQueue',
        'Get-OpticalDriveInfo',
        'Get-PathVariable',
        'Get-PEHeader',
        'Get-Privilege',
        'Get-PSSnapinHelp',
        'Get-ReparsePoint',
        'Get-RunningObject',
        'Get-ShortPath',
        'Get-TabExpansion',
        'Get-TerminalSession',
        'Get-TypeName',
        'Get-Uptime',
        'Import-Bitmap',
        'Invoke-AdoCommand',
        'Invoke-Apartment',
        'Join-String',
        'New-Hardlink',
        'New-Junction',
        'New-MSMQueue',
        'New-Shortcut',
        'New-Symlink',
        'Out-Clipboard',
        'Ping-Host',
        'Pop-EnvironmentBlock',
        'Push-EnvironmentBlock',
        'Read-Archive',
        'Receive-MSMQueue',
        'Remove-AlternateDataStream',
        'Remove-MountPoint',
        'Remove-ReparsePoint',
        'Resolve-Host',
        'Send-MSMQueue',
        'Send-SmtpMail',
        'Set-BitmapSize',
        'Set-Clipboard',
        'Set-FileTime',
        'Set-ForegroundWindow',
        'Set-PathVariable',
        'Set-Privilege',
        'Set-VolumeLabel',
        'Skip-Object',
        'Split-String',
        'Start-TabExpansion',
        'Stop-TerminalSession',
        'Test-AlternateDataStream',
        'Test-Assembly',
        'Test-MSMQueue',
        'Test-Script',
        'Test-UserGroupMembership',
        'Test-Xml',
        'Unblock-File',
        'Write-BZip2',
        'Write-Clipboard',
        'Write-GZip',
        'Write-Tar',
        'Write-Zip'
    )
    FunctionsToExport = @(
        'Add-DirectoryLength',
        'Add-ShortPath',
        'Edit-File',
        'Edit-Profile',
        'Edit-HostProfile',
        'Enable-OpenPowerShellHere',
        'Get-ExecutionTime',
        'Get-Help',
        'Get-Parameter',
        'Get-PropertyValue',
        'Get-ScreenCss',
        'Get-ScreenHtml',
        'Get-ViewDefinition',
        'help',
        'Import-VisualStudioVars',
        'Invoke-BatchFile',
        'Invoke-Elevated',
        'Invoke-GC',
        'Invoke-Method',
        'Invoke-NullCoalescing',
        'Invoke-Ternary',
        'less',
        'New-HashObject',
        'Out-Speech',
        'prompt',
        'QuoteList',
        'QuoteString',
        'Resolve-ErrorRecord',
        'Resolve-HResult',
        'Resolve-WindowsError',
        'Search-Transcript',
        'Set-Writable',
        'Set-ReadOnly',
        'Show-Tree',
        'Start-PowerShell',
        'Stop-RemoteProcess',
        'Set-LocationEx',
        'Dismount-VHD',
        'Mount-VHD'
    )
    FormatsToProcess   = @(
        'FormatData\Pscx.Format.ps1xml',
        'FormatData\Pscx.FeedStore.Format.ps1xml',
        'FormatData\Pscx.Archive.Format.ps1xml',
        'FormatData\Pscx.Environment.Format.ps1xml',
        'FormatData\Pscx.Security.Format.ps1xml',
        'FormatData\Pscx.SIUnits.Format.ps1xml',
        'FormatData\Pscx.TerminalServices.Format.ps1xml'
    )
    TypesToProcess     = @(
        'TypeData\Pscx.FeedStore.Type.ps1xml',
        'TypeData\Pscx.Archive.Type.ps1xml',
        'TypeData\Pscx.Reflection.Type.ps1xml',
        'TypeData\Pscx.SIUnits.Type.ps1xml',
        'TypeData\Pscx.TerminalServices.Type.ps1xml'        
    )
}