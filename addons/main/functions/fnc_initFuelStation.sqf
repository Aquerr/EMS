#include "script_component.hpp"

params [
    "_object",
    ["_capacity", 500, [1]],
    ["_availableFuel", -1, [1]], // -1 = Unlimited,
    ["_drainSpeed", 0.01, [0.1]],
    ["_global", true, [true]]
];

// Code for server + future players
if (isServer && {_global && {isMultiplayer && {isNil {_object getVariable QGVAR(initFuelStation_JIP)}}}}) exitWith {

    _object setVariable ["ems_fuelstation_capacity", _capacity, true];
    if (_availableFuel > _capacity) then {
        _availableFuel = _capacity;
    };

    _object setVariable ["ems_fuelstation_available_fuel", _availableFuel, true];
    _object setVariable ["ems_fuelstation_drainspeed", _drainSpeed, true];

    private _id = [QGVAR(initFuelStationEvent), [_object, _capacity, _availableFuel, _drainSpeed, false]] call CBA_fnc_globalEventJIP;

    // Remove JIP EH if object is deleted
    [_id, _object] call CBA_fnc_removeGlobalEventJIP;

    _object setVariable [QGVAR(initFuelStation_JIP), _id, true];
};

if (!hasInterface) exitWith {};

[
    _object,
    "Refuel Spacesuit",
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", 
    "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
    "_this distance _target < 3 && {(_target getVariable ['ems_fuelstation_available_fuel', 0] == -1) || (_target getVariable ['ems_fuelstation_available_fuel', 0] > 0)}",
    "_caller distance _target < 3 && {(_target getVariable ['ems_fuelstation_available_fuel', 0] == -1) || (_target getVariable ['ems_fuelstation_available_fuel', 0] > 0)}",
    {},
    {
        params ["_target", "_caller", "_actionId", "_arguments", "_frame", "_maxFrame"];
        private _drainSpeed = _target getVariable ["ems_fuelstation_drainspeed", 0];
        private _drainedFuel = (_target getVariable ['ems_fuelstation_available_fuel', 0]) max _drainSpeed;

        private _actualFuel = _target getVariable ["ems_fuelstation_available_fuel", _drainedFuel];
        if (_actualFuel != -1) then {
            _target setVariable ["ems_fuelstation_available_fuel", _actualFuel - _drainedFuel, true];
        };

        [player, _drainedFuel] call EMS_SpaceSuit_RefillFuel;
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
