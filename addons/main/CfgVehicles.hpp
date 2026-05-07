class CfgVehicles {
    class Logic;
    class Module_F: Logic {

    };

    // Base module
    class GVAR(baseEdenModule): Module_F {
        author = "Aquerr";
        category = QGVAR(EMS);
        function = QFUNC(emptyFunction);
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 0;
        scope = 0; // 2 for EDEN and Zeus, 1 for Zeus.
        scopeCurator = 0; // 0 hidden from Zeus
    };

    ///////////////////////////////////////////////////////////////////////////////////
    //EDEN Modules
};
