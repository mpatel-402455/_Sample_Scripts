
 $tempList = New-Object System.Collections.ArrayList

[void]$tempList.Add(
    [PSCustomObject]@{
        Server = $ServerName
        Hotfix = $hotfix
    }
)

$tempList | Select-Object @{Name='Server'; E=$_.Server }, @{Name='Hotfix'; E=$_.Hotfix } | Export-Csv -NoTypeInformation -Path "C:\temp\x.csv"
  
