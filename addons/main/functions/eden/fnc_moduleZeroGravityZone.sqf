
params [
	["_logic", objNull, [objNull]],		
	["_units", [], [[]]],
	["_activated", true, [true]]
];

if (!_activated) exitWith {};

private _area = [getPos _logic];
_area append (_logic getVariable ["objectarea",[]]);
_area params ["_center","_a","_b", "_angle", "_isRectangle", "_c"];
private _radius = (_a max _b) * 1.42;
private _angle = getDir _logic;

hint (format ["Module pos %1 | radius: %2", _center, _radius]);

// Array with [center, a, b, angle, isRectangle, c, usePosWorld]
emsSpaceZones pushBack _area;
