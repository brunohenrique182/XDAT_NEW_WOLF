class ArenaScoreBoardWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(2740);
	RegisterGFxEvent(1140);
	RegisterGFxEvent(1160);
	RegisterGFxEvent(1150);
	RegisterGFxEvent(1170);
	RegisterGFxEvent(180);
	RegisterGFxEvent(8510);
	RegisterGFxEvent(8500);
	RegisterGFxEvent(8520);
	RegisterGFxEvent(8400);
	RegisterGFxEvent(8401);
	RegisterGFxEvent(8402);
	RegisterGFxEvent(8370);
	RegisterGFxEvent(8430);
	RegisterGFxEvent(8380);
	RegisterGFxEvent(8542);
	return;
}

function OnLoad()
{
	AddState("ARENABATTLESTATE");
	AddState("ARENAOBSERVERSTATE");
	AddState("ARENAPICKSTATE");
	SetContainerWindow("none", 0);
	SetHavingFocus(false);
	return;
}

function OnFlashLoaded()
{
	SetRenderOnTop(true);
	SetAlwaysFullAlpha(true);
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 0, 0);
	return;
}

function OnEvent(int Id, string param)
{
	switch(Id)
	{
		case 3410:
			if(((param == "ARENAGAMINGSTATE") || (param == "ARENABATTLESTATE")))
			{
				HideWindow();
			}
			break;
		default:
			break;
	}
	return;
}
