Write-Host "THis is Script 2" -ForegroundColor Blue
$DBName

   $MagicTaskServers = "AGPJMT599"
    
    foreach ($MagicTaskServer in $MagicTaskServers)
        {
            $MagicTaskServer = $MagicTaskServer.HostName
            $MagicTaskServer
           }