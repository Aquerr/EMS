#include "script_component.hpp"

/*
	Author: Aquerr (also known as Nerdi)
	https://github.com/Aquerr

	Description:
        Function for handling the oxygen loop tick logic (normally executed every 5 seconds).

    Side:
       This script should be executed locally only.

	Parameter(s):
		0: OBJECT - the player

	Example:
        [_player] call ems_main_fnc_oxygenLoopTickLocal;
*/

params ["_player"];

private _hasGoggles = (goggles player) in GVAR(SpaceSuitGogglesClassNames);
private _hasHeadgear = (headgear player) in GVAR(SpaceSuitHeadgearClassNames);
private _hasUniform = (uniform player) in GVAR(SpaceSuitUniformClassNames);
private _hasVest = (vest player) in GVAR(SpaceSuitVestClassNames);
private _hasBackpack = (backpack player) in GVAR(SpaceSuitBackpackClassNames);
private _hasFullSuit = _hasHeadgear && _hasGoggles && _hasUniform && _hasVest && _hasBackpack;

private _isPlayerInOpenSpace = [] call EMS_IsPlayerInOpenSpace;

[QGVAR(handleBreathEvent), [player]] call CBA_fnc_localEvent;
