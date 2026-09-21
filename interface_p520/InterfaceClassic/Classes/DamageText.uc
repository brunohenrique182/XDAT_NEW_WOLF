class DamageText extends GFxUIScript;

const FLASH_WIDTH = 800;
const FLASH_HEIGHT = 600;

enum EDamageTextType
{
	NOMAKE,                         // 0
	NormalAttack,                   // 1
	ConsecutiveAttack,              // 2
	Critical,                       // 3
	OverHit,                        // 4
	RecoverHP,                      // 5
	RecoverMP,                      // 6
	GetSP,                          // 7
	GetExp,                         // 8
	MagicDefiance,                  // 9
	ShieldGuard,                    // 10
	Dodge,                          // 11
	Immune,                         // 12
	SkillHit,                       // 13
	etc                             // 14
};

var int currentScreenWidth;
var int currentScreenHeight;

function OnRegisterEvent()
{
	RegisterEvent(5370);
	RegisterEvent(5371);
	return;
}

function OnLoad()
{
	RegisterState("DamageText", "GamingState");
	SetAnchor("", ANCHORPOINT_TopLeft, ANCHORPOINT_TopLeft, 0, 0);
	return;
}

function OnShow()
{
	return;
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_DamageText);
	SetAlwaysFullAlpha(true);
	IgnoreUIEvent(true);
	return;
}

function OnHide()
{
	return;
}

function OnCallUCLogic(int logicID, string param)
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	local string clipName;
	local int UnitType, xLoc, yLoc, valueType, Value, bCritical, bOverHit, bMagicDefense, bShieldDefense, bMiss, bContinuousAttack, bImmune, bSkillHit;
	local array<GFxValue> args;
	local GFxValue invokeResult;
	local int nID;

	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	if((Event_ID == 5370))
	{
		ShowWindow();
		ParseInt(param, "clipName", nID);
		clipName = string(nID);
		ParseInt(param, "unitType", UnitType);
		ParseInt(param, "valueType", valueType);
		ParseInt(param, "value", Value);
		ParseInt(param, "bCritical", bCritical);
		ParseInt(param, "bOverHit", bOverHit);
		ParseInt(param, "bMagicDefense", bMagicDefense);
		ParseInt(param, "bShieldDefense", bShieldDefense);
		ParseInt(param, "bMiss", bMiss);
		ParseInt(param, "bContinuousAttack", bContinuousAttack);
		ParseInt(param, "bImmune", bImmune);
		ParseInt(param, "bSkillHit", bSkillHit);
		ParseInt(param, "x", xLoc);
		ParseInt(param, "y", yLoc);
		conditionalDamageText(clipName, UnitType, xLoc, yLoc, valueType, Value, bCritical, bOverHit, bMagicDefense, bShieldDefense, bMiss, bContinuousAttack, bImmune, bSkillHit);
	}
	else if((Event_ID == 5371))
	{
		ShowWindow();
		ParseInt(param, "clipName", nID);
		clipName = string(nID);
		ParseInt(param, "x", xLoc);
		ParseInt(param, "y", yLoc);
		AllocGFxValues(args, 2);
		AllocGFxValue(invokeResult);
		args[0].SetInt(2);
		CreateObject(args[1]);
		args[1].SetMemberString("clipName", clipName);
		args[1].SetMemberInt("x", xLoc);
		args[1].SetMemberInt("y", yLoc);
		Invoke("_root.onEvent", args, invokeResult);
		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);
	}
	return;
}

function makeDamageText(string clipName, int UnitType, int textType, int xLoc, int yLoc, string messageStr)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	if((textType != -1))
	{
		AllocGFxValues(args, 2);
		AllocGFxValue(invokeResult);
		args[0].SetInt(1);
		CreateObject(args[1]);
		args[1].SetMemberString("clipName", clipName);
		args[1].SetMemberInt("unitType", UnitType);
		args[1].SetMemberInt("textType", textType);
		args[1].SetMemberInt("x", xLoc);
		args[1].SetMemberInt("y", yLoc);
		args[1].SetMemberString("messageStr", messageStr);
		Invoke("_root.onEvent", args, invokeResult);
		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);
	}
	return;
}

function conditionalDamageText(string clipName, int UnitType, int xLoc, int yLoc, int valueType, int Value, int bCritical, int bOverHit, int bMagicDefense, int bShieldDefense, int bMiss, int bContinuousAttack, int bImmune, int bSkillHit)
{
	local int damageTextType;

	damageTextType = -1;
	if((valueType == 3))
	{
		if((Value >= 0))
		{
			damageTextType = 5;
		}
		else
		{
			damageTextType = 1;
		}
		if((Value != 0))
		{
			makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
		}
	}
	else if((valueType == 4))
	{
		damageTextType = 6;
	}
	else if((valueType == 1))
	{
		damageTextType = 7;
	}
	else if((valueType == 2))
	{
		damageTextType = 8;
	}
	if(((Value > 0) && (valueType != 3)))
	{
		makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
	}
	if((bContinuousAttack == 1))
	{
		damageTextType = 2;
		makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
	}
	if((bOverHit == 1))
	{
		damageTextType = 4;
		makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
	}
	if((bCritical == 1))
	{
		damageTextType = 3;
		makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
	}
	if((bMagicDefense == 1))
	{
		damageTextType = 9;
		makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
	}
	if((bShieldDefense == 1))
	{
		damageTextType = 10;
		makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
	}
	if((bMiss == 1))
	{
		damageTextType = 11;
		makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
	}
	if((bImmune == 1))
	{
		damageTextType = 12;
		makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
	}
	if((bSkillHit != 0))
	{
		damageTextType = 13;
		makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
	}
	return;
}
