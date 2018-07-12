    $DBName = "xIT6C"
    $SourceLocation = "\\xxCM501\p$\IBMS\$DBName"
        
    $xxPJCM501 =  "\\xxxJCM599\p$\IBMS" 

    $Log = "D:\MyScripts\Log\$DBName-$date.txt"

    $DestinationLocation = "\L$\IBMS\"               #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    
    $AGPJCM_List = (import-csv -path .\AGPJCM-List.csv, .\AGPJMT-List.csv) 
    #$AGPJCM_List = @(import-csv -path .\AGPJCM-List2.csv) + @(Import-Csv -Path .\AGPJCM-List3.csv)

    $MagicTaskServers = "xxxJMT501", "xxxxJMT502"     #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    #$MagicTaskServers = "xxxJMT504"
    $AGPJCM_List
    
    Write-Host "`nStep 4: Folder Comparison." -ForegroundColor Cyan -BackgroundColor Blue 
    $colItems = (Get-ChildItem -Path $SourceLocation -Recurse | Measure-Object -Property length -sum)
    $colItems_2 = (Get-ChildItem -Path "$xxPJCM501\$DBName" -Recurse | Measure-Object -Property length -sum)
    
    Write-Host "`nStep 4: Folder Comparison." -ForegroundColor Cyan -BackgroundColor Blue 
    $colItems = (Get-ChildItem -Path $SourceLocation -Recurse | Measure-Object -Property length -sum)
    "`nLocation:`t`t`t`t`t`tSize:`t`t`tFiles:`n$SourceLocation`t" + "{0:N2}" -f ($colItems.sum / 1MB) + " MB`t`t" + $colItems.Count

    $colItems_2 = (Get-ChildItem -Path "$xxPJCM501\$DBName" -Recurse | Measure-Object -Property length -sum)
    "$xxPJCM501\$DBName`t`t" + "{0:N2}" -f ($colItems_2.sum / 1MB) + " MB`t`t" + ($colItems_2.Count - 1) + "`n`n"


#
        $Table = $null
        $tabName = "FolderComparison"
        #Create Table object
            $table = New-Object System.Data.DataTable “$tabName”
           
        #Define Columns
            $col1 = New-Object System.Data.DataColumn "Location",([string])
            $col2 = New-Object System.Data.DataColumn "Size(MB)",([string])
            $col3 = New-Object System.Data.DataColumn "Files",([string])
            $col4 = New-Object System.Data.DataColumn "ClientVersion",([string])
            
        #Add the Columns
            $table.columns.add($col1) 
            $table.columns.add($col2)
            $table.columns.add($col3)
            $table.columns.add($col4)


            $ClientVersion  = Get-Item -Path "$SourceLocation\ibms.exe"
            $ClientVersionNumber = $ClientVersion.VersionInfo.ProductVersion
        # Create a row 1
           $row = $table.NewRow()
        #Enter data in the row
            $row.Location = "$SourceLocation" 
            $row."Size(MB)" = "{0:N2}" -f ($colItems.sum / 1MB)
            $row.Files = ($colItems.count)
            $row.ClientVersion = $ClientVersionNumber
        #Add the row to the table
            $table.Rows.Add($row)


            $ClientVersion  = Get-Item -Path "$xxPJCM501\$DBName\ibms.exe"
            $ClientVersionNumber = $ClientVersion.VersionInfo.ProductVersion
        # Create a row 2
            $row = $table.NewRow()
        #Enter data in the row
            $row.Location = "$xxPJCM501\$DBName" 
            $row.'Size(MB)' = "{0:N2}" -f ($colItems_2.sum / 1MB)
            $row.Files = ($colItems_2.Count)
            $row.ClientVersion = $ClientVersionNumber
        #Add the row to the table
            $table.Rows.Add($row)
  

    #Display the table
        $table | Format-Table -AutoSize 

foreach ($ServerName in $AGPJCM_List)
    {
        $ServerName = $ServerName.HostName
        $ServerName

        $colItems_3 = (Get-ChildItem -Path "\\$ServerName$DestinationLocation$DBName" -Recurse | Measure-Object -Property length -sum)
        #Getting current Client VersionNumber
        $ClientVersion  = Get-Item -Path "\\$ServerName$DestinationLocation$DBName\ibms.exe"
        $ClientVersionNumber = $ClientVersion.VersionInfo.ProductVersion
        #$ClientVersionNumber           
           
           # Create a row
            $row = $table.NewRow()
        #Enter data in the row
            $row.Location = "\\$ServerName\$DestinationLocation$DBName" 
            $row.'Size(MB)' = "{0:N2}" -f ($colItems_2.sum / 1MB)
            $row.Files = ($colItems_3.Count)
            $row.ClientVersion = $ClientVersionNumber
        #Add the row to the table
            $table.Rows.Add($row)
    }       



    $table | Format-Table -AutoSize 
    #$table | Format-Table -GroupBy Files -AutoSize
    #$Table | Out-GridView
    #$Table | Format-Table -AutoSize | Out-File table.txt
