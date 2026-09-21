class WorldSiegeInfoMCWWnd extends UICommonAPI
	dependson(UIPacket);

enum TYPE_TABORDER
{
	Attacker                        // 0
};

enum SiegeType
{
	READY,                          // 0
	Start,                          // 1
	End                             // 2
};

var bool m_IsExistMyClanIDinAttackSide;
var bool m_ISMercenary;
var ListCtrlHandle lstAttackClan;
var TextBoxHandle txtAttackCount;
var ButtonHandle btnAttackApply;
var ButtonHandle btnAttackCancel;

static function WorldSiegeInfoMCWWnd Inst()
{
	return WorldSiegeInfoMCWWnd(GetScript("WorldSiegeInfoMCWWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(11540);
	RegisterEvent(11541);
	RegisterEvent(11542);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	lstAttackClan = GetListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeInfoWnd_Party1.lstClan"));
	txtAttackCount = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeInfoWnd_Party1.txtCount"));
	btnAttackApply = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeInfoWnd_Party1.btnAttackApply"));
	btnAttackCancel = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeInfoWnd_Party1.btnAttackCancel"));
	UpdateAttackCount();
	return;
}

event OnHide()
{
	local WindowHandle worldSiegeWndHandle;

	worldSiegeWndHandle = Class'InterfaceClassic.WorldSiegeWnd'.static.Inst().m_hOwnerWnd;
	worldSiegeWndHandle.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "CenterCenter", "CenterCenter", 0, 0);
	worldSiegeWndHandle.ClearAnchor();
	worldSiegeWndHandle.ShowWindow();
	worldSiegeWndHandle.BringToFront();
	return;
}

event OnShow()
{
	API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST();
	Class'InterfaceClassic.WorldSiegeWnd'.static.Inst().m_hOwnerWnd.HideWindow();
	m_hOwnerWnd.SetAnchor("WorldSiegeWnd", "CenterCenter", "CenterCenter", 0, 0);
	m_hOwnerWnd.ClearAnchor();
	ClearAttackButton();
	m_hOwnerWnd.SetFocus();
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnAttackApply":
			OnAttackApplyClick();
			break;
		case "btnAttackCancel":
			OnAttackCancelClick();
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	if((!m_hOwnerWnd.IsShowWindow() && !Class'InterfaceClassic.WorldSiegeWnd'.static.Inst().m_hOwnerWnd.IsShowWindow()))
	{
		return;
	}
	switch(Event_ID)
	{
		case 11540:
			HandleSiegeInfoClanListStart();
			break;
		case 11541:
			HandleSiegeInfoClanList(param);
			break;
		case 11542:
			HandleSiegeInfoClanListEnd();
			break;
		case 1710:
			HandleOK();
			break;
		default:
			break;
	}
	return;
}

function HandleOK()
{
	if(DialogIsMine())
	{
		switch(DialogGetID())
		{
			case 0:
				API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_JOIN();
				break;
			default:
				break;
		}
	}
	return;
}

function OnAttackApplyClick()
{
	DialogSetID(0);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(667), GetCastleName(GetCastleID()), ""));
	return;
}

function OnAttackCancelClick()
{
	DialogSetID(0);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(669), GetCastleName(GetCastleID()), ""));
	return;
}

function HandleSiegeInfoClanListStart()
{
	lstAttackClan.DeleteAllItem();
	m_IsExistMyClanIDinAttackSide = false;
	m_ISMercenary = false;
	UpdateAttackCount();
	ClearAttackButton();
	return;
}

function HandleSiegeInfoClanList(string param)
{
	local int clanID, myClanID;
	local string ClanName;
	local int MercenaryRecruit;
	local LVDataRecord Record;
	local Texture texClan;

	Record.LVDataList.Length = 2;
	ParseInt(param, "ClanID", clanID);
	ParseString(param, "ClanName", ClanName);
	myClanID = GetPlayerClanID();
	if((clanID == myClanID))
	{
		if((clanID == ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_clanID))
		{
			ParseInt(param, "IsMercenaryRecruit", MercenaryRecruit);
			Class'InterfaceClassic.WorldSiegeWnd'.static.Inst().SetRecruit(MercenaryRecruit);
			m_IsExistMyClanIDinAttackSide = true;
		}
		else
		{
			m_ISMercenary = true;
		}
	}
	Record.LVDataList[0].szData = ConvertWorldIDToStr(ClanName);
	if(Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(clanID, texClan))
	{
		Record.LVDataList[0].arrTexture.Length = 1;
		Record.LVDataList[0].arrTexture[0].objTex = texClan;
		Record.LVDataList[0].arrTexture[0].X = 0;
		Record.LVDataList[0].arrTexture[0].Y = 0;
		Record.LVDataList[0].arrTexture[0].Width = 24;
		Record.LVDataList[0].arrTexture[0].Height = 12;
		Record.LVDataList[0].arrTexture[0].U = 0;
		Record.LVDataList[0].arrTexture[0].V = 4;
	}
	lstAttackClan.InsertRecord(Record);
	UpdateAttackCount();
	return;
}

function HandleSiegeInfoClanListEnd()
{
	UpdateAttackButton();
	return;
}

function UpdateAttackCount()
{
	txtAttackCount.SetText(((GetSystemString(576) $ " : ") $ string(lstAttackClan.GetRecordCount())));
	return;
}

function UpdateAttackButton()
{
	if(IsCastleOwner())
	{
		return;
	}
	if((Class'InterfaceClassic.NoticeHUD'.static.Inst().worldsiegeState != 0))
	{
		return;
	}
	if(((ClanWndClassicNew(GetScript("ClanWndClassicNew")).m_bClanMaster == 0) || m_ISMercenary))
	{
		return;
	}
	if(m_IsExistMyClanIDinAttackSide)
	{
		btnAttackCancel.ShowWindow();
	}
	else
	{
		btnAttackApply.ShowWindow();
	}
	return;
}

function ClearAttackButton()
{
	btnAttackApply.HideWindow();
	btnAttackCancel.HideWindow();
	return;
}

function int GetOwnerPledgeID()
{
	return Class'InterfaceClassic.WorldSiegeWnd'.static.Inst().OwnerPledgeID;
}

function int GetPlayerClanID()
{
	local UserInfo infUser;

	if(GetPlayerInfo(infUser))
	{
		return infUser.nClanID;
	}
	return -1;
}

function bool IsCastleOwner()
{
	return (GetOwnerPledgeID() == GetPlayerClanID());
}

function int GetCastleID()
{
	return Class'InterfaceClassic.WorldSiegeWnd'.static.Inst().GetCastleIDSelected();
}

function API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET(int PledgeID)
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET packet;

	packet.nCastleID = GetCastleID();
	packet.nType = 0;
	packet.nIsMercenaryRecruit = 0;
	if(Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_RECRUIT_INFO_SET(stream, packet))
	{
		Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(736, stream);
	}
	return;
}

function API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST packet;

	packet.nCastleID = GetCastleID();
	if(Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_ATTACKER_LIST(stream, packet))
	{
		Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(735, stream);
	}
	return;
}

function API_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_JOIN()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_JOIN packet;

	packet.nCastleID = GetCastleID();
	packet.nAsAttacker = 1;
	if(m_IsExistMyClanIDinAttackSide)
	{
		packet.nIsRegister = 0;
	}
	else
	{
		packet.nIsRegister = 1;
	}
	if(Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_CASTLE_SIEGE_JOIN(stream, packet))
	{
		Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(734, stream);
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}
