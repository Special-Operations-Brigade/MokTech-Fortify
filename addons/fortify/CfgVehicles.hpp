class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class ADDON {
                displayName = CSTRING(Fortify);
                condition = QUOTE([_player] call FUNC(canFortify));
                insertChildren = QUOTE([ARR_2(_this select 0,'')] call FUNC(addActions));
                statement = "";
                exceptions[] = {};
                showDisabled = 0;
                priority = 1;

                class recallAll {
                    displayName = "<t color='#FFA500'>Recall Backpack Objects</t>";
                    condition = QUOTE([_player] call FUNC(canRecallObjectsPlayer));
                    statement = QUOTE([_player] call FUNC(recallAllObjectsPlayer));
                };

                class manageSavedCompositions {
                    displayName = "<t color='#006da3'>Manage Saved Compositions</t>";
                    condition = QUOTE((count (profileNamespace getVariable [ARR_2(QQGVAR(saved_compositions),createHashmap)])) > 0);
                    statement = QUOTE([] call FUNC(manageSavedCompositions));
                };

                class Fortifications {
                    displayName = "<t color ='#659157'>Fortifications</t>";
                    condition = "true";
                    statement = "";
                    showDisabled = 0;
                    insertChildren = QUOTE([ARR_2(_this select 0,'Fortifications')] call FUNC(addActions));
                };

                class FOB_Parts {
                    displayName = "<t color ='#bfb7df'>FOB Parts</t>";
                    condition = "true";
                    statement = "";
                    showDisabled = 0;
                    insertChildren = QUOTE([ARR_2(_this select 0,'FOB_Parts')] call FUNC(addActions));
                };

                class Statics {
                    displayName = "<t color ='#e05263'>Statics</t>";
                    condition = "true";
                    statement = "";
                    showDisabled = 0;
                    insertChildren = QUOTE([ARR_2(_this select 0,'Statics')] call FUNC(addActions));
                };

                class Misc {
                    displayName = "<t color ='#ccb885'>Miscellaneous</t>";
                    condition = "true";
                    statement = "";
                    showDisabled = 0;
                    insertChildren = QUOTE([ARR_2(_this select 0,'Misc')] call FUNC(addActions));
                };
            };
        };
    };
    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Default;
            class Combo;
            class Edit;
            class Checkbox;
            class ModuleDescription;
        };
        class ModuleDescription;
    };
    class ACE_Module: Module_F {};
    class GVAR(buildLocationModule): ACE_Module {
        author = AUTHOR;
        category = "MTI_Modules";
        displayName = CSTRING(buildLocationModule);
        scope = 2;
        isGlobal = 1;
        canSetArea = 1;
        function = QFUNC(buildLocationModule);
        class AttributeValues {
            size3[] = {300, 300, -1};
            IsRectangle = 1;
        };
    };

// examples for crates below
/*
    class Slingload_01_Base_F;
    class GVAR(slingload_base): Slingload_01_Base_F {
        scope = 1;
        author = AUTHOR;

        editorCategory = QUOTE(DOUBLES(PREFIX,common));
        editorSubcategory = QUOTE(ADDON);

        disableInventory = 1;

        ace_cargo_canLoad = 1;
		ace_cargo_hasCargo = 1;
		ace_cargo_size = 50;
        ace_cargo_space = 20;

        class VehicleTransport {
            class Cargo {
                parachuteClass = "B_Parachute_02_F";
                parachuteHeightLimit = 5;
                canBeTransported = 1;
                dimensions[] = {"BBox_1_1_pos", "BBox_1_2_pos"};
            };
        };
    };

    class ThingX;
    class ReammoBox_F: ThingX {
        class ACE_Actions;
    };
    class NATO_Box_Base: ReammoBox_F {
        class ACE_Actions: ACE_Actions {
            class ACE_MainActions;
        };
    };
    class GVAR(box_base): NATO_Box_Base {
        scope = 1;
        author = AUTHOR;

        editorCategory = QUOTE(DOUBLES(PREFIX,common));
        editorSubcategory = QUOTE(ADDON);

		ace_cargo_canLoad = 1;
        ace_cargo_size = 2;
        ace_dragging_canCarry = 1;
		ace_dragging_canDrag = 1;
    };

    class GVAR(container_small): GVAR(box_base) {
        scope = 2;
        displayName = "[SOB] Fortify Container (Small Fortifications)";

        model = "lsb_props_containers\props\kyber_box\KyberCrystal_Box.p3d";
        hiddenselections[] = {"Camo1"};
        hiddenselectionstextures[] = {"lsb_props_containers\props\kyber_box\data\KyberCrystal_Box_CO.paa"};

        ace_dragging_dragPosition[] = {0, 1.5, 0};
        ace_dragging_carryPosition[] = {0, 1.5, 0};

        GVAR(availablePresets)[] = {"Fortifications_Small", 1000};
    };

    class GVAR(container_medium): GVAR(box_base) {
        scope = 2;
        displayName = "[SOB] Fortify Container (Medium Fortifications)";

        model = "\3as\3as_props\crates\large_crate.p3d";
		editorPreview = "\3as\3as_props\crates\data\3as_large_crate_prop.jpg";

        ace_cargo_size = 4;
        ace_dragging_canCarry = 0;
        ace_dragging_dragPosition[] = {0, 2, 0};

        GVAR(availablePresets)[] = {"Fortifications_Medium", 1000};
    };

    class GVAR(container_large): GVAR(slingload_base) {
        scope = 2;
        scopeCurator = 2;
        displayName = "[SOB] Fortify Container (Large Fortifications)";

        model = "3as\3as_props\crates\3as_Republic_Container_prop.p3d";
        editorPreview = "\3as\3as_props\crates\data\land_3as_Republic_Container_prop.jpg";

		EGVAR(aircraft,laatc_loadVars) = "[[[-0.2,-4,-5.5]], [0.3], [-0.1]]";
        GVAR(availablePresets)[] = {"Fortifications_Large", 1000,"FOB_HBarrier",1000};
    };

    class GVAR(container_FOB): GVAR(slingload_base) {
        scope = 2;
        scopeCurator = 2;
        displayName = "[SOB] Fortify Container (FOB Parts)";

        model = "\3as\3as_props\crates\Big_Box_1.p3d";
        editorPreview = "3as\3as_props\crates\data\3as_Big_Box_1_prop.jpg";
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {"3as\3as_props\crates\data\DefaultMaterial_co.paa"};
        hiddenSelectionsMaterials[] = {"3as\3as_props\crates\data\Big_Box_1.rvmat"};

		EGVAR(aircraft,laatc_loadVars) = "[[[0,-4,-4.5]], [0.05], [0.3]]";
        GVAR(availablePresets)[] = {"FOB_Walls",1000,"FOB_Objects",250,"LaserWalls",250,"FOB_Decorations_Large",150,"FOB_Decorations_Small",150,"FOB_HBarrier",1000};
    };

    class GVAR(container_BARC): GVAR(slingload_base) {
        scope = 2;
        scopeCurator = 2;
        displayName = "[SOB] Fortify Container (BARC Speeders)";

		model = "\3as\3as_props\crates\Big_Box_2.p3d";
		editorPreview = "3as\3as_props\crates\data\3as_Big_Box_2_prop.jpg";

		EGVAR(aircraft,laatc_loadVars) = "[[[0,-4,-6.5]], [-0.001], [-1.25]]";
        GVAR(availablePresets)[] = {"BARC_Speeders", 250};
    };

    class GVAR(container_saveload): GVAR(slingload_base) {
        scope = 2;
        scopeCurator = 2;
        displayName = "[SOB] Save/Load Container";

        model = "\3as\3as_props\crates\Big_Box_3.p3d";
        editorPreview = "3as\3as_props\crates\data\3as_Big_Box_3_Light_prop.jpg";
        hiddenSelections[] = {"Camo1"};
        hiddenSelectionsTextures[] = {"3as\3as_props\crates\data\Box3Light_co.paa"};

		EGVAR(aircraft,laatc_loadVars) = "[[[0,-4,-5.5]], [-0.001], [0.35]]";
        GVAR(canSave) = 1;
        GVAR(saveMaxBudget) = 3000;
        GVAR(saveRange) = 150;
    };
*/

// example for a FOB Core
/*
    class ls_commandPost_base;
    class ls_commandPost_blue_base: ls_commandPost_base {
        class ACE_Actions;
    };
    class ls_commandPost_republic_blue: ls_commandPost_blue_base {
        class ACE_Actions: ACE_Actions {
            class ACE_MainActions;
        };
    };
    class GVAR(FOB_core): ls_commandPost_republic_blue {
        scope = 1;
        author = AUTHOR;
        displayName = "[SOB] FOB Core";

        GVAR(availablePresets)[] = {"Arsenals", 700};

        class ACE_Actions: ACE_Actions {
            class ACE_MainActions: ACE_MainActions {
                class GVAR(FOB_Controls) {
                    displayName = "FOB Options";
                    condition = QUOTE([_player] call FUNC(canFortify));
                    statement = "";
                    exceptions[] = {};
                    showDisabled = 0;
                    priority = 1;

                    class createMarker {
                        displayName = "<t color='#FFA500'>Create FOB Marker</t>";
                        condition = QUOTE([_player,_target] call FUNC(canCreateFOBMarker));
                        statement = QUOTE([_player,_target] call FUNC(createFOBMarker));
                    };

                    class deleteMarker {
                        displayName = "<t color='#FFFF66'>Delete FOB Marker</t>";
                        condition = QUOTE(!(isNil {_target getVariable QQGVAR(FOBMarker)}));
                        statement = QUOTE([_player,_target] call FUNC(deleteFOBMarker));
                    };
                };
            };
        };
    };
*/

// example for a composition container below
/*
    class 3as_Big_Box_1_prop;
    class GVAR(test_Comp): 3as_Big_Box_1_prop {
        scope = 0;
        displayName = "[SOB] Composition Test Container";
        GVAR(availableCompositions)[] = { "Default","Test" };
        GVAR(compositionBudget) = 4000;

        class ACE_Actions {
            class ACE_MainActions {
                displayName = "Interactions";
                condition = "true";
                distance = 10;
            };
        };
    };
*/
};
