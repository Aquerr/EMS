#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"
#include "cba_settings.inc.sqf"

GVAR(isAceMedicalEnabled) = isClass(configFile >> "CfgPatches" >> "ace_medical");
GVAR(isAceInteractionMenuEnabled) = isClass(configFile >> "CfgPatches" >> "ace_interact_menu");
GVAR(cbaKeybindingsActive) = isClass(configFile >> "CfgPatches" >> "cba_keybinding");

emsSpaceZones = [];

ADDON = true;
