class Logic;
class Module_F: Logic {
    class AttributesBase {
        class Edit;
        class ModuleDescription;
    };
    class ModuleDescription;
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

class GVAR(moduleFuelStation): GVAR(baseEdenModule) {
    displayName = CSTRING(Module_FuelStation_DisplayName);
    function = QFUNC(moduleFuelStation);
    scope = 2;
    class Attributes: AttributesBase {
        class Capacity: Edit {
            property = QGVAR(moduleFuelStation_Capacity);
            displayName = CSTRING(CapacityLabel);
            tooltip = CSTRING(CapacityTooltip);
            typeName = "NUMBER";
            defaultValue = "500";
        };
        class FuelAmount: Edit {
            property = QGVAR(moduleFuelStation_FuelAmount);
            displayName = CSTRING(FuelAmountLabel);
            typeName = "NUMBER";
            defaultValue = "500";
        };
        class DrainSpeed: Edit {
            property = QGVAR(moduleFuelStation_DrainSpeed);
            displayName = CSTRING(DrainSpeedLabel);
            typeName = "NUMBER";
            defaultValue = "2";
        };

        class ModuleDescription: ModuleDescription {};
    };
    class ModuleDescription: ModuleDescription {
        description = CSTRING(Module_FuelStation_Description);
    };
};

class GVAR(moduleOxygenStation): GVAR(baseEdenModule) {
    displayName = CSTRING(Module_OxygenStation_DisplayName);
    function = QFUNC(moduleOxygenStation);
    scope = 2;
    class Attributes: AttributesBase {
        class Capacity: Edit {
            property = QGVAR(moduleOxygenStation_Capacity);
            displayName = CSTRING(CapacityLabel);
            tooltip = CSTRING(CapacityTooltip);
            typeName = "NUMBER";
            defaultValue = "500";
        };
        class OxygenAmount: Edit {
            property = QGVAR(moduleOxygenStation_OxygenAmount);
            displayName = CSTRING(OxygenAmountLabel);
            typeName = "NUMBER";
            defaultValue = "500";
        };
        class DrainSpeed: Edit {
            property = QGVAR(moduleFuelStation_DrainSpeed);
            displayName = CSTRING(DrainSpeedLabel);
            typeName = "NUMBER";
            defaultValue = "2";
        };
        class ModuleDescription: ModuleDescription {};
    };
    class ModuleDescription: ModuleDescription {
        description = CSTRING(Module_OxygenStation_Description);
    };
};

class GVAR(moduleZeroGravityZone): GVAR(baseEdenModule) {
    displayName = CSTRING(Module_ZeroGravityZone_DisplayName);
    function = QFUNC(moduleZeroGravityZone);
    scope = 2;

    // This enables the 3D area widget (resizing) for the module
    canSetArea=1;
    canSetAreaHeight=1;
    canSetAreaShape=1;

    class AttributeValues
    {
        size3[]={5,5,-1};
        isRectangle=0;
    };

    class Attributes: AttributesBase {
        class ModuleDescription: ModuleDescription {};
    };
    class ModuleDescription: ModuleDescription {
        description = CSTRING(Module_ZeroGravityZone_Description);
    };
};
