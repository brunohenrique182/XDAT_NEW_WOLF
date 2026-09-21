class AdenLabPiece extends UIScript;

const CENTER_X = 400;
const CENTER_Y = 287;
const TweenTime = 1000;
const Distance = 100;
const ROTATEANGLE = 20;
const Encourage_TWEENID_UP = 0;
const Encourage_TWEENID_DOWN = 1;
const Encourage_TWEENID_TOP_DOWN = 2;
const Encourage_TWEENID_BOTTOM_UP = 3;
const Encourage_TWEEN_MOVINGDIST = 5;

struct SpcialOptionDataStruct
{
	var int OptionID;
	var int EffectSlot;
	var array<ExOptionData> optionDatas;
	var array<float> probs;
};

var byte BossID;
var int pieceID;
var CardSelectStageInfo stageInfo;
var array<int> levels;
var int optionNum;
var int MaxLevel;
var array<int> optionIds;
var TextureHandle UpTexture;
var WindowHandle highLights;
var array<L2UITweenTwinkleObject> twinkleObjects;
var WindowHandle piece;
var AnimTextureHandle completeIcon;
var WindowHandle completeIcon02;
var L2UITweenObject tObject;
var L2UITween l2UITweenScript;
var L2UITimer encourageTimer;
var L2UITimerObject clickEncourgeTObject;
var int StartX;
var int StartY;
var float Angle;
var bool isOver;
var bool isDown;
var INT64 lastAppMilliSeconds;
var array<SpcialOptionDataStruct> spcialOptionDatas;

function _GetOptionDatas(out array<int> oOptionIDs, out array<int> oOptionLevels)
{
	oOptionIDs = optionIds;
	oOptionLevels = levels;
	return;
}

function int _GetPieceID()
{
	return pieceID;
}

function int _GetSlotID()
{
	return (pieceID + 1);
}

function int _GetStageIndex()
{
	return stageInfo.Index;
}

function UIEventManager.EStageType _GetStageType()
{
	return stageInfo.StageType;
}

function _SetLevels(array<int> lvs)
{
	levels = lvs;
	SetStageName();
	return;
}

static function AdenLabPiece _InitScript(WindowHandle wnd, CardSelectData Data)
{
	local AdenLabPiece scr;

	wnd.SetScript("AdenlabPiece");
	scr = AdenLabPiece(wnd.GetScript());
	scr._InitWindow(wnd, Data);
	return scr;
}

function _InitWindow(WindowHandle W, CardSelectData Data)
{
	local array<string> strings;

	m_hOwnerWnd = W;
	Class'InterfaceClassic.UICommonAPI'.static.Split(m_hOwnerWnd.m_WindowNameWithFullPath, "_", strings);
	pieceID = int(strings[1]);
	stageInfo = Data.StageArray[pieceID];
	BossID = Data.BossID;
	m_hOwnerWnd.SetAlpha(0);
	piece = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".piece"));
	completeIcon02 = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".piece.completeIcon02"));
	completeIcon02.HideWindow();
	completeIcon = GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".piece.completeIcon"));
	completeIcon.SetLoopCount(1);
	completeIcon.HideWindow();
	SetOptionIds();
	GetLocalPosition(m_hOwnerWnd, StartX, StartY);
	SetAngleFormZero();
	InitTweensObject();
	InitTwinklesTweens();
	InitTimerObject();
	InitTextures();
	SetStageName();
	UpTexture.SetColorModify(Class'InterfaceClassic.UICommonAPI'.static.InstUICommonAPI().GetColor(210, 210, 210, 210));
	return;
}

function StartEncourage()
{
	if(!IsCurrentSlotID())
	{
		return;
	}
	if((isOver || isDown))
	{
		return;
	}
	piece.MoveC(0, 0);
	clickEncourgeTObject._Reset();
	return;
}

function StopEncoruage()
{
	clickEncourgeTObject._Stop();
	piece.MoveC(0, 0);
	return;
}

function bool IsCurrentSlotID()
{
	return (Class'InterfaceClassic.AdenLabWnd'.static._Inst()._GetnCurrentSlot() == _GetSlotID());
}

function bool isCompleted()
{
	return (Class'InterfaceClassic.AdenLabWnd'.static._Inst()._GetnCurrentSlot() > _GetSlotID());
}

function bool IsViewPiece()
{
	return (Class'InterfaceClassic.AdenLabWnd'.static._Inst()._CurrentViewPieceID() == pieceID);
}

function InitTextures()
{
	UpTexture = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".piece.upTexture"));
	highLights = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".piece.highLights"));
	highLights.HideWindow();
	return;
}

function InitTimerObject()
{
	switch(_GetStageType())
	{
		case STAGE_NORMAL:
			clickEncourgeTObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, -1);
			clickEncourgeTObject._DelegateOnTime = DelegateOnTimer;
			clickEncourgeTObject._DelegateOnPlayStart = DelegateOnPlayStart;
			break;
		case STAGE_SPECIAL:
			clickEncourgeTObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, 50);
			clickEncourgeTObject._DelegateOnTime = DelegateOnTimerBoss;
			clickEncourgeTObject._DelegateOnPlayStart = DelegateOnPlayStart;
			clickEncourgeTObject._DelegateOnEnd = DelegateOnPlayEndBoss;
			break;
		default:
			clickEncourgeTObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, -1);
			clickEncourgeTObject._DelegateOnTime = DelegateOnTimer;
			clickEncourgeTObject._DelegateOnPlayStart = DelegateOnPlayStart;
			break;
	}
	return;
}

function DelegateOnPlayStart()
{
	lastAppMilliSeconds = GetAppMilliSeconds();
	return;
}

function DelegateOnTimer(int Count)
{
	piece.MoveC(0, int((0.0000000 - (Sin((float((GetAppMilliSeconds() - lastAppMilliSeconds)) / 300.0000000)) * 10.0000000))));
	return;
}

function DelegateOnTimerBoss(int Count)
{
	local float pastSec;

	pastSec = float((GetAppMilliSeconds() - lastAppMilliSeconds));
	piece.MoveC(0, int((Sin((pastSec / 40.0000000)) * 2.0000000)));
	piece.SetRotationAngle((Sin((pastSec / 40.0000000)) * 1.0000000));
	return;
}

function DelegateOnPlayEndBoss()
{
	piece.SetRotationAngle(0.0000000);
	clickEncourgeTObject._Reset();
	clickEncourgeTObject._Play(2000);
	piece.MoveC(0, 0);
	return;
}

function InitTweensObject()
{
	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	tObject = new Class'InterfaceClassic.L2UITweenObject';
	tObject.Id = pieceID;
	tObject.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tObject.Target = m_hOwnerWnd;
	tObject.Duration = 1000.0000000;
	tObject.ease = OUT_STRONG;
	return;
}

function InitTwinklesTweens()
{
	local int i;
	local WindowHandle effectWnd;

	i = 0;
	while((GetWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".piece.highLights.effect") $ string(i))).m_pTargetWnd != none))
	{
		effectWnd = GetWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".piece.highLights.effect") $ string(i)));
		twinkleObjects.Length = (twinkleObjects.Length + 1);
		twinkleObjects[i] = l2UITweenScript._AddTweenTwinlkle(effectWnd, -1.0000000, 0.5000000, float((Rand(1000) + 2000)), 0, 255, float(Rand(2)), float((Rand(8) + 2)));
		i++;
	}
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	if(("ColliderBtn" != a_WindowHandle.GetWindowName()))
	{
		return;
	}
	isOver = true;
	_SetMouseOver();
	Class'InterfaceClassic.AdenLabWnd'.static._Inst()._SetBtnOverByPieceID(pieceID);
	return;
}

function _SetMouseOver()
{
	if(!isCompleted())
	{
		ShowHeightLights();
	}
	StopEncoruage();
	UpTexture.SetColorModify(Class'InterfaceClassic.UICommonAPI'.static.InstUICommonAPI().GetColor(255, 255, 255, 255));
	return;
}

function _SetMouseOut()
{
	if(IsCurrentSlotID())
	{
		highLights.HideWindow();
		StartEncourage();
	}
	UpTexture.SetColorModify(Class'InterfaceClassic.UICommonAPI'.static.InstUICommonAPI().GetColor(210, 210, 210, 210));
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	if(("ColliderBtn" != a_WindowHandle.GetWindowName()))
	{
		return;
	}
	isOver = false;
	_SetMouseOut();
	Class'InterfaceClassic.AdenLabWnd'.static._Inst()._SetBtnOutByPieceID(pieceID);
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if(("ColliderBtn" != a_WindowHandle.GetWindowName()))
	{
		return;
	}
	isDown = true;
	if((!isCompleted() || (int(_GetStageType()) == 2)))
	{
		UpTexture.SetColorModify(Class'InterfaceClassic.UICommonAPI'.static.InstUICommonAPI().GetColor(160, 160, 160, 255));
	}
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if(("ColliderBtn" != a_WindowHandle.GetWindowName()))
	{
		return;
	}
	isDown = false;
	UpTexture.SetColorModify(Class'InterfaceClassic.UICommonAPI'.static.InstUICommonAPI().GetColor(210, 210, 210, 210));
	HandleOnLButtonUP();
	return;
}

function HandleOnLButtonUP()
{
	if(!isOver)
	{
		StartEncourage();
		return;
	}
	switch(_GetStageType())
	{
		case STAGE_NORMAL:
			if(!isCompleted())
			{
				Class'InterfaceClassic.AdenLabCardCaptorWnd'.static._Inst()._TryShowNormalGame(_GetStageIndex(), int(BossID));
			}
			break;
		case STAGE_SPECIAL:
			Class'InterfaceClassic.AdenLabBossOptionWnd'.static._Inst()._TryShowSpecialGame(_GetStageIndex(), _GetSlotID(), int(BossID));
			break;
		default:
			break;
	}
	return;
}

function _SetNewPiece()
{
	local int oX, oY;

	GetXYToword(oX, oY);
	m_hOwnerWnd.MoveC(oX, oY);
	_Show();
	return;
}

function _SetComplete()
{
	completeIcon.ShowWindow();
	completeIcon.Play();
	completeIcon.SetFocus();
	StopEncoruage();
	ShowHeightLights();
	completeIcon02.ShowWindow();
	completeIcon02.SetFocus();
	_SetDisable();
	return;
}

function ShowHeightLights()
{
	local int i;

	highLights.ShowWindow();
	i = 0;
	while((i < twinkleObjects.Length))
	{
		twinkleObjects[i]._Reset();
		twinkleObjects[i].Target.SetAlpha(0);
		i++;
	}
	return;
}

function _ResetPieceState()
{
	if(isCompleted())
	{
		StopEncoruage();
		ShowHeightLights();
		completeIcon02.ShowWindow();
	}
	else if(IsCurrentSlotID())
	{
		completeIcon.HideWindow();
		completeIcon02.HideWindow();
		if((!isOver && !isDown))
		{
			StartEncourage();
		}
	}
	else
	{
		completeIcon02.HideWindow();
		completeIcon.HideWindow();
		highLights.HideWindow();
	}
	ChkEnableState();
	return;
}

function ChkEnableState()
{
	m_hOwnerWnd.EnableWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ColliderBtn")).ShowWindow();
	if((int(_GetStageType()) != 1))
	{
		return;
	}
	if(IsViewPiece())
	{
		return;
	}
	m_hOwnerWnd.DisableWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ColliderBtn")).HideWindow();
	return;
}

function _SetEnable()
{
	if((IsViewPiece() == false))
	{
		return;
	}
	m_hOwnerWnd.EnableWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ColliderBtn")).ShowWindow();
	return;
}

function _SetDisable()
{
	if((int(_GetStageType()) != 1))
	{
		return;
	}
	m_hOwnerWnd.DisableWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ColliderBtn")).HideWindow();
	return;
}

function _Hide(optional bool bImmediately)
{
	local int locX, locY, oX, oY;

	GetLocalPosition(m_hOwnerWnd, locX, locY);
	clickEncourgeTObject._Stop();
	if(bImmediately)
	{
		m_hOwnerWnd.SetAlpha(0);
		m_hOwnerWnd.HideWindow();
	}
	else
	{
		GetXYToword(oX, oY);
		tObject.MoveX = float((locX - oX));
		tObject.MoveY = float((locY - oY));
		tObject.Alpha = float(-m_hOwnerWnd.GetAlpha());
		tObject._DelegateOnEnd = DelegateOnEndHide;
		tObject._Reset();
	}
	return;
}

function DelegateOnEndHide(L2UITweenObject Me)
{
	m_hOwnerWnd.HideWindow();
	return;
}

function DelegateOnEndClickEncourage(L2UITweenObject Me)
{
	StartEncourage();
	return;
}

function _Show(optional bool bImmediately)
{
	local int locX, locY, GlobalX, GlobalY;

	GetLocalPosition(m_hOwnerWnd, locX, locY);
	if(bImmediately)
	{
		Class'InterfaceClassic.UICommonAPI'.static.InstUICommonAPI().Local2Global(m_hOwnerWnd.GetParentWindowHandle(), StartX, StartY, GlobalX, GlobalY);
		m_hOwnerWnd.MoveTo(GlobalX, GlobalY);
		m_hOwnerWnd.SetAlpha(255);
	}
	else
	{
		tObject.MoveX = float((StartX - locX));
		tObject.MoveY = float((StartY - locY));
		tObject.Alpha = (255.0000000 - float(m_hOwnerWnd.GetAlpha()));
		tObject._Reset();
		tObject._DelegateOnEnd = DelegateOnEndClickEncourage;
	}
	_ResetPieceState();
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	return;
}

function _SetStartPosition()
{
	local int GlobalX, GlobalY;

	Class'InterfaceClassic.UICommonAPI'.static.InstUICommonAPI().Local2Global(m_hOwnerWnd.GetParentWindowHandle(), StartX, StartY, GlobalX, GlobalY);
	m_hOwnerWnd.MoveTo(GlobalX, GlobalY);
	return;
}

function int GetDistance(int x1, int y1, int x2, int y2)
{
	local int gabX, gabY;

	gabX = (x1 - x2);
	gabY = (y1 - y2);
	return int(Sqrt(float(((gabX * gabX) + (gabY * gabY)))));
}

function SetAngleFormZero()
{
	Angle = ((Atan(float(-(StartY - 287)), float((StartX - 400))) * 180.0000000) / 3.1415927);
	return;
}

function GetXYToword(out int oX, out int oY)
{
	local int orginalDist, dist;

	orginalDist = GetDistance(400, 287, StartX, StartY);
	dist = (orginalDist - 100);
	oX = int(((Cos((Angle / (180.0000000 / 3.1415927))) * float(dist)) + 400.0000000));
	oY = int(((-Sin((Angle / (180.0000000 / 3.1415927))) * float(dist)) + 287.0000000));
	return;
}

function GetLocalPosition(WindowHandle W, out int X, out int Y)
{
	local Rect rectWnd, rectWndParent;

	rectWnd = W.GetRect();
	if((W.m_pTargetWnd == none))
	{
		X = rectWnd.nX;
		Y = rectWnd.nY;
		return;
	}
	rectWndParent = W.GetParentWindowHandle().GetRect();
	X = (rectWnd.nX - rectWndParent.nX);
	Y = (rectWnd.nY - rectWndParent.nY);
	return;
}

function SetStageName()
{
	InsertNameTooltip(GetStageNames());
	return;
}

function InsertNameTooltip(array<string> names)
{
	local CustomTooltip t;
	local L2Util util;
	local int i;
	local CardSelectSpecialStage spcialStageData;
	local Color itemScoreColor;

	util = Class'InterfaceClassic.L2Util'.static.Inst();
	util.setCustomTooltip(t);
	util.ToopTipMinWidth(10);
	itemScoreColor.R = 221;
	itemScoreColor.G = 221;
	itemScoreColor.B = 221;
	itemScoreColor.A = 255;
	i = 0;
	while((i < names.Length))
	{
		util.ToopTipInsertText(names[i], true, true);
		i++;
	}
	if((IsAdenServer() && (int(_GetStageType()) == 2)))
	{
		API_GetSpecialStageData(spcialStageData);
		if((spcialStageData.ItemScore > 0))
		{
			util.TooltipInsertItemBlank(4);
			util.TooltipInsertItemLine();
			util.TooltipInsertItemBlank(4);
			util.TooltipInsertTextureDetail("L2UI_NewTex.DetailStatusWnd.ItemLevelIcon", 14, 16, 19, 21, true, false);
			if((levels.Length > 0))
			{
				util.ToopTipInsertColorText(((GetSystemString(14681) @ "+") $ string(spcialStageData.ItemScore)), true, false, itemScoreColor, 2);
			}
			else
			{
				util.ToopTipInsertColorText((((((GetSystemString(14681) @ "+") $ string(spcialStageData.ItemScore)) @ "(") $ GetSystemString(2496)) $ ")"), true, false, util.Gray, 2);
			}
		}
	}
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ColliderBtn")).SetTooltipCustomType(util.getCustomToolTip());
	if((int(_GetStageType()) == 2))
	{
		Class'InterfaceClassic.AdenLabWnd'.static._Inst()._InsertSpecial(pieceID);
	}
	return;
}

function CustomTooltip getUsePotionCustomTooltip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local UICommonAPI apis;

	apis = Class'InterfaceClassic.UICommonAPI'.static.InstUICommonAPI();
	drawListArr[drawListArr.Length] = apis.addDrawItemText(GetSystemString(13008), Class'InterfaceClassic.L2Util'.static.Inst().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = apis.addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = apis.AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = apis.addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = apis.addDrawItemText(MakeFullSystemMsg(GetSystemMessage(5292), string(30)), Class'InterfaceClassic.L2Util'.static.Inst().DRed, "", true, true);
	mCustomTooltip = apis.MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	apis.setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function SetBuyButtonTooltip()
{
	local CustomTooltip t;
	local L2Util util;

	util = Class'InterfaceClassic.L2Util'.static.Inst();
	util.setCustomTooltip(t);
	util.ToopTipMinWidth(10);
	util.ToopTipInsertText(GetSystemString(13713), true, true, COLOR_RED);
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ColliderBtn")).SetTooltipCustomType(util.getCustomToolTip());
	return;
}

function array<string> GetStageNames()
{
	local int i, OptionID;
	local array<string> names;
	local ExOptionData optionData;
	local string optionValueString;
	local CardSelectNormalStage normalStageData;

	switch(_GetStageType())
	{
		case STAGE_NORMAL:
			API_GetNormalStageData(normalStageData);
			OptionID = normalStageData.ExOptionKey.Id;
			API_GetExOptionData(OptionID, 1, optionData);
			names[0] = optionData.Desc;
			return names;
		case STAGE_SPECIAL:
			MakeSpcialOptionData();
			break;
		default:
			break;
	}
	i = 0;
	while((i < spcialOptionDatas.Length))
	{
		names[i] = spcialOptionDatas[i].optionDatas[0].Filter[0].Name;
		i++;
	}
	i = 0;
	while((i < names.Length))
	{
		if((levels[i] == 0))
		{
			i++;
			continue;
		}
		API_GetExOptionData(spcialOptionDatas[i].OptionID, levels[i], optionData);
		optionValueString = GetOptionTooltipString(optionData.Filter[0]);
		if((optionValueString != ""))
		{
			names[i] = optionValueString;
		}
		i++;
	}
	return names;
}

function MakeSpcialOptionData()
{
	local int i, EffectSlot, OptionID, Level, Index;
	local ExOptionData optionData;
	local int Len;
	local CardSelectSpecialStage spcialStageData;

	API_GetSpecialStageData(spcialStageData);
	Len = spcialStageData.EffectArray.Length;
	spcialOptionDatas.Length = 0;
	i = 0;
	while((i < Len))
	{
		OptionID = spcialStageData.EffectArray[i].ExOptionKey.Id;
		Level = spcialStageData.EffectArray[i].ExOptionKey.Level;
		EffectSlot = spcialStageData.EffectArray[i].EffectSlot;
		Index = (Level - 1);
		spcialOptionDatas.Length = Max((EffectSlot + 1), spcialOptionDatas.Length);
		API_GetExOptionData(OptionID, Level, optionData);
		spcialOptionDatas[EffectSlot].OptionID = OptionID;
		spcialOptionDatas[EffectSlot].EffectSlot = EffectSlot;
		spcialOptionDatas[EffectSlot].optionDatas[Index] = optionData;
		i++;
	}
	return;
}

function string GetOptionTooltipString(ExOptionFilter optionFilter)
{
	return Class'InterfaceClassic.AdenLabBossOptionWnd'.static._Inst()._GetOptionTooltipString(optionFilter);
}

function SetOptionIds()
{
	local CardSelectNormalStage normalStageData;

	switch(_GetStageType())
	{
		case STAGE_NORMAL:
			API_GetNormalStageData(normalStageData);
			optionIds.Length = 1;
			optionIds[0] = normalStageData.ExOptionKey.Id;
			MaxLevel = 1;
			levels[0] = 1;
			break;
		default:
			Class'InterfaceClassic.AdenLabBossOptionWnd'.static._Inst()._GetOptionIDs(_GetStageIndex(), optionNum, MaxLevel, optionIds);
			break;
	}
	return;
}

function API_GetNormalStageData(out CardSelectNormalStage Data)
{
	Class'NWindow.UIDataManager'.static.GetNormalStageData(_GetStageIndex(), Data);
	return;
}

function API_GetSpecialStageData(out CardSelectSpecialStage Data)
{
	Class'NWindow.UIDataManager'.static.GetSpecialStageData(_GetStageIndex(), Data);
	return;
}

function API_GetExOptionData(int OptionID, int lv, out ExOptionData Data)
{
	local ExOptionData nullData;

	Data = nullData;
	Class'NWindow.UIDataManager'.static.GetExOptionData(OptionID, byte(lv), Data);
	return;
}
