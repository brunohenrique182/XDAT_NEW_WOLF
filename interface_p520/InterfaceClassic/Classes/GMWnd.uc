class GMWnd extends UICommonAPI;

const DIALOGID_Recall = 0;
const DIALOGID_SendHome = 1;

var Color m_WhiteColor;
var EditBoxHandle m_hEditBox;
var WindowHandle m_hGMwnd;
var WindowHandle m_hGMDetailStatusWnd;
var WindowHandle m_hGMInventoryWnd;
var WindowHandle m_hGMMagicSkillWnd;
var WindowHandle m_hGMWarehouseWnd;
var WindowHandle m_hGMClanWnd;
var WindowHandle m_hGMFindTreeWnd;
var WindowHandle m_dialogWnd;
var ComboBoxHandle m_hCbClassName;
var ComboBoxHandle Race_ComboBox;
var ComboBoxHandle Sex_ComboBox;
var int m_targetID;
var int m_TargetClass;
var bool tickflag_ClassData;
var bool tickflag_OnShow;

function InitHandle()
{
	m_hGMwnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath);
	m_hEditBox = GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EditBox"));
	m_hGMDetailStatusWnd = GetWindowHandle("GMDetailStatusWnd");
	m_hGMInventoryWnd = GetWindowHandle("GMInventoryWnd");
	m_hGMMagicSkillWnd = GetWindowHandle("GMMagicSkillWnd");
	m_hGMWarehouseWnd = GetWindowHandle("GMWarehouseWnd");
	m_hGMClanWnd = GetWindowHandle("GMClanWnd");
	m_hGMFindTreeWnd = GetWindowHandle("GMFindTreeWnd");
	m_dialogWnd = GetWindowHandle("DialogBox");
	m_hCbClassName = GetComboBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".cbClassName"));
	InitRaceCombobox();
	InitSexCombobox();
	return;
}

function bool API_IsClassicServer()
{
	return IsClassicServer();
}

function InitRaceCombobox()
{
	Race_ComboBox = GetComboBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Race_ComboBox"));
	Race_ComboBox.AddStringWithReserved(((GetSystemString(2705) @ GetSystemString(175)) @ "(0)"), 0);
	Race_ComboBox.AddStringWithReserved(((GetSystemString(2705) @ GetSystemString(176)) @ "(10)"), 10);
	Race_ComboBox.AddStringWithReserved(((GetSystemString(171) @ GetSystemString(175)) @ "(18)"), 18);
	Race_ComboBox.AddStringWithReserved(((GetSystemString(171) @ GetSystemString(176)) @ "(25)"), 25);
	Race_ComboBox.AddStringWithReserved(((GetSystemString(172) @ GetSystemString(175)) @ "(31)"), 31);
	Race_ComboBox.AddStringWithReserved(((GetSystemString(172) @ GetSystemString(176)) @ "(38)"), 38);
	Race_ComboBox.AddStringWithReserved(((GetSystemString(173) @ GetSystemString(175)) @ "(44)"), 44);
	Race_ComboBox.AddStringWithReserved(((GetSystemString(173) @ GetSystemString(176)) @ "(49)"), 49);
	Race_ComboBox.AddStringWithReserved((GetSystemString(174) @ "(53)"), 53);
	if(API_IsClassicServer())
	{
		Race_ComboBox.AddStringWithReserved((GetSystemString(1544) @ "(192)"), 192);
		Race_ComboBox.AddStringWithReserved((GetSystemString(13536) @ "(208)"), 208);
		Race_ComboBox.AddStringWithReserved((GetSystemString(14614) @ "(236)"), 236);
		Race_ComboBox.AddStringWithReserved((GetSystemString(14615) @ "(240)"), 240);
		Race_ComboBox.AddStringWithReserved("- 추가 직업 ----------------------", -1);  // EN?: - Additional occupations ----------------------
		Race_ComboBox.AddStringWithReserved(((GetSystemString(13221) @ GetSystemString(2705)) @ "(196)"), 196);
		Race_ComboBox.AddStringWithReserved(((GetSystemString(13221) @ GetSystemString(171)) @ "(200)"), 200);
		Race_ComboBox.AddStringWithReserved(((GetSystemString(13221) @ GetSystemString(172)) @ "(204)"), 204);
		Race_ComboBox.AddStringWithReserved((GetSystemString(14043) @ "(217)"), 217);
		Race_ComboBox.AddStringWithReserved((((GetSystemString(282) @ GetSystemString(2705)) @ GetSystemString(177)) @ "(221)"), 221);
		Race_ComboBox.AddStringWithReserved((((GetSystemString(282) @ GetSystemString(172)) @ GetSystemString(178)) @ "(225)"), 225);
		Race_ComboBox.AddStringWithReserved((GetSystemString(14898) @ "(247)"), 247);
		Race_ComboBox.AddStringWithReserved((GetSystemString(14968) @ "(251)"), 251);
	}
	else
	{
		Race_ComboBox.AddStringWithReserved((GetSystemString(14544) @ "(231)"), 231);
		Race_ComboBox.AddStringWithReserved((GetSystemString(1561) @ "(123)"), 123);
		Race_ComboBox.AddStringWithReserved((GetSystemString(1562) @ "(124)"), 124);
		Race_ComboBox.AddStringWithReserved(((GetSystemString(3273) @ GetSystemString(175)) @ "(182)"), 182);
		Race_ComboBox.AddStringWithReserved(((GetSystemString(3273) @ GetSystemString(176)) @ "(183)"), 183);
		Race_ComboBox.AddStringWithReserved("- 추가 직업 ----------------------", -1);  // EN?: - Additional occupations ----------------------
		Race_ComboBox.AddStringWithReserved((GetSystemString(13221) @ "(212)"), 212);
		Race_ComboBox.AddStringWithReserved((GetSystemString(14898) @ "(255)"), 255);
	}
	return;
}

function InitSexCombobox()
{
	Sex_ComboBox = GetComboBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Sex_ComboBox"));
	Sex_ComboBox.SYS_AddStringWithReserved(177, 0);
	Sex_ComboBox.SYS_AddStringWithReserved(178, 1);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(2280);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(980);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	InitHandle();
	m_WhiteColor.R = 220;
	m_WhiteColor.G = 220;
	m_WhiteColor.B = 220;
	m_WhiteColor.A = 255;
	m_targetID = 0;
	m_hEditBox.DisableWindow();
	return;
}

event OnTick()
{
	local UserInfo uInfo;

	if((tickflag_OnShow == true))
	{
		m_hEditBox.EnableWindow();
		m_hEditBox.SetFocus();
		tickflag_OnShow = false;
	}
	if((tickflag_ClassData == true))
	{
		if(!GetUserInfo(m_targetID, uInfo))
		{
			m_hOwnerWnd.DisableTick();
			return;
		}
		if((m_TargetClass != uInfo.nSubClass))
		{
			m_TargetClass = uInfo.nSubClass;
			SetClassTypeComboBox();
			m_hOwnerWnd.DisableTick();
		}
		tickflag_ClassData = false;
	}
	m_hOwnerWnd.DisableTick();
	return;
}

event OnComboBoxItemSelected(string strID, int IndexID)
{
	switch(strID)
	{
		case "Race_ComboBox":
			SetRace(IndexID);
			break;
		case "Sex_ComboBox":
			SetSex(IndexID);
			break;
		case "cbClassName":
			SetClass(IndexID);
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 2280:
			HandleShowGMWnd();
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			HandleDialogCancel();
			break;
		case 980:
			HandleTargetUpdate();
			break;
		default:
			break;
	}
	return;
}

event OnHide()
{
	m_hEditBox.DisableWindow();
	Class'InterfaceClassic.ChatWnd'.static.Inst()._HandleHideDevTool();
	InventoryWnd(GetScript("InventoryWnd"))._HandleHideDevTool();
	return;
}

event OnShow()
{
	InvalidateOnShow();
	HandleTargetUpdate();
	checkVisibleLockButton();
	Class'InterfaceClassic.ChatWnd'.static.Inst()._HandleShowDevTool();
	return;
}

event OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		case "MsgSearchButton":
			onClickMsgSearchButton();
			break;
		case "TeleButton":
			OnClickTeleButton();
			break;
		case "MoveButton":
			OnClickMoveButton();
			break;
		case "RecallButton":
			OnClickRecallButton();
			break;
		case "DetailStatusButton":
			OnClickDetailStatusButton();
			break;
		case "InventoryButton":
			OnClickInventoryButton();
			break;
		case "MagicSkillButton":
			OnClickMagicSkillButton();
			break;
		case "InfoButton":
			OnClickInfoButton();
			break;
		case "StoreButton":
			OnClickStoreButton();
			break;
		case "ClanButton":
			OnClickClanButton();
			break;
		case "PetitionButton":
			OnClickPetitionButton();
			break;
		case "SendHomeButton":
			OnClickSendHomeButton();
			break;
		case "NPCListButton":
			OnClickNPCListButton();
			break;
		case "ItemListButton":
			OnClickItemListButton();
			break;
		case "SkillListButton":
			OnClickSkillListButton();
			break;
		case "ForcePetitionButton":
			OnClickForcePetitionButton();
			break;
		case "ChangeServerButton":
			OnClickChangeServerButton();
			break;
		case "UIButton":
			OnClickUIButton();
			break;
		case "QuestListButton":
			OnClickQuestListButton();
			break;
		case "TargettingButton":
			OnClickTargetButton();
			break;
		case "ClassChangeButton":
			OnClickClassChangeButton();
			break;
		case "LockBtn":
		case "UnLockBtn":
			OnClickLockButton();
			break;
		case "questSearchToolButton":
			LoadWindowClick("UIQuestToolWnd");
			break;
		case "bcToolBtn":
			LoadWindowClick("UICommandWnd");
			break;
		case "debugButton":
			toggleWindow("DebugWnd", true, false);
			break;
		case "builderCmdButton":
			LoadWindowClick("BuilderCmdWnd");
			break;
		case "yebisCmdButton":
			LoadWindowClick("YebisCmdWnd");
			break;
		case "SkillDetailButton":
			UISkillToolWnd(GetScript("UISkillToolWnd"))._Toggle();
			break;
		case "HelpButton":
			HelpWnd(GetScript("HelpWnd")).LoadHtmlTest(htmlSetHtmlStart(m_hEditBox.GetString()));
			HelpWnd(GetScript("HelpWnd")).m_hOwnerWnd.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function SetClassTypeComboBox()
{
	local int classNameSysString, i;
	local array<int> EnableClassIndexList;
	local int Len, classIndex;
	local UserInfo TargetInfo;
	local int myClassIndex;

	m_hCbClassName.Clear();
	if(!GetTargetInfo(TargetInfo))
	{
		return;
	}
	if(TargetInfo.bNpc)
	{
		return;
	}
	Class'NWindow.UIDataManager'.static.GetEnableClassIndexList(TargetInfo.Class, EnableClassIndexList);
	Len = EnableClassIndexList.Length;
	i = 0;
	while((i < Len))
	{
		classIndex = EnableClassIndexList[i];
		classNameSysString = Class'NWindow.UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(classIndex);
		m_hCbClassName.AddStringWithReserved((((GetSystemString(classNameSysString) @ "(") $ string(classIndex)) $ ")"), classIndex);
		if((TargetInfo.nSubClass == classIndex))
		{
			myClassIndex = i;
		}
		++i;
	}
	m_hCbClassName.SetSelectedNum(myClassIndex);
	return;
}

function SetRace(int IndexID)
{
	if((m_targetID < 1))
	{
		return;
	}
	switch(Race_ComboBox.GetReserved(IndexID))
	{
		case 0:
			ExecuteCommand("//setparam race 0 0");
			break;
		case 10:
			ExecuteCommand("//setparam race 0 1");
			break;
		case 18:
			ExecuteCommand("//setparam race 1 0");
			break;
		case 25:
			ExecuteCommand("//setparam race 1 1");
			break;
		case 31:
			ExecuteCommand("//setparam race 2 0");
			break;
		case 38:
			ExecuteCommand("//setparam race 2 1");
			break;
		case 44:
			ExecuteCommand("//setparam race 3 0");
			break;
		case 49:
			ExecuteCommand("//setparam race 3 1");
			break;
		case 53:
			ExecuteCommand("//setparam race 4 0");
			break;
		case 192:
			ExecuteCommand("//setparam race 5 0");
		case 123:
			ExecuteCommand("//setparam race 5 0");
			break;
		case 124:
			ExecuteCommand("//setparam race 5 1");
			break;
			break;
		case 182:
			ExecuteCommand("//setparam race 6 0");
			break;
		case 183:
			ExecuteCommand("//setparam race 6 1");
			break;
		case 208:
			ExecuteCommand("//setparam race 30 1");
			break;
		case 196:
		case 212:
			ExecuteCommand("//setparam race 0 0");
			ExecuteCommand("//setparam sex 0");
			ExecuteCommand(("//setclass" @ string(Race_ComboBox.GetReserved(IndexID))));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");  // EN?: A restart is required.
			break;
		case 200:
			ExecuteCommand("//setparam race 1 0");
			ExecuteCommand("//setparam sex 0");
			ExecuteCommand(("//setclass" @ string(Race_ComboBox.GetReserved(IndexID))));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");  // EN?: A restart is required.
			break;
		case 204:
			ExecuteCommand("//setparam race 2 0");
			ExecuteCommand("//setparam sex 0");
			ExecuteCommand(("//setclass" @ string(Race_ComboBox.GetReserved(IndexID))));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");  // EN?: A restart is required.
			break;
		case 217:
			ExecuteCommand("//setparam race 3 0");
			ExecuteCommand("//setparam sex 0");
			ExecuteCommand(("//setclass" @ string(Race_ComboBox.GetReserved(IndexID))));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");  // EN?: A restart is required.
			break;
		case 221:
			ExecuteCommand("//setparam race 0 0");
			ExecuteCommand("//setparam sex 0");
			ExecuteCommand(("//setclass" @ string(Race_ComboBox.GetReserved(IndexID))));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");  // EN?: A restart is required.
			break;
		case 225:
			ExecuteCommand("//setparam race 2 0");
			ExecuteCommand("//setparam sex 1");
			ExecuteCommand(("//setclass" @ string(Race_ComboBox.GetReserved(IndexID))));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");  // EN?: A restart is required.
			break;
		case 236:
			ExecuteCommand("//setparam race 31 1");
			ExecuteCommand("//setparam sex 1");
			ExecuteCommand(("//setclass" @ string(Race_ComboBox.GetReserved(IndexID))));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");  // EN?: A restart is required.
			break;
		case 236:
			ExecuteCommand("//setparam race 31 0");
			ExecuteCommand("//setparam sex 0");
			ExecuteCommand(("//setclass" @ string(Race_ComboBox.GetReserved(IndexID))));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");  // EN?: A restart is required.
			break;
		case 247:
		case 255:
			ExecuteCommand("//setparam race 0 0");
			ExecuteCommand("//setparam sex 0");
			ExecuteCommand(("//setclass" @ string(Race_ComboBox.GetReserved(IndexID))));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");  // EN?: A restart is required.
			break;
		case 251:
			ExecuteCommand("//setparam race 2 0");
			ExecuteCommand("//setparam sex 1");
			ExecuteCommand(("//setclass" @ string(Race_ComboBox.GetReserved(IndexID))));
			getInstanceL2Util().showGfxScreenMessage("재시작이 필요 합니다.");  // EN?: A restart is required.
			break;
		default:
			break;
	}
	InvalidateClass();
	return;
}

function SetSex(int IndexID)
{
	if((m_targetID < 1))
	{
		return;
	}
	ExecuteCommand(("//setparam sex" @ string(Sex_ComboBox.GetReserved(IndexID))));
	InvalidateClass();
	return;
}

function SetClass(int IndexID)
{
	local int classIndex;

	classIndex = m_hCbClassName.GetReserved(IndexID);
	if((classIndex >= 0))
	{
		ExecuteCommand(("//setclass " @ string(classIndex)));
	}
	return;
}

function SetSelectTargetRaceComboBox()
{
	local UserInfo uInfo;
	local int j;

	if(!GetTargetInfo(uInfo))
	{
		return;
	}
	j = 0;
	while((j < Race_ComboBox.GetNumOfItems()))
	{
		if((uInfo.Class == Race_ComboBox.GetReserved(j)))
		{
			Race_ComboBox.SetSelectedNum(j);
			return;
		}
		j++;
	}
	return;
}

function SetSelectTaargetSexComboBox()
{
	local UserInfo uInfo;

	if(!GetTargetInfo(uInfo))
	{
		return;
	}
	Sex_ComboBox.SetSelectedNum(uInfo.nSex);
	return;
}

function InvalidateClass()
{
	local UserInfo uInfo;

	m_TargetClass = -1;
	if(!GetTargetInfo(uInfo))
	{
		return;
	}
	m_TargetClass = uInfo.nSubClass;
	m_hOwnerWnd.EnableTick();
	tickflag_ClassData = true;
	return;
}

function InvalidateOnShow()
{
	m_hOwnerWnd.EnableTick();
	tickflag_OnShow = true;
	return;
}

function HandleDialogOK()
{
	if(!DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case 0:
			Recall();
			break;
		case 1:
			SendHome();
			break;
		default:
			break;
	}
	return;
}

function HandleDialogCancel()
{
	if(!DialogIsMine())
	{
		return;
	}
	return;
}

function Recall()
{
	local string EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if((EditBoxString != ""))
	{
		ExecuteCommand(("//recall" @ EditBoxString));
	}
	return;
}

function SendHome()
{
	local string EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if((EditBoxString != ""))
	{
		ExecuteCommand(("//sendhome" @ EditBoxString));
	}
	return;
}

function HandleTargetUpdate()
{
	local int m_nowTargetID;
	local UserInfo Info;

	if(!m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	m_nowTargetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
	if((m_nowTargetID == m_targetID))
	{
		return;
	}
	if((m_nowTargetID < 1))
	{
		m_targetID = 0;
		if(m_hEditBox.IsEnableWindow())
		{
			m_hEditBox.SetString("");
		}
		return;
	}
	GetTargetInfo(Info);
	if(((m_nowTargetID > 0) && (Info.bNpc == false)))
	{
		if(m_hEditBox.IsEnableWindow())
		{
			m_hEditBox.SetString(Info.Name);
		}
	}
	m_targetID = m_nowTargetID;
	SetSelectTargetRaceComboBox();
	SetSelectTaargetSexComboBox();
	SetClassTypeComboBox();
	return;
}

function HandleShowGMWnd()
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
		m_hGMwnd.SetFocus();
	}
	return;
}

function onClickMsgSearchButton()
{
	toggleWindow("UISysMsgToolWnd", true);
	return;
}

function OnClickTeleButton()
{
	local string EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if((EditBoxString != ""))
	{
		ExecuteCommand(("//teleportto" @ EditBoxString));
	}
	return;
}

function OnClickMoveButton()
{
	ExecuteCommand("//instant_move");
	return;
}

function OnClickRecallButton()
{
	DialogSetID(0);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(1220));
	return;
}

function OnClickDetailStatusButton()
{
	local string EditBoxString;
	local GMDetailStatusWnd GMDetailStatusWndScript;

	EditBoxString = m_hEditBox.GetString();
	if((EditBoxString != ""))
	{
		GMDetailStatusWndScript = GMDetailStatusWnd(m_hGMDetailStatusWnd.GetScript());
		GMDetailStatusWndScript.ShowStatus(EditBoxString);
	}
	else
	{
		AddSystemMessage(364);
	}
	return;
}

function OnClickInventoryButton()
{
	local string EditBoxString;
	local GMInventoryWnd GMInventoryWndScript;

	EditBoxString = m_hEditBox.GetString();
	if((EditBoxString != ""))
	{
		GMInventoryWndScript = GMInventoryWnd(m_hGMInventoryWnd.GetScript());
		GMInventoryWndScript.ShowInventory(EditBoxString);
	}
	else
	{
		AddSystemMessage(364);
	}
	return;
}

function OnClickMagicSkillButton()
{
	local string EditBoxString;
	local GMMagicSkillWnd GMMagicSkillWndScript;

	EditBoxString = m_hEditBox.GetString();
	GMMagicSkillWndScript = GMMagicSkillWnd(m_hGMMagicSkillWnd.GetScript());
	GMMagicSkillWndScript.ShowMagicSkill(EditBoxString);
	return;
}

function OnClickInfoButton()
{
	local string EditBoxString;
	local UserInfo uInfo;

	GetTargetInfo(uInfo);
	if((uInfo.bNpc == true))
	{
		ExecuteCommand("//debug .");
	}
	else
	{
		EditBoxString = m_hEditBox.GetString();
		if((EditBoxString != ""))
		{
			ExecuteCommand(("//debug" @ EditBoxString));
		}
	}
	return;
}

function OnClickStoreButton()
{
	local string EditBoxString;
	local GMWarehouseWnd GMWarehouseWndScript;

	EditBoxString = m_hEditBox.GetString();
	if((EditBoxString != ""))
	{
		GMWarehouseWndScript = GMWarehouseWnd(m_hGMWarehouseWnd.GetScript());
		GMWarehouseWndScript.ShowWarehouse(EditBoxString);
	}
	else
	{
		AddSystemMessage(364);
	}
	return;
}

function OnClickClanButton()
{
	local string EditBoxString;
	local GMClanWnd GMClanWndScript;

	EditBoxString = m_hEditBox.GetString();
	GMClanWndScript = GMClanWnd(m_hGMClanWnd.GetScript());
	GMClanWndScript.ShowClan(EditBoxString);
	return;
}

function OnClickPetitionButton()
{
	local string EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if((EditBoxString != ""))
	{
		ExecuteCommand(("//add_peti_chat" @ EditBoxString));
	}
	return;
}

function OnClickSendHomeButton()
{
	DialogSetID(1);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(1221));
	return;
}

function OnClickNPCListButton()
{
	local string EditBoxString;
	local GMFindTreeWnd m_GMFindTreeWnd;

	EditBoxString = m_hEditBox.GetString();
	m_GMFindTreeWnd = GMFindTreeWnd(m_hGMFindTreeWnd.GetScript());
	m_GMFindTreeWnd._Toggle(EditBoxString, LISTTYPE_NPC);
	return;
}

function OnClickItemListButton()
{
	local string EditBoxString;
	local GMFindTreeWnd m_GMFindTreeWnd;

	EditBoxString = m_hEditBox.GetString();
	m_GMFindTreeWnd = GMFindTreeWnd(m_hGMFindTreeWnd.GetScript());
	m_GMFindTreeWnd._Toggle(EditBoxString, LISTTYPE_ITEM);
	return;
}

function OnClickSkillListButton()
{
	local string EditBoxString;
	local GMFindTreeWnd m_GMFindTreeWnd;

	EditBoxString = m_hEditBox.GetString();
	m_GMFindTreeWnd = GMFindTreeWnd(m_hGMFindTreeWnd.GetScript());
	m_GMFindTreeWnd._Toggle(EditBoxString, LISTTYPE_SKILL);
	return;
}

function OnClickForcePetitionButton()
{
	local string EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if((EditBoxString != ""))
	{
		ExecuteCommand((("//force_peti" @ EditBoxString) @ GetSystemMessage(1528)));
	}
	return;
}

function OnClickChangeServerButton()
{
	local string EditBoxString;
	local UserInfo PlayerInfo;

	EditBoxString = m_hEditBox.GetString();
	if((EditBoxString == ""))
	{
		return;
	}
	if(!GetPlayerInfo(PlayerInfo))
	{
		return;
	}
	Class'NWindow.GMAPI'.static.BeginGMChangeServer(int(EditBoxString), PlayerInfo.Loc);
	return;
}

function OnClickUIButton()
{
	local WindowHandle UIToolWnd;

	UIToolWnd = GetWindowHandle("UIToolWnd");
	if(UIToolWnd.IsShowWindow())
	{
		UIToolWnd.HideWindow();
	}
	else
	{
		UIToolWnd.ShowWindow();
	}
	UIToolWnd.SetFocus();
	return;
}

function OnClickQuestListButton()
{
	local string EditBoxString;
	local GMFindTreeWnd m_GMFindTreeWnd;

	EditBoxString = m_hEditBox.GetString();
	m_GMFindTreeWnd = GMFindTreeWnd(m_hGMFindTreeWnd.GetScript());
	m_GMFindTreeWnd._Toggle(EditBoxString, LISTTYPE_QUEST);
	return;
}

function LoadWindowClick(string WindowName)
{
	local WindowHandle NewWindow;

	NewWindow = GetWindowHandle(WindowName);
	NewWindow.ShowWindow();
	NewWindow.SetFocus();
	return;
}

function OnClickLockButton()
{
	if(m_hEditBox.IsEnableWindow())
	{
		m_hEditBox.DisableWindow();
	}
	else
	{
		m_hEditBox.EnableWindow();
	}
	checkVisibleLockButton();
	return;
}

function checkVisibleLockButton()
{
	if(m_hEditBox.IsEnableWindow())
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UnlockBtn")).ShowWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".LockBtn")).HideWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UnlockBtn")).HideWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".LockBtn")).ShowWindow();
	}
	return;
}

function OnClickTargetButton()
{
	local string EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	if((EditBoxString != ""))
	{
		ExecuteCommand(("/target" @ EditBoxString));
	}
	return;
}

function OnClickClassChangeButton()
{
	local string EditBoxString;
	local GMFindTreeWnd m_GMFindTreeWnd;

	EditBoxString = m_hEditBox.GetString();
	m_GMFindTreeWnd = GMFindTreeWnd(m_hGMFindTreeWnd.GetScript());
	m_GMFindTreeWnd._Toggle(EditBoxString, LISTTYPE_CLASS);
	return;
}

function OnClickFindListButton()
{
	local string EditBoxString;
	local GMFindTreeWnd m_GMFindTreeWnd;

	EditBoxString = m_hEditBox.GetString();
	m_GMFindTreeWnd = GMFindTreeWnd(m_hGMFindTreeWnd.GetScript());
	m_GMFindTreeWnd._Toggle(EditBoxString, LISTTYPE_ITEM);
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).HideWindow();
	return;
}
