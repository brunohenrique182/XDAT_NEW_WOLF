class BR_EventChristmasWnd extends UICommonAPI;

var WindowHandle Me;

function OnRegisterEvent()
{
	RegisterEvent(9110);
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	if((1 == 0))
	{
		Me = GetHandle("BR_EventChristmasWnd");
	}
	else
	{
		Me = GetWindowHandle("BR_EventChristmasWnd");
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int Show;

	switch(Event_ID)
	{
		case 9110:
			ParseInt(param, "Show", Show);
			Debug(("Christmas EEEEEEEEEEEEEEEvent! " $ string(Show)));
			if((Show == 0))
			{
				if(Me.IsShowWindow())
				{
					Me.HideWindow();
				}
			}
			else
			{
				if(!Me.IsShowWindow())
				{
					Me.ShowWindow();
				}
				AddSystemMessage(6029);
			}
		default:
			return;
	}
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "EventChristmasBtn1":
			OnEventHalloBtn1Click();
			break;
		case "EventChristmasBtn2":
			OnEventHalloBtn2Click();
			break;
		case "EventChristmasBtn3":
			OnEventHalloBtn3Click();
			break;
		default:
			break;
	}
	return;
}

function OnEventHalloBtn1Click()
{
	local string strParam;

	if(IsShowWindow("BR_EventHtmlWndA"))
	{
		HideWindow("BR_EventHtmlWndA");
	}
	else
	{
		ShowWindowWithFocus("BR_EventHtmlWndA");
		ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "br_xmas_2009_UI_rudolf000.htm"));
		ParamAdd(strParam, "Title", GetSystemString(5043));
		ExecuteEvent(9111, strParam);
	}
	return;
}

function OnEventHalloBtn2Click()
{
	local string strParam;

	if(IsShowWindow("BR_EventHtmlWndB"))
	{
		HideWindow("BR_EventHtmlWndB");
	}
	else
	{
		ShowWindowWithFocus("BR_EventHtmlWndB");
		ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "br_xmas_2009_UI_santa000.htm"));
		ParamAdd(strParam, "Title", GetSystemString(5044));
		ExecuteEvent(9112, strParam);
	}
	return;
}

function OnEventHalloBtn3Click()
{
	local string strParam;

	if(IsShowWindow("BR_EventHtmlWndC"))
	{
		HideWindow("BR_EventHtmlWndC");
	}
	else
	{
		ShowWindowWithFocus("BR_EventHtmlWndC");
		ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "br_xmas_2009_UI_reward000.htm"));
		ParamAdd(strParam, "Title", GetSystemString(5045));
		ExecuteEvent(9113, strParam);
	}
	return;
}
