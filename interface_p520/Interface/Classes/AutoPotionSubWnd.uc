class AutoPotionSubWnd extends UICommonAPI;

const DEFAULT_HPPERCENT = 80;
const AutoHPPotionSlotID = 277;

var WindowHandle Me;
var WindowHandle ParentWindow;
var WindowHandle AutoPotionSubWnd;
var TextBoxHandle use_Text;
var TextBoxHandle Percent_Text;
var ProgressCtrlHandle BarSkillProgress;
var ButtonHandle Apply_Button;
var SliderCtrlHandle HPSetting_SliderCtrl;
var ItemWindowHandle ItemWnd_SubWnd;
var ItemWindowHandle InventoryItem_ItemWnd;
var InventoryWnd inventoryWndScript;
var AutoPotionWnd AutoPotionWndSrcipt;
var string m_Windowname;
var int nHPPotionPercent;
var int nCurrentHPPotionPercent;
var bool firstSetting;
var int atShowTimeHpSliderValue;
var bool Initialized;

function Initialize()
{
	Me = GetWindowHandle("AutoPotionSubWnd");
	use_Text = GetTextBoxHandle("AutoPotionSubWnd.SettingWnd.use_Text");
	Percent_Text = GetTextBoxHandle("AutoPotionSubWnd.SettingWnd.Percent_Text");
	BarSkillProgress = GetProgressCtrlHandle("AutoPotionSubWnd.SettingWnd.BarSkillProgress");
	Apply_Button = GetButtonHandle("AutoPotionSubWnd.SettingWnd.apply_Button");
	HPSetting_SliderCtrl = GetSliderCtrlHandle("AutoPotionSubWnd.SettingWnd.HPSetting_SliderCtrl");
	ItemWnd_SubWnd = GetItemWindowHandle("AutoPotionSubWnd.Potion_Inventory_Window.ItemWnd_SubWnd");
	BarSkillProgress.SetProgressTime(100);
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	AutoPotionWndSrcipt = AutoPotionWnd(GetScript("AutoPotionWnd"));
	Initialized = true;
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(11170);
	RegisterEvent(40);
	RegisterEvent(2610);
	RegisterEvent(2600);
	return;
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	syncInventoryByAll();
	Apply_Button.DisableWindow();
	atShowTimeHpSliderValue = nCurrentHPPotionPercent;
	return;
}

event OnHide()
{
	if((nCurrentHPPotionPercent != nHPPotionPercent))
	{
		setHPPotionPercent(nHPPotionPercent);
	}
	return;
}

event OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	switch(strID)
	{
		case "HPSetting_SliderCtrl":
			if(!Initialized)
			{
				return;
			}
			Percent_Text.SetText((string((iCurrentTick + 1)) $ "%"));
			BarSkillProgress.SetPos((99 - (iCurrentTick + 1)));
			nCurrentHPPotionPercent = (iCurrentTick + 1);
			if((atShowTimeHpSliderValue == nCurrentHPPotionPercent))
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

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			break;
		case 2610:
		case 2600:
			syncInventory(param);
			checkRecoverAutoPlayHpPoint();
			break;
		case 11170:
			AutoplaySettingHandler(param);
			break;
		case 40:
			ItemWnd_SubWnd.Clear();
			firstSetting = false;
			break;
		default:
			break;
	}
	return;
}

event OnClickItem(string strID, int Index)
{
	local ItemInfo SelectItemInfo;

	ItemWnd_SubWnd.GetItem(Index, SelectItemInfo);
	if((SelectItemInfo.Id.ClassID > 0))
	{
		Class'NWindow.ShortcutWndAPI'.static.RequestRegisterShortcut(277, SelectItemInfo);
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "CloseButton":
			Me.HideWindow();
			setHPPotionPercent(nHPPotionPercent);
			break;
		case "apply_Button":
			OnApply_ButtonClick();
			break;
		default:
			break;
	}
	return;
}

function checkRecoverAutoPlayHpPoint()
{
	local int nHpPoint, nHpPetPoint;

	if((firstSetting == false))
	{
		firstSetting = true;
		GetINIInt(m_Windowname, "e", nHpPoint, "WindowsInfo.ini");
		GetINIInt(m_Windowname, "l", nHpPetPoint, "WindowsInfo.ini");
		if((nHpPoint == 0))
		{
			nHpPoint = 80;
		}
		if((nHpPetPoint == 0))
		{
			nHpPetPoint = 80;
		}
		if(getInstanceUIData().GetIsLiveServer())
		{
			AutoUseItemWnd(GetScript("AutoUseItemWnd")).requestAutoPlayForAutoPotion(nHpPoint);
		}
		else
		{
			AutomaticPlay(GetScript("AutomaticPlay")).requestAutoPlayForAutoPotionWithPet(nHpPoint, nHpPetPoint);
		}
	}
	return;
}

function AutoplaySettingHandler(string param)
{
	ParseInt(param, "HPPotionPercent", nHPPotionPercent);
	if(((nHPPotionPercent > 0) && (nCurrentHPPotionPercent != nHPPotionPercent)))
	{
		if((AutoPotionWndSrcipt.getCurrentSlotClassID() > 0))
		{
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(5293), string(nHPPotionPercent)));
		}
		else
		{
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(5293), string(nHPPotionPercent)));
			getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13003), string(nHPPotionPercent)));
		}
	}
	setHPPotionPercent(nHPPotionPercent);
	return;
}

function setHPPotionPercent(int hpPoint)
{
	if(((hpPoint > 0) && (hpPoint <= 100)))
	{
	}
	else
	{
		Debug(("#### 경고(값이 비정상입니다.) :: HPPotionPercent :" @ string(nHPPotionPercent)));  // EN?: # # # # Warning (Value is invalid.):: HPPotionPercent:
		hpPoint = 1;
	}
	Percent_Text.SetText((string(hpPoint) $ "%"));
	BarSkillProgress.SetPos((100 - hpPoint));
	HPSetting_SliderCtrl.SetCurrentTick((hpPoint - 1));
	nCurrentHPPotionPercent = hpPoint;
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
	if((int(Class'NWindow.UIDATA_ITEM'.static.GetAutomaticUseItemType(updatedItemInfo.Id.ClassID)) == 2))
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
		if((int(Class'NWindow.UIDATA_ITEM'.static.GetAutomaticUseItemType(itemarray[i].Id.ClassID)) == 2))
		{
			SetShowItemCount(itemarray[i]);
			ItemWnd_SubWnd.AddItem(itemarray[i]);
		}
		i++;
	}
	if((AutoPotionWndSrcipt.getCurrentSlotClassID() > 0))
	{
		ExSetSelectPostion(AutoPotionWndSrcipt.getCurrentSlotClassID());
	}
	return;
}

function OnApply_ButtonClick()
{
	SetINIInt(m_Windowname, "e", nCurrentHPPotionPercent, "WindowsInfo.ini");
	if(getInstanceUIData().GetIsLiveServer())
	{
		AutoUseItemWnd(GetScript("AutoUseItemWnd")).requestAutoPlayForAutoPotion(nCurrentHPPotionPercent);
	}
	else
	{
		AutomaticPlay(GetScript("AutomaticPlay")).requestAutoPlayForAutoPotion(nCurrentHPPotionPercent);
	}
	Me.HideWindow();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="AutoPotionSubWnd"
}
