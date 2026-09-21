class ArenaMapGuidance extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(4560);
	RegisterGFxEvent(4570);
	RegisterGFxEvent(8380);
	RegisterGFxEvent(8430);
	RegisterEvent(3410);
	return;
}

function OnLoad()
{
	AddState("ARENAGAMINGSTATE");
	AddState("ARENABATTLESTATE");
	AddState("ARENAPICKSTATE");
	AddState("SPECIALCAMERASTATE");
	SetContainerWindow("none", 0);
	SetHUD();
	SetHavingFocus(false);
	SetCanBeShownDuringScene(true);
	return;
}

function OnFlashLoaded()
{
	IgnoreUIEvent(true);
	return;
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 3410:
			if(!getInstanceUIData().getIsArenaServer())
			{
				return;
			}
			if((param == "ARENAGAMINGSTATE"))
			{
				HideWindow();
			}
			else if((param == "SPECIALCAMERASTATE"))
			{
				ShowWindow();
			}
			break;
		default:
			break;
	}
	return;
}
