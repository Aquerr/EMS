PREP(emptyFunction);
PREP(spaceSuitLogicLocal);
PREP(initPostPlayer);
PREP(addZeroGravityZone);

// Oxygen
PREP_BY_PATH(initOxygenStation,functions\oxygen\fnc_initOxygenStation.sqf);
PREP_BY_PATH(oxygenLoopTickLocal,functions\oxygen\fnc_oxygenLoopTickLocal.sqf);
PREP_BY_PATH(handleBreathLocal,functions\oxygen\fnc_handleBreathLocal.sqf);
PREP_BY_PATH(handleBreathSoundLocal,functions\oxygen\fnc_handleBreathSoundLocal.sqf);

// Fuel
PREP_BY_PATH(initFuelStation,functions\fuel\fnc_initFuelStation.sqf);

// Module functions
PREP_BY_PATH(moduleFuelStation,functions\eden\fnc_moduleFuelStation.sqf);
PREP_BY_PATH(moduleOxygenStation,functions\eden\fnc_moduleOxygenStation.sqf);
PREP_BY_PATH(moduleZeroGravityZone,functions\eden\fnc_moduleZeroGravityZone.sqf);
