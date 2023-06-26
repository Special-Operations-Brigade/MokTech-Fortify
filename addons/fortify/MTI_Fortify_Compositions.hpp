/*
Containers can contain deployable compositions in addition to Fortify presets.
Compositions are pre-made collections of object that can be deployed to rapidly construct FOBs and Outposts.
A container's Fortify budget and Composition budget are separate. The following settings need to be define in container's config:

(begin example)
    class MTI_Fortify_Compositions {
        class Default;
        class Example_Composition: Default {
            scope = 1;
            displayName = "My Example Composition";
            file = "my_composition.sqf";
            cost = 250;
            createMarker = 1;
            markerType = "b_hq";
            markerColor = "ColorOrange";
        };
    };

    class CfgVehicles {
        class My_Container {
            //....
            mti_fortify_availableCompositions[] = { "Example_Composition" };
            mti_fortify_compositionBudget = 2500;
        };
    };
(end example)

Compositions can also be defined in missionConfigFile (through description.ext). If missionConfig and addonConfig both contain a class of the same name, the one from missionConfig will be used.

Using setVariable, any object can be made into a container through means of scripting. The relevant variables to set are outlined below. Please note that using setVariable OVERWRITES the container settings found in config!

(begin example)
    // let _this be an object
    _this setVariable ["mti_fortify_availableCompositions", ["Example_Composition"], true];
    _this setVariable ["mti_fortify_compositionBudget", 2500, true];
(end example)
*/
class GVAR(compositions) {
    class Default {
        scope = 0;                  // controls visibility of the composition, scope > 0 makes it visible
        displayName = "";           // the name of the composition, displayed in the fortify interaction menu
        file = "";                  // points to the file that contains the actual composition data (in sqf format)
        cost = 0;                   // total cost of the composition, subtracted from the container's max composition budget
        createMarker = 0;           // Controls whether a marker should be created upon deploy
        markerType = "hd_flag";     // type of marker (from CfgMarkers) to use for this composition [see: https://community.bistudio.com/wiki/Arma_3:_CfgMarkers]
        markerColor = "ColorBlack"; // colour of marker (from CfgMarkerColors) to use for this composition [see: https://community.bistudio.com/wiki/Arma_3:_CfgMarkerColors]
    };
/*
    class Test: Default {
        scope = 1;
        displayName = "Test Composition";
        file = QPATHTOF(compositions\test_composition.sqf);
        cost = 100;
        createMarker = 1;
        markerType = "b_hq";
        markerColor = "ColorOrange";
    };
*/
};
