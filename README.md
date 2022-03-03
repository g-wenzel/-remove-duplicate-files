# remove-duplicate-files
Powershell script to remove duplicate files. 
Primarily aimed at cluttered windows shares, that may develop in teams over the course of several years. If there are no extremely valuable data but thousands of files, usually no manual review of the files and folder structures is required or reasonable. Therefore files with the shortest path are kept by default.

The script is intended to be used in a corporate environment, where you may be not permitted to install software but you may be allowed to run a shell script.
The script searches for duplicate files basd on file hashes and suggests files to delete.

Based on https://sid-500.com/2020/04/26/find-duplicate-files-with-powershell/
