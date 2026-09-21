class GMInventoryWnd extends InventoryWnd;

struct GMHennaInfo
{
	var int HennaID;
	var int IsActive;
	var int Period;
};

var bool bShow;
var int m_ObservingUserInvenLimit;
var INT64 m_Adena;
var bool m_HasLEar;
var bool m_HasLFinger;
var array<GMHennaInfo> m_HennaInfoList;
var GMHennaInfo m_PremiumHennaInfo;

function OnRegisterEvent()
{
	RegisterEvent(2401);
	RegisterEvent(2402);
	RegisterEvent(2403);
	RegisterEvent(2405);
	RegisterEvent(2404);
	RegisterEvent(8000);
	return;
}

function OnLoad()
{
	local WindowHandle hCrystallizeButton, hTrashButton, hInvenWeight;

	InitHandleCOD();
	SetEquipWindowHandle();
	SetHandles();
	hCrystallizeButton = GetWindowHandle("GMInventoryWnd.CrystallizeButton");
	hTrashButton = GetWindowHandle("GMInventoryWnd.TrashButton");
	hInvenWeight = GetWindowHandle("GMInventoryWnd.InvenWeight");
	bShow = false;
	m_hOwnerWnd.SetWindowTitle(GetSystemString(138));
	hCrystallizeButton.HideWindow();
	hTrashButton.HideWindow();
	hInvenWeight.HideWindow();
	InitScrollBar();
	m_bCurrentState = false;
	m_selectedItemTab = 0;
	return;
}

function OnShow()
{
	CheckShowCrystallizeButton();
	SetAdenaText();
	SetItemCount();
	UpdateHennaInfo();
	return;
}

function OnHide()
{
	return;
}

function ShowInventory(string a_Param)
{
	if((a_Param == ""))
	{
		return;
	}
	if(bShow)
	{
		HandleClear();
		m_hOwnerWnd.HideWindow();
		bShow = false;
	}
	else
	{
		Class'NWindow.GMAPI'.static.RequestGMCommand(GMCOMMAND_InventoryInfo, a_Param);
		bShow = true;
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 2401:
			HandleGMObservingInventoryAddItem(a_Param);
			break;
		case 2402:
			HandleGMObservingInventoryClear(a_Param);
			break;
		case 2403:
			HandleGMAddHennaInfo(a_Param);
			break;
		case 2404:
			HandleGMUpdateHennaInfo(a_Param);
			break;
		case 2405:
			HandleGMAddPremiumHennaInfo(a_Param);
			break;
		case 8000:
			checkClassicForm();
			break;
		default:
			break;
	}
	return;
}

function HandleGMObservingInventoryAddItem(string a_Param)
{
	HandleAddItem(a_Param);
	SetItemCount();
	return;
}

function HandleAddItem(string param)
{
	local ItemInfo Info;

	ParamToItemInfo(param, Info);
	if(IsEquipItem(Info))
	{
		EquipItemUpdate(Info);
	}
	else if(IsQuestItem(Info))
	{
		m_questItem.AddItem(Info);
	}
	else
	{
		if(IsAdena(Info.Id))
		{
			SetAdena(Info.ItemNum);
		}
		NormalInvenAddItem(Info);
	}
	return;
}

function SetAdena(INT64 a_Adena)
{
	m_Adena = a_Adena;
	SetAdenaText();
	return;
}

function SetAdenaText()
{
	local string Adenastring;

	Adenastring = MakeCostString(string(m_Adena));
	m_hAdenaTextBox.SetText(Adenastring);
	m_hAdenaTextBox.SetTooltipString(ConvertNumToText(string(m_Adena)));
	return;
}

function int GetMyInventoryLimit()
{
	return m_ObservingUserInvenLimit;
}

function HandleGMObservingInventoryClear(string a_Param)
{
	HandleClear();
	ParseInt(a_Param, "InvenLimit", m_ObservingUserInvenLimit);
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	return;
}

function HandleGMAddHennaInfo(string a_Param)
{
	m_HennaInfoList.Length = (m_HennaInfoList.Length + 1);
	ParseInt(a_Param, "ID", m_HennaInfoList[(m_HennaInfoList.Length - 1)].HennaID);
	ParseInt(a_Param, "bActive", m_HennaInfoList[(m_HennaInfoList.Length - 1)].IsActive);
	UpdateHennaInfo();
	return;
}

function HandleGMAddPremiumHennaInfo(string a_Param)
{
	ParseInt(a_Param, "ID", m_PremiumHennaInfo.HennaID);
	ParseInt(a_Param, "bActive", m_PremiumHennaInfo.IsActive);
	ParseInt(a_Param, "Period", m_PremiumHennaInfo.Period);
	GMUpdatePremiumHennaInfo();
	return;
}

function HandleGMUpdateHennaInfo(string a_Param)
{
	m_HennaInfoList.Length = 0;
	m_PremiumHennaInfo.HennaID = 0;
	m_PremiumHennaInfo.IsActive = 0;
	m_PremiumHennaInfo.Period = 0;
	return;
}

function OnDropItem(string strTarget, ItemInfo Info, int X, int Y)
{
	return;
}

function OnDropItemSource(string strTarget, ItemInfo Info)
{
	return;
}

function OnDBClickItem(string strID, int Index)
{
	return;
}

function OnRClickItem(string strID, int Index)
{
	return;
}

function EquipItemUpdate(ItemInfo a_Info, optional bool bSwitchExpandEquipBox)
{
	local ItemWindowHandle hItemWnd;

	super.EquipItemUpdate(a_Info);
	switch(a_Info.SlotBitType)
	{
		case INT64(2):
		case INT64(4):
		case INT64(6):
			if((0 == m_equipItem[8].GetItemNum()))
			{
				hItemWnd = m_equipItem[8];
			}
			else
			{
				hItemWnd = m_equipItem[9];
			}
			break;
		case INT64(16):
		case INT64(32):
		case INT64(48):
			if((0 == m_equipItem[13].GetItemNum()))
			{
				hItemWnd = m_equipItem[13];
			}
			else
			{
				hItemWnd = m_equipItem[14];
			}
			break;
		default:
			break;
	}
	if((none != hItemWnd))
	{
		hItemWnd.Clear();
		hItemWnd.AddItem(a_Info);
	}
	return;
}

function int IsLOrREar(ItemID sID)
{
	return 0;
}

function int IsLOrRFinger(ItemID sID)
{
	return 0;
}

function UpdateHennaInfo()
{
	local int i;
	local ItemInfo HennaItemInfo;

	i = 0;
	while((i < m_HennaInfoList.Length))
	{
		if(!Class'NWindow.UIDATA_HENNA'.static.GetItemName(m_HennaInfoList[i].HennaID, HennaItemInfo.Name))
		{
			break;
		}
		if(!Class'NWindow.UIDATA_HENNA'.static.GetDescription(m_HennaInfoList[i].HennaID, HennaItemInfo.Description))
		{
			break;
		}
		if(!Class'NWindow.UIDATA_HENNA'.static.GetIconTex(m_HennaInfoList[i].HennaID, HennaItemInfo.IconName))
		{
			break;
		}
		if((0 == m_HennaInfoList[i].IsActive))
		{
			HennaItemInfo.bDisabled = 1;
			++i;
			continue;
		}
		HennaItemInfo.bDisabled = 0;
		++i;
	}
	return;
}

function GMUpdatePremiumHennaInfo()
{
	local int HennaID;
	local ItemInfo HennaItemInfo;
	local bool hennacheck;

	HennaID = m_PremiumHennaInfo.HennaID;
	hennacheck = Class'NWindow.UIDATA_HENNA'.static.GetItemCheck(HennaID);
	if(hennacheck)
	{
		HennaItemInfo.Name = Class'NWindow.UIDATA_HENNA'.static.GetItemNameS(HennaID);
		HennaItemInfo.Description = Class'NWindow.UIDATA_HENNA'.static.GetDescriptionS(HennaID);
		HennaItemInfo.IconName = Class'NWindow.UIDATA_HENNA'.static.GetIconTexS(HennaID);
		HennaItemInfo.CurrentPeriod = m_PremiumHennaInfo.Period;
	}
	if((0 == m_PremiumHennaInfo.IsActive))
	{
		HennaItemInfo.bDisabled = 1;
	}
	else
	{
		HennaItemInfo.bDisabled = 0;
	}
	return;
}
