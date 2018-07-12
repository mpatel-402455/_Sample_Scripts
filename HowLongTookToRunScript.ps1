# Get Start Time
$startDTM = (Get-Date)

    #sleep 5

# Get End Time
$endDTM = (Get-Date)

# Display Time elapsed

    #"Elapsed Time: $(($endDTM-$startDTM).TotalSeconds) seconds"
    #"Elapsed Time: " + "{0:N2}" -f  $(($endDTM-$startDTM).TotalMinutes) 

if ( $(($endDTM-$startDTM).TotalSeconds) -lt 60)
    {
      $ET =  "Elapsed Time: " + "{0:N2}" -f  $(($endDTM-$startDTM).TotalMinutes) + " seconds"
      $ET = "{0:N2}" -f  $(($endDTM-$startDTM).TotalSeconds)
      Write-Host "`nElapsed Time: $ET seconds" -ForegroundColor Green
    }
elseif ($(($endDTM-$startDTM).TotalSeconds) -gt 60)
    {
         $ET = "{0:N2}" -f  $(($endDTM-$startDTM).TotalMinutes)

         Write-Host "`nElapsed Time: $ET  Minutes" -ForegroundColor Green
    }
