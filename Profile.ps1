$hosts = "C:\Windows\system32\drivers\etc\hosts";
$ProfileDir = Split-Path -Parent $Profile
Import-Module Pscx -arg (Join-Path $ProfileDir "config/Pscx.UserPreferences.ps1")
Set-Alias n atom
if (Test-Path "D:\scripts") {
  add-pathvariable "D:\scripts"
}

$profileDir = [System.IO.Path]::GetDirectoryName($profile);
. "$profileDir\profile-functions.ps1"
$profile = [System.IO.Path]::Combine($profileDir,"Profile.ps1");
cd D:\ | out-null

# Load posh-git profile
. (Join-Path $ProfileDir config\posh-git-profile.driis.ps1)
