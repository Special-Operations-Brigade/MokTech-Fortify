#include "script_component.hpp"

/*
Function: mti_fortify_fnc_deployCanceled

Description:
    Resets values if deployment was canceled

Arguments:
    ...

Return Value:
    None

Example:
    (begin example)
        [] call mti_fortify_fnc_deployCanceled;
    (end)

Author:
	Mokka
*/

params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
_args params ["_unit", "_container", "_preset", "_typeOf", "_posASL", "_vectorDir", "_vectorUp", "_cost"];

// Refund if deploy was cancelled
[_container, _preset, _cost] call FUNC(updateBudget);
_container setVariable [QGVAR(used),false,true];

// Reset animation
[_unit, "", 2] call ace_common_fnc_doAnimation;
