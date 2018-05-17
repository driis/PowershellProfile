# Load posh-git module from current directory
Import-Module posh-git
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
$GitPromptSettings.EnableWindowTitle = "$WindowTitle ~ "