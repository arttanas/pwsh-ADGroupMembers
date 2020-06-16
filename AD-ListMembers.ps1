
#PowerShell AD Group Member query
#By @Arttanas


# Used to check members of groups.
# Script requires RSAT tools. 

#This brings up the file explorer so you can select your list of groups. 
#You can also add the file directly to the PowerShell line, and it'll skip the explorer window.


if ($args.count -gt 0){
    $fp = $args[0]
}
else {
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        InitialDirectory = [Environment]::GetFolderPath("Desktop") } 
    $null = $FileBrowser.ShowDialog()
    $fp = $FileBrowser.FileName
}

$data = Get-Content -Path $fp 

#Server Request
$server = Read-Host -Prompt "Enter your Active Directory server"

#Credentials are needed for accessing the AD server.
Write-Host "Requesting credentials..."

$cred=Get-Credential

foreach ($role in $data) 
{
    Write-Host "Querying $role..."
    Get-ADGroupMember -Credential $cred -Server "$server" -Identity "$role" | 
    Get-ADUser -Properties Mail | Select-Object Name,Mail | 
    Export-Csv -Append -Path "$env:USERPROFILE\Desktop\ADGroups.csv"
}
