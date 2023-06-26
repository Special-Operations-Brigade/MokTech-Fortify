#include "script_component.hpp"
/*
 * Author: Kingsley, modified by Mokka
 * Gets the cost for the given preset and classname.
 *
 * Arguments:
 * 0: Preset <STRING>
 * 1: Classname <STRING>
 *
 * Return Value:
 * Cost <NUMBER>
 *
 * Example:
 * ["Example_Preset", "Sandbag"] call mti_fortify_fortify_fnc_getCost
 *
 * Public: Yes
 */

params ["_preset", "_classname"];

private _classes = (format ["(toLower (getText (_x >> 'name'))) isEqualTo (toLower '%1')",_classname]) configClasses (([_preset] call FUNC(getPresetConfig)) >> "Objects");

if ((count _classes < 1)) exitWith { WARNING_2("object %1 not found in preset %2",_classname,_preset); 0 };

private _cost = GET_NUMBER((_classes select 0) >> "cost",0);

_cost
