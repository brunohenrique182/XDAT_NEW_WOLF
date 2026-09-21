class QuitReportWnd extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID = 999001;
const Refresh_Timer_ID = 999002;
const MAGIC_LAMP_MAX_GRADE = 4;



var WindowHandle Me;
var WindowHandle reportContainer;
var WindowHandle expInfoContainer;
var WindowHandle adenaInfoContainer;
var WindowHandle itemInfoContainer;
var WindowHandle magicLampInfoContainer;
var WindowHandle playTimeInfoContainer;
var TextureHandle ButtonIconImg_Texture;
var TextBoxHandle txtPlayReportWnd_Title;
var TextBoxHandle txtPlayReportWnd_item;
var TextBoxHandle txtPlayReportWnd_magicLamp;
var TextBoxHandle txtPlayReportWnd_exp;
var TextBoxHandle txtPlayReportWnd_GameSession;
var HtmlHandle txtPlayReportWnd_adena;
var ButtonHandle ITEMButton_Right;
var ButtonHandle ITEMButton_Reset;
var ButtonHandle BtnRestart;
var ButtonHandle btnCancel;
var INT64 beforeExp;
var INT64 Exp;
var INT64 beforeAdena;
var INT64 Adena;
var bool firstSetting;
var bool firstAdenaSetting;
var string quitOrRestartExeStr;
var ButtonHandle magicLampListOpenBtn;
var array<ItemInfo> getItemInfoArray;
var MagicLampGetInfo _getMagicLampInfo;
var L2Util util;
var InventoryWnd inventoryWndScript;
var QuitReportDrawerWnd QuitReportDrawerWndScript;
var QuitReportDrawerInstantZoneWnd QuitReportDrawerInstantZoneWndScript;
var QuitReportDrawerMagicLampWnd drawerMagicLampScript;
var UserInfo PlayerInfo;
var int _resetGameConnectTimeSec;

static function QuitReportWnd Inst()
{
	return QuitReportWnd(GetScript("QuitReportWnd"));
}

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(180);
	RegisterEvent(9570);
	RegisterEvent(3340);
	RegisterEvent(3350);
	RegisterEvent(5312);
	RegisterEvent(EV_PacketID(1105));
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function OnShow()
{
	Me.SetFocus();
	UpdateUserInfoHandler();
	updateGameSessionText();
	UpdateInfoControls();
	Me.SetTimer(999002, 10000);
	return;
}

function OnHide()
{
	drawerMagicLampScript.ClearListControls();
	Me.KillTimer(999002);
	return;
}

function Initialize()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	reportContainer = GetWindowHandle((ownerFullPath $ ".PlayReportWnd"));
	expInfoContainer = GetWindowHandle((reportContainer.m_WindowNameWithFullPath $ ".EXP_ReportWnd"));
	adenaInfoContainer = GetWindowHandle((reportContainer.m_WindowNameWithFullPath $ ".Adena_ReportWnd"));
	itemInfoContainer = GetWindowHandle((reportContainer.m_WindowNameWithFullPath $ ".Item_ReportWnd"));
	magicLampInfoContainer = GetWindowHandle((reportContainer.m_WindowNameWithFullPath $ ".Magiclamp_ReportWnd"));
	playTimeInfoContainer = GetWindowHandle((reportContainer.m_WindowNameWithFullPath $ ".GameSession_ReportWnd"));
	txtPlayReportWnd_exp = GetTextBoxHandle((expInfoContainer.m_WindowNameWithFullPath $ ".txtPlayReportWnd_exp"));
	txtPlayReportWnd_adena = GetHtmlHandle((adenaInfoContainer.m_WindowNameWithFullPath $ ".txtPlayReportWnd_adena"));
	txtPlayReportWnd_item = GetTextBoxHandle((itemInfoContainer.m_WindowNameWithFullPath $ ".txtPlayReportWnd_item"));
	txtPlayReportWnd_magicLamp = GetTextBoxHandle((magicLampInfoContainer.m_WindowNameWithFullPath $ ".txtPlayReportWnd_Magiclamp"));
	txtPlayReportWnd_GameSession = GetTextBoxHandle((playTimeInfoContainer.m_WindowNameWithFullPath $ ".txtPlayReportWnd_GameSession"));
	magicLampListOpenBtn = GetButtonHandle("QuitReportWnd.PlayReportWnd.MagicLampButton_Right");
	ITEMButton_Right = GetButtonHandle("QuitReportWnd.PlayReportWnd.ITEMButton_Right");
	ITEMButton_Reset = GetButtonHandle("QuitReportWnd.PlayReportWnd.ITEMButton_Reset");
	BtnRestart = GetButtonHandle("QuitReportWnd.BtnRestart");
	btnCancel = GetButtonHandle("QuitReportWnd.BtnCancel");
	ButtonIconImg_Texture = GetTextureHandle("QuitReportWnd.ButtonIconImg_Texture");
	util = L2Util(GetScript("L2Util"));
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	QuitReportDrawerWndScript = QuitReportDrawerWnd(GetScript("QuitReportDrawerWnd"));
	QuitReportDrawerInstantZoneWndScript = QuitReportDrawerInstantZoneWnd(GetScript("QuitReportDrawerInstantZoneWnd"));
	drawerMagicLampScript = QuitReportDrawerMagicLampWnd(GetScript("QuitReportDrawerMagicLampWnd"));
	Init();
	return;
}

function Init()
{
	beforeExp = INT64(0);
	Exp = INT64(0);
	Adena = INT64(0);
	beforeAdena = GetAdena();
	firstSetting = false;
	firstAdenaSetting = false;
	if(GetWindowHandle("QuitReportDrawerWnd").IsShowWindow())
	{
		setDrawerButtonState(true);
		GetWindowHandle("QuitReportDrawerWnd").HideWindow();
	}
	if(GetWindowHandle("QuitReportDrawerMagicLampWnd").IsShowWindow())
	{
		SetDrawerMagicLampButtonState(true);
		GetWindowHandle("QuitReportDrawerMagicLampWnd").HideWindow();
	}
	ResetMagicLampGetInfo();
	SetForm();
	UpdateInfoControls();
	return;
}

function SetForm()
{
	if(UseMagicLampSystem())
	{
		expInfoContainer.SetAnchor(reportContainer.m_WindowNameWithFullPath, "TopCenter", "TopCenter", 0, 51);
		adenaInfoContainer.SetAnchor(reportContainer.m_WindowNameWithFullPath, "TopCenter", "TopCenter", 0, 90);
		itemInfoContainer.SetAnchor(reportContainer.m_WindowNameWithFullPath, "TopCenter", "TopCenter", 0, 130);
		playTimeInfoContainer.SetAnchor(reportContainer.m_WindowNameWithFullPath, "TopCenter", "TopCenter", 0, 206);
		magicLampInfoContainer.ShowWindow();
	}
	else
	{
		expInfoContainer.SetAnchor(reportContainer.m_WindowNameWithFullPath, "TopCenter", "TopCenter", 0, 66);
		adenaInfoContainer.SetAnchor(reportContainer.m_WindowNameWithFullPath, "TopCenter", "TopCenter", 0, 104);
		itemInfoContainer.SetAnchor(reportContainer.m_WindowNameWithFullPath, "TopCenter", "TopCenter", 0, 143);
		playTimeInfoContainer.SetAnchor(reportContainer.m_WindowNameWithFullPath, "TopCenter", "TopCenter", 0, 190);
		magicLampInfoContainer.HideWindow();
	}
	return;
}

function ResetMagicLampGetInfo()
{
	local MagicLampGetInfo defaultInfo;

	_getMagicLampInfo = defaultInfo;
	return;
}

function setDrawerButtonState(bool bShow)
{
	if(bShow)
	{
		ITEMButton_Right.SetTexture("L2UI_CT1.Button.Button_DF_Right_Down", "L2UI_CT1.Button.Button_DF_Right_Down", "L2UI_CT1.Button.Button_DF_Right_Over");
	}
	else
	{
		ITEMButton_Right.SetTexture("L2UI_CT1.Button.Button_DF_Left_Down", "L2UI_CT1.Button.Button_DF_Left_Down", "L2UI_CT1.Button.Button_DF_Left_Over");
	}
	return;
}

function SetDrawerMagicLampButtonState(bool bShow)
{
	if(bShow)
	{
		magicLampListOpenBtn.SetTexture("L2UI_CT1.Button.Button_DF_Right_Down", "L2UI_CT1.Button.Button_DF_Right_Down", "L2UI_CT1.Button.Button_DF_Right_Over");
	}
	else
	{
		magicLampListOpenBtn.SetTexture("L2UI_CT1.Button.Button_DF_Left_Down", "L2UI_CT1.Button.Button_DF_Left_Down", "L2UI_CT1.Button.Button_DF_Left_Over");
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "ITEMButton_Right":
			if(!GetWindowHandle("QuitReportDrawerWnd").IsShowWindow())
			{
				setDrawerButtonState(false);
				GetWindowHandle("QuitReportDrawerWnd").ShowWindow();
				SetDrawerMagicLampButtonState(true);
				GetWindowHandle("QuitReportDrawerMagicLampWnd").HideWindow();
			}
			else
			{
				setDrawerButtonState(true);
				GetWindowHandle("QuitReportDrawerWnd").HideWindow();
			}
			break;
		case "MagicLampButton_Right":
			if(!GetWindowHandle("QuitReportDrawerMagicLampWnd").IsShowWindow())
			{
				SetDrawerMagicLampButtonState(false);
				GetWindowHandle("QuitReportDrawerMagicLampWnd").ShowWindow();
				setDrawerButtonState(true);
				GetWindowHandle("QuitReportDrawerWnd").HideWindow();
			}
			else
			{
				SetDrawerMagicLampButtonState(true);
				GetWindowHandle("QuitReportDrawerMagicLampWnd").HideWindow();
			}
			break;
		case "ITEMButton_Reset":
			OnITEMButton_ResetClick();
			break;
		case "BtnRestart":
			ExecuteQuitOrRestart();
			Me.HideWindow();
			break;
		case "BtnCancel":
			OnbtnCancelClick();
			break;
		default:
			break;
	}
	return;
}

function ExecuteQuitOrRestart()
{
	local InventoryWnd Script;

	Script = InventoryWnd(GetScript("InventoryWnd"));
	Script.SaveInventoryOrder();
	if((quitOrRestartExeStr == "quit"))
	{
		ExecQuit();
	}
	else
	{
		ExecRestart();
	}
	return;
}

function OnITEMButton_ResetClick()
{
	GetPlayerInfo(PlayerInfo);
	beforeExp = PlayerInfo.nCurExp;
	Exp = INT64(0);
	Adena = INT64(0);
	beforeAdena = GetAdena();
	firstSetting = true;
	firstAdenaSetting = true;
	QuitReportDrawerWndScript.Init();
	if(GetWindowHandle("QuitReportDrawerWnd").IsShowWindow())
	{
		setDrawerButtonState(true);
		GetWindowHandle("QuitReportDrawerWnd").HideWindow();
	}
	if(GetWindowHandle("QuitReportDrawerMagicLampWnd").IsShowWindow())
	{
		SetDrawerMagicLampButtonState(true);
		GetWindowHandle("QuitReportDrawerMagicLampWnd").HideWindow();
	}
	ResetMagicLampGetInfo();
	UpdateInfoControls();
	_resetGameConnectTimeSec = Class'Interface.UIData'.static.Inst().gameConnectTimeSec();
	updateGameSessionText();
	return;
}

function OnbtnCancelClick()
{
	Me.HideWindow();
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	local INT64 pAdena;
	local int nQuitRestrictField;

	if((a_EventID == 9570))
	{
		ParseINT64(a_Param, "Adena", pAdena);
		UpdateAdena(pAdena);
	}
	else if((a_EventID == 40))
	{
		ParseInt(a_Param, "QuitRestrictField", nQuitRestrictField);
		if((nQuitRestrictField == 0))
		{
			Init();
			QuitReportDrawerWndScript.Init();
		}
		_resetGameConnectTimeSec = 0;
	}
	else if((a_EventID == 3340))
	{
		quitOrRestartExeStr = "quit";
		ButtonIconImg_Texture.SetTexture("L2UI_CT1.Icon.QuitIcon");
		BtnRestart.SetButtonName(148);
		setWindowTitleByString(GetSystemString(148));
		Me.ShowWindow();
		Me.SetFocus();
	}
	else if((a_EventID == 3350))
	{
		quitOrRestartExeStr = "restart";
		ButtonIconImg_Texture.SetTexture("L2UI_CT1.Icon.RestartIcon");
		BtnRestart.SetButtonName(147);
		setWindowTitleByString(GetSystemString(147));
		Me.ShowWindow();
		Me.SetFocus();
	}
	else if((a_EventID == 180))
	{
		UpdateUserInfoHandler();
	}
	else if((a_EventID == 5312))
	{
		firstSetting = false;
		beforeExp = INT64(0);
		Exp = INT64(0);
		txtPlayReportWnd_exp.SetText(MakeFullSystemMsg(GetSystemMessage(4323), "0"));
	}
	else if((a_EventID == EV_PacketID(1105)))
	{
		Nt_S_EX_MAGICLAMP_RESULT();
	}
	return;
}

function updateGameSessionText()
{
	local int gameConnectTimeSec;

	gameConnectTimeSec = Class'Interface.UIData'.static.Inst().gameConnectTimeSec();
	if(((gameConnectTimeSec - _resetGameConnectTimeSec) < 0))
	{
		_resetGameConnectTimeSec = 0;
	}
	txtPlayReportWnd_GameSession.SetText(MakeTimeStr((gameConnectTimeSec - _resetGameConnectTimeSec)));
	return;
}

function addInzoneListItem(string inzoneName, string remainTimeStr)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 2;
	Record.LVDataList[0].szData = inzoneName;
	Record.LVDataList[1].szData = remainTimeStr;
	return;
}

function string setTimeString(int tmpTime)
{
	local string timeStr;
	local int timeHour, timeMin;

	if((tmpTime < 60))
	{
		timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string(1));
		timeStr = MakeFullSystemMsg(GetSystemMessage(3408), timeStr);
	}
	else if((tmpTime < 3600))
	{
		tmpTime = (tmpTime / 60);
		timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string(tmpTime));
	}
	else
	{
		timeHour = (tmpTime / 3600);
		timeMin = ((tmpTime - (timeHour * 3600)) / 60);
		if((timeMin > 0))
		{
			timeStr = (MakeFullSystemMsg(GetSystemMessage(3406), string(timeHour)) @ MakeFullSystemMsg(GetSystemMessage(3390), string(timeMin)));
		}
		else
		{
			timeStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeHour));
		}
	}
	return timeStr;
}

function UpdateAdena(INT64 pAdena)
{
	if((firstAdenaSetting == false))
	{
		Adena = INT64(0);
		beforeAdena = pAdena;
		firstAdenaSetting = true;
	}
	if((pAdena > beforeAdena))
	{
		Adena = (Adena + (pAdena - beforeAdena));
	}
	beforeAdena = pAdena;
	UpdateAdenaInfoControl();
	SetMPlayerClientVar("earned_adn", string(Adena));
	return;
}

function UpdateUserInfoHandler()
{
	local INT64 ItemCount;

	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	GetPlayerInfo(PlayerInfo);
	if((firstSetting == false))
	{
		firstSetting = true;
		beforeExp = PlayerInfo.nCurExp;
		Exp = INT64(0);
		if(Me.IsShowWindow())
		{
			UpdateExpInfoControl();
		}
	}
	if((PlayerInfo.nCurExp > beforeExp))
	{
		Exp = (Exp + (PlayerInfo.nCurExp - beforeExp));
	}
	beforeExp = PlayerInfo.nCurExp;
	ItemCount = INT64(QuitReportDrawerWndScript.GetTotalItemCount());
	if(Me.IsShowWindow())
	{
		UpdateExpInfoControl();
		UpdateItemInfoControl();
	}
	SetMPlayerClientVar("earned_exp", string(Exp));
	SetMPlayerClientVar("item_cnt", string(ItemCount));
	return;
}

function UpdateExpInfoControl()
{
	local string expStr;
	local Color expStrColor;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if(UseExpAdenaColorString())
	{
		if((Exp == INT64(0)))
		{
			expStr = string(Exp);
		}
		else
		{
			expStr = ConvertNumToTextNoAdena(string(Exp));
		}
		expStrColor = GetExpNumericColor(string(Exp));
	}
	else
	{
		expStr = MakeFullSystemMsg(GetSystemMessage(4323), MakeCostString(string(Exp)));
		expStrColor = GetColor(170, 153, 119, 255);
	}
	txtPlayReportWnd_exp.SetText(expStr);
	txtPlayReportWnd_exp.SetTextColor(expStrColor);
	return;
}

function UpdateAdenaInfoControl()
{
	local string htmlAdd, adenaHexColor, adenaStr;

	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if(UseExpAdenaColorString())
	{
		if((Adena == INT64(0)))
		{
			adenaStr = string(Adena);
		}
		else
		{
			adenaStr = ConvertNumToTextNoAdena(string(Adena));
		}
		adenaHexColor = getColorHexString(GetNumericColor(string(Adena)));
	}
	else
	{
		adenaStr = MakeCostString(string(Adena));
		adenaHexColor = "AA9977";
	}
	htmlAdd = HtmlAddTableTD(MakeFullSystemMsg(htmlAddText(GetSystemMessage(2932), "hs10", "AA9977"), htmlAddText(adenaStr, "hs10", adenaHexColor)), "center", "center", 0, 0, "", false);
	HtmlSetTableTR(htmlAdd);
	htmlSetTable(htmlAdd, 0, 174, 0, "", 0, 0);
	txtPlayReportWnd_adena.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd), false);
	return;
}

function UpdateItemInfoControl()
{
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	txtPlayReportWnd_item.SetText(MakeFullSystemMsg(GetSystemMessage(1983), MakeCostString(string(QuitReportDrawerWndScript.GetTotalItemCount()))));
	return;
}

function UpdateInfoControls()
{
	UpdateExpInfoControl();
	UpdateAdenaInfoControl();
	UpdateItemInfoControl();
	UpdateMagicLampInfoControls();
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 999001))
	{
		beforeAdena = GetAdena();
		Me.KillTimer(999001);
	}
	else if((TimerID == 999002))
	{
		updateGameSessionText();
	}
	return;
}

function externalAddItem(ItemInfo addItemInfo)
{
	QuitReportDrawerWndScript.externalAddItem(addItemInfo);
	QuitReportDrawerInstantZoneWndScript.externalAddItem(addItemInfo);
	return;
}

function UpdateMagicLampInfoControls()
{
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	txtPlayReportWnd_magicLamp.SetText(MakeFullSystemMsg(GetSystemMessage(1983), MakeCostString(string(_getMagicLampInfo.totalNum))));
	drawerMagicLampScript.UpdateMagicLampList();
	return;
}

function MagicLampGetInfo GetMagicLampGetInfo()
{
	return _getMagicLampInfo;
}

function AddMagicLampGetInfo(int Grade, INT64 Exp)
{
	local MagicLampExpInfo tempInfo;
	local int validGrade;

	if((Grade > 4))
	{
		Debug(("AddMagicLampGetInfo Grade out" @ string(Grade)));
		return;
	}
	validGrade = (Grade - 1);
	tempInfo = _getMagicLampInfo.expInfos[validGrade];
	tempInfo.Count = (tempInfo.Count + INT64(1));
	tempInfo.Exp = (tempInfo.Exp + Exp);
	_getMagicLampInfo.totalNum = (_getMagicLampInfo.totalNum + INT64(1));
	_getMagicLampInfo.expInfos[validGrade] = tempInfo;
	return;
}

function Nt_S_EX_MAGICLAMP_RESULT()
{
	local UIPacket._S_EX_MAGICLAMP_RESULT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_MAGICLAMP_RESULT(packet))
	{
		return;
	}
	AddMagicLampGetInfo(packet.nGrade, packet.nEXP);
	UpdateMagicLampInfoControls();
	return;
}

function bool UseMagicLampSystem()
{
	return IsAdenServer();
}

function bool UseExpAdenaColorString()
{
	return getInstanceUIData().GetIsClassicServer();
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
