#include "script_component.hpp"

params [
    "_object",
    ["_capacity", 500, [1]],
    ["_availableOxygen", -1, [1]], // -1 = Unlimited,
    ["_drainSpeed", 0.01, [0.1]],
    ["_global", true, [true]]
];

// Code for server + future players
if (isServer && {_global && {isMultiplayer && {isNil {_object getVariable QGVAR(initOxygenStation_JIP)}}}}) exitWith {

    _object setVariable ["ems_oxygenstation_capacity", _capacity, true];
    if (_availableOxygen > _capacity) then {
        _availableOxygen = _capacity;
    };

    _object setVariable ["ems_oxygenstation_available_oxygen", _availableOxygen, true];
    _object setVariable ["ems_oxygenstation_drainspeed", _drainSpeed, true];

    private _id = [QGVAR(initOxygenStationEvent), [_object, _capacity, _availableOxygen, _drainSpeed, false]] call CBA_fnc_globalEventJIP;

    // Remove JIP EH if object is deleted
    [_id, _object] call CBA_fnc_removeGlobalEventJIP;

    _object setVariable [QGVAR(initOxygenStation_JIP), _id, true];
};

if (!hasInterface) exitWith {};

[
    _object,
    "Refill Spacesuit's Oxygen",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
    "_this distance _target < 3 && {(_target getVariable ['ems_oxygenstation_available_oxygen', 0] == -1) || (_target getVariable ['ems_oxygenstation_available_oxygen', 0] > 0)}",
    "_caller distance _target < 3 && {(_target getVariable ['ems_oxygenstation_available_oxygen', 0] == -1) || (_target getVariable ['ems_oxygenstation_available_oxygen', 0] > 0)}",
    {},
    {
        params ["_target", "_caller", "_actionId", "_arguments", "_frame", "_maxFrame"];
        private _drainSpeed = _target getVariable ["ems_oxygenstation_drainspeed", 0];
        private _drainedFuel = (_target getVariable ['ems_oxygenstation_available_oxygen', 0]) max _drainSpeed;

        private _actualOxygen = _target getVariable ["ems_oxygenstation_available_oxygen", _drainedFuel];
        if (_actualOxygen != -1) then {
            _target setVariable ["ems_oxygenstation_available_oxygen", _actualOxygen - _drainedFuel, true];
        };

        [player, _drainedFuel] call EMS_SpaceSuit_RefillOxygen;
    },
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
    },
    {},
    [], 
    10, 
    nil, 
    false, 
    false
] call BIS_fnc_holdActionAdd;
