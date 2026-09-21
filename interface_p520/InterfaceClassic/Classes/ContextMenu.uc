class ContextMenu extends L2UIGFxScript;

const SPECIALTYPE_CHAT_ADDBLOCK = 1;
const ACHIEVEMENT = 1;
const PRIVATESHOP_SELL = 2;
const PRIVATESHOP_ALLSELL = 3;
const PRIVATESHOP_BUY = 4;
const PRIVATESHOP_CLOSE = 5;
const TRANSFORM_CANCEL = 6;
const INSTANCEZONE_HISTORY = 7;
const ASSIST = 8;
const WHISPER = 9;
const INVITE_CLAN = 10;
const INVITE_FRIEND = 11;
const INVITE_PARTY = 12;
const TARGET_TOKEN1 = 13;
const TARGET_TOKEN2 = 14;
const TARGET_TOKEN3 = 15;
const TARGET_TOKEN4 = 16;
const PET_ACTION_RIDE = 17;
const PET_ACTION_CHANGE_MOVEMODE = 18;
const PET_ACTION_RETURN = 19;
const SUMMON_DISPOSITION_PASSIVE = 20;
const SUMMON_DISPOSITION_DEFENSE = 21;
const SUMMON_RETURN = 25;
const GETOFF = 22;
const TRADE = 23;
const Title = 24;
const Line = 10000;
const PARTY_BREAK_UP = 26;
const PARTY_LEAVE = 27;
const PARTY_BANISH = 28;
const PARTY_LEADER_CHANGE = 29;
const MANUFACTURE_COMMON = 30;
const MANUFACTURE_DWARF = 31;
const TRANSFORM_RIDE_CANCEL = 32;
const BLOCKLIST_AD = 33;
const BLOCKLIST_BADMANNER = 34;
const PET_ACTION_STOP = 35;

struct ContextMenuInfo
{
	var string Name;
	var int Id;
	var int X;
	var int Y;
};

var InviteClanPopWnd InviteClanPopWndScript;
var TargetStatusWnd TargetStatusWndScript;
var PrivateShopWnd PrivateShopWndScript;
var SummonedWnd SummonedWndScript;
var ContextMenuInfo m_contextMenuInfo;

function OnRegisterEvent()
{
	RegisterGFxEvent(9860);
	RegisterEvent(40);
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 40))
	{
		clearInfo();
	}
	return;
}

function OnLoad()
{
	RegisterState("ContextMenu", "GamingState");
	SetHavingFocus(false);
	SetAnchor("", ANCHORPOINT_TopLeft, ANCHORPOINT_TopLeft, 0, 0);
	SetDefaultShow(true);
	PrivateShopWndScript = PrivateShopWnd(GetScript("PrivateShopWnd"));
	InviteClanPopWndScript = InviteClanPopWnd(GetScript("InviteClanPopWnd"));
	SummonedWndScript = SummonedWnd(GetScript("SummonedWnd"));
	TargetStatusWndScript = TargetStatusWnd(GetScript("TargetStatusWnd"));
	return;
}

function OnFlashLoaded()
{
	SetRenderOnTop(true);
	return;
}

function OnHide()
{
	clearInfo();
	SetHavingFocus(false);
	return;
}

function execContextEvent(string creatureName, int CreatureID, int locX, int locY, optional int specialType, optional string etcParam)
{
	local string strParam;

	ParamAdd(strParam, "ID", string(CreatureID));
	ParamAdd(strParam, "Name", creatureName);
	ParamAdd(strParam, "X", string(locX));
	ParamAdd(strParam, "Y", string(locY));
	ParamAdd(strParam, "SpecialType", string(specialType));
	ParamAdd(strParam, "EtcParam", etcParam);
	ExecuteEvent(9860, strParam);
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "processCommand":
			processCommand(param);
			break;
		case "contextMenuEventInfo":
			saveInfo(param);
			break;
		default:
			break;
	}
	return;
}

function saveInfo(string param)
{
	ParseString(param, "Name", m_contextMenuInfo.Name);
	ParseInt(param, "ID", m_contextMenuInfo.Id);
	ParseInt(param, "X", m_contextMenuInfo.X);
	ParseInt(param, "Y", m_contextMenuInfo.Y);
	return;
}

function clearInfo()
{
	m_contextMenuInfo.Name = "";
	m_contextMenuInfo.Id = 0;
	m_contextMenuInfo.X = 0;
	m_contextMenuInfo.Y = 0;
	return;
}

function ContextMenuInfo getContextEventInfo()
{
	return m_contextMenuInfo;
}

function makeContextMenu()
{
	if((m_contextMenuInfo.Id > 0))
	{
		execContextEvent(m_contextMenuInfo.Name, m_contextMenuInfo.Id, m_contextMenuInfo.X, m_contextMenuInfo.Y);
	}
	return;
}

function processCommand(string param)
{
	local int menuItemType, targetID;
	local string UserName;
	local UserInfo targetUserInfo;
	local ItemInfo SkillInfo;
	local string ChatMsg;

	ParseInt(param, "menuItemType", menuItemType);
	ParseInt(param, "ID", targetID);
	ParseString(param, "Name", UserName);
	ParseString(param, "ChatMsg", ChatMsg);
	switch(menuItemType)
	{
		case 1:
			break;
		case 2:
			ExecuteCommandFromAction("vendor");
			break;
		case 3:
			ExecuteCommandFromAction("packagevendor");
			break;
		case 4:
			ExecuteCommandFromAction("buy");
			break;
		case 5:
			PrivateShopWndScript.contextMenuQuit();
			break;
		case 32:
			SkillInfo.Id.ClassID = 9210;
			SkillInfo.Id.ServerID = 0;
			UseSkill(SkillInfo.Id, 2);
			break;
		case 6:
			SkillInfo.Id.ClassID = 619;
			SkillInfo.Id.ServerID = 0;
			UseSkill(SkillInfo.Id, 2);
			break;
		case 7:
			RequestInzoneWaitingTime();
			break;
		case 8:
			GetUserInfo(targetID, targetUserInfo);
			RequestAssist(targetID, targetUserInfo.Loc);
			break;
		case 9:
			whisperToUser(UserName);
			break;
		case 10:
			if(getInstanceUIData().GetIsClassicServer())
			{
				RequestClanAskJoinByName(UserName, 0);
			}
			else if(getInstanceL2Util().isClanV2())
			{
				RequestClanAskJoin(targetID, 0);
			}
			else
			{
				InviteClanPopWndScript.showByPersonalConnectionsWndUsingUserName(UserName);
			}
			break;
		case 11:
			Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(UserName);
			break;
		case 12:
			RequestInvitePartyByTargetID(targetID);
			break;
		case 13:
			ExecuteCommandFromAction("tacticalsign1");
			break;
		case 14:
			ExecuteCommandFromAction("tacticalsign2");
			break;
		case 15:
			ExecuteCommandFromAction("tacticalsign3");
			break;
		case 16:
			ExecuteCommandFromAction("tacticalsign4");
			break;
		case 17:
			ExecuteCommandFromAction("mountdismount");
			break;
		case 18:
			ExecuteCommandFromAction("pethold");
			break;
		case 19:
			ExecuteCommandFromAction("petrevert");
			break;
		case 35:
			ExecuteCommandFromAction("petstop");
			break;
		case 20:
			DoAction(Class'InterfaceClassic.UICommonAPI'.static.GetItemID(1104));
			break;
		case 21:
			DoAction(Class'InterfaceClassic.UICommonAPI'.static.GetItemID(1103));
			break;
		case 25:
			ExecuteCommandFromAction("unsummon");
			break;
		case 23:
			ExecuteCommandFromAction("trade");
			break;
		case 22:
			ExecuteCommandFromAction("mountdismount");
			break;
		case 26:
			break;
		case 27:
			ExecuteCommandFromAction("partyleave");
			break;
		case 28:
			ExecuteCommandFromAction("partydismiss");
			break;
		case 29:
			ExecuteCommandFromAction("leaderchange");
			break;
		case 30:
			ExecuteCommandFromAction("manufacture2");
			break;
		case 31:
			ExecuteCommandFromAction("manufacture");
			break;
		case 33:
			RequestBlockListForAD(UserName, ChatMsg);
			Debug(("-> RequestBlockListForAD" @ UserName));
			Debug(("-> chatMsg" @ ChatMsg));
			break;
		case 34:
			Debug(("-> RequestAddBlock" @ UserName));
			Class'NWindow.PersonalConnectionAPI'.static.RequestAddBlock(UserName);
			break;
		default:
			break;
	}
	return;
}

function whisperToUser(string UserName)
{
	local ChatWnd chatWndScript;

	if((UserName != ""))
	{
		chatWndScript = ChatWnd(GetScript("ChatWnd"));
		chatWndScript.SetChatEditBox((("\"" $ UserName) $ " "));
	}
	return;
}

function bool isShowContextMenu()
{
	local bool bShow;
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 1);
	args[0].SetBool(false);
	AllocGFxValue(invokeResult);
	Invoke("_root.isShowContextMenu", args, invokeResult);
	bShow = invokeResult.GetBool();
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return bShow;
}

function OnFocus(bool bFlag, bool bTransparency)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	args[0].SetBool(bFlag);
	args[1].SetBool(bTransparency);
	AllocGFxValue(invokeResult);
	Invoke("_root.onFocus", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	if(!bFlag)
	{
		SetHavingFocus(false);
	}
	return;
}
