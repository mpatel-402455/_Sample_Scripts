#					  https://github.com/mpatel-402455		                #
                     #        Script Version : 2.0                                                      #
                     #        Last Modified  : December 18, 2014                                        #
                     #        Prerequisite   : PowerShell.                                              #
                     #        Copyright      :  https://github.com/mpatel-402455                        #
                     ####################################################################################

Start-Transcript

    $date = Get-Date -UFormat %Y-%m-%d-%H%M%S
    $date
    Get-Date
    # Get Start Time
    $startDTM = (Get-Date)

    $DBName = "PROD"
    $SourceLocation = "\\PJCM_Srv01\L$\IBMS\SIT6CL"
    $PRD_Srv01 =  "\\PRD_Srv01\L$\IBMSCLIENT"               #<<<<<<<<<<<<<

    $Log = "C:\MyScripts\Log\$DBName-$date.txt"            #<<<<<<<<<<<<<<

    $DestinationLocation = "\L$\IBMSCLIENT\"               #<<<<<<<<<<<<<<

    $PilatAppConfigFile = $PRD_Srv01+"\$DBName\PilatApp.config"

    $AGPJCM_List = import-csv -path .\PROD-OddServer_List.csv

    $MagicTaskServers = "MagicTaskSrv01", "MagicTaskSrv02", "MagicTaskSrv03"     #<<<<<<<<<<<

    $ServiceHelper = "Pilat.Workflow.WindowsService.Helper_$DBName"
    $ServiceTracking = "Pilat.Workflow.WindowsService.Tracking_$DBName"
    $ServiceNames = "$ServiceHelper", "$ServiceTracking"
    $ImgNames = "Pilat.Workflow.WindowsService.Helper.exe", "Pilat.Workflow.WindowsService.tracking.exe"

    #Getting current Client VersionNumber
    $ClientVersion  = Get-Item -Path "$PRD_Srv01\$DBName\ibms.exe"
    $ClientVersionNumber = $ClientVersion.VersionInfo.ProductVersion

# 1 - Rename current PROD client to "PROD x.xx.xx.xx." (current version number). Then copy the update version of client

    Write-Host "`nStep 1: Client Copy. `n" -ForegroundColor Cyan -BackgroundColor Blue
        if (Test-Path "$PRD_Srv01\$DBName")
            {
                Write-Host "1.1. Copying and Renameing ""$PRD_Srv01\$DBName"" directory to ""$DBName $ClientVersionNumber""" -ForegroundColor Cyan `n
                "Please wait... `n"
                Copy-Item -Path "$PRD_Srv01\$DBName" -Destination "$PRD_Srv01\$DBName $ClientVersionNumber" -Force -Recurse 
            
                Write-Host "1.2. Copying ""$SourceLocation"" directory to ""$PRD_Srv01""" -ForegroundColor Cyan
                "Please wait... `n"
                Robocopy.exe $SourceLocation "$PRD_Srv01\$DBName" /R:0 /W:0 /MT:16 /DCOPY:T /COPY:DAT /MIR /LOG+:$Log
            }

        else 
            {
                Write-Host "1.1. Please wait. Copying ""$SourceLocation"" directory to ""$PRD_Srv01""" -ForegroundColor Cyan -BackgroundColor Gray
                Robocopy.exe $SourceLocation "$PRD_Srv01\$DBName" /R:0 /W:0 /MT:16 /DCOPY:T /COPY:DAT /MIR /LOG+:$Log
            }


# 2. Modify PilatApp.config
        
    Write-Host "`nStep 2: Modify PilatApp.config. " -ForegroundColor Cyan -BackgroundColor Blue
    Write-Host "`n2.0: Modifying ""PilatApp.config"" file for $DBName database upgrade. `n" -ForegroundColor Cyan

    $XML = [xml](Get-Content -Path $PilatAppConfigFile)

# 2.1: Database Name
    $XML.configuration.ibmsSettings.database.dbName = "$DBName"
    Write-Host "2.1: Datbase Value: " $XML.configuration.ibmsSettings.database.dbName -ForegroundColor Yellow `n

# 2.2: SSO authenticationType
    $XML.configuration.ibmsSettings.security.authenticationType = "WebServiceLADPAuthenticationNoScreen"
    Write-Host "2.2: authenticationType: " $XML.configuration.ibmsSettings.security.authenticationType -ForegroundColor Yellow `n

# 2.3: SSO WebServerURL
    $XML.configuration.ibmsSettings.security.webServiceUrl = "https://qa.lab.ca/SSOWebService/Service.asmx"
    Write-Host "2.3: webServiceUrl: " $XML.configuration.ibmsSettings.security.webServiceUrl -ForegroundColor Yellow `n

# 2.4: customization.enableCustomization
    $XML.configuration.ibmsSettings.customization.enableCustomization = "true"
    Write-Host "2.4: enableCustomization Value: " $XML.configuration.ibmsSettings.customization.enableCustomization -ForegroundColor Yellow `n

# Collects all Key and Values
    $collection = ($xml.configuration.appSettings.add.Count) -1
    
    for ($i=0
         $i -le $collection
         $i++)

            {
                #2.5: TempFolder
                    if ($xml.configuration.appSettings.add.key[$i] -eq "TempFolder") 
                        {
                            Write-Host "2.5:" $xml.configuration.appSettings.add.key[$i] -ForegroundColor Yellow
                            $XML.configuration.appSettings.add.Item($i).value = "L:\temp\"
                            Write-Host "New Value :" $XML.configuration.appSettings.add.value[$i] -ForegroundColor Yellow `n
                        }

                # 2.6:XmlMapFilePath        
                    if ($xml.configuration.appSettings.add.key[$i] -eq "XmlMapFilePath") 
                        {
                            Write-Host "2.6:" $xml.configuration.appSettings.add.key[$i] -ForegroundColor Yellow
                            $XML.configuration.appSettings.add.Item($i).value = "p:\IBMS\Help Files for IBMS\Combined.xml"
                            Write-Host "New Value :"$XML.configuration.appSettings.add.value[$i] -ForegroundColor Yellow `n
                        }
            
                # 2.7: ChmFilePath
                    if ($xml.configuration.appSettings.add.key[$i] -eq "ChmFilePath") 
                        {
                            Write-Host "2.7:" $xml.configuration.appSettings.add.key[$i] -ForegroundColor Yellow
                            $XML.configuration.appSettings.add.Item($i).value = "p:\IBMS\Help Files for IBMS\IBMS Reference Guide.chm"
                            Write-Host "New Value :"$XML.configuration.appSettings.add.value[$i] -ForegroundColor Yellow `n
                        }
            
                # 2.8: BSImage
                    if ($xml.configuration.appSettings.add.key[$i] -eq "BSImage") 
                        {
                            Write-Host "2.8:" $xml.configuration.appSettings.add.key[$i] -ForegroundColor Yellow            
                            $XML.configuration.appSettings.add.Item($i).value = "p:\IBMS\logos"
                            Write-Host "New Value :"$XML.configuration.appSettings.add.value[$i] -ForegroundColor Yellow `n
                        }
            
                # 2.9: ServiceNames
                    if ($xml.configuration.appSettings.add.key[$i] -eq "ServiceNames") 
                        {
                            Write-Host "2.9:" $xml.configuration.appSettings.add.key[$i] -ForegroundColor Yellow
                            $XML.configuration.appSettings.add.Item($i).value = "Pilat.Workflow.WindowsService.Tracking_$DBName"
                            Write-Host "New Value :"$XML.configuration.appSettings.add.value[$i] -ForegroundColor Yellow `n
                        }
            
                # 2.10: StopServicesAtHour24Minute
                    if ($xml.configuration.appSettings.add.key[$i] -eq "StopServicesAtHour24Minute") 
                        {
                            Write-Host "2.10" $xml.configuration.appSettings.add.key[$i] -ForegroundColor Yellow
                            $XML.configuration.appSettings.add.Item($i).value = "22:30"
                            Write-Host "New Value :"$XML.configuration.appSettings.add.value[$i] -ForegroundColor Yellow `n
                        }
            
                # 2.11: StartServicesAtHour24Minute
                    if ($xml.configuration.appSettings.add.key[$i] -eq "StartServicesAtHour24Minute") 
                        {
                            Write-Host "2.11" $xml.configuration.appSettings.add.key[$i] -ForegroundColor Yellow
                            $XML.configuration.appSettings.add.Item($i).value = "05:00"
                            Write-Host "New Value :"$XML.configuration.appSettings.add.value[$i] -ForegroundColor Yellow `n
                        }
            
                # 2.12: ErrorsRecipients 
                    if ($xml.configuration.appSettings.add.key[$i] -eq "ErrorsRecipients") 
                        {
                            Write-Host "2.12" $xml.configuration.appSettings.add.key[$i] -ForegroundColor Yellow
                            $XML.configuration.appSettings.add.Item($i).value = "helpdesk@mylab.ca"
                            Write-Host "New Value :"$XML.configuration.appSettings.add.value[$i] -ForegroundColor Yellow `n
                        }
			    $XML.Save($PilatAppConfigFile)
            }


#Determining the Size of a Folder & File counts
#3.0: Comparing the original folder and copied folder to make sure they have same number of files.
    
    Write-Host "`nStep 3: Folder Comparison:" -ForegroundColor Cyan -BackgroundColor Blue
        $colItems = (Get-ChildItem -Path $SourceLocation -Recurse | Measure-Object -Property length -sum)
        $colItems_2 = (Get-ChildItem -Path "$PRD_Srv01\$DBName" -Recurse | Measure-Object -Property length -sum)

    #---
        # 3.A: Creating a Table
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


            $ClientVersion  = Get-Item -Path "$PJCM_Srv01\$DBName\ibms.exe"
            $ClientVersionNumber = $ClientVersion.VersionInfo.ProductVersion
        # Create a row 2
            $row = $table.NewRow()
        #Enter data in the row
            $row.Location = "$PJCM_Srv01\$DBName" 
            $row.'Size(MB)' = "{0:N2}" -f ($colItems_2.sum / 1MB)
            $row.Files = ($colItems_2.Count)
            $row.ClientVersion = $ClientVersionNumber
        #Add the row to the table
            $table.Rows.Add($row)
    
        #Display the table
            $table | Format-Table -AutoSize 
    #--- 

#4.0: Copy the new updated $DBName folder to xxPJCM502-xxPJCM507 Citrix Servers. It's using robocoy with mirroring option.
# PROD ODD Servers

    Write-Host "`nStep 4: Copy Client to ODD Number of Servers: `n" -ForegroundColor Cyan -BackgroundColor Blue
      
        foreach ($ServerName in $AGPJCM_List)
            {
                $ServerName = $ServerName.HostName
                $CopyTO = "\\$ServerName"+"$DestinationLocation"+"$DBName"
         
                Write-Host "Copying ""$DBName"" directory to: $ServerName" -ForegroundColor Yellow
                "FROM: "+"$PRD_Srv01"
                "To: " + $CopyTO + "`n"
                                                                                             
                Robocopy.exe "$PRD_Srv01\$DBName" "$CopyTO" /R:0 /W:0 /MT:16 /DCOPY:T /COPY:DAT /MIR /LOG+:$Log
                    
                    #----- Adding to Table Start ----
                            $colItems_3 = (Get-ChildItem -Path "\\$ServerName$DestinationLocation$DBName" -Recurse | Measure-Object -Property length -sum)
                        #Getting current Client VersionNumber
                            $ClientVersion  = Get-Item -Path "\\$ServerName$DestinationLocation$DBName\ibms.exe"
                            $ClientVersionNumber = $ClientVersion.VersionInfo.ProductVersion
                        #$ClientVersionNumber           
           
                        # Create a row
                            $row = $table.NewRow()
                        #Enter data in the row
                            $row.Location = "\\$ServerName$DestinationLocation$DBName" 
                            $row.'Size(MB)' = "{0:N2}" -f ($colItems_2.sum / 1MB)
                            $row.Files = ($colItems_3.Count)
                            $row.ClientVersion = $ClientVersionNumber
                        #Add the row to the table
                            $table.Rows.Add($row)
                    #----- Adding to Table END -----                
            }

    Write-Host """$DBName"" client has been updated on all ""ODD"" Citrix servers. `n" -ForegroundColor Green

# 5.0: Updating the Workflow and Task Server

    Write-Host "Step 5: Update Workflow and Task Servers:`n" -ForegroundColor Cyan -BackgroundColor Blue
    
        foreach ($MagicTaskServer in $MagicTaskServers)
            {
                $MagicTaskServer
                Write-Host "Working on: $MagicTaskServer `n" -ForegroundColor Green

                #5.1: Clear the logs on each server
                    
                    Write-Host "5.1. Clearing Application and Systems Logs on ""$MagicTaskServer""" -ForegroundColor Yellow `n
                        Clear-EventLog -LogName Application, System -ComputerName $MagicTaskServer
                
                        $ServiceHelperStatus = (Get-Service -ComputerName $MagicTaskServer -Name $ServiceHelper)
                        $ServiceTrackingStatus = (Get-Service -ComputerName $MagicTaskServer -Name $ServiceTracking)
                        #$ServiceHelperStatus | Format-Table -AutoSize
                        #$ServiceTrackingStatus | Format-Table -AutoSize
        
                        #-----
                        if ($ServiceHelperStatus.Status -ne 'Stopped' -or $ServiceTrackingStatus.Status -ne 'Stopped')
                            {
                                foreach ($ImgName in $ImgNames)
                                    {
                                        #5.1: Stopping $DBName services
                                        Write-Host "5.2: Killing $ImgName task" -ForegroundColor Cyan
                                        taskkill /S $MagicTaskServer /IM $ImgName /F
                                        "`n" #New Blank Line 
                                    }
                            }
                        #-----
                
                        #5.3            
                        Write-Host "5.3: Copying ""$DBName"" directory to: $MagicTaskServer" -ForegroundColor Yellow
                        $CopyTO = "\\$MagicTaskServer"+"$DestinationLocation"+"$DBName"
                        "FROM: "+"$PRD_Srv01"
                        "To: " + $CopyTO + "`n"
       
                        Robocopy.exe "$PRD_Srv01\$DBName" "$CopyTO" /R:0 /W:0 /MT:16 /DCOPY:T /COPY:DAT /MIR /LOG+:$Log
                        
                        #----- Adding to Table Start ----
                                $colItems_4 = (Get-ChildItem -Path "\\$MagicTaskServer$DestinationLocation$DBName" -Recurse | Measure-Object -Property length -sum)
                            #Getting current Client VersionNumber
                                $ClientVersion  = Get-Item -Path "\\$MagicTaskServer$DestinationLocation$DBName\ibms.exe"
                                $ClientVersionNumber = $ClientVersion.VersionInfo.ProductVersion
                            #$ClientVersionNumber           
           
                            # Create a row
                                $row = $table.NewRow()
                            #Enter data in the row
                                $row.Location = "\\$MagicTaskServer$DestinationLocation$DBName" 
                                $row.'Size(MB)' = "{0:N2}" -f ($colItems_4.sum / 1MB)
                                $row.Files = ($colItems_4.Count)
                                $row.ClientVersion = $ClientVersionNumber
                            #Add the row to the table
                                $table.Rows.Add($row)
                        #----- Adding to Table END -----
                        
                #6.0: COPY config to PROD SSO folder
      
                    $PRODSSO = "\\$MagicTaskServer"+"$DestinationLocation"+"PRODSSO"
                    #$PRODSSO
                    Write-Host "Step 6: Copy ""PilatApp.config"" to ""PRODSSO"":`n" -ForegroundColor Cyan -BackgroundColor Blue
                    Write-Host "6. Copying ""PilatApp.config"" to $PRODSSO `n" -ForegroundColor Cyan

                    Copy-Item -Path "$PRD_Srv01\$DBName\PilatApp.config" -Destination $PRODSSO -Force 

                #7.0: Modify the config file in PROD folder to have NON SSO settings
                    $config = "\\$MagicTaskServer$DestinationLocation$DBName\"+"PilatApp.config"
                    #$config
      
                    Write-Host "Step 7: Modify ""PilatApp.config"" for ""PROD"":`n" -ForegroundColor Cyan -BackgroundColor Blue
                    Write-Host "Modifying ""$config"" to have Non-SSO settings. `n" -ForegroundColor Yellow
      

                    $XML = [xml](Get-Content -Path $config)
      
                # 7.1: SSO authenticationType
                    $XML.configuration.ibmsSettings.security.authenticationType = "IBMSStandardAuthentication" 
                    Write-Host "7.1: authenticationType: " $XML.configuration.ibmsSettings.security.authenticationType -ForegroundColor Yellow `n

                # 7.2: SSO WebServerURL
                    $XML.configuration.ibmsSettings.security.webServiceUrl = "http://localhost:8080e.asmx"
                    Write-Host "7.2: webServiceUrl: " $XML.configuration.ibmsSettings.security.webServiceUrl -ForegroundColor Yellow `n
                    $XML.Save($config)
     
                #8.0: Starting the Helper and Tracking services
                    Write-Host "Step 8: Start Services:`n" -ForegroundColor Cyan -BackgroundColor Blue
                    Write-Host "8. Starting services, please wait....`n" -ForegroundColor Yellow
                        $ServiceHelperStatus.Refresh()
                        $ServiceHelperStatus.Start()
                        $ServiceHelperStatus.Refresh()
                        $ServiceHelperStatus | Format-Table -AutoSize
                        $ServiceTrackingStatus.Refresh()
                        $ServiceTrackingStatus | Format-Table -AutoSize

                    Write-Host "$DBName upgrade is done on $MagicTaskServer :`n" -ForegroundColor Green
            }

# Show Table
    $Table | Format-Table -AutoSize

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
            Write-Host "Elapsed Time: $ET  Minutes" -ForegroundColor Green
        }
            
    Write-Host "$DBName upgrade is done. Please run ""PROD_Client_702.ps1"" scriptr to update the EVEN servers:`n" -ForegroundColor Green

Stop-Transcript