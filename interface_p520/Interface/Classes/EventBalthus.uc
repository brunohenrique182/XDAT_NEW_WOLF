class EventBalthus extends L2UIGFxScriptNoneContainer;

const FLASH_XPOS = -190;
const FLASH_YPOS = 0;

var int currentScreenWidth;
var int currentScreenHeight;
var bool saveShow;
var SideBar SideBarScript;
var bool bRunning;
var string tooltipZeroLine;
var string tooltipOneLine;
var string tooltipTwoLine;

function OnRegisterEvent()
{
	RegisterGFxEvent(9433);
	RegisterGFxEvent(9434);
	RegisterGFxEvent(9435);
	RegisterGFxEvent(40);
	RegisterGFxEventForLoaded(2900);
	RegisterEvent(9434);
	RegisterEvent(3410);
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	SetSaveWnd(true, true);
	SetHavingFocus(false);
	RegisterState("EventBalthus", "GamingState");
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 0, 0);
	SideBarScript = SideBar(GetScript("SideBar"));
	tooltipTwoLine = "";
	return;
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_EventKalieWnd);
	return;
}

function OnShow()
{
	saveShow = true;
	SideBarScript.ToggleByWindowName("EventBalthus", true);
	return;
}

function OnHide()
{
	SideBarScript.ToggleByWindowName("EventBalthus", false);
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 3410))
	{
		if((param == "GAMINGSTATE"))
		{
			if((saveShow == true))
			{
				SetShowWindow();
			}
		}
	}
	else if((Event_ID == 40))
	{
		if(saveShow)
		{
			saveShow = false;
		}
	}
	else if((Event_ID == 9434))
	{
		Debug(("EV_EventBalthusJackpotUser---->" @ param));
	}
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "closeEventBalthus":
			Debug("OnCallUcFunction -- closeEventBalthus ~ ");
			SideBarScript.SetWindowShowHideByIndex(18, false);
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("EventBalthus");
			break;
		case "openEventBalthus":
			Debug("OnCallUcFunction -- openEventBalthus ~ ");
			SideBarScript.SetWindowShowHideByIndex(18, true);
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("EventBalthus");
			break;
		case "SetIconEnabled":
			if(bool(param))
			{
				tooltipOneLine = GetSystemString(3869);
			}
			else
			{
				tooltipOneLine = GetSystemString(3870);
			}
			break;
		case "Running":
			bRunning = bool(param);
			if(!bool(param))
			{
				tooltipTwoLine = GetSystemMessage(4395);
			}
			HandleGuageSetColor(bRunning);
			break;
		case "CurrentState":
			if((int(GetLanguage()) == 1))
			{
				tooltipZeroLine = (GetSystemString(2980) @ param);
			}
			else
			{
				tooltipZeroLine = (param $ GetSystemString(2980));
			}
			break;
		case "progress":
			SideBarScript.SetPointByIndex(TYPE_EVENT_EVENTBALTHUS, (100 - int(param)), 100);
			break;
		case "Round":
			if(bRunning)
			{
				if((int(GetLanguage()) == 1))
				{
					tooltipTwoLine = (GetSystemString(670) @ param);
				}
				else
				{
					tooltipTwoLine = (param $ GetSystemString(670));
				}
			}
			break;
		default:
			break;
	}
	setTooltipSideBar();
	return;
}

function setTooltipSideBar()
{
	if((tooltipTwoLine != ""))
	{
		SideBarScript.setMakegfxWindowTooltip(18, (((tooltipZeroLine @ tooltipOneLine) @ "\\n") $ tooltipTwoLine));
	}
	else
	{
		SideBarScript.setMakegfxWindowTooltip(18, GetSystemString(3870));
	}
	return;
}

function HandleGuageSetColor(bool bRunning)
{
	local StatusRoundHandle guage;
	local Color tmpColor;

	if(bRunning)
	{
		tmpColor = GetColor(148, 148, 148, 255);
	}
	else
	{
		tmpColor = GetColor(227, 149, 57, 255);
	}
	guage = SideBarScript.GetStatusBarByIndex(18);
	guage.SetGaugeColor(7, tmpColor);
	return;
}

function Color GetColor(int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = byte(R);
	tColor.G = byte(G);
	tColor.B = byte(B);
	tColor.A = byte(A);
	return tColor;
}

function SetShowWindow()
{
	if((IsShowWindow() == false))
	{
		ShowWindow();
	}
	return;
}
