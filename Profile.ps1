# study stream pomodoro timer for Windows

$pomoOptions = @{
    "work"  = 45
    "break" = 10
}

function Start-Pomodoro {
    param(
        [string]$SessionType,
        [int]$Minutes = 0
    )
    
    # Use custom minutes if provided, otherwise use default
    if ($Minutes -eq 0) {
        if ($pomoOptions.ContainsKey($SessionType)) {
            $Minutes = $pomoOptions[$SessionType]
        }
        else {
            Write-Host "Unknown session type: $SessionType" -ForegroundColor Red
            return
        }
    }
    
    # Colorful output (similar to lolcat)
    Write-Host "$SessionType ($Minutes minutes)" -ForegroundColor Magenta
    
    # Countdown timer
    $seconds = $Minutes * 60
    while ($seconds -gt 0) {
        $timeSpan = [TimeSpan]::FromSeconds($seconds)
        Write-Host "`r$($timeSpan.ToString('mm\:ss')) remaining..." -NoNewline
        Start-Sleep -Seconds 1
        $seconds--
    }
    Write-Host "`rDone!                    "
    
    # Text-to-speech notification
    Add-Type -AssemblyName System.Speech
    $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $synth.Speak("$SessionType session done")
}

# Functions with optional time parameter
function wo { 
    param([int]$Minutes = 0)
    Start-Pomodoro "work" $Minutes 
}

function br { 
    param([int]$Minutes = 0)
    Start-Pomodoro "break" $Minutes 
}
