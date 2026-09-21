class AlterSkill extends L2UIGFxScript;

const FLASH_WIDTH = 800;
const FLASH_HEIGHT = 600;

var int currentScreenWidth;
var int currentScreenHeight;

function OnRegisterEvent()
{
	RegisterEvent(3410);
	RegisterEvent(5130);
	RegisterGFxEvent(5130);
	RegisterGFxEvent(5131);
	RegisterGFxEvent(5132);
	RegisterGFxEvent(40);
	RegisterGFxEvent(8545);
	RegisterGFxEvent(8546);
	return;
}

function OnLoad()
{
	RegisterState("AlterSkill", "GamingState");
	SetContainerHUD("none", 0);
	AddState("GAMINGSTATE");
	AddState("ARENABATTLESTATE");
	SetDefaultShow(true);
	SetHavingFocus(false);
	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	return;
}

function OnShow()
{
	return;
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_UseSkill);
	return;
}

function OnHide()
{
	return;
}

function OnCallUCLogic(int logicID, string param)
{
	if((logicID == 1))
	{
		SetNextFocus();
		HideWindow();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local string mainKey;

	if((Event_ID == 5130))
	{
		ParseString(param, "mainKey", mainKey);
		CallGFxFunction("AlterSkill", "setShowShortKey", string((mainKey != "")));
	}
	else if((Event_ID == 3410))
	{
		if((param == "ARENAGAMINGSTATE"))
		{
			HideWindow();
		}
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

function int getSkillIconType(int skill_id)
{
	local int returnV;

	returnV = 1;
	switch(skill_id)
	{
		case 0:
		case 1:
		case 2:
			returnV = 1;
			break;
		case 3:
		case 4:
		case 5:
			returnV = 2;
			break;
		default:
			break;
	}
	return returnV;
}
