$hosts = "C:\Windows\system32\drivers\etc\hosts";
Import-Module D:\WindowsPowerShell\Modules\Pscx -arg ~\Pscx.UserPreferences.ps1
Set-Alias n atom
add-pathvariable "D:\scripts"

$profileDir = [System.IO.Path]::GetDirectoryName($profile);
. "$profileDir\profile-functions.ps1"
$profile = [System.IO.Path]::Combine($profileDir,"Profile.ps1");
cd D:\ | out-null

function prompt() {
  $loc = get-location;
  $h = get-host;
  $h.UI.RawUI.WindowTitle = "$loc -- PowerShell";
  "$loc>"
}


function gs()
{
	git status
}

function ga()
{
	git add .
	gs
}
# Load posh-git example profile
. 'D:\WindowsPowerShell\Modules\posh-git\profile.example.ps1'
