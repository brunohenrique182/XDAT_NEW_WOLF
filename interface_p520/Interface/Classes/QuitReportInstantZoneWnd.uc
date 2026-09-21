class QuitReportInstantZoneWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle PlayReportWnd;
var TextBoxHandle txtPlayReportWnd_exp;
var TextBoxHandle txtPlayReportWnd_adena;
var TextBoxHandle txtPlayReportWnd_item;
var ButtonHandle ITEMButton_Right;
var INT64 beforeExp;
var INT64 Exp;
var INT64 beforeAdena;
var INT64 Adena;
var bool firstSetting;
var bool firstAdenaSetting;
var QuitReportDrawerInstantZoneWnd QuitReportDrawerWndScript;
var UserInfo PlayerInfo;
var bool bGainStart;
var bool bTryShowOnGamingState;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(180);
	RegisterEvent(9570);
	RegisterEvent(5312);
	RegisterEvent(150);
	RegisterEvent(11251);
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
	return;
}

function OnHide()
{
	return;
}

function Initialize()
{
	Me = GetWindowHandle("QuitReportInstantZoneWnd");
	txtPlayReportWnd_item = GetTextBoxHandle("QuitReportInstantZoneWnd.PlayReportWnd.txtPlayReportWnd_item");
	txtPlayReportWnd_exp = GetTextBoxHandle("QuitReportInstantZoneWnd.PlayReportWnd.txtPlayReportWnd_exp");
	txtPlayReportWnd_adena = GetTextBoxHandle("QuitReportInstantZoneWnd.PlayReportWnd.txtPlayReportWnd_adena");
	ITEMButton_Right = GetButtonHandle("QuitReportInstantZoneWnd.PlayReportWnd.ITEMButton_Right");
	QuitReportDrawerWndScript = QuitReportDrawerInstantZoneWnd(GetScript("QuitReportDrawerInstantZoneWnd"));
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
	txtPlayReportWnd_exp.SetText(MakeFullSystemMsg(GetSystemMessage(4323), "0"));
	txtPlayReportWnd_item.SetText(MakeFullSystemMsg(GetSystemMessage(1983), "0"));
	txtPlayReportWnd_adena.SetText(MakeFullSystemMsg(GetSystemMessage(2932), "0"));
	if(GetWindowHandle("QuitReportDrawerInstantZoneWnd").IsShowWindow())
	{
		setDrawerButtonState(true);
		GetWindowHandle("QuitReportDrawerInstantZoneWnd").HideWindow();
	}
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

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "ITEMButton_Right":
			if(!GetWindowHandle("QuitReportDrawerInstantZoneWnd").IsShowWindow())
			{
				setDrawerButtonState(false);
				GetWindowHandle("QuitReportDrawerInstantZoneWnd").ShowWindow();
			}
			else
			{
				setDrawerButtonState(true);
				GetWindowHandle("QuitReportDrawerInstantZoneWnd").HideWindow();
			}
			break;
		case "BtnCancel":
			OnbtnCancelClick();
			break;
		default:
			break;
	}
	return;
}

function InfoGainStart()
{
	bGainStart = true;
	GetPlayerInfo(PlayerInfo);
	beforeExp = PlayerInfo.nCurExp;
	Exp = INT64(0);
	Adena = INT64(0);
	beforeAdena = GetAdena();
	firstSetting = true;
	firstAdenaSetting = true;
	QuitReportDrawerWndScript.Init();
	return;
}

function InfoGainResult()
{
	bGainStart = false;
	Me.ShowWindow();
	UpdateAdena(Adena, true);
	UpdateUserInfoHandler(true);
	QuitReportDrawerWndScript.UpdateList();
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
		if(!bGainStart)
		{
			return;
		}
		ParseINT64(a_Param, "Adena", pAdena);
		UpdateAdena(pAdena);
	}
	else if((a_EventID == 40))
	{
		bTryShowOnGamingState = false;
		ParseInt(a_Param, "QuitRestrictField", nQuitRestrictField);
		if((nQuitRestrictField == 0))
		{
			Init();
			QuitReportDrawerWndScript.Init();
		}
		else if(Me.IsShowWindow())
		{
			bTryShowOnGamingState = true;
		}
	}
	else if((a_EventID == 180))
	{
		if(!bGainStart)
		{
			return;
		}
		UpdateUserInfoHandler();
	}
	else if((a_EventID == 5312))
	{
		firstSetting = false;
		beforeExp = INT64(0);
		Exp = INT64(0);
		txtPlayReportWnd_exp.SetText(MakeFullSystemMsg(GetSystemMessage(4323), "0"));
		Debug("----> EV_ChangedSubjob 초기화 경험치 초기화 ");  // EN?: ---- > EV_ChangedSubjob Reset exp
	}
	else if((a_EventID == 150))
	{
		Debug(("EV_GamingStateEnter 다시 열릴지 체크 " @ string(bTryShowOnGamingState)));  // EN?: EV_GamingStateEnter check to reopen
		if(bTryShowOnGamingState)
		{
			bTryShowOnGamingState = false;
			Me.ShowWindow();
		}
	}
	else if((a_EventID == 11251))
	{
		Me.HideWindow();
	}
	return;
}

function UpdateAdena(INT64 pAdena, optional bool bSetTextUpdate)
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
	if(bSetTextUpdate)
	{
		if((Adena > INT64(0)))
		{
			txtPlayReportWnd_adena.SetText(MakeFullSystemMsg(GetSystemMessage(2932), MakeCostString(string(Adena))));
		}
		else
		{
			txtPlayReportWnd_adena.SetText(MakeFullSystemMsg(GetSystemMessage(2932), "0"));
		}
	}
	return;
}

function UpdateUserInfoHandler(optional bool bSetTextUpdate)
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
	}
	if((PlayerInfo.nCurExp > beforeExp))
	{
		Exp = (Exp + (PlayerInfo.nCurExp - beforeExp));
	}
	beforeExp = PlayerInfo.nCurExp;
	if(bSetTextUpdate)
	{
		ItemCount = INT64(QuitReportDrawerWndScript.GetTotalItemCount());
		if((Exp > INT64(0)))
		{
			txtPlayReportWnd_exp.SetText(MakeFullSystemMsg(GetSystemMessage(4323), MakeCostString(string(Exp))));
		}
		else
		{
			txtPlayReportWnd_exp.SetText(MakeFullSystemMsg(GetSystemMessage(4323), "0"));
		}
		if((ItemCount > INT64(0)))
		{
			txtPlayReportWnd_item.SetText(MakeFullSystemMsg(GetSystemMessage(1983), MakeCostString(string(ItemCount))));
		}
		else
		{
			txtPlayReportWnd_item.SetText(MakeFullSystemMsg(GetSystemMessage(1983), "0"));
		}
	}
	return;
}

function externalAddItem(ItemInfo addItemInfo)
{
	if(!bGainStart)
	{
		return;
	}
	QuitReportDrawerWndScript.externalAddItem(addItemInfo);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
