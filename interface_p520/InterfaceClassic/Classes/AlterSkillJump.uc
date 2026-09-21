class AlterSkillJump extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(9231);
	return;
}

function OnLoad()
{
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 106, 46);
	AddState("GAMINGSTATE");
	AddState("ARENABATTLESTATE");
	AddState("ARENAGAMINGSTATE");
	SetContainerHUD("none", 0);
	SetAlwaysFullAlpha(true);
	SetHavingFocus(false);
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "flyMove":
			RequestFlyMoveStart();
			break;
		default:
			break;
	}
	return;
}

function bool bFlag(int nFlag)
{
	if((nFlag > 0))
	{
		return true;
	}
	else
	{
		return false;
	}
}
