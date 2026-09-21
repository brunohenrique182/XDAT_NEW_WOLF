class UIPanelTest extends UICommonAPI;

struct RenderData
{
	var bool bActive;
	var float Angle;
};

var UIControlTilelist scrollTester;
var UIControlTilelist scrollTesterV;
var L2UITweenRotateObject rotateTObject;
var array<RenderData> renderDatasV;

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnHide()
{
	scrollTester._SetSelect(-1);
	return;
}

event OnShow()
{
	scrollTester._SetSelect(0);
	return;
}

function Initialize()
{
	scrollTester = Class'Interface.UIControlTilelist'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd")), 3, 2);
	scrollTester.DelegateOnItemRenderer = HandleDelegateOnItemRenderer;
	scrollTester.DelegateOnClick = HandleDelegateOnClick;
	scrollTester._SetUsePage(true);
	scrollTester._SetTileListItemNumTotal(100);
	scrollTesterV = Class'Interface.UIControlTilelist'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWndV")), 2, 3, true);
	scrollTesterV.DelegateOnItemRenderer = HandleDelegateOnItemRenderer;
	scrollTesterV.DelegateOnClick = HandleDelegateOnClickV;
	scrollTesterV._SetTileListItemNumTotal(100);
	renderDatasV.Length = 100;
	return;
}

function HandleDelegateOnItemRenderer(string itemRendererID, int rendererIndex, int Position)
{
	local int diceIndex;

	diceIndex = int((float(Position) % float(scrollTester._GetItemRendererNum())));
	if((Position >= scrollTester._GetItemNumTotal()))
	{
		GetTextureHandle((itemRendererID $ ".dice")).HideWindow();
		GetTextBoxHandle((itemRendererID $ ".scrollText")).SetText((("IDX:Disabled!" @ "POS:") $ string(Position)));
	}
	else
	{
		GetTextureHandle((itemRendererID $ ".dice")).ShowWindow();
		GetTextureHandle((itemRendererID $ ".dice")).SetTexture(("L2UI_CH3.Br_Score" $ string((diceIndex + 1))));
		GetTextBoxHandle((itemRendererID $ ".scrollText")).SetText(((("IDX:" $ string(rendererIndex)) @ "POS:") $ string(Position)));
	}
	return;
}

function PlayAnimTextureHandle(string BTNID, int rendererIndex, int itemIndex)
{
	local L2UITween l2UITweenScript;

	l2UITweenScript = Class'Interface.L2UITween'.static.Inst();
	rotateTObject = Class'Interface.L2UITween'.static.Inst()._AddTweenRotate(GetAnimTextureHandle((scrollTester._GetRendererPath(rendererIndex) $ ".circleEffect")), 9, 370.0000000, 2000.0000000);
	rotateTObject._Play();
	return;
}

function PlayAnimTextureHandleV(string BTNID, int rendererIndex, int itemIndex)
{
	local L2UITween l2UITweenScript;
	local L2UITween.TweenObject tweenObj;

	l2UITweenScript = Class'Interface.L2UITween'.static.Inst();
	rotateTObject = Class'Interface.L2UITween'.static.Inst()._AddTweenRotate(GetAnimTextureHandle((scrollTesterV._GetRendererPath(rendererIndex) $ ".circleEffect")), 2, -490.0000000, 4000.0000000, 0.0000000, true);
	tweenObj.Target = GetAnimTextureHandle((scrollTesterV._GetRendererPath(rendererIndex) $ ".circleEffect"));
	tweenObj.ease = OUT_BOUNCE;
	tweenObj.Duration = 4000.0000000;
	tweenObj.Alpha = 100.0000000;
	tweenObj.MoveX = -50.0000000;
	tweenObj.MoveY = -50.0000000;
	tweenObj.SizeX = 100.0000000;
	tweenObj.SizeY = 100.0000000;
	Class'Interface.L2UITween'.static.Inst().AddTweenObject(tweenObj);
	rotateTObject._Play();
	return;
}

function HandleDelegateOnClick(string BTNID, int rendererIndex, int itemIndex)
{
	PlayAnimTextureHandle(BTNID, rendererIndex, itemIndex);
	return;
}

function HandleDelegateOnClickV(string BTNID, int rendererIndex, int itemIndex)
{
	PlayAnimTextureHandleV(BTNID, rendererIndex, itemIndex);
	return;
}

event OnCompleteEditBox(string strID)
{
	scrollTester._SetTileListItemNumTotal(int(GetEditBoxHandle(strID).GetString()));
	scrollTesterV._SetTileListItemNumTotal(int(GetEditBoxHandle(strID).GetString()));
	return;
}

event OnClickButton(string strID)
{
	local int randNum;

	switch(strID)
	{
		case "ButtonUpdate":
			break;
		case "test0Button":
			randNum = Rand(int(GetEditBoxHandle("nomOfItem").GetString()));
			Debug(("click 0 :" @ string(randNum)));
			scrollTester._SetSelect(randNum, true);
			break;
		case "test1Button":
			randNum = Rand(int(GetEditBoxHandle("nomOfItem").GetString()));
			Debug(("click 1 :" @ string(randNum)));
			scrollTesterV._SetSelect(randNum, true);
			break;
		case "test2Button":
			break;
		case "ButtonResetParam":
			break;
		default:
			break;
	}
	Debug(("OnClickButton" @ strID));
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}
