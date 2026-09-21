class HennaInfoWndLive extends UICommonAPI;

const HENNA_EQUIP = 1;
const HENNA_UNEQUIP = 2;

var int m_iState;
var int m_iHennaID;
var INT64 needCount;
var bool bEnoughItemnum;
var string m_Windowname;
var WindowHandle HennaInfoWndEquip;
var WindowHandle HennaInfoWndUnEquip;
var ItemWindowHandle HennaSlot1;
var ItemWindowHandle HennaSlot2;
var ItemWindowHandle HennaSlot3;
var ItemWindowHandle HennaSkillSlot1;
var ItemWindowHandle HennaSkillSlot2;
var ItemWindowHandle HennaSkillSlot3;
var TextureHandle HennaArrow1;
var TextureHandle HennaArrow2;
var TextureHandle HennaArrow3;
var TextureHandle HennaSkillSelelct1;
var TextureHandle HennaSkillSelelct2;
var TextureHandle HennaSkillSelelct3;
var array<TextureHandle> EffectSkillSlotDisables;
var int nSubClass;
var UIControlNeedItem needItemScript;

event OnRegisterEvent()
{
	RegisterEvent(1660);
	RegisterEvent(1690);
	RegisterEvent(8000);
	RegisterEvent(180);
	return;
}

event OnLoad()
{
	local string EngraveTxt;

	SetClosingOnESC();
	OnRegisterEvent();
	GetTextBoxHandle((m_Windowname $ ".HennaInfoWndUnEquip.txtSTRString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3366), 154));
	GetTextBoxHandle((m_Windowname $ ".HennaInfoWndUnEquip.txtDEXString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3368), 154));
	GetTextBoxHandle((m_Windowname $ ".HennaInfoWndUnEquip.txtCONString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3370), 154));
	GetTextBoxHandle((m_Windowname $ ".HennaInfoWndUnEquip.txtINTString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3367), 154));
	GetTextBoxHandle((m_Windowname $ ".HennaInfoWndUnEquip.txtWITString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3369), 154));
	GetTextBoxHandle((m_Windowname $ ".HennaInfoWndUnEquip.txtMENString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3371), 154));
	GetTextBoxHandle((m_Windowname $ ".HennaInfoWndUnEquip.txtLUCString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3372), 154));
	GetTextBoxHandle((m_Windowname $ ".HennaInfoWndUnEquip.txtCHAString")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3373), 154));
	HennaInfoWndEquip = GetWindowHandle((m_Windowname $ ".HennaInfoWndEquip"));
	HennaInfoWndUnEquip = GetWindowHandle((m_Windowname $ ".HennaInfoWndUnEquip"));
	EffectSkillSlotDisables.Length = 3;
	EffectSkillSlotDisables[0] = GetTextureHandle((m_Windowname $ ".HennaInfoWndEquip.DefendSkillSlotDisable"));
	EffectSkillSlotDisables[1] = GetTextureHandle((m_Windowname $ ".HennaInfoWndEquip.MagicDefendSkillSlotDisable"));
	EffectSkillSlotDisables[2] = GetTextureHandle((m_Windowname $ ".HennaInfoWndEquip.AttackSkillSlotDisable"));
	EffectSkillSlotDisables[0].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(5278)));
	EffectSkillSlotDisables[1].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(5278)));
	EffectSkillSlotDisables[2].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(5278)));
	InitNeetItemScript();
	GetTextBoxHandle((m_Windowname $ ".HennaInfoWndEquip.EngraveText")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(5282)));
	EngraveTxt = GetSystemMessage(5282);
	Class'InterfaceClassic.L2Util'.static.GetEllipsisString(EngraveTxt, 350);
	GetTextBoxHandle((m_Windowname $ ".HennaInfoWndEquip.EngraveText")).SetText(EngraveTxt);
	return;
}

event OnClickButton(string strID)
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_Windowname);
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
			GetWindowHandle(m_Windowname).SetAnchor("HennaListWndLive", "TopLeft", "TopLeft", 0, 0);
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

event OnShow()
{
	if((m_iState == 1))
	{
		SetFormEquip();
	}
	else if((m_iState == 2))
	{
		SetFormUnEQUIP();
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		return;
	}
	switch(Event_ID)
	{
		case 1660:
			m_iState = 1;
			ShowHennaInfoWnd(param);
			break;
		case 1690:
			m_iState = 2;
			ShowHennaInfoWnd(param);
			break;
		case 8000:
			if(getInstanceUIData().GetIsClassicServer())
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".txtLUCString"));
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".txtLUCBefore"));
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".txtLUCArrow"));
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".txtLUCAfter"));
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".txtCHAString"));
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".txtCHABefore"));
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".txtCHAArrow"));
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow((m_Windowname $ ".txtCHAAfter"));
			}
			else
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".txtLUCString"));
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".txtLUCBefore"));
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".txtLUCArrow"));
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".txtLUCAfter"));
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".txtCHAString"));
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".txtCHABefore"));
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".txtCHAArrow"));
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((m_Windowname $ ".txtCHAAfter"));
			}
			break;
		case 180:
			SetSkills();
			break;
		default:
			break;
	}
	return;
}

function SetSkills()
{
	local UserInfo Info;

	if(!IsShowWindow(m_Windowname))
	{
		return;
	}
	GetPlayerInfo(Info);
	if((nSubClass == Info.nSubClass))
	{
		return;
	}
	else
	{
		nSubClass = Info.nSubClass;
	}
	return;
}

function SetFormEquip()
{
	local UserInfo Info;

	setWindowTitleByString(GetSystemString(651));
	HennaInfoWndEquip.ShowWindow();
	HennaInfoWndUnEquip.HideWindow();
	GetPlayerInfo(Info);
	return;
}

function SetFormUnEQUIP()
{
	setWindowTitleByString(GetSystemString(652));
	HennaInfoWndEquip.HideWindow();
	HennaInfoWndUnEquip.ShowWindow();
	return;
}

function ShowHennaInfoWnd(string param)
{
	local string orignalString;
	local int textWidth, textHeight;
	local INT64 iAdena;
	local string strDyeName, strDyeIconName;
	local int iHennaID, iClassID;
	local INT64 iNum, iFee;
	local string strTattooName, strTattooAddName, strTattooIconName;
	local int iINTnow, iINTchange, iSTRnow, iSTRchange, iCONnow, iCONchange, iMENnow, iMENchange, iDEXnow, iDEXchange, iWITnow, iWITchange, iLUCnow, iLUCchange, iCHAnow, iCHAchange;

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
	m_iHennaID = iHennaID;
	if((m_iState == 1))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtDyeInfo"), GetSystemString(638));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture((m_Windowname $ ".textureDyeIconName"), strDyeIconName);
		orignalString = strDyeName;
		if(Class'InterfaceClassic.L2Util'.static.GetEllipsisString(strDyeName, 315))
		{
			GetTextBoxHandle((m_Windowname $ ".HennaInfoWndEquip.txtDyeName")).SetTooltipString(orignalString);
		}
		else
		{
			GetTextBoxHandle((m_Windowname $ ".HennaInfoWndEquip.txtDyeName")).SetTooltipString("");
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".HennaInfoWndEquip.txtDyeName"), strDyeName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtNeedItemString"), (GetSystemString(2380) $ " : "));
		bEnoughItemnum = (iNum >= needCount);
		if(!bEnoughItemnum)
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((m_Windowname $ ".txtCurrentItemNum"), GetColor(255, 0, 0, 255));
		}
		else
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((m_Windowname $ ".txtCurrentItemNum"), GetColor(0, 176, 255, 255));
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtCurrentItemNum"), string(iNum));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtNeedItemNum"), ("/" $ string(needCount)));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtTattooInfo"), GetSystemString(639));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture((m_Windowname $ ".textureTattooIconName"), strTattooIconName);
		orignalString = strTattooName;
		if(Class'InterfaceClassic.L2Util'.static.GetEllipsisString(strTattooName, 315))
		{
			GetTextBoxHandle((m_Windowname $ ".HennaInfoWndEquip.txtTattooName")).SetTooltipString(orignalString);
		}
		else
		{
			GetTextBoxHandle((m_Windowname $ ".HennaInfoWndEquip.txtTattooName")).SetTooltipString("");
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtTattooName"), strTattooName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtTattooAddName"), strTattooAddName);
	}
	else if((m_iState == 2))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtTattooInfoUnEquip"), GetSystemString(639));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture((m_Windowname $ ".textureTattooIconNameUnEquip"), strTattooIconName);
		orignalString = ((GetSystemString(652) $ ":") $ strTattooName);
		if(Class'InterfaceClassic.L2Util'.static.GetEllipsisString(orignalString, 315))
		{
			GetTextBoxHandle((m_Windowname $ ".HennaInfoWndUnEquip.txtTattooNameUnEquip")).SetTooltipString(strTattooName);
		}
		else
		{
			GetTextBoxHandle((m_Windowname $ ".HennaInfoWndUnEquip.txtTattooNameUnEquip")).SetTooltipString("");
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".HennaInfoWndUnEquip.txtTattooNameUnEquip"), orignalString);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtTattooAddNameUnEquip"), strTattooAddName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtDyeInfoUnEquip"), GetSystemString(638));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture((m_Windowname $ ".textureDyeIconNameUnEquip"), strDyeIconName);
		orignalString = strDyeName;
		GetTextSizeDefault(("x" $ string(iNum)), textWidth, textHeight);
		if(Class'InterfaceClassic.L2Util'.static.GetEllipsisString(strDyeName, (315 - textWidth)))
		{
			GetTextBoxHandle((m_Windowname $ ".HennaInfoWndUnEquip.txtDyeNameUnEquip")).SetTooltipString(orignalString);
		}
		else
		{
			GetTextBoxHandle((m_Windowname $ ".HennaInfoWndUnEquip.txtDyeNameUnEquip")).SetTooltipString("");
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".HennaInfoWndUnEquip.txtDyeNameUnEquip"), ((strDyeName $ "x") $ string(iNum)));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtNeedItemString"), "");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtCurrentItemNum"), "");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".txtNeedItemNum"), "");
	}
	updateNeedItem(iFee);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtSTRBefore"), iSTRnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtSTRAfter"), iSTRchange);
	ColorOnChange(iSTRnow, iSTRchange, "txtSTRAfter");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtDEXBefore"), iDEXnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtDEXAfter"), iDEXchange);
	ColorOnChange(iDEXnow, iDEXchange, "txtDEXAfter");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtCONBefore"), iCONnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtCONAfter"), iCONchange);
	ColorOnChange(iCONnow, iCONchange, "txtCONAfter");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtINTBefore"), iINTnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtINTAfter"), iINTchange);
	ColorOnChange(iINTnow, iINTchange, "txtINTAfter");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtWITBefore"), iWITnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtWITAfter"), iWITchange);
	ColorOnChange(iWITnow, iWITchange, "txtWITAfter");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtMENBefore"), iMENnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtMENAfter"), iMENchange);
	ColorOnChange(iMENnow, iMENchange, "txtMENAfter");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtLUCBefore"), iLUCnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtLUCAfter"), iLUCchange);
	ColorOnChange(iLUCnow, iLUCchange, "txtLUCAfter");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtCHABefore"), iCHAnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt((m_Windowname $ ".txtCHAAfter"), iCHAchange);
	ColorOnChange(iCHAnow, iCHAchange, "txtCHAAfter");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaListWndLive");
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_Windowname);
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_Windowname);
	GetWindowHandle("HennaListWndLive").SetAnchor(m_Windowname, "TopLeft", "TopLeft", 0, 0);
	return;
}

function ColorOnChange(int before, int after, string textname)
{
	if((before != after))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(((m_Windowname $ ".") $ textname), getInstanceL2Util().Yellow);
	}
	else
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(((m_Windowname $ ".") $ textname), GetColor(176, 155, 121, 255));
	}
	return;
}

function updateNeedItem(INT64 needNum)
{
	needItemScript.SetNumNeed(needNum);
	DelegateNeedItemOnUpdateItem(needItemScript);
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
	if((Script.canBuy() && (bEnoughItemnum || (m_iState == 2))))
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
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="HennaInfoWndLive"
}
