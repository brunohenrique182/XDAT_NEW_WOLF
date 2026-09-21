class GFxUIScript extends UIScript;

enum EFlashImageLoaderType
{
	EImgLoader_None,                // 0
	EImgLoader_Pledge,              // 1
	EImgLoader_PackageTexture       // 2
};

enum EExternalFunctionType
{
	EFunc_None,                     // 0
	EFunc_SysStringTranslator       // 1
};

enum EDelegateHandlerType
{
	EDHandler_Default,              // 0
	EDHandler_OlympiadArenaList,    // 1
	EDHandler_UseSkill,             // 2
	EDHandler_Container,            // 3
	EDHandler_DamageText,           // 4
	EDHandler_Statistic,            // 5
	EDHandler_NotifyUSMEnd,         // 6
	EDHandler_ClanUnionAction,      // 7
	EDHandler_EventKalieWnd,        // 8
	EDHandler_Option,               // 9
	EDHandler_ShortcutAPI,          // 10
	EDHandler_InputAPI,             // 11
	EDHandler_BeautyshopWnd,        // 12
	EDHandler_ChatWnd,              // 13
	EDHandler_PledgeRecruit,        // 14
	EDHandler_EventChristmasWnd,    // 15
	EDHandler_EventCardWnd,         // 16
	EDHandler_AdenaDistributionWnd, // 17
	EDHandler_GFxDebug,             // 18
	EDHandler_LuckyGameWnd,         // 19
	EDHandler_TrainingRoomWnd,      // 20
	EDHandler_Event10thAnniversary, // 21
	EDHandler_RadarMap,             // 22
	EDHandler_AlchemyAPI,           // 23
	EDHandler_FishWnd,              // 24
	EDHandler_VipSystem,            // 25
	EDHandler_Arena,                // 26
	EDHandler_FactionWnd,           // 27
	EDHandler_Minimap,              // 28
	EDHandler_UpgradeSystemWnd,     // 29
	EDHandler_GameData,             // 30
	EDHandler_OBS,                  // 31
	EDHandler_CardUpdownGame,       // 32
	EDHandler_PledgeWnd,            // 33
	EDHandler_ElementalSpirit,      // 34
	EDHandler_Costume,              // 35
	EDHandler_ClassChange,          // 36
	EDHandler_TeleportList,         // 37
	EDHandler_HuntingZone           // 38
};

var Object m_pTargetWnd;

native function RegisterEvent(int ev);

native function RegisterGFxEventForLoaded(int ev);

native function RegisterGFxEvent(int ev);

native function RegisterState(string WindowName, string State);

native final function bool ShowFlashFromFilePath(string filePath, optional bool bDuplicated);

native final function CreateObject(out GFxValue val);

native final function CreateArray(out GFxValue val);

native final function bool Invoke(string funcName, out array<GFxValue> args, out GFxValue Result);

native final function AllocGFxValues(out array<GFxValue> args, int Num);

native final function DeallocGFxValues(out array<GFxValue> args);

native final function AllocGFxValue(out GFxValue val);

native final function DeallocGFxValue(out GFxValue val);

native final function RegisterDelegateHandler(EDelegateHandlerType Type);

native final function bool GetVariable(out GFxValue val, string PathToVar);

native final function GetFunction(out GFxValue val, EExternalFunctionType funcType);

native function SetMsgPassThrough(bool bPass);

native function SetAlwaysFullAlpha(bool bFull);

native function SetRenderOnTop(bool bSet);

native function SetDefaultShow(bool bSet);

native final function ShowWindow(optional string WindowName);

native final function HideWindow(optional string WindowName);

native final function bool IsShowWindow(optional string WindowName);

native final function SetFocus(optional string WindowName);

native final function BringToFrontOf(string TargetName);

native final function BringToFront();

native final function MakeRenderToTexture(bool bScreenSizeRenderTarget);

native final function IgnoreUIEvent(bool bIgnore);

native final function SetHavingFocus(bool bFocus);

native final function FlashMoviePlayStart(int iReserved);

native final function FlashMoviePlayEnd(int iReserved);

native final function SetAnchor(string targetWindowName, UIEventManager.EAnchorPointType targetPointType, UIEventManager.EAnchorPointType anchorPointType, int OffsetX, int OffsetY);

native final function SetFixedPositionRate(float fVerticalPositionRate, float fHorizontalPositionRate);

native final function ApplyFixedPositionRate();

native final function SetSaveWnd(bool bSavePosition, bool bSaveSize);

native final function SetRestartableFlash();

native final function SetContainer(string containerName);

native final function SetStateChangeNotification();

native final function HasTextField(bool enableIME);

native final function SetHasGFxTextField(bool HasTextField);

native final function SetNextFocus();

native final function SetModal(bool a_Modal);

native final function SetAlwaysOnTop(bool bAlwaysOnTop);

native final function SetRotateCursor();

native final function UnsetRotateCursor();

native final function bool IsSavedInfo();

native final function bool SetGFxFromSavedInfo();

native final function GetAnchorPointFromWindow(out float X, out float Y, UIEventManager.EAnchorPointType anchorType);

native function SetClosingOnESC();

native final function SetHUD();

native final function ForceToMoveMousePos(float X, float Y);

native final function SendCommandToServer(string Command);

event OnCallUCLogic(int logicID, string param)
{
	return;
}

event OnFlashLoaded()
{
	return;
}

event OnFocus(bool bFocused, bool bTransparencyMode)
{
	return;
}

native final function SetEulaText(out GFxValue val, string Name);

native final function int GetUserPremiumLevel();

native final function SetTimer(int a_TimerID, int a_DelayMiliseconds);

native final function KillTimer(int a_TimerID);

native final function SetCanBeShownDuringScene(bool bCanBeShownDuringScene);
