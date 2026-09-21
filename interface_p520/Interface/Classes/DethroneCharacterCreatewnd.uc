class DethroneCharacterCreatewnd extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID_ANIMATION = 19;
const TIMER_DELAY = 2000;
const TIMER_ID_CLICK = 2;
const TIMER_DELAY_CLICK = 150;
const PAWN_SCALE = 0.86f;
const LEVEL_LIMIt = 110;

enum STATECREATE
{
	initName,                       // 0
	roomEnter,                      // 1
	reName                          // 2
};

var string m_Windowname;
var WindowHandle Me;
var UIControlTextInput uicontrolTextInputScr;
var UIControlDialogAssets uicontrolDialogAssetScr;
var TextBoxHandle NameEditDscrp_tex;
var TextBoxHandle DethroneDscrp_tex;
var ButtonHandle Name_Btn;
var ButtonHandle Help_btn;
var ButtonHandle MainEnter_Button;
var ButtonHandle Cancel_Btn;
var CharacterViewportWindowHandle m_ObjectViewport;
var string _name;
var int m_MeshType;
var bool isDown;
var bool isAniPlaing;
var int bOpen;
var STATECREATE CurrentState;

function SetBOpen(int _bOpen)
{
	bOpen = _bOpen;
	if((int(CurrentState) == 1))
	{
		CheckRoomEnter();
	}
	return;
}

function CheckRoomEnter()
{
	if((bOpen == 1))
	{
		MainEnter_Button.EnableWindow();
	}
	else
	{
		MainEnter_Button.DisableWindow();
	}
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	NameEditDscrp_tex = GetTextBoxHandle((m_Windowname $ ".NameEditDscrp_tex"));
	DethroneDscrp_tex = GetTextBoxHandle((m_Windowname $ ".DethroneDscrp_tex"));
	Name_Btn = GetButtonHandle((m_Windowname $ ".Name_Btn"));
	Help_btn = GetButtonHandle((m_Windowname $ ".Help_btn"));
	Cancel_Btn = GetButtonHandle((m_Windowname $ ".Cancel_Btn"));
	MainEnter_Button = GetButtonHandle((m_Windowname $ ".MainEnter_Button"));
	uicontrolTextInputScr = Class'Interface.UIControlTextInput'.static.InitScript(GetWindowHandle((m_Windowname $ ".TextInput")));
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	uicontrolTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	m_ObjectViewport = GetCharacterViewportWindowHandle((m_Windowname $ ".CharacterView_wnd.ObjectViewport"));
	SetAssets();
	return;
}

function SetAssets()
{
	uicontrolDialogAssetScr = Class'Interface.UIControlDialogAssets'.static.InitScript(GetWindowHandle((m_Windowname $ ".AssetGroup.UIControlDialogAsset")));
	uicontrolDialogAssetScr.SetDisableWindow(GetWindowHandle((m_Windowname $ ".AssetGroup.DisableDialog_tex")));
	uicontrolDialogAssetScr.DelegateOnClickBuy = OnClickPopupBuy;
	uicontrolDialogAssetScr.DelegateOnCancel = OnClickPopupCancel;
	return;
}

function DelegateESCKey()
{
	return;
}

function DelegateOnChangeEdited(string Text)
{
	if(uicontrolTextInputScr.IsEmpty())
	{
		Name_Btn.DisableWindow();
	}
	else
	{
		Name_Btn.EnableWindow();
	}
	return;
}

function DelegateOnCompleteEditBox(string Text)
{
	if(((Text != "") && (Text != _name)))
	{
		HandleClickNameBtn();
	}
	return;
}

function API_C_EX_DETHRONE_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_INFO packet;

	packet.cDummy = 0;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DETHRONE_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(715, stream);
	return;
}

function API_C_EX_DETHRONE_ENTER()
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_ENTER packet;

	if((_name == ""))
	{
		return;
	}
	packet.cDummy = 0;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DETHRONE_ENTER(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(723, stream);
	return;
}

function API_C_EX_DETHRONE_LEAVE()
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_LEAVE packet;

	packet.cDummy = 0;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DETHRONE_LEAVE(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(724, stream);
	return;
}

function API_C_EX_DETHRONE_CHECK_NAME(string _name)
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_CHECK_NAME packet;

	packet.sName = _name;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DETHRONE_CHECK_NAME(stream, packet))
	{
		return;
	}
	Debug("API_C_EX_DETHRONE_CHECK_NAME");
	Class'Interface.UIPacket'.static.RequestUIPacket(725, stream);
	return;
}

function API_C_EX_DETHRONE_CHANGE_NAME()
{
	local array<byte> stream;
	local UIPacket._C_EX_DETHRONE_CHANGE_NAME packet;

	packet.sName = uicontrolTextInputScr.GetString();
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_DETHRONE_CHANGE_NAME(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(726, stream);
	return;
}

function API_GetDethroneChangeNameCost(out array<RequestItem> o_arrData)
{
	GetDethroneChangeNameCost(o_arrData);
	return;
}

function Handle_S_EX_DETHRONE_INFO()
{
	local UIPacket._S_EX_DETHRONE_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_INFO(packet))
	{
		return;
	}
	_name = packet.sName;
	HandleGameStart();
	return;
}

function Handle_S_EX_DETHRONE_CHECK_NAME()
{
	local UIPacket._S_EX_DETHRONE_CHECK_NAME packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_CHECK_NAME(packet))
	{
		return;
	}
	Debug(("Handle_S_EX_DETHRONE_CHECK_NAME" @ string(packet.nResult)));
	HandlecharacterNameCreatable(packet.nResult);
	HandleCharacterNameCreate(packet.nResult);
	return;
}

function Handle_S_EX_DETHRONE_CHANGE_NAME()
{
	local UIPacket._S_EX_DETHRONE_CHANGE_NAME packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_CHANGE_NAME(packet))
	{
		return;
	}
	if((int(packet.bSuccess) == 1))
	{
		_name = packet.sName;
		SetState(roomEnter);
		PlayRandAttackAnimation();
	}
	return;
}

function SetState(STATECREATE State)
{
	uicontrolDialogAssetScr.Hide();
	switch(State)
	{
		case initName:
			NameEditDscrp_tex.SetText(GetSystemMessage(80));
			uicontrolTextInputScr.SetEdtiable(true);
			uicontrolTextInputScr.SetMaxLength(16);
			HandleLevelCheck();
			Cancel_Btn.HideWindow();
			uicontrolTextInputScr.Clear();
			MainEnter_Button.DisableWindow();
			Name_Btn.DisableWindow();
			Name_Btn.SetButtonName(140);
			DethroneDscrp_tex.SetText(GetSystemString(13772));
			break;
		case roomEnter:
			NameEditDscrp_tex.SetText(GetSystemString(13778));
			uicontrolTextInputScr.SetMaxLength(100);
			uicontrolTextInputScr.SetString(GetfullName());
			uicontrolTextInputScr.SetEdtiable(false);
			Cancel_Btn.HideWindow();
			CheckRoomEnter();
			Name_Btn.EnableWindow();
			Name_Btn.SetButtonName(13776);
			DethroneDscrp_tex.SetAlpha(100);
			DethroneDscrp_tex.SetAlpha(255, 1.0000000);
			DethroneDscrp_tex.SetText(GetSystemString(13775));
			break;
		case reName:
			NameEditDscrp_tex.SetText(GetSystemMessage(80));
			uicontrolTextInputScr.SetMaxLength(16);
			uicontrolTextInputScr.SetString(_name);
			uicontrolTextInputScr.SetEdtiable(true);
			HandleLevelCheck();
			uicontrolTextInputScr.AllSelect();
			Cancel_Btn.ShowWindow();
			MainEnter_Button.DisableWindow();
			Name_Btn.EnableWindow();
			Name_Btn.SetButtonName(140);
			DethroneDscrp_tex.SetAlpha(100);
			DethroneDscrp_tex.SetAlpha(255, 1.0000000);
			DethroneDscrp_tex.SetText(GetSystemString(13772));
			break;
		default:
			break;
	}
	CurrentState = State;
	return;
}

function string GetfullName()
{
	local UserInfo myInfo;

	if(GetPlayerInfo(myInfo))
	{
		return ((_name $ "_") $ getInstanceUIData().Int2Str(getServerExtIdByWorldID(myInfo.nWorldID)));
	}
	return _name;
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(3810);
	RegisterEvent(180);
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent((100000 + 960));
	RegisterEvent((100000 + 959));
	RegisterEvent((100000 + 950));
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3810:
			HandleChangeCharacterPawn(param);
			break;
		case 180:
			HandleUpdateUserInfo();
			break;
		case 9750:
			HandleGameStart();
			break;
		case 40:
			HandleRestart();
			break;
		case (100000 + 960):
			Handle_S_EX_DETHRONE_CHANGE_NAME();
			break;
		case (100000 + 959):
			Handle_S_EX_DETHRONE_CHECK_NAME();
			break;
		case (100000 + 950):
			Handle_S_EX_DETHRONE_INFO();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		Me.HideWindow();
		return;
	}
	TextOnShow();
	return;
}

event OnHide()
{
	uicontrolDialogAssetScr.Hide();
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "DethroneWnd");
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == m_ObjectViewport))
	{
		Me.SetTimer(2, 150);
		isDown = true;
	}
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if(((!isAniPlaing && isDown) && (a_WindowHandle == m_ObjectViewport)))
	{
		isAniPlaing = true;
		if(((m_MeshType == 18) || (m_MeshType == 19)))
		{
			m_ObjectViewport.PlayAnimation(3);
		}
		else
		{
			PlayRandAttackAnimation();
		}
		Me.KillTimer(19);
		Me.SetTimer(19, 2000);
	}
	Me.KillTimer(2);
	isDown = false;
	return;
}

event OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if(((!isAniPlaing && isDown) && (a_WindowHandle == m_ObjectViewport)))
	{
		isAniPlaing = true;
		PlayRandAnimation();
		Me.KillTimer(19);
		Me.SetTimer(19, 2000);
	}
	Me.KillTimer(2);
	isDown = false;
	return;
}

event OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == m_ObjectViewport))
	{
		Me.SetTimer(2, 150);
		isDown = true;
	}
	return;
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 19:
			Me.KillTimer(19);
			isAniPlaing = false;
			break;
		case 2:
			Me.KillTimer(2);
			isDown = false;
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string BTNID)
{
	switch(BTNID)
	{
		case "Cancel_Btn":
			HandleClickCancelBtn();
			break;
		case "MainEnter_Button":
			HandleClickMainEnter();
			break;
		case "Name_Btn":
			HandleClickNameBtn();
			break;
		case "Back_Btn":
			HandleClickBackBtn();
			break;
		default:
			break;
	}
	return;
}

function HandleClickBackBtn()
{
	Me.HideWindow();
	GetWindowHandle("DethroneWnd").ShowWindow();
	return;
}

function HandleClickNameBtn()
{
	switch(CurrentState)
	{
		case initName:
		case reName:
			if(!NameConfirm())
			{
				uicontrolTextInputScr.AllSelect();
				return;
			}
			API_C_EX_DETHRONE_CHECK_NAME(uicontrolTextInputScr.GetString());
			break;
		case roomEnter:
			SetState(reName);
			break;
		default:
			break;
	}
	return;
}

function HandleClickMainEnter()
{
	API_C_EX_DETHRONE_ENTER();
	m_hOwnerWnd.HideWindow();
	return;
}

function HandleClickCancelBtn()
{
	SetState(roomEnter);
	return;
}

function HandleRestart()
{
	_name = "";
	return;
}

function HandleGameStart()
{
	if((_name == ""))
	{
		SetState(initName);
	}
	else
	{
		SetState(roomEnter);
	}
	return;
}

function HandleUpdateUserInfo()
{
	if(!HandleLevelCheck())
	{
		Me.HideWindow();
	}
	return;
}

function bool HandleLevelCheck()
{
	local UserInfo uInfo;

	if(GetPlayerInfo(uInfo))
	{
		if((uInfo.nLevel < 110))
		{
			uicontrolTextInputScr.SetDisable(true);
			NameEditDscrp_tex.SetText(MakeFullSystemMsg(GetSystemMessage(4547), string(110)));
		}
		else
		{
			uicontrolTextInputScr.SetDisable(false);
		}
		return !uicontrolTextInputScr._bDisable;
	}
	return false;
}

function HandlecharacterNameCreatable(int nResult)
{
	local int createMessage;

	switch(nResult)
	{
		case 1:
			createMessage = 80;
			break;
		case -1:
			createMessage = 79;
			break;
		case -2:
			createMessage = 204;
			break;
		case -3:
			createMessage = 80;
			break;
		case 0:
		default:
			createMessage = 0;
			break;
	}
	NameEditDscrp_tex.SetText(GetSystemMessage(createMessage));
	return;
}

function HandleCharacterNameCreate(int nResult)
{
	local array<RequestItem> o_arrData;
	local int i;

	if((nResult != 1))
	{
		uicontrolTextInputScr.AllSelect();
		return;
	}
	uicontrolDialogAssetScr.SetUseBuyItem(false);
	uicontrolDialogAssetScr.SetUseNumberInput(false);
	switch(CurrentState)
	{
		case initName:
			uicontrolDialogAssetScr.SetUseNeedItem(false);
			uicontrolDialogAssetScr.SetDialogDescHtml(((("<br><font color=\"E6DCBE\" name=gameDefault11>" $ uicontrolTextInputScr.GetString()) $ "</font><br>") $ GetSystemString(13774)));
			break;
		case reName:
			API_GetDethroneChangeNameCost(o_arrData);
			uicontrolDialogAssetScr.SetDialogDescHtml(((("<br><font color=\"E6DCBE\" name=gameDefault11>" $ uicontrolTextInputScr.GetString()) $ "</font><br>") $ GetSystemString(13782)));
			uicontrolDialogAssetScr.SetUseNeedItem(true);
			uicontrolDialogAssetScr.StartNeedItemList(o_arrData.Length);
			i = 0;
			while((i < o_arrData.Length))
			{
				uicontrolDialogAssetScr.AddNeedItemClassID(o_arrData[i].Id, o_arrData[i].Amount);
				i++;
			}
			uicontrolDialogAssetScr.SetItemNum(1);
			break;
		default:
			break;
	}
	uicontrolTextInputScr.SetDisable(true);
	uicontrolDialogAssetScr.Show();
	return;
}

function OnClickPopupBuy()
{
	uicontrolDialogAssetScr.Hide();
	switch(CurrentState)
	{
		case initName:
		case reName:
			API_C_EX_DETHRONE_CHANGE_NAME();
			break;
		default:
			break;
	}
	return;
}

function OnClickPopupCancel()
{
	switch(CurrentState)
	{
		case initName:
		case reName:
			uicontrolTextInputScr.SetDisable(false);
			uicontrolTextInputScr.Focus();
			break;
		default:
			break;
	}
	uicontrolDialogAssetScr.Hide();
	return;
}

function PlayRandAttackAnimation()
{
	local int aniType;

	aniType = (Rand(3) + 1);
	m_ObjectViewport.PlayAttackAnimation(aniType);
	return;
}

function PlayRandAnimation()
{
	local int aniType;

	aniType = (Rand(13) + 1);
	m_ObjectViewport.PlayAnimation(aniType);
	return;
}

function HandleChangeCharacterPawn(string param)
{
	ParseInt(param, "MeshType", m_MeshType);
	switch(m_MeshType)
	{
		case 0:
			m_ObjectViewport.SetCharacterScale((0.9800000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-2);
			break;
		case 1:
			m_ObjectViewport.SetCharacterScale((0.9570000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 8:
			m_ObjectViewport.SetCharacterScale((1.0000000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-16);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 9:
			m_ObjectViewport.SetCharacterScale((1.0100000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-14);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 6:
			m_ObjectViewport.SetCharacterScale((0.9700000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-2);
			break;
		case 7:
			m_ObjectViewport.SetCharacterScale((0.9800000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-18);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		case 2:
			m_ObjectViewport.SetCharacterScale((0.9900000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(3);
			m_ObjectViewport.SetCharacterOffsetY(-2);
			break;
		case 3:
			m_ObjectViewport.SetCharacterScale((0.9800000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-14);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		case 10:
			m_ObjectViewport.SetCharacterScale((0.9500000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(5);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		case 11:
			m_ObjectViewport.SetCharacterScale((0.8800000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-26);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 12:
			m_ObjectViewport.SetCharacterScale((0.9500000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(3);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		case 13:
			m_ObjectViewport.SetCharacterScale((0.9000000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-26);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 4:
			m_ObjectViewport.SetCharacterScale((1.0500000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(3);
			m_ObjectViewport.SetCharacterOffsetY(0);
			break;
		case 5:
			m_ObjectViewport.SetCharacterScale((1.0500000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-10);
			m_ObjectViewport.SetCharacterOffsetY(-2);
			break;
		case 14:
			m_ObjectViewport.SetCharacterScale((0.9600000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-5);
			m_ObjectViewport.SetCharacterOffsetY(-2);
			break;
		case 15:
			m_ObjectViewport.SetCharacterScale((0.9700000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(4);
			m_ObjectViewport.SetCharacterOffsetY(0);
			break;
		case 17:
			m_ObjectViewport.SetCharacterScale((1.0500000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			break;
		case 18:
			m_ObjectViewport.SetCharacterScale((1.0500000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			break;
		case 19:
			m_ObjectViewport.SetCharacterScale((1.0500000 * 0.8600000));
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			break;
		default:
			break;
	}
	return;
}

function bool NameConfirm()
{
	local string NewName;

	NewName = uicontrolTextInputScr.GetString();
	if(((Len(NewName) == 0) || !CheckNameLength(NewName)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(80));
		return false;
	}
	else if(!CheckValidName(NewName))
	{
		NameEditDscrp_tex.SetText(GetSystemMessage(204));
		return false;
	}
	else if((uicontrolTextInputScr.GetString() == _name))
	{
		NameEditDscrp_tex.SetText(GetSystemMessage(3221));
		return false;
	}
	return true;
}

function OnReceivedCloseUI()
{
	switch(CurrentState)
	{
		case reName:
			SetState(roomEnter);
			break;
		default:
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			HandleClickBackBtn();
			break;
	}
	return;
}

function TextOnShow()
{
	HandleUpdateUserInfo();
	API_C_EX_DETHRONE_INFO();
	return;
}
