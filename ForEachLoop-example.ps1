$servernames = import-csv -path e:\test.csv
foreach ($servername in $servernames)
{
"This is "+ $servername.hostname
"this is "+ $servername.ip
}


#
    for ($x=0; $x -lt $DestinationServer.Length; $x++)

        { 
         $DBLocation = ("\\"+ $DestinationServer[$x]+"\D$\Test\IBMS\SIT6CL\*")
         $DBLocation

         $DServer = $DestinationServer[$x]
         Write-Host "Destination Server is: " $DServer
         Write-Verbose -Verbose "Copying SIT6CL from $SourceLocation TO $DServer server"
         #Remove-Item -Path $DBLocation -Force -Recurse -Verbose
         #Robocopy.exe $SourceLocation $CTXFolder"\SIT6CL" /R:0 /W:0 /MT:32 /DCOPY:T /COPY:DAT /MIR /LOG+:D:\test\IBMS\Log\SIT6CL.txt
}

Get-Date