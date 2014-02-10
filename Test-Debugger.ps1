
<#
.Synopsis
	Tests PowerShell debugging with breakpoints.
	Author: Roman Kuzmin

.Description
	This scripts helps to get familiar with all kinds of breakpoints, i.e.
	command, variable (reading, writing, reading and writing), and custom
	actions. It is also used for testing of debuggers (Add-Debugger.ps1).

	On the first run the script sets some breakpoints in itself. Run it again
	in order to see how the debugger works when breakpoints are hit. In order
	to remove test breakpoints invoke Test-Debugger.ps1 -RemoveBreakpoints.

	With built-in debuggers it is ready to use, e.g. in
	- ConsoleHost
	- FarHost
	- Windows PowerShell ISE Host

	Use it with a custom debugger (Add-Debugger.ps1) in
	- Default Host
	- Package Manager Host

.Parameter RemoveBreakpoints
		Tells to remove breakpoints set for this script.

.Link
	https://github.com/nightroman/PowerShelf
#>

param(
	[Parameter()]
	[switch]$RemoveBreakpoints
)

# this script path
$script = $MyInvocation.MyCommand.Definition

# get its breakpoints
$breakpoints = Get-PSBreakpoint | Where-Object { $_.Script -eq $script }

### remove breakpoints and exit
if ($RemoveBreakpoints) {
	$breakpoints | Remove-PSBreakpoint
	Write-Host "Removed $($breakpoints.Count) breakpoints."
	return
}

### set breakpoints and exit
if (!$breakpoints) {
	# command breakpoint, e.g. function TestFunction1
	$null = Set-PSBreakpoint -Script $script -Command TestFunction1

	# variable breakpoint on reading
	$null = Set-PSBreakpoint -Script $script -Variable varRead -Mode Read

	# variable breakpoint on writing
	$null = Set-PSBreakpoint -Script $script -Variable varWrite -Mode Write

	# variable breakpoint on reading and writing
	$null = Set-PSBreakpoint -Script $script -Variable varReadWrite -Mode ReadWrite

	# special breakpoint with action without breaking (for logging, diagnostics and etc.)
	# NOTE: mind infinite recursion (stack overflow) if the action accesses the same variables
	$null = Set-PSBreakpoint -Script $script -Variable 'varRead', 'varWrite', 'varReadWrite' -Mode ReadWrite -Action {
		++$script:VarAccessCount
	}

	Write-Host @'

Test breakpoints have been set.
Invoke the script again to test.

'@
	return
}

### proceed with existing breakpoints

# will be counted by the breakpoint action
$script:VarAccessCount = 0

# a command breakpoint is set for this function
function TestFunction1 {
	TestFunction2 42 text @{data=3.14} # try to step into, over, out
	$_ = 1 # dummy
}

# function to test stepping into from TestFunction1
function TestFunction2 { # you have stepped into TestFunction2
	param($int, $text, $data)
	$_ = 1 # dummy
}

# test a command breakpoint
TestFunction1 # in v2 it stops at this line, in v3 at `function TestFunction1 {`

# to change the variable in debugger
[int]$toWrite = 0 # change me after
if ($toWrite -le 0) {
	Write-Host "Nothing to write."
}
else {
	Write-Host "Writing"
	1..$toWrite
}

# steps in one line
if ($true) { $_ = 1 } # step through the pieces of command

$varRead = 1 # no break
$_ = $varRead # break on reading

$varWrite = 2 # break on writing
$_ = $varWrite # no break

$varReadWrite = 3 # break on writing
$_ = $varReadWrite # break on reading

# counter value is calculated by the breakpoint action
Write-Host @"

Testing completed.
Watched variables have been accessed $($script:VarAccessCount) times.

"@
