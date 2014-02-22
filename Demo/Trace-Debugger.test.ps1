
<#
.Synopsis
	Trace-Debugger.ps1 tests.
#>

$v3 = $PSVersionTable.PSVersion.Major -eq 3

task Invalid {
	$e = try {Trace-Debugger.ps1 -Path ''} catch {$_}
	assert ($e -like "*Cannot bind argument to parameter 'Path' because it is an empty string.")

	$e = try {Trace-Debugger.ps1 -Table ''} catch {$_}
	assert ($e -like "*Cannot bind argument to parameter 'Table' because it is an empty string.")
}

task HelpExample {
	# enable tracing, use Test-Debugger as the trigger command
	Trace-Debugger Test-Debugger

	# invoke with tracing
	Test-Debugger
	Test-Debugger

	# stop tracing
	Restore-Debugger
}

task OutputToFile {
	$log = "$env:TEMP\trace.log"
	if (Test-Path -LiteralPath $log) {Remove-Item -LiteralPath $log}

	Trace-Debugger Test-Debugger -Path $log
	Test-Debugger
	Test-Debugger
	Restore-Debugger

	# end
	Remove-Item -LiteralPath $log
}

task CodeCoverageWithFilter -If $v3 {
	Trace-Debugger Invoke-Build -Table Coverage -Filter {$ScriptName -like '*\Add-Path.*'}
	Invoke-Build * Add-Path.test.ps1
	Restore-Debugger

	$Coverage
	assert ($Coverage.Count -eq 2)
	$files = $Coverage.Keys | Sort-Object {[IO.Path]::GetFileName($_)}

	($file = $files[0])
	$Coverage[$file]
	assert ([IO.Path]::GetFileName($file) -eq 'Add-Path.ps1')
	assert ($Coverage[$file].Count -eq 7)

	($file = $files[1])
	$Coverage[$file]
	assert ([IO.Path]::GetFileName($file) -eq 'Add-Path.test.ps1')
	assert ($Coverage[$file].Count -eq 34)
}
