class SiegeWnd extends UICommonAPI
	dependson(UIPacket);

const TIMER_BTNRECURIT = 1;
const TIMER_BTNRECURITREFRESH = 3000;
const TIMER_TAB_ENABLE = 2;
const TIMER_TAB_ENABLEREFRESH = 1000;
const TAB_MAX = 2;

enum TYPE_CONFIRM
{
	RECRUIT,                        // 0
	Teleport,                       // 1
	OBSERVER                        // 2
};

enum TYPE_TELEPORT
{
	Left,                           // 0
	MIDDLE,                         // 1
	Right                           // 2
};

enum SiegeType
{
	READY,                          // 0
	Start,                          // 1
	End                             // 2
};

var string m_Windowname;
var WindowHandle Me;
var int typeConfirm;
var int typeTeleport;
var bool IsSiegeMember;
var bool IsOnTimer;
var bool IsOnTimerTabEnable;
var TextureHandle texturePledge;
var TextureHandle texturePledgeCrest;
var TextBoxHandle txtCastleName;
var TextBoxHandle txtSiegeState;
var TextBoxHandle txtPledgeName;
var TextBoxHandle txtPledgeMasterName;
var TextBoxHandle txtNumAttack;
var TextBoxHandle txtNumDefence;
var TextBoxHandle txtSiegeMercenaryConfirmDesc_Txt;
var WindowHandle SiegeMercenaryConfirmWnd;
var ButtonHandle btnRecruit;
var TextBoxHandle txtRecruit;
var int OwnerPledgeID;
var string OwnerPledgeName;
var string OwnerPledgeMasterName;
var int siegeState;
var bool IsMercenaryRecruit;
var array<INT64> currentIncomes;
var TextBoxHandle txtRecruitOK;
var ButtonHandle per10Btn;
var ButtonHandle per20Btn;
var ButtonHandle per30Btn;
var ButtonHandle per40Btn;
var ButtonHandle per50Btn;
var ButtonHandle btnRecruitOK;
var ButtonHandle BtnRanking;
var WindowHandle SiegeMercenaryRecruitmentWnd;
var int selectedPer;
var RichListCtrlHandle SiegeMercenaryRecruitment_RichList;
var array<int> mySelectedCastleIDs;
var array<int> castleIDs;
var int SelectedIndex;

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	texturePledge = GetTextureHandle((m_Windowname $ ".WndCastleInfo.texturePledge"));
	texturePledgeCrest = GetTextureHandle((m_Windowname $ ".WndCastleInfo.texturePledgeCrest"));
	txtCastleName = GetTextBoxHandle((m_Windowname $ ".WndCastleInfo.txtCastleName"));
	txtSiegeState = GetTextBoxHandle((m_Windowname $ ".WndCastleInfo.txtSiegeState"));
	txtPledgeName = GetTextBoxHandle((m_Windowname $ ".WndCastleInfo.txtPledgeName"));
	txtPledgeMasterName = GetTextBoxHandle((m_Windowname $ ".WndCastleInfo.txtPledgeMasterName"));
	txtNumAttack = GetTextBoxHandle((m_Windowname $ ".WndCastleInfo.txtNumAttack"));
	txtNumDefence = GetTextBoxHandle((m_Windowname $ ".WndCastleInfo.txtNumDefence"));
	txtSiegeMercenaryConfirmDesc_Txt = GetTextBoxHandle((m_Windowname $ ".SiegeMercenaryConfirmWnd.SiegeMercenaryConfirmDesc_Txt"));
	btnRecruit = GetButtonHandle((m_Windowname $ ".WndCastleInfo.btnRecruit"));
	BtnRanking = GetButtonHandle((m_Windowname $ ".WndCastleInfo.btnRanking"));
	SiegeMercenaryConfirmWnd = GetWindowHandle((m_Windowname $ ".SiegeMercenaryConfirmWnd"));
	txtRecruit = GetTextBoxHandle((m_Windowname $ ".WndCastleInfo.txtRecruit"));
	SiegeMercenaryRecruitmentWnd = GetWindowHandle((m_Windowname $ ".SiegeMercenaryRecruitmentWnd"));
	per10Btn = GetButtonHandle((((m_Windowname $ ".SiegeMercenaryRecruitmentWnd.per") $ string(1)) $ "0Btn"));
	per20Btn = GetButtonHandle((((m_Windowname $ ".SiegeMercenaryRecruitmentWnd.per") $ string(2)) $ "0Btn"));
	per30Btn = GetButtonHandle((((m_Windowname $ ".SiegeMercenaryRecruitmentWnd.per") $ string(3)) $ "0Btn"));
	per40Btn = GetButtonHandle((((m_Windowname $ ".SiegeMercenaryRecruitmentWnd.per") $ string(4)) $ "0Btn"));
	per50Btn = GetButtonHandle((((m_Windowname $ ".SiegeMercenaryRecruitmentWnd.per") $ string(5)) $ "0Btn"));
	per10Btn.SetNameText("10%");
	per20Btn.SetNameText("20%");
	per30Btn.SetNameText("30%");
	per40Btn.SetNameText("40%");
	per50Btn.SetNameText("50%");
	SiegeMercenaryRecruitment_RichList = GetRichListCtrlHandle((m_Windowname $ ".SiegeMercenaryRecruitmentWnd.SiegeMercenaryRecruitment_RichList"));
	SiegeMercenaryRecruitment_RichList.SetSelectedSelTooltip(false);
	SiegeMercenaryRecruitment_RichList.SetAppearTooltipAtMouseX(true);
	SiegeMercenaryRecruitment_RichList.SetUseStripeBackTexture(false);
	txtRecruitOK = GetTextBoxHandle((m_Windowname $ ".SiegeMercenaryRecruitmentWnd.txtRecruitOK"));
	btnRecruitOK = GetButtonHandle((m_Windowname $ ".SiegeMercenaryRecruitmentWnd.btnRecruitOK"));
	HideAllTabs();
	if(!IsAdenServer())
	{
		BtnRanking.HideWindow();
	}
	else
	{
		BtnRanking.ShowWindow();
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(11315);
	RegisterEvent(11310);
	RegisterEvent(11300);
	RegisterEvent(2450);
	return;
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 11315:
			HandleMCW_CastleSiegeInfo(param);
			break;
		case 11310:
			HandleMCW_CastleSiegeHUDInfo(param);
			break;
		case 11300:
			HandleEVMCW_CastleInfo(param);
			break;
		case 2450:
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "btnTeleportLeft":
			HandleBtnClickHelpTeleport(0);
			break;
		case "btnTeleportCenter":
			HandleBtnClickHelpTeleport(1);
			break;
		case "btnTeleportRight":
			HandleBtnClickHelpTeleport(2);
			break;
		case "btnAttend":
			GetWindowHandle("SiegeInfoMCWWnd").ShowWindow();
			GetWindowHandle("SiegeInfoMCWWnd").BringToFront();
			break;
		case "btnRecruit":
			if(IsMercenaryRecruit)
			{
				HandleBtnClickRecruit();
			}
			else
			{
				HandleShowRecruitWnd();
			}
			break;
		case "btnVolunteer":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("SiegeMercenaryWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SiegeMercenaryWnd");
			}
			else
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SiegeMercenaryWnd");
			}
			break;
		case "SiegeMercenaryConfirmOK_Btn":
			HandleOK();
		case "btnRecruitCancel":
			SiegeMercenaryRecruitmentWnd.HideWindow();
			GetWindowHandle((m_Windowname $ ".TextuerDescVolunteerwnd")).HideWindow();
			TabOnOff(true);
		case "SiegeMercenaryConfirmCancle_Btn":
			SiegeMercenaryConfirmWnd.HideWindow();
			break;
		case "btnRecruitOK":
			HandleBtnClickRecruit();
			break;
		case "per10Btn":
		case "per20Btn":
		case "per30Btn":
		case "per40Btn":
		case "per50Btn":
			HandleClickPerBtn(btnName);
			break;
		case "WindowHelp_BTN":
			HandleBtnClickHelp();
			break;
		case "btnObserver":
			HandleBtnClickObserver();
			break;
		case "btnRanking":
			if(GetWindowHandle("SiegeRankingWnd").IsShowWindow())
			{
				GetWindowHandle("SiegeRankingWnd").HideWindow();
			}
			else
			{
				GetWindowHandle("SiegeRankingWnd").ShowWindow();
			}
			break;
		default:
			break;
	}
	return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local int tabindex;

	switch(a_ButtonHandle.GetWindowName())
	{
		case "btnTab":
			tabindex = int(Right(a_ButtonHandle.GetParentWindowName(), 1));
			if((tabindex != SelectedIndex))
			{
				TabSetSelectedIndex(tabindex);
			}
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 1:
			IsOnTimer = false;
			Me.KillTimer(TimerID);
			SetbtnRecruitEnable();
			break;
		case 2:
			IsOnTimerTabEnable = false;
			Me.KillTimer(TimerID);
			TabOnOff(true);
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	local SiegeInfoMCWWnd SiegeInfoMCWWndScript;
	local int i;

	SetbtnRecruitDisable();
	txtRecruit.SetText(GetSystemString(13058));
	SiegeInfoMCWWndScript = SiegeInfoMCWWnd(GetScript("SiegeInfoMCWWnd"));
	mySelectedCastleIDs.Length = 0;
	i = 0;
	while((i < castleIDs.Length))
	{
		TabSetEntryOnOffByCatleID(castleIDs[i], false);
		SiegeInfoMCWWndScript.API_RequestMCWCastleSiegeAttackerList(castleIDs[i]);
		SiegeInfoMCWWndScript.API_RequestMCWCastleSiegeDefenderList(castleIDs[i]);
		i++;
	}
	SiegeMercenaryRecruitmentWnd.HideWindow();
	TabOnOff(true);
	SiegeMercenaryConfirmWnd.HideWindow();
	GetWindowHandle((m_Windowname $ ".TextuerDescVolunteerwnd")).HideWindow();
	Me.SetFocus();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SiegeMercenaryWnd");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SiegeInfoMCWWnd");
	IsSiegeMember = false;
	return;
}

function OnHide()
{
	if(GetWindowHandle("SiegeRankingWnd").IsShowWindow())
	{
		GetWindowHandle("SiegeRankingWnd").HideWindow();
	}
	return;
}

function HandleOK()
{
	switch(typeConfirm)
	{
		case 0:
			if(IsMercenaryRecruit)
			{
				API_RequestPledgeMercenaryRecruitInfoSet(0, 0, INT64(0));
			}
			else
			{
				API_RequestPledgeMercenaryRecruitInfoSet(1, 1, INT64(selectedPer));
			}
			Me.SetTimer(1, 3000);
			IsOnTimer = true;
			SetbtnRecruitDisable();
			break;
		case 1:
			Class'NWindow.TeleportListAPI'.static.RequestTeleport(GetCurrentTeleportID());
			break;
		case 2:
			API_C_EX_CASTLEWAR_OBSERVER_START();
			break;
		default:
			break;
	}
	return;
}

function int GetCurrentTeleportID()
{
	switch(typeTeleport)
	{
		case 0:
			return GetTeleportIDL();
			break;
		case 1:
			return GetTeleportIDMiddle();
			break;
		case 2:
			return GetTeleportIDR();
			break;
		default:
			break;
	}
	return -1;
}

function int GetTeleportIDL()
{
	switch(castleIDs[SelectedIndex])
	{
		case 3:
			return 421;
			break;
		case 7:
			return 427;
			break;
		default:
			break;
	}
}

function int GetTeleportIDMiddle()
{
	switch(castleIDs[SelectedIndex])
	{
		case 3:
			return 420;
			break;
		case 7:
			return 426;
			break;
		default:
			break;
	}
}

function int GetTeleportIDR()
{
	switch(castleIDs[SelectedIndex])
	{
		case 3:
			return 419;
			break;
		case 7:
			return 425;
			break;
		default:
			break;
	}
}

function HandleBtnClickHelp()
{
	local string strParam;

	if(getInstanceUIData().GetIsClassicServer())
	{
		ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "siege_help_aden001.htm"));
		ExecuteEvent(1210, strParam);
	}
	else
	{
		ExecuteEvent(1210, "155");
	}
	return;
}

function HandleBtnClickRecruit()
{
	typeConfirm = 0;
	SetConfirm();
	return;
}

function HandleBtnClickHelpTeleport(int Type)
{
	typeConfirm = 1;
	typeTeleport = Type;
	SetConfirm();
	return;
}

function HandleBtnClickObserver()
{
	typeConfirm = 2;
	SetConfirm();
	return;
}

function SetbtnRecruitEnable()
{
	local UserInfo uInfo;

	if(IsOnTimer)
	{
		return;
	}
	if(!IsSiegeMember)
	{
		return;
	}
	if((ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_bClanMaster == 0))
	{
		return;
	}
	GetPlayerInfo(uInfo);
	if((ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_clanID != uInfo.nClanID))
	{
		return;
	}
	txtRecruit.SetTextColor(GetColor(230, 217, 190, 255));
	btnRecruit.EnableWindow();
	return;
}

function SetbtnRecruitDisable()
{
	txtRecruit.SetTextColor(GetColor(120, 120, 120, 255));
	btnRecruit.DisableWindow();
	return;
}

function SetRecruit(int tmpCastleID, int MercenaryRecruit)
{
	IsMercenaryRecruit = (MercenaryRecruit > 0);
	IsSiegeMember = true;
	mySelectedCastleIDs.Length = (mySelectedCastleIDs.Length + 1);
	mySelectedCastleIDs[(mySelectedCastleIDs.Length - 1)] = tmpCastleID;
	TabSetEntryOnOffByCatleID(tmpCastleID, true);
	SetbtnRecruitEnable();
	if(IsMercenaryRecruit)
	{
		txtRecruit.SetText(GetSystemString(13059));
	}
	else
	{
		txtRecruit.SetText(GetSystemString(13058));
	}
	return;
}

function SetConfirm()
{
	switch(typeConfirm)
	{
		case 0:
			if(IsMercenaryRecruit)
			{
				txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemString(13065));
			}
			else
			{
				txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemString(13064));
			}
			break;
		case 1:
			SetTeleportInfo();
			break;
		case 2:
			txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemMessage(13091));
			break;
		default:
			break;
	}
	SiegeMercenaryConfirmWnd.ShowWindow();
	SiegeMercenaryConfirmWnd.SetFocus();
	return;
}

function string GetTeleportPositionName()
{
	switch(typeTeleport)
	{
		case 0:
			return GetSystemString(13051);
			break;
		case 1:
			return GetSystemString(13053);
			break;
		case 2:
			return GetSystemString(13052);
			break;
		default:
			break;
	}
}

function SetTeleportInfo()
{
	txtSiegeMercenaryConfirmDesc_Txt.SetText(((((MakeFullSystemMsg(GetSystemMessage(13166), MakeCostStringINT64(getInstanceUIData().GetTeleportPriceByID(GetCurrentTeleportID()))) $ "\\n\\n(") $ GetCastleName(castleIDs[SelectedIndex])) @ GetTeleportPositionName()) $ ")"));
	return;
}

function string GetMainTextureByClastleID(int castleID)
{
	switch(castleID)
	{
		case 3:
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleImg_Giran";
			break;
		case 7:
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleImg_Godard";
			break;
		default:
			break;
	}
}

function HandleMCW_CastleSiegeInfo(string param)
{
	local int castleID;
	local string numOfAttackerPledge, numOfDefenderPledge;
	local Texture PledgeCrestTexture, PledgeAllianceCrestTexture;
	local bool bPledge, bAlliance;

	ParseInt(param, "CastleID", castleID);
	txtCastleName.SetText(GetCastleName(castleID));
	ParseInt(param, "OwnerPledgeID", OwnerPledgeID);
	texturePledge.SetTexture("");
	texturePledgeCrest.SetTexture("");
	bPledge = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(OwnerPledgeID, PledgeCrestTexture);
	bAlliance = Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(OwnerPledgeID, PledgeAllianceCrestTexture);
	if(bPledge)
	{
		texturePledge.SetTextureWithObject(PledgeCrestTexture);
	}
	if(bAlliance)
	{
		texturePledgeCrest.SetTextureWithObject(PledgeAllianceCrestTexture);
	}
	GetTextureHandle((m_Windowname $ ".WndCastleInfo.textureMainImg")).SetTexture(GetMainTextureByClastleID(castleID));
	ParseInt(param, "SiegeState", siegeState);
	switch(siegeState)
	{
		case 0:
			txtSiegeState.SetText(GetSystemString(13048));
			break;
		case 1:
			txtSiegeState.SetText(GetSystemString(13049));
			break;
		case 2:
			txtSiegeState.SetText(GetSystemString(13050));
			Me.HideWindow();
			break;
		default:
			break;
	}
	ParseString(param, "OwnerPledgeName", OwnerPledgeName);
	txtPledgeName.SetText(OwnerPledgeName);
	ParseString(param, "OwnerPledgeMasterName", OwnerPledgeMasterName);
	txtPledgeMasterName.SetText(OwnerPledgeMasterName);
	Debug(("HandleMCW_CastleSiegeInfo" @ param));
	ParseString(param, "NumOfAttackerPledge", numOfAttackerPledge);
	txtNumAttack.SetText((numOfAttackerPledge @ GetSystemString(314)));
	ParseString(param, "NumOfDefenderPledge", numOfDefenderPledge);
	txtNumDefence.SetText((numOfDefenderPledge @ GetSystemString(314)));
	Me.ShowWindow();
	return;
}

function HandleMCW_CastleSiegeHUDInfo(string param)
{
	local int tmpSiegeState, tmpCastleID;

	if(!Me.IsShowWindow())
	{
		return;
	}
	ParseInt(param, "SiegeState", tmpSiegeState);
	ParseInt(param, "CastleID", tmpCastleID);
	if((castleIDs[tmpCastleID] != tmpCastleID))
	{
		return;
	}
	if((tmpSiegeState == siegeState))
	{
		return;
	}
	if((tmpSiegeState == 2))
	{
		Me.HideWindow();
		return;
	}
	API_RequestMCWCastleSiegeInfo(tmpCastleID);
	return;
}

function RichListCtrlRowData MakeRowData(int castleID, int Num)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 2;
	rowData.cellDataList[0].nReserved1 = 1;
	return rowData;
}

function RichListCtrlRowData MakeRowDataTitle(int castleID)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 1;
	rowData.cellDataList[0].nReserved1 = castleID;
	rowData.sOverlayTex = "L2UI_ct1.SiegeWnd.SiegeWnd_CastleHeaderBg";
	rowData.OverlayTexU = 411;
	rowData.OverlayTexV = 25;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetCastleName(castleID), GetColor(255, 221, 102, 255), false, 10, 0);
	return rowData;
}

function RichListCtrlRowData MakeRowDataTex(int castleID)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 2;
	rowData.cellDataList[0].nReserved1 = castleID;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(13113), GetColor(153, 153, 153, 255), false, 10, 0);
	rowData = MakeRowDataCommon(rowData);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, MakeCostStringINT64(currentIncomes[TabIndexByCastleID(castleID)]), GetColor(187, 170, 136, 255), false, -204);
	return rowData;
}

function RichListCtrlRowData MakeRowDataReward(int castleID)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 2;
	rowData.cellDataList[0].nReserved1 = castleID;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(13112), GetColor(153, 153, 153, 255), false, 10, 0);
	rowData = MakeRowDataCommon(rowData);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, MakeCostStringINT64(((currentIncomes[TabIndexByCastleID(castleID)] * INT64(selectedPer)) / INT64(100))), GetColor(153, 153, 153, 255), false, -204);
	return rowData;
}

function RichListCtrlRowData MakeRowDataCommon(RichListCtrlRowData rowData)
{
	addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_ct1.SiegeWnd.SiegeWnd_Richlist_AdenaTextBg", 207, 20, 15, 3);
	addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_ct1.Icon.Icon_DF_Common_Adena", 18, 14, 207, 4);
	return rowData;
}

function HandleEVMCW_CastleInfo(string param)
{
	local int tmpCastleID, tabNum;

	ParseInt(param, "CastleID", tmpCastleID);
	tabNum = TabIndexByCastleID(tmpCastleID);
	ParseINT64(param, "CurrentIncome", currentIncomes[tabNum]);
	HandleTexByTabNum(tabNum);
	return;
}

function HandleShowRecruitWnd()
{
	local int i;

	SetPerBtnSelect(-1);
	SetRecords();
	currentIncomes.Length = castleIDs.Length;
	i = 0;
	while((i < castleIDs.Length))
	{
		Class'NWindow.SiegeAPI'.static.RequestMCWCastleInfo(castleIDs[i]);
		i++;
	}
	txtRecruitOK.SetTextColor(GetColor(120, 120, 120, 255));
	btnRecruitOK.DisableWindow();
	SiegeMercenaryRecruitmentWnd.ShowWindow();
	TabOnOff(false);
	SiegeMercenaryConfirmWnd.HideWindow();
	GetWindowHandle((m_Windowname $ ".TextuerDescVolunteerwnd")).ShowWindow();
	return;
}

function SetRecords()
{
	local int i;

	SiegeMercenaryRecruitment_RichList.DeleteAllItem();
	i = 0;
	while((i < castleIDs.Length))
	{
		SiegeMercenaryRecruitment_RichList.InsertRecord(MakeRowDataTitle(castleIDs[i]));
		SiegeMercenaryRecruitment_RichList.InsertRecord(MakeRowDataTex(castleIDs[i]));
		SiegeMercenaryRecruitment_RichList.InsertRecord(MakeRowDataReward(castleIDs[i]));
		i++;
	}
	return;
}

function HandleReward()
{
	local int i;

	i = 0;
	while((i < castleIDs.Length))
	{
		HandleRewardByTabNum(i);
		i++;
	}
	return;
}

function HandleTexByTabNum(int tabNum)
{
	SiegeMercenaryRecruitment_RichList.ModifyRecord(((tabNum * 3) + 1), MakeRowDataTex(castleIDs[tabNum]));
	return;
}

function HandleRewardByTabNum(int tabNum)
{
	SiegeMercenaryRecruitment_RichList.ModifyRecord(((tabNum * 3) + 2), MakeRowDataReward(castleIDs[tabNum]));
	return;
}

function HandleClickPerBtn(string btnName)
{
	Debug(("HandleClickPerBtn" @ string(int(Right(btnName, 5)))));
	SetPerBtnSelect(int(Right(btnName, 5)));
	switch(Right(btnName, 5))
	{
		case "10Btn":
			SetPerBtnSelect(1);
			break;
		case "20Btn":
			SetPerBtnSelect(2);
			break;
		case "30Btn":
			SetPerBtnSelect(3);
			break;
		case "40Btn":
			SetPerBtnSelect(4);
			break;
		case "50Btn":
			SetPerBtnSelect(5);
			break;
		default:
			break;
	}
	return;
}

function SetPerBtnSelect(int Index)
{
	SetPerBtn(per10Btn, false);
	SetPerBtn(per20Btn, false);
	SetPerBtn(per30Btn, false);
	SetPerBtn(per40Btn, false);
	SetPerBtn(per50Btn, false);
	if((Index > 0))
	{
		SetPerBtn(GetButtonHandle((((m_Windowname $ ".SiegeMercenaryRecruitmentWnd.per") $ string(Index)) $ "0Btn")), true);
		txtRecruitOK.SetTextColor(GetColor(230, 217, 190, 255));
		btnRecruitOK.EnableWindow();
		selectedPer = (Index * 10);
		HandleReward();
	}
	else
	{
		selectedPer = 0;
	}
	return;
}

function SetPerBtn(ButtonHandle perBtn, bool Selected)
{
	if(Selected)
	{
		perBtn.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
	}
	else
	{
		perBtn.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
	}
	return;
}

function HideAllTabs()
{
	local int i;

	i = 0;
	while((i < 2))
	{
		GetWindowHandle(GetTabWindowName(i)).HideWindow();
		i++;
	}
	return;
}

function TabSetSelectedIndex(int tabNum)
{
	local int i;

	SelectedIndex = tabNum;
	i = 0;
	while((i < castleIDs.Length))
	{
		TabSetDeSelect(i);
		i++;
	}
	API_RequestMCWCastleSiegeInfo(castleIDs[SelectedIndex]);
	GetButtonHandle((GetTabWindowName(tabNum) $ ".btnTab")).SetTexture("L2UI_ct1.SiegeWnd.SiegeWnd_CastleTabButton_Down", "L2UI_ct1.SiegeWnd.SiegeWnd_CastleTabButton_Down", "L2UI_ct1.SiegeWnd.SiegeWnd_CastleTabButton_Down");
	Me.SetTimer(2, 1000);
	TabOnOff(false);
	SiegeMercenaryConfirmWnd.HideWindow();
	return;
}

function TabSetDeSelect(int tabNum)
{
	GetButtonHandle((GetTabWindowName(tabNum) $ ".btnTab")).SetTexture("L2UI_ct1.SiegeWnd.SiegeWnd_CastleTabButton", "L2UI_ct1.SiegeWnd.SiegeWnd_CastleTabButton_Over", "L2UI_ct1.SiegeWnd.SiegeWnd_CastleTabButton_Down");
	return;
}

function TabOnOff(bool On)
{
	local int i;
	local string TabWindowName;

	if(On)
	{
		if(IsOnTimerTabEnable)
		{
			return;
		}
		if(SiegeMercenaryRecruitmentWnd.IsShowWindow())
		{
			return;
		}
		i = 0;
		while((i < castleIDs.Length))
		{
			TabWindowName = GetTabWindowName(i);
			GetButtonHandle((TabWindowName $ ".btnTab")).EnableWindow();
			GetTextBoxHandle((TabWindowName $ ".txtTab")).SetTextColor(GetTabColorByEntry(GetEntryByTabNum(i)));
			i++;
		}
	}
	else
	{
		i = 0;
		while((i < castleIDs.Length))
		{
			TabWindowName = GetTabWindowName(i);
			GetButtonHandle((TabWindowName $ ".btnTab")).DisableWindow();
			GetTextBoxHandle((TabWindowName $ ".txtTab")).SetTextColor(GetColor(120, 120, 120, 255));
			i++;
		}
	}
	return;
}

function bool GetEntryByTabNum(int tabNum)
{
	local int i;

	i = 0;
	while((i < mySelectedCastleIDs.Length))
	{
		if((mySelectedCastleIDs[i] == castleIDs[tabNum]))
		{
			return true;
		}
		i++;
	}
	return false;
}

function int TabIndexByCastleID(int castleID)
{
	local int i;

	i = 0;
	while((i < castleIDs.Length))
	{
		if((castleIDs[i] == castleID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function TabSetEntryOnOffByCatleID(int castleID, bool bEntry)
{
	Debug((("---   --- TabSetEntryOnOffByCatleID ---   ---" @ string(castleID)) @ string(bEntry)));
	TabSetEntryOnOff(TabIndexByCastleID(castleID), bEntry);
	return;
}

function TabSetEntryOnOff(int tabNum, bool bEntry)
{
	local string WindowName;

	Debug((("TabSetEntryOnOff" @ string(tabNum)) @ string(bEntry)));
	WindowName = GetTabWindowName(tabNum);
	GetTextureHandle((WindowName $ ".TextuerIconTab")).SetTexture(getInstanceL2Util().GetClastleButtonIconName(castleIDs[tabNum], bEntry));
	GetTextBoxHandle((WindowName $ ".txtTab")).SetTextColor(GetTabColorByEntry(bEntry));
	return;
}

function Color GetTabColorByEntry(bool bEntry)
{
	if(bEntry)
	{
		return GetColor(255, 255, 0, 255);
	}
	return GetColor(230, 215, 190, 255);
}

function TabAdd(int tabNum, int castleID)
{
	TabSet(tabNum, castleID);
	castleIDs.Length = (castleIDs.Length + 1);
	castleIDs[tabNum] = castleID;
	return;
}

function TabSet(int tabNum, int castleID)
{
	local string WindowName;
	local TextBoxHandle txtTab;
	local TextureHandle TextuerIconTab;

	WindowName = GetTabWindowName(tabNum);
	GetWindowHandle(GetTabWindowName(tabNum)).ShowWindow();
	txtTab = GetTextBoxHandle((WindowName $ ".txtTab"));
	TextuerIconTab = GetTextureHandle((WindowName $ ".TextuerIconTab"));
	TextuerIconTab.SetTexture(getInstanceL2Util().GetClastleButtonIconName(castleID));
	txtTab.SetText(GetCastleName(castleID));
	return;
}

function TabDel(int tabNum)
{
	local int i;

	Me.HideWindow();
	castleIDs.Remove(tabNum, 1);
	GetWindowHandle(GetTabWindowName(castleIDs.Length)).HideWindow();
	i = 0;
	while((i < castleIDs.Length))
	{
		TabSet(i, castleIDs[i]);
		i++;
	}
	return;
}

function string GetTabWindowName(int tabNum)
{
	return ((m_Windowname $ ".TabWnd0") $ string(tabNum));
}

function API_RequestMCWCastleSiegeInfo(int tmpCastleID)
{
	Class'NWindow.SiegeAPI'.static.RequestMCWCastleSiegeInfo(tmpCastleID);
	return;
}

function API_RequestPledgeMercenaryRecruitInfoSet(int Type, int IsMercenaryRecruit, INT64 MercenaryReward)
{
	if((mySelectedCastleIDs.Length < 1))
	{
		return;
	}
	Debug((((("API_RequestPledgeMercenaryRecruitInfoSet" @ string(mySelectedCastleIDs[0])) @ string(Type)) @ string(IsMercenaryRecruit)) @ string(MercenaryReward)));
	Class'NWindow.SiegeAPI'.static.RequestPledgeMercenaryRecruitInfoSet(mySelectedCastleIDs[0], Type, IsMercenaryRecruit, MercenaryReward);
	return;
}

function API_C_EX_CASTLEWAR_OBSERVER_START()
{
	local array<byte> stream;
	local UIPacket._C_EX_CASTLEWAR_OBSERVER_START packet;

	packet.nCastleID = castleIDs[SelectedIndex];
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_CASTLEWAR_OBSERVER_START(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(616, stream);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if(SiegeMercenaryConfirmWnd.IsShowWindow())
	{
		SiegeMercenaryConfirmWnd.HideWindow();
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

defaultproperties
{
	m_Windowname="SiegeWnd"
}
