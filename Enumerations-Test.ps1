
#requires -Version 5
enum MyFavoriteCities
{
  Hannover
  Seattle
  London
  NewYork
  Toronto
}


function Select-City
{
  param
  (
    [MyFavoriteCities]
    [Parameter(Mandatory=$true)]
    $city
  )
  
  "You chose $city"
}

Select-City toronto
