// ====================== Keybindings ======================

if (isClass(configFile >> "CfgPatches" >> "cba_keybinding")) then {
    
    [EMS_KEYBINDINGS_CAT, QGVAR(SpaceSuitKeybindingsFlightToggle), LLSTRING(ToggleFlight), {
        [player] call EMS_SpaceSuit_FlightToggle;
    }, {}, [47, [false, false, false]]] call CBA_fnc_addKeybind;

    [EMS_KEYBINDINGS_CAT, QGVAR(SpaceSuitKeybindingsFlightForward), LLSTRING(FlightForward), {
        EMS_SpaceSuit_FlightForward_Pressed = true;
    }, {
        EMS_SpaceSuit_FlightForward_Pressed = false;
    }, [17, [false, false, false]]] call CBA_fnc_addKeybind;

    [EMS_KEYBINDINGS_CAT, QGVAR(SpaceSuitKeybindingsFlightBackward), LLSTRING(FlightBackward), {
        EMS_SpaceSuit_FlightBackward_Pressed = true;
    }, {
        EMS_SpaceSuit_FlightBackward_Pressed = false;
    }, [31, [false, false, false]]] call CBA_fnc_addKeybind;

    [EMS_KEYBINDINGS_CAT, QGVAR(SpaceSuitKeybindingsFlightUp), LLSTRING(FlightUpward), {
        EMS_SpaceSuit_FlightUp_Pressed = true;
    }, {
        EMS_SpaceSuit_FlightUp_Pressed = false;
    }, [57, [false, false, false]]] call CBA_fnc_addKeybind;

    [EMS_KEYBINDINGS_CAT, QGVAR(SpaceSuitKeybindingsFlightLeft), LLSTRING(FlightLeft), {
        EMS_SpaceSuit_FlightLeft_Pressed = true;
    }, {
        EMS_SpaceSuit_FlightLeft_Pressed = false;
    }, [30, [false, false, false]]] call CBA_fnc_addKeybind;

    [EMS_KEYBINDINGS_CAT, QGVAR(SpaceSuitKeybindingsFlightDown), LLSTRING(FlightDownward), {
        EMS_SpaceSuit_FlightDown_Pressed = true;
    }, {
        EMS_SpaceSuit_FlightDown_Pressed = false;
    }, [44, [false, false, false]]] call CBA_fnc_addKeybind;

    [EMS_KEYBINDINGS_CAT, QGVAR(SpaceSuitKeybindingsFlightRight), LLSTRING(FlightRight), {
        EMS_SpaceSuit_FlightRight_Pressed = true;
    }, {
        EMS_SpaceSuit_FlightRight_Pressed = false;
    }, [32, [false, false, false]]] call CBA_fnc_addKeybind;

    [EMS_KEYBINDINGS_CAT, QGVAR(SpaceSuitKeybindingsOxygenCheck), LLSTRING(CheckOxygen), {
        [player] call EMS_SpaceSuit_OxygenCheck;
    }, {}, [34, [false, false, false]]] call CBA_fnc_addKeybind;

    [EMS_KEYBINDINGS_CAT, QGVAR(SpaceSuitKeybindingsFuelCheck), LLSTRING(CheckFuel), {
        [player] call EMS_SpaceSuit_FlightFuelCheck;
    }, {}, [35, [false, false, false]]] call CBA_fnc_addKeybind;
};


// ================= SETTINGS ====================

[
    QGVAR(SpaceSuitOxygenEnabled),
    "CHECKBOX",
    LLSTRING(SETTING_SpaceSuitOxygenEnabled),
    [EMS_SETTINGS_CAT, LSTRING(SubCategory_SpaceSuit)],
    true,
    true,
    {},
    false
] call CBA_fnc_addSetting;

[
    QGVAR(SpaceSuitOxygenConsumptionSpeed),
    "SLIDER",
    [LLSTRING(SpaceSuitOxygenConsumptionSpeed)],
    [EMS_SETTINGS_CAT, LSTRING(SubCategory_SpaceSuit)],
    [0.01, 10, 0.2, 2],
    true,
    {},
    false
] call CBA_fnc_addSetting;

[
    QGVAR(SpaceSuitFuelEnabled),
    "CHECKBOX",
    LLSTRING(SpaceSuitFuelEnabled),
    [EMS_SETTINGS_CAT, LSTRING(SubCategory_SpaceSuit)],
    true,
    true,
    {},
    false
] call CBA_fnc_addSetting;

[
    QGVAR(SpaceSuitFuelConsumptionSpeed),
    "SLIDER",
    [LLSTRING(SpaceSuitFuelConsumptionSpeed)],
    [EMS_SETTINGS_CAT, LSTRING(SubCategory_SpaceSuit)],
    [0.01, 10, 0.01, 2],
    true,
    {},
    false
] call CBA_fnc_addSetting;

[
    QGVAR(SpaceSuitDamageModeWhenNoSuitInSpace),
    "LIST",
    [LLSTRING(SpaceSuitDamageModeWhenNoSuitInSpace)],
    [EMS_SETTINGS_CAT, LSTRING(SubCategory_SpaceSuit)],
    [[1, 2], ["damage","kill"], 1],
    true,
    {},
    false
] call CBA_fnc_addSetting;

[
    QGVAR(SpaceSuitMaxSpeed),
    "SLIDER",
    [LLSTRING(SpaceSuitMaxSpeed)],
    [EMS_SETTINGS_CAT, LSTRING(SubCategory_SpaceSuit)],
    [0.1, 200, 10, 1],
    true,
    {},
    false
] call CBA_fnc_addSetting;

[
    QGVAR(SpaceSuitAccelleration),
    "SLIDER",
    [LLSTRING(SpaceSuitAccelleration)],
    [EMS_SETTINGS_CAT, LSTRING(SubCategory_SpaceSuit)],
    [0.1, 200, 15, 1],
    true,
    {},
    false
] call CBA_fnc_addSetting;

[
    QGVAR(SpaceSuitHeadgearClassNamesSetting),
    "EDITBOX",
    [LLSTRING(SpaceSuitHeadgearClassNames)],
    [EMS_SETTINGS_CAT, LSTRING(SubCategory_SpaceSuit)],
    "['H_PilotHelmetFighter_B', 'EXPNS_MCRNHelm']",
    true,
    {
        GVAR(SpaceSuitHeadgearClassNames) = parseSimpleArray GVAR(SpaceSuitHeadgearClassNamesSetting);
    },
    false
] call CBA_fnc_addSetting;

[
    QGVAR(SpaceSuitGogglesClassNamesSetting),
    "EDITBOX",
    [LLSTRING(SpaceSuitGogglesClassNames)],
    [EMS_SETTINGS_CAT, LSTRING(SubCategory_SpaceSuit)],
    "['G_AirPurifyingRespirator_02_black_F', 'TKE_MDWebbingNettingGrey']",
    true,
    {
        GVAR(SpaceSuitGogglesClassNames) = parseSimpleArray GVAR(SpaceSuitGogglesClassNamesSetting);
    },
    false
] call CBA_fnc_addSetting;

[
    QGVAR(SpaceSuitUniformClassNamesSetting),
    "EDITBOX",
    [LLSTRING(SpaceSuitUniformClassNames)],
    [EMS_SETTINGS_CAT, LSTRING(SubCategory_SpaceSuit)],
    "['U_C_CBRN_Suit_01_White_F', 'EXPNS_Suit_MCR']",
    true,
    {
        GVAR(SpaceSuitUniformClassNames) = parseSimpleArray GVAR(SpaceSuitUniformClassNamesSetting);
    },
    false
] call CBA_fnc_addSetting;

[
    QGVAR(SpaceSuitVestClassNamesSetting),
    "EDITBOX",
    [LLSTRING(SpaceSuitVestClassNames)],
    [EMS_SETTINGS_CAT, LSTRING(SubCategory_SpaceSuit)],
    "['V_RebreatherB', 'EXPNS_MCR_LightArmor']",
    true,
    {
        GVAR(SpaceSuitVestClassNames) = parseSimpleArray GVAR(SpaceSuitVestClassNamesSetting);
    },
    false
] call CBA_fnc_addSetting;

[
    QGVAR(SpaceSuitBackpackClassNamesSetting),
    "EDITBOX",
    [LLSTRING(SpaceSuitBackpackClassNames)],
    [EMS_SETTINGS_CAT, LSTRING(SubCategory_SpaceSuit)],
    "['C_IDAP_UAV_01_backpack_F', 'EXPNS_AirPack_MCRN']",
    true,
    {
        GVAR(SpaceSuitBackpackClassNames) = parseSimpleArray GVAR(SpaceSuitBackpackClassNamesSetting);
    },
    false
] call CBA_fnc_addSetting;
