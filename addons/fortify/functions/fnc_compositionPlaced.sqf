#include "script_component.hpp"

/*
Function: mti_fortify_fnc_compositionPlaced

Description:
    Handles composition being placed, server-side broadcast

Arguments:
    _unit - Unit that placed the composition
    _container - Container the composition was deployed from
    _objects - The objects of the composition
    _marker - Marker as string, empty if no marker should be created
    _posASL - Center position of the composition
    _cost - Cost of the composition

Return Value:
    None

Example:
    (begin example)
        [] call mti_fortify_fnc_compositionPlaced;
    (end)

Author:
	Mokka
*/

params ["_unit", "_container", "_objects", "_marker", "_posASL", "_cost"];
TRACE_4("compositionPlaced",_unit,_container,_objects,_marker);

if ((GVAR(markObjectsOnMap) isNotEqualTo 0) && (_marker isNotEqualTo "")) then {
    private _newMarker = [_marker] call BIS_fnc_stringToMarker;
    _newMarker setMarkerPos _posASL;

    private _compositionMarkers = _container getVariable [QGVAR(composition_markers),[]];
    _compositionMarkers pushBack _newMarker;
    _container setVariable [QGVAR(composition_markers),_compositionMarkers, true];
};

private _deployedObjects = _container getVariable [QGVAR(deployedCompositionObjects), []];
_deployedObjects pushBack [_objects,_cost,_newMarker];
_container setVariable [QGVAR(deployedCompositionObjects),_deployedObjects,true];
