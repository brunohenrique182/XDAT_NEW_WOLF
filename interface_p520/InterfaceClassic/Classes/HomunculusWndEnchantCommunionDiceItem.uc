class HomunculusWndEnchantCommunionDiceItem extends UICommonAPI;

const DICE_H = 120;
const DICETIME_FIRST = 100;
const ROTATEMAX = 4;
const TWEENKEYNONE = 0;
const TWEENKEYSHOW = 11;
const TWEENKEYHIDE = 12;

var WindowHandle Me;
var string m_Windowname;
var int Index;
var TextureHandle dice0;
var TextureHandle DiceSwap00;
var TextureHandle DiceSwap01;
var AnimTextureHandle DiceComplete;
var AnimTextureHandle DiceSame;
var TextureHandle FlagMask_tex;
var int dicePointSwap0;
var int dicePointSwap1;
var int diceTime0;
var int diceNumb0;
var int diceTarget0;
var bool isDiceSame;
var int currentDiceIndex;
var L2UITween l2UITweenScript;
var int time_Add;
var HomunculusWndEnchantCommunionDice homunculusWndEnchantCommunionDiceScript;

function Init(string WindowName)
{
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	Index = int(Right(m_Windowname, 1));
	DiceSwap00 = GetTextureHandle((m_Windowname $ ".DiceAni.DiceSwap00"));
	DiceSwap01 = GetTextureHandle((m_Windowname $ ".DiceAni.DiceSwap01"));
	DiceComplete = GetAnimTextureHandle((m_Windowname $ ".DiceComplete"));
	DiceSame = GetAnimTextureHandle((m_Windowname $ ".DiceSame"));
	FlagMask_tex = GetTextureHandle((m_Windowname $ ".DiceAni.FlagMask_tex"));
	switch(Index)
	{
		case 0:
			FlagMask_tex.SetTexture("L2UI_EPIC.HomunCulusWnd.HomunDiceBG_SystemMask");
			break;
		case 1:
		case 2:
			break;
		default:
			break;
	}
	DiceComplete.Stop();
	homunculusWndEnchantCommunionDiceScript = HomunculusWndEnchantCommunionDice(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionDice"));
	l2UITweenScript = L2UITween(GetScript("L2UITween"));
	time_Add = (-100 / (4 + 6));
	currentDiceIndex = 11;
	return;
}

function Clear()
{
	l2UITweenScript.StopTween(("HomunculusWnd." $ m_Windowname), 0);
	l2UITweenScript.StopTween(("HomunculusWnd." $ m_Windowname), 12);
	l2UITweenScript.StopTween(("HomunculusWnd." $ m_Windowname), 11);
	if((currentDiceIndex == 11))
	{
		DiceSwap00.MoveC(0, 0);
		DiceSwap01.MoveC(0, -120);
	}
	else
	{
		DiceSwap00.MoveC(0, -120);
		DiceSwap01.MoveC(0, 0);
	}
	diceTime0 = 100;
	diceNumb0 = 0;
	DiceComplete.Stop();
	DiceSame.Stop();
	isDiceSame = false;
	return;
}

function OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case "tweenEnd":
			HandleComplete(int(param));
			break;
		default:
			break;
	}
	return;
}

function ShowSame()
{
	if(isDiceSame)
	{
		DiceSame.SetLoopCount(99999);
		DiceSame.Play();
	}
	return;
}

function HandleComplete(int Id)
{
	if((diceNumb0 >= 4))
	{
		if((diceTarget0 == (dicePointSwap0 + 1)))
		{
			if((Id != 0))
			{
				Debug((((("HandleComplete" @ string(diceTarget0)) @ string(dicePointSwap0)) @ string(Index)) @ string(Id)));
				DiceComplete.Play();
				homunculusWndEnchantCommunionDiceScript.CompletedDice();
			}
			return;
		}
	}
	if((Id == 12))
	{
		dicePointSwap0++;
		if((dicePointSwap0 == 6))
		{
			dicePointSwap0 = 0;
		}
		DiceSwap00.SetTexture(("L2UI_CH3.Br_Score" $ string((dicePointSwap0 + 1))));
		currentDiceIndex = 11;
		MakeChargeObjectHide(DiceSwap01);
		MakeChargeObjectShow(DiceSwap00, currentDiceIndex);
	}
	else if((Id == 11))
	{
		diceTime0 = (diceTime0 + time_Add);
		diceNumb0++;
		dicePointSwap0++;
		if((dicePointSwap0 == 6))
		{
			dicePointSwap0 = 0;
		}
		DiceSwap01.SetTexture(("L2UI_CH3.Br_Score" $ string((dicePointSwap0 + 1))));
		currentDiceIndex = 12;
		MakeChargeObjectShow(DiceSwap01);
		MakeChargeObjectHide(DiceSwap00, currentDiceIndex);
	}
	return;
}

function MakeChargeObjectHide(TextureHandle Target, optional int Id)
{
	MakeChargeObject(Target, Id);
	return;
}

function MakeChargeObjectShow(TextureHandle Target, optional int Id)
{
	Target.MoveC(0, -120);
	MakeChargeObject(Target, Id);
	return;
}

function Dice()
{
	if((currentDiceIndex == 11))
	{
		MakeChargeObjectShow(DiceSwap01);
		MakeChargeObjectHide(DiceSwap00, 12);
	}
	else
	{
		MakeChargeObjectHide(DiceSwap01);
		MakeChargeObjectShow(DiceSwap00, 11);
	}
	return;
}

function SetTargetNum(int targetNum)
{
	isDiceSame = false;
	diceTarget0 = targetNum;
	return;
}

function MakeChargeObject(TextureHandle Target, int Id)
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = ("HomunculusWnd." $ m_Windowname);
	tweenObjectData.Id = Id;
	tweenObjectData.Target = Target;
	tweenObjectData.Duration = float(diceTime0);
	tweenObjectData.MoveY = 120.0000000;
	tweenObjectData.ease = EASENONE;
	l2UITweenScript.AddTweenObject(tweenObjectData);
	return;
}
