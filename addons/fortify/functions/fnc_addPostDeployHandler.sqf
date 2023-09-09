#include "script_component.hpp"
/*
 * Author: Cuel, mharis001, modified by Mokka
 * Adds a custom post deploy handler.
 * Handles setting certain variables etc on objects post-deployment.
 *
 * Arguments:
 * 0: Code <CODE>
 *  - Passed [Unit <OBJECT>, Object being placed <OBJECT>, Cost <NUMBER>, Container <OBJECT>, Preset <STRING>]
 *
 * Return Value:
 * None
 *
 * Example:
 * [{(_this select 0) getVariable ["isBobTheBuilder", false]}] call mti_fortify_fnc_addPostDeployHandler
 *
 * Public: Yes
 */

params [["_code", {}, [{}]]];

if (_code isEqualTo {} || {_code isEqualTo {true}}) exitWith {};
GVAR(postDeployHandlers) pushBack _code;
