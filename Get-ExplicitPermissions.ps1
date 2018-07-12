<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.118
	 Created on:   	4/5/2016 4:43 PM
	 Created by:   	Zack
	 Organization: 	Convention Data Services
	 Filename:      Get-ExplicitPermissions.ps1	
	===========================================================================
	.DESCRIPTION
		This script will itterate through all directoried in the $root variable
		It will return folders that have explicitly defined permissions
		It will return what user objects have explicit permissions defined 
#>


#Define Global Scope Variables
$Root = (Read-Host -Prompt "Type the path to search within")
Write-Verbose '*************************The content of $Root is:*************************' # -Verbose
# $Root

$Folders = Get-ChildItem -Recurse -Directory -Path $Root | select -ExpandProperty fullname
Write-Verbose '*************************The content of $Folders is:*************************' # -Verbose
# $Folders

$outfile = "$Root`ExplicitACLs.txt"
Write-Verbose "*************************The ExplicitACLs.txt folder will be saved to: *************************"  # -Verbose
# $outfile

<#
Time to do work:
#>

# Iterate through each folder in the $root variable
foreach ($Folder in $Folders)
{
	#Define variables limited to the foreach loop iteration
	$acl = Get-Acl -Path $Folder 									# Get the acl list on each folder
	$access = $acl.access 											# Get each individual access right from the ACL list
	IF ($access | Where-Object { $_.IsInherited -eq $False })		# Check to see if the ACL entry is inherited or explicit
	{
		Add-Content -Path $outfile $Folder							# Append the folder name to the output file
		$access | Where-Object { $_.IsInherited -eq $False } |		# Filter each ACL list value and return only explicit permissions (inherited permissions filtered)
		ForEach-Object {											# Iterate through the filtered ACL list working against only explicit permissions
			Add-Content -Path $outfile $_.IdentityReference 		# Output the ID/Name of each user object with explicit permission entry into the output file
			Add-Content -Path $outfile $_.FileSystemRights			# Output the FileSystem permission for each user object.
		}
		Add-Content -Path $outfile ""								# Add a line break to the output file
		Clear-Variable acl											# Clear the ACL variable defined for this iteration in the loop
		Clear-Variable access										# Clear the access variable defined for this iteration in the loop
	}
}
