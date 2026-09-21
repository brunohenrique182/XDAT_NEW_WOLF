class ArenaSkillUpgrade extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(1280);
	RegisterGFxEvent(1290);
	RegisterGFxEvent(1291);
	RegisterGFxEvent(2064);
	RegisterGFxEvent(2065);
	RegisterGFxEvent(4600);
	RegisterEvent(40);
	return;
}

function OnEvent(int Id, string param)
{
	switch(Id)
	{
		case 40:
			HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnLoad()
{
	AddState("ARENABATTLESTATE");
	AddState("ARENAGAMINGSTATE");
	SetContainerHUD("none", 0);
	SetHavingFocus(false);
	return;
}

function OnFlashLoaded()
{
	SetAnchor("", ANCHORPOINT_BottomCenter, ANCHORPOINT_BottomCenter, 0, -140);
	return;
}
