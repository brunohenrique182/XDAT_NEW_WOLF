class PVBuilderCmdWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var ButtonHandle rmode_button;
var ButtonHandle stat_all_button;
var ButtonHandle ghost_button;
var CheckBoxHandle m_CheckBoxBoneName;
var ComboBoxHandle m_ComboBoneName;
var ComboBoxHandle Reload_ComboBox;
var ButtonHandle Reload_button;
var ButtonHandle AVE_addButton;
var ButtonHandle AVE_delButton;
var ButtonHandle AVE_clearButton;
var ButtonHandle Effect_button;
var ButtonHandle Ride_button;
var ButtonHandle Teleport_button;
var ButtonHandle pv_button;
var ButtonHandle nv_button;
var ButtonHandle sv_button;
var ButtonHandle sc_button;
var ButtonHandle Search_button;
var ButtonHandle skill_search_button;
var ButtonHandle minimap_button;
var ButtonHandle pe_button;
var ButtonHandle ui_button;
var ComboBoxHandle Location_ComboBox;
var EditBoxHandle AveId_EditBox;
var EditBoxHandle Effect_EditBox;
var EditBoxHandle RideId_EditBox;
var EditBoxHandle OffsetX_EditBox;
var EditBoxHandle OffsetY_EditBox;
var EditBoxHandle OffsetZ_EditBox;
var EditBoxHandle Pitch_EditBox;
var EditBoxHandle Yaw_EditBox;
var EditBoxHandle Roll_EditBox;
var EditBoxHandle Speed_EditBox;
var EditBoxHandle Rate_EditBox;
var EditBoxHandle TelX_EditBox;
var EditBoxHandle TelY_EditBox;
var EditBoxHandle TelZ_EditBox;
var EditBoxHandle Player_EditBox;
var EditBoxHandle Range_EditBox;
var EditBoxHandle ZoneState_EditBox;
var SliderCtrlHandle sliderSetTime;
var TextBoxHandle txtSetTime;
var CheckBoxHandle checkBoxRange;
var CheckBoxHandle checkBoxSetTime;

function OnLoad()
{
	local string pawnViewerMode;

	SetClosingOnESC();
	Me = GetWindowHandle("PVBuilderCmdWnd");
	if(GetINIString("URL", "L2PawnViewerMode", pawnViewerMode, "l2.ini"))
	{
		Me.SetWindowTitle(((("BuilderCommand" @ "(") $ pawnViewerMode) $ ")"));
	}
	rmode_button = GetButtonHandle((m_Windowname $ ".rmode_button"));
	stat_all_button = GetButtonHandle((m_Windowname $ ".stat_all_button"));
	m_CheckBoxBoneName = GetCheckBoxHandle((m_Windowname $ ".BoneName_CheckBox"));
	m_ComboBoneName = GetComboBoxHandle((m_Windowname $ ".BoneName_ComboBox"));
	Reload_ComboBox = GetComboBoxHandle((m_Windowname $ ".Reload_ComboBox"));
	Reload_ComboBox.AddString("AVE");
	Reload_ComboBox.AddString("AdditionalEffect");
	Reload_ComboBox.AddString("ArmorGrp");
	Reload_ComboBox.AddString("WeaponGrp");
	Reload_ComboBox.AddString("SkillGrp");
	Reload_ComboBox.AddString("NpcGrp");
	Reload_ComboBox.AddString("HairExGrp");
	Reload_ComboBox.AddString("FaceExGrp");
	Reload_ComboBox.AddString("CharGrp");
	Reload_ComboBox.AddString("----------------");
	Reload_ComboBox.AddString("Effect");
	Reload_ComboBox.AddString("SkillEffect");
	Reload_ComboBox.AddString("LineageNpc");
	Reload_ComboBox.AddString("LineageMonster");
	Reload_ComboBox.AddString("LineageWarrior");
	AVE_addButton = GetButtonHandle((m_Windowname $ ".AVE_addButton"));
	AVE_delButton = GetButtonHandle((m_Windowname $ ".AVE_delButton"));
	AVE_clearButton = GetButtonHandle((m_Windowname $ ".AVE_delButton"));
	Effect_button = GetButtonHandle((m_Windowname $ ".Effect_button"));
	Ride_button = GetButtonHandle((m_Windowname $ ".Ride_button"));
	Teleport_button = GetButtonHandle((m_Windowname $ ".Teleport_button"));
	ghost_button = GetButtonHandle((m_Windowname $ ".Ghost_button"));
	Location_ComboBox = GetComboBoxHandle((m_Windowname $ ".Location_ComboBox"));
	Location_ComboBox.AddStringWithReserved("공터", 0);  // EN?: Empty
	Location_ComboBox.AddStringWithReserved("기란성 마을", 1);  // EN?: Ghiranseong Village
	Location_ComboBox.AddStringWithReserved("아덴성 마을", 2);  // EN?: Aden Castle Village
	Location_ComboBox.AddStringWithReserved("엘프 마을", 3);  // EN?: Elven Village
	Location_ComboBox.AddStringWithReserved("도마뱀 초원", 4);  // EN?: Lizard Meadow
	Location_ComboBox.AddStringWithReserved("황무지", 5);  // EN?: Wasteland
	Location_ComboBox.SetSelectedNum(0);
	AveId_EditBox = GetEditBoxHandle((m_Windowname $ ".AveId_EditBox"));
	AveId_EditBox.SetString("388");
	Effect_EditBox = GetEditBoxHandle((m_Windowname $ ".Effect_EditBox"));
	RideId_EditBox = GetEditBoxHandle((m_Windowname $ ".RideId_EditBox"));
	ZoneState_EditBox = GetEditBoxHandle((m_Windowname $ ".ZoneState_EditBox"));
	ZoneState_EditBox.SetString("0");
	OffsetX_EditBox = GetEditBoxHandle((m_Windowname $ ".OffsetX_EditBox"));
	OffsetY_EditBox = GetEditBoxHandle((m_Windowname $ ".OffsetY_EditBox"));
	OffsetZ_EditBox = GetEditBoxHandle((m_Windowname $ ".OffsetZ_EditBox"));
	Pitch_EditBox = GetEditBoxHandle((m_Windowname $ ".Pitch_EditBox"));
	Yaw_EditBox = GetEditBoxHandle((m_Windowname $ ".Yaw_EditBox"));
	Roll_EditBox = GetEditBoxHandle((m_Windowname $ ".Roll_EditBox"));
	OffsetX_EditBox.SetString("0");
	OffsetY_EditBox.SetString("0");
	OffsetZ_EditBox.SetString("0");
	Pitch_EditBox.SetString("0");
	Yaw_EditBox.SetString("0");
	Roll_EditBox.SetString("0");
	Speed_EditBox = GetEditBoxHandle((m_Windowname $ ".Speed_EditBox"));
	Speed_EditBox.SetString("5");
	Rate_EditBox = GetEditBoxHandle((m_Windowname $ ".Rate_EditBox"));
	Rate_EditBox.SetString("0.5");
	Range_EditBox = GetEditBoxHandle((m_Windowname $ ".Range_EditBox"));
	Range_EditBox.SetString("1000");
	TelX_EditBox = GetEditBoxHandle((m_Windowname $ ".TelX_EditBox"));
	TelY_EditBox = GetEditBoxHandle((m_Windowname $ ".TelY_EditBox"));
	TelZ_EditBox = GetEditBoxHandle((m_Windowname $ ".TelZ_EditBox"));
	TelX_EditBox.SetString("-20358");
	TelY_EditBox.SetString("-157358");
	TelZ_EditBox.SetString("-3727");
	Player_EditBox = GetEditBoxHandle((m_Windowname $ ".Player_EditBox"));
	Player_EditBox.SetString("1");
	sliderSetTime = GetSliderCtrlHandle((m_Windowname $ ".sliderSetTime"));
	txtSetTime = GetTextBoxHandle((m_Windowname $ ".txtSetTime"));
	checkBoxSetTime = GetCheckBoxHandle((m_Windowname $ ".checkBoxSetTime"));
	checkBoxRange = GetCheckBoxHandle((m_Windowname $ ".checkBoxRange"));
	pv_button = GetButtonHandle((m_Windowname $ ".pv_button"));
	nv_button = GetButtonHandle((m_Windowname $ ".nv_button"));
	sv_button = GetButtonHandle((m_Windowname $ ".sv_button"));
	sc_button = GetButtonHandle((m_Windowname $ ".sc_button"));
	Search_button = GetButtonHandle((m_Windowname $ ".search_button"));
	skill_search_button = GetButtonHandle((m_Windowname $ ".skill_search_button"));
	minimap_button = GetButtonHandle((m_Windowname $ ".minimap_button"));
	ExecuteCommand("///settime time=12");
	pe_button = GetButtonHandle((m_Windowname $ ".pe_button"));
	ui_button = GetButtonHandle((m_Windowname $ ".ui_button"));
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
			ExecuteCommand("///skillgrp_reload");
			break;
		case 5:
			ExecuteCommand("///npcgrp_reload");
			break;
		case 6:
			ExecuteCommand("///hairexgrp_reload");
			break;
		case 7:
			ExecuteCommand("///faceexgrp_reload");
			break;
		case 8:
			ExecuteCommand("///chargrp_reload");
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
		default:
			break;
	}
	return;
}

function RideOffsetRefresh()
{
	local string OffsetX, OffsetY, OffsetZ, Pitch, Yaw, Roll, ride_id;

	ride_id = RideId_EditBox.GetString();
	OffsetX = OffsetX_EditBox.GetString();
	OffsetY = OffsetY_EditBox.GetString();
	OffsetZ = OffsetZ_EditBox.GetString();
	Pitch = Pitch_EditBox.GetString();
	Yaw = Yaw_EditBox.GetString();
	Roll = Roll_EditBox.GetString();
	ExecuteCommand(((((((((((((("///ride id=" $ ride_id) @ "x=") $ OffsetX) @ "y=") $ OffsetY) @ "z=") $ OffsetZ) @ "pitch=") $ Pitch) @ "yaw=") $ Yaw) @ "roll=") $ Roll));
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
		case "stat_l2_button":
			ExecuteCommand("///stat l2");
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
		case "option_button":
			ExecuteCommand("///ow");
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
		case "Effect_button":
			ExecuteCommand(("///se name=" $ Effect_EditBox.GetString()));
			break;
		case "Ride_button":
			if((Ride_button.GetButtonName() == "Ride"))
			{
				ExecuteCommand(("///ride id=" @ RideId_EditBox.GetString()));
				Ride_button.SetNameText("Unride");
				break;
			}
			else
			{
				ExecuteCommand("///unride");
				Ride_button.SetNameText("Ride");
				break;
			}
		case "ghost_button":
			if((ghost_button.GetButtonName() == "Ghost"))
			{
				ExecuteCommand("///ghost");
				ghost_button.SetNameText("Walk");
				break;
			}
			else
			{
				ExecuteCommand("///walk");
				ghost_button.SetNameText("Ghost");
				break;
			}
		case "search_button":
			ExecuteCommand("///searchobject");
			break;
		case "minimap_button":
			ExecuteEvent(1780, "");
			break;
		case "clone_button":
			ExecuteCommand("///spawnpc copy num=1");
			break;
		case "pv_button":
			ExecuteCommand("///sw name=PCViewerWnd");
			break;
		case "nv_button":
			ExecuteCommand("///nv");
			break;
		case "sv_button":
			ExecuteCommand("///sv");
			break;
		case "skill_search_button":
			ExecuteCommand("///sw name=UISkillToolWnd");
			break;
		case "sc_button":
			ExecuteCommand("///sce");
			break;
		case "Teleport_button":
			ExecuteCommand(((((("///teleport x=" @ TelX_EditBox.GetString()) @ "y=") @ TelY_EditBox.GetString()) @ "z=") @ TelZ_EditBox.GetString()));
			break;
		case "pe_button":
			ExecuteCommand("///photoshop");
			break;
		case "ui_button":
			ExecuteCommand("///ui");
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
			case "Player_EditBox":
				ExecuteCommand(("///playermove index=" @ Player_EditBox.GetString()));
				break;
			case "ZoneState_EditBox":
				ExecuteCommand(("///zonestate num=" @ ZoneState_EditBox.GetString()));
				break;
			case "Effect_EditBox":
				ExecuteCommand(("///se name=" $ Effect_EditBox.GetString()));
				break;
			case "RideId_EditBox":
				if((Ride_button.GetButtonName() == "Ride"))
				{
					ExecuteCommand(("///ride id=" @ RideId_EditBox.GetString()));
					Ride_button.SetNameText("Unride");
					break;
				}
				else
				{
					ExecuteCommand("///unride");
					Ride_button.SetNameText("Ride");
					break;
				}
			case "OffsetX_EditBox":
				RideOffsetRefresh();
				break;
			case "OffsetY_EditBox":
				RideOffsetRefresh();
				break;
			case "OffsetZ_EditBox":
				RideOffsetRefresh();
				break;
			case "Pitch_EditBox":
				RideOffsetRefresh();
				break;
			case "Yaw_EditBox":
				RideOffsetRefresh();
				break;
			case "Roll_EditBox":
				RideOffsetRefresh();
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

function OnComboBoxItemSelected(string strID, int Index)
{
	switch(strID)
	{
		case "Location_ComboBox":
			switch(Index)
			{
				case 0:
					TelX_EditBox.SetString("-20358");
					TelY_EditBox.SetString("-157358");
					TelZ_EditBox.SetString("-3727");
					break;
				case 1:
					TelX_EditBox.SetString("82674");
					TelY_EditBox.SetString("148621");
					TelZ_EditBox.SetString("-3465");
					break;
				case 2:
					TelX_EditBox.SetString("147451");
					TelY_EditBox.SetString("26999");
					TelZ_EditBox.SetString("-2204");
					break;
				case 3:
					TelX_EditBox.SetString("45340");
					TelY_EditBox.SetString("48220");
					TelZ_EditBox.SetString("-3060");
					break;
				case 4:
					TelX_EditBox.SetString("83756");
					TelY_EditBox.SetString("76950");
					TelZ_EditBox.SetString("-3710");
					break;
				case 5:
					TelX_EditBox.SetString("-28057");
					TelY_EditBox.SetString("186055");
					TelZ_EditBox.SetString("-4167");
					break;
				default:
					break;
			}
			break;
		case "BoneName_ComboBox":
			if((Index == 0))
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
				Class'NWindow.UIDATA_PAWNVIEWER'.static.ShowSelectedBone(m_ComboBoneName.GetString(Index));
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
	m_Windowname="PVBuilderCmdWnd"
}
