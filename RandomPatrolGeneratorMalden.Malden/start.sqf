//Init Location functions
#include "engine\searchLocation.sqf"
#include "engine\objectiveManagement\doGenerateObjective.sqf"
#include "database\objectLibrary.sqf"
#include "objectGenerator\vehicleManagement.sqf"
#include "enemyManagement\generationEngine\groupGenerator.sqf"

//Init base mission parameters
enableInitAttack = "EnableInitAttack" call BIS_fnc_getParamValue;
enableInitBluAttack = "EnableInitBluAttack" call BIS_fnc_getParamValue;
initBluforBase = "InitBluforBase" call BIS_fnc_getParamValue;
chooseStartPos = "ChooseStartPos" call BIS_fnc_getParamValue;
timeOfDay = "TimeOfDay" call BIS_fnc_getParamValue;
respawnSettings = "Respawn" call BIS_fnc_getParamValue;
bluforVehicleSpawnType = "BluforVehicleSpawnType" call BIS_fnc_getParamValue;

//Init all environement database variable
_handleEnvironmentInitialization = [] execVM 'initEnvironment.sqf';
waitUntil {isNull _handleEnvironmentInitialization};

//Mission settings waiting
waitUntil {missionNamespace getVariable "generationSetup" == true};

//faction definition
warEra = missionNamespace getVariable "warEra"; // Default actual warfare
bluFaction = missionNamespace getVariable "bluforFaction"; //Default faction 14 -> OTAN 2035
opFaction = missionNamespace getVariable "opforFaction"; //Default faction 3 -> Syndikat
indFaction = missionNamespace getVariable "independentFaction"; //Default faction 3 -> Syndikat
civFaction = missionNamespace getVariable "civilianFaction"; //Default faction 3 -> Syndikat

//Missions vehicle settings
enableArmedAicraft = missionNamespace getVariable "enableArmedAicraft"; //Default armed aircraft are disabled
enableArmoredVehicle = missionNamespace getVariable "enableArmoredVehicle"; //Default armored vehicle are disabled

//Mission configuration
enableCampaignMode = missionNamespace getVariable "enableCampaignMode"; //Default disable
missionLength = missionNamespace getVariable "missionLength"; //Default 2 missions + 1 optional
missionDifficultyParam = missionNamespace getVariable "missionDifficultyParam"; //Default medium
startIntel = missionNamespace getVariable "startIntel"; //Default medium

/////////////////////////
////Setup IA Opti////////
/////////////////////////
enableDynamicSimulationSystem true;
"Group" setDynamicSimulationDistance 1500;
"Vehicle" setDynamicSimulationDistance 2500;
"EmptyVehicle" setDynamicSimulationDistance 1000;



/////////////////////////
//////Find Assets////////
/////////////////////////

//FriendlyGroupDefinition
bluforUnarmedVehicle = bluforUnarmedVehicle_db select {_x select 1  == bluFaction} select 0 select 0;
publicVariable "bluforUnarmedVehicle";

bluforArmedVehicle = bluforArmedVehicle_db select {_x select 1  == bluFaction} select 0 select 0;
publicVariable "bluforArmedVehicle";

bluforUnarmedVehicleChopper = bluforUnarmedVehicleChopper_db select {_x select 1  == bluFaction} select 0 select 0;
publicVariable "bluforUnarmedVehicleChopper";

bluforFixedWing = bluforFixedWing_db select {_x select 1  == bluFaction} select 0 select 0;
publicVariable "bluforFixedWing";

bluforArmedChopper = bluforArmedChopper_db select {_x select 1  == bluFaction} select 0 select 0;
publicVariable "bluforArmedChopper";

bluforDrone = bluforDrone_db select {_x select 1  == bluFaction} select 0 select 0;
publicVariable "bluforDrone";

bluforHQVehicle = bluforHQVehicle_db select {_x select 1  == bluFaction} select 0 select 0;
publicVariable "bluforHQVehicle";

bluforBoat = bluforBoat_db select {_x select 1  == bluFaction} select 0 select 0;
publicVariable "bluforBoat";

bluforMagazineList = magazineList_db select {_x select 1  == bluFaction} select 0 select 0;

//CivilianGroupDefinition
civilian_group = civilian_group_db select {_x select 1  == civFaction} select 0 select 0;
civilian_big_group = civilian_big_group_db select {_x select 1  == civFaction} select 0 select 0;
civilianTruck = civilianTruck_db select {_x select 1  == civFaction} select 0 select 0;

//EnemyGroupDefinition
baseEnemyGroup = baseEnemyGroup_db select {_x select 1  == opFaction} select 0 select 0;
baseEnemyATGroup = baseEnemyATGroup_db select {_x select 1  == opFaction} select 0 select 0;
baseEnemyDemoGroup = baseEnemyDemoGroup_db select {_x select 1  == opFaction} select 0 select 0;
baseEnemyMortarGroup = baseEnemyMortarGroup_db select {_x select 1  == opFaction} select 0 select 0;
baseEnemyVehicleGroup = baseEnemyVehicleGroup_db select {_x select 1  == opFaction} select 0 select 0;
baseEnemyLightArmoredVehicleGroup = baseEnemyLightArmoredVehicleGroup_db select {_x select 1  == opFaction} select 0 select 0;
baseEnemyHeavyArmoredVehicleGroup = baseEnemyHeavyArmoredVehicleGroup_db select {_x select 1  == opFaction} select 0 select 0;

//Enemy Wave Composition, needs to be completely rework
EnemyWaveLevel_1 = [baseEnemyGroup,baseEnemyATGroup];
EnemyWaveLevel_6 = [baseEnemyGroup,baseEnemyATGroup,baseEnemyDemoGroup];
EnemyWaveLevel_8 = [baseEnemyGroup,baseEnemyATGroup,baseEnemyDemoGroup,baseEnemyMortarGroup];

EnemyWaveGroups = [EnemyWaveLevel_1,EnemyWaveLevel_6,EnemyWaveLevel_8];
publicvariable "EnemyWaveGroups";

///////////////////////////
///Define player settings//
///////////////////////////

//Clean area WIP
waitUntil {count allPlayers != 0};

//Determine main player side
_mainPlayerSide = blufor;
if ({isPlayer _x && side _x == independent} count allPlayers != 0) then
{
	_mainPlayerSide = independent;
};

/////////////////////////
/////Find locations//////
/////////////////////////

initCityLocationPosition = objNull;
publicVariable "initCityLocationPosition";
initBlueforLocationPosition = objNull;
publicVariable "initBlueforLocationPosition";


switch (chooseStartPos) do
{
	case 1:
		{
			//If independent are avalaible server is waiting for independent init position
			if (_mainPlayerSide == independent) then
			{
				waitUntil {initCityLocationPosition isEqualType []};
			};

			//Wait for blufor leader to choose a start position
			if ({isPlayer _x && side _x == blufor} count allUnits != 0) then
			{
				waitUntil {initBlueforLocationPosition isEqualType []};
			};
		};
	default
		{
			//Do nothing
		};
};



//Initilize independent starting position
if (initCityLocationPosition isEqualType []) then
{

	if (!([initCityLocationPosition, [0,0,0]] call BIS_fnc_areEqual)) then
	{
		_nearestCity = nearestLocations [initCityLocationPosition, ["NameLocal","NameVillage","NameCity","NameCityCapital"], 1500] select 0;
		initCityLocation = _nearestCity;
	};
}  else
{
	//Select a random position
	possibleInitLocation = [] call getRandomCenterLocations;
	initCityLocation = selectRandom possibleInitLocation;
};

publicvariable "initCityLocation";
possiblePOILocation = ([initCityLocation, 3000] call getLocationsAroundWithBuilding) - [initCityLocation];
dangerAreaList = [];

if ( count possiblePOILocation < missionLength + 1) then
{
	possiblePOILocation = ([initCityLocation, 5000] call getLocationsAroundWithBuilding) - [initCityLocation];
};

//Search road around AO
possibleAmbushPosition = [];
tempPossibleAmbush = [];
currentAO = objNull;
_distance = 0;
{
	currentAO = _x;
	tempPossibleAmbush = (getPos _x) nearRoads 750;
	{
		_distance = (getPos _x) distance (getPos currentAO);
		if (350<_distance && _distance<750) then	//Il faudrait tester si ce n'est pas trop près des villes adjacentes
		{
			possibleAmbushPosition pushBack _x;
		};
	}
	foreach tempPossibleAmbush;
} foreach possiblePOILocation;

numberOfAmbush = (missionLength+1)*4;
AmbushPositions = [];
for [{_i = 0}, {_i < numberOfAmbush}, {_i = _i + 1}] do
{
	AmbushPositions pushBack (selectRandom possibleAmbushPosition);
	possibleAmbushPosition = possibleAmbushPosition - [AmbushPositions select ((count AmbushPositions)-1)];
};
PossibleObjectivePosition = possiblePOILocation;

for [{_i = 0}, {_i <= 2}, {_i = _i + 1}] do //Peut être optimisé
{
	_currentTruckType = selectRandom civilianTruck;
	_currentTruckPosition = [getPos initCityLocation, 2, 100, 10, 10, 0.25, 0, [], [[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
	if !([_currentTruckPosition , [0,0,0]] call BIS_fnc_areEqual) then
	{
		_currentTruck = createVehicle [_currentTruckType, _currentTruckPosition, [], 0, "NONE"];
	};
};

/////////////////////////
///Generate Objectives///
/////////////////////////

//Define 3 objectives
SupplyPositions = [];
SelectedObjectivePosition = objNull;
SupplyObjects = [];
currentObjType = nil;
currentRandomPos = [];
currentObj = objNull;
currentRandObj = objNull;

//Generate objectives according to the mission's length parameter
for [{_i = 0}, {_i <= missionLength min(count PossibleObjectivePosition)}, {_i = _i + 1}] do //Peut être optimisé
{
	PossibleObjectivePosition = [avalaibleTypeOfObj, PossibleObjectivePosition, missionDifficultyParam] call generateObjective;
};

//check wave spawn
EnemyWaveSpawnPositions = [];
numberOfSpawnWave = 4;
possibleEnemyWaveSpawnPositions = (([initCityLocation, 2000] call getLocationsAroundWithBuilding) - [initCityLocation]) - SupplyPositions;

for [{_i = 0}, {_i < numberOfSpawnWave}, {_i = _i + 1}] do
{
	EnemyWaveSpawnPositions pushBack (getPos (selectRandom possibleEnemyWaveSpawnPositions));
};


//Init checkobjective
[SelectedObjectives, initCityLocation] execVM 'engine\objectiveManagement\checkobjective.sqf';


/////////////////////////
////Generate Civ/////////
/////////////////////////

//IA civilian taskGarrison
diag_log format ["Begin generation of civilian AO : %1 on position %2", civilian_big_group, initCityLocation];
currentCivGroup = objNull;
civsGroup = [];
for [{_i = 0}, {_i <= 2}, {_i = _i + 1}] do
{
	currentCivGroup = [civilian_big_group, ((getPos initCityLocation) findEmptyPosition [5, 60]), civilian, "Civilian"] call doGenerateEnemyGroup;
	civsGroup pushBack currentCivGroup;
	diag_log format ["Generation of civilian group : %1 on position %2 has been completed", currentCivGroup, initCityLocation];
};

//Garrison or camp every civ group
{
	[_x, getPos (leader _x), 80, true] execVM 'enemyManagement\behaviorEngine\doGarrison.sqf';
} foreach civsGroup;


//Init VA
VA1 = createVehicle ["Box_IND_Wps_F", [getPos initCityLocation, 1, 10, 3, 0, 20, 0] call BIS_fnc_findSafePos, [], 0, "NONE"];
clearWeaponCargoGlobal VA1;
clearMagazineCargoGlobal VA1;
clearItemCargoGlobal VA1;
clearBackpackCargoGlobal VA1;
VA1 allowDamage false;
publicvariable "VA1";

/////////////////////////
////Generate Ind/////////
/////////////////////////

//Init attack management on ind
isIndAttacked = false;
publicvariable "isIndAttacked";
AvalaibleInitAttackPositions = [];
AvalaibleInitAttackPositions = [getPos initCityLocation, 1200,1400, missionDifficultyParam] call getListOfPositionsAroundTarget;
if ( count AvalaibleInitAttackPositions != 0 && (enableInitAttack == 1 || ((enableInitAttack == 2) && (round (random 1))==0))) then
{
	diag_log "Init attack on independent city";
	_handleCivGeneration = [AvalaibleInitAttackPositions,getPos initCityLocation,[baseEnemyGroup,baseEnemyATGroup],baseEnemyVehicleGroup, missionDifficultyParam] execVM 'enemyManagement\behaviorEngine\doAmbush.sqf';
	isIndAttacked = true;
	publicvariable "isIndAttacked";
	waitUntil {isNull _handleCivGeneration};
};

//Generate items on VA1 box
if (isClass (configFile >> "CfgPatches" >> "ace_medical")) then
{
	VA1 addItemCargoGlobal ["ACE_key_indp", 5];
};

//Init perma harass on player
[[baseEnemyGroup,baseEnemyATGroup,baseEnemyDemoGroup],baseEnemyVehicleGroup, baseEnemyLightArmoredVehicleGroup, baseEnemyHeavyArmoredVehicleGroup, missionDifficultyParam] execVM 'enemyManagement\generationEngine\generateHarass.sqf';

// Get smallest distance to an AO
areaOfOperation = [possiblePOILocation] call getAreaOfMission;
aoSize = 1500;

/////////////////////////
////Generate Blufor//////
/////////////////////////

//Init
selectedBluforVehicle =[];
selectedBluforAirDroneVehicle = [];
vehicleGoodPosition = [];
initBlueforLocation = [0,0,0];
bluforShortFrequencyTFAR = (((round random 400)+400)/10);
publicvariable "bluforShortFrequencyTFAR";

//Initilize blufor starting position
//Generate blufor FOB Location
if (initBlueforLocationPosition isEqualType []) then
{
	if (!([initBlueforLocationPosition, [0,0,0]] call BIS_fnc_areEqual)) then
	{
		diag_log format ["test0 : %1", initBlueforLocationPosition];
		initBlueforLocation = initBlueforLocationPosition;
	};
};

//TODO create the random option
if (initBluforBase == 0 || (initBluforBase == 2 && (round random 1 == 0))) then
{
	//Check if position is already determine by player
	if ([initBlueforLocation, [0,0,0]] call BIS_fnc_areEqual) then
	{
		initBlueforLocation = [getPos initCityLocation, (aoSize+400), (aoSize+700), 3, 0, 0.25, 0, [areaOfOperation], [[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
		if ([initBlueforLocation , [0,0,0]] call BIS_fnc_areEqual) then
		{
			initBlueforLocation = [getPos initCityLocation, (aoSize+400), (aoSize+1500), 3, 0, 0.25, 0, [areaOfOperation], [[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
		};

		//Safe position
		initBlueforLocation = [selectMax [selectMin [initBlueforLocation select 0, worldSize-50 ],50],selectMax [selectMin [initBlueforLocation select 1, worldSize-50],50]];
	};
	diag_log format ["test0 : %1", initBlueforLocation];

	//Generate FOB
	spawnFOBObjects = [initBlueforLocation, (random 360), selectRandom avalaibleFOB] call BIS_fnc_ObjectsMapper;
	sleep 3;

	initBlueforLocation = getPos (spawnFOBObjects select 0);
	publicvariable "initBlueforLocation";
	waitUntil {!isNil "spawnFOBObjects"};
} else
{
	//Check if position is already determine by player
	if ([initBlueforLocation, [0,0,0]] call BIS_fnc_areEqual) then
	{
		initBlueforLocation = [getPos initCityLocation, (aoSize+2000), (aoSize+4000), 3, 0, 0.25, 0, [areaOfOperation], [[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
		//Safe position
		initBlueforLocation = [selectMax [selectMin [initBlueforLocation select 0, worldSize-100 ],100],selectMax [selectMin [initBlueforLocation select 1, worldSize-100],100]];
	};
	//Generate FOB
	spawnFOBObjects = [initBlueforLocation, (random 360), selectRandom avalaibleFOB] call BIS_fnc_ObjectsMapper;
	sleep 3;

	initBlueforLocation = getPos (spawnFOBObjects select 0);
	publicvariable "initBlueforLocation";
	waitUntil {!isNil "spawnFOBObjects"};

	//Generate air vehicle
	if (bluforVehicleSpawnType == 1) then
	{
		if (0 < count bluforUnarmedVehicleChopper ) then
		{
			for [{_i = 0}, {_i < 2}, {_i = _i + 1}] do
			{
				selectedBluforVehicle pushBack [(selectRandom bluforUnarmedVehicleChopper), false];
			};
		};
	};

    //Generate air drone vehicle
	if (0 < count bluforDrone ) then
	{
		selectedBluforVehicle pushBack [(selectRandom bluforDrone), true];
	};
};
[["FOB","ColorBlue","loc_Fortress",initBlueforLocation, blufor], 'objectGenerator\doGenerateMarker.sqf'] remoteExec ['BIS_fnc_execVM', 0];

//Clean area WIP
[initBlueforLocation, 150] execVM 'objectGenerator\doCleanArea.sqf';

//Generate ground vehicle
vehicleGoodPosition = [];
if (0 < count bluforUnarmedVehicle ) then
{
	for [{_i = 0}, {_i < 3}, {_i = _i + 1}] do
	{
		selectedBluforVehicle pushBack [(selectRandom bluforUnarmedVehicle), false];
	};
};


if (bluforVehicleSpawnType == 1) then
{
	if (0 < count bluforArmedVehicle ) then
	{
		for [{_i = 0}, {_i < 1}, {_i = _i + 1}] do
		{
			selectedBluforVehicle pushBack [(selectRandom bluforArmedVehicle), false];
		};
	};
};

//Generate Boat
if (0 < count bluforBoat ) then
{
	for [{_i = 0}, {_i < 3}, {_i = _i + 1}] do
	{
		selectedBluforVehicle pushBack [(selectRandom bluforBoat), false];
	};
};


//Generate all vehicles
diag_log format ["Generating blufor vehicle : %1",selectedBluforVehicle];
_spawnedVehicle = [initBlueforLocation, selectedBluforVehicle, 30, 100] call doGenerateVehicleForFOB;
diag_log format ["Generating blufor vehicle spawned : %1", _spawnedVehicle];
//TODO: get each vehicule and set the lock parameter to LOCKED;

//HQ Vehicle spawn
if (count bluforHQVehicle >0) then
{
	//Spawn one HQ vehicle at bluforFOB
	_bluforHQVehicleSpawned = ([initBlueforLocation, [[selectRandom bluforHQVehicle, false]], 30, 100] call doGenerateVehicleForFOB);
	diag_log format ["Generating blufor HQ vehicle spawned : %1", _bluforHQVehicleSpawned];
	if (count _bluforHQVehicleSpawned >0) then
	{
		// //Change vehicle name
		createVehicle ["Flag_Blue_F", getPos (_bluforHQVehicleSpawned select 0) , [], 0, "NONE"];
		bluforMobileHQ = _bluforHQVehicleSpawned select 0;
		publicVariable "bluforMobileHQ";
	};
};


//Init VA
VA2 = createVehicle ["Box_NATO_WpsSpecial_F", [initBlueforLocation, 1, 10, 3, 0, 20, 0] call BIS_fnc_findSafePos, [], 0, "NONE"];
clearWeaponCargoGlobal VA2;
clearMagazineCargoGlobal VA2;
clearItemCargoGlobal VA2;
clearBackpackCargoGlobal VA2;
VA2 allowDamage false;
publicvariable "VA2";

//Create portable FOB
deployableFOBItem = createVehicle [deployableFOB, [initBlueforLocation, 20, 50, 3, 0, 20, 0] call BIS_fnc_findSafePos, [], 0, "NONE"];
clearWeaponCargoGlobal deployableFOBItem;
clearMagazineCargoGlobal deployableFOBItem;
clearItemCargoGlobal deployableFOBItem;
clearBackpackCargoGlobal deployableFOBItem;
deployableFOBItem allowDamage false;
publicvariable "deployableFOBItem";

//Add action to deploy advanced outpost
[
	deployableFOBItem,
	"Deploy advanced FOB",
	"\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\repair_ca.paa",
	"\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\repair_ca.paa",
	"true",
	"true",
	{
		// Action start code
	},
	{
		// Action on going code
	},
	{
		// Action successfull code
		params ["_object","_caller","_ID","_param"];
		_avalaibleOutpost = _param select 0;
		_respawnSetting = _param select 1;

		//[TODO] Check distance from blufor spawn
		if (_caller distance initBlueforLocation > 100) then
		{
			//Spawn outpost
			_spawnFOBObjects = [getPos _object, (random 360), _avalaibleOutpost] call BIS_fnc_ObjectsMapper;

			TPFlag2 = createVehicle ["Flag_Blue_F", [getPos _object, 1, 10, 3, 0, 20, 0] call BIS_fnc_findSafePos, [], 0, "NONE"];

			missionNamespace setVariable ["advancedBlueforLocation", getPos TPFlag2, true];

			//Add action to rest and skip 6 hours
			[TPFlag2, ["Take a nap",{
				params ["_object","_caller","_ID","_param"];

				if (!(missionNamespace getVariable ["usedFewTimeAgo",false])) then
				{
					//Skip 6 hour
					6 remoteExec ["skipTime", 2, false];
					[format ["%1 needs to rest", name _caller]] remoteExec ["hint",0,true];
					missionNamespace setVariable ["usedFewTimeAgo",true,true];
					sleep 300;
					missionNamespace setVariable ["usedFewTimeAgo",false,true];
				} else {
					hint "No need to rest";
				};
			},objNull,1.5,true,false,"","_target distance _this <5"]] remoteExec [ "addAction", 0, true ];

			//Add action to rest until morning
			[TPFlag2, ["Sleep until next morning",{
				params ["_object","_caller","_ID","_param"];

				if (!(missionNamespace getVariable ["usedFewTimeAgo",false])) then
				{
					//set morning
					skipTime ((06 - dayTime + 24) % 24);
					[format ["%1 needs to rest", name _caller]] remoteExec ["hint",0,true];
					missionNamespace setVariable ["usedFewTimeAgo",true,true];
					sleep 300;
					missionNamespace setVariable ["usedFewTimeAgo",false,true];
				} else {
					hint "No need to rest";
				};
			},objNull,1.5,true,false,"","_target distance _this <5"]] remoteExec [ "addAction", 0, true ];

			//Add action to make all player respawn
			if (_respawnSetting == 1) then
			{
				[TPFlag2, ["Call Reinforcements",{
					params ["_object","_caller","_ID","_param"];

					if (!(missionNamespace getVariable ["usedRespawnFewTimeAgo",false])) then
					{
						//set morning
						skipTime 24;
						[[], "engine\respawnManagement\respawnManager.sqf"] remoteExec ['BIS_fnc_execVM', 0];
						[format ["%1 needs reinforcement", name _caller]] remoteExec ["hint",0,true];
						missionNamespace setVariable ["usedRespawnFewTimeAgo",true,true];
						sleep 1200;
						missionNamespace setVariable ["usedRespawnFewTimeAgo",false,true];
					} else {
						hint "You must wait before call reinforcements";
					};
				},[_respawnSetting],1.5,true,false,"","_target distance _this <5"]] remoteExec [ "addAction", 0, true ];
			};

			//Remove Box
			deleteVehicle _object;
		} else {
			hint "Too close to base";
		};
	},
	{
		// Action failed code
	},
	[deployableFOBMounted, respawnSettings],
	10,
	0,
	true,
	false
] remoteExec ["BIS_fnc_holdActionAdd", 0, true];

//Place empty box to blufor camp
{
	_tempBox = createVehicle [_x, [ initBlueforLocation, 1, 15, 2, 0, 20, 0] call BIS_fnc_findSafePos, [], 0, "NONE"];
	clearWeaponCargoGlobal _tempBox;
	clearMagazineCargoGlobal _tempBox;
	clearItemCargoGlobal _tempBox;
	clearBackpackCargoGlobal _tempBox;
} foreach ["Box_NATO_Grenades_F"];

//Place a box with ammo to blufor camp
{
	_tempBox = createVehicle [_x, [ initBlueforLocation, 1, 15, 2, 0, 20, 0] call BIS_fnc_findSafePos, [], 0, "NONE"];
	clearWeaponCargoGlobal _tempBox;
	clearMagazineCargoGlobal _tempBox;
	clearItemCargoGlobal _tempBox;
	clearBackpackCargoGlobal _tempBox;

	//Add magazines according to avalaible magazine in the faction
	{
		_tempBox addItemCargoGlobal [_x, 20];
	}	foreach bluforMagazineList;
} foreach ["Box_NATO_Uniforms_F"];

//Place empty box with ACE medical stuff
_tempBox = createVehicle ["Box_NATO_Equip_F", [ initBlueforLocation, 1, 15, 2, 0, 20, 0] call BIS_fnc_findSafePos, [], 0, "NONE"];
clearWeaponCargoGlobal _tempBox;
clearMagazineCargoGlobal _tempBox;
clearItemCargoGlobal _tempBox;
clearBackpackCargoGlobal _tempBox;

//Check if ACE is enable on the server
if (isClass (configFile >> "CfgPatches" >> "ace_medical")) then
{
	//Setup medic ACE box
	_tempBox addItemCargoGlobal ["ACE_surgicalKit", 1];
	_tempBox addItemCargoGlobal ["ACE_epinephrine", 10];
	_tempBox addItemCargoGlobal ["ACE_splint", 10];
	_tempBox addItemCargoGlobal ["ACE_elasticBandage", 50];
	_tempBox addItemCargoGlobal ["ACE_quikclot", 50];
	_tempBox addItemCargoGlobal ["ACE_morphine", 10];
	_tempBox addItemCargoGlobal ["ACE_bloodIV_500", 10];
	_tempBox addItemCargoGlobal ["ACE_bloodIV", 5];
	_tempBox addItemCargoGlobal ["ACE_tourniquet", 5];

	//Add keys to the box
	_tempBox addItemCargoGlobal ["ACE_key_west", 5];

	//Setup fortification ACE mod
	[blufor, 150, [["Land_BagFence_Long_F", 20], ["Land_BagBunker_Small_F", 50]]] call ace_fortify_fnc_registerObjects;
};

//Setup view distance changer
SettingsComputer =  createVehicle ["Land_MultiScreenComputer_01_olive_F", [initBlueforLocation, 1, 10, 3, 0, 20, 0] call BIS_fnc_findSafePos, [], 0, "NONE"];
{
	[SettingsComputer, [format ["Set view distance to %1",_x],{
				params ["_object","_caller","_ID","_viewDistance"];
				//Select ViewDistance
				setViewDistance _viewDistance;
			},_x,1.5,true,true,"","_target distance _this <5"]] remoteExec ["addAction", 0, true];
} foreach [-1,300,500,1000,1500,2000,2500];

TPFlag1 = createVehicle ["Flag_Blue_F", [initBlueforLocation, 1, 10, 3, 0, 20, 0] call BIS_fnc_findSafePos, [], 0, "NONE"];
publicvariable "TPFlag1";

//Add action to make all player respawn
if (respawnSettings == 1) then
{
	[TPFlag1, ["Call Reinforcements",{
		params ["_object","_caller","_ID","_param"];

		if (!(missionNamespace getVariable ["usedRespawnFewTimeAgo",false])) then
		{
			//set morning
			skipTime 24;
			[[], "engine\respawnManagement\respawnManager.sqf"] remoteExec ['BIS_fnc_execVM', 0];
			[format ["%1 needs reinforcement", name _caller]] remoteExec ["hint",0,true];
			missionNamespace setVariable ["usedRespawnFewTimeAgo",true,true];
			sleep 1200;
			missionNamespace setVariable ["usedRespawnFewTimeAgo",false,true];
		} else {
			hint "You must wait before call reinforcements";
		};
	},[respawnSettings],1.5,true,false,"","_target distance _this <5"]] remoteExec [ "addAction", 0, true ];
};


//Setup random attack on blufor at the beginning
isBluforAttacked = false;
publicvariable "isBluforAttacked";

AvalaibleInitAttackPositions = [];
AvalaibleInitAttackPositions = [initBlueforLocation, 800,1000, missionDifficultyParam] call getListOfPositionsAroundTarget;
if ( count AvalaibleInitAttackPositions != 0 && (enableInitBluAttack == 1 || ((enableInitBluAttack == 2) && (round (random 4))==0))) then
{
	diag_log "Init attack on blufor FOB";
	[AvalaibleInitAttackPositions,initBlueforLocation,[baseEnemyGroup,baseEnemyATGroup],baseEnemyVehicleGroup, missionDifficultyParam] execVM 'enemyManagement\behaviorEngine\doAmbush.sqf';
	isBluforAttacked = true;
	publicvariable "isBluforAttacked";
};

/////////////////////////
///////Generate Opfor///////
/////////////////////////
//IA taskPatrol with level 1 enemy
[EnemyWaveLevel_1,AmbushPositions, missionDifficultyParam] execVM 'enemyManagement\generationEngine\generatePatrol.sqf';

//Generate Wave
if (1 <= (count EnemyWaveSpawnPositions)) then
{
	[EnemyWaveGroups,EnemyWaveSpawnPositions,initCityLocation, missionDifficultyParam] execVM 'enemyManagement\generationEngine\generateWave.sqf';
};

//Generate mortar | 50% chance to spawn
if ((round (random 1))==0 ) then
{
	for [{_i = 0}, {_i < 2}, {_i = _i + 1}] do
	{
		_mortarSpawnPosition = [getPos initCityLocation, (800), (aoSize+700), 3, 10, 0.25, 0, [], [[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
		if !([_mortarSpawnPosition , [0,0,0]] call BIS_fnc_areEqual) then
		{
			_mortarGroup = [baseEnemyMortarGroup, _mortarSpawnPosition, east, "Mortar"] call doGenerateEnemyGroup;
		};
	};
};


for [{_i = 0}, {_i <= missionLength}, {_i = _i + 1}] do //Peut être optimisé
{
	[] execVM 'enemyManagement\generationEngine\generateOpforFOB.sqf';
};



////////////////////////////
///// MissionInitSetup /////
////////////////////////////

//Case where blufor has objective on start

switch (startIntel) do
{
	case 1:
		{
			//Setup init Civ city
			//Init task for blufor to get informations
			[blufor, "taskContactCiv", [format ["Contact civilians at %1 to get tasks", text initCityLocation], "Contact civilians", ""], objNull, 1, 3, true] call BIS_fnc_taskCreate;
			initCityLocationTrigger = createTrigger ["EmptyDetector", getPos initCityLocation]; //create a trigger area created at object with variable name my_object
			initCityLocationTrigger setTriggerArea [100, 100, 0, false]; // trigger area with a radius of 100m.

			//Setup task completion
			[] spawn {
				_hasContactCivilian = false;
				while {sleep 10; !_hasContactCivilian} do
				{
					if (count((allPlayers select {alive _x && side _x == blufor && _x getVariable "isDead" == false} ) inAreaArray initCityLocationTrigger) >0) then
					{
						_hasContactCivilian = true;
						["taskContactCiv","SUCCEEDED"] call BIS_fnc_taskSetState;
					};
				};
			};
		};
	case 2:
		{
			for [{_i = 0}, {_i <= missionLength}, {_i = _i + 1}] do //Peut être optimisé
			{
				[objNull, [], _mainPlayerSide] execVM 'engine\objectiveManagement\revealObjective.sqf';
			};
		};
	default
		{
			//
		};
};

//reveal objective for ind
if (_mainPlayerSide == independent) then
{
		for [{_i = 0}, {_i <= missionLength}, {_i = _i + 1}] do //Peut être optimisé
	{
		[objNull, [], _mainPlayerSide] execVM 'engine\objectiveManagement\revealObjective.sqf';
	};
};


//Init garbage collector
[] execVM 'engine\garbageCollector.sqf';

//Disable respawn for IA Unit
{
	_x addMPEventHandler ["MPRespawn", {
		_unit = _this select 0;
		if (!isPlayer _unit) exitWith {
			deleteVehicle _unit;
		};
	}
];
} forEach playableUnits;

//Setup weather and time
switch (timeOfDay) do
{
	case 1:
		{
			//set morning
			skipTime ((06 - dayTime + 24) % 24);
		};
	case 2:
		{
			//set day
			skipTime ((12 - dayTime + 24) % 24);
		};
	case 3:
		{
			//set afternoon
			skipTime ((18 - dayTime + 24) % 24);
		};
	case 4:
		{
			//set night
			skipTime ((00 - dayTime + 24) % 24);
		};
	default
		{
			//set random time
			skipTime ((round (random (24)) - dayTime + 24) % 24);
		};
};



//Init checkdeath
[] execVM 'engine\checkdeath.sqf';

missionGenerated = true;
publicvariable "missionGenerated";



/////////////////////////
///Init Campaign mode////
/////////////////////////

if (enableCampaignMode) then
{
	//Init mission objective status
	_completedObjectives = missionNamespace getVariable ["completedObjectives",[]];
	_objectiveCompletedCounter = count _completedObjectives;
	_maxObjectivesGenerated = false;

	//Add this action on campaign mode blufor side
	[TPFlag1, ["Complete mission",{
			//Param initialization
			params ["_object","_caller","_ID","_missionLength"];
			_completedObjectives = missionNamespace getVariable ["completedObjectives",[]];

			//End mission
			if (_missionLength <= (count _completedObjectives)) then
			{
				if (isMultiplayer) then {
					['OBJ_OK'] remoteExec ["BIS_fnc_endMissionServer", 2];
				} else {
					['OBJ_OK'] remoteExec ["BIS_fnc_endMission", 2];
				};
			} else
			{
				hint "Not enough mission completed";
			};
		},missionLength,1.5,true,true,"","_target distance _this <5"]] remoteExec ["addAction", 0, true];

	//Add this action on campaign mode independent side
	[VA1, ["Complete mission",{
			//Param initialization
			params ["_object","_caller","_ID","_missionLength"];
			_completedObjectives = missionNamespace getVariable ["completedObjectives",[]];

			//End mission
			if (_missionLength <= (count _completedObjectives)) then
			{
				if (isMultiplayer) then {
					['OBJ_OK'] remoteExec ["BIS_fnc_endMissionServer", 2];
				} else {
					['OBJ_OK'] remoteExec ["BIS_fnc_endMission", 2];
				};
			} else
			{
				hint "Not enough mission completed";
			};
		},missionLength,1.5,true,true,"","_target distance _this <5"]] remoteExec ["addAction", 0, true];

	//Loop until maximum number of possible objective are generated
	while {sleep 10; (!_maxObjectivesGenerated)} do
	{
		//Is an objective been completed ?
		if (_objectiveCompletedCounter == (count (missionNamespace getVariable ["completedObjectives",[]]))) then
		{
			//Do nothing
			sleep 30;

		} else
		{
			//Generate the new objective
			PossibleObjectivePosition = [avalaibleTypeOfObj, PossibleObjectivePosition, missionDifficultyParam] call generateObjective;

			//Reveal objective to the player
			if (startIntel == 2) then
			{
				[objNull, [], _mainPlayerSide] execVM 'engine\objectiveManagement\revealObjective.sqf';
			};

			//Update objective complete counter
			_completedObjectives = missionNamespace getVariable ["completedObjectives",[]];
			_objectiveCompletedCounter = count _completedObjectives;
		};


		//Check if there is always avalaible position for new objective
		_maxObjectivesGenerated = (count PossibleObjectivePosition) == 0;
	};
};