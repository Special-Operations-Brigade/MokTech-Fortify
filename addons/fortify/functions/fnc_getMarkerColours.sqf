#include "script_component.hpp"

/*
Function: mti_common_fnc_getMarkerColours

Description:
    Returns all marker colours in pretty format for ZEN dialog.

Arguments:
    None

Return Value:
    All marker types in format [class name, pretty name array]

Example:
    (begin example)
        [] call mti_common_fnc_getMarkerColours;
    (end)

Author:
	Mokka
*/

private _allConfigs = "getNumber (_x >> 'scope') > 0" configClasses (configFile >> "CfgMarkerColors");
private _classNames = [];
private _prettyNames = [];

{
	_classNames pushBack (configName _x);

	private _name = GET_TEXT(_x >> "name","");
	private _color = GET_ARRAY(_x >> "color",[ARR_4(0,0,0,1)]);

    // handle colours set through profileNamespace
    if ((_color select 0) isEqualType "") then {
        private _colorStr = +_color;
        {
            _color set [_forEachIndex,call (compile _x)];
        } forEach _colorStr;
    };

    TRACE_3("getting marker colours",(configName _x),_name,_color);

	_prettyNames pushBack [_name,"","", _color];
} forEach _allConfigs;

[_classNames,_prettyNames]
