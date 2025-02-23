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
    [ValidateNotNullOrEmpty()]
    [string]$LogName,

    [Parameter(Mandatory=$true, HelpMessage="Enter the hashtable with filtering parameters.")]
    [ValidateNotNullOrEmpty()]
    [hashtable]$FilterHashTable,

    [Parameter(Mandatory=$true, HelpMessage="Enter the output file path for the exported CSV file.")]
    [ValidateNotNullOrEmpty()]
    [string]$OutputFile
)

function Export-EventLogs {
    param (
        [string]$LogName,
        [hashtable]$FilterHashTable,
        [string]$OutputFile
    )

    try {
        Write-Verbose "Retrieving event logs for $LogName with filters $FilterHashTable"
        $Events = Get-WinEvent -FilterHashTable $FilterHashTable
        Write-Verbose "Exporting event logs to $OutputFile"
        $Events | Export-Csv -Path $OutputFile -NoTypeInformation

        Write-Information "Successfully exported $LogName event logs to $OutputFile" -InformationAction Continue
    }
    catch {
        Write-Error "An error occurred while exporting $LogName event logs: $_"
    }
}

# Main script execution
Export-EventLogs -LogName $LogName -FilterHashTable $FilterHashTable -OutputFile $OutputFile
