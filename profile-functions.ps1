# Unix-like DU commmand. Shows space used for directories below the given path.
# ref. http://www.viveksharma.com/TECHLOG/archive/2008/11/24/powershell-version-sort-of-of-unixrsquos-du-command.aspx
function du ($path = '.\', $unit="MB", $round=0)
{
   get-childitem $path -force | ? {
     $_.Attributes -like '*Directory*' } | %{
       dir $_.FullName -rec -force |
           measure-object -sum -prop Length |
               add-member -name Path -value $_.Fullname -member NoteProperty -pass |
                   select Path,Count,@{ expr={[math]::Round($_.Sum/"1$unit",$round)}; Name="Size($unit)"}
        }
}

# Unix-like tail using Get-Content
function tail($file)
{

  Get-Content $file -Tail 10 -Wait
}

function get-path($item)
{
  return (get-item $item).Fullname
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

function clean-branches($mainBranch)
{
	git branch --merged $mainBranch | foreach {
		$branch = $_.Trim()
    if (-not $branch.StartsWith("*")) {
      git branch -d $branch
    }
	}
}

function get-main
{
	git checkout main
	git pull --ff-only
	clean-branches "main"
}

function get-master
{
  git checkout master
  git pull --ff-only
  clean-branches "master"
}
