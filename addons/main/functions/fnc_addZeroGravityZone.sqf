// Local only

// _area = [center, x, y, angle, isRectangle, z, usePosWorld]
params ["_area"];

waitUntil { sleep 0.2; not (isNil "emsSpaceZones")};
emsSpaceZones pushBack _area;
