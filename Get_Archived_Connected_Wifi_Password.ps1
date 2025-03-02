# Get all saved Wi-Fi profiles
$Networks = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {($_ -split ":")[-1].Trim()}

# Check if any profiles exist
if ($Networks) {
    Write-Host "`n🔍 Retrieving Wi-Fi Passwords..." -ForegroundColor Cyan

    # Loop through each network and extract the password
    foreach ($Network in $Networks) {
        $Password = netsh wlan show profile name="$Network" key=clear | Select-String "Key Content" | ForEach-Object {($_ -split ":")[-1].Trim()}

        if ($Password) {
            Write-Host "✅ Wi-Fi: $Network | Password: $Password" -ForegroundColor Green
        } else {
            Write-Host "❌ Wi-Fi: $Network | Password: [Not Found or Hidden]" -ForegroundColor Red
        }
    }
} else {
    Write-Host "❌ No saved Wi-Fi profiles found!" -ForegroundColor Yellow
}

# Prevents automatic closing of PowerShell window
Write-Host "`nPress any key to exit..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
