#include <openvr.h>
#include <iostream>

// ----------------
// OpenVR variables 
// ----------------

vr::IVRSystem* vr_context;

using namespace std;

// Tracked devices array keeps the record of connected device type
string tracked_device_type[vr::k_unMaxTrackedDeviceCount];

// Initialize JSON output
string json_out = "{ \n";

bool is_HMD_connected = false;
int base_stations_count = 0, controller_count = 0;

// Function outputs the tracked VR devices
int init_OpenVR();

int main()
{
	if (init_OpenVR() != 0) return -1;
	vr::VR_Shutdown();
}


int init_OpenVR()
{
	// Check whether HMD is connected successfully and the SteamVR runtime is installed
	if (vr::VR_IsHmdPresent())
	{
		// HMD connection is succesful in the setup
		is_HMD_connected = true;

		if (vr::VR_IsRuntimeInstalled()) {
			//cout << "SteamVR Runtime correctly installed'" << endl;
		}
		else
		{
			// SteamVR is not running, quitting the VR tracking app 
			return -1;
		}
	}
	else
	{
		// No HMD was found in the system
		// Record HMD connection as 0 in the json output
		json_out += "	\"HMD\": 0,\n";
	}

	if (is_HMD_connected) {

		// Load the SteamVR Runtime
		vr::HmdError err;
		vr_context = vr::VR_Init(&err, vr::EVRApplicationType::VRApplication_Overlay);
		

		for (uint32_t td = vr::k_unTrackedDeviceIndex_Hmd; td < vr::k_unMaxTrackedDeviceCount; td++) {

			if (vr_context->IsTrackedDeviceConnected(td))
			{
				vr::ETrackedDeviceClass tracked_device_class = vr_context->GetTrackedDeviceClass(td);
				string td_type = to_string(tracked_device_class);

				if (tracked_device_class == vr::ETrackedDeviceClass::TrackedDeviceClass_HMD)
				{
					tracked_device_type[td] = "HMD";
					json_out += "	\"HMD\": 1,\n";
				}
				else if (tracked_device_class == vr::ETrackedDeviceClass::TrackedDeviceClass_Controller)
				{
					tracked_device_type[td] = "Controller";
					controller_count++;
				}
				else if (tracked_device_class == vr::ETrackedDeviceClass::TrackedDeviceClass_TrackingReference)
				{
					tracked_device_type[td] = "BaseStation";
					base_stations_count++;
				}
				else tracked_device_type[td] = "Other";

				// Output tracked devices for debugging purpose 
				//cout << "Tracking device " << td << " is connected " << endl;
				//cout << "  Device type: " << td_type << "   Device Name: " << tracked_device_type[td] << endl;
				
			}

		}

	}

	json_out = json_out + "	\"Controller\": " + to_string(controller_count) + ",\n";
	json_out = json_out + "	\"Base Stations\": " + to_string(base_stations_count) + "\n";
	json_out += "}";

	cout << json_out << endl;

	return 0;
}
