class AnniveEvent extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(9660);
	RegisterGFxEvent(9670);
	RegisterGFxEvent(9680);
	RegisterGFxEvent(6000);
	return;
}

function OnLoad()
{
	SetContainerWindow("SkinnedWindow", 14081);
	AddState("GAMINGSTATE");
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 0, 0);
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	if((functionName == "shop"))
	{
		RequestOpenWndWithoutNPC(OPEN_15EVENT_HTML);
	}
	return;
}
