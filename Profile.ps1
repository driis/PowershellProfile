$hosts = "C:\Windows\system32\drivers\etc\hosts";
$ProfileDir = Split-Path -Parent $Profile
Import-Module Pscx -arg (Join-Path $ProfileDir "config/Pscx.UserPreferences.ps1")
Import-Module PSReadLine
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-Alias pbpaste get-clipboard
Set-Alias pbcopy set-clipboard
#Paths
Set-Alias n code
Add-PathVariable "C:\Program Files\Git\bin"
Add-PathVariable "C:\Program Files\Amazon\AWSCLIV2"


if (Test-Path "D:\scripts") {
  add-pathvariable "D:\scripts"
}

# Make TLS1.2 default for this instance of PSH
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

. "$ProfileDir\profile-functions.ps1"
$profile = [System.IO.Path]::Combine($profileDir,"Profile.ps1");

$WindowTitle = "$Env:UserName on $(hostname)"
$Host.UI.RawUI.WindowTitle = $WindowTitle

# Load posh-git profile
. (Join-Path $ProfileDir config\posh-git-profile.driis.ps1)

# Setup Git to use OpenSSH bundled with Windows so we can use ssh-agent as a service
(get-command ssh)[0].Source | Set-Item Env:GIT_SSH

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
