class HennaInfoPremiumWnd extends UICommonAPI;

const HENNA_EQUIP = 1;
const HENNA_UNEQUIP = 2;

var int m_iState;
var int m_iHennaID;
var WindowHandle HennaInfoWndEquip;
var WindowHandle HennaInfoWndUnEquip;
var TextBoxHandle HennaJobText;
var ButtonHandle btnOk;
var UIControlNeedItem needItemScript;
var array<TextureHandle> EffectSkillSlotDisables;
var int nSubClass;
var bool bEnoughItemnum;

event OnRegisterEvent()
{
	RegisterEvent(1661);
	RegisterEvent(1691);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtSTRString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3366), 154));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtDEXString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3368), 154));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtCONString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3370), 154));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtINTString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3367), 154));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtWITString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3369), 154));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtMENString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3371), 154));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtLUCString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3372), 154));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtCHAString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3373), 154));
	HennaInfoWndEquip = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip"));
	HennaInfoWndUnEquip = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip"));
	InitNeetItemScript();
	return;
}

event OnClickButton(string strID)
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	switch(strID)
	{
		case "btnPrev":
			if((m_iState == 1))
			{
				RequestHennaItemList();
			}
			else if((m_iState == 2))
			{
				RequestHennaUnEquipList();
			}
			GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).SetAnchor("HennaListWndLive", "TopLeft", "TopLeft", 0, 0);
			break;
		case "btnOK":
			if((m_iState == 1))
			{
				RequestHennaEquip(m_iHennaID);
			}
			else if((m_iState == 2))
			{
				RequestHennaUnEquip(m_iHennaID);
			}
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	Debug((("OnEvent ! " @ string(Event_ID)) @ param));
	switch(Event_ID)
	{
		case 1661:
			SetFormEquip();
			ShowHennaInfoPremiumWnd(param);
			break;
		case 1691:
			SetFormUnEQUIP();
			ShowHennaInfoPremiumWnd(param);
			break;
		default:
			break;
	}
	return;
}

function SetFormEquip()
{
	local UserInfo Info;

	m_iState = 1;
	Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText(m_hOwnerWnd.m_WindowNameWithFullPath, GetSystemString(651));
	HennaInfoWndEquip.ShowWindow();
	HennaInfoWndUnEquip.HideWindow();
	GetPlayerInfo(Info);
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.HennaJobText")).SetText(GetClassType(Info.nSubClass));
	return;
}

function SetFormUnEQUIP()
{
	m_iState = 2;
	Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText(m_hOwnerWnd.m_WindowNameWithFullPath, GetSystemString(652));
	HennaInfoWndEquip.HideWindow();
	HennaInfoWndUnEquip.ShowWindow();
	return;
}

function ShowHennaInfoPremiumWnd(string param)
{
	local INT64 iAdena;
	local string strDyeName, strDyeIconName;
	local int iHennaID, iClassID;
	local INT64 iFee;
	local string strTattooName, strTattooAddName, strTattooIconName;
	local int iINTnow, iINTchange, iSTRnow, iSTRchange, iCONnow, iCONchange, iMENnow, iMENchange, iDEXnow, iDEXchange, iWITnow, iWITchange, iLUCnow, iLUCchange, iCHAnow, iCHAchange;
	local string Description;
	local INT64 needCount, iNum;

	ParseINT64(param, "Adena", iAdena);
	ParseString(param, "DyeIconName", strDyeIconName);
	ParseString(param, "DyeName", strDyeName);
	ParseInt(param, "HennaID", iHennaID);
	ParseInt(param, "ClassID", iClassID);
	ParseINT64(param, "NumOfItem", iNum);
	ParseINT64(param, "Fee", iFee);
	ParseString(param, "TattooIconName", strTattooIconName);
	ParseString(param, "TattooName", strTattooName);
	ParseString(param, "TattooAddName", strTattooAddName);
	ParseInt(param, "INTnow", iINTnow);
	ParseInt(param, "INTchange", iINTchange);
	ParseInt(param, "STRnow", iSTRnow);
	ParseInt(param, "STRchange", iSTRchange);
	ParseInt(param, "CONnow", iCONnow);
	ParseInt(param, "CONchange", iCONchange);
	ParseInt(param, "MENnow", iMENnow);
	ParseInt(param, "MENchange", iMENchange);
	ParseInt(param, "DEXnow", iDEXnow);
	ParseInt(param, "DEXchange", iDEXchange);
	ParseInt(param, "WITnow", iWITnow);
	ParseInt(param, "WITchange", iWITchange);
	ParseInt(param, "LUCnow", iLUCnow);
	ParseInt(param, "LUCchange", iLUCchange);
	ParseInt(param, "CHAnow", iCHAnow);
	ParseInt(param, "CHAchange", iCHAchange);
	ParseString(param, "Description", Description);
	m_iHennaID = iHennaID;
	if((m_iState == 1))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtDyeInfo"), GetSystemString(638));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.textureDyeIconName"), strDyeIconName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtDyeName"), strDyeName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtNeedItemString"), (GetSystemString(2380) $ " : "));
		ParseINT64(param, "NeedCount", needCount);
		bEnoughItemnum = (iNum >= needCount);
		if(!bEnoughItemnum)
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtCurrentItemNum"), GetColor(255, 0, 0, 255));
		}
		else
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtCurrentItemNum"), GetColor(0, 176, 255, 255));
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtCurrentItemNum"), string(iNum));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtNeedItemNum"), ("/" $ string(needCount)));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtTattooInfo"), GetSystemString(639));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.textureTattooIconName"), strTattooIconName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtTattooName"), strTattooName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.txtTattooAddName"), strTattooAddName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndEquip.HennaDescTextBox"), Description);
	}
	else if((m_iState == 2))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtTattooInfoUnEquip"), GetSystemString(639));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.textureTattooIconNameUnEquip"), strTattooIconName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtTattooNameUnEquip"), strTattooName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtTattooAddNameUnEquip"), strTattooAddName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtDyeInfoUnEquip"), GetSystemString(638));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.textureDyeIconNameUnEquip"), strDyeIconName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtDyeNameUnEquip"), strDyeName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtNeedItemString"), "");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtCurrentItemNum"), "");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtNeedItemNum"), "");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtAdenaStringUnEquip"), GetSystemString(469));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.txtAdenaStringUnEquip"), GetColor(255, 255, 0, 255));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HennaInfoWndUnEquip.HennaDescTextBox"), Description);
	}
	updateNeedItem(iFee);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtSTRBefore"), iSTRnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtSTRAfter"), iSTRchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtDEXBefore"), iDEXnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtDEXAfter"), iDEXchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtCONBefore"), iCONnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtCONAfter"), iCONchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtINTBefore"), iINTnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtINTAfter"), iINTchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtWITBefore"), iWITnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtWITAfter"), iWITchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtMENBefore"), iMENnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtMENAfter"), iMENchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtLUCBefore"), iLUCnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtLUCAfter"), iLUCchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtCHABefore"), iCHAnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtCHAAfter"), iCHAchange);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaListWndLive");
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_hOwnerWnd.m_WindowNameWithFullPath);
	GetWindowHandle("HennaListWndLive").SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", 0, 0);
	return;
}

function updateNeedItem(INT64 needNum)
{
	local WindowHandle needItemWnd;

	needItemScript.SetNumNeed(needNum);
	Debug((((("UpdateNeedItem" @ string(needNum)) @ string(needItemScript.canBuy())) @ string(needItemWnd.IsShowWindow())) @ needItemWnd.GetWindowName()));
	return;
}

function InitNeetItemScript()
{
	local WindowHandle needItemWnd;

	needItemWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem"));
	needItemWnd.SetScript("UIControlNeedItem");
	needItemScript = UIControlNeedItem(needItemWnd.GetScript());
	needItemScript.Init((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItem"));
	needItemScript.setId(GetItemID(57));
	needItemScript.DelegateItemUpdate = DelegateNeedItemOnUpdateItem;
	return;
}

function DelegateNeedItemOnUpdateItem(UIControlNeedItem Script)
{
	if((Script.canBuy() && bEnoughItemnum))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnOK")).EnableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnOK")).DisableWindow();
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).HideWindow();
	return;
}
