class CustomizingWnd extends UICommonAPI
	dependson(UIPacket);

const ORCRIDERSCALE = 0.803f;
const ORCRIDERX = 0;
const ORCRIDERY = 1;
const TIMER_ID_ANIMATION = 19;
const TIMER_DELAY = 2000;
const TIMER_ID_CLICK = 2;
const TIMER_DELAY_CLICK = 150;
const BTN_NAME0 = "WeaponShapeBtn";
const BTN_NAME1 = "KillEffectBtn";
const BTN_NAME2 = "NameDecoBtn";
const MOUSETRACETIME = 500f;

var UIControlDialogAssets uicontrolDialogAssetScr;
var CharacterViewportWindowHandle m_ObjectViewport;
var EffectViewportWndHandle effectViewport;
var L2UITimerObject tickTimerObjectScroll;
var INT64 clientStartSec;
var float TargetDistance;
var float currentDistance;
var TextureHandle MainBG_texAni00;
var TextureHandle MainBG_texAni01;
var TextureHandle MainBG_texAniUnder;
var int currentPage;
var ButtonHandle BtnBackHome;
var bool bRequestedStyleData;
var int rotateBasic;

function UIControlDialogAssets _GetDialogAssets()
{
	return uicontrolDialogAssetScr;
}

static function CustomizingWnd Inst()
{
	return CustomizingWnd(GetScript("CustomizingWnd"));
}

function Initialize()
{
	m_ObjectViewport = GetCharacterViewportWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ObjectViewport"));
	m_ObjectViewport.SetSpawnDuration(0.5000000);
	MainBG_texAni00 = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MainBG_texAni00"));
	MainBG_texAni01 = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MainBG_texAni01"));
	MainBG_texAniUnder = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MainBG_texAniUnder"));
	effectViewport = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".effectViewport"));
	BtnBackHome = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BtnBackHome"));
	BtnBackHome.HideWindow();
	currentPage = 0;
	GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ "WeaponShapeBtn")).SetAlpha(0);
	GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ "KillEffectBtn")).SetAlpha(0);
	GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ "NameDecoBtn")).SetAlpha(0);
	return;
}

function InitUIControlDialogAsset()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset"));
	uicontrolDialogAssetScr = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	uicontrolDialogAssetScr.SetDisableWindow(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd")));
	return;
}

function InitUIControlGroupButtonAssets()
{
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabGroup")).HideWindow();
	return;
}

function DelegateOnClickButton(string parentWndName, string strName, int mainIndex)
{
	switch(mainIndex)
	{
		case 0:
			OnClickButton("WeaponShapeBtn");
			break;
		case 1:
			OnClickButton("KillEffectBtn");
			break;
		case 2:
			OnClickButton("NameDecoBtn");
			break;
		default:
			break;
	}
	return;
}

function InitTickTimers()
{
	tickTimerObjectScroll = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, -1);
	tickTimerObjectScroll._DelegateOnStart = ScrollMoveStart;
	tickTimerObjectScroll._DelegateOnTime = ScrollMove;
	return;
}

function ScrollMoveStart()
{
	clientStartSec = GetAppMilliSeconds();
	return;
}

function ScrollMove(int Time)
{
	local float Position, ratio, tmpValue;

	Position = (float((GetAppMilliSeconds() - clientStartSec)) / 500.0000000);
	ratio = Class'InterfaceClassic.L2UITween'.static.Inst().easeOutStrong(Position, 0.0000000, 1.0000000, 1.0000000);
	if((ratio > 1.0000000))
	{
		tickTimerObjectScroll._Stop();
		ratio = 1.0000000;
	}
	tmpValue = (TargetDistance - currentDistance);
	tmpValue = (tmpValue * Position);
	currentDistance = (currentDistance + tmpValue);
	SetUVByDistance(int(currentDistance));
	return;
}

function SetUVByDistance(int Distance)
{
	local Vector vec;

	MainBG_texAni00.SetUV(((Distance + 5524) / 200), 0);
	vec.Z = float((Distance / 200));
	vec.Y = -50.0000000;
	effectViewport.SetOffset(vec);
	MainBG_texAni01.SetUV(((Distance + 6024) / 80), 0);
	m_ObjectViewport.MoveC((-Distance / 25), 49);
	MainBG_texAniUnder.SetUV((((Distance + 2048) / 25) + 35), 0);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(3810);
	RegisterEvent(EV_PacketID(1205));
	RegisterEvent(EV_PacketID(1206));
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	InitUIControlDialogAsset();
	InitUIControlGroupButtonAssets();
	InitTickTimers();
	SetSetterBtn();
	return;
}

function SetSetterBtn()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".portraitSetterBtn")).HideWindow();
	if((IsBuilderPC() && (int(GetReleaseMode()) == 0)))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".portraitSetterBtn")).ShowWindow();
	}
	return;
}

event OnHide()
{
	if((currentPage == 0))
	{
		return;
	}
	tickTimerObjectScroll._Stop();
	return;
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	if((currentPage > 0))
	{
		SetPrevPage();
	}
	currentPage = 0;
	ButtonSetOut("WeaponShapeBtn", true);
	ButtonSetOut("KillEffectBtn", true);
	ButtonSetOut("NameDecoBtn", true);
	_ShowPC();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabGroup")).HideWindow();
	BtnBackHome.HideWindow();
	SetUVByDistance(0);
	ChangeButtonStates();
	effectViewport.SpawnEffect("LineageEffect2.ui_relic_deco_green");
	if((bRequestedStyleData == true))
	{
		return;
	}
	SetButtonSetTitleTextureSizes();
	RQ_C_EX_CHARACTER_STYLE_LIST();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 40:
			ClearAllDatas();
		case EV_PacketID(1205):
			RT_S_EX_CHARACTER_STYLE_USE_ITEM();
			break;
		case EV_PacketID(1206):
			RT_S_EX_CHARACTER_STYLE_LIST();
			break;
		case 3810:
			HandleChangeCharacterPawn(param);
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "WindowHelp_BTN":
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(79);
			break;
		case "WeaponShapeBtn":
		case ("WeaponShapeBtn" $ "_Tab"):
			SetCurrentPage(1);
			break;
		case "KillEffectBtn":
		case ("KillEffectBtn" $ "_Tab"):
			SetCurrentPage(2);
			break;
		case "NameDecoBtn":
		case ("NameDecoBtn" $ "_Tab"):
			SetCurrentPage(3);
			break;
		case "BtnBackHome":
			OnReceivedCloseUI();
			break;
		case "portraitSetterBtn":
			GetWindowHandle("UIPortraitSetter").ShowWindow();
			UIPortraitSetter(GetScript("UIPortraitSetter"))._SetCurrentUserInfo(m_ObjectViewport);
			break;
		default:
			break;
	}
	ChangeButtonStates();
	return;
}

function _ShowPC()
{
	m_ObjectViewport.ShowNPC(0.2000000);
	return;
}

function _HidePC()
{
	m_ObjectViewport.HideNPC(0.2000000);
	return;
}

function SetCurrentPage(int Page)
{
	local WindowHandle tabGroup;

	currentPage = Page;
	if((currentPage == 0))
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabGroup")).HideWindow();
		return;
	}
	_HidePC();
	TargetDistance = 4024.0000000;
	tickTimerObjectScroll._Reset();
	tabGroup = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabGroup"));
	tabGroup.ShowWindow();
	tabGroup.SetAlpha(255, 0.2000000);
	tabGroup.SetFocus();
	BtnBackHome.ShowWindow();
	switch(currentPage)
	{
		case 1:
			Class'InterfaceClassic.CustomizingWndAppearance'.static.Inst().Show();
			Class'InterfaceClassic.CustomizingWndKillEffect'.static.Inst().Hide();
			Class'InterfaceClassic.CustomizingWndNameDeco'.static.Inst().Hide();
			TabButtonSetSelect("WeaponShapeBtn");
			break;
		case 2:
			Class'InterfaceClassic.CustomizingWndAppearance'.static.Inst().Hide();
			Class'InterfaceClassic.CustomizingWndKillEffect'.static.Inst().Show();
			Class'InterfaceClassic.CustomizingWndNameDeco'.static.Inst().Hide();
			TabButtonSetSelect("KillEffectBtn");
			break;
		case 3:
			Class'InterfaceClassic.CustomizingWndAppearance'.static.Inst().Hide();
			Class'InterfaceClassic.CustomizingWndKillEffect'.static.Inst().Hide();
			Class'InterfaceClassic.CustomizingWndNameDeco'.static.Inst().Show();
			TabButtonSetSelect("NameDecoBtn");
			break;
		default:
			break;
	}
	return;
}

function ChangeButtonStates()
{
	ChangeButtonState("WeaponShapeBtn");
	ChangeButtonState("KillEffectBtn");
	ChangeButtonState("NameDecoBtn");
	return;
}

function ChangeButtonState(string btnName)
{
	if((currentPage == 0))
	{
		GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ btnName)).ShowWindow();
		GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "_Condition")).ShowWindow();
	}
	else
	{
		ButtonSetOut(btnName);
		GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ btnName)).HideWindow();
		GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "_Condition")).HideWindow();
	}
	return;
}

function TabButtonSetOver(string btnName)
{
	GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabGroup.tex_") $ btnName) $ "_Tab_Condition")).SetTexture((("L2UI_NewTex.StyleWnd.StyleWndSmall" $ btnName) $ "_Over"));
	return;
}

function TabButtonSetOut(string btnName)
{
	if((GetButtonHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabGroup.") $ btnName) $ "_Tab")).IsShowWindow() == false))
	{
		return;
	}
	GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabGroup.tex_") $ btnName) $ "_Tab_Condition")).SetTexture((("L2UI_NewTex.StyleWnd.StyleWndSmall" $ btnName) $ "_Normal"));
	return;
}

function TabButtonSetSelect(string btnName)
{
	TabButtonSetEnableState("WeaponShapeBtn");
	TabButtonSetEnableState("KillEffectBtn");
	TabButtonSetEnableState("NameDecoBtn");
	TabButtonSetSelectState(btnName);
	return;
}

function TabButtonSetEnableState(string btnName)
{
	GetButtonHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabGroup.") $ btnName) $ "_Tab")).EnableWindow();
	GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabGroup.tex_") $ btnName) $ "_Tab_Condition")).SetTexture((("L2UI_NewTex.StyleWnd.StyleWndSmall" $ btnName) $ "_Normal"));
	return;
}

function TabButtonSetSelectState(string btnName)
{
	GetButtonHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabGroup.") $ btnName) $ "_Tab")).DisableWindow();
	GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabGroup.tex_") $ btnName) $ "_Tab_Condition")).SetTexture((("L2UI_NewTex.StyleWnd.StyleWndSmall" $ btnName) $ "_Normal_Selected"));
	return;
}

function ButtonSetOver(string btnName)
{
	local AnimTextureHandle aniTextureOnce_Up, aniTextureOnce_Down, aniTextureLoop;

	GetTextureHandle((("tex_" $ btnName) $ "_Condition")).SetTexture((("L2UI_NewTex.StyleWnd.StyleWndMain" $ btnName) $ "_Over"));
	aniTextureLoop = GetAnimTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "_Loop"));
	aniTextureLoop.ShowWindow();
	aniTextureLoop.SetCurrentFrame(1);
	aniTextureLoop.SetLoopCount(-1);
	aniTextureLoop.Play();
	aniTextureOnce_Up = GetAnimTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "_Once_Up"));
	aniTextureOnce_Down = GetAnimTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "_Once_Down"));
	aniTextureOnce_Up.ShowWindow();
	aniTextureOnce_Up.SetCurrentFrame(1);
	aniTextureOnce_Up.SetLoopCount(1);
	aniTextureOnce_Up.Play();
	aniTextureOnce_Down.ShowWindow();
	aniTextureOnce_Down.SetCurrentFrame(1);
	aniTextureOnce_Down.SetLoopCount(1);
	aniTextureOnce_Down.Play();
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg01")).ShowWindow();
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg02_Up")).ShowWindow();
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg02_Down")).ShowWindow();
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg01")).SetAlpha(255);
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg02_Up")).SetAlpha(255);
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg02_Down")).SetAlpha(255);
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg02_Down")).SetAlpha(255);
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ btnName) $ "Title_Wnd")).SetAlpha(255);
	return;
}

function ButtonSetOut(string btnName, optional bool bImmediately)
{
	GetTextureHandle((("tex_" $ btnName) $ "_Condition")).SetTexture((("L2UI_NewTex.StyleWnd.StyleWndMain" $ btnName) $ "_Normal"));
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "_Loop")).HideWindow();
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "_Once_Up")).HideWindow();
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "_Once_Down")).HideWindow();
	if(bImmediately)
	{
		GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg01")).SetAlpha(0);
		GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg02_Up")).SetAlpha(0);
		GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg02_Down")).SetAlpha(0);
		GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ btnName) $ "Title_Wnd")).SetAlpha(0);
	}
	else
	{
		GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg01")).SetAlpha(0, 0.1000000);
		GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg02_Up")).SetAlpha(0, 0.1000000);
		GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "Bg02_Down")).SetAlpha(0, 0.1000000);
		GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ btnName) $ "Title_Wnd")).SetAlpha(0, 0.1000000);
	}
	return;
}

function SetButtonSetTitleTextureSizes()
{
	SetButtonSetTitleTextureSize("WeaponShapeBtn");
	SetButtonSetTitleTextureSize("KillEffectBtn");
	SetButtonSetTitleTextureSize("NameDecoBtn");
	return;
}

function SetButtonSetTitleTextureSize(string btnName)
{
	local int W, h;

	GetWindowHandle((((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ btnName) $ "Title_Wnd.") $ btnName) $ "Title_txt")).GetWindowSize(W, h);
	GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ btnName) $ "Title_Wnd")).SetWindowSize(Max(128, (W + 55)), 113);
	GetWindowHandle((((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ btnName) $ "Title_Wnd.") $ btnName) $ "Title_txt")).SetAnchor((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ btnName) $ "Title_Wnd"), "TopCenter", "TopCenter", 0, 20);
	return;
}

event OnMouseMove(WindowHandle a_WindowHandle, int X, int Y)
{
	local int oX, oY, locX, locY, W, h;

	if((currentPage > 0))
	{
		return;
	}
	m_hOwnerWnd.GetWindowSize(W, h);
	GetClientCursorPos(oX, oY);
	Global2Local(m_hOwnerWnd, oX, oY, locX, locY);
	TargetDistance = float((locX - (W / 2)));
	if((float((GetAppMilliSeconds() - clientStartSec)) > 500.0000000))
	{
		tickTimerObjectScroll._Reset();
	}
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	local int oX, oY, locX, locY, W, h;

	if((a_WindowHandle == none))
	{
		return;
	}
	if(CheckTabButtonOver(a_WindowHandle.GetWindowName(), "WeaponShapeBtn"))
	{
		return;
	}
	else if(CheckTabButtonOver(a_WindowHandle.GetWindowName(), "KillEffectBtn"))
	{
		return;
	}
	else if(CheckTabButtonOver(a_WindowHandle.GetWindowName(), "NameDecoBtn"))
	{
		return;
	}
	if((currentPage == 0))
	{
		m_hOwnerWnd.GetWindowSize(W, h);
		GetClientCursorPos(oX, oY);
		Global2Local(m_hOwnerWnd, oX, oY, locX, locY);
		TargetDistance = float((locX - (W / 2)));
		tickTimerObjectScroll._Reset();
		if(CheckButtonOver(a_WindowHandle.GetWindowName(), "WeaponShapeBtn"))
		{
			return;
		}
		else if(CheckButtonOver(a_WindowHandle.GetWindowName(), "KillEffectBtn"))
		{
			return;
		}
		else
		{
			CheckButtonOver(a_WindowHandle.GetWindowName(), "NameDecoBtn");
		}
	}
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	if((a_WindowHandle == none))
	{
		return;
	}
	if(CheckTabButtonOut(a_WindowHandle.GetWindowName(), "WeaponShapeBtn"))
	{
		return;
	}
	else if(CheckTabButtonOut(a_WindowHandle.GetWindowName(), "KillEffectBtn"))
	{
		return;
	}
	else if(CheckTabButtonOut(a_WindowHandle.GetWindowName(), "NameDecoBtn"))
	{
		return;
	}
	if((currentPage == 0))
	{
		TargetDistance = 0.0000000;
		tickTimerObjectScroll._Reset();
		if(CheckButtonOut(a_WindowHandle.GetWindowName(), "WeaponShapeBtn"))
		{
			return;
		}
		else if(CheckButtonOut(a_WindowHandle.GetWindowName(), "KillEffectBtn"))
		{
			return;
		}
		else
		{
			CheckButtonOut(a_WindowHandle.GetWindowName(), "NameDecoBtn");
		}
	}
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	local string btnName;

	if((a_WindowHandle == none))
	{
		return;
	}
	btnName = a_WindowHandle.GetWindowName();
	switch(btnName)
	{
		case "WeaponShapeBtn":
		case "KillEffectBtn":
		case "NameDecoBtn":
			GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "_Condition")).SetTexture((("L2UI_NewTex.StyleWnd.StyleWndMain" $ btnName) $ "_Normal"));
			break;
		default:
			break;
	}
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local string btnName;

	if((a_WindowHandle == none))
	{
		return;
	}
	btnName = a_WindowHandle.GetWindowName();
	switch(btnName)
	{
		case "WeaponShapeBtn":
		case "KillEffectBtn":
		case "NameDecoBtn":
			GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tex_") $ btnName) $ "_Condition")).SetTexture((("L2UI_NewTex.StyleWnd.StyleWndMain" $ btnName) $ "_Down"));
			break;
		default:
			break;
	}
	return;
}

function bool CheckTabButtonOver(string FullName, string buttonName)
{
	if((InStr(FullName, (buttonName $ "_Tab")) == -1))
	{
		return false;
	}
	if((GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ FullName)).IsEnableWindow() == false))
	{
		return false;
	}
	TabButtonSetOver(buttonName);
	return true;
}

function bool CheckTabButtonOut(string FullName, string buttonName)
{
	if((InStr(FullName, (buttonName $ "_Tab")) == -1))
	{
		return false;
	}
	if((GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ FullName)).IsEnableWindow() == false))
	{
		return false;
	}
	TabButtonSetOut(buttonName);
	return true;
}

function bool CheckButtonOver(string FullName, string buttonName)
{
	if((InStr(FullName, buttonName) == -1))
	{
		return false;
	}
	ButtonSetOver(buttonName);
	return true;
}

function bool CheckButtonOut(string FullName, string buttonName)
{
	if((InStr(FullName, buttonName) == -1))
	{
		return false;
	}
	ButtonSetOut(buttonName);
	return true;
}

event OnReceivedCloseUI()
{
	SetPrevPage();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

function SetPrevPage()
{
	switch(currentPage)
	{
		case 0:
			m_hOwnerWnd.HideWindow();
			break;
		case 1:
			Class'InterfaceClassic.CustomizingWndAppearance'.static.Inst().Hide();
			break;
		case 2:
			Class'InterfaceClassic.CustomizingWndKillEffect'.static.Inst().Hide();
			break;
		case 3:
			Class'InterfaceClassic.CustomizingWndNameDeco'.static.Inst().Hide();
			break;
		default:
			break;
	}
	if((currentPage > 0))
	{
		TargetDistance = 0.0000000;
		tickTimerObjectScroll._Reset();
		currentPage = 0;
		_ShowPC();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabGroup")).HideWindow();
		BtnBackHome.HideWindow();
	}
	ChangeButtonStates();
	return;
}

function RT_S_EX_CHARACTER_STYLE_USE_ITEM()
{
	local UIPacket._S_EX_CHARACTER_STYLE_USE_ITEM packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CHARACTER_STYLE_USE_ITEM(packet))
	{
		return;
	}
	m_hOwnerWnd.ShowWindow();
	SetCurrentPage((packet.nStyleType + 1));
	ChangeButtonStates();
	switch(currentPage)
	{
		case 1:
			Class'InterfaceClassic.CustomizingWndAppearance'.static.Inst()._SetSelectByStyleID(packet.nStyleID);
			break;
		case 2:
			Class'InterfaceClassic.CustomizingWndKillEffect'.static.Inst()._SetSelectByStyleID(packet.nStyleID);
			break;
		case 3:
			Class'InterfaceClassic.CustomizingWndNameDeco'.static.Inst()._SetSelectByStyleID(packet.nStyleID);
			break;
		default:
			break;
	}
	return;
}

function RQ_C_EX_CHARACTER_STYLE_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_CHARACTER_STYLE_LIST packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_CHARACTER_STYLE_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(926, stream);
	return;
}

function RT_S_EX_CHARACTER_STYLE_LIST()
{
	local UIPacket._S_EX_CHARACTER_STYLE_LIST packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CHARACTER_STYLE_LIST(packet))
	{
		return;
	}
	bRequestedStyleData = true;
	return;
}

function ClearAllDatas()
{
	bRequestedStyleData = false;
	return;
}

function HandleChangeCharacterPawn(string param)
{
	local string ClassName;

	ParseString(param, "ClassName", ClassName);
	Debug((" 폰 번호 확인 :" @ ClassName));  // EN?: Confirm your phone number:
	m_ObjectViewport.SetCharacterScale(1.0000000);
	switch(ClassName)
	{
		case "MFighter":
			m_ObjectViewport.SetCameraDistance(470);
			rotateBasic = 33500;
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(2);
			m_ObjectViewport.SetCharacterOffsetZ(1);
			break;
		case "FFighter":
			m_ObjectViewport.SetCameraDistance(470);
			rotateBasic = 33120;
			m_ObjectViewport.SetCharacterOffsetX(-19);
			m_ObjectViewport.SetCharacterOffsetY(0);
			m_ObjectViewport.SetCharacterOffsetZ(2);
			break;
		case "MMagic":
			m_ObjectViewport.SetCameraDistance(448);
			rotateBasic = 32800;
			m_ObjectViewport.SetCharacterOffsetX(-16);
			m_ObjectViewport.SetCharacterOffsetY(0);
			m_ObjectViewport.SetCharacterOffsetZ(4);
			break;
		case "FMagic":
			m_ObjectViewport.SetCameraDistance(425);
			rotateBasic = 33600;
			m_ObjectViewport.SetCharacterOffsetX(-15);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			m_ObjectViewport.SetCharacterOffsetZ(1);
			break;
		case "MElf":
			m_ObjectViewport.SetCameraDistance(475);
			rotateBasic = 33600;
			m_ObjectViewport.SetCharacterOffsetX(-3);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(2);
			break;
		case "FElf":
			m_ObjectViewport.SetCameraDistance(455);
			rotateBasic = 33750;
			m_ObjectViewport.SetCharacterOffsetX(-20);
			m_ObjectViewport.SetCharacterOffsetY(0);
			m_ObjectViewport.SetCharacterOffsetZ(1);
			break;
		case "MDarkElf":
			m_ObjectViewport.SetCameraDistance(485);
			rotateBasic = 33260;
			m_ObjectViewport.SetCharacterOffsetX(-18);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(-1);
			break;
		case "FDarkElf":
			m_ObjectViewport.SetCameraDistance(442);
			rotateBasic = 33600;
			m_ObjectViewport.SetCharacterOffsetX(7);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(2);
			break;
		case "MOrc":
			m_ObjectViewport.SetCameraDistance(460);
			rotateBasic = 33500;
			m_ObjectViewport.SetCharacterOffsetX(17);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			m_ObjectViewport.SetCharacterOffsetZ(2);
			break;
		case "FOrc":
			m_ObjectViewport.SetCameraDistance(488);
			rotateBasic = 33600;
			m_ObjectViewport.SetCharacterOffsetX(6);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			m_ObjectViewport.SetCharacterOffsetZ(4);
			break;
		case "MShaman":
			m_ObjectViewport.SetCameraDistance(500);
			rotateBasic = 34000;
			m_ObjectViewport.SetCharacterOffsetX(10);
			m_ObjectViewport.SetCharacterOffsetY(0);
			m_ObjectViewport.SetCharacterOffsetZ(4);
			break;
		case "FShaman":
			m_ObjectViewport.SetCameraDistance(470);
			rotateBasic = 34100;
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(0);
			m_ObjectViewport.SetCharacterOffsetZ(3);
			break;
		case "MDwarf":
			m_ObjectViewport.SetCameraDistance(380);
			rotateBasic = 33550;
			m_ObjectViewport.SetCharacterOffsetX(24);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(2);
			break;
		case "FDwarf":
			m_ObjectViewport.SetCameraDistance(380);
			rotateBasic = 33550;
			m_ObjectViewport.SetCharacterOffsetX(24);
			m_ObjectViewport.SetCharacterOffsetY(0);
			m_ObjectViewport.SetCharacterOffsetZ(4);
			break;
		case "MKamael":
			m_ObjectViewport.SetCameraDistance(475);
			rotateBasic = 33762;
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(3);
			break;
		case "FKamael":
			m_ObjectViewport.SetCameraDistance(462);
			rotateBasic = 30500;
			m_ObjectViewport.SetCharacterOffsetX(1);
			m_ObjectViewport.SetCharacterOffsetY(3);
			m_ObjectViewport.SetCharacterOffsetZ(0);
			break;
		case "FErtheia":
			m_ObjectViewport.SetCameraDistance(430);
			rotateBasic = 33000;
			m_ObjectViewport.SetCharacterOffsetX(-4);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(1);
			break;
		case "MSylph":
			m_ObjectViewport.SetCameraDistance(410);
			rotateBasic = 33000;
			m_ObjectViewport.SetCharacterOffsetX(-4);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(1);
			break;
		case "FSylph":
			m_ObjectViewport.SetCameraDistance(430);
			rotateBasic = 33000;
			m_ObjectViewport.SetCharacterOffsetX(-4);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(1);
			break;
		case "MHighElf":
			m_ObjectViewport.SetCameraDistance(470);
			rotateBasic = 32840;
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(0);
			break;
		case "FHighElf":
			m_ObjectViewport.SetCameraDistance(455);
			rotateBasic = 35960;
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(0);
			break;
		case "MHuman_DeathKnight":
			m_ObjectViewport.SetCameraDistance(470);
			rotateBasic = 33500;
			m_ObjectViewport.SetCharacterOffsetY(2);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetZ(1);
			break;
		case "MElf_DeathKnight":
			m_ObjectViewport.SetCameraDistance(470);
			rotateBasic = 33600;
			m_ObjectViewport.SetCharacterOffsetX(-3);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(2);
			break;
		case "MDarkElf_DeathKnight":
			m_ObjectViewport.SetCameraDistance(485);
			rotateBasic = 33260;
			m_ObjectViewport.SetCharacterOffsetX(-18);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(-1);
			break;
		case "MOrc_Rider":
			m_ObjectViewport.SetCameraDistance(720);
			rotateBasic = 33700;
			m_ObjectViewport.SetCharacterOffsetX(-8);
			m_ObjectViewport.SetCharacterOffsetY(11);
			m_ObjectViewport.SetCharacterOffsetZ(2);
			break;
		case "MHuman_Assassin":
			m_ObjectViewport.SetCameraDistance(507);
			rotateBasic = 29540;
			m_ObjectViewport.SetCharacterOffsetX(-26);
			m_ObjectViewport.SetCharacterOffsetY(3);
			m_ObjectViewport.SetCharacterOffsetZ(9);
			break;
		case "FDarkElf_Assassin":
			m_ObjectViewport.SetCameraDistance(442);
			rotateBasic = 31700;
			m_ObjectViewport.SetCharacterOffsetX(7);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(2);
			break;
		case "FDwarf_Maker":
			break;
		case "MHuman_WereWolf":
			m_ObjectViewport.SetCameraDistance(450);
			rotateBasic = 31900;
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(1);
			break;
		case "transform_wildwolf":
			m_ObjectViewport.SetCameraDistance(480);
			rotateBasic = 33930;
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			m_ObjectViewport.SetCharacterOffsetZ(0);
			break;
		case "FDarkElf_RoseVain":
			m_ObjectViewport.SetCameraDistance(442);
			rotateBasic = 33000;
			m_ObjectViewport.SetCharacterOffsetX(7);
			m_ObjectViewport.SetCharacterOffsetY(1);
			m_ObjectViewport.SetCharacterOffsetZ(0);
			break;
		default:
			break;
	}
	m_ObjectViewport.SetCurrentRotation(rotateBasic);
	m_ObjectViewport.SetCameraPitch(0);
	return;
}
