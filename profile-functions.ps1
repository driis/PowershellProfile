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

function get-path($item)
{
  return (get-item $item).Fullname
}