//Init params
params ["_thisAvailablePosition","_thisTargetPosition","_thisAvailableInfantryGroups","_thisAvailableVehicleGroups","_thisDifficulty"];

currentAttackGroup = objNull;
currentGroup = objNull;
currentPosition = [];
if (isServer) then
{
	_numberOfVehicleSpawned = 0;
	_waveHaveVehicle = round random 1 == 0;
	diag_log format ["Avalaible spawn position %1", _thisAvailablePosition ];
	for [{_k = 0}, {_k < (count _thisAvailablePosition)}, {_k = _k + 1}] do 
	{
		for [{_j = 0}, {_j < 1 + _thisDifficulty}, {_j = _j + 1}] do 
		{
			//Case Infantry
			currentAttackGroup = selectRandom _thisAvailableInfantryGroups;
			currentPosition = selectRandom _thisAvailablePosition;

			//Check distance from nearest player
			//[TEMPHOTFIX] not a clean fix to enemy spawn near player
			_players = allPlayers select {alive _x} apply {[_x distance currentPosition,_x]};
			_players sort true;
			
			if (((_players apply {_x#1})#0) distance currentPosition >= 300) then 
			{
			currentGroup = [([currentPosition,1,60,10,0] call BIS_fnc_findSafePos), east, currentAttackGroup,[],[],[],[],[],0] call BIS_fnc_spawnGroup;
			diag_log format ["Create group : %1 at position %2 and assault to position %3", currentGroup, getPos (leader currentGroup), _thisTargetPosition];

			//Assault for infantry
			[currentGroup, _thisTargetPosition] spawn lambs_wp_fnc_taskAssault;
			[currentGroup, (currentPosition distance _thisTargetPosition) + 500] spawn lambs_wp_fnc_taskHunt;
			currentGroup setFormation "DIAMOND";
			diag_log format ["Group %1 ready to assault", _j ];
			} else 
			{
				diag_log format ["doAmbush : Spawn on %2 near players %1 blocked", getPos ((_players apply {_x#1})#0), currentPosition];
			};


			//Case vehicle
			if (_waveHaveVehicle && count _thisAvailableVehicleGroups != 0 && _numberOfVehicleSpawned<=_thisDifficulty) then 
			{
				currentAttackVehicleGroup = selectRandom _thisAvailableVehicleGroups;
				currentPosition = selectRandom _thisAvailablePosition;

				//Check distance from nearest player
				//[TEMPHOTFIX] not a clean fix to enemy spawn near player
				_players = allPlayers select {alive _x} apply {[_x distance currentPosition,_x]};
				_players sort true;
				
				if (((_players apply {_x#1})#0) distance currentPosition >= 300) then 
				{
					currentVehicleGroup = [([currentPosition,1,60,10,0] call BIS_fnc_findSafePos), east, currentAttackVehicleGroup,[],[],[],[],[],0] call BIS_fnc_spawnGroup;
					diag_log format ["Create group : %1 at position %2 and assault to position %3", currentVehicleGroup, getPos (leader currentVehicleGroup), _thisTargetPosition];

					//Assault for vehicle
					currentVehicleGroup move (_thisTargetPosition);
					currentVehicleGroup setBehaviour "SAFE";
					_numberOfVehicleSpawned = _numberOfVehicleSpawned + 1;
					(vehicle leader currentGroup) limitSpeed 15; //limit speed of vehicle
				} else 
				{
					diag_log format ["doAmbush : Spawn on %1 near players %2 blocked", getPos ((_players apply {_x#1})#0), currentPosition];
				};
			};
		};
	};
};