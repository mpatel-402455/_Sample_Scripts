<#
    Code Placement for Enums
    When writing the code, place the enum definition outside the class definition or in its own file. I placed this Size enum in a file named C:\PowerShell\SizeEnum.ps1. That way, I can dot-source the enum. Why would I want to do this? If I place the enum in its own file, I can dot-source it for any class or function. That is right, enums are not just for PowerShell classes. I can use it to define custom types for functions as well, as shown in the function below.
#>

# https://www.petri.com/powershell-classes-part-3-using-methods#
# https://www.petri.com/powershell-classes-part-2-enumerated-types

enum Size {
    Small
    Medium
    Large
    }

class Rock {
    [string]$Color
    [string]$Luster
    [string]$Shape
    [string]$Texture
    [string]$Pattern
    [Size]$Size   #<<<<<<<< Name is Size
    [int]$Location 
    }

    $Rock = [rock]::New()
$Rock.Color = "Silver"
$Rock.Size = "Small"