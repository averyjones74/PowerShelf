
PowerShelf - PowerShell Scripts
===============================

This is a set of PowerShell scripts for various tasks.
They are designed and tested for PowerShell v2 and v3.

## Script List

* *Add-Debugger.ps1* - Adds a simple debugger to PowerShell.
* *Add-Path.ps1* - Adds a directory to an environment path variable once.
* *Debug-Error.ps1* - Enables debugging on terminating errors.
* *Export-Binary.ps1* - Exports objects using binary serialization.
* *Format-Chart.ps1* - Formats output as a table with the last chart column.
* *Format-High.ps1* - Formats output by columns with optional custom item colors.
* *Import-Binary.ps1* - Imports objects using binary serialization.
* *Invoke-Environment.ps1* - Invokes a command and imports its environment variables.
* *Measure-Command2.ps1* - Measure-Command with several iterations and progress.
* *Measure-Property.ps1* -  Counts properties grouped by names and types.
* *Set-ConsoleSize.ps1* - Sets the current console size, interactively by default.
* *Show-Color.ps1* - Shows all color combinations, color names and codes.
* *Submit-Gist.ps1* - Submits a file to its GitHub gist repository.
* *Test-Debugger.ps1* - Tests PowerShell debugging with breakpoints.
* *Watch-Command.ps1* - Invokes a command repeatedly and shows its one screen output.

The directory *Demo* contains demo scripts and tests invoked by [*Invoke-Build.ps1*](https://github.com/nightroman/Invoke-Build).

## Get Scripts

The scripts can be downloaded as the archive *PowerShelf.zip* to the current
process directory by this PowerShell command:

    (New-Object Net.WebClient).DownloadFile("https://github.com/nightroman/PowerShelf/zipball/master", "PowerShelf.zip")
