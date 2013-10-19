
<#
.Synopsis
	Format-Chart.ps1 tests.

.Notes
	# Custom bar character for shadow effects
	Get-Process | Format-Chart Name, WS -Bar ([char]9600) -Space ([char]9617)
#>

Set-StrictMode -Version 2

task MissingParameterProperty {
	$ErrorActionPreference = $err = 'Continue'
	try {
		Format-Chart
	}
	catch { $err = $_ | Out-String }
	$err
	assert ($err -like '*\Format-Chart.ps1 : Missing parameter Property.*\Format-Chart.test.ps1:*')
}

task UnknownArguments {
	$ErrorActionPreference = $err = 'Continue'
	try {
		Format-Chart Name -Unknown foo
	}
	catch { $err = $_ | Out-String }
	$err
	assert ($err -like '*\Format-Chart.ps1 : Unknown arguments: -Unknown foo*\Format-Chart.test.ps1:*')
}

task NumericValues {
	$ErrorActionPreference = $err = 'Continue'

	# in V3 null and strings make issues; V2 is less strict
	if ($PSVersionTable.PSVersion.Major -ge 3) {
		$NonNumeric = $(
			New-Object PSObject -Property @{Name='name1'; Data=3}
			New-Object PSObject -Property @{Name='name2'; Data='b'}
		)
	}
	else {
		$NonNumeric = $(
			New-Object PSObject -Property @{Name='name1'; Data='a'}
			New-Object PSObject -Property @{Name='name2'; Data='b'}
		)
	}

	try {
		$NonNumeric | Format-Chart Name, Data
	}
	catch { $err = $_ | Out-String }
	$err
	assert ($err -like "*\Format-Chart.ps1 : Property 'Data' should have numeric values.*\Format-Chart.test.ps1:*")
}

task InvalidMinimumMaximum {
	$ErrorActionPreference = $err = 'Continue'
	try {
		Get-Process PowerShell | Format-Chart Name, WS -Minimum 1gb
	}
	catch { $err = $_ | Out-String }
	$err
	assert ($err -like "*\Format-Chart.ps1 : Invalid Minimum and Maximum: *, *.*\Format-Chart.test.ps1:*")
}

task NoData {
	$io = @()
	$res = $io | Format-Chart Data
	assert ($null -eq $res)
	$res = Format-Chart Data -InputObject $io
	assert ($null -eq $res)

	$io = $null
	$res = $io | Format-Chart Data
	assert ($null -eq $res)
	$res = Format-Chart Data -InputObject $io
	assert ($null -eq $res)
}

function Trim
{
	$(foreach($_ in $Input) {if ($_ = $_.TrimEnd()) {$_}}) -join "`r`n"
}

$Input2 = $(
	New-Object PSObject -Property @{Name='name1'; Data=3}
	New-Object PSObject -Property @{Name='name2'; Data=9}
	New-Object PSObject -Property @{Name='name3'; Data=$null}
	New-Object PSObject -Property @{Name='name4'}
	$null
	1
)

task Input2Default {
	$res = $Input2 | Format-Chart Name, Data -Width 9 -BarChar * -SpaceChar . | Out-String -Stream | Trim
	$res
	assert ($res -eq @'
Name  Data Chart
----  ---- -----
name1    3 .........
name2    9 *********
'@)
}

task Param2Default {
	$res = Format-Chart Name, Data -Width 9 -BarChar * -SpaceChar . -InputObject $Input2 | Out-String -Stream | Trim
	$res
	assert ($res -eq @'
Name  Data Chart
----  ---- -----
name1    3 .........
name2    9 *********
'@)
}

task Input2Minimum {
	$res = $Input2 | Format-Chart Name, Data -Width 9 -BarChar * -SpaceChar . -Minimum 0 | Out-String -Stream | Trim
	$res
	assert ($res -eq @'
Name  Data Chart
----  ---- -----
name1    3 ***......
name2    9 *********
'@)
}

task Input2Logarithmic {
	$res = $Input2 | Format-Chart Name, Data -Width 9 -BarChar * -SpaceChar . -Minimum 0 -Logarithmic | Out-String -Stream | Trim
	$res
	assert ($res -eq @'
Name  Data Chart
----  ---- -----
name1    3 *****....
name2    9 *********
'@)
}
