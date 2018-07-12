
  for($i = 1; $i -lt 101; $i++ )
    {
        Write-Progress -activity Updating -Status 'Progress->' -PercentComplete $i -currentOperation OuterLoop; `
        
        for($j = 1; $j -lt 101; $j++ )
            {
                Write-Progress -id  1 -activity Updating -Status 'Progress' -PercentComplete $j -currentOperation InnerLoop
            } 
    }
