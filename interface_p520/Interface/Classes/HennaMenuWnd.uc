class HennaMenuWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var string m_Windowname;
var UIPacket._S_EX_NEW_HENNA_LIST henna_list_packet;
var int selectIndexSlot;

function OnRegisterEvent()
{
	RegisterEvent(11581);
	RegisterEvent(40);
	RegisterEvent(9750);
	RegisterEvent(3410);
	RegisterEvent((100000 + 982));
	return;
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	initUI();
	return;
}

function initUI()
{
	local int i;

	i = 1;
	while((i <= 4))
	{
		GetTextureHandle((((m_Windowname $ ".HennaSlot0") $ string(i)) $ "_wnd.HannaMark_tex")).HideWindow();
		GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string(i)) $ "_wnd.HennaTitle_txt")).SetText("");
		GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string(i)) $ "_wnd.HennaLV_txt")).SetText("");
		GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string(i)) $ "_wnd.HennaStat_txt")).SetText("");
		GetTextureHandle((((m_Windowname $ ".HennaSlot0") $ string(i)) $ "_wnd.HannaMark_tex")).HideWindow();
		GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string(i)) $ "_wnd.EmptyMark_txt")).SetText("");
		GetWindowHandle((((m_Windowname $ ".HennaSlot0") $ string(i)) $ "_wnd.EmptyMarkShowWnd")).HideWindow();
		GetButtonHandle((((m_Windowname $ ".HennaSlot0") $ string(i)) $ "_wnd.HennaEnchant_Btn")).SetTooltipType("text");
		GetButtonHandle((((m_Windowname $ ".HennaSlot0") $ string(i)) $ "_wnd.HennaEnchant_Btn")).SetTooltipCustomType(MakeTooltipSimpleColorText(MakeFullSystemMsg(GetSystemMessage(13751), string(i)), GTColor().BrightWhite, "hs13"));
		i++;
	}
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	API_C_EX_NEW_HENNA_LIST();
	return;
}

function OnClickButton(string Name)
{
	Debug(("Name" @ Name));
	if((Name == "HennaClose_BTN"))
	{
		Me.HideWindow();
	}
	else if((Name == "HennaSynthetic_BTN"))
	{
		ShowMennaMenuWnd();
	}
	else if((Name == "HelpWnd_Btn"))
	{
		Class'Interface.HelpWnd'.static.ShowHelp(78);
	}
	else
	{
		OnClickEnchant(Name);
	}
	return;
}

function ShowMennaMenuWnd()
{
	local Rect rectWnd;

	rectWnd = GetWindowHandle("HennaDyeEnchantWnd").GetRect();
	getInstanceL2Util().syncWindowLoc(m_hOwnerWnd.m_WindowNameWithFullPath, "HennaDyeEnchantWnd", ((m_hOwnerWnd.GetRect().nWidth - rectWnd.nWidth) / 2), ((m_hOwnerWnd.GetRect().nHeight - rectWnd.nHeight) / 2));
	ShowWindowWithFocus("HennaDyeEnchantWnd");
	Me.HideWindow();
	return;
}

function OnClickEnchant(string Name)
{
	local int Index;

	if((Left(Name, 14) == "HennaInfoOpen0"))
	{
		Index = int(Mid(Name, 14, 1));
		Debug(("OnClickEnchant:" @ string(Index)));
		requestEquipUnEquip((Index - 1));
	}
	return;
}

function requestEquipUnEquip(int i)
{
	selectIndexSlot = i;
	if((henna_list_packet.hennaInfoList[i].cActive <= 0))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13455));
	}
	else
	{
		if((henna_list_packet.hennaInfoList[i].nHennaID > 0))
		{
			RequestHennaUnEquipInfo(henna_list_packet.hennaInfoList[i].nHennaID);
			Debug(("Api --> RequestHennaUnEquipInfo" @ string(henna_list_packet.hennaInfoList[i].nHennaID)));
		}
		else
		{
			RequestHennaItemList();
			Debug("Api --> RequestHennaItemList");
		}
		Me.HideWindow();
	}
	return;
}

function OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		case 11581:
			Me.ShowWindow();
			Me.SetFocus();
			break;
		case (100000 + 982):
			ParsePacket_S_EX_NEW_HENNA_LIST();
			break;
		case 40:
			initUI();
			break;
		case 3410:
			if((param != "GAMINGSTATE"))
			{
				m_hOwnerWnd.HideWindow();
			}
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_NEW_HENNA_LIST()
{
	local int i, dyeItemClassID, dyeItemlevel;
	local string dyeItemName, cutStr, ItemNameS;
	local SkillInfo SkillInfo;
	local string emblemTex, Desc;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_NEW_HENNA_LIST(henna_list_packet))
	{
		return;
	}
	if(!Me.IsShowWindow())
	{
		return;
	}
	Debug((" -->  Decode_S_EX_NEW_HENNA_LIST :  " @ string(henna_list_packet.hennaInfoList.Length)));
	i = 0;
	while((i < henna_list_packet.hennaInfoList.Length))
	{
		Debug((("--------------------------------" @ string(i)) @ "--------------------------------------"));
		Debug(("packet.nHennaID " @ string(henna_list_packet.hennaInfoList[i].nHennaID)));
		Debug(("packet.nPotenID " @ string(henna_list_packet.hennaInfoList[i].nPotenID)));
		Debug(("packet.cActive " @ string(henna_list_packet.hennaInfoList[i].cActive)));
		Debug(("packet.nEnchantStep " @ string(henna_list_packet.hennaInfoList[i].nEnchantStep)));
		Debug(("packet.nEnchantExp " @ string(henna_list_packet.hennaInfoList[i].nEnchantExp)));
		Debug(("packet.nActiveStep " @ string(henna_list_packet.hennaInfoList[i].nActiveStep)));
		Debug(("packet.nDailyStep " @ string(henna_list_packet.hennaInfoList[i].nDailyStep)));
		Debug(("packet.nDailyCount " @ string(henna_list_packet.hennaInfoList[i].nDailyCount)));
		Debug(("packet.nOpenedSlotStep " @ string(henna_list_packet.hennaInfoList[i].nOpenedSlotStep)));
		if((henna_list_packet.hennaInfoList[i].cActive > 0))
		{
			GetWindowHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.EmptyMarkShowWnd")).HideWindow();
			if((henna_list_packet.hennaInfoList[i].nHennaID > 0))
			{
				emblemTex = Class'NWindow.UIDATA_HENNA'.static.GetHennaEmblemTex(henna_list_packet.hennaInfoList[i].nHennaID);
				GetTextureHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HannaMark_tex")).ShowWindow();
				GetTextureHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HannaMark_tex")).SetTexture(emblemTex);
				Class'NWindow.UIDATA_HENNA'.static.GetHennaDyeItemClassID(henna_list_packet.hennaInfoList[i].nHennaID, dyeItemClassID);
				Class'NWindow.UIDATA_HENNA'.static.GetHennaDyeItemLevel(henna_list_packet.hennaInfoList[i].nHennaID, dyeItemlevel);
				ItemNameS = Class'NWindow.UIDATA_HENNA'.static.GetItemNameS(henna_list_packet.hennaInfoList[i].nHennaID);
				Desc = Class'NWindow.UIDATA_HENNA'.static.GetDescriptionS(henna_list_packet.hennaInfoList[i].nHennaID);
				GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.Bottom_txt")).SetText(Desc);
				dyeItemName = Left(ItemNameS, InStr(ItemNameS, "<"));
				cutStr = Mid(ItemNameS, InStr(ItemNameS, "<"), Len(ItemNameS));
				GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaTitle_txt")).SetText(dyeItemName);
				GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaLV_txt")).SetText(MakeFullSystemMsg(GetSystemMessage(5203), string(dyeItemlevel)));
				GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaStat_txt")).SetText(cutStr);
				textBoxShortStringWithTooltip(GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaStat_txt")), true);
				GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.EmptyMark_txt")).SetText("");
				GetButtonHandle((((m_Windowname $ ".HennaInfoOpen0") $ string((i + 1))) $ "_BTN")).SetButtonName(3969);
				GetButtonHandle((((m_Windowname $ ".HennaInfoOpen0") $ string((i + 1))) $ "_BTN")).EnableWindow();
			}
			else
			{
				GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaTitle_txt")).SetText("");
				GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaLV_txt")).SetText("");
				GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaStat_txt")).SetText("");
				GetTextureHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HannaMark_tex")).HideWindow();
				GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.EmptyMark_txt")).SetText(GetSystemString(2496));
				GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.Bottom_txt")).SetText("");
				GetButtonHandle((((m_Windowname $ ".HennaInfoOpen0") $ string((i + 1))) $ "_BTN")).SetButtonName(3968);
				GetButtonHandle((((m_Windowname $ ".HennaInfoOpen0") $ string((i + 1))) $ "_BTN")).EnableWindow();
			}
			GetButtonHandle((((m_Windowname $ ".HennaInfoOpen0") $ string((i + 1))) $ "_BTN")).ClearTooltip();
			GetButtonHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaEnchant_Btn")).SetTooltipCustomType(MakeTooltipSimpleColorText(MakeFullSystemMsg(GetSystemMessage(13751), string((i + 1))), GTColor().BrightWhite, "hs13"));
			i++;
			continue;
		}
		GetTextureHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HannaMark_tex")).HideWindow();
		GetWindowHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.EmptyMarkShowWnd")).ShowWindow();
		GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.EmptyMark_txt")).SetText(GetSystemString(13195));
		GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaTitle_txt")).SetText("");
		GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaStat_txt")).SetText("");
		GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaStat_txt")).ClearTooltip();
		GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaLV_txt")).SetText("");
		GetButtonHandle((((m_Windowname $ ".HennaInfoOpen0") $ string((i + 1))) $ "_BTN")).ClearTooltip();
		GetButtonHandle((((m_Windowname $ ".HennaInfoOpen0") $ string((i + 1))) $ "_BTN")).SetButtonName(3587);
		GetTextBoxHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.Bottom_txt")).SetText("");
		GetSkillInfo(45269, 1, 0, SkillInfo);
		GetButtonHandle((((m_Windowname $ ".HennaInfoOpen0") $ string((i + 1))) $ "_BTN")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13923)));
		GetButtonHandle((((m_Windowname $ ".HennaSlot0") $ string((i + 1))) $ "_wnd.HennaEnchant_Btn")).SetTooltipCustomType(MakeTooltipSimpleColorText(GetSystemString(14594), GTColor().Yellow, "hs13", 350));
		i++;
	}
	return;
}

function int getSelectIndexSlot()
{
	return (selectIndexSlot + 1);
}

function API_C_EX_NEW_HENNA_LIST()
{
	local array<byte> stream;

	Debug("API Call -------------- _C_EX_NEW_HENNA_LIST ---------------");
	Class'Interface.UIPacket'.static.RequestUIPacket(746, stream);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
