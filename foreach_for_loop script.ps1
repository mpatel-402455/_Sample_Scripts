$MagicTaskServers = "AGPJMT504", "AGPJMT500"
$DBNames = "SIT6CL", "SIT6", "SIT6C"
$count = ($DBNames.Count) -1
$count



for ($i=0; $i -lt $count; $i++) 
{
    write-host -foregroundcolor yellow $i"." $DBNames[$i] 
}
      
 foreach ($MagicTaskServer in $MagicTaskServers)
        {
          Write-Host "`n$MagicTaskServer" -ForegroundColor Cyan `n
          #"This is in foreach loop: $DBNames[$i]   "
          
            
            foreach ($DBName in $DBNames)
                {
                    #"In 2nd foreach loop  $DBName"
                   "Start the services on $DBName"
                }
        
        
        }

