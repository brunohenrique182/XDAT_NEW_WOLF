class OlympiadScoreBoardHUD extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(11022);
	RegisterEvent(3410);
	return;
}

function OnLoad()
{
	AddState("GAMINGSTATE");
	SetContainerHUD("none", 0);
	SetDefaultShow(true);
	SetHavingFocus(false);
	SetHUD();
	return;
}

function OnFlashLoaded()
{
	IgnoreUIEvent(true);
	SetAnchor("", ANCHORPOINT_TopCenter, ANCHORPOINT_TopCenter, 0, 0);
	return;
}

function OnEvent(int Id, string param)
{
	switch(Id)
	{
		case 3410:
			if(((param == "ARENABATTLESTATE") || (param == "ARENAOBSERVERSTATE")))
			{
				ShowWindow(getCurrentWindowName(string(self)));
			}
			else
			{
				HideWindow(getCurrentWindowName(string(self)));
			}
			break;
		default:
			break;
	}
	return;
}
