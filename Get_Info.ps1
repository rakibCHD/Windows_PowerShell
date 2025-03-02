# Get Current Date and Time 
Write-Host "`nCurrent Date and Time: $(Get-Date)" -ForegroundColor Green

# Get Current Location (if Internet is available)
try {
    $location = Invoke-RestMethod -Uri "http://ip-api.com/json/" -ErrorAction Stop
    Write-Host "`nCurrent Location (Approximate):" -ForegroundColor Cyan
    Write-Host "Country: $($location.country)" -ForegroundColor Yellow
    Write-Host "Region: $($location.regionName)" -ForegroundColor Yellow
    Write-Host "City: $($location.city)" -ForegroundColor Yellow
    Write-Host "Latitude: $($location.lat), Longitude: $($location.lon)" -ForegroundColor Yellow
} catch {
    Write-Host "`nCould not retrieve location. No Internet connection or service unavailable." -ForegroundColor Red
}

# OS Information
Write-Host "`nOS Information:" -ForegroundColor Cyan
Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture | Format-List

# CPU Information
Write-Host "`nCPU Information:" -ForegroundColor Cyan
Get-CimInstance Win32_Processor | Select-Object Name, @{Name='MaxClockSpeed (MHz)'; Expression={$_.MaxClockSpeed}}, NumberOfCores | Format-List

# RAM Information
Write-Host "`nRAM Information:" -ForegroundColor Cyan
Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, @{Name='Capacity (Bytes)'; Expression={$_.Capacity}} | Format-List

# Disk Information
Write-Host "`nDisk Information:" -ForegroundColor Cyan
Get-CimInstance Win32_LogicalDisk | Select-Object DeviceID, VolumeName, @{Name='Size (Bytes)'; Expression={$_.Size}}, @{Name='FreeSpace (Bytes)'; Expression={$_.FreeSpace}} | Format-Table

# Network Information
Write-Host "`nNetwork Information:" -ForegroundColor Cyan
Get-NetIPAddress | Select-Object InterfaceAlias, AddressFamily, IPAddress | Format-Table

# COM Ports and USB Devices
Write-Host "`nCOM Ports and USB Devices:" -ForegroundColor Cyan
Get-WMIObject Win32_SerialPort | Select-Object DeviceID, Description | Format-Table
Get-PnpDevice -Class USB -Status OK | Select-Object Name, DeviceID | Format-Table

# Running Applications and Memory Consumption
Write-Host "`nRunning Applications and Memory Consumption:" -ForegroundColor Cyan
Get-Process | Select-Object Name, @{Name='Memory (MB)'; Expression={[math]::round($_.WorkingSet / 1MB, 2)}} | Sort-Object 'Memory (MB)' -Descending | Format-Table

# Prevent Window from Closing Automatically
Write-Host "`nPress any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
