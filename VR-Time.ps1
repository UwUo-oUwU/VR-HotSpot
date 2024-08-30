$wifiInterfaceName = "Wi-Fi Interface Name here, eg. Wi-Fi/WiFi/wifi"
# run "Get-NetAdapter" to get list of your interfaces, input the name left of the adapter name

$wifiProfile = "Your 5GHz Network Here"
# This is the 5GHz profile, to get list of profiles run "netsh wlan show profiles"

$wifiProfile2_4 = "Your 2.4GHz network Here"
# This is the 2.4GHz profile

$TaskName = "Your Task Name Here"
# Define Task Scheduler task name

# Setting Error Action Preference to Stop, so any error will stop the script execution
echo "Setting Error Action Preference to Stop..."
$ErrorActionPreference = "Stop"

# Getting Internet Connection Profile
echo "Getting Internet Connection Profile..."
$connectionProfile = [Windows.Networking.Connectivity.NetworkInformation, Windows.Networking.Connectivity, ContentType=WindowsRuntime]::GetInternetConnectionProfile()

# Creating Tethering Manager from Connection Profile
echo "Creating Tethering Manager from Connection Profile..."
$tetheringManager = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager, Windows.Networking.NetworkOperators, ContentType=WindowsRuntime]::CreateFromConnectionProfile($connectionProfile)

if ((netsh wlan show autoconfig | Select-String -CaseSensitive "disabled on interface `"$wifiInterfaceName`"")){
	echo "Checking if autoconfig is disabled on wifi interface..."
	
	# If autoconfig is disabled, enable it
	echo "Enabling autoconfig on wifi interface..."
    netsh wlan set autoconfig enabled=yes interface="$wifiInterfaceName"
	
	# If HotSpot is enabled, turn it off
	if ($tetheringManager.TetheringOperationalState -ne 'Off'){
		echo "Turning off HotSpot..."
		($tetheringManager.StopTetheringAsync()) > $null 
	}
	
	echo "Revert configuration complete! Press ENTER to exit..."
	read-host 
	exit
}

echo "Starting wifi configuration..."

# Enabling autoconfig on wifi interface
echo "Enabling autoconfig on wifi interface..."
netsh wlan set autoconfig enabled=yes interface="$wifiInterfaceName"

# Connecting to wifi
echo "Connecting to wifi profile: $wifiProfile..."
netsh wlan connect name="$wifiProfile" interface="$wifiInterfaceName"

echo "Waiting for connection..."

# Waiting for wifi connection
while(-not (netsh interface show interface | Select-String -CaseSensitive "Connected.+$wifiInterfaceName")){
    Start-Sleep -Seconds 1
	echo "Still waiting for connection..."
}

echo "Connected to wifi!"

# Starting Hotspot with half speed (client and hotspot simultaneously)
echo "Starting HotSpot with half speed (client and hotspot simultaneously)..."
($tetheringManager.StartTetheringAsync()) > $null  

echo "Waiting for HotSpot start..."

# Waiting for HotSpot start
while($tetheringManager.TetheringOperationalState -ne 'On'){
	echo "Still waiting for HotSpot to start..."
    Start-Sleep -Seconds 1	
}

echo "HotSpot started with half speed!"

# Disconnecting wifi
echo "Disconnecting wifi..."
($tetheringManager.StopTetheringAsync()) > $null 
netsh wlan disconnect interface="$wifiInterfaceName"

# Connecting to 2.4GHz profile if Ethernet is down
$ethernetStatus = (Get-NetAdapter | Where-Object {$_.Status -eq 'Down'}).Name
if ($ethernetStatus -ne $null) {
	echo "Connecting to wifi profile: $wifiProfile2_4..."
	netsh wlan connect name="$wifiProfile2_4" interface="$wifiInterfaceName"
}

# Starting Hotspot with full speed
echo "Starting HotSpot with full speed..."
($tetheringManager.StartTetheringAsync()) > $null

echo "Waiting for HotSpot start..."

# Waiting for HotSpot start
while($tetheringManager.TetheringOperationalState -ne 'On' ){
	echo "Still waiting for HotSpot to start..."
    Start-Sleep -Seconds 1	
}

echo "HotSpot started with full speed!"

# Disabling autoconfig on wifi interface
echo "Disabling autoconfig on wifi interface..."
netsh wlan set autoconfig enabled=no interface="$wifiInterfaceName"

# Starting Task Scheduler task
echo "Starting Task Scheduler task: $TaskName..."
Start-Process -FilePath "C:\Windows\System32\schtasks.exe" -ArgumentList "/run /tn ""$TaskName"""
echo "Complete, UwU! Run this script again to revert configuration."
read-host 
