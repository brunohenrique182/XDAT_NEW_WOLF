class UIPanelTestScroll extends UICommonAPI;

struct RenderData
{
	var bool bActive;
	var float Angle;
};

var UIControlTilelistScroll scrollTesterV;
var UIControlTilelistScroll scrollTesterV2;
var UIControlTilelistScroll scrollTester;
var L2UITweenRotateObject rotateTObject;
var array<RenderData> renderDatasV;
var array<RenderData> renderDatas;

function Initialize()
{
	scrollTesterV = Class'InterfaceClassic.UIControlTilelistScroll'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWndV")), 2, 5, true, "renderer");
	scrollTesterV.DelegateOnRenderer = HandleDelegateOnRenderer;
	scrollTesterV.DelegateOnClick = HandleDelegateOnClickV;
	scrollTesterV._SetTileListLength(100);
	scrollTesterV2 = Class'InterfaceClassic.UIControlTilelistScroll'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWndV2")), 1, 4, true, "renderer");
	scrollTesterV2.DelegateOnRenderer = HandleDelegateOnRenderer2;
	scrollTesterV2.DelegateOnClick = HandleDelegateOnClickV;
	scrollTesterV2.DelegateOnSort = HandleDelegateOnSort;
	scrollTesterV2._SetTileListLength(100);
	renderDatasV.Length = 100;
	scrollTester = Class'InterfaceClassic.UIControlTilelistScroll'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd")), 5, 2, false, "renderer");
	scrollTester.DelegateOnRenderer = HandleDelegateOnRenderer;
	scrollTester.DelegateOnClick = HandleDelegateOnClickV;
	scrollTester._SetTileListLength(100);
	renderDatas.Length = 100;
	return;
}

function HandleDelegateOnSort(int Index, int SortOrder)
{
	Debug((("HandleDelegateOnSort" @ string(Index)) @ string(SortOrder)));
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnHide()
{
	scrollTesterV2._SetSelect(-1);
	scrollTesterV._SetSelect(-1);
	scrollTester._SetSelect(-1);
	return;
}

event OnShow()
{
	scrollTesterV2._Refresh();
	scrollTesterV2._SetSelect(3);
	scrollTesterV._Refresh();
	scrollTesterV._SetSelect(3);
	scrollTester._Refresh();
	scrollTester._SetSelect(3);
	return;
}

event OnCompleteEditBox(string strID)
{
	scrollTesterV2._SetTileListLength(int(GetEditBoxHandle(strID).GetString()));
	scrollTesterV2._Refresh();
	scrollTesterV._SetTileListLength(int(GetEditBoxHandle(strID).GetString()));
	scrollTesterV._Refresh();
	scrollTester._SetTileListLength(int(GetEditBoxHandle(strID).GetString()));
	scrollTester._Refresh();
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
			scrollTesterV2._SetSelect(randNum, true);
			scrollTesterV._SetSelect(randNum, true);
			scrollTester._SetSelect(randNum, true);
			break;
		case "test1Button":
			randNum = Rand(int(GetEditBoxHandle("nomOfItem").GetString()));
			Debug(("click 1 :" @ string(randNum)));
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

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}

function HandleDelegateOnRenderer2(string rendererName, int rendererID, int Index)
{
	local int diceIndex;
	local ItemInfo iInfo;

	diceIndex = int((float(Index) % 9.0000000));
	if((scrollTesterV2.GetTestSortOrder() == 1))
	{
		Index = ((scrollTesterV2._GetLength() - Index) - 1);
	}
	iInfo = GetItemInfoByClassID(Index);
	Debug(((("HandleDelegateOnRenderer2" @ string(Index)) @ string(scrollTesterV2.GetTestSortOrder())) @ string(scrollTesterV2._GetLength())));
	if((Index >= scrollTesterV2._GetLength()))
	{
		GetTextureHandle((rendererName $ ".dice")).HideWindow();
		GetTextBoxHandle((rendererName $ ".scrollText")).SetText((("IDX:Disabled!" @ "POS:") $ string(Index)));
		GetTextureHandle((rendererName $ ".test")).ClearTooltip();
		GetItemWindowHandle((rendererName $ ".Item")).Clear();
	}
	else
	{
		GetTextureHandle((rendererName $ ".test")).SetTooltipCustomType(MakeTooltipSimpleText(("버튼 심플" $ rendererName)));  // EN?: Button Simple
		GetTextureHandle((rendererName $ ".dice")).ShowWindow();
		GetTextureHandle((rendererName $ ".dice")).SetTexture(("L2UI_CH3.Br_Score" $ string((diceIndex + 1))));
		GetTextBoxHandle((rendererName $ ".scrollText")).SetText(((("IDX:" $ string(rendererID)) @ "POS:") $ string(Index)));
		GetItemWindowHandle((rendererName $ ".Item")).Clear();
		GetItemWindowHandle((rendererName $ ".Item")).AddItem(iInfo);
		GetTextBoxHandle((rendererName $ ".text0")).SetText(iInfo.Name);
		GetTextBoxHandle((rendererName $ ".text1")).SetText(MakeCostString(string((Index * 1000))));
		GetTextBoxHandle((rendererName $ ".text2")).SetText(("x" $ MakeCostString(string((Index * 1000)))));
	}
	return;
}

function HandleDelegateOnRenderer(string rendererName, int rendererID, int Index)
{
	local int diceIndex;

	diceIndex = int((float(Index) % 9.0000000));
	if((Index >= scrollTesterV._GetLength()))
	{
		GetTextureHandle((rendererName $ ".dice")).HideWindow();
		GetTextBoxHandle((rendererName $ ".scrollText")).SetText((("IDX:Disabled!" @ "POS:") $ string(Index)));
		GetTextureHandle((rendererName $ ".test")).ClearTooltip();
	}
	else
	{
		GetTextureHandle((rendererName $ ".test")).SetTooltipCustomType(MakeTooltipSimpleText(("버튼 심플" $ rendererName)));  // EN?: Button Simple
		GetTextureHandle((rendererName $ ".dice")).ShowWindow();
		GetTextureHandle((rendererName $ ".dice")).SetTexture(("L2UI_CH3.Br_Score" $ string((diceIndex + 1))));
		GetTextBoxHandle((rendererName $ ".scrollText")).SetText(((("IDX:" $ string(rendererID)) @ "POS:") $ string(Index)));
	}
	return;
}

function PlayAnimTextureHandle(string BTNID, int rendererIndex, int itemIndex)
{
	local L2UITween l2UITweenScript;

	l2UITweenScript = Class'InterfaceClassic.L2UITween'.static.Inst();
	rotateTObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenRotate(GetAnimTextureHandle((scrollTesterV._GetRendererPath(rendererIndex) $ ".circleEffect")), 9, 370.0000000, 2000.0000000);
	rotateTObject._Play();
	return;
}

function PlayAnimTextureHandleV(string BTNID, int rendererIndex, int itemIndex)
{
	return;
}

function HandleDelegateOnClickV(string BTNID, int rendererIndex, int itemIndex)
{
	PlayAnimTextureHandleV(BTNID, rendererIndex, itemIndex);
	return;
}
