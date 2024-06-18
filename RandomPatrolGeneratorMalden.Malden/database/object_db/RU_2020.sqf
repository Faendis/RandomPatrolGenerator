#include "..\classConstant.sqf"

//Add specific RHS factions
if (isClass (configFile >> "CfgPatches" >> "rhs_main")) then 
{
	factionInfos pushBack ["_RU_2020", 39,"2020 Russian VDV [RHS]", true, true, false];
};

//////////////////////////////
///Define enemy group data////
//////////////////////////////
//USA
baseEnemyGroup_RU_2020 = [
	"rhs_vdv_sergeant",
	"rhs_vdv_efreitor",
	"rhs_vdv_arifleman",
	"rhs_vdv_machinegunner_assistant",
	"rhs_vdv_LAT",
	"rhs_vdv_grenadier",
	"rhs_msv_emr_medic",
	"rhs_msv_emr_rifleman",
	"rhs_msv_emr_rifleman"
];

baseEnemyATGroup_RU_2020 = [
	"rhs_vdv_junior_sergeant",
	"rhs_vdv_at",
	"rhs_vdv_strelok_rpg_assist",
	"rhs_vdv_LAT",
	"rhs_vdv_rifleman",
	"rhs_vdv_aa"
];

baseEnemyDemoGroup_RU_2020 = [
	"rhs_vdv_sergeant",
	"rhs_vdv_efreitor",
	"rhs_vdv_arifleman",
	"rhs_vdv_machinegunner_assistant",
	"rhs_vdv_arifleman",
	"rhs_vdv_machinegunner_assistant"
];

baseEnemyMortarGroup_RU_2020 = [
	"rhs_2b14_82mm_vdv",
	"rhs_vdv_marksman", 
	"rhs_vdv_rifleman", 
	"rhs_vdv_arifleman_rpk"
];

baseEnemyVehicleGroup_RU_2020 = [
	"rhs_tigr_3camo_vdv",
	"rhs_tigr_sts_3camo_vdv"
];

baseEnemyLightArmoredVehicleGroup_RU_2020 = [
	"rhs_btr60_vdv"
];

baseEnemyHeavyArmoredVehicleGroup_RU_2020 = [
	"rhs_bmd1",
	"rhs_bmp2d_vdv",
	"rhs_sprut_vdv"
];

baseEnemyUnarmedChopperGroup_RU_2020 = [
	"RHS_Mi8mt_vdv"
];

baseEnemyArmedChopperGroup_RU_2020 = [
	"RHS_Mi24P_vdv", 
	"RHS_Mi8MTV3_heavy_vdv"
];

baseFixedWingGroup_RU_2020 = [
	"rhs_mig29s_vvs",
	"RHS_Su25SM_vvs",
	"RHS_T50_vvs_generic"
];


////////////////////////
//Vehicle management////
////////////////////////
//USA
bluforUnarmedVehicle_RU_2020 = [
	"rhs_gaz66_vdv",
	"rhs_kamaz5350_vdv",
	"RHS_Ural_Open_VDV_01",
	"rhs_tigr_vdv",
	"rhs_tigr_3camo_vdv",
	"rhs_uaz_vdv",
	"rhs_uaz_open_vdv",
	"rhs_tigr_m_vdv"
];

bluforArmedVehicle_RU_2020 = [
	"rhs_tigr_sts_3camo_vdv",
	"rhs_tigr_sts_vdv",
	"rhs_Igla_AA_pod_msv" //AA Turret
];

//Armored vehicle avalaible for blufor : Ex light tank
bluforArmoredVehicle_RU_2020 = [
	"rhs_bmd1",
	"rhs_bmp2d_vdv",
	"rhs_sprut_vdv",
	"rhs_btr60_vdv"
];

bluforUnarmedVehicleChopper_RU_2020 = [
	"RHS_Mi8mt_vdv",
	"RHS_Mi8mt_Cargo_vdv",
	"rhs_ka60_c"
];

bluforArmedChopper_RU_2020 = [
	"RHS_Ka52_vvs",
	"RHS_Mi24P_vvs",
	"RHS_Mi8AMTSh_vvs",
	"RHS_Mi24P_vdv",
	"RHS_Mi8MTV3_vdv"
];

bluforDrone_RU_2020 = [
	"rhs_pchela1t_vvs", 
	"rhs_pchela1t_vvsc"
];

bluforBoat_RU_2020 = [

];

//FixedWing vehicle avalaible for blufor
bluforFixedWing_RU_2020 = [
	"rhs_mig29s_vvs",
	"RHS_Su25SM_vvs",
	"RHS_T50_vvs_generic"
];

//Vehicule able to do HQ features (Loadout management and more)
bluforHQVehicle_RU_2020 = [
	"rhs_typhoon_vdv", 
	"rhs_tigr_vdv",
	"RHS_Mi8T_vdv"
];	


////////////////////////
//Loadout management////
////////////////////////

//USA
loadout_RU_2020 = [		
	[c_leader, "rhs_vdv_junior_sergeant"],
	[c_at, "rhs_vdv_at"],
	[c_rifleman, "rhs_vdv_rifleman"],//Default stuff
	[c_engineer,"rhs_vdv_engineer"],
	[c_autorifleman, "rhs_vdv_machinegunner"],
	[c_marksman, "rhs_vdv_marksman_asval"],
	[c_sniper,"rhs_vdv_marksman"],
	[c_medic,"rhs_vdv_medic"],
	[c_grenadier, "rhs_vdv_grenadier"],//Default stuff
	[c_pilot,"rhs_pilot_combat_heli"]
];


////////////////////////
///Weapon management////
////////////////////////
//USA
rifleList_RU_2020 = [		
	"rhs_weap_ak74m",
	"rhs_weap_makarov_pm",
	"rhs_weap_ak74mr",
	"rhs_weap_ak74m_fullplum",
	"rhs_weap_ak74m_fullplum_npz",
	"rhs_weap_ak74m_zenitco01_b33",
	"rhs_weap_aks74n_npz",
	"rhs_weap_aks74n_2",
	"rhs_weap_ak103",
	"rhs_weap_ak103_npz",
	"rhs_weap_ak103_zenitco01",
	"rhs_weap_ak103_zenitco01_b33",
	"rhs_weap_ak103_1",
	"rhs_weap_ak104",
	"rhs_weap_ak104_npz",
	"rhs_weap_ak105",
	"rhs_weap_ak105_npz",
	"rhs_weap_ak105_zenitco01",
	"rhs_weap_ak105_zenitco01_b33",
	"rhs_weap_ak74mr_grip1",
	"rhs_weap_ak74m_fullplum_grip1",
	"rhs_weap_ak74m_fullplum_npz_grip1",
	"rhs_weap_ak74m_zenitco01_b33_grip1",
	"rhs_weap_aks74n_npz_grip1",
	"rhs_weap_ak103_npz_grip1",
	"rhs_weap_ak103_zenitco01_grip1",
	"rhs_weap_ak103_zenitco01_b33_grip1",
	"rhs_weap_ak104_npz_grip1",
	"rhs_weap_ak105_npz_grip1",
	"rhs_weap_ak105_zenitco01_grip1",
	"rhs_weap_ak105_zenitco01_b33_grip1",



	"rhs_weap_pya",
	"rhs_weap_6p53",

	

	//Periscope
	"rhs_weap_tr8"
];	




grenadeLauncherList_RU_2020 = [		
	"rhs_weap_ak74m_gp25",
	"rhs_weap_ak74mr_gp25",
	"rhs_weap_ak74m_fullplum_gp25_npz",
	"rhs_weap_ak74n_gp25",
	"rhs_weap_ak74m_gp25_grip1",
	"rhs_weap_ak74mr_gp25_grip1",
	"rhs_weap_ak74m_fullplum_gp25_npz_grip1",
	"rhs_weap_ak74n_gp25"
];


launcherList_RU_2020 = [		
	"rhs_weap_rpg26",
	"rhs_weap_rpg7",
	"rhs_weap_igla"
];	

autorifleList_RU_2020 = [			
	"rhs_weap_pkm",
	"rhs_weap_pkp",
	"rhs_weap_rpk74m",
	"rhs_weap_rpk74m_npz"

];	

marksmanrifleList_RU_2020 = [		
	"rhs_asval",
	"rhs_weap_svds",
	"rhs_weap_vss",
	"rhs_weap_vss_grip1",
	"rhs_weap_t5000",
	"rhs_weap_svds_npz",
	"rhs_weap_vss_grip_npz",
	"rhs_weap_svdp"
];



smgList_RU_2020 = [		
	"rhs_weap_aks74u",
	"rhs_weap_ak74m_folded",
	"rhs_weap_pp2000_folded",
	"rhs_weap_pp2000"
];

//////////////////////////
attachmentShortList_RU_2020	= [
	"rhs_acc_dtk",
	"rhs_acc_pkas",
	"rhs_acc_pgo7v3",
	"rhs_acc_1p78",
	"rhs_acc_uuk",
	"rhs_acc_1p87",
	"rhs_acc_rakursPM",
	"rhs_acc_pgs64",
	"rhs_acc_2dpZenit",
	"rhs_acc_okp7_picatinny",
	"rhs_acc_perst1ik_ris",
	"rhs_acc_pkas_pkp",
	"rhs_acc_pgo7v3_pkp",
	"rhs_acc_pgo7v3_ak",
	"rhs_acc_grip_ffg2",
	"rhs_acc_grip_rk2",
	"rhs_acc_grip_rk6",
	"rhs_acc_ekp8_18"

];

attachmentLongList_RU_2020	= [
	"rhs_acc_pso1m21",
	"rhs_acc_pso1m2",
	"rhs_acc_dh520x56",
	"rhs_acc_pgo7v3_asval",
	"rhs_acc_pkas_asval"
];


////////////////////////
itemList_RU_2020 = [
	"B_UavTerminal",
	"ItemGPS",
	"rhs_pdu4",
	"ACE_EntrenchingTool",
	"ACE_RangeTable_82mm",
	"ACE_IR_Strobe_Item",
	"ACE_RangeCard",
	"ACE_NVG_Wide_Black_WP",
	"ACE_NVG_Wide_WP",
	"ACE_NVG_Wide_Green_WP"
];

itemEngineerList_RU_2020 = [

];
	
itemMedicList_RU_2020 = [

];

//backpack avalaible for all unit
backPackList_RU_2020 = [
	"rhs_rk_sht_30_emr",
	"rhs_tortila_olive",
	"rhs_assault_umbts",
	"TFAR_mr3000_rhs"
];

//Uniform, vest, headgear, avalaible for all unit
uniformList_RU_2020 = [
	"rhs_uniform_vkpo_gloves",
	"rhs_6b47_emr_1",
	"rhs_facewear_6m2_1",
	"rhs_6b45_light",
	"rhs_6b45_holster",
	"rhs_6b45_rifleman",
	"rhs_6b45_rifleman_2",
	"rhs_6b45_off",
	"rhs_6b45_mg",
	"rhs_uniform_6sh122_v1",
	"rhs_6b23_digi_medic",
	"rhs_balaclava",
	"rhs_balaclava_olive",
	"rhs_scarf"
];


factionDefaultRadios_RU_2020 = [
	"tfar_fadak"
];

//Magazine avalaible for all unit
magazineList_RU_2020 = 	[
];