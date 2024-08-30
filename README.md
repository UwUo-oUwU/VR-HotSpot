High-Speed Hotspot for VR
=====================================

This is a fork of a workaround script to enable high-speed hotspot for VR applications. 
This fork is a modified version of the original to have a 2.4GHz fallback for internet connectivity if you do not have an Ethernet connection, while functioning normally if hardwired while adding an extra optional functionality.

### Introduction

This PowerShell script will connect to a specified 5GHz network, start the hotspot, and then disconnect from it before connecting to a specified 2.4GHz network if Ethernet is down.

Additionally, this script will also automate the launching of a user-created Task Scheduler task, which can be used to launch VR applications like Pimax Play, PICO Connect, Virtual Desktop, Meta Quest Link, ALVR, or RiftCat/VRidge.

**Important:** To use this script, you need to update these variables in the code:

* `"Wi-Fi Interface Name here, eg. Wi-Fi/WiFi/wifi"`: This should be set to your Wi-Fi interface name (e.g. "Wi-Fi"). You can find this by running `Get-NetAdapter` in PowerShell.

* `"Your 5GHz Network Here"` and `"Your 2.4GHz network Here"`: These should be set to the names of your 5GHz and 2.4GHz network profiles you have respectively.

* `"Your Task Name Here"`: This will be the task name you create that will be launched if you assign one by using the instructions below; this field is optional.

### Making a Shortcut

How to create a shortcut for easy VR launching:

1. Right-click on your desktop and click **New > Shortcut**
2. In the **Location** field, copy & paste: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File`
3. Navigate to where you saved the PowerShell script after downloading, (e.g., `C:\Users\YourUsername\Documents\VR\VR-Time.ps1`)
4. Right-click on the PowerShell script and click **Copy as path**.
5. Return to the "Create Shortcut" window and click in the **Location** field, make sure you have a space after -File.
6. Right-click inside the field and click **Paste**, including the quotes (e.g., `"C:\Users\YourUsername\Desktop\VR-Time.ps1"`) after -File with a space after it.
7. Click **Next**, then give it a name (e.g., "VR Time")
8. You can now drag this shortcut to your Start menu or taskbar for quick access.

### How to change these variables

If you're not familiar with scripts, don't worry! Changing these variables is easy & are at the top of the script. Here's how:

1. After placing VR-Time.ps1 where you plan to keep it & having made the shortcut, click it once & right-click, then click "Edit in Notepad."
2. Now you'll see the code for the script. Don't worry if it looks complicated - we're just going to change few things.
3. Use your mouse to highlight the phrase that needs to be changed (e.g. `"Your 5GHz Network Here"`).
4. Type in the new value within the quotes after doing the steps to determin what those are, and press Ctrl+S to save it after each change.
5. Repeat the steps 3-4 for each of the variables defined, task. `"Your Task Name Here"` is optional.



### Creating a Task Scheduler Task (Optional)

If you want to automate the launching of your VR application, you can create a new task in the Task Scheduler as follows:

1. Open the Task Scheduler (you can search for it in the Start menu).
2. Create a new task by clicking on "Create Task" in the right-hand **Actions** panel.
3. Give the task a name and description.
4. Click "Actions" tab then click "New".
5. Make sure "Start a program" as the action type.
6. Now, in the search at the bottom of your task bar, search for the desired program.
7. When the program is highlighted in search, click "Open file location".
8. In the new File Explorer window, right-click the program & click "copy as path".
5. Now paste that into the **Program/script** field.
6. Click "OK", note the name of your task letter for letter, including spaces & caps under the **General** tab.
7. Click "OK" again, you are done & can add it to your variable.

### Usage

To use this script, simply run the "VR Time" shortcut you created. This will execute the PowerShell script and enable high-speed hotspot for VR applications. To revert the changes made by the script, simply run it again when you're finished using your VR application.
### Troubleshooting

If you're experiencing issues with the hotspot connection, try checking the following:

* Ensure that the hotspot is set to 5GHz instead of 2.4GHz.
* Make sure that the proper device is selected as the internet source (e.g., Ethernet before running the script).
* Verify that your VR application is properly configured and installed.

By following these steps and troubleshooting tips, you should be able to successfully use this script to enable high-speed hotspot for your VR.

Note:It is normal for "No Wi-Fi networks found" to be shown during the use state of this script, after running again; it will revert this state. This is to disable the scanning autoconfig does which causes issues/dropouts when using the hotspot for VR.
