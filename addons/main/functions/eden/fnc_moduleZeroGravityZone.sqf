#include "..\script_component.hpp"

params [
	["_logic", objNull, [objNull]],		
	["_units", [], [[]]],
	["_activated", true, [true]]
];

if (!_activated) exitWith {};

private _synchronizedObjects = synchronizedObjects _logic;
private _syncedTriggers = _synchronizedObjects select { _x isKindOf "EmptyDetector" };

private _initZeroGravityZone = {
	params ["_logic"];

	private _area = [getPos _logic];
	_area append (_logic getVariable ["objectarea",[]]);
	_area params ["_center","_a","_b", "_angle", "_isRectangle", "_c"];

	[_area] call FUNC(addZeroGravityZone);
};

if (_syncedTriggers isNotEqualTo []) then {
	{
		private _trigger = _x;
		// Trigger based init
		[
			_trigger,
			_logic,
			_initZeroGravityZone
		] spawn {
			params [
				"_trigger",
				"_logic",
				"_initZeroGravityZone"
			];

			waitUntil { sleep 1; triggerActivated _trigger };

			_logic call _initZeroGravityZone;
		};
	} forEach _syncedTriggers;
} else {
	// Regular init (no trigger)
	_logic call _initZeroGravityZone;
};
