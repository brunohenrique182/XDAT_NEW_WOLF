class WorldChatBox extends L2UIGFxScript;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	RegisterState("WorldChatBox", "GamingState");
	SetContainerHUD("none", 0);
	AddState("GAMINGSTATE");
	AddState("ARENABATTLESTATE");
	AddState("ARENAGAMINGSTATE");
	SetHavingFocus(false);
	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	return;
}
