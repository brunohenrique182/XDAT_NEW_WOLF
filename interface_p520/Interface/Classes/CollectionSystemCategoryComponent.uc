class CollectionSystemCategoryComponent extends UICommonAPI;

const STATE_SELECTED = 'stateSelected';
const STATE_NORMAL = 'stateNormal';

enum DOTTYPE
{
	non,                            // 0
	canregist,                      // 1
	notEnough,                      // 2
	empty,                          // 3
	Over,                           // 4
	Max                             // 5
};

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var ButtonHandle ItemBTN;
var TextBoxHandle buttonName;
var StatusBarHandle Progress;
var CollectionSystem collectionSystemScript;
var array<CollectionSystemStandComponent> collectionSystemStandComponentScripts;
var int Index;
var bool bOver;
var bool bDown;
var bool bSelected;
var TextureHandle Icon_Tex;
var TextureHandle TooltipTexture;
var DOTTYPE currentDotType;
var TextureHandle ItemInsufficient_Tex;
var TextureHandle ItemRegistration_Tex;
var TextureHandle ItemOverEnchant_Tex;
var Color selectedEmptyColor;
//var delegate<DelegateOnButtonClick> __DelegateOnButtonClick__Delegate;
//var delegate<DelegateOnOver> __DelegateOnOver__Delegate;

delegate DelegateOnButtonClick(string Name)
{
	return;
}

delegate DelegateOnOver()
{
	return;
}

function Initialize()
{
	util = L2Util(GetScript("L2Util"));
	collectionSystemScript = CollectionSystem(GetScript("collectionSystem"));
	buttonName = GetTextBoxHandle((m_Windowname $ ".buttonName_Txt"));
	ItemBTN = GetButtonHandle((m_Windowname $ ".Item_Btn"));
	Progress = GetStatusBarHandle((m_Windowname $ ".progress"));
	Icon_Tex = GetTextureHandle((m_Windowname $ ".Icon_Tex"));
	TooltipTexture = GetTextureHandle((m_Windowname $ ".TooltipTexture"));
	ItemRegistration_Tex = GetTextureHandle((m_Windowname $ ".ItemRegistration_Tex"));
	ItemInsufficient_Tex = GetTextureHandle((m_Windowname $ ".ItemInsufficient_Tex"));
	ItemOverEnchant_Tex = GetTextureHandle((m_Windowname $ ".ItemOverEnchant_Tex"));
	TooltipTexture.SetAlpha(0);
	selectedEmptyColor = GetColor(115, 85, 0, 255);
	return;
}

function Init(string WindowName, string _buttonName, int Category)
{
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	Index = (Category - 1);
	Initialize();
	SetStandComponetScript(Category);
	Progress.SetDrawPoint(false);
	buttonName.SetText(_buttonName);
	return;
}

function SetStandComponetScript(int Category)
{
	local int i;

	if((Category == collectionSystemScript.favoriteCategory))
	{
		collectionSystemStandComponentScripts = collectionSystemScript.collectionSystemStandComponentFavoriteScript;
		return;
	}
	i = 0;
	while((i < collectionSystemScript.collectionSystemStandComponentScripts.Length))
	{
		if((collectionSystemScript.collectionSystemStandComponentScripts[i].cMainData.Category == Category))
		{
			collectionSystemStandComponentScripts[collectionSystemStandComponentScripts.Length] = collectionSystemScript.collectionSystemStandComponentScripts[i];
		}
		i++;
	}
	return;
}

event OnClickButton(string btnName)
{
	if(bSelected)
	{
		return;
	}
	switch(btnName)
	{
		case "Item_Btn":
			bDown = false;
			collectionSystemScript.SetCurrentCategory((Index + 1));
			break;
		default:
			break;
	}
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if(bSelected)
	{
		return;
	}
	switch(a_WindowHandle)
	{
		case ItemBTN:
			bDown = true;
			Icon_Tex.SetTexture((("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index)) $ "_down"));
			break;
		default:
			break;
	}
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	if(bSelected)
	{
		return;
	}
	switch(a_WindowHandle)
	{
		case ItemBTN:
			bDown = false;
			HandleBtnOut();
			break;
		default:
			break;
	}
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	if(bSelected)
	{
		return;
	}
	switch(a_WindowHandle)
	{
		case ItemBTN:
			HandleBtnOver();
			break;
		default:
			break;
	}
	return;
}

function SetSelecte()
{
	bSelected = true;
	bOver = false;
	bDown = false;
	Icon_Tex.SetTexture((("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index)) $ "_selected"));
	ItemBTN.SetEnable(false);
	SetFontColor();
	HandleBtnOuts();
	return;
}

function HandleBtnOuts()
{
	local int i;

	i = 0;
	while((i < collectionSystemStandComponentScripts.Length))
	{
		collectionSystemStandComponentScripts[i].HandleBtnOut();
		i++;
	}
	return;
}

function SetDeselecte()
{
	bSelected = false;
	ItemBTN.SetEnable(true);
	Icon_Tex.SetTexture(("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index)));
	SetFontColor();
	return;
}

function HandleBtnOver()
{
	if(collectionSystemScript.Me.IsShowWindow())
	{
		bOver = true;
		Icon_Tex.SetTexture((("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index)) $ "_over"));
		HandleBtnOvers();
	}
	return;
}

function HandleBtnOvers()
{
	local int i;

	i = 0;
	while((i < collectionSystemStandComponentScripts.Length))
	{
		collectionSystemStandComponentScripts[i].HandleBtnOver();
		i++;
	}
	return;
}

function HandleBtnOut()
{
	if(collectionSystemScript.Me.IsShowWindow())
	{
		bOver = false;
		Icon_Tex.SetTexture(("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index)));
		HandleBtnOuts();
	}
	return;
}

function SetBtnOver()
{
	if(((collectionSystemScript.Me.IsShowWindow() && !bOver) && !bSelected))
	{
		ItemBTN.SetEnable(false);
		Icon_Tex.SetTexture((("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index)) $ "_over"));
	}
	return;
}

function SetBtnOut()
{
	if((collectionSystemScript.Me.IsShowWindow() && !bSelected))
	{
		ItemBTN.SetEnable(true);
		Icon_Tex.SetTexture(("L2UI_EPIC.CollectionSystemWnd.Category_Icon" $ collectionSystemScript.GetStringKeyByIndex(Index)));
	}
	return;
}

function SetPoint(int Min, int Max)
{
	local string ToolTipString;

	Progress.SetPoint(INT64(Min), INT64(Max));
	ToolTipString = ((string(int(((float(Min) / float(Max)) * 100.0000000))) $ "%") @ GetSystemString(898));
	ItemBTN.SetTooltipCustomType(MakeTooltipSimpleText(ToolTipString));
	TooltipTexture.SetTooltipCustomType(MakeTooltipSimpleText(ToolTipString));
	return;
}

function HideDot()
{
	currentDotType = non;
	Icon_Tex.SetColorModify(GetColor(255, 255, 255, 255));
	ItemRegistration_Tex.HideWindow();
	ItemInsufficient_Tex.HideWindow();
	ItemOverEnchant_Tex.HideWindow();
	SetFontColor();
	return;
}

function ShowDot(int Type)
{
	currentDotType = DOTTYPE(Type);
	switch(currentDotType)
	{
		case non:
			HideDot();
			break;
		case canregist:
			Icon_Tex.SetColorModify(GetColor(255, 255, 255, 255));
			ItemRegistration_Tex.ShowWindow();
			ItemInsufficient_Tex.HideWindow();
			ItemOverEnchant_Tex.HideWindow();
			break;
		case notEnough:
			Icon_Tex.SetColorModify(GetColor(255, 255, 255, 255));
			ItemRegistration_Tex.HideWindow();
			ItemInsufficient_Tex.ShowWindow();
			ItemOverEnchant_Tex.HideWindow();
			break;
		case empty:
			Icon_Tex.SetColorModify(GetColor(80, 80, 80, 255));
			ItemRegistration_Tex.HideWindow();
			ItemInsufficient_Tex.HideWindow();
			ItemOverEnchant_Tex.HideWindow();
			break;
		case Over:
			Icon_Tex.SetColorModify(GetColor(255, 255, 255, 255));
			ItemRegistration_Tex.HideWindow();
			ItemInsufficient_Tex.HideWindow();
			ItemOverEnchant_Tex.ShowWindow();
			break;
		default:
			break;
	}
	SetFontColor();
	return;
}

function SetFontColor()
{
	if((int(currentDotType) == 3))
	{
		if(bSelected)
		{
			buttonName.SetTextColor(selectedEmptyColor);
		}
		else
		{
			buttonName.SetTextColor(getInstanceL2Util().DarkGray);
		}
	}
	else if(bSelected)
	{
		buttonName.SetTextColor(getInstanceL2Util().Yellow);
	}
	else
	{
		buttonName.SetTextColor(getInstanceL2Util().White);
	}
	return;
}
