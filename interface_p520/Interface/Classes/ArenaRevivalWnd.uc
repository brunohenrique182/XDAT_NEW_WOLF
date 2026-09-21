class ArenaRevivalWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	AddState("ARENAGAMINGSTATE");
	AddState("ARENABATTLESTATE");
	AddState("ARENAPICKSTATE");
	SetContainerWindow("none", 0);
	SetHavingFocus(false);
	return;
}

function OnFlashLoaded()
{
	SetRenderOnTop(true);
	SetAlwaysFullAlpha(true);
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 0, -50);
	return;
}

function OnEvent(int Id, string param)
{
	switch(Id)
	{
		case 1430:
			ShowWindow();
			break;
		case 1440:
		case 40:
			HideWindow();
			break;
		default:
			break;
	}
	return;
}
