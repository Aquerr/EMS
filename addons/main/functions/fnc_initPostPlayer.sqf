#include "script_component.hpp"

params ["_unit", ["_isRespawn", true]];

if (!_isRespawn) then {
    _unit addEventHandler ["Respawn", {[(_this select 0), true] call FUNC(initPostPlayer)}];

    [player] call FUNC(spaceSuitLogicLocal);
};

if (_unit isNotEqualTo player) exitWith {};
if (!local _unit) exitWith {};

[player, 100] call EMS_SpaceSuit_RefillFuel;
[player, 100] call EMS_SpaceSuit_RefillOxygen;
