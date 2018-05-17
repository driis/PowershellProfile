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
Add-PathVariable "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin"
Add-PathVariable "C:\Program Files\nodejs"
Add-PathVariable "C:\Program Files (x86)\Microsoft SDKs\F#\4.1\Framework\v4.0"
Set-Alias n code
if (Test-Path "D:\scripts") {
  add-pathvariable "D:\scripts"
}

. "$ProfileDir\profile-functions.ps1"
$profile = [System.IO.Path]::Combine($profileDir,"Profile.ps1");

$WindowTitle = "$Env:UserName on $(hostname)"
$Host.UI.RawUI.WindowTitle = $WindowTitle

# Load posh-git profile
. (Join-Path $ProfileDir config\posh-git-profile.driis.ps1)
. (Join-Path $ProfileDir paket.ps1)

# Setup Git to use OpenSSH bundled with Windows so we can use ssh-agent as a service
(get-command ssh)[0].Source | Set-Item Env:GIT_SSH
ssh-add
