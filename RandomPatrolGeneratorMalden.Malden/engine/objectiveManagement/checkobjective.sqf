#include "..\..\objectGenerator\vehicleManagement.sqf"

_objectivesDestinationArea = _this select 0;

//Obj management
obj_list_items = [];
enableCampaignMode = missionNamespace getVariable "enableCampaignMode"; //Default disable

//Define current test
current_obj = objNull;

missionComplete = false;
RTBComplete = false;
isRTBMissionGenerated = false;
numberOfCompletedObj = 0;
missionLengthParam = missionNamespace getVariable "missionLength"; //Default 2 missions + 1 optional

independantTrigger = createTrigger ["EmptyDetector", _objectivesDestinationArea]; //create a trigger area created at object with variable name my_object
independantTrigger setTriggerArea [60, 60, 0, false]; // trigger area with a radius of 100m.

waitUntil {!isNil "missionGenerated"};
waitUntil {missionGenerated};

bluforTrigger = createTrigger ["EmptyDetector", initBlueforLocation]; //create a trigger area created at object with variable name my_object
bluforTrigger setTriggerArea [100, 100, 0, false]; // trigger area with a radius of 100m.
objectReturnedToCity = [];


[] execVM "engine\respawnManagement\respawnSetup.sqf";


while {sleep 10; !RTBComplete} do
{
	_completedObjectives = missionNamespace getVariable ["completedObjectives",[]];
	_missionObjectives = missionNamespace getVariable ["MissionObjectives",[]];
	_missionFailedObjectives = missionNamespace getVariable ["missionFailedObjectives",[]];

	//Check if the server is setup with only one objective
	if (missionLengthParam == 1) then 
	{
		missionComplete = ((count _completedObjectives) + (count _missionFailedObjectives))  >= count _missionObjectives;
	} else 
	{
		//When there are more than one objective, blufor/independent needs n-1 objective to complete the mission
		missionComplete = ((count _completedObjectives)+ (count _missionFailedObjectives)) + 1 >= count _missionObjectives;
	};
	
	//Check if mission is complete
	if ((missionComplete && !enableCampaignMode)||(count _completedObjectives >= count AllPossibleObjectivePosition)) then 
	{
		//Generate RTB mission
		if (!isRTBMissionGenerated) then
		{
			[true, "taskRTB", ["Return to your initial base or extract  area of operation", "RTB or Extract", ""], objNull, 1, 3, true] call BIS_fnc_taskCreate;
			isRTBMissionGenerated = true;

			extractExtendedTriggerArea = createTrigger ["EmptyDetector", areaOfOperationPosition]; //create a trigger area created at object with variable name my_object
			extractExtendedTriggerArea setTriggerArea [(extendedTriggerArea #0)+500, (extendedTriggerArea #1)+500, 0, true]; // trigger area with a radius of 100m.
			
			//Display area of operation
			[[areaOfOperationPosition,[(extendedTriggerArea #0)+500,(extendedTriggerArea #1)+500]], "engine\objectiveManagement\drawAORectangle.sqf"] remoteExec ['BIS_fnc_execVM', 0, true];
		};

		nbBluePlayer = {alive _x && side _x == blufor} count allPlayers;
		nbIndPlayer = {alive _x && side _x == independent} count allPlayers;
		nbBluePlayerBack = count ((allPlayers select {alive _x && side _x == blufor} ) inAreaArray bluforTrigger); //vehicles (all vehicles) inAreaArray (Returns list of Objects or Positions that are in the area _independantTrigger.)  
		nbIndPlayerBack = count ((allPlayers select {alive _x && side _x == independent} ) inAreaArray independantTrigger);
		nbPlayersNotExtracted = count ((allPlayers select {alive _x}) inAreaArray extractExtendedTriggerArea); 
		if (((floor(nbBluePlayer/2) <= nbBluePlayerBack && floor(nbIndPlayer/2) <= nbIndPlayerBack) && (nbBluePlayerBack != 0 || nbIndPlayerBack != 0)) || 
			((nbPlayersNotExtracted != (nbIndPlayer + nbBluePlayer)) && (nbPlayersNotExtracted <= round((nbIndPlayer+nbBluePlayer)/2)))) then 
		{
			["taskRTB","SUCCEEDED"] call BIS_fnc_taskSetState;
			//Reward player for RTB
			[[50, "RPG_ranking_objective_complete"], "engine\rankManagement\rankUpdater.sqf"] remoteExec ['BIS_fnc_execVM', 0];
			RTBComplete = true;

			//Save current loadout
			if (ironMan) then
			{
				[objNull, "personal"] remoteExec ["saveCustomLoadout", 0, true];
			};
		};
	};
};


diag_log format ["All objectives completed !"];
[['OBJ_OK'], 'engine\objectiveManagement\endMission.sqf'] remoteExec ['BIS_fnc_execVM', 2];

