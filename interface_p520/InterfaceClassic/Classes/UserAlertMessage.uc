class UserAlertMessage extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(6110);
	RegisterGFxEvent(4560);
	return;
}

function OnLoad()
{
	RegisterState("UserAlertMessage", "GamingState");
	SetContainerHUD("none", 0);
	AddState("GAMINGSTATE");
	AddState("ARENABATTLESTATE");
	AddState("ARENAGAMINGSTATE");
	SetHavingFocus(false);
	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	return;
}
