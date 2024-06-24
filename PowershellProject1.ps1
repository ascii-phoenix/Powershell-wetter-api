
<# 
.SYNOPSIS
    My code Gets the temperatur from a api and displays it with a notifacation
.DESCRIPTION 
    My code checks if there is a specific user. 
    After that, it checks if there is an internet connection with Google. 
    If it succeeds, it makes an API call that gives me the temperature from a JSON file, which I display as a notification. 
    If it fails 10 times, it gives a notification that there is no connection. If the API fails, there will be an error message.
.NOTES 
Author: Eloi Knecht
    Build-version: 1.2
    Last updated : 2023-06-24
    Download BurntToast
    Header template was copied from scriptrunner.com
    Build in PS1-version 5.1.22621.3672
.COMPONENT 
   Please downlode BurntToast and change the Usersting in the 42 line to yours.
.LINK 
https://github.com/Windos/BurntToast.
https://open-meteo.com/
https://www.scriptrunner.com/en/blog/powershell-script-header-parameters-in-scriptrunner/
.Parameter user 
 is the user
.Parameter connectedAdapter
 is a bool that checks that tere is a conection
.Parameter counterOfRepetition
Counts how many trys there where to connect with google
.Parameter apiUrl
 is a string of my API-URL
.Parameter response
 it is the API respons as a json file
.Parameter temperature_2m
 is the temperture as a numbre
.Parameter imagePath
 is the image used in my nodification
#>
Import-Module BurntToast # (Install-Module -Name BurntToast) do not forget to downlode "BurntToast".
do {# Checks who is the user
    $user = (Get-WmiObject -Class Win32_ComputerSystem).UserName
    if ($user -ne "") {
        if (-not($user -eq "Studio2Eloi\eloik")) {exit}   
    } else {
        Start-Sleep -Seconds 5
    }
} while ($null -eq $user)
$counterOfRepetition = 0;
do { #Checks if there is a connection to google.com (only 10 trys)
    $connectedAdapter = Test-Connection -ComputerName google.com -Count 1 -Quiet
    $counterOfRepetition++
    if (!$connectedAdapter) {
        Start-Sleep -Seconds 5
    }
} while (!$connectedAdapter -and ($counterOfRepetition -lt 10))
if ($connectedAdapter -and $counterOfRepetition -lt 10) {
    $apiUrl = "https://api.open-meteo.com/v1/forecast?latitude=47.3925&longitude=8.0442&current=temperature_2m,rain&forecast_days=1"
# try was created with Chat GPT to prevent that $response is not $null and that the programm does not crash.
    try {# Try to make an api-call
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get
        
        if ( $null -ne $response) {# cheks if there is an answer
            $temperature_2m = $response.current.temperature_2m
            $imagePath = "C:\Users\eloik\Powershell\sun-8553511_1280.jpg"
            New-BurntToastNotification -Text "Heute ist es : $($temperature_2m)C" -AppLogo $imagePath
        } else {
            $imagePath = "C:\Users\eloik\Powershell\sun-8553511_1280.jpg"
            New-BurntToastNotification -Text "Leider keine API Verbindung" -AppLogo $imagePath
        }
    } catch {# if there is a Error
        $imagePath = "C:\Users\eloik\Powershell\sun-8553511_1280.jpg"
        New-BurntToastNotification -Text "Leider gabe es ein Problem" -AppLogo $imagePath
    }
} else {
    $imagePath = "C:\Users\eloik\Powershell\sun-8553511_1280.jpg"
    New-BurntToastNotification -Text "Leider keine API Verbindung" -AppLogo $imagePath
}