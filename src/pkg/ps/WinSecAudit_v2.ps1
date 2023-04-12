<#
.SYNOPSIS
    A script to efficiently check and process Windows system event log files.

.DESCRIPTION
    This script retrieves specified Windows event logs, filters them based on the provided parameters, and exports the results to a CSV file.

.PARAMETER LogName
    The name of the Windows Event Log to be processed (e.g., System, Application, Security).

.PARAMETER FilterHashTable
    A hashtable containing the filtering parameters for the event logs.

.PARAMETER OutputFile
    The output file path for the exported CSV file.

.EXAMPLE
    .\WinSecAudit_v2.ps1 -LogName "System" -FilterHashTable @{Logname='System'; StartTime='2023-04-01'; EndTime='2023-04-12'; Level=2} -OutputFile "SystemEvents.csv"
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, HelpMessage="Enter the Windows Event Log name to be processed.")]
    [string]$LogName,

    [Parameter(Mandatory=$true, HelpMessage="Enter the hashtable with filtering parameters.")]
    [hashtable]$FilterHashTable,

    [Parameter(Mandatory=$true, HelpMessage="Enter the output file path for the exported CSV file.")]
    [string]$OutputFile
)

function Export-EventLogs {
    param (
        [string]$LogName,
        [hashtable]$FilterHashTable,
        [string]$OutputFile
    )

    try {
        $Events = Get-WinEvent -FilterHashTable $FilterHashTable
        $Events | Export-Csv -Path $OutputFile -NoTypeInformation

        Write-Host "Successfully exported $LogName event logs to $OutputFile" -ForegroundColor Green
    }
    catch {
        Write-Host "An error occurred while exporting $LogName event logs: $_" -ForegroundColor Red
    }
}

# Main script execution
Export-EventLogs -LogName $LogName -FilterHashTable $FilterHashTable -OutputFile $OutputFile
