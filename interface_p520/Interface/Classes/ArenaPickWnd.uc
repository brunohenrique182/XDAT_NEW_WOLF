class ArenaPickWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterEvent(3410);
	RegisterGFxEvent(8340);
	RegisterGFxEvent(8350);
	RegisterGFxEvent(8360);
	RegisterGFxEvent(8370);
	RegisterGFxEvent(8800);
	return;
}

function OnLoad()
{
	AddState("ARENAPICKSTATE");
	SetContainerHUD("SimpleNoBg", 0);
	SetDefaultShow(true);
	SetHavingFocus(false);
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 3410))
	{
		if((param == "ARENAPICKSTATE"))
		{
			ShowWindow();
		}
		else
		{
			HideWindow();
		}
	}
	return;
}

function OnFlashLoaded()
{
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 0, 0);
	return;
}
