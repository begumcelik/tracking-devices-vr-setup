# Tracking Devices in the VR Setup and Automating Restart

The project is developed to track connected devices in the VR setup. In general, connections in the VR setup are not stable enough and necessitate human interference to restart the system. Especially in the case of long run-time of VR apps such as in exhibition setups, restarting the setup becomes a necessity. To solve this problem, tracked device information was gathered to automate the system using smart plugs. The [OpenVR API](https://github.com/ValveSoftware/openvr/wiki/API-Documentation) is implemented to check connected devices (HMD, Base Stations, Controllers) and SteamVR connection. Since the OpenVR API allows you to interact with any Virtual Reality display, the project is compatible with all headset brands (Oculus, Mixed Reality, Vive, etc). This VR setup tracking project is implemented as an overlay application so that it can run with other VR applications simultaneously. 

*Tested with:*
- HTC Vive Pro 2
- Valve Index

##  Supervisor
- Marc Schütze

##  Developer
- Begüm Çelik

## Step 1: Tracking Devices in the VR Setup
- OpenVR API is implemented to keep track of connected devices in the VR Setup.
- The VR Tracker application will check whether HMD is connected or not. 
- If the HMD is connected and SteamVR is running succesfully, then it will check how many base stations and controllers are connected.

### Download
- Executable `vr-tracker.exe` can be found under the x64 directory.
- `openvr_api.dll` should be placed along with the exe file in order to run the app.

### Output
- Application outputs JSON file as such: <br />
```
    { 
      HMD: #0 disconnected; #1 connected, 
      Base Stations: #number of connected base stations, 
      Controllers #number of connected controllers 
    } 
```

## Step 2: Configuring ESP Devices
- Sonoff S26 Wi-Fi Smart Plugs are used in the VR setup.
- [ESP Home](https://esphome.io/index.html) Dashboard is used to configure ESP modules inside the wifi plugs.
- Copy sonoff.yaml file and paste it into your ESP Home dashboard, and install it into your wifi device. (and boot it!)
```
# Basic Config
esphome:
  name: sonoff
  platform: ESP8266
  board: esp01_1m

wifi:
  ssid: <your wifi ssid here>
  password: <your wifi password here>
   # Optional manual IP
  manual_ip:
    static_ip: xxx.xxx.xxx.xxx
    gateway: xxx.xxx.xxx.x
    subnet: xxx.xxx.xxx.x
logger:

api:
  reboot_timeout: 0s

ota:
  password: <your password here>
  
web_server:
  port: 80
  
status_led:
  pin:
    number: GPIO13
    inverted: false
    
binary_sensor:
  - platform: gpio
    pin:
      number: GPIO0
      mode: INPUT_PULLUP
      inverted: True
    name: "sonoff-button"
    on_press:
      - switch.turn_off: relay
      - delay: 2s
      - switch.turn_on: relay
  - platform: status
    name: "sonoff-status"

sensor:
  - platform: wifi_signal
    name: "sonoff-wifi-signal"
    update_interval: 60s
switch:
  - platform: gpio
    name: "sonoff-Relay"
    pin: GPIO12
    id: "relay"
```

## Step 3: Automating the system
- [AutoIt](https://www.autoitscript.com/site/) script is implemented to automate the tracking system.
- AutoIt script runs the exe file in every 15 seconds and decodes the JSON output. 
- If the number of connected base stations is less than the required value, HTTP requests are sent to turn off-turn on the smart plug in which the VR headset is plugged.
- In order to use this AutoIt sript you should add `Json.au3` and `BinaryCall.au3` into your ProgramFiles. `C:\Program Files\AutoIt\Libraries`
- Then, open the `restart-vr-setup.au3` in the AutoIt editor and change the path to your exe file, and HTTP requests corresponding to your smart plugs' control. (you can find yours by inspecting the ESP Dashboard site)
- Built the watchdog and include it in your autostart folder, if you would like to use it all the time. 

## Contact
begumcelik@sabanciuniv.edu

## License 

