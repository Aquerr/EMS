#include "script_component.hpp"

/*
	Author: Aquerr (also known as Nerdi)
	https://github.com/Aquerr

	Description:
        Function for handling breath.

    Side:
       This script should be executed locally only.

	Parameter(s):
		0: OBJECT - the player

	Example:
        [_player] call ems_main_fnc_handleBreathLocal;
*/

params ["_player"];

// TODO: Addon setting for what body parts are required to breathe.

private _hasGoggles = (goggles player) in GVAR(SpaceSuitGogglesClassNames); //TODO: Take classnames also from config.
private _hasHeadgear = (headgear player) in GVAR(SpaceSuitHeadgearClassNames);
private _hasUniform = (uniform player) in GVAR(SpaceSuitUniformClassNames);
private _hasVest = (vest player) in GVAR(SpaceSuitVestClassNames);
private _hasBackpack = (backpack player) in GVAR(SpaceSuitBackpackClassNames);
private _hasFullSuit = _hasHeadgear && _hasGoggles && _hasUniform && _hasVest && _hasBackpack;

private _isPlayerInOpenSpace = [] call EMS_IsPlayerInOpenSpace;

[player] call FUNC(handleBreathSoundLocal);

// If has mask then play sound
if (_hasGoggles) then {
	[player, GVAR(SpaceSuitOxygenConsumptionSpeed)] call EMS_SpaceSuit_UseOxygen;
    [QGVAR(handleBreathEvent), [player]] call CBA_fnc_localEvent;

	_oxygen = [player] call EMS_SpaceSuit_GetOxygen;
	if (_oxygen < 0) then {
		if (GVAR(isAceMedicalEnabled)) then {
			[player, 0.05, "Head", "burn"] call ace_medical_fnc_addDamageToUnit;
		} else {
			player setDamage ((damage player) + 0.05); 
		};
	};

} else {
    if (_isPlayerInOpenSpace) then {
        _sounds = [] call EMS_SpaceSuit_CoughSounds;
        [_sounds, 1] call EMS_SpaceSuit_PlayRandomBreathSound;
        [player, _hasHeadgear, false, _hasUniform, _hasVest, _hasBackpack] call EMS_SpaceSuit_HandleSpaceDamage;
    };
};

if (_isPlayerInOpenSpace) then {
    if (not _hasfullSuit) then {
        [player, _hasHeadgear, _hasGoggles, _hasUniform, _hasVest, _hasBackpack] call EMS_SpaceSuit_HandleSpaceDamage;
    };
};
