#include "script_component.hpp"

// ====================== Functions ======================

EMS_IsPlayerInOpenSpace = {
	private _spaceTriggers = emsSpaceTriggers;
	private _playerInOpenSpace = false;
	{
		_trigger = _x;
		if (player inArea _trigger) exitWith {
			_playerInOpenSpace = true;
		};

	} forEach _spaceTriggers;
	_playerInOpenSpace;
};

EMS_SpaceSuit_HandleSpaceDamage = {
	params ["_player", "_hasHeadgear", "_hasGoggles", "_hasUniform", "_hasVest", "_hasBackpack"];

	switch (true) do {
		// TODO: Addon setting for what body parts are required in space.
		case (GVAR(SpaceSuitDamageModeWhenNoSuitInSpace) == 1): { // Damage

			// Vanilla
			if (not GVAR(isAceMedicalEnabled)) exitWith {
				player setDamage ((damage player) + 0.05); 
			};

			// ACE
			if (not _hasHeadgear || not _hasGoggles) then {
				[player, 0.05, "Head", "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit"];
			};
			if (not _hasUniform) then {
				[player, 0.1, "Body", "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit"];
				[player, 0.1, "LeftArm", "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit"];
				[player, 0.1, "RightArm", "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit"];
				[player, 0.1, "LeftLeg", "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit"];
				[player, 0.1, "RightLeg", "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit"];
			};
			if (not _hasVest) then {
				[player, 0.05, "Body", "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit"];
			};
		};
		case (GVAR(SpaceSuitDamageModeWhenNoSuitInSpace) == 2): { // Kill
			if (GVAR(isAceMedicalEnabled)) then {
				[player, 100, "Head", "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit"];
			} else {
				_player setDamage 1;
			};
		};
		default { };
	};
};

EMS_SpaceSuit_OxygenLoop = {
	[] spawn {
		while {true} do {			
			if (!GVAR(SpaceSuitOxygenEnabled)) exitWith {};

			if (!alive player) exitWith {
				sleep 5;
			};

			private _hasGoggles = (goggles player) in GVAR(SpaceSuitGogglesClassNames);
			private _hasHeadgear = (headgear player) in GVAR(SpaceSuitHeadgearClassNames);
			private _hasUniform = (uniform player) in GVAR(SpaceSuitUniformClassNames);
			private _hasVest = (vest player) in GVAR(SpaceSuitVestClassNames);
			private _hasBackpack = (backpack player) in GVAR(SpaceSuitBackpackClassNames);
			private _hasFullSuit = _hasHeadgear && _hasGoggles && _hasUniform && _hasVest && _hasBackpack;

			private _isPlayerInOpenSpace = [] call EMS_IsPlayerInOpenSpace;

			// TODO: Addon setting for what body parts are required to breathe.

			// If has mask then play sound
			if (_hasGoggles) then {
				[player, GVAR(SpaceSuitOxygenConsumptionSpeed)] call EMS_SpaceSuit_UseOxygen;
				_oxygen = [player] call EMS_SpaceSuit_GetOxygen;
				if (_oxygen > 8) then {
					private _sounds = [] call EMS_SpaceSuit_BreathSounds;
					[_sounds, 0.5] call EMS_SpaceSuit_PlayRandomBreathSound;
				} else {
					if (_oxygen > 3) then {
						private _sounds = ([] call EMS_SpaceSuit_HeavyBreathSounds) + ([] call EMS_SpaceSuit_BreathSounds);
						[_sounds, 0.5] call EMS_SpaceSuit_PlayRandomBreathSound;	
					} else {
						_sounds = [] call EMS_SpaceSuit_CoughSounds;
						[_sounds, 0.5] call EMS_SpaceSuit_PlayRandomBreathSound;

						// Apply damage
						if (_oxygen < 0) then {
							if (GVAR(isAceMedicalEnabled)) then {
								[player, 0.05, "Head", "burn"] remoteExec ["ace_medical_fnc_addDamageToUnit"];
							} else {
								player setDamage ((damage player) + 0.05); 
							};
						};
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

			sleep 5;
		};
	};
};

EMS_SpaceSuit_OxygenCheck = {
	private _oxygen = [player] call EMS_SpaceSuit_GetOxygen;
	hintSilent (format ["Current oxygen: %1", _oxygen]);
};

EMS_SpaceSuit_GetOxygen = {
	_oxygen = player getVariable ["EMS_SpaceSuit_Oxygen", 0];
	_oxygen;
};

EMS_SpaceSuit_UseOxygen = {
	params ["_player", ["_amount", 0.1, [0]]];
	private _oxygen = player getVariable ["EMS_SpaceSuit_Oxygen", 0];
	player setVariable ["EMS_SpaceSuit_Oxygen", _oxygen - _amount];
};

EMS_SpaceSuit_SetOxygen = {
	params ["_player", ["_amount", 100, [0]]];
	player setVariable ["EMS_SpaceSuit_Oxygen", _amount];
};

EMS_SpaceSuit_RefillOxygen = {
	params ["_player", ["_amount", 0.5, [0]]];
	private _oxygen = player getVariable ["EMS_SpaceSuit_Oxygen", 0];
	player setVariable ["EMS_SpaceSuit_Oxygen", _oxygen + _amount];
};

EMS_SpaceSuit_PlayRandomBreathSound = {
	params ["_sounds", ["_pitch", 0.5]];
	private _selectedSound = selectRandom _sounds;
	playSoundUI [_selectedSound, 0.5, _pitch];
};

// TODO: Supply own sounds
EMS_SpaceSuit_BreathSounds = {
	_sounds = ["kat_chemical_mask_breath_1", "kat_chemical_mask_breath_2"];
	_sounds;
};

EMS_SpaceSuit_HeavyBreathSounds = {
	_sounds = ["kat_chemical_mask_breath_heavy"];
	_sounds;
};

EMS_SpaceSuit_CoughSounds = {
	_sounds = ["kat_chemical_cough_0", "kat_chemical_cough_1", "kat_chemical_cough_2", "kat_chemical_cough_3"];
	_sounds;
};

EMS_SpaceSuit_GetFuel = {
	private _fuel = player getVariable ["EMS_SpaceSuit_Fuel", 0];
	_fuel;
};

EMS_SpaceSuit_UseFuel = {
	params [["_amount", 0.01, [0]]];
	private _fuel = player getVariable ["EMS_SpaceSuit_Fuel", 0];
	player setVariable ["EMS_SpaceSuit_Fuel", _fuel - _amount];
};

EMS_SpaceSuit_SetFuel = {
	params ["_player", ["_amount", 100, [0]]];
	player setVariable ["EMS_SpaceSuit_Fuel", _amount];
};

EMS_SpaceSuit_RefillFuel = {
	params ["_player", ["_amount", 0.5, [0]]];
	private _fuel = player getVariable ["EMS_SpaceSuit_Fuel", 0];
	player setVariable ["EMS_SpaceSuit_Fuel", _fuel + _amount];
};

EMS_SpaceSuit_HasFuel = {
	private _fuel = [player] call EMS_SpaceSuit_GetFuel;
	private _hasFuel = _fuel > 0;
	_hasFuel;
};

EMS_SpaceSuit_FlightFuelCheck = {
	private _fuel = [player] call EMS_SpaceSuit_GetFuel;
	hintSilent (format ["Current fuel: %1", _fuel]);
};

EMS_SpaceSuit_FlightToggle = {

	private _isFlightEnabled = player getVariable ["EMS_SpaceSuit_Flight_Enabled", false];
	if (_isFlightEnabled) then {
		player setVariable ["EMS_SpaceSuit_Flight_Enabled", false];
		player setUnitFreefallHeight originlUnitFreefallHeight;
        hint "Space suit: flight disabled";
        
        private _vel = velocity player;
        player setVelocity [_vel select 0, _vel select 1, 0];
		if ((animationState player) isEqualTo "asdvpercmstpsnonwrfldnon") then {
			player switchMove "";
		}
        
	} else {
        player setVariable ["EMS_SpaceSuit_Flight_Enabled", true];
		player setUnitFreefallHeight 100000;
        hint "Space suit: flight enabled";
        
        private _pos = getPosATL player;
        _pos set [2, (_pos select 2) + 1];
        player setPosATL _pos;
	};
};

EMS_SpaceSuit_FlightLoop = {
	[{
		params ["_args", "_handle"];

			if (not (player getVariable ["EMS_SpaceSuit_Flight_Enabled", false])) exitWith {
				if ([player] call EMS_IsPlayerInOpenSpace && {not (isTouchingGround player)}) then {
					private _vel = player getVariable ["ems_spacesuit_velocity", [0,0,0]]; 
					player setVelocity _vel;
				};
			};

			if (!alive player) exitWith {
				player setVariable ["ems_spacesuit_velocity", [0,0,0]];
				if ([player] call EMS_IsPlayerInOpenSpace) then {
					private _vel = player getVariable ["ems_spacesuit_velocity", [0,0,0]]; 
					player setVelocity _vel;
				};
			};
			
			private _hasFuel = [player] call EMS_SpaceSuit_HasFuel;
			if (!_hasFuel) exitWith {
				player setVariable ["EMS_SpaceSuit_Flight_Enabled", false];
				if ([player] call EMS_IsPlayerInOpenSpace) then {
					private _vel = player getVariable ["ems_spacesuit_velocity", [0,0,0]]; 
					player setVelocity _vel;
				};
			};

			private _isPlayerInOpenSpace = [player] call EMS_IsPlayerInOpenSpace;
			if (_isPlayerInOpenSpace) then {
				[player] call EMS_SpaceSuit_HandleFlightInZeroGravityZone; 
			} else {
				[player] call EMS_SpaceSuit_HandleJetPackFlight;
			};

	}, 0.05] call CBA_fnc_addPerFrameHandler;
};

EMS_SpaceSuit_HandleJetPackFlight = {

	private _vel = velocity player;
	if ((_vel select 2) < 0) then {
		player setVelocity [_vel select 0, _vel select 1, -(_vel select 2)];
	};

	private _playerDirection = vectorDir player;
	private _camRight = (_playerDirection vectorCrossProduct [0,0,1]); 
	
	private _flightFuelConsumption = GVAR(SpaceSuitFuelConsumptionSpeed);
	private _speed = GVAR(SpaceSuitAccelleration) / 5;
	private _moveVec = [0,0,0];

	if (GVAR(cbaKeybindingsActive)) then {
		if (EMS_SpaceSuit_FlightForward_Pressed) then { _moveVec = _moveVec vectorAdd _playerDirection; };
		if (EMS_SpaceSuit_FlightBackward_Pressed) then { _moveVec = _moveVec vectorAdd (_playerDirection vectorMultiply -1); };
		if (EMS_SpaceSuit_FlightRight_Pressed) then { _moveVec = _moveVec vectorAdd _camRight; };
		if (EMS_SpaceSuit_FlightLeft_Pressed) then { _moveVec = _moveVec vectorAdd (_camRight vectorMultiply -1); };
		if (EMS_SpaceSuit_FlightUp_Pressed) then { _moveVec = _movevec vectorAdd [0, 0, 1]; };
		if (EMS_SpaceSuit_FlightDown_Pressed) then { _moveVec = _movevec vectorAdd [0, 0, -1]};
		if (inputAction "turbo" > 0) then { _speed = _speed * 2; _flightFuelConsumption = _flightFuelConsumption * 2 };
	} else {
		if (inputAction "MoveForward" > 0) then { _moveVec = _moveVec vectorAdd _playerDirection; };
		if (inputAction "MoveBack" > 0) then { _moveVec = _moveVec vectorAdd (_playerDirection vectorMultiply -1); };
		if (inputAction "TurnRight" > 0 || inputAction "LeanRight" > 0) then { _moveVec = _moveVec vectorAdd _camRight; };
		if (inputAction "TurnLeft" > 0 || inputAction "LeanLeft" > 0) then { _moveVec = _moveVec vectorAdd (_camRight vectorMultiply -1); };
		if (inputAction "Action" > 0) then { _moveVec = _movevec vectorAdd [0, 0, 1]; };
		if (inputAction "turbo" > 0) then { _speed = _speed * 2; _flightFuelConsumption = _flightFuelConsumption * 2 };
	};

	if (isTouchingGround player) then {
		if ((animationState player) isEqualTo "asdvpercmstpsnonwrfldnon") then {
			player switchMove "";
		};
		if (GVAR(cbaKeybindingsActive) && {not EMS_SpaceSuit_FlightUp_Pressed}) then {
			continue;
		};
		if (not GVAR(cbaKeybindingsActive) && {not (inputAction "Action" > 0)}) then {
			continue;
		}
	} else {
		player playMove "AsdvPercMstpSnonWrflDnon";	
	};

	if (vectorMagnitude _moveVec > 0) then {
		if (not EMS_SpaceSuitAirPressureSoundPlaying) then {
			EMS_SpaceSuitAirPressureSoundPlaying = true;
			playSound3D ["air_pressure", player, false, getPosASL player, 0.5, 1];
			[
				{EMS_SpaceSuitAirPressureSoundPlaying = false;}, 
				[],
				random 2
			] call CBA_fnc_waitAndExecute;
		};
		player setVelocity (vectorNormalized _moveVec vectorMultiply _speed);
	} else {
		player setVelocity [0, 0, 0];
	};

	player setVariable ["ems_spacesuit_velocity", (velocity player)];

	private _spaceSuitStatusHintMessage = "";

	if (GVAR(SpaceSuitFuelEnabled)) then {
		[_flightFuelConsumption] call EMS_SpaceSuit_UseFuel;
		private _fuel = [] call EMS_SpaceSuit_GetFuel;
		_spaceSuitStatusHintMessage = _spaceSuitStatusHintMessage + (format ["Current fuel: %1 \n", _fuel]);
	};
	
	if (_spaceSuitStatusHintMessage isNotEqualTo "") then {
		hintSilent _spaceSuitStatusHintMessage;
	};

};

EMS_SpaceSuit_HandleFlightInZeroGravityZone = {
	private _dt = diag_deltaTime;
	private _vel = player getVariable ["ems_spacesuit_velocity", [0,0,0]];

	if (!_isPlayerInOpenSpace) then {
		_vel = velocity player;
		if ((_vel select 2) < 0) then {
			player setVelocity [_vel select 0, _vel select 1, -(_vel select 2)];
		};
	};

	private _playerDirection = vectorDir player;
	private _camRight = (_playerDirection vectorCrossProduct [0,0,1]); 
	
	private _flightFuelConsumption = GVAR(SpaceSuitFuelConsumptionSpeed);
	private _moveVec = [0,0,0];
	private _acceleration = GVAR(SpaceSuitAccelleration);

	private _inputPressed = false;

	if (GVAR(cbaKeybindingsActive)) then {
		if (EMS_SpaceSuit_FlightForward_Pressed) then { _moveVec = _playerDirection; _inputPressed = true;};
		if (EMS_SpaceSuit_FlightBackward_Pressed) then { _moveVec = _playerDirection vectorMultiply -1; _inputPressed = true;};
		if (EMS_SpaceSuit_FlightRight_Pressed) then { _moveVec = _playerDirection vectorAdd _camRight; _inputPressed = true;};
		if (EMS_SpaceSuit_FlightLeft_Pressed) then { _moveVec = _playerDirection vectorAdd (_camRight vectorMultiply -1); _inputPressed = true;};
		if (EMS_SpaceSuit_FlightUp_Pressed) then { _moveVec = _playerDirection vectorAdd [0, 0, 1]; _inputPressed = true;};
		if (EMS_SpaceSuit_FlightDown_Pressed) then { _moveVec = _playerDirection vectorAdd [0, 0, -1]; _inputPressed = true;};
		if (inputAction "turbo" > 0) then { _acceleration = _acceleration * 2; _flightFuelConsumption = _flightFuelConsumption * 2; _inputPressed = true; };
	} else {
		if (inputAction "MoveForward" > 0) then { _moveVec = _playerDirection; _inputPressed = true;};
		if (inputAction "MoveBack" > 0) then { _moveVec = _playerDirection vectorMultiply -1; _inputPressed = true; };
		if (inputAction "TurnRight" > 0 || inputAction "LeanRight" > 0) then { _moveVec = _playerDirection vectorAdd _camRight; _inputPressed = true; };
		if (inputAction "TurnLeft" > 0 || inputAction "LeanLeft" > 0) then { _moveVec = _playerDirection vectorAdd (_camRight vectorMultiply -1); _inputPressed = true; };
		if (inputAction "Action" > 0) then { _moveVec = _playerDirection vectorAdd [0, 0, 1]; _inputPressed = true; };
		if (inputAction "turbo" > 0) then { _acceleration = _acceleration * 2; _flightFuelConsumption = _flightFuelConsumption * 2; _inputPressed = true; };
	};

	if (isTouchingGround player) then {
		player setVariable ["ems_spacesuit_velocity", [0,0,0]];
		if ((animationState player) isEqualTo "asdvpercmstpsnonwrfldnon") then {
			player switchMove "";
		};
		if (GVAR(cbaKeybindingsActive) && {not EMS_SpaceSuit_FlightUp_Pressed}) then {
			continue;
		};
		if (not GVAR(cbaKeybindingsActive) && {not (inputAction "Action" > 0)}) then {
			continue;
		};
	} else {
		player playMove "AsdvPercMstpSnonWrflDnon";	
	};

	if (vectorMagnitude _moveVec > 0) then {
		_moveVec = vectorNormalized _moveVec;
		_vel = _vel vectorAdd (_moveVec vectorMultiply (_acceleration * _dt));
	};

	_speed = vectorMagnitude _vel;
	if (_speed > GVAR(SpaceSuitMaxSpeed)) then {
		_vel = vectorNormalized _vel vectorMultiply GVAR(SpaceSuitMaxSpeed);
	};

	player setVelocity _vel;
	player setVariable ["ems_spacesuit_velocity", _vel];

	private _spaceSuitStatusHintMessage = "";

	if (_inputPressed) then {
		if (not EMS_SpaceSuitAirPressureSoundPlaying) then {
			EMS_SpaceSuitAirPressureSoundPlaying = true;
			playSound3D [getMissionPath "\sounds\air_pressure.ogg", player, false, getPosASL player, 0.5, 1];
			[
				{EMS_SpaceSuitAirPressureSoundPlaying = false;}, 
				[],
				random 2
			] call CBA_fnc_waitAndExecute;
		};

		if (GVAR(SpaceSuitFuelEnabled)) then {
			[_flightFuelConsumption] call EMS_SpaceSuit_UseFuel;
			private _fuel = [] call EMS_SpaceSuit_GetFuel;
			_spaceSuitStatusHintMessage = _spaceSuitStatusHintMessage + (format ["Current fuel: %1 \n", _fuel]);
			hintSilent _spaceSuitStatusHintMessage;
		};
	};
};

// ====================== Execution code on player init ======================

// ====================== Variables ======================
if (GVAR(cbaKeybindingsActive)) then {
	EMS_SpaceSuit_FlightForward_Pressed = false;
	EMS_SpaceSuit_FlightBackward_Pressed = false;
	EMS_SpaceSuit_FlightUp_Pressed = false;
	EMS_SpaceSuit_FlightLeft_Pressed = false;
	EMS_SpaceSuit_FlightDown_Pressed = false;
	EMS_SpaceSuit_FlightRight_Pressed = false;
};

// Spacesuit configuration
emsSpaceTriggers = [space_trigger_1]; // Create on init and append space_triggers via EDEN modules

//TODO: Move to addon settings
player setUnitFreefallHeight 10000;
originlUnitFreefallHeight = (getUnitFreefallInfo player) select 2;
EMS_SpaceSuitAirPressureSoundPlaying = false;

// ==================== Init logic ====================

[player, 100] call EMS_SpaceSuit_RefillFuel;
[player, 100] call EMS_SpaceSuit_RefillOxygen;

if (GVAR(SpaceSuitOxygenEnabled)) then {
	[player] call EMS_SpaceSuit_OxygenLoop;
};
[player] call EMS_SpaceSuit_FlightLoop;

if (GVAR(isAceInteractionMenuEnabled)) then {

        _spaceSuitActionParent = ["ems_spacesuit", "Space Suit", "", {}, {true}, {}, []] call ace_interact_menu_fnc_createAction;
        [player, 1, ["ACE_SelfActions", "ACE_Equipment"], _spaceSuitActionParent] call ace_interact_menu_fnc_addActionToObject;

        _actionCheckOxygen = ["spacesuit_check_oxygen", "Check Oxygen", "",
        {
            params ["_target", "_player", "_actionParams"];
			[player] call EMS_SpaceSuit_OxygenCheck;

        }, {true}, {}, []] call ace_interact_menu_fnc_createAction;

        _actionCheckFuel = ["spacesuit_check_fuel", "Check Fuel", "",
        {
            params ["_target", "_player", "_actionParams"];
			[player] call EMS_SpaceSuit_FlightFuelCheck;

        }, {true}, {}, []] call ace_interact_menu_fnc_createAction;

        [player, 1, ["ACE_SelfActions", "ACE_Equipment", "ems_spacesuit"], _actionCheckOxygen] call ace_interact_menu_fnc_addActionToObject;
        [player, 1, ["ACE_SelfActions", "ACE_Equipment", "ems_spacesuit"], _actionCheckFuel] call ace_interact_menu_fnc_addActionToObject;

};
