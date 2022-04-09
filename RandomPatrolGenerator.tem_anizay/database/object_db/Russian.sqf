c_leader = "leader";
c_at = "at";
c_rifleman = "rifleman";
c_engineer = "engineer";
c_autorifleman = "autorifleman";
c_marksman = "marksman"; 
c_medic = "medic";



//////////////////////////////
///Define enemy group data////
//////////////////////////////
//Russian
baseEnemyGroup_Russian  = ["CUP_O_RU_Soldier_SL_M_EMR_V2", 
"CUP_O_RU_Soldier_M_EMR_V2", 
"CUP_O_RU_Soldier_LAT_M_EMR_V2", 
"CUP_O_RU_Soldier_MG_M_EMR_V2", 
"CUP_O_RU_Soldier_TL_M_EMR_V2", 
"CUP_O_RU_Soldier_AR_M_EMR_V2", 
"CUP_O_RU_Soldier_A_M_EMR_V2", 
"CUP_O_RU_Soldier_Medic_M_EMR_V2"];

baseEnemyATGroup_Russian  = ["CUP_O_RU_Soldier_TL_M_EMR_V2", 
"CUP_O_RU_Soldier_AT_M_EMR_V2", 
"CUP_O_RU_Soldier_AAT_M_EMR_V2",
"CUP_O_RU_Soldier_AT_M_EMR_V2"];

baseEnemyDemoGroup_Russian  = ["CUP_O_RU_Soldier_TL_M_EMR_V2", 
"CUP_O_RU_Soldier_HAT_M_EMR_V2", 
"CUP_O_RU_Soldier_AHAT_M_EMR_V2",
"CUP_O_RU_Soldier_AHAT_M_EMR_V2"];

baseEnemyMortarGroup_Russian  = ["CUP_O_2b14_82mm_RU_M_MSV",
"CUP_O_RU_Soldier_MG_M_EMR_V2", 
"CUP_O_RU_Soldier_TL_M_EMR_V2"];

baseEnemyVehicle_Russian  = ["CUP_O_UAZ_MG_RU",
"CUP_O_UAZ_SPG9_RU"];

////////////////////////
//Vehicle management////
////////////////////////
//Russian
bluforUnarmedVehicle_Russian = ["CUP_O_UAZ_Unarmed_RU", 
"CUP_O_GAZ_Vodnik_Unarmed_RU"];

bluforArmedVehicle_Russian = ["CUP_O_GAZ_Vodnik_PK_RU", 
"CUP_O_UAZ_MG_RU"];

bluforUnarmedVehicleChopper_Russian = ["CUP_O_Mi8AMT_RU"];


bluforDrone_Russian = [
];

bluforBoat_Russian = ["CUP_O_PBX_RU"
];

////////////////////////
//Loadout management////
////////////////////////

//Russian
loadout_Russian = [		
	[c_leader,"CUP_O_RU_Soldier_TL_Ratnik_Summer"],
	[c_at,"CUP_O_RU_Soldier_HAT_Ratnik_Summer" ],
	[c_rifleman,"CUP_O_RU_Soldier_Ratnik_Summer"],//Default stuff
	[c_engineer,"CUP_O_RU_Soldier_Engineer_Ratnik_Summer"],
	[c_autorifleman,"CUP_O_RU_Soldier_MG_Ratnik_Summer"],
	[c_marksman,"CUP_O_RU_Soldier_Marksman_Ratnik_Summer"],
	[c_medic,"CUP_O_RU_Soldier_Medic_Ratnik_Summer"]
];


//Sample stuff
// [["CUP_srifle_SVD_pso","","","CUP_optic_PSO_1",["CUP_10Rnd_762x54_SVD_M",10],[],""],[],[],["CUP_U_O_RUS_Ratnik_Summer",[["FirstAidKit",1],["CUP_10Rnd_762x54_SVD_M",3,10],["SmokeShell",1,1]]],["CUP_Vest_RUS_6B45_Sh117",[["CUP_10Rnd_762x54_SVD_M",6,10],["CUP_HandGrenade_RGD5",2,1],["SmokeShellRed",1,1],["Chemlight_red",2,1]]],[],"CUP_H_RUS_6B47_v2_Summer","CUP_G_RUS_Balaclava_Ratnik",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","CUP_NVG_1PN138"]]
// [["CUP_arifle_RPK74M_1p78","","","CUP_optic_PechenegScope",["CUP_45Rnd_TE4_LRT4_Green_Tracer_545x39_RPK74M_M",45],[],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["CUP_U_O_RUS_Ratnik_Summer",[["FirstAidKit",1],["CUP_45Rnd_TE4_LRT4_Green_Tracer_545x39_RPK74M_M",2,45]]],["CUP_Vest_RUS_6B45_Sh117",[["CUP_45Rnd_TE4_LRT4_Green_Tracer_545x39_RPK74M_M",7,45],["16Rnd_9x21_Mag",2,17],["CUP_HandGrenade_RGD5",2,1],["SmokeShell",1,1],["SmokeShellRed",1,1],["Chemlight_red",2,1]]],[],"CUP_H_RUS_6B47_v2_GogglesUp_Summer","CUP_G_RUS_Balaclava_Ratnik",["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","CUP_NVG_1PN138"]]
// [["CUP_arifle_AK12_black_1P87","","","CUP_optic_1P87_RIS",["CUP_30Rnd_545x39_AK12_M",30],[],""],["CUP_launch_Metis","","","",["CUP_AT13_M",1],[],""],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["CUP_U_O_RUS_Ratnik_Summer",[["FirstAidKit",1],["CUP_30Rnd_545x39_AK12_M",3,30],["SmokeShell",1,1]]],["CUP_Vest_RUS_6B45_Sh117",[["CUP_30Rnd_545x39_AK12_M",4,30],["16Rnd_9x21_Mag",2,17],["CUP_HandGrenade_RGD5",2,1],["SmokeShellRed",1,1],["Chemlight_red",2,1]]],[],"CUP_H_RUS_6B47_v2_GogglesDown_Summer","CUP_G_RUS_Balaclava_Ratnik_v2",["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","CUP_NVG_1PN138"]]
// [["CUP_lmg_Pecheneg_PScope","","","CUP_optic_PechenegScope",["CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M",100],[],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_Mag",17],[],""],["CUP_U_O_RUS_Ratnik_Summer",[["FirstAidKit",1],["16Rnd_9x21_Mag",2,17],["CUP_HandGrenade_RGD5",1,1],["SmokeShell",1,1],["SmokeShellRed",1,1]]],["CUP_Vest_RUS_6B45_Sh117_PKP",[["CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M",2,100],["CUP_HandGrenade_RGD5",1,1],["Chemlight_red",2,1]]],[],"CUP_H_RUS_6B47_v2_GogglesUp_Summer","CUP_G_RUS_Balaclava_Ratnik",["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","CUP_NVG_1PN138"]]
// [["CUP_arifle_AS_VAL_VFG_pso_open","","","CUP_optic_PSO_1_1_open",["CUP_20Rnd_9x39_SP5_VSS_M",20],[],""],[],["CUP_hgun_PB6P9_snds","CUP_muzzle_PB6P9","","",["CUP_8Rnd_9x18_MakarovSD_M",8],[],""],["CUP_U_O_RUS_Ratnik_Summer",[["FirstAidKit",1],["CUP_20Rnd_9x39_SP5_VSS_M",2,20]]],["CUP_Vest_RUS_6B45_Sh117",[["CUP_20Rnd_9x39_SP5_VSS_M",5,20],["CUP_8Rnd_9x18_MakarovSD_M",2,8],["CUP_HandGrenade_RGD5",2,1],["SmokeShell",1,1],["SmokeShellRed",1,1],["SmokeShellOrange",1,1],["SmokeShellYellow",1,1],["Chemlight_red",2,1]]],[],"CUP_H_RUS_6B47_v2_Summer","CUP_G_RUS_Balaclava_Ratnik",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","CUP_NVG_1PN138"]]
// [["CUP_srifle_VSSVintorez_pso","","","CUP_optic_PSO_1_1",["CUP_10Rnd_9x39_SP5_VSS_M",10],[],""],[],["CUP_hgun_PB6P9_snds","CUP_muzzle_PB6P9","","",["CUP_8Rnd_9x18_MakarovSD_M",8],[],""],["CUP_U_O_RUS_Ratnik_Summer",[["FirstAidKit",1],["CUP_10Rnd_9x39_SP5_VSS_M",5,10]]],["CUP_Vest_RUS_6B45_Sh117",[["CUP_10Rnd_9x39_SP5_VSS_M",4,10],["CUP_8Rnd_9x18_MakarovSD_M",2,8],["CUP_HandGrenade_RGD5",2,1],["SmokeShell",1,1],["SmokeShellRed",1,1],["SmokeShellOrange",1,1],["SmokeShellYellow",1,1],["Chemlight_red",2,1]]],[],"CUP_H_RUS_6B47_v2_Summer","CUP_G_RUS_Balaclava_Ratnik",["Rangefinder","","","",[],[],""],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","CUP_NVG_1PN138"]]

////////////////////////
///Weapon management////
////////////////////////
//Russian
rifleList_Russian = [		
	"CUP_arifle_AK12_black_1P87"
];	

launcherList_Russian = [		
	"CUP_launch_Metis"

];	

autorifleList_Russian = [			
	"CUP_arifle_RPK74M_1p78",
	"CUP_lmg_Pecheneg_PScope"
];	


marksmanrifleList_Russian = [		
	"CUP_srifle_SVD_pso",
	"CUP_srifle_VSSVintorez_pso",
	"CUP_arifle_AS_VAL_VFG_pso_open"
];

smgList_Russian = [		
];


//////////////////////////
//Attachement management//
//////////////////////////
attachmentShortList_Russian	= [
	"CUP_optic_AC11704_Black",
	"CUP_optic_VortexRazor_UH1_Black",		
	"CUP_optic_artel_m14",
	"CUP_optic_artel_m14_pip",
	"CUP_optic_Aimpoint_5000",
	"CUP_optic_HoloBlack",
	"CUP_optic_Eotech553_Black",		
	"CUP_optic_CompM2_Black",			
	"CUP_optic_CompM2_low",			
	"CUP_optic_CompM4",
	"CUP_optic_MicroT1",			
	"CUP_optic_MicroT1_low",			
	"CUP_optic_MARS",
	"CUP_optic_MEPRO",
	"CUP_optic_MEPRO_openx_orange",
	"CUP_optic_MEPRO_moa_clear",
	"CUP_optic_MEPRO_tri_clear",
	"CUP_optic_SUSAT",
	"CUP_optic_SUSAT_PIP",
	"CUP_optic_SUSAT_3D",
	//"CUP_optic_ACOG",  //Remove too versatile optics to test players new choice
	"CUP_optic_ACOG_PIP",
	"CUP_optic_ACOG_3D",
	"CUP_optic_ACOG2",
	"CUP_optic_ACOG2_PIP",
	"CUP_optic_ACOG2_3D",
	"CUP_optic_RCO",
	"CUP_optic_ACOG_TA01NSN_Black_PIP",
	"CUP_optic_ACOG_TA01NSN_Black_3D",
	"CUP_optic_ACOG_TA01B_Black",
	"CUP_optic_ACOG_TA01B_Black_PIP",
	"CUP_optic_ACOG_TA01B_Black_3D",
	"CUP_optic_ZDDot",
	"CUP_optic_MRad",
	"CUP_optic_TrijiconRx01_black",
	"CUP_optic_TrijiconRx01_kf_black",
	"CUP_optic_ZeissZPoint",
	"CUP_optic_HensoldtZO",
	"CUP_acc_ANPEQ_15",
	"CUP_acc_ANPEQ_15_Black",
	"CUP_acc_ANPEQ_15_Top_Flashlight_Tan_L",
	"CUP_acc_ANPEQ_2",
	"CUP_acc_ANPEQ_2_Black_Top",
	"CUP_acc_ANPEQ_2_desert",
	"CUP_acc_ANPEQ_2_grey",
	"CUP_bipod_Harris_1A2_L_BLK",
	"CUP_bipod_VLTOR_Modpod",
	"CUP_muzzle_PB6P9",
	"CUP_muzzle_Bizon",
	"CUP_muzzle_PBS4",
	"CUP_muzzle_TGPA",
	"CUP_muzzle_snds_KZRZP_Base",
	"CUP_muzzle_snds_KZRZP_SVD",
	"CUP_muzzle_snds_KZRZP_AK762",
	"CUP_muzzle_snds_KZRZP_AK545",
	"CUP_muzzle_snds_KZRZP_PK"
];

attachmentLongList_Russian	= [
	"CUP_optic_SB_11_4x20_PM",
	"CUP_optic_SB_11_4x20_PM_pip",
	"CUP_optic_SB_3_12x50_PMII",
	"CUP_optic_SB_3_12x50_PMII_PIP",
	"CUP_optic_LeupoldMk4",
	"CUP_optic_CWS",
	"CUP_optic_CWS_NV",
	"CUP_optic_CWS_NV_RDS"
];

////////////////////////
////Items management////
////////////////////////
itemList_Russian = [
	"ItemMap",
	"ItemCompass",
	"ItemWatch",
	"NVGoggles",
	//"B_UavTerminal",
	"Binocular",
	"Rangefinder",
	"ACE_MapTools",
	"ACE_microDAGR",
	"ACE_SpraypaintRed",
	"ACE_CableTie",
	"ACE_DAGR",
	"ACE_WaterBottle",
	"ACE_EarPlugs",
	"ACE_fieldDressing",
	"ACE_packingBandage",
	"ACE_elasticBandage",
	"ACE_tourniquet",
	"ACE_splint",
	"ACE_morphine",
	"ACE_quikclot",
	"ACE_EntrenchingTool"
	];

itemEngineerList_Russian = [
	"ToolKit",
	"MineDetector",
	"ACE_wirecutter"
	];
	
itemMedicList_Russian = [
	"ACE_epinephrine",
	"ACE_bloodIV",
	"ACE_bloodIV_500",
	"ACE_bloodIV_250",
	"ACE_personalAidKit",
	"ACE_surgicalKit"
	];