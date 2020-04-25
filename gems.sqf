
	private [
	"_event_marker","_spawnChance", "_spawnMarker", "_spawnRadius", "_textMark", 
	"_item", "_marker", "_start_time", "_wait_time", "_spawnRoll", "_position", "_gem_pos", 
	"_text_marker","_hint","_rockore"
	];

	_spawnChance =  0.50; 
	_markerRadius = 200; 
	_textMark = true;		

	_wait_time = 3600; 
	_start_time = time;
	_spawnRadius = 5000;
	_spawnMarker = 'center';

	//CHECK IF ALREADY RUNNING
	if (isnil "epoch_event_running") then {
	epoch_event_running = false;
	};
	 if (epoch_event_running) exitwith {
	diag_log("event already running");
	};
	 
	// CHANCE 
	_spawnRoll = random 1;
	if (_spawnRoll > _spawnChance and !_textMark) exitWith {};
	 
	// LOCATION
	_position = [getMarkerPos _spawnMarker,0,_spawnRadius,10,0,2000,0] call BIS_fnc_findSafePos;
	 
	diag_log(format["Spawning Gem event at %1", _position]);

	_event_marker = createMarker [ format ["gem_event_marker_%1", _start_time], _position];
	_event_marker setMarkerShape "ELLIPSE";
	_event_marker setMarkerColor "ColorYellow";
	_event_marker setMarkerAlpha 0;					//change to 0.5 for visiblity
	_event_marker setMarkerSize [(_markerRadius + 50), (_markerRadius + 50)];
	_gem_pos = [_position,0,(_markerRadius - 100),10,0,2000,0] call BIS_fnc_findSafePos;
	 
	if (_textMark) then {
	_text_marker = createMarker [ format ["gem_event_text_marker_%1", _start_time], _gem_pos];
	_text_marker setMarkerShape "ICON";
	_text_marker setMarkerType "mil_dot";
	_text_marker setMarkerColor "ColorYellow";
	_text_marker setMarkerAlpha 0.5;
	_text_marker setMarkerText "Gems!";
	};
	 
	diag_log(format["Creating Gem Farm at %1", _gem_pos]);

	// CREATE 
	createVehicle ["Gold_Vein_DZE",[(_gem_pos select 0) - 1, (_gem_pos select 1) - 2,-0.12],[], 0, "CAN_COLLIDE"];
	createVehicle ["Gold_Vein_DZE",[(_gem_pos select 0) + 1.1, (_gem_pos select 1) - 2,-0.64],[], 0, "CAN_COLLIDE"];
	createVehicle ["Gold_Vein_DZE",[(_gem_pos select 0) - 1.1, (_gem_pos select 1) - 2,-0.64],[], 0, "CAN_COLLIDE"];
	createVehicle ["Gold_Vein_DZE",[(_gem_pos select 0) - 1.2, (_gem_pos select 1) - 2,-0.64],[], 0, "CAN_COLLIDE"];
	createVehicle ["Gold_Vein_DZE",[(_gem_pos select 0) + 1.2, (_gem_pos select 1) + 2,-0.64],[], 0, "CAN_COLLIDE"];
	createVehicle ["Gold_Vein_DZE",[(_gem_pos select 0) - 1.3, (_gem_pos select 1) + 2,-0.64],[], 0, "CAN_COLLIDE"];
	createVehicle ["Gold_Vein_DZE",[(_gem_pos select 0) - 2, (_gem_pos select 1) + 2,-0.64],[], 0, "CAN_COLLIDE"];
	createVehicle ["Gold_Vein_DZE",[(_gem_pos select 0) + 2, (_gem_pos select 1) + 2,-0.02],[], 0, "CAN_COLLIDE"];

	// MESSAGECLIENT
	_params = ["0.8","#FFFFFF","0.5","#a6ff00",0,-0.3,10,0.5];
	RemoteMessage = ["dynamic_text", ["Radio chatter of Ore Deposits!","Check your map for the location!"],_params];
	publicVariable "RemoteMessage";

	diag_log(format["Gem event setup, waiting for %1 seconds", _wait_time]);

	sleep _wait_time;
	 
	EPOCH_EVENT_RUNNING = false;

	{deleteVehicle _x} forEach nearestObjects [_position, ["Gold_Vein_DZE"], 20];
	deleteMarker _event_marker;
	if (_textMark) then {
	deleteMarker _text_marker;
	};