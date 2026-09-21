class ArenaScoreBoardHUD extends L2UIGFxScript;

function OnRegisterEvent()
{
	return;
	RegisterGFxEvent(8500);
	RegisterGFxEvent(8520);
	RegisterGFxEvent(190);
	RegisterGFxEvent(2610);
	RegisterGFxEvent(8530);
	RegisterEvent(3410);
	RegisterGFxEvent(8380);
	RegisterGFxEvent(8540);
	RegisterGFxEvent(8541);
	RegisterGFxEvent(8542);
	return;
}

function OnLoad()
{
	AddState("ARENABATTLESTATE");
	AddState("ARENAGAMINGSTATE");
	AddState("ARENAOBSERVERSTATE");
	SetContainerHUD("none", 0);
	SetHavingFocus(false);
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
