# private function
function Test-Environment {
    # this module supports only desktop edition
    Set-StrictMode -Version 2.0
    try {
        if ($PSVersionTable.PSEdition -eq "Desktop") {
            return $true
        }
        return $false
    }
    catch {
        # PS5.1 earlier(=Desktop Edition)
        return $true
    }
}
if (-not (Test-Environment)) {
    Write-Warning "[PSSushiBar]This environment is not supported."
    return
}
$Global:Timer = New-Object System.Timers.Timer
$Global:EventLocation = "Sushibar"
$Global:EventID = "_SushiBarTimer"
$Global:PrevTitle = ""
$Global:SushiCount = 0
$Global:CurrentSushiPosition = 0
$Global:SushiArray = (
    "🍣              ",
    "  🍣            ",
    "    🍣          ",
    "      🍣        ",
    "        🍣      ",
    "          🍣    ",
    "            🍣  ",
    "              🍣"
)

<#
.Synopsis
    Starting Sushibar rolling.
.EXAMPLE
    Start-SushiBar
.EXAMPLE
    Start-SushiBar -Interval 500
#>
function Start-SushiBar {
    [CmdletBinding()]
    param(
        [int]$Interval = 200 # msec
    )
    Set-StrictMode -Version 2.0
    if ($Global:Timer.Enabled) {
        Write-Warning "Sushi is already flowing!"
        return
    }

    # timer settings
    $Global:PrevTitle = $Host.ui.RawUI.WindowTitle
    $Global:Timer.Interval = if($Interval -lt 200){ 200 }else{ $Interval }

    # timer elapsed actio
    switch ($Host.Name) {
        "Windows PowerShell ISE Host" {
            # Can't get window size on PowerShell ISE 
            $Global:SushiCount = [Math]::Ceiling($Host.UI.RawUI.BufferSize.Width / 8)
        }
        Default {
            $Global:SushiCount = [Math]::Ceiling($Host.UI.RawUI.WindowSize.Width / 8)
        }
    }
    if ($Global:SushiCount -gt 63) {
        $Global:SushiCount = 63 # titlebar's max length is 1023
    }
    $Global:CurrentSushiPosition = 8
    $action = {
        if ($Global:CurrentSushiPosition -le 0) {
            $Global:CurrentSushiPosition = 8
            switch ($Host.Name) {
                "Windows PowerShell ISE Host" {
                    # Can't get window size on PowerShell ISE 
                    $Global:SushiCount = [Math]::Ceiling($Host.UI.RawUI.BufferSize.Width / 8)
                }
                Default {
                    $Global:SushiCount = [Math]::Ceiling($Host.UI.RawUI.WindowSize.Width / 8)
                }
            }
            if ($Global:SushiCount -gt 63) {
                $Global:SushiCount = 63 # titlebar's max length is 1023
            }
        }
        $Host.UI.RawUI.WindowTitle = $Global:SushiArray[$Global:CurrentSushiPosition - 1] * $Global:SushiCount
        $Global:CurrentSushiPosition -= 1
    }

    # register event and start timer
    $params = @{
        InputObject = $Global:Timer
        SourceIdentifier = $Global:EventID
        EventName = "Elapsed"
        Action = $action
    }
    Register-ObjectEvent @params | Out-Null
    $Global:Timer.start()
}

<#
.Synopsis
    Stop Sushibar rolling.
.EXAMPLE
    Start-SushiBar
#>
function Stop-SushiBar {
    [CmdletBinding()]
    param()
    if (-not $Global:Timer.Enabled) {
        Write-Warning "Sushi is not flowing."
        return
    }

    # stop timer and unregister event
    $Global:Timer.Stop()
    Unregister-Event $Global:EventID
    $Host.UI.RawUI.WindowTitle = $Global:PrevTitle
    $Global:PrevTitle = ""
}