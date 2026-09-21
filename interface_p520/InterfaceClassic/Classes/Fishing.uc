class Fishing extends L2UIGFxScript;

event OnRegisterEvent()
{
	RegisterGFxEvent(2490);
	RegisterGFxEvent(2471);
	RegisterGFxEvent(2481);
	return;
}

event OnLoad()
{
	SetContainerHUD("none", 0);
	AddState("GAMINGSTATE");
	SetHavingFocus(false);
	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	return;
}

event OnCallUCLogic(int logicID, string param)
{
	switch(logicID)
	{
		case 1:
			SetNextFocus();
			HideWindow();
			break;
		default:
			break;
	}
	return;
}
