# Get Start Time
$startDTM = (Get-Date)

#-------

# Get End Time
    $endDTM = (Get-Date)

# Display Time elapsed

if ( $(($endDTM-$startDTM).TotalSeconds) -lt 60)
    {
      $ET =  "Elapsed Time: " + "{0:N2}" -f  $(($endDTM-$startDTM).TotalMinutes) + " seconds"
      $ET = "{0:N2}" -f  $(($endDTM-$startDTM).TotalSeconds)
      Write-Host "Elapsed Time: $ET seconds" -ForegroundColor Green
    }
elseif ($(($endDTM-$startDTM).TotalSeconds) -gt 60)
    {
         $ET = "{0:N2}" -f  $(($endDTM-$startDTM).TotalMinutes)

         Write-Host "Elapsed Time: $ET  Minutes" -ForegroundColor 
    }
