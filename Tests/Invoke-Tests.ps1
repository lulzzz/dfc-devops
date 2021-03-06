<#
.SYNOPSIS
Runner to invoke Acceptance, Quality and / or Unit tests

.DESCRIPTION
Test wrapper that invokes

.PARAMETER TestType
[Optional] The type of test that will be executed. The parameter value can be either All (default), Acceptance, Quality or Unit

.EXAMPLE
Invoke-AcceptanceTests.ps1 -Type ASM

.EXAMPLE
Invoke-AcceptanceTests.ps1 -Type ARM

#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory = $false)]
    [ValidateSet("All", "Acceptance", "Quality", "Unit")]
    [String] $TestType = "All"
)

$TestParameters = @{
    OutputFormat = 'NUnitXml'
    OutputFile   = "$PSScriptRoot\TEST-$TestType.xml"
    Script       = "$PSScriptRoot"
    PassThru     = $True
}
if ($TestType -ne 'All') {
    $TestParameters['Tag'] = $TestType
}

# --- Supress logging
$null = New-Item -Name SUPPRESSLOGGING -value $true -ItemType Variable -Path Env: -Force

# --- Invoke tests
$Result = Invoke-Pester @TestParameters

if ($Result.FailedCount -ne 0) { 
    Write-Error "Pester returned $($result.FailedCount) errors"
}