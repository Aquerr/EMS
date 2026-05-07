#include "script_component.hpp"

class CfgPatches
{
	class ADDON
	{
        name = COMPONENT_NAME;
		authors[]= { "Aquerr" };
		units[]={};
		weapons[]={};
        requiredVersion = REQUIRED_VERSION;
		requiredAddons[]=
		{
			"cba_main"
		};
        authorUrl = "https://github.com/Aquerr";
		VERSION_CONFIG;
	};
};

#include "CfgFactionClasses.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "CfgUnitInsignia.hpp"
