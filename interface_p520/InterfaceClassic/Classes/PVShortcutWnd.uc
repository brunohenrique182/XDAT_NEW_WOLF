class PVShortcutWnd extends UICommonAPI;

const SHORTCUT_SLOT_MAX = 24;

struct ShortcutInfo
{
	var string Command;
	var string Name;
	var string IconTexName;
};

var WindowHandle Me;
var ItemInfo m_ShortcutItemInfo[24];
var string INIFilename;
var string m_Windowname;
var string defaultTextureName;
var ShortcutInfo m_ShortcutInfo[12];
var string pawnViewerMode;

function OnRegisterEvent()
{
	local int tmpInt;

	GetINIBool("URL", "IsL2PawnViewer", tmpInt, "l2.ini");
	if((tmpInt == 0))
	{
		return;
	}
	RegisterEvent(91);
	RegisterEvent(630);
	RegisterEvent(4365);
	return;
}

function LoadINIValues()
{
	local int tmpInt;

	GetINIBool("ShortcutWnd", "l", tmpInt, "windowsInfo.ini");
	GetINIString("URL", "L2PawnViewerMode", pawnViewerMode, "l2.ini");
	if((pawnViewerMode == ""))
	{
		pawnViewerMode = "Live";
	}
	if(bool(tmpInt))
	{
		OnMaxBtn();
	}
	else
	{
		OnMinBtn();
	}
	return;
}

function OnShow()
{
	LoadShortcutData();
	return;
}

function OnLoad()
{
	local int tmpInt;

	GetINIBool("URL", "IsL2PawnViewer", tmpInt, "l2.ini");
	if((tmpInt == 0))
	{
		return;
	}
	INIFilename = "PV.ini";
	InitializeHandle();
	LoadINIValues();
	return;
}

function InitializeHandle()
{
	Me = GetWindowHandle(m_Windowname);
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 91:
			ExecuteShortcutCommandBySlot(a_Param);
			break;
		case 630:
			HandleShortcutUpdate(a_Param);
			break;
		case 4365:
			HandleShortcutSave(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandleShortcutUpdate(string param)
{
	local int nShortcutID, nShortcutNum;

	ParseInt(param, "ShortcutID", nShortcutID);
	nShortcutNum = (int((float(nShortcutID) % 24.0000000)) + 1);
	Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((m_Windowname $ ".Shortcut") $ string(nShortcutNum)), nShortcutID);
	return;
}

function HandleShortcutSave(string param)
{
	local int nShortcutID;
	local ItemInfo Info;

	ParseInt(param, "ShortcutID", nShortcutID);
	if(Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.GetShortcutItem(Info, nShortcutID))
	{
		SetShortcutData(Info, nShortcutID);
	}
	else
	{
		RemoveShortcutData(nShortcutID);
	}
	SaveShortcutData();
	return;
}

function LoadShortcutData()
{
	local string Category;
	local ItemInfo Info;
	local int ClassID, ItemType, ShortcutType, Level, SubLevel;
	local string Name, IconName, IconPanel, Description, AdditionalName;
	local int ShortcutID, shortcutNum;

	ShortcutID = 0;
	while((ShortcutID < 24))
	{
		switch(pawnViewerMode)
		{
			case "Live":
				Category = ("Shortcut" $ string(ShortcutID));
				break;
			case "Classic":
				Category = ("C_Shortcut" $ string(ShortcutID));
				break;
			case "Aden":
				Category = ("A_Shortcut" $ string(ShortcutID));
				break;
			default:
				break;
		}
		if(!GetINIInt(Category, "ClassID", ClassID, INIFilename))
		{
			shortcutNum = (int((float(ShortcutID) % 24.0000000)) + 1);
			Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((m_Windowname $ ".Shortcut") $ string(shortcutNum)), ShortcutID);
			++ShortcutID;
			continue;
		}
		GetINIInt(Category, "ClassID", ClassID, INIFilename);
		GetINIInt(Category, "ItemType", ItemType, INIFilename);
		GetINIInt(Category, "ShortcutType", ShortcutType, INIFilename);
		GetINIInt(Category, "Level", Level, INIFilename);
		GetINIInt(Category, "SubLevel", SubLevel, INIFilename);
		GetINIString(Category, "Name", Name, INIFilename);
		GetINIString(Category, "IconName", IconName, INIFilename);
		GetINIString(Category, "IconPanel", IconPanel, INIFilename);
		GetINIString(Category, "Description", Description, INIFilename);
		GetINIString(Category, "AdditionalName", AdditionalName, INIFilename);
		Info.Id.ClassID = ClassID;
		Info.ItemType = ItemType;
		Info.ShortcutType = ShortcutType;
		Info.Level = Level;
		Info.SubLevel = SubLevel;
		Info.Name = Name;
		Info.IconName = IconName;
		Info.IconPanel = IconPanel;
		Info.Description = Description;
		Info.AdditionalName = AdditionalName;
		Info.Reserved = ShortcutID;
		m_ShortcutItemInfo[ShortcutID] = Info;
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.AddShortcutItem(Info, ShortcutID);
		++ShortcutID;
	}
	return;
}

function SetShortcutData(ItemInfo Info, int ShortcutID)
{
	local string Category;

	switch(pawnViewerMode)
	{
		case "Live":
			Category = ("Shortcut" $ string(ShortcutID));
			break;
		case "Classic":
			Category = ("C_Shortcut" $ string(ShortcutID));
			break;
		case "Aden":
			Category = ("A_Shortcut" $ string(ShortcutID));
			break;
		default:
			break;
	}
	SetINIInt(Category, "ClassID", Info.Id.ClassID, INIFilename);
	SetINIInt(Category, "ItemType", Info.ItemType, INIFilename);
	SetINIInt(Category, "ShortcutType", Info.ShortcutType, INIFilename);
	SetINIInt(Category, "Level", Info.Level, INIFilename);
	SetINIInt(Category, "SubLevel", Info.SubLevel, INIFilename);
	SetINIString(Category, "Name", Info.Name, INIFilename);
	SetINIString(Category, "IconName", Info.IconName, INIFilename);
	SetINIString(Category, "IconPanel", Info.IconPanel, INIFilename);
	SetINIString(Category, "Description", Info.Description, INIFilename);
	SetINIString(Category, "AdditionalName", Info.AdditionalName, INIFilename);
	m_ShortcutItemInfo[ShortcutID] = Info;
	return;
}

function RemoveShortcutData(int ShortcutID)
{
	local string Category;

	switch(pawnViewerMode)
	{
		case "Live":
			Category = ("Shortcut" $ string(ShortcutID));
			break;
		case "Classic":
			Category = ("C_Shortcut" $ string(ShortcutID));
			break;
		case "Aden":
			Category = ("A_Shortcut" $ string(ShortcutID));
			break;
		default:
			break;
	}
	RemoveINI(Category, "ClassID", INIFilename);
	RemoveINI(Category, "ItemType", INIFilename);
	RemoveINI(Category, "ShortcutType", INIFilename);
	RemoveINI(Category, "Level", INIFilename);
	RemoveINI(Category, "SubLevel", INIFilename);
	RemoveINI(Category, "Name", INIFilename);
	RemoveINI(Category, "IconName", INIFilename);
	RemoveINI(Category, "IconPanel", INIFilename);
	RemoveINI(Category, "Description", INIFilename);
	RemoveINI(Category, "AdditionalName", INIFilename);
	m_ShortcutItemInfo[ShortcutID].Id.ClassID = 0;
	m_ShortcutItemInfo[ShortcutID].ItemType = 0;
	m_ShortcutItemInfo[ShortcutID].ShortcutType = 0;
	m_ShortcutItemInfo[ShortcutID].Level = 0;
	m_ShortcutItemInfo[ShortcutID].SubLevel = 0;
	m_ShortcutItemInfo[ShortcutID].Name = "";
	m_ShortcutItemInfo[ShortcutID].IconName = "";
	m_ShortcutItemInfo[ShortcutID].IconPanel = "";
	m_ShortcutItemInfo[ShortcutID].Description = "";
	m_ShortcutItemInfo[ShortcutID].AdditionalName = "";
	return;
}

function SaveShortcutData()
{
	SaveINI(INIFilename);
	return;
}

function OnClickButton(string a_strID)
{
	local int ShortcutID;
	local string buttonName;

	ShortcutID = 0;
	while((ShortcutID < 24))
	{
		buttonName = ("Shortcut" $ string((ShortcutID + 1)));
		if((buttonName == a_strID))
		{
			UseShortcut(ShortcutID);
		}
		++ShortcutID;
	}
	switch(a_strID)
	{
		case "TooltipMinBtn":
			OnMinBtn();
			break;
		case "TooltipMaxBtn":
			OnMaxBtn();
			break;
		default:
			break;
	}
	return;
}

function ExecuteShortcutCommandBySlot(string param)
{
	local int ShortcutID;

	ParseInt(param, "Slot", ShortcutID);
	if(((ShortcutID >= 24) || (ShortcutID < 0)))
	{
		return;
	}
	if(Me.IsShowWindow())
	{
		UseShortcut(ShortcutID);
	}
	return;
}

function UseShortcut(int ShortcutID)
{
	local ItemInfo Info;

	Info = m_ShortcutItemInfo[ShortcutID];
	if((Info.ShortcutType == 1))
	{
		if((Info.Id.ClassID <= 0))
		{
			return;
		}
		Class'NWindow.UIDATA_PAWNVIEWER'.static.EquipPCItem(Info.Id);
	}
	else if((Info.ShortcutType == 2))
	{
		if((Info.Level <= 0))
		{
			return;
		}
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ExecuteSkill(Info.Id.ClassID, Info.Level, Info.SubLevel);
	}
	else if((Info.ShortcutType == 4))
	{
		ExecuteCommand(Info.Name);
	}
	return;
}

function HandleShortcutClear()
{
	local int i;

	i = 0;
	while((i < 24))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("PVShortcutWnd.PVShortcutWnd.Shortcut" $ string((i + 1))));
		++i;
	}
	return;
}

function OnMinBtn()
{
	local ToolTip Script;

	Script = ToolTip(GetScript("Tooltip"));
	Script.setBoolSelect(true);
	LoadShortcutData();
	ShowWindow("PVShortcutWnd.PVShortcutWnd.TooltipMaxBtn");
	HideWindow("PVShortcutWnd.PVShortcutWnd.TooltipMinBtn");
	SetINIBool("ShortcutWnd", "l", false, "windowsInfo.ini");
	return;
}

function OnMaxBtn()
{
	local ToolTip Script;

	Script = ToolTip(GetScript("Tooltip"));
	Script.setBoolSelect(false);
	LoadShortcutData();
	ShowWindow("PVShortcutWnd.PVShortcutWnd.TooltipMinBtn");
	HideWindow("PVShortcutWnd.PVShortcutWnd.TooltipMaxBtn");
	SetINIBool("ShortcutWnd", "l", true, "windowsInfo.ini");
	return;
}

defaultproperties
{
	m_Windowname="PVShortcutWnd"
	defaultTextureName="L2UI_NewTex.ShortcutWnd.SlotBG_4x2"
}
