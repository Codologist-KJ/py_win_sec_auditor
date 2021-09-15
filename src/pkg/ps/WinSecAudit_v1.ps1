#Clear-Host
#RECORDING TRANSCRIPT TO DUMP FILE
$CurrentDir = $PSScriptRoot
$SystemName = $env:computername
$DumpFilePath = "$CurrentDir\"+$SystemName+"-CONFIG_DUMP_$(get-date -Format yyyymmdd_hhmmtt).txt"

Start-Transcript -Path $DumpFilePath -NoClobber #-UseMinimalHeader

#Checking if your PowerShell Script Execution Policy
Write-Host
Write-Host 'Checking if your PowerShell Script Execution Policy is set to RemoteSigned' -ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -s 5
Write-Host
$ExecutionPolicy = Get-ExecutionPolicy
$ScriptExecution = "RemoteSigned"
    If ($ExecutionPolicy -eq $ScriptExecution) 
        {
            Write-Host 'Yes! your PowerShell Script Execution Policy is already set to' $ExecutionPolicy -ForegroundColor Red -BackgroundColor Black
        }
    Else
        {
            Write-Host Your PowerShell Script Execution Policy is set to $ExecutionPolicy -ForegroundColor Yellow -BackgroundColor Black
            Write-Host
            Write-Host 'This policy should be set to RemoteSigned for the script to execute properly.' -ForegroundColor Magenta -BackgroundColor Black
            Write-Host
            Write-Host 'This change will be reverted back to its original state after script execution is complete.' -ForegroundColor Magenta -BackgroundColor Black
            Write-Host
            Write-Host Setting PowerShell Script Execution Policy to $ScriptExecution automatically. Please Wait...
            Start-Sleep -s 5
            
            Set-ExecutionPolicy RemoteSigned -force
        
            Write-Host
            Write-Host PowerShell Script Execution Policy is now set to $ScriptExecution. -ForegroundColor Yellow -BackgroundColor Black
            Start-Sleep -s 5
        }

#--------------

#Begin Windows Security Auditing Code
"`n"
$Today = Get-Date

        Write-Host Today is $Today -ForegroundColor Blue -BackgroundColor Black
        Write-Host


#Retrieve Application Event Logs

Write-Host '********** Begin Application Event Logs **********'
Write-Host

$AppQuery = '<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(Level=1  or Level=2 or Level=3) and TimeCreated[timediff(@SystemTime) &lt;= 604800000]]]</Select>
  </Query>
</QueryList>'

Get-WinEvent -FilterXML $AppQuery | Select-Object TimeCreated, ID, ProviderName, LevelDisplayName, Message | Format-Table -AutoSize

Write-Host '********** End Application Event Logs **********'
Write-Host

#Retrieve Security Event Logs
Write-Host '********** Begin Security Event Logs **********'
Write-Host

$SecQuery = '<QueryList>
<Query Id="0" Path="Security">
  <Select Path="Security">*[System[(Level=1  or Level=2 or Level=3 or Level=4 or Level=0) and (band(Keywords,13510798882111488)) and 
  (EventID=1102 or EventID=4624 or EventID=4625 or EventID=4635 or EventID=4648 or EventID=4675 or EventID=4719 or EventID=4964 or EventID=4720 or EventID=4722 or EventID=4723 or EventID=4725) and 
  TimeCreated[timediff(@SystemTime) &lt;= 604800000]]]</Select>
</Query>
</QueryList>'

Get-WinEvent -FilterXML $SecQuery | Select-Object TimeCreated, ID, ProviderName, LevelDisplayName, Message | Format-Table -AutoSize

Write-Host '********** End Security Event Logs **********'
Write-Host

#Retrieve System Event Logs
Write-Host '********** Begin System Event Logs **********'
Write-Host

$SysQuery = '<QueryList>
  <Query Id="0" Path="System">
  <Select Path="System">*[System[(Level=1  or Level=2 or Level=3) and TimeCreated[timediff(@SystemTime) &lt;= 604800000]]]</Select>
</Query>
</QueryList>'

Get-WinEvent -FilterXML $SysQuery | Select-Object TimeCreated, ID, ProviderName, LevelDisplayName, Message | Format-Table -AutoSize

Write-Host '********** End System Event Logs **********'
Write-Host

#End - Windows Security Auditing Code

#--------------

Write-Host
Write-Host Script execution complete. Please Wait... -ForegroundColor Yellow -BackgroundColor Black
Write-Host
Start-Sleep -s 5
Write-Host Reverting the PowerShell script execution policy to $ExecutionPolicy, 'if it was not already set by default' -ForegroundColor Red -BackgroundColor Black
    
    Start-Sleep -s 5
    Set-ExecutionPolicy $ExecutionPolicy -force

Write-Host
Write-Host The PowerShell Script Execution Policy setting has been reverted back to $ExecutionPolicy -ForegroundColor Yellow -BackgroundColor Black
Write-Host 
Write-Host All done. Have a good day. -ForegroundColor Blue -BackgroundColor Black
Write-Host

#STOP RECORDING TRANSCRIPT
Stop-Transcript