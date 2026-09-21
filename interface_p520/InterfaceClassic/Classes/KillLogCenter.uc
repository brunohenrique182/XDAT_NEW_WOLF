class KillLogCenter extends L2UIGFxScript;

event OnRegisterEvent()
{
	RegisterGFxEvent(40);
	return;
}

event OnLoad()
{
	SetSaveWnd(true, true);
	AddState("GAMINGSTATE");
	SetDefaultShow(true);
	SetHavingFocus(false);
	return;
}

event OnFlashLoaded()
{
	Class'InterfaceClassic.PositionManager'.static.Inst()._MoveOnLoad(getCurrentWindowName(string(self)));
	IgnoreUIEvent(true);
	return;
}
