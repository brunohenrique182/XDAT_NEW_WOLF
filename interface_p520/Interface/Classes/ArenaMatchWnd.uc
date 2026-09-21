class ArenaMatchWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterEvent(3410);
	RegisterGFxEvent(8300);
	RegisterGFxEvent(8310);
	RegisterGFxEvent(8320);
	RegisterGFxEvent(8330);
	RegisterGFxEvent(4915);
	RegisterGFxEvent(4919);
	RegisterGFxEvent(4918);
	RegisterGFxEvent(1140);
	RegisterGFxEvent(1170);
	return;
}

function OnLoad()
{
	AddState("ARENAGAMINGSTATE");
	SetContainerHUD("none", 0);
	SetHUD();
	SetDefaultShow(true);
	SetHavingFocus(false);
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 3410))
	{
		if((param == "ARENAGAMINGSTATE"))
		{
			ShowWindow();
			GetWindowHandle("ChatWnd").ShowWindow();
			GetWindowHandle("ShortcutWnd").ShowWindow();
		}
		else if((param == "ARENAPICKSTATE"))
		{
			HideWindow();
		}
		else if((param == "ARENABATTLESTATE"))
		{
			GetWindowHandle("ChatWnd").ShowWindow();
			GetWindowHandle("ShortcutWnd").ShowWindow();
			HideWindow();
		}
	}
	return;
}

function OnFlashLoaded()
{
	SetAnchor("", ANCHORPOINT_BottomCenter, ANCHORPOINT_TopCenter, 0, 0);
	return;
}
