#include "script_component.hpp"

[QGVAR(initFuelStationEvent), { call FUNC(initFuelStation)}] call CBA_fnc_addEventHandler;
[QGVAR(initOxygenStationEvent), { call FUNC(initOxygenStation)}] call CBA_fnc_addEventHandler;

[QGVAR(oxygenLoopTickEvent), { call FUNC(oxygenLoopTickLocal)}] call CBA_fnc_addEventHandler;
[QGVAR(handleBreathEvent), { call FUNC(handleBreathLocal)}] call CBA_fnc_addEventHandler;
