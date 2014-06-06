
This directory contains test and demo scripts. Scripts `*.test.ps1` are invoked
by [Invoke-Build](https://github.com/nightroman/Invoke-Build).

Example PowerShell commands

- If *Invoke-Build.ps1* is not in the path then specify its path in the commands.
- Set this directory current (`Set-Location ...`).

Invoke all tests in all test scripts here:

    Invoke-Build **

Invoke all tests in *Assert-SameFile.test.ps1*:

    Invoke-Build * Assert-SameFile.test.ps1

Invoke the test *MissingSample* in *Assert-SameFile.test.ps1*:

    Invoke-Build MissingSample Assert-SameFile.test.ps1
