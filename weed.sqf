	private [
	"_event_marker","_spawnChance", "_spawnMarker", "_spawnRadius", "_textMark", 
	"_item", "_marker", "_start_time", "_wait_time", "_spawnRoll", "_position", "_thc_pos", 
	"_text_marker","_hint","_weedplants"
	];
	_spawnChance =  0.50; 
	_markerRadius = 200; 
	_textMark = true;

	_wait_time = 3600 ; 
	_start_time = time;
	_spawnRadius = 5000;
	_spawnMarker = 'center';

	// CHECK IF ALREADY RUNNING
	if (isNil "epoch_event_running") then {
	epoch_event_running = false;
	};
	 if (epoch_event_running) exitWith {
	diag_log("Event already running");
	};

	// CHANCE 
	_spawnRoll = random 1;
	if (_spawnRoll > _spawnChance and !_textMark) exitWith {};
	 
	// LOCATION
	_position = [getMarkerPos _spawnMarker,0,_spawnRadius,10,0,2000,0] call BIS_fnc_findSafePos;

	diag_log(format["Spawning Weed Farm at %1", _position]);

	_event_marker = createMarker [ format ["weed_event_marker_%1", _start_time], _position];
	_event_marker setMarkerShape "ELLIPSE";
	_event_marker setMarkerColor "ColorGreen";
	_event_marker setMarkerAlpha 0;					//change to 0.5 for visiblity
	_event_marker setMarkerSize [(_markerRadius + 50), (_markerRadius + 50)];
	_thc_pos = [_position,0,(_markerRadius - 100),10,0,2000,0] call BIS_fnc_findSafePos;
	 
	if (_textMark) then {
	_text_marker = createMarker [ format ["weed_event_text_marker_%1", _start_time], _thc_pos];
	_text_marker setMarkerShape "ICON";
	_text_marker setMarkerType "mil_dot";
	_text_marker setMarkerColor "ColorGreen";
	_text_marker setMarkerAlpha 0.5;
	_text_marker setMarkerText "Weed!";
	};
	
	diag_log(format["Creating Weed Farm at %1", _thc_pos]);

	createVehicle ["fiberplant",[(_thc_pos select 0) - 1, (_thc_pos select 1) - 2,-0.12],[], 0, "CAN_COLLIDE"];
	createVehicle ["fiberplant",[(_thc_pos select 0) + 1.1, (_thc_pos select 1) - 2,-0.64],[], 0, "CAN_COLLIDE"];
	createVehicle ["fiberplant",[(_thc_pos select 0) - 1.1, (_thc_pos select 1) - 2,-0.64],[], 0, "CAN_COLLIDE"];
	createVehicle ["fiberplant",[(_thc_pos select 0) - 1.2, (_thc_pos select 1) - 2,-0.64],[], 0, "CAN_COLLIDE"];

	// MESSAGECLIENT
	_params = ["0.8","#FFFFFF","0.5","#a6ff00",0,-0.3,10,0.5];
	RemoteMessage = ["dynamic_text", ["Radio chatter of a Weed Farm!","Check your map for the location!"],_params];
	publicVariable "RemoteMessage";

	diag_log(format["Weed Farm Setup, waiting for %1 seconds", _wait_time]);

	sleep _wait_time;
	 
	epoch_event_running = false;
	{deleteVehicle _x} forEach nearestObjects [_position, ["fiberplant"], 20];
	deleteMarker _event_marker;
	if (_textMark) then {
	deleteMarker _text_marker;
	};