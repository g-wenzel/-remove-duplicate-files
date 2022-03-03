# .SYNOPSIS
# find_and_remove_ducplicate_files.ps1 finds duplicate files based on hash values.
 
# .DESCRIPTION
# Prompts for entering file path. Shows duplicate files for selection. 
# Selected files will be removed 

# .EXAMPLE
# Open PowerShell. Nagivate to the file location. Type .\find_duplicate_files.ps1 OR
# Open PowerShell ISE. Open find_duplicate.ps1 and hit F5.
 
# .NOTES
# Author: Gregor Wenzel
# Based on script by Patrick Gruenauer | Microsoft MVP on PowerShell [2018-2020]
# Web: https://sid-500.com/2020/04/26/find-duplicate-files-with-powershell/

############# Find Duplicate Files based on Hash Value ###############
''
$filepath = Read-Host 'Enter file path for searching duplicate files (e.g. C:\Temp)'

If (Test-Path $filepath) {
    ''
    Write-Host 'Searching for duplicates ... Please wait ...'

    $all_duplicates = Get-ChildItem $filepath -File -Recurse `
    -ErrorAction SilentlyContinue | 
    Get-FileHash | 
    Group-Object -Property Hash |
    Where-Object Count -GT 1

    If ($all_duplicates.count -lt 1){
        Write-Host 'No duplicates found.'
        Break  ''
    }

    else {
        $keep = @()
        $remove = @()
        Write-Host "Duplicates found."
        foreach ($d in $all_duplicates)  { 
            $duplicates_file_level = $d.Group | Select-Object -Property Path, Hash,{$_.Path.Length} | Sort-Object -Property {$_.Path.Length}
            $keep += $duplicates_file_level | Select-Object -Index 0
            $remove += $duplicates_file_level | Select-Object -Skip 1
        } 

        $keep | Out-GridView -Title `
        "Files to keep" `

        $itemstoremove = $remove | Out-GridView -Title `
        "Files to remove: Select files (CTRL for multiple) and press OK." ` -PassThru

        If ($itemstoremove)    {
            Remove-Item $itemstoremove.Path 
            Write-Host `
            "Mission accomplished. Selected files removed"
        }

        else  {
            Write-Host "Operation aborted. No files selected."
        }
    }
}
else {
    Write-Host `
    "Folder not found. Use full path to directory e.g. C:\photos\patrick"
}