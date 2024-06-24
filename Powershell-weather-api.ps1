Import-Module BurntToast # (Install-Module -Name BurntToast) nicht vergessen
do {
    $user = (Get-WmiObject -Class Win32_ComputerSystem).UserName
    if ($user -ne "") {
        if (-not($user -eq "Studio2Eloi\eloik")) {exit}   ## $user überprüft obe se mein acount is account 
    } else {
        Start-Sleep -Seconds 5
    }
} while ($null -eq $user)
$counterOfRepetition = 0;
do {
    $connectedAdapter = Test-Connection -ComputerName google.com -Count 1 -Quiet
    $counterOfRepetition++
    if (!$connectedAdapter) {
        Start-Sleep -Seconds 5
    }
} while (!$connectedAdapter -and ($counterOfRepetition -lt 10))
if ($connectedAdapter -and $counterOfRepetition -lt 10) {
    $apiUrl = "https://api.open-meteo.com/v1/forecast?latitude=47.3925&longitude=8.0442&current=temperature_2m,rain&forecast_days=1"
# try wurde mit Chat GPT um zu verhindern dass $response nicht $null ist und dadurch das program nicht funktioniert.
    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method Get
        
        if ( $null -ne $response) {
            $temperature_2m = $response.current.temperature_2m
            $imagePath = "C:\Users\eloik\Powershell\sun-8553511_1280.jpg"
            New-BurntToastNotification -Text "Heute ist es : $($temperature_2m)C" -AppLogo $imagePath
        } else {
            $imagePath = "C:\Users\eloik\Powershell\sun-8553511_1280.jpg"
            New-BurntToastNotification -Text "Leider keine API Verbindung" -AppLogo $imagePath
        }
    } catch {
        $imagePath = "C:\Users\eloik\Powershell\sun-8553511_1280.jpg"
        New-BurntToastNotification -Text "Leider gabe es ein Problem" -AppLogo $imagePath
    }
}