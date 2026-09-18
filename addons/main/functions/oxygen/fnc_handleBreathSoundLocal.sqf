#include "script_component.hpp"

/*
	Author: Aquerr (also known as Nerdi)
	https://github.com/Aquerr

	Description:
        Function for handling breath sound.

    Side:
       This script should be executed locally only.

	Parameter(s):
		0: OBJECT - the player

	Example:
        [_player] call ems_main_fnc_handleBreathSoundLocal;
*/

params [];

private _playingBreathSound = player getVariable ["ems_is_playing_breath_sound", false];
if (_playingBreathSound) exitWith {};
player setVariable ["ems_is_playing_breath_sound", true];

private _pitch = 0.5;
private _sounds = [];

private _hasGoggles = (goggles player) in GVAR(SpaceSuitGogglesClassNames);
if (_hasGoggles) then {
    _oxygen = [player] call EMS_SpaceSuit_GetOxygen;
    if (_oxygen > 8) then {
        _sounds = [] call EMS_SpaceSuit_BreathSounds;
    } else {
        if (_oxygen > 3) then {
            _sounds = ([] call EMS_SpaceSuit_HeavyBreathSounds) + ([] call EMS_SpaceSuit_BreathSounds);
        } else {
            _sounds = [] call EMS_SpaceSuit_CoughSounds;
        };
    };
} else {
	// Cough if in space/zero gravity. (Ability to turn off breathing in space via ADDON OPTIONS);
	_sounds = [] call EMS_SpaceSuit_CoughSounds;
	_pitch = 1;
};

private _soundId = [_sounds, _pitch] call EMS_SpaceSuit_PlayRandomBreathSound;

waitUntil {sleep 0.5; (soundParams _soundId) isEqualTo -1};
player setVariable ["ems_is_playing_breath_sound", false];
