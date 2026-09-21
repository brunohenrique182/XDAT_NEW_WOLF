class BuilderCmdWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var ButtonHandle rmode_button;
var ButtonHandle init_button;
var ButtonHandle removeDelay_button;
var ButtonHandle stat_all_button;
var ButtonHandle normal_button;
var ButtonHandle bbox_button;
var CheckBoxHandle m_CheckBoxBoneName;
var ComboBoxHandle m_ComboBoneName;
var ComboBoxHandle Reload_ComboBox;
var ButtonHandle Reload_button;
var ButtonHandle NpcSummon_Button;
var ButtonHandle UseSkill_button;
var ButtonHandle DefaultNpc_button;
var ButtonHandle ComeOn_button;
var ButtonHandle KillNpc_button;
var ButtonHandle SetParam_button;
var ButtonHandle SetSpeed_button;
var ButtonHandle SetRate_button;
var ButtonHandle SetRace_button;
var ButtonHandle Clone_button;
var ButtonHandle JobTree_button;
var ButtonHandle Search_button;
var ButtonHandle distance_button;
var ButtonHandle empty_button;
var EditBoxHandle AveId_EditBox;
var EditBoxHandle NpcId_EditBox;
var EditBoxHandle SkillId_EditBox;
var EditBoxHandle Param_EditBox;
var EditBoxHandle Speed_EditBox;
var EditBoxHandle Rate_EditBox;
var EditBoxHandle Range_EditBox;
var SliderCtrlHandle sliderSetTime;
var TextBoxHandle txtSetTime;
var CheckBoxHandle checkBoxRange;
var CheckBoxHandle checkBoxSetTime;
var CheckBoxHandle autoOpenCheckBox;
var int nAutoOpen;
var array<string> noteArray;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent(3410);
	return;
}

function OnShow()
{
	Me.SetFocus();
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("BuilderCmdWnd");
	if(getInstanceUIData().GetIsLiveServer())
	{
		setWindowTitleByString(("BuilderCommand" @ "(Live)"));
	}
	else if(getInstanceUIData().IsAdenServer())
	{
		setWindowTitleByString(("BuilderCommand" @ "(Aden)"));
	}
	else
	{
		setWindowTitleByString(("BuilderCommand" @ "(Classic)"));
	}
	rmode_button = GetButtonHandle((m_Windowname $ ".rmode_button"));
	init_button = GetButtonHandle((m_Windowname $ ".init_button"));
	removeDelay_button = GetButtonHandle((m_Windowname $ ".removeDelay_button"));
	stat_all_button = GetButtonHandle((m_Windowname $ ".stat_all_button"));
	normal_button = GetButtonHandle((m_Windowname $ ".normal_button"));
	bbox_button = GetButtonHandle((m_Windowname $ ".bbox_button"));
	distance_button = GetButtonHandle((m_Windowname $ ".distance_button"));
	empty_button = GetButtonHandle((m_Windowname $ ".empty_button"));
	m_CheckBoxBoneName = GetCheckBoxHandle((m_Windowname $ ".BoneName_CheckBox"));
	m_ComboBoneName = GetComboBoxHandle((m_Windowname $ ".BoneName_ComboBox"));
	Reload_ComboBox = GetComboBoxHandle((m_Windowname $ ".Reload_ComboBox"));
	Reload_ComboBox.AddString("AVE");
	Reload_ComboBox.AddString("AdditionalEffect");
	Reload_ComboBox.AddString("ArmorGrp");
	Reload_ComboBox.AddString("WeaponGrp");
	Reload_ComboBox.AddString("EtcItemGrp");
	Reload_ComboBox.AddString("SkillGrp");
	Reload_ComboBox.AddString("NpcGrp");
	Reload_ComboBox.AddString("HairExGrp");
	Reload_ComboBox.AddString("FaceExGrp");
	Reload_ComboBox.AddString("----------------");
	Reload_ComboBox.AddString("Effect");
	Reload_ComboBox.AddString("SkillEffect");
	Reload_ComboBox.AddString("LineageNpc");
	Reload_ComboBox.AddString("LineageMonster");
	Reload_ComboBox.AddString("LineageWarrior");
	Reload_ComboBox.AddString("----------------");
	Reload_ComboBox.AddString("Skill_Data");
	Reload_ComboBox.AddString("Item_Data");
	Reload_ComboBox.AddString("Npc_Data");
	AveId_EditBox = GetEditBoxHandle((m_Windowname $ ".AveId_EditBox"));
	AveId_EditBox.SetString("388");
	NpcSummon_Button = GetButtonHandle((m_Windowname $ ".NpcSummon_Button"));
	NpcId_EditBox = GetEditBoxHandle((m_Windowname $ ".NpcId_EditBox"));
	if(getInstanceUIData().GetIsLiveServer())
	{
		NpcId_EditBox.SetString("18912");
	}
	else if(getInstanceUIData().IsAdenServer())
	{
		NpcId_EditBox.SetString("18002");
	}
	else
	{
		NpcId_EditBox.SetString("18002");
	}
	UseSkill_button = GetButtonHandle((m_Windowname $ ".UseSkill_button"));
	SkillId_EditBox = GetEditBoxHandle((m_Windowname $ ".SkillId_EditBox"));
	SkillId_EditBox.SetString("129 1 0");
	DefaultNpc_button = GetButtonHandle((m_Windowname $ ".DefaultNpc_button"));
	ComeOn_button = GetButtonHandle((m_Windowname $ ".ComeOn_button"));
	KillNpc_button = GetButtonHandle((m_Windowname $ ".KillNpc_button"));
	SetParam_button = GetButtonHandle((m_Windowname $ ".SetParam_button"));
	SetSpeed_button = GetButtonHandle((m_Windowname $ ".SetSpeed_button"));
	SetRate_button = GetButtonHandle((m_Windowname $ ".SetRate_button"));
	Search_button = GetButtonHandle((m_Windowname $ ".search_button"));
	Param_EditBox = GetEditBoxHandle((m_Windowname $ ".Param_EditBox"));
	Param_EditBox.SetString("lv 90");
	Speed_EditBox = GetEditBoxHandle((m_Windowname $ ".Speed_EditBox"));
	Speed_EditBox.SetString("5");
	Rate_EditBox = GetEditBoxHandle((m_Windowname $ ".Rate_EditBox"));
	Rate_EditBox.SetString("0.5");
	Range_EditBox = GetEditBoxHandle((m_Windowname $ ".Range_EditBox"));
	Range_EditBox.SetString("1000");
	Clone_button = GetButtonHandle((m_Windowname $ ".Clone_button"));
	JobTree_button = GetButtonHandle((m_Windowname $ ".JobTree_button"));
	checkBoxRange = GetCheckBoxHandle((m_Windowname $ ".checkBoxRange"));
	sliderSetTime = GetSliderCtrlHandle((m_Windowname $ ".sliderSetTime"));
	txtSetTime = GetTextBoxHandle((m_Windowname $ ".txtSetTime"));
	checkBoxSetTime = GetCheckBoxHandle((m_Windowname $ ".checkBoxSetTime"));
	autoOpenCheckBox = GetCheckBoxHandle((m_Windowname $ ".autoOpenCheckBox"));
	nAutoOpen = -9999;
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int nOpen;

	if((Event_ID == 40))
	{
		nAutoOpen = -9999;
	}
	else if((Event_ID == 9750))
	{
		if((nAutoOpen == -9999))
		{
			GetINIInt("BuilderCmdWnd", "autoOpen", nAutoOpen, "UIDEV.ini");
		}
	}
	else if((Event_ID == 3410))
	{
		if((param == "GAMINGSTATE"))
		{
			GetINIInt("BuilderCmdWnd", "autoOpen", nOpen, "UIDEV.ini");
		}
		else
		{
			Me.HideWindow();
		}
	}
	return;
}

function OnClickReloadButton()
{
	local int Selected;

	Selected = Reload_ComboBox.GetSelectedNum();
	switch(Selected)
	{
		case 0:
			ExecuteCommand("///ave_reload");
			break;
		case 1:
			ExecuteCommand("///additionaleffect_reload");
			break;
		case 2:
			ExecuteCommand("///armorgrp_reload");
			break;
		case 3:
			ExecuteCommand("///weapongrp_reload");
			break;
		case 4:
			ExecuteCommand("///etcitemgrp_reload");
			break;
		case 5:
			ExecuteCommand("///skillgrp_reload");
			break;
		case 6:
			ExecuteCommand("///npcgrp_reload");
			break;
		case 7:
			ExecuteCommand("///hairexgrp_reload");
			break;
		case 8:
			ExecuteCommand("///faceexgrp_reload");
			break;
		case 9:
			break;
		case 10:
			ExecuteCommand("///reloade");
			break;
		case 11:
			ExecuteCommand("///reloadse");
			break;
		case 12:
			ExecuteCommand("///reloadnpc");
			break;
		case 13:
			ExecuteCommand("///reloadmonster");
			break;
		case 14:
			ExecuteCommand("///reloadwarrior");
			break;
		case 15:
			break;
		case 16:
			ExecuteCommand("//reload_skill_data");
			break;
		case 17:
			ExecuteCommand("//reload_item_data");
			break;
		case 18:
			ExecuteCommand("//reload_npc_data");
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		case "Reload_button":
			OnClickReloadButton();
			break;
		case "collision_button":
			ExecuteCommand("///show radii");
			break;
		case "npcinfo_button":
			ExecuteCommand("//debug .");
			break;
		case "nameTag_button":
			ExecuteCommand("///show name");
			break;
		case "rmode_button":
			if((rmode_button.GetButtonName() == "Wireframe"))
			{
				ExecuteCommand("///rmode 1");
				rmode_button.SetNameText("Lighting");
			}
			else
			{
				ExecuteCommand("///rmode 5");
				rmode_button.SetNameText("Wireframe");
			}
			break;
		case "stat_all_button":
			if((stat_all_button.GetButtonName() == "Stat All"))
			{
				ExecuteCommand("///stat all");
				stat_all_button.SetNameText("Stat Off");
				break;
			}
			else
			{
				ExecuteCommand("///stat none");
				stat_all_button.SetNameText("Stat All");
				break;
			}
		case "stat_l2_button":
			ExecuteCommand("///stat l2");
			break;
		case "stat_emt_button":
			ExecuteCommand("///stat emitter");
			break;
		case "stat_fps_button":
			ExecuteCommand("///stat fps");
			break;
		case "stat_render_button":
			ExecuteCommand("///stat render");
			break;
		case "stat_game_button":
			ExecuteCommand("///stat game");
			break;
		case "normal_button":
			ExecuteCommand("///rend normal");
			break;
		case "bbox_button":
			ExecuteCommand("///rend bound");
			break;
		case "init_button":
			ExecuteCommand("//hide off");
			ExecuteCommand("//undying on");
			ExecuteCommand("/target %self");
			ExecuteCommand("//skill_master on");
			ExecuteCommand("//item_master on");
			ExecuteCommand("///autocom");
			break;
		case "removeDelay_button":
			ExecuteCommand("/target %self");
			ExecuteCommand("//remove_skill_delay_all");
			break;
		case "AVE_addButton":
			ExecuteCommand(("///aa type=" @ AveId_EditBox.GetString()));
			break;
		case "AVE_delButton":
			ExecuteCommand(("///da type=" @ AveId_EditBox.GetString()));
			break;
		case "AVE_clearButton":
			ExecuteCommand("///aa type=none");
			break;
		case "NpcSummon_Button":
			ExecuteCommand(("//summon 10" $ NpcId_EditBox.GetString()));
			break;
		case "UseSkill_Button":
			ExecuteCommand(("//npc_use_skill" @ SkillId_EditBox.GetString()));
			break;
		case "DefaultNpc_button":
			ExecuteCommand("//setai default_npc");
			break;
		case "ComeOn_Button":
			ExecuteCommand("//come_to_me 1");
			break;
		case "KillNpc_Button":
			ExecuteCommand("//killnpc");
			break;
		case "SetParam_button":
			ExecuteCommand(("//setparam " @ Param_EditBox.GetString()));
			break;
		case "dex_1_button":
			ExecuteCommand("//setparam_me dex 50");
			break;
		case "dex_2_button":
			ExecuteCommand("//setparam_me dex 100");
			break;
		case "dex_3_button":
			ExecuteCommand("//setparam_me dex 200");
			break;
		case "SetSpeed_button":
			ExecuteCommand(("//gmspeed" @ Speed_EditBox.GetString()));
			break;
		case "SetRate_button":
			ExecuteCommand(("///gamespeed" @ Rate_EditBox.GetString()));
			break;
		case "Clone_button":
			ExecuteCommand("///spawnpc copy num=1");
			break;
		case "JobTree_button":
			ExecuteCommand("/target %self");
			ShowWindow("JobTreeWnd");
			break;
		case "Search_button":
			ExecuteCommand("///searchobject");
			break;
		case "Distance_button":
			ExecuteCommand("//distance");
			break;
		case "resetSkill_button":
			ExecuteCommand("/target %self");
			ExecuteCommand("//reset_skill");
			break;
		case "allSkill_button":
			ExecuteCommand("//set_skill_all_me");
			break;
		case "destroyItem_button":
			ExecuteCommand("//destroy_all_inven_item");
			break;
		case "destroyUnequippedItem_button":
			ExecuteCommand("//destroy_unequipped_item");
			break;
		case "dispelAll_button":
			ExecuteCommand("/target %self");
			ExecuteCommand("//dispelall");
			break;
		case "yebis_button":
			ExecuteCommand("///sw name=YebisCmdWnd");
			break;
		case "uieditor_button":
			ExecuteCommand("///ui");
			break;
		case "empty_button":
			ExecuteCommand("//teleport -20358, -157358, -3727");
			break;
		default:
			break;
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if((int(nKey) == 13))
	{
		switch(a_WindowHandle.GetWindowName())
		{
			case "AveId_EditBox":
				ExecuteCommand(("///aa type=" @ AveId_EditBox.GetString()));
				break;
			case "Speed_EditBox":
				ExecuteCommand(("///gmspeed" @ Speed_EditBox.GetString()));
				break;
			case "Rate_EditBox":
				ExecuteCommand(("///gamespeed" @ Rate_EditBox.GetString()));
				break;
			case "NpcId_EditBox":
				ExecuteCommand(("//summon 10" $ NpcId_EditBox.GetString()));
				break;
			case "Param_EditBox":
				ExecuteCommand(("//setparam " @ Param_EditBox.GetString()));
				break;
			case "SkillId_EditBox":
				ExecuteCommand(("//npc_use_skill" @ SkillId_EditBox.GetString()));
				break;
			default:
				break;
		}
	}
	return false;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local float ftime;

	switch(strID)
	{
		case "sliderSetTime":
			if(checkBoxSetTime.IsChecked())
			{
				ftime = (float(sliderSetTime.GetCurrentTick()) / 10.0000000);
				SetEnvTime(ftime);
				txtSetTime.SetText(string(ftime));
			}
			break;
		default:
			break;
	}
	return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
	switch(strID)
	{
		case "BoneName_ComboBox":
			if((IndexID == 0))
			{
				if(m_CheckBoxBoneName.IsChecked())
				{
					ExecuteCommand("///rend reset");
					ExecuteCommand("///rend bone");
					ExecuteCommand("///rend bonename");
				}
			}
			else
			{
				Class'NWindow.UIDATA_PAWNVIEWER'.static.ShowSelectedBone(m_ComboBoneName.GetString(IndexID));
			}
			break;
		default:
			break;
	}
	return;
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "BoneName_CheckBox":
			if(m_CheckBoxBoneName.IsChecked())
			{
				ExecuteCommand("///rend bone");
				ExecuteCommand("///rend bonename");
			}
			else
			{
				ExecuteCommand("///rend reset");
			}
			SetBoneList();
			break;
		case "checkBoxRange":
			if(checkBoxRange.IsChecked())
			{
				ExecuteCommand(("///show_range" @ Range_EditBox.GetString()));
			}
			else
			{
				ExecuteCommand("///show_range none");
			}
			break;
		case "autoOpenCheckBox":
			break;
		default:
			break;
	}
	return;
}

function OnChangeEditBox(string strID)
{
	switch(strID)
	{
		case "Range_EditBox":
			if(checkBoxRange.IsChecked())
			{
				ExecuteCommand(("///show_range" @ Range_EditBox.GetString()));
			}
			break;
		default:
			break;
	}
	return;
}

function SetBoneList()
{
	local array<string> BoneNameList;
	local int Index;

	m_ComboBoneName.Clear();
	m_ComboBoneName.AddString("Show All Bones");
	if(m_CheckBoxBoneName.IsChecked())
	{
		Class'NWindow.UIDATA_PAWNVIEWER'.static.GetBoneNameList(BoneNameList);
		Index = 0;
		while((Index < BoneNameList.Length))
		{
			m_ComboBoneName.AddString(BoneNameList[Index]);
			Index++;
		}
		m_ComboBoneName.SetSelectedNum(1);
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ShowSelectedBone(m_ComboBoneName.GetString(1));
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="BuilderCmdWnd"
}
