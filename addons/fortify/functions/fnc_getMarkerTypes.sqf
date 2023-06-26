#include "script_component.hpp"

/*
Function: mti_common_fnc_getMarkerTypes

Description:
    Returns all marker types in pretty format for ZEN dialog.

Arguments:
    None

Return Value:
    All marker types in format [class name, pretty name array]

Example:
    (begin example)
        [] call mti_common_fnc_getMarkerTypes;
    (end)

Author:
	Mokka
*/

private _allConfigs = "getNumber (_x >> 'scope') > 0" configClasses (configFile >> "CfgMarkers");
private _classNames = [];
private _prettyNames = [];

{
	_classNames pushBack (configName _x);

	private _name = GET_TEXT(_x >> "name","");
	private _icon = GET_TEXT(_x >> "icon","");

    TRACE_3("getting marker types",(configName _x),_name,_icon);

	_prettyNames pushBack [_name,"",_icon, [1,1,1,1]];
} forEach _allConfigs;

[_classNames,_prettyNames]
