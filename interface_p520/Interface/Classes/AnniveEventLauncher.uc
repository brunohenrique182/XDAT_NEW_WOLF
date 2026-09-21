class AnniveEventLauncher extends L2UIGFxScript;

var bool bInEvent;

static function AnniveEventLauncher Inst()
{
	return AnniveEventLauncher(GetScript("AnniveEventLauncher"));
}

event OnRegisterEvent()
{
	RegisterEvent(150);
	return;
}

event OnLoad()
{
	SetContainerHUD("SimpleNoBgNoDrag", 0);
	AddState("GAMINGSTATE");
	NotUseESC();
	SetHUD();
	SetHavingFocus(false);
	return;
}

event OnEvent(int eID, string param)
{
	Show();
	return;
}

function _Show()
{
	bInEvent = true;
	Show();
	return;
}

function Show()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	if(!bInEvent)
	{
		return;
	}
	if(IsPlayerOnWorldRaidServer())
	{
		return;
	}
	ShowWindow(getCurrentWindowName(string(self)));
	return;
}
