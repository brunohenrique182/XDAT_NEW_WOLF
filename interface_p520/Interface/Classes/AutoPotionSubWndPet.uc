class AutoPotionSubWndPet extends UICommonAPI;

const DEFAULT_HPPERCENT = 80;
const AUTO_HP_PET_POTION_SHORTCUT_NUM = 278;

var WindowHandle Me;
var string m_Windowname;
var TextBoxHandle use_Text;
var TextBoxHandle Percent_Text;
var SliderCtrlHandle HPSetting_SliderCtrl;
var ProgressCtrlHandle BarSkillProgress;
var ItemWindowHandle ItemWnd_SubWnd;
var ButtonHandle Apply_Button;
var ItemWindowHandle InventoryItem_ItemWnd;
var InventoryWnd inventoryWndScript;
var AutoPotionWndPet AutoPotionWndPetSrcipt;
var int nHPPetPotionPercent;
var int nCurrentHPPetPotionPercent;
var int atShowTimeHpSliderValue;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	use_Text = GetTextBoxHandle((m_Windowname $ ".SettingWnd.use_Text"));
	Percent_Text = GetTextBoxHandle((m_Windowname $ ".SettingWnd.Percent_Text"));
	HPSetting_SliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".SettingWnd.HPSetting_SliderCtrl"));
	BarSkillProgress = GetProgressCtrlHandle((m_Windowname $ ".SettingWnd.BarSkillProgress"));
	ItemWnd_SubWnd = GetItemWindowHandle((m_Windowname $ ".Potion_Inventory_Window.ItemWnd_SubWnd"));
	Apply_Button = GetButtonHandle((m_Windowname $ ".SettingWnd.apply_Button"));
	BarSkillProgress.SetProgressTime(100);
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	AutoPotionWndPetSrcipt = AutoPotionWndPet(GetScript("PetStatusWndClassic.AutoPotionWndPet"));
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(11170);
	RegisterEvent(40);
	RegisterEvent(2610);
	RegisterEvent(2600);
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	syncInventoryByAll();
	Apply_Button.DisableWindow();
	atShowTimeHpSliderValue = nCurrentHPPetPotionPercent;
	return;
}

function OnHide()
{
	if((nCurrentHPPetPotionPercent != nHPPetPotionPercent))
	{
		setHPPotionPercent(nHPPetPotionPercent);
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo SelectItemInfo;

	ItemWnd_SubWnd.GetItem(Index, SelectItemInfo);
	Debug(("index" @ string(Index)));
	Debug(("Name:" @ SelectItemInfo.Name));
	if((SelectItemInfo.Id.ClassID > 0))
	{
		Class'NWindow.ShortcutWndAPI'.static.RequestRegisterShortcut(278, SelectItemInfo);
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "CloseButton":
			Me.HideWindow();
			setHPPotionPercent(nHPPetPotionPercent);
			break;
		case "apply_Button":
			OnApply_ButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2610:
		case 2600:
			syncInventory(param);
			break;
		case 11170:
			AutoplaySettingHandler(param);
			break;
		case 40:
			ItemWnd_SubWnd.Clear();
			break;
		default:
			break;
	}
	return;
}

event OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	switch(strID)
	{
		case "HPSetting_SliderCtrl":
			Percent_Text.SetText((string((iCurrentTick + 1)) $ "%"));
			BarSkillProgress.SetPos((99 - (iCurrentTick + 1)));
			nCurrentHPPetPotionPercent = (iCurrentTick + 1);
			if((atShowTimeHpSliderValue == nCurrentHPPetPotionPercent))
			{
				Apply_Button.DisableWindow();
			}
			else
			{
				Apply_Button.EnableWindow();
			}
			break;
		default:
			break;
	}
	return;
}

function AutoplaySettingHandler(string param)
{
	ParseInt(param, "HPPetPotionPercent", nHPPetPotionPercent);
	if(((nHPPetPotionPercent > 0) && (nCurrentHPPetPotionPercent != nHPPetPotionPercent)))
	{
		if((AutoPotionWndPetSrcipt.getCurrentSlotClassID() > 0))
		{
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(5293), string(nHPPetPotionPercent)));
		}
		else
		{
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(5293), string(nHPPetPotionPercent)));
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13003), string(nHPPetPotionPercent)));
		}
	}
	setHPPotionPercent(nHPPetPotionPercent);
	return;
}

function setHPPotionPercent(int hpPoint)
{
	if(((hpPoint > 0) && (hpPoint <= 100)))
	{
	}
	else
	{
		Debug(("#### 경고(값이 비정상입니다.) :: HPPetPotionPercent :" @ string(hpPoint)));  // EN?: # # # # Warning (Value is invalid.):: HPPetPotionPercent:
		hpPoint = 1;
	}
	Percent_Text.SetText((string(hpPoint) $ "%"));
	BarSkillProgress.SetPos((100 - hpPoint));
	HPSetting_SliderCtrl.SetCurrentTick((hpPoint - 1));
	nCurrentHPPetPotionPercent = hpPoint;
	return;
}

function syncInventory(string param)
{
	local ItemInfo updatedItemInfo;
	local string Type;
	local int Index;

	if(!Me.IsShowWindow())
	{
		return;
	}
	ParamToItemInfo(param, updatedItemInfo);
	ParseString(param, "type", Type);
	if((int(Class'NWindow.UIDATA_ITEM'.static.GetAutomaticUseItemType(updatedItemInfo.Id.ClassID)) == 3))
	{
		Index = ItemWnd_SubWnd.FindItemByClassID(updatedItemInfo.Id);
		if((Type == "delete"))
		{
			if((Index > -1))
			{
				ItemWnd_SubWnd.DeleteItem(Index);
			}
		}
		else
		{
			SetShowItemCount(updatedItemInfo);
			if((Index > -1))
			{
				ItemWnd_SubWnd.SetItem(Index, updatedItemInfo);
			}
			else
			{
				ItemWnd_SubWnd.AddItem(updatedItemInfo);
			}
		}
	}
	return;
}

function ExSetSelectPostion(int nClassID)
{
	local int i;

	i = ItemWnd_SubWnd.FindItemByClassID(GetItemID(nClassID));
	if((i > -1))
	{
		ItemWnd_SubWnd.SetSelectedNum(i);
	}
	return;
}

function syncInventoryByAll()
{
	local array<ItemInfo> itemarray;
	local int i;

	itemarray = inventoryWndScript.getInventoryAllItemArray(true);
	ItemWnd_SubWnd.Clear();
	i = 0;
	while((i < itemarray.Length))
	{
		if((int(Class'NWindow.UIDATA_ITEM'.static.GetAutomaticUseItemType(itemarray[i].Id.ClassID)) == 3))
		{
			SetShowItemCount(itemarray[i]);
			ItemWnd_SubWnd.AddItem(itemarray[i]);
		}
		i++;
	}
	if((AutoPotionWndPetSrcipt.getCurrentSlotClassID() > 0))
	{
		ExSetSelectPostion(AutoPotionWndPetSrcipt.getCurrentSlotClassID());
	}
	return;
}

function OnApply_ButtonClick()
{
	Debug((("OnApply_ButtonClick" @ string(nCurrentHPPetPotionPercent)) @ m_Windowname));
	SetINIInt("AutoPotionSubWnd", "l", nCurrentHPPetPotionPercent, "WindowsInfo.ini");
	AutoUseItemWnd(GetScript("AutoUseItemWnd")).requestAutoPlayForAutoPotionPet(nCurrentHPPetPotionPercent);
	Me.HideWindow();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}
