class SiegeInfoWnd extends UICommonAPI;

var bool m_bShow;
var int m_CastleID;
var string m_CastleName;
var int m_PlayerClanID;
var bool m_IsCastleOwner;
var int m_SiegeTime;
var array<int> m_SelectableTimeArray;
var bool m_IsExistMyClanIDinAttackSide;
var bool m_IsExistMyClanIDinDefenseSide;
var int m_AcceptedClan;
var int m_WaitingClan;
var int m_DialogClanID;
var WindowHandle m_wndTop;
var TabHandle TabCtrl;
var TextBoxHandle txtCastleName;
var TextBoxHandle txtOwnerName;
var TextBoxHandle txtClanName;
var TextBoxHandle txtAllianceName;
var TextureHandle texClan;
var TextureHandle texAlliance;
var TextBoxHandle txtCurTime;
var TextBoxHandle txtSiegeTime;
var ListCtrlHandle lstAttackClan;
var TextBoxHandle txtAttackCount;
var ButtonHandle btnAttackApply;
var ButtonHandle btnAttackCancel;
var ListCtrlHandle lstDefenseClan;
var TextBoxHandle txtDefenseCount;
var ButtonHandle btnDefenseApply;
var ButtonHandle btnDefenseCancel;
var ButtonHandle btnDefenseReject;
var ButtonHandle btnDefenseConfirm;
var TextureHandle tabLineBgTail;

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1450);
	RegisterEvent(1460);
	RegisterEvent(1470);
	RegisterEvent(1480);
	RegisterEvent(1490);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	m_bShow = false;
	m_CastleID = 0;
	m_CastleName = "";
	m_SiegeTime = 0;
	m_AcceptedClan = 0;
	m_WaitingClan = 0;
	m_wndTop = GetWindowHandle("SiegeInfoWnd");
	TabCtrl = GetTabHandle("SiegeInfoWnd.TabCtrl");
	txtCastleName = GetTextBoxHandle("SiegeInfoWnd.txtCastleName");
	txtOwnerName = GetTextBoxHandle("SiegeInfoWnd.txtOwnerName");
	txtClanName = GetTextBoxHandle("SiegeInfoWnd.txtClanName");
	txtAllianceName = GetTextBoxHandle("SiegeInfoWnd.txtAllianceName");
	texClan = GetTextureHandle("SiegeInfoWnd.texClan");
	texAlliance = GetTextureHandle("SiegeInfoWnd.texAlliance");
	txtCurTime = GetTextBoxHandle("SiegeInfoWnd.SiegeInfoWnd_Date.txtCurTime");
	txtSiegeTime = GetTextBoxHandle("SiegeInfoWnd.SiegeInfoWnd_Date.txtSiegeTime");
	lstAttackClan = GetListCtrlHandle("SiegeInfoWnd.SiegeInfoWnd_Party1.lstClan");
	txtAttackCount = GetTextBoxHandle("SiegeInfoWnd.SiegeInfoWnd_Party1.txtCount");
	btnAttackApply = GetButtonHandle("SiegeInfoWnd.SiegeInfoWnd_Party1.btnAttackApply");
	btnAttackCancel = GetButtonHandle("SiegeInfoWnd.SiegeInfoWnd_Party1.btnAttackCancel");
	lstDefenseClan = GetListCtrlHandle("SiegeInfoWnd.SiegeInfoWnd_Party2.lstClan");
	txtDefenseCount = GetTextBoxHandle("SiegeInfoWnd.SiegeInfoWnd_Party2.txtCount");
	btnDefenseApply = GetButtonHandle("SiegeInfoWnd.SiegeInfoWnd_Party2.btnDefenseApply");
	btnDefenseCancel = GetButtonHandle("SiegeInfoWnd.SiegeInfoWnd_Party2.btnDefenseCancel");
	btnDefenseReject = GetButtonHandle("SiegeInfoWnd.SiegeInfoWnd_Party2.btnDefenseReject");
	btnDefenseConfirm = GetButtonHandle("SiegeInfoWnd.SiegeInfoWnd_Party2.btnDefenseConfirm");
	tabLineBgTail = GetTextureHandle("SiegeInfoWnd.tabLineBgTail");
	UpdateAttackCount();
	UpdateDefenseCount();
	return;
}

function bool getDefenceTabVisibleByCastleID()
{
	switch(m_CastleID)
	{
		case 1:
			return !getInstanceUIData().GetIsClassicServer();
			break;
		default:
			break;
	}
	return true;
}

function toggleDefenceTabVisible(bool visible)
{
	if(visible)
	{
		TabCtrl.SetButtonName(2, GetSystemString(587));
		TabCtrl.SetDisable(2, false);
		tabLineBgTail.SetWindowSize(36, 23);
	}
	else
	{
		TabCtrl.SetButtonDisableTexture(2, "L2UI_ct1.Misc_DF_Blank");
		TabCtrl.SetDisable(2, true);
		TabCtrl.SetButtonName(2, "");
		tabLineBgTail.SetWindowSize(111, 23);
	}
	return;
}

function OnShow()
{
	m_bShow = true;
	return;
}

function OnHide()
{
	m_bShow = false;
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 1450))
	{
		HandleSiegeInfo(param);
	}
	else if((Event_ID == 1460))
	{
		HandleSiegeInfoClanListStart(param);
	}
	else if((Event_ID == 1470))
	{
		HandleSiegeInfoClanList(param);
	}
	else if((Event_ID == 1480))
	{
		HandleSiegeInfoClanListEnd(param);
	}
	else if((Event_ID == 1710))
	{
		if(DialogIsMine())
		{
			if((DialogGetID() == 1))
			{
				Class'NWindow.SiegeAPI'.static.RequestJoinCastleSiege(m_CastleID, 1, 1);
			}
			else if((DialogGetID() == 2))
			{
				Class'NWindow.SiegeAPI'.static.RequestJoinCastleSiege(m_CastleID, 1, 0);
			}
			else if((DialogGetID() == 3))
			{
				Class'NWindow.SiegeAPI'.static.RequestJoinCastleSiege(m_CastleID, 0, 1);
			}
			else if((DialogGetID() == 4))
			{
				Class'NWindow.SiegeAPI'.static.RequestJoinCastleSiege(m_CastleID, 0, 0);
			}
			else if((DialogGetID() == 5))
			{
				if((m_DialogClanID > 0))
				{
					Class'NWindow.SiegeAPI'.static.RequestConfirmCastleSiegeWaitingList(m_CastleID, m_DialogClanID, 0);
					m_DialogClanID = 0;
				}
			}
			else if((DialogGetID() == 6))
			{
				if((m_DialogClanID > 0))
				{
					Class'NWindow.SiegeAPI'.static.RequestConfirmCastleSiegeWaitingList(m_CastleID, m_DialogClanID, 1);
					m_DialogClanID = 0;
				}
			}
		}
	}
	return;
}

function clearInfo()
{
	local Rect rectWnd;

	rectWnd = m_wndTop.GetRect();
	m_CastleID = 0;
	m_CastleName = "";
	m_IsCastleOwner = false;
	m_SiegeTime = 0;
	txtCurTime.SetText("");
	txtSiegeTime.SetText("");
	txtCastleName.SetText("");
	txtOwnerName.SetText(GetSystemString(595));
	txtClanName.SetText("");
	txtAllianceName.SetText("");
	texClan.SetTexture("");
	texAlliance.SetTexture("");
	txtClanName.MoveTo((rectWnd.nX + 80), (rectWnd.nY + 86));
	txtAllianceName.MoveTo((rectWnd.nX + 80), (rectWnd.nY + 102));
	TabCtrl.SetTopOrder(0, true);
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnAttackApply":
			OnAttackApplyClick();
			break;
		case "btnAttackCancel":
			OnAttackCancelClick();
			break;
		case "btnDefenseApply":
			OnDefenseApplyClick();
			break;
		case "btnDefenseCancel":
			OnDefenseCancelClick();
			break;
		case "btnDefenseReject":
			OnDefenseRejectClick();
			break;
		case "btnDefenseConfirm":
			OnDefenseConfirmClick();
			break;
		case "TabCtrl1":
			OnTabCtrl1Click();
			break;
		case "TabCtrl2":
			OnTabCtrl2Click();
			break;
		default:
			break;
	}
	return;
}

function OnAttackApplyClick()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(667), m_CastleName, ""));
	DialogSetID(1);
	return;
}

function OnAttackCancelClick()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(669), m_CastleName, ""));
	DialogSetID(2);
	return;
}

function OnDefenseApplyClick()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(668), m_CastleName, ""));
	DialogSetID(3);
	return;
}

function OnDefenseCancelClick()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(669), m_CastleName, ""));
	DialogSetID(4);
	return;
}

function OnDefenseRejectClick()
{
	local int idx, clanID;
	local string ClanName;
	local int Status;
	local UIEventManager.ECastleSiegeDefenderType DefenderType;
	local LVDataRecord Record;

	idx = lstDefenseClan.GetSelectedIndex();
	if((idx > -1))
	{
		lstDefenseClan.GetRec(idx, Record);
		clanID = int(Record.nReserved1);
		Status = int(Record.nReserved2);
		DefenderType = ECastleSiegeDefenderType(Status);
		if((clanID > 0))
		{
			if(((int(DefenderType) == 2) || (int(DefenderType) == 3)))
			{
				ClanName = Class'NWindow.UIDATA_CLAN'.static.GetName(clanID);
				m_DialogClanID = clanID;
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(670), ClanName, ""));
				DialogSetID(5);
			}
		}
	}
	return;
}

function OnDefenseConfirmClick()
{
	local int idx, clanID;
	local string ClanName;
	local int Status;
	local UIEventManager.ECastleSiegeDefenderType DefenderType;
	local LVDataRecord Record;

	idx = lstDefenseClan.GetSelectedIndex();
	if((idx > -1))
	{
		lstDefenseClan.GetRec(idx, Record);
		clanID = int(Record.nReserved1);
		Status = int(Record.nReserved2);
		DefenderType = ECastleSiegeDefenderType(Status);
		if((clanID > 0))
		{
			if((int(DefenderType) == 2))
			{
				ClanName = Class'NWindow.UIDATA_CLAN'.static.GetName(clanID);
				m_DialogClanID = clanID;
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(671), ClanName, ""));
				DialogSetID(6);
			}
		}
	}
	return;
}

function OnTabCtrl1Click()
{
	ClearAttackButton();
	Class'NWindow.SiegeAPI'.static.RequestCastleSiegeAttackerList(m_CastleID);
	return;
}

function OnTabCtrl2Click()
{
	ClearDefenseButton();
	Class'NWindow.SiegeAPI'.static.RequestCastleSiegeDefenderList(m_CastleID);
	return;
}

function HandleSiegeInfo(string param)
{
	local Rect rectWnd;
	local int castleID, IsOwner;
	local string OwnerName;
	local int clanID;
	local string ClanName;
	local int allianceID;
	local string allianceName;
	local int nowTime, SiegeTime;
	local string CastleName;
	local Texture ClanCrestTexture, AllianceCrestTexture;

	clearInfo();
	rectWnd = m_wndTop.GetRect();
	ParseInt(param, "CastleID", castleID);
	ParseInt(param, "IsOwner", IsOwner);
	if((IsOwner == 1))
	{
		m_IsCastleOwner = true;
	}
	ParseString(param, "OwnerName", OwnerName);
	ParseInt(param, "ClanID", clanID);
	ParseString(param, "ClanName", ClanName);
	ParseInt(param, "AllianceID", allianceID);
	ParseString(param, "AllianceName", allianceName);
	ParseInt(param, "NowTime", nowTime);
	ParseInt(param, "SiegeTime", SiegeTime);
	m_SiegeTime = SiegeTime;
	CastleName = GetCastleName(castleID);
	m_CastleID = castleID;
	m_CastleName = CastleName;
	txtCastleName.SetText(CastleName);
	if((Len(OwnerName) > 0))
	{
		txtOwnerName.SetText(OwnerName);
	}
	if((Len(ClanName) > 0))
	{
		txtClanName.SetText(ClanName);
	}
	if((Len(allianceName) > 0))
	{
		txtAllianceName.SetText(allianceName);
	}
	else if((Len(ClanName) > 0))
	{
		txtAllianceName.SetText(GetSystemString(591));
	}
	if((clanID > 0))
	{
		if(Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(clanID, ClanCrestTexture))
		{
			texClan.SetTextureWithObject(ClanCrestTexture);
			txtClanName.MoveTo((rectWnd.nX + 100), (rectWnd.nY + 86));
		}
	}
	if((allianceID > 0))
	{
		if(Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(clanID, AllianceCrestTexture))
		{
			texAlliance.SetTextureWithObject(AllianceCrestTexture);
			txtAllianceName.MoveTo((rectWnd.nX + 100), (rectWnd.nY + 102));
		}
	}
	if((nowTime > 0))
	{
		txtCurTime.SetText(ConvertTimetoStr(nowTime));
	}
	if((SiegeTime > 0))
	{
		txtSiegeTime.SetText(ConvertTimetoStr(SiegeTime));
	}
	else if(!m_IsCastleOwner)
	{
		txtSiegeTime.SetText(GetSystemString(584));
	}
	toggleDefenceTabVisible(getDefenceTabVisibleByCastleID());
	m_wndTop.ShowWindow();
	m_wndTop.SetFocus();
	return;
}

function HandleSiegeInfoClanListStart(string param)
{
	local int Type;
	local UserInfo infUser;

	m_PlayerClanID = 0;
	if(GetPlayerInfo(infUser))
	{
		m_PlayerClanID = infUser.nClanID;
	}
	if(ParseInt(param, "Type", Type))
	{
		if((Type == 0))
		{
			lstAttackClan.DeleteAllItem();
			m_IsExistMyClanIDinAttackSide = false;
			UpdateAttackCount();
			ClearAttackButton();
		}
		else if((Type == 1))
		{
			lstDefenseClan.DeleteAllItem();
			m_IsExistMyClanIDinDefenseSide = false;
			m_AcceptedClan = 0;
			m_WaitingClan = 0;
			UpdateDefenseCount();
			ClearDefenseButton();
		}
	}
	return;
}

function HandleSiegeInfoClanList(string param)
{
	local int Type, clanID;
	local string ClanName, allianceName;
	local int allianceID, Status;
	local UIEventManager.ECastleSiegeDefenderType DefenderType;
	local LVDataRecord Record;
	local Texture texClan, texAlliance;

	Record.LVDataList.Length = 2;
	if(ParseInt(param, "Type", Type))
	{
		ParseInt(param, "ClanID", clanID);
		ParseString(param, "ClanName", ClanName);
		ParseInt(param, "AllianceID", allianceID);
		ParseString(param, "AllianceName", allianceName);
		ParseInt(param, "Status", Status);
		if((clanID < 1))
		{
			return;
		}
		if((Type == 0))
		{
			if(((m_PlayerClanID > 0) && (clanID == m_PlayerClanID)))
			{
				m_IsExistMyClanIDinAttackSide = true;
			}
			Record.LVDataList[0].szData = ClanName;
			if(Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(clanID, texClan))
			{
				Record.LVDataList[0].arrTexture.Length = 1;
				Record.LVDataList[0].arrTexture[0].objTex = texClan;
				Record.LVDataList[0].arrTexture[0].X = 6;
				Record.LVDataList[0].arrTexture[0].Y = 0;
				Record.LVDataList[0].arrTexture[0].Width = 24;
				Record.LVDataList[0].arrTexture[0].Height = 12;
				Record.LVDataList[0].arrTexture[0].U = 0;
				Record.LVDataList[0].arrTexture[0].V = 4;
			}
			Record.LVDataList[1].szData = allianceName;
			if((allianceID > 0))
			{
				if(Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(clanID, texAlliance))
				{
					Record.LVDataList[1].arrTexture.Length = 1;
					Record.LVDataList[1].arrTexture[0].objTex = texAlliance;
					Record.LVDataList[1].arrTexture[0].X = 6;
					Record.LVDataList[1].arrTexture[0].Y = 0;
					Record.LVDataList[1].arrTexture[0].Width = 8;
					Record.LVDataList[1].arrTexture[0].Height = 12;
					Record.LVDataList[1].arrTexture[0].U = 0;
					Record.LVDataList[1].arrTexture[0].V = 4;
				}
			}
			lstAttackClan.InsertRecord(Record);
			UpdateAttackCount();
		}
		else if((Type == 1))
		{
			if(((m_PlayerClanID > 0) && (clanID == m_PlayerClanID)))
			{
				m_IsExistMyClanIDinDefenseSide = true;
			}
			Record.nReserved1 = INT64(clanID);
			Record.nReserved2 = INT64(Status);
			Record.LVDataList[0].szData = ClanName;
			if(Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(clanID, texClan))
			{
				Record.LVDataList[0].arrTexture.Length = 1;
				Record.LVDataList[0].arrTexture[0].objTex = texClan;
				Record.LVDataList[0].arrTexture[0].X = 6;
				Record.LVDataList[0].arrTexture[0].Y = 0;
				Record.LVDataList[0].arrTexture[0].Width = 24;
				Record.LVDataList[0].arrTexture[0].Height = 12;
				Record.LVDataList[0].arrTexture[0].U = 0;
				Record.LVDataList[0].arrTexture[0].V = 4;
			}
			DefenderType = ECastleSiegeDefenderType(Status);
			switch(DefenderType)
			{
				case CSDT_CASTLE_OWNER:
					Record.LVDataList[1].szData = GetSystemString(588);
					m_WaitingClan++;
					break;
				case CSDT_WAITING_CONFIRM:
					Record.LVDataList[1].szData = GetSystemString(568);
					m_WaitingClan++;
					break;
				case CSDT_APPROVED:
					Record.LVDataList[1].szData = GetSystemString(567);
					m_AcceptedClan++;
					break;
				case CSDT_REJECTED:
					Record.LVDataList[1].szData = GetSystemString(579);
					break;
				default:
					break;
			}
			lstDefenseClan.InsertRecord(Record);
			UpdateDefenseCount();
		}
	}
	return;
}

function HandleSiegeInfoClanListEnd(string param)
{
	local int Type;

	if(ParseInt(param, "Type", Type))
	{
		if((Type == 0))
		{
			UpdateAttackButton();
		}
		else if((Type == 1))
		{
			UpdateDefenseButton();
		}
	}
	return;
}

function UpdateAttackCount()
{
	txtAttackCount.SetText(((GetSystemString(576) $ " : ") $ string(lstAttackClan.GetRecordCount())));
	return;
}

function UpdateDefenseCount()
{
	txtDefenseCount.SetText(((((((GetSystemString(577) $ "/") $ GetSystemString(578)) $ " : ") $ string(m_AcceptedClan)) $ "/") $ string(m_WaitingClan)));
	return;
}

function UpdateAttackButton()
{
	if(!m_IsCastleOwner)
	{
		if(m_IsExistMyClanIDinAttackSide)
		{
			btnAttackCancel.ShowWindow();
		}
		else
		{
			btnAttackApply.ShowWindow();
		}
	}
	return;
}

function UpdateDefenseButton()
{
	if(!m_IsCastleOwner)
	{
		if(m_IsExistMyClanIDinDefenseSide)
		{
			btnDefenseCancel.ShowWindow();
		}
		else
		{
			btnDefenseApply.ShowWindow();
		}
	}
	else
	{
		btnDefenseReject.ShowWindow();
		btnDefenseConfirm.ShowWindow();
	}
	return;
}

function ClearAttackButton()
{
	btnAttackApply.HideWindow();
	btnAttackCancel.HideWindow();
	return;
}

function ClearDefenseButton()
{
	btnDefenseApply.HideWindow();
	btnDefenseCancel.HideWindow();
	btnDefenseReject.HideWindow();
	btnDefenseConfirm.HideWindow();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	OnHide();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SiegeInfoWnd");
	return;
}
