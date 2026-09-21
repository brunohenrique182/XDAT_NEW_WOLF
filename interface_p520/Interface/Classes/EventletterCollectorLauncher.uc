class EventletterCollectorLauncher extends L2UIGFxScript
	dependson(UIPacket);

var WindowHandle eventletterCollectorWndHandle;
var bool bActived;
var SideBar SideBarScript;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 831));
	RegisterEvent(180);
	RegisterEvent(40);
	RegisterEvent(3410);
	return;
}

function OnLoad()
{
	SetSaveWnd(true, false);
	RegisterState("EventletterCollectorLauncher", "GamingState");
	SetContainerWindow("SimpleNoBgNoDrag", 0);
	AddState("GAMINGSTATE");
	eventletterCollectorWndHandle = GetWindowHandle("EventletterCollectorWnd");
	SideBarScript = SideBar(GetScript("SideBar"));
	return;
}

function OnEvent(int Id, string param)
{
	switch(Id)
	{
		case (100000 + 831):
			HandleLuncherOnOf();
			break;
		case 180:
			HandleUpdateUserInfo();
			break;
		case 40:
			bActived = false;
			break;
		case 3410:
			if((param == "GAMINGSTATE"))
			{
				break;
			}
		default:
			break;
	}
	return;
}

function showSideBar(string minLv)
{
	if(bActived)
	{
		Debug(("showSideBarshowSideBarshowSideBar--->" @ minLv));
		SideBarScript.SetWindowShowHideByIndex(17, true);
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("EventletterCollectorLauncher");
		SideBarScript.setMakegfxWindowTooltip(17, minLv);
	}
	else
	{
		SideBarScript.SetWindowShowHideByIndex(17, false);
	}
	return;
}

function OnShow()
{
	SideBarScript.ToggleByWindowName("EventletterCollectorLauncher", true);
	CallGFxFunction("EventletterCollectorLauncher", "LevelCheck", "");
	return;
}

function OnHide()
{
	SideBarScript.ToggleByWindowName("EventletterCollectorLauncher", false);
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "ShowHideCollectorWnd":
			ShowHideCollectorWnd();
			break;
		default:
			break;
	}
	return;
}

function ShowHideCollectorWnd()
{
	if(eventletterCollectorWndHandle.IsShowWindow())
	{
		eventletterCollectorWndHandle.HideWindow();
	}
	else
	{
		eventletterCollectorWndHandle.ShowWindow();
	}
	return;
}

function HandleUpdateUserInfo()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("EventletterCollectorLauncher"))
	{
		if((getInstanceUIData().IsLevelUP() || getInstanceUIData().IsLevelDown()))
		{
			CallGFxFunction("EventletterCollectorLauncher", "LevelCheck", "");
		}
	}
	return;
}

function HandleLuncherOnOf()
{
	local UIPacket._S_EX_LETTER_COLLECTOR_UI_LAUNCHER packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_LETTER_COLLECTOR_UI_LAUNCHER(packet))
	{
		return;
	}
	if((int(packet.bActivate) == 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("EventletterCollectorLauncher");
	}
	else
	{
		bActived = true;
		CallGFxFunction("EventletterCollectorLauncher", "SetMinLevel", string(packet.nMinLevel));
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("EventletterCollectorLauncher");
		showSideBar(string(packet.nMinLevel));
	}
	EventletterCollectorWnd(GetScript("EventletterCollectorWnd")).MinLevel = packet.nMinLevel;
	return;
}
