#include "..\script_component.hpp"

params [
	["_logic", objNull, [objNull]],		
	["_units", [], [[]]],
	["_activated", true, [true]]
];

if (!_activated) exitWith {};

if (!_activated) exitWith {};

private _synchronizedObjects = synchronizedObjects _logic;
if (_synchronizedObjects isEqualTo []) exitWith {};

private _capacity = _logic getVariable ["Capacity", 500];
private _availableOxygen = _logic getVariable ["OxygenAmount", 500];
private _drainSpeed = _logic getVariable ["DrainSpeed", 2];

private _syncedTriggers = _synchronizedObjects select { _x isKindOf "EmptyDetector" };
private _connectedObjects = _synchronizedObjects select { not (_x isKindOf "EmptyDetector") };

if (_connectedObjects isEqualTo []) exitWith {};

{
	private _params = [
		_x, 
		_capacity, 
		_availableOxygen, 
		_drainSpeed,
		true
	];

	if (_syncedTriggers isNotEqualTo []) then {
		{
			private _trigger = _x;
			// Trigger based init
			[
				_trigger,
				_params
			] spawn {
				params [
					"_trigger",
					"_params"
				];

				waitUntil { sleep 1; triggerActivated _trigger };

				_params call FUNC(initOxygenStation);
			};
		} forEach _syncedTriggers;
	} else {
		// Regular init (no trigger)
		_params call FUNC(initOxygenStation);
	};


} forEach _connectedObjects;
