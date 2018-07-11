#Step 1;
#batch script 

 #   powershell.exe -file C:\Folder\Folder\Aadmin.ps1

#---------------
<#
    .SYNOPSIS
        Admin Options Script

    .DESCRIPTION
        This script will a list of options for the Admin to run.  Options are Button_1, Button_1

        Version History
        v1.0 -- Initial version
		
    .EXAMPLE
        The Admin will be able to exucte the Task Sequence(Button_1) or Seal the Image (Button_2)
        This is a sample/example of selection 

    .VERSION
        1.0

    .DATE MODIFIED (DD/MM/YYYY)
        02/07/2018
#>

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

Function function_1 {
    Write-Host "This is Function_1 section" -ForegroundColor Cyan
    #New-PSDrive -Name "MapEUWShare" -PSProvider FileSystem -Root "\\$env:EUWFileServer\$env:EUWFileShare" -Credential UserID
    #[System.Windows.Forms.MessageBox]::Show("This is MapDrive section")
    #Invoke-Expression Y:\myWorkspace\Documents\MyScripts\sample\script1_test.ps1
}

Function Button1_Pressed {
    $objForm.Close()
    function_1
    #Invoke-Expression MapEUWShare:\RBC\Launcher\Execute.ps1
    
    [System.Windows.Forms.MessageBox]::show("Button 1 Pressed")
    Invoke-Expression Y:\myWorkspace\Documents\MyScripts\sample\script1_test.ps1
    #[system.windows.forms.
    
}

Function Button2_Pressed {
    $objForm.Close()
    function_1
    #Invoke-Expression MapEUWShare:\Folder\Folder2\script.ps1
    # Write-Host "This is SealButtonPressed section" -ForegroundColor Green
    [System.Windows.Forms.MessageBox]::show("Button 2 Pressed")

    Invoke-Expression Y:\myWorkspace\Documents\MyScripts\sample\script2_test.ps1
   
}

Function ExitButtonPressed {
    $objForm.Close()
}

# Create and display main form
$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "What would you like to do?"

$Lable= New-Object System.Windows.Forms.Label
$Lable.Text = "Please slect your option.`n"
$Lable.AutoSize = $True
$objForm.Controls.Add($Lable)

$objForm.Size = New-Object System.Drawing.Size(300,400) # (Width,Height)
$objForm.ControlBox = $False
$objForm.FormBorderStyle = "Fixed3D"
$objForm.StartPosition = "CenterScreen"
$objForm.Topmost = $True

# Create and display Execute Task Sequence button #1
$RunTSButton = New-Object System.Windows.Forms.Button
$RunTSButton.Location = New-Object System.Drawing.Size(10,10)
$RunTSButton.Size = New-Object System.Drawing.Size(270,50)
$RunTSButton.Text = "Button 1"
$RunTSButton.Add_Click({Button1_Pressed})
$objForm.Controls.Add($RunTSButton)

# Create and display Seal Image button #2
$SealButton = New-Object System.Windows.Forms.Button
$SealButton.Location = New-Object System.Drawing.Size(10,70)
$SealButton.Size = New-Object System.Drawing.Size(270,50)
$SealButton.Text = "Button 2"
$SealButton.Add_Click({Button2_Pressed})
$objForm.Controls.Add($SealButton)

# Create and display Exit button
$ExitButton = New-Object System.Windows.Forms.Button
$ExitButton.Location = New-Object System.Drawing.Size(10,130)
$ExitButton.Size = New-Object System.Drawing.Size(270,50)
$ExitButton.Text = "Exit"
$ExitButton.Add_Click({ExitButtonPressed})
$objForm.Controls.Add($ExitButton)

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()
#$objForm.ShowDialog()
