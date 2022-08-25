# Tracking Devices in the VR Setup

The project is developed to track connected devices in the VR setup. In general, connections in the VR setup are not stable enough and necessitate human interference to restart the system. To solve this problem, tracked device information was gathered to automate the system using smart plugs. The [OpenVR API](https://github.com/ValveSoftware/openvr/wiki/API-Documentation) is implemented to check connected devices (HMD, Base Stations, Controllers). Since the OpenVR API allows you to interact with any Virtual Reality displays, this project is compatible with all headset brands (Oculus, Mixed Reality, Vive, etc). This VR tracking application is developed as an overlay app so that it can run with other VR applications simultaneously. 

######  Developer
- Begüm Çelik


## Step 1: Tracking Devices in the VR Setup
- OpenVR API is implemented to keep track of connected devices in the VR Setup.
- Executable can be found in the x64 directory. openvr_api.dll should be placed along with the exe file in order to run the app.
- Application outputs JSON file as such: <br />
```
  { 
    HMD: #0 disconnected; #1 connected 
    Base Stations: #number of connected base stations 
    Controllers #number of connected controllers 
  } 
```

## Step 2: Configuring ESP Devices
- Sonoff S26 Wi-Fi Smart Plugs are used in the VR setup.
- [ESP Home](https://esphome.io/index.html) Dashboard is used to configure ESP modules inside the wifi plugs.

## Step 3: Automating the system
- [AutoIt](https://www.autoitscript.com/site/) script is used to automate the tracking system.
- AutoIt script runs the exe file in every 15 seconds and decodes the JSON output. If the number of connected base stations are les then requirement, HTTP requests are sent to turn off-turn on the smart plug in which the VR headset is plugged in.
- Then, the script is built and the watchdog is added to autostart. 
- In order to use this AutoIt sript you should add json and binary call libraries into your ProgramFiles. (C:\Program Files\AutoIt\Libraries)

