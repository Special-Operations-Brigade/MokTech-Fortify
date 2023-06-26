[
    QGVAR(fortifyAllowed),
    "CHECKBOX",
    ["Enable Fortify System", "Enables the Fortify System."],
    COMPONENT_NAME,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(timeCostCoefficient),
    "SLIDER",
    [LLSTRING(settingHint_timeCostCoefficient), LLSTRING(settingHintDesc_timeCostCoefficient)],
    COMPONENT_NAME,
    [0, 10, 0.25, 2], // Min, Max, Default, Trailing Decimals, is Percentage
    true //isGlobal
] call CBA_fnc_addSetting;

[
    QGVAR(timeMin),
    "SLIDER",
    [LLSTRING(settingHint_timeMin), LLSTRING(settingHintDesc_timeMin)],
    COMPONENT_NAME,
    [0, 25, 1.5, 1], // Min, Max, Default, Trailing Decimals, is Percentage
    true //isGlobal
] call CBA_fnc_addSetting;

[
    QGVAR(timeMax),
    "SLIDER",
    [LLSTRING(settingHint_timeMax), LLSTRING(settingHintDesc_timeMax)],
    COMPONENT_NAME,
    [0, 120, 30, 0], // Min, Max, Default, Trailing Decimals, is Percentage
    true //isGlobal
] call CBA_fnc_addSetting;

[
    QGVAR(markObjectsOnMap),
    "LIST",
    [LLSTRING(markObjectsOnMap), LLSTRING(markObjectsOnMapDesc)],
    COMPONENT_NAME,
    [
        [0, 1, 2],
        [LLSTRING(markObjectsOnMapNone), LLSTRING(markObjectsOnMapFriendly), LLSTRING(markObjectsOnMapEveryone)],
        1
    ],
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowSaving),
    "CHECKBOX",
    ["Allow Saving/Loading", "Enables players to save/load compositions using special containers."],
    COMPONENT_NAME,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(recallTimeCoef),
    "SLIDER",
    ["Recall Time Coefficient", "Controls how long the recall takes (coef multiplied by amount of objects)."],
    COMPONENT_NAME,
    [0, 10, 0.25, 2], // Min, Max, Default, Trailing Decimals, is Percentage
    true //isGlobal
] call CBA_fnc_addSetting;
