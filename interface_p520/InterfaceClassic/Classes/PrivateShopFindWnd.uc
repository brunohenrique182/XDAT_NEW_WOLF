class PrivateShopFindWnd extends UICommonAPI;

const COLLECTION_ITEM_TYPE = 10000;

enum StoreType
{
	Sell,                           // 0
	Buy,                            // 1
	Wholesale,                      // 2
	AllStoreType                    // 3
};

enum ItemType
{
	Equipment,                      // 0
	Artifact,                       // 1
	Enchant,                        // 2
	Consumable,                     // 3
	EtcType                         // 4
};

var WindowHandle Me;
var WindowHandle Main_ItemFind_Wnd;
var WindowHandle ItemFind_Wnd;
var ButtonHandle BtnFind;
var WindowHandle TextInput;
var CheckBoxHandle AllItem_CheckBox;
var CheckBoxHandle SaleItem_CheckBox;
var CheckBoxHandle BuyItem_CheckBox;
var string m_Windowname;
var WindowHandle m_PrivateShopFind_Main;
var WindowHandle m_PrivateShopFind_Sub;
var PrivateShopFind_Main PrivateShopFind_MainScript;
var PrivateShopFind_Sub PrivateShopFind_SubScript;
var UIControlGroupButtonAssets TopGroupButtonAsset;
var UIControlTextInput uicontrolTextInputScr;
var UIControlDialogAssets uicontrolDialogAssetScr;
var WindowHandle disableWnd;
var int currentTeleportID;
var string clickedCheckBoxString;
var bool bFirstSetting;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent(20460);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	Main_ItemFind_Wnd = GetWindowHandle((m_Windowname $ ".Main_ItemFind_Wnd"));
	ItemFind_Wnd = GetWindowHandle((m_Windowname $ ".ItemFind_Wnd"));
	BtnFind = GetButtonHandle((m_Windowname $ ".ItemFind_Wnd.BtnFind"));
	TextInput = GetWindowHandle((m_Windowname $ ".ItemFind_Wnd.TextInput"));
	AllItem_CheckBox = GetCheckBoxHandle((m_Windowname $ ".ItemFind_Wnd.AllItem_CheckBox"));
	SaleItem_CheckBox = GetCheckBoxHandle((m_Windowname $ ".ItemFind_Wnd.SaleItem_CheckBox"));
	BuyItem_CheckBox = GetCheckBoxHandle((m_Windowname $ ".ItemFind_Wnd.BuyItem_CheckBox"));
	m_PrivateShopFind_Main = GetWindowHandle((m_Windowname $ ".PrivateShopFind_Main"));
	m_PrivateShopFind_Sub = GetWindowHandle((m_Windowname $ ".PrivateShopFind_Sub"));
	PrivateShopFind_MainScript = PrivateShopFind_Main(m_PrivateShopFind_Main.GetScript());
	PrivateShopFind_SubScript = PrivateShopFind_Sub(m_PrivateShopFind_Sub.GetScript());
	m_PrivateShopFind_Main.ShowWindow();
	m_PrivateShopFind_Sub.HideWindow();
	initGroupButton();
	InitUIControlTextInput();
	SetPopupScript();
	bFirstSetting = false;
	clickedCheckBoxString = "";
	OnClickCheckBox("AllItem_CheckBox");
	return;
}

function OnShow()
{
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
		return;
	}
	setCategoryButton();
	uicontrolTextInputScr.SetDisable(true);
	Me.SetFocus();
	setInputCheckEnable();
	if(m_PrivateShopFind_Main.IsShowWindow())
	{
		PrivateShopFind_MainScript.OnShow();
	}
	else if(m_PrivateShopFind_Sub.IsShowWindow())
	{
		PrivateShopFind_SubScript.OnShow();
	}
	if(GetWindowHandle((m_Windowname $ ".UIControlDialogAsset")).IsShowWindow())
	{
		GetPopupExpandScript().Hide();
	}
	return;
}

function initGroupButton()
{
	TopGroupButtonAsset = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle((m_Windowname $ ".UIControlGroupButtonAsset1")));
	TopGroupButtonAsset._SetStartInfo("L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Center_Unselected_Over", true);
	TopGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButton;
	TopGroupButtonAsset._setDelayTime(1500);
	TopGroupButtonAsset.DelegateOnDelayTime = DelegateOnDelayTime;
	return;
}

function DelegateOnDelayTime(bool bOnTime)
{
	if(bOnTime)
	{
		BtnFind.DisableWindow();
		PrivateShopFind_SubScript.ReFresh_btn.DisableWindow();
		AllItem_CheckBox.DisableWindow();
		SaleItem_CheckBox.DisableWindow();
		BuyItem_CheckBox.DisableWindow();
	}
	else
	{
		BtnFind.EnableWindow();
		PrivateShopFind_SubScript.ReFresh_btn.EnableWindow();
		AllItem_CheckBox.EnableWindow();
		SaleItem_CheckBox.EnableWindow();
		BuyItem_CheckBox.EnableWindow();
	}
	return;
}

function setCategoryButton()
{
	if(bFirstSetting)
	{
		return;
	}
	bFirstSetting = true;
	if(getInstanceUIData().GetIsClassicServer())
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, "");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(116));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(2, GetSystemString(2066));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(3, GetSystemString(13891));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(4, GetSystemString(13476));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(0, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(1, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(2, 2);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(3, 4);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(4, 10000);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(5);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(987, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setTextureLoc(0, GetTextureHandle((m_Windowname $ ".Tab_HomeIcon")), 0, 13, "center");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Left_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Left_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Left_Unselected_Over");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(4, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected_Over");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0);
	}
	else
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, "");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(116));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(2, GetSystemString(3877));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(3, GetSystemString(1532));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(4, GetSystemString(3935));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(5, GetSystemString(49));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(6, GetSystemString(13476));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(0, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(1, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(2, 1);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(3, 2);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(4, 3);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(5, 4);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(6, 10000);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(7);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(987, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setTextureLoc(0, GetTextureHandle((m_Windowname $ ".Tab_HomeIcon")), 0, 13, "center");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Left_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Left_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Left_Unselected_Over");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(6, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Selected", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_Tab_Right_Unselected_Over");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0);
	}
	return;
}

function DelegateOnClickButton(string parentWndName, string strName, int Index)
{
	if((Index == 0))
	{
		m_PrivateShopFind_Main.ShowWindow();
		m_PrivateShopFind_Sub.HideWindow();
		Main_ItemFind_Wnd.ShowWindow();
		ItemFind_Wnd.HideWindow();
	}
	else
	{
		m_PrivateShopFind_Main.HideWindow();
		m_PrivateShopFind_Sub.ShowWindow();
		Main_ItemFind_Wnd.HideWindow();
		ItemFind_Wnd.ShowWindow();
		PrivateShopFind_SubScript.setGroupButtonCategory((Index - 1));
	}
	setInputCheckEnable();
	return;
}

function setInputCheckEnable()
{
	if(m_PrivateShopFind_Main.IsShowWindow())
	{
		uicontrolTextInputScr.SetDisable(true);
		BtnFind.DisableWindow();
		AllItem_CheckBox.DisableWindow();
		SaleItem_CheckBox.DisableWindow();
		BuyItem_CheckBox.DisableWindow();
	}
	else
	{
		uicontrolTextInputScr.SetDisable(false);
		BtnFind.EnableWindow();
		AllItem_CheckBox.EnableWindow();
		SaleItem_CheckBox.EnableWindow();
		BuyItem_CheckBox.EnableWindow();
	}
	return;
}

function InitUIControlTextInput()
{
	uicontrolTextInputScr = Class'InterfaceClassic.UIControlTextInput'.static.InitScript(GetWindowHandle((m_Windowname $ ".ItemFind_Wnd.TextInput")));
	uicontrolTextInputScr.SetMaxLength(16);
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	uicontrolTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolTextInputScr.SetEdtiable(true);
	uicontrolTextInputScr.SetDisable(false);
	uicontrolTextInputScr.SetDefaultString(GetSystemString(13835));
	return;
}

function DelegateESCKey()
{
	Debug("DelegateESCKey");
	return;
}

function DelegateOnChangeEdited(string Text)
{
	return;
}

function DelegateOnCompleteEditBox(string Text)
{
	if(((Text != "") && (TopGroupButtonAsset.bOnDelayTime == false)))
	{
		PrivateShopFind_SubScript.refresh();
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "BtnFind":
			OnBtnFindClick();
			break;
		default:
			break;
	}
	return;
}

function OnBtnFindClick()
{
	PrivateShopFind_SubScript.refresh();
	return;
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "AllItem_CheckBox":
			AllItem_CheckBox.SetCheck(true);
			SaleItem_CheckBox.SetCheck(false);
			BuyItem_CheckBox.SetCheck(false);
			break;
		case "SaleItem_CheckBox":
			AllItem_CheckBox.SetCheck(false);
			SaleItem_CheckBox.SetCheck(true);
			BuyItem_CheckBox.SetCheck(false);
			break;
		case "BuyItem_CheckBox":
			AllItem_CheckBox.SetCheck(false);
			SaleItem_CheckBox.SetCheck(false);
			BuyItem_CheckBox.SetCheck(true);
			break;
		default:
			break;
	}
	if((clickedCheckBoxString == strID))
	{
		return;
	}
	clickedCheckBoxString = strID;
	if(GetWindowHandle(m_Windowname).IsShowWindow())
	{
		PrivateShopFind_SubScript.refresh();
	}
	return;
}

function int getStoreTypeByCheckBox()
{
	if(SaleItem_CheckBox.IsChecked())
	{
		return 0;
	}
	else if(BuyItem_CheckBox.IsChecked())
	{
		return 1;
	}
	return 3;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			bFirstSetting = false;
			clickedCheckBoxString = "";
			break;
		case 40:
			bFirstSetting = false;
			clickedCheckBoxString = "";
			break;
		case 20460:
			if(!Me.IsShowWindow())
			{
				Me.ShowWindow();
			}
			break;
		default:
			break;
	}
	return;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	return UIControlDialogAssets(poopExpandWnd.GetScript());
}

function SetPopupScript()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(GetWindowHandle((m_Windowname $ ".UIControlDialogAsset")));
	disableWnd = GetWindowHandle((m_Windowname $ ".disable_tex"));
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_Windowname $ ".disable_tex"), false);
	return;
}

function ShowPopupTeleport(int nTeleportID)
{
	local UIControlDialogAssets popupExpandScript;
	local TeleportListAPI.TeleportListData listData;

	currentTeleportID = nTeleportID;
	popupExpandScript = GetPopupExpandScript();
	listData = getInstanceUIData().GetTeleportListDataByID(currentTeleportID);
	if((GetCurrentZoneName() == listData.Name))
	{
		AddSystemMessage(13577);
		GetWindowHandle(m_Windowname).HideWindow();
		PrivateShopFind_SubScript.setUserTargetCommand();
		return;
	}
	popupExpandScript.SetDialogDesc(((((GetSystemMessage(5239) $ "\\n\\n") $ "(") $ listData.Name) $ ")"));
	popupExpandScript.SetUseNeedItem(true);
	popupExpandScript.StartNeedItemList(1);
	popupExpandScript.AddNeedItemClassID(57, getInstanceUIData().GetTeleportPriceByID(currentTeleportID));
	popupExpandScript.SetItemNum(1);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = onClickTeleport;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	return;
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	return;
}

function onClickTeleport()
{
	local UserInfo UserInfo;

	if((GetPlayerInfo(UserInfo) == false))
	{
		return;
	}
	if((UserInfo.nCurHP == INT64(0)))
	{
		AddSystemMessage(5243);
		GetPopupExpandScript().Hide();
		return;
	}
	Class'NWindow.TeleportListAPI'.static.RequestTeleport(currentTeleportID);
	GetWindowHandle(m_Windowname).HideWindow();
	PrivateShopFind_SubScript.setUserTargetCommand();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
