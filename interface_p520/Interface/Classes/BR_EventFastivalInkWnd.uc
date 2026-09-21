class BR_EventFastivalInkWnd extends UICommonAPI;

var int MaxEnergy;
var int CurrentEnergy;
var WindowHandle Me;
var TextureHandle EventInkTex;
var TextureHandle EventInkTexBG;
var ButtonHandle HelpButton;
var StatusBarHandle GoalGage1;
var StatusBarHandle GoalGage2;
var StatusBarHandle GoalGageMax;
var bool m_showInk;

function OnRegisterEvent()
{
	RegisterEvent(10000);
	RegisterEvent(10001);
	RegisterEvent(3410);
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	if((1 == 0))
	{
		Me = GetHandle("BR_EventFastivalInkWnd");
		EventInkTex = TextureHandle(GetHandle("BR_EventFastivalInkWnd.EventInkTex"));
		EventInkTexBG = TextureHandle(GetHandle("BR_EventFastivalInkWnd.EventInkTexBG"));
		HelpButton = ButtonHandle(GetHandle("BR_EventFastivalInkWnd.HelpButton"));
		GoalGage1 = GetStatusBarHandle("BR_EventFastivalInkWnd.GoalGage1");
		GoalGage2 = GetStatusBarHandle("BR_EventFastivalInkWnd.GoalGage2");
		GoalGageMax = GetStatusBarHandle("BR_EventFastivalInkWnd.GoalGageMax");
	}
	else
	{
		Me = GetWindowHandle("BR_EventFastivalInkWnd");
		EventInkTex = GetTextureHandle("BR_EventFastivalInkWnd.EventInkTex");
		EventInkTexBG = GetTextureHandle("BR_EventFastivalInkWnd.EventInkTexBG");
		HelpButton = GetButtonHandle("BR_EventFastivalInkWnd.HelpButton");
		GoalGage1 = GetStatusBarHandle("BR_EventFastivalInkWnd.GoalGage1");
		GoalGage2 = GetStatusBarHandle("BR_EventFastivalInkWnd.GoalGage2");
		GoalGageMax = GetStatusBarHandle("BR_EventFastivalInkWnd.GoalGageMax");
	}
	MaxEnergy = 10000;
	CurrentEnergy = 0;
	GoalGageMax.SetPointExpPercentRate(1.0000000);
	GoalGageMax.HideWindow();
	Me.HideWindow();
	EventInkTexBG.HideWindow();
	m_showInk = false;
	return;
}

function Load()
{
	HelpButton.SetTooltipCustomType(SetTooltip(GetSystemString(5148)));
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	local int iEnergy;

	switch(a_EventID)
	{
		case 10000:
			ParseInt(a_Param, "Energy", iEnergy);
			EventInkWndShow(iEnergy);
			break;
		case 10001:
			ParseInt(a_Param, "Energy", iEnergy);
			FireEventGauge(iEnergy);
			break;
		default:
			break;
	}
	if((a_EventID == 3410))
	{
		if((a_Param == "GAMINGSTATE"))
		{
			if((m_showInk == true))
			{
				if(!Me.IsShowWindow())
				{
					Me.ShowWindow();
				}
			}
		}
	}
	return;
}

function EventInkWndShow(int iMaxEnergy)
{
	if(!Me.IsShowWindow())
	{
		Me.ShowWindow();
	}
	MaxEnergy = iMaxEnergy;
	GoalGage1.SetPointExpPercentRate(0.0000000);
	GoalGage2.SetPointExpPercentRate(0.0000000);
	m_showInk = true;
	return;
}

function FireEventGauge(int iEnergy)
{
	local float convertpercent;

	CurrentEnergy = iEnergy;
	convertpercent = (float(CurrentEnergy) / float(MaxEnergy));
	if((convertpercent >= 1.0000000))
	{
		GoalGage1.SetPointExpPercentRate(1.0000000);
		EventInkTex.SetTexture("BranchSys3.icon1.g_ev_invite_ink_03");
		GoalGage1.HideWindow();
		GoalGage2.HideWindow();
		GoalGageMax.ShowWindow();
		EventInkTexBG.ShowWindow();
	}
	else
	{
		if((convertpercent >= 0.1429000))
		{
			EventInkTex.SetTexture("BranchSys3.icon1.g_ev_invite_ink_02");
			GoalGage2.ShowWindow();
			GoalGage1.HideWindow();
			GoalGage2.SetPointExpPercentRate(convertpercent);
		}
		else
		{
			EventInkTex.SetTexture("BranchSys3.icon1.g_ev_invite_ink_01");
			GoalGage1.ShowWindow();
			GoalGage2.HideWindow();
			GoalGage1.SetPointExpPercentRate(convertpercent);
		}
		GoalGageMax.HideWindow();
		EventInkTexBG.HideWindow();
	}
	return;
}

function CustomTooltip SetTooltip(string Text)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;

	ToolTip.MinimumWidth = 144;
	ToolTip.DrawList.Length = 1;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_color.R = 178;
	Info.t_color.G = 190;
	Info.t_color.B = 207;
	Info.t_color.A = 255;
	Info.t_strText = Text;
	ToolTip.DrawList[0] = Info;
	return ToolTip;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "HelpButton":
			OnHelpButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnEventFireBtn1Click()
{
	return;
}

function OnHelpButtonClick()
{
	return;
}
