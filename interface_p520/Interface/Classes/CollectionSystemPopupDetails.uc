class CollectionSystemPopupDetails extends UICommonAPI;

const ItemNum = 6;

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var CollectionSystem collectionSystemScript;
var CollectionSystemSub collectionSystemSubScript;
var WindowHandle ItemRegistrationList_Wnd;
var ItemWindowHandle ItemRegistrationList_ItemWnd;
var ButtonHandle Registration_Btn;
var TextureHandle ItemAllow_Tex;
var int currentSlotID;
var int CollectionID;
var bool bRecursive;
var UIControlNeedItemDialog needItemDialogScript;
var ItemWindowHandle RewardItem_ItemWnd;
var ItemWindowHandle RewardSkill_ItemWnd;
var ButtonHandle Reward_Btn;
var AnimTextureHandle Complete_Ani;
var TextureHandle Complete_tex;
var AnimTextureHandle GetSkill_Ani;
var TextureHandle GetSkill_Tex;
var AnimTextureHandle GetItem_Ani;
var TextureHandle GetItem_Tex;
var bool isCompleted;
var ButtonHandle CloseBtn;
var ButtonHandle CloseBtn2;

function OnRegisterEvent()
{
	RegisterEvent(1710);
	return;
}

function HandleDialogOK()
{
	if(!DialogIsMine())
	{
		return;
	}
	collectionSystemScript.API_C_EX_COLLECTION_RECEIVE_REWARD(CollectionID);
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	util = L2Util(GetScript("L2Util"));
	collectionSystemScript = CollectionSystem(GetScript("CollectionSystem"));
	collectionSystemSubScript = CollectionSystemSub(GetScript("CollectionSystem.CollectionSystemSub"));
	ItemRegistrationList_Wnd = GetWindowHandle((m_Windowname $ ".ItemRegistrationList_Wnd"));
	ItemRegistrationList_ItemWnd = GetItemWindowHandle((m_Windowname $ ".ItemRegistrationList_Wnd.ItemRegistrationList_ItemWnd"));
	Registration_Btn = GetButtonHandle((m_Windowname $ ".ItemRegistrationList_Wnd.Registration_Btn"));
	InitItemWnds();
	SetScript_UIControlNeedItemDialog();
	RewardItem_ItemWnd = GetItemWindowHandle((m_Windowname $ ".PopupDetailsContents.RewardItem_ItemWnd"));
	RewardSkill_ItemWnd = GetItemWindowHandle((m_Windowname $ ".PopupDetailsContents.RewardSkill_ItemWnd"));
	Reward_Btn = GetButtonHandle((m_Windowname $ ".PopupDetailsContents.Reward_Btn"));
	Complete_Ani = GetAnimTextureHandle((m_Windowname $ ".PopupDetailsContents.Complete_Ani"));
	GetItem_Ani = GetAnimTextureHandle((m_Windowname $ ".PopupDetailsContents.GetItem_Ani"));
	GetSkill_Ani = GetAnimTextureHandle((m_Windowname $ ".PopupDetailsContents.GetSkill_Ani"));
	Complete_tex = GetTextureHandle((m_Windowname $ ".PopupDetailsContents.Complete_Tex"));
	GetItem_Tex = GetTextureHandle((m_Windowname $ ".PopupDetailsContents.GetItem_Tex"));
	GetSkill_Tex = GetTextureHandle((m_Windowname $ ".PopupDetailsContents.GetSkill_Tex"));
	ItemAllow_Tex = GetTextureHandle((m_Windowname $ ".PopupDetailsContents.ItemAllow_Tex"));
	CloseBtn = GetButtonHandle((m_Windowname $ ".PopupDetailsContents.Close_Btn"));
	CloseBtn.SetNameText("");
	CloseBtn2 = GetButtonHandle((m_Windowname $ ".ItemRegistrationList_Wnd.ItemRegistrationListClose_Btn"));
	CloseBtn2.SetNameText("");
	return;
}

function InitItemWnds()
{
	local int i;

	i = 0;
	while((i < 6))
	{
		GetItemWndByIndex(i).SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
		GetNotEnoughEnchantedTextureHandle(i).SetTextureCtrlType(TCT_Control);
		GetNotEnoughEnchantedTextureHandle(i).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13666)));
		i++;
	}
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnClickButton(string strID)
{
	local ItemInfo iInfo, inveniInfo;
	local int DialogStrNum;
	local CollectionData cData;

	switch(strID)
	{
		case "ItemRegistrationListClose_Btn":
			HandleHideItemRegistrationList();
			break;
		case "Ok_Btn":
		case "Close_Btn":
			collectionSystemScript.SetState(Sub);
			break;
		case "Registration_Btn":
			if(!collectionSystemScript.API_GetCollectionData(CollectionID, cData))
			{
				return;
			}
			if((cData.bDurationEvent == true))
			{
				needItemDialogScript.setInit((((GetSystemString(13493) $ "<br><font color=\"FFBB00\">") $ GetSystemString(14878)) $ "</font><br>"), 0, 0, 0, true);
			}
			else
			{
				needItemDialogScript.setInit(GetSystemString(13493), 0, 0, 0, true);
			}
			needItemDialogScript.StartNeedItemList();
			if((ItemRegistrationList_ItemWnd.GetSelectedNum() < 0))
			{
				return;
			}
			ItemRegistrationList_ItemWnd.GetSelectedItem(iInfo);
			NeedItemDialogShow();
			Class'NWindow.UIDATA_INVENTORY'.static.FindItem(iInfo.Id.ServerID, inveniInfo);
			needItemDialogScript.AddNeeItemInfo(iInfo, iInfo.Reserved64, inveniInfo.ItemNum);
			needItemDialogScript.EndNeedItemList();
			CheckRegistBtn();
			break;
		case "Reward_Btn":
			Class'Interface.UICommonAPI'.static.DialogSetID(9999);
			Class'Interface.UICommonAPI'.static.DialogSetDefaultCancle();
			if(bRecursive)
			{
				DialogStrNum = 5982;
			}
			else
			{
				DialogStrNum = 13510;
			}
			DialogShow(DialogModalType_Modal, DialogType_OKCancel, GetSystemString(DialogStrNum));
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
		case 1710:
			HandleDialogOK();
			break;
		default:
			break;
	}
	return;
}

event OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	switch(a_WindowHandle)
	{
		case Complete_Ani:
			if(isCompleted)
			{
				Complete_tex.ShowWindow();
			}
			else
			{
				Complete_tex.HideWindow();
			}
			break;
		case GetItem_Ani:
			GetItem_Tex.ShowWindow();
			break;
		case GetSkill_Ani:
			GetSkill_Tex.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	Init();
	return;
}

event OnMouseOver(WindowHandle W)
{
	local string wndname, Id;
	local Rect rectWnd;
	local array<ItemInfo> replaceiInfos;
	local CollectionData cData;

	wndname = W.GetWindowName();
	if(GetStringIDFromBtnName(wndname, "Item_ItemWnd", Id))
	{
		if(GetItemWndByIndex(int(Id)).IsEnableWindow())
		{
			GetOverTextureHandle(int(Id)).ShowWindow();
		}
	}
	else if(GetStringIDFromBtnName(wndname, "ItemReplace_Btn", Id))
	{
		if(!collectionSystemScript.API_GetCollectionData(CollectionID, cData))
		{
			return;
		}
		if(GetReplaceItems(cData, int(Id), replaceiInfos))
		{
			rectWnd = GetItemReplace_Btn(int(Id)).GetRect();
			ShowContextMenu((rectWnd.nX + rectWnd.nWidth), rectWnd.nY, replaceiInfos);
		}
	}
	return;
}

event OnMouseOut(WindowHandle W)
{
	local string wndname, Id;
	local UIControlContextMenu ContextMenu;

	wndname = W.GetWindowName();
	if(GetStringIDFromBtnName(wndname, "Item_ItemWnd", Id))
	{
		GetOverTextureHandle(int(Id)).HideWindow();
	}
	else if(GetStringIDFromBtnName(wndname, "ItemReplace_Btn", Id))
	{
		ContextMenu = Class'Interface.UIControlContextMenu'.static.GetInstance();
		ContextMenu.Hide();
	}
	return;
}

event OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	switch(a_hItemWindow.GetWindowName())
	{
		case "ItemRegistrationList_ItemWnd":
			if(CheckRegistBtn())
			{
				OnClickButton("Registration_Btn");
			}
			break;
		default:
			break;
	}
	return;
}

event OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	a_hItemWindow.SetSelectedNum(a_Index);
	switch(a_hItemWindow.GetWindowName())
	{
		case "ItemRegistrationList_ItemWnd":
			OnDBClickItemWithHandle(a_hItemWindow, a_Index);
			break;
		default:
			break;
	}
	return;
}

event OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	if((a_hItemWindow.GetWindowName() == "ItemRegistrationList_ItemWnd"))
	{
		CheckRegistBtn();
	}
	else
	{
		HandleBtnClick(a_hItemWindow.GetWindowName());
	}
	return;
}

function bool CheckRegistBtn()
{
	local ItemInfo iInfo;

	if(!ItemRegistrationList_ItemWnd.GetSelectedItem(iInfo))
	{
		return false;
	}
	if((needItemDialogScript.Me.IsShowWindow() || (iInfo.bDisabled == 1)))
	{
		Registration_Btn.DisableWindow();
	}
	else
	{
		Registration_Btn.EnableWindow();
		return true;
	}
	return false;
}

function HandleBtnClick(string strID)
{
	local string Id;
	local ItemInfo iInfo;

	if(GetStringIDFromBtnName(strID, "Item_ItemWnd", Id))
	{
		currentSlotID = int(Id);
		GetItemWndByIndex(currentSlotID).GetSelectedItem(iInfo);
		if((iInfo.bDisabled == 0))
		{
			return;
		}
		HndleShowItemRegistrationList();
	}
	return;
}

function SetReplaceTooltip(CollectionData cData, int SlotID)
{
	local array<ItemInfo> replaceiInfos;

	if(GetReplaceItems(cData, SlotID, replaceiInfos))
	{
		GetItemReplace_Btn(SlotID).ShowWindow();
		GetItemReplace_Tex(SlotID).ShowWindow();
	}
	else
	{
		GetItemReplace_Btn(SlotID).HideWindow();
		GetItemReplace_Tex(SlotID).HideWindow();
	}
	return;
}

function bool SetDetails()
{
	local int i;
	local CollectionInfo cInfo;
	local CollectionData cData;
	local array<ItemInfo> iIonfos, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList;
	local ItemInfo iInfo;
	local SkillInfo SkillInfo;
	local bool canregist;
	local string remainTimeString;

	isCompleted = false;
	Complete_Ani.Stop();
	Complete_Ani.HideWindow();
	Complete_tex.HideWindow();
	GetItem_Ani.HideWindow();
	GetSkill_Ani.HideWindow();
	GetItem_Tex.HideWindow();
	GetSkill_Tex.HideWindow();
	CollectionID = collectionSystemSubScript.GetSelectedCollectionID();
	if(!collectionSystemScript.API_GetCollectionInfo(CollectionID, cInfo))
	{
		return false;
	}
	if(!collectionSystemScript.API_GetCollectionData(CollectionID, cData))
	{
		return false;
	}
	GetTextBoxHandle((m_Windowname $ ".PopupDetailsContents.DetailsTitle_Txt")).SetText(cData.collection_name);
	GetTextBoxHandle((m_Windowname $ ".PopupDetailsContents.Period_Txt")).SetText(GetEndDateTime(cData.endDateTime));
	GetTextBoxHandle((m_Windowname $ ".PopupDetailsContents.CollectionEffect_Txt")).SetText(collectionSystemSubScript.GetOptionByOptionID(cData.option_id));
	if((cData.bDurationEvent == true))
	{
		remainTimeString = _GetResetTimeString(cInfo.RemainTime);
	}
	else if((cData.Period > 0))
	{
		remainTimeString = GetRemainTimeString(cData.Period, cInfo.RemainTime);
	}
	GetTextBoxHandle((m_Windowname $ ".PopupDetailsContents.Time_Txt")).SetText(remainTimeString);
	if((remainTimeString != ""))
	{
		GetTextureHandle((m_Windowname $ ".PopupDetailsContents.Time_Tex")).ShowWindow();
		if((cInfo.RemainTime > 0))
		{
			GetTextBoxHandle((m_Windowname $ ".PopupDetailsContents.Time_Txt")).SetTextColor(getInstanceL2Util().Yellow);
		}
		else
		{
			GetTextBoxHandle((m_Windowname $ ".PopupDetailsContents.Time_Txt")).SetTextColor(getInstanceL2Util().Gray);
		}
	}
	else
	{
		GetTextureHandle((m_Windowname $ ".PopupDetailsContents.Time_Tex")).HideWindow();
	}
	isCompleted = collectionSystemSubScript.GetItemList(cInfo, cData, iIonfos);
	i = 0;
	while((i < iIonfos.Length))
	{
		GetItemWndByIndex(i).Clear();
		GetItemWndByIndex(i).AddItem(iIonfos[i]);
		GetItemWndByIndex(i).EnableWindow();
		GetItemRegistrationTextureHandle(i).HideWindow();
		GetNotEnoughEnchantedTextureHandle(i).HideWindow();
		GetOverEnchantedTextureHandle(i).HideWindow();
		SetReplaceTooltip(cData, i);
		GetOverTextureHandle(i).HideWindow();
		notEnoughEnchantedList.Length = 0;
		haveNotEnoughList.Length = 0;
		overNeedEnchantList.Length = 0;
		if((cInfo.ItemInfo[i].nItemClassID > 0))
		{
			i++;
			continue;
		}
		canregist = CanRegistration(cData, i, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList);
		if(canregist)
		{
			Debug((("CanRegistration" @ string(i)) @ string(notEnoughEnchantedList.Length)));
			GetItemRegistrationTextureHandle(i).ShowWindow();
			i++;
			continue;
		}
		if((notEnoughEnchantedList.Length > 0))
		{
			Debug((("notEnoughEnchantedList.length" @ string(i)) @ string(notEnoughEnchantedList.Length)));
			GetNotEnoughEnchantedTextureHandle(i).ShowWindow();
			i++;
			continue;
		}
		if((haveNotEnoughList.Length > 0))
		{
			Debug((("haveNotEnoughList.length" @ string(i)) @ string(haveNotEnoughList.Length)));
			GetNotEnoughEnchantedTextureHandle(i).ShowWindow();
			i++;
			continue;
		}
		if((overNeedEnchantList.Length > 0))
		{
			Debug((("overNeedEnchantList.length" @ string(i)) @ string(overNeedEnchantList.Length)));
			GetOverEnchantedTextureHandle(i).ShowWindow();
		}
		i++;
	}
	i = i;
	while((i < 6))
	{
		GetItemWndByIndex(i).Clear();
		GetItemWndByIndex(i).DisableWindow();
		GetItemReplace_Btn(i).HideWindow();
		GetItemReplace_Tex(i).HideWindow();
		GetOverTextureHandle(i).HideWindow();
		GetItemRegistrationTextureHandle(i).HideWindow();
		GetNotEnoughEnchantedTextureHandle(i).HideWindow();
		GetOverEnchantedTextureHandle(i).HideWindow();
		i++;
	}
	RewardItem_ItemWnd.Clear();
	RewardSkill_ItemWnd.Clear();
	if((cData.RewardItems.Length > 0))
	{
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(cData.RewardItems[0].ItemID), iInfo);
		iInfo.ItemNum = INT64(cData.RewardItems[0].ItemCount);
		if((iInfo.ItemNum > INT64(0)))
		{
			iInfo.bShowCount = true;
		}
		RewardItem_ItemWnd.AddItem(iInfo);
		if((isCompleted && cInfo.isReward))
		{
			GetItem_Tex.ShowWindow();
		}
	}
	if((cData.RewardSkills.Length > 0))
	{
		GetSkillInfo(cData.RewardSkills[0].SkillID, cData.RewardSkills[0].SkillLevel, 0, SkillInfo);
		RewardSkill_ItemWnd.AddItem(getItemInfoBySkillInfo(SkillInfo));
		if(isCompleted)
		{
			GetSkill_Tex.ShowWindow();
		}
	}
	if(isCompleted)
	{
		Complete_tex.ShowWindow();
	}
	if((((cData.RewardItems.Length > 0) && !cInfo.isReward) && isCompleted))
	{
		Reward_Btn.EnableWindow();
	}
	else
	{
		Reward_Btn.DisableWindow();
	}
	NeedItemDialogHide();
	return true;
}

function HndleShowItemRegistrationList()
{
	local int i;
	local ItemInfo mainiInfo;
	local array<ItemInfo> iInfos, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList, mainInfos;

	ItemRegistrationList_ItemWnd.Clear();
	ItemRegistrationList_Wnd.ShowWindow();
	GetItemWndByIndex(currentSlotID).GetItem(0, mainiInfo);
	Class'NWindow.UIAPI_WINDOW'.static.SetAnchor((m_Windowname $ ".PopupDetailsContents.ItemAllow_Tex"), ((m_Windowname $ ".PopupDetailsContents.Item_ItemWnd") $ Int2Str2(currentSlotID)), "BottomRight", "BottomRight", 8, 8);
	ItemAllow_Tex.ShowWindow();
	iInfos = GetCanRegisrationsCurrentSlot(currentSlotID, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList);
	i = 0;
	while((i < iInfos.Length))
	{
		iInfos[i].bDisabled = 0;
		if((mainiInfo.Id.ClassID == iInfos[i].Id.ClassID))
		{
			mainInfos[mainInfos.Length] = iInfos[i];
			i++;
			continue;
		}
		ItemRegistrationList_ItemWnd.AddItem(iInfos[i]);
		i++;
	}
	i = 0;
	while((i < notEnoughEnchantedList.Length))
	{
		notEnoughEnchantedList[i].bDisabled = 1;
		if((mainiInfo.Id.ClassID == notEnoughEnchantedList[i].Id.ClassID))
		{
			mainInfos[mainInfos.Length] = notEnoughEnchantedList[i];
			i++;
			continue;
		}
		ItemRegistrationList_ItemWnd.AddItem(notEnoughEnchantedList[i]);
		i++;
	}
	i = 0;
	while((i < haveNotEnoughList.Length))
	{
		haveNotEnoughList[i].bDisabled = 1;
		if((mainiInfo.Id.ClassID == haveNotEnoughList[i].Id.ClassID))
		{
			mainInfos[mainInfos.Length] = haveNotEnoughList[i];
			i++;
			continue;
		}
		ItemRegistrationList_ItemWnd.AddItem(haveNotEnoughList[i]);
		i++;
	}
	i = 0;
	while((i < overNeedEnchantList.Length))
	{
		overNeedEnchantList[i].bDisabled = 1;
		if((mainiInfo.Id.ClassID == overNeedEnchantList[i].Id.ClassID))
		{
			mainInfos[mainInfos.Length] = overNeedEnchantList[i];
			i++;
			continue;
		}
		ItemRegistrationList_ItemWnd.AddItem(overNeedEnchantList[i]);
		i++;
	}
	i = 0;
	while((i < mainInfos.Length))
	{
		ItemRegistrationList_ItemWnd.AddItem(mainInfos[i]);
		i++;
	}
	Registration_Btn.DisableWindow();
	return;
}

function HandleHideItemRegistrationList()
{
	ItemRegistrationList_Wnd.HideWindow();
	ItemAllow_Tex.HideWindow();
	NeedItemDialogHide();
	return;
}

function ItemWindowHandle GetItemWndByIndex(int Index)
{
	return GetItemWindowHandle(((m_Windowname $ ".PopupDetailsContents.Item_ItemWnd") $ Int2Str2(Index)));
}

function ButtonHandle GetItemReplace_Btn(int Index)
{
	return GetButtonHandle(((m_Windowname $ ".PopupDetailsContents.ItemReplace_Btn") $ Int2Str2(Index)));
}

function TextureHandle GetItemReplace_Tex(int Index)
{
	return GetTextureHandle(((m_Windowname $ ".PopupDetailsContents.ItemReplace_Tex") $ Int2Str2(Index)));
}

function TextureHandle GetOverTextureHandle(int Index)
{
	return GetTextureHandle((((m_Windowname $ ".PopupDetailsContents.Item") $ Int2Str2(Index)) $ "_Over_tex"));
}

function TextureHandle GetItemRegistrationTextureHandle(int Index)
{
	return GetTextureHandle(((m_Windowname $ ".PopupDetailsContents.ItemRegistration_Tex") $ Int2Str2(Index)));
}

function TextureHandle GetNotEnoughEnchantedTextureHandle(int Index)
{
	return GetTextureHandle(((m_Windowname $ ".PopupDetailsContents.ItemInsufficient_Tex") $ Int2Str2(Index)));
}

function TextureHandle GetOverEnchantedTextureHandle(int Index)
{
	return GetTextureHandle(((m_Windowname $ ".PopupDetailsContents.ItemOverEnchant_Tex") $ Int2Str2(Index)));
}

function ShowContextMenu(int X, int Y, array<ItemInfo> iItemInfos)
{
	local int i;
	local UIControlContextMenu ContextMenu;

	ContextMenu = Class'Interface.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	i = 0;
	while((i < iItemInfos.Length))
	{
		ContextMenu.MenuAddRecord(MenuRecord(iItemInfos[i]));
		ContextMenu.menuObjects[i].iconHeight = 32;
		ContextMenu.menuObjects[i].iconWidth = 32;
		ContextMenu.menuObjects[i].Icon = iItemInfos[i].IconName;
		ContextMenu.menuObjects[i].Name = GetItemNameAll(iItemInfos[i]);
		i++;
	}
	ContextMenu.SetMenuHeight(36);
	ContextMenu.Show(X, Y, string(self));
	return;
}

function RichListCtrlRowData MenuRecord(ItemInfo iInfo)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 1;
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, iInfo, 32, 32);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, GetItemNameAll(iInfo), getInstanceL2Util().BrightWhite, false, 2, 2);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, ("x" $ string(iInfo.ItemNum)), getInstanceL2Util().BrightWhite, true, 35, 1);
	return Record;
}

function Init()
{
	Complete_Ani.Stop();
	Complete_Ani.HideWindow();
	GetItem_Tex.HideWindow();
	GetSkill_Tex.HideWindow();
	HandleHideItemRegistrationList();
	SetDetails();
	return;
}

function SetScript_UIControlNeedItemDialog()
{
	local WindowHandle ItemRegistrationConfirm_Wnd;

	ItemRegistrationConfirm_Wnd = GetWindowHandle((m_Windowname $ ".ItemRegistrationConfirm_Wnd"));
	ItemRegistrationConfirm_Wnd.SetScript("UIControlNeedItemDialog");
	needItemDialogScript = UIControlNeedItemDialog(ItemRegistrationConfirm_Wnd.GetScript());
	needItemDialogScript.SetWindow((m_Windowname $ ".ItemRegistrationConfirm_Wnd"));
	needItemDialogScript.DelegateOnClickCancleButton = OnClickHideDialog;
	needItemDialogScript.DelegateOnClickOkButton = OnClickOkDialog;
	return;
}

function OnClickHideDialog(optional int nDialogKey)
{
	NeedItemDialogHide();
	return;
}

function OnClickOkDialog(optional int nDialogKey)
{
	local ItemInfo iInfo;

	NeedItemDialogHide();
	ItemRegistrationList_ItemWnd.GetSelectedItem(iInfo);
	collectionSystemScript.API_C_EX_COLLECTION_REGISTER(CollectionID, currentSlotID, iInfo.Id.ServerID);
	return;
}

function HandleCollectionRegisted(int tmpCollectionID, optional int nRecursive)
{
	if((CollectionID != tmpCollectionID))
	{
		collectionSystemScript.SetState(Sub);
	}
	if((nRecursive == 1))
	{
		bRecursive = true;
	}
	else
	{
		bRecursive = false;
	}
	Init();
	return;
}

function HandleCompleted(int tmpCollectionID)
{
	local CollectionData cData;

	if((CollectionID != tmpCollectionID))
	{
		collectionSystemScript.SetState(Sub);
	}
	Init();
	collectionSystemScript.API_GetCollectionData(tmpCollectionID, cData);
	Complete_tex.HideWindow();
	Complete_Ani.ShowWindow();
	Complete_Ani.Stop();
	Complete_Ani.SetLoopCount(1);
	Complete_Ani.Play();
	if((cData.RewardSkills.Length > 0))
	{
		GetSkill_Ani.ShowWindow();
		GetSkill_Ani.Stop();
		GetSkill_Ani.SetLoopCount(1);
		GetSkill_Ani.Play();
	}
	return;
}

function HandleReceiveReward(int tmpCollectionID)
{
	if((CollectionID != tmpCollectionID))
	{
		collectionSystemScript.SetState(Sub);
	}
	Init();
	GetItem_Tex.HideWindow();
	GetItem_Ani.ShowWindow();
	GetItem_Ani.Stop();
	GetItem_Ani.SetLoopCount(1);
	GetItem_Ani.Play();
	return;
}

function bool CanRegistration(CollectionData cData, int SlotID, out array<ItemInfo> notEnoughEnchantedList, out array<ItemInfo> haveNotEnoughList, out array<ItemInfo> overNeedEnchantList)
{
	local array<ItemInfo> iInfos;

	iInfos = GetCanRegisrations(cData, SlotID, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList);
	return (iInfos.Length > 0);
}

function array<ItemInfo> GetCanRegisrationsCurrentSlot(int SlotID, out array<ItemInfo> notEnoughEnchantedList, out array<ItemInfo> haveNotEnoughList, out array<ItemInfo> overNeedEnchantList)
{
	local array<ItemInfo> iInfos;
	local CollectionData cData;

	if(!collectionSystemScript.API_GetCollectionData(CollectionID, cData))
	{
		return iInfos;
	}
	iInfos = GetCanRegisrations(cData, SlotID, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList);
	return iInfos;
}

function array<ItemInfo> GetCanRegisrations(CollectionData cData, int SlotID, out array<ItemInfo> notEnoughEnchantedList, out array<ItemInfo> haveNotEnoughList, out array<ItemInfo> overNeedEnchantList)
{
	local int i, j, ClassID;
	local array<ItemInfo> iInfos, iInfosResult;
	local UIScript.CollectionRegistFailReason failReason;
	local bool canregist;

	notEnoughEnchantedList.Length = 0;
	haveNotEnoughList.Length = 0;
	overNeedEnchantList.Length = 0;
	i = 0;
	while((i < cData.SlotItems.Length))
	{
		if((cData.SlotItems[i].SlotID != SlotID))
		{
			i++;
			continue;
		}
		iInfos.Length = 0;
		ClassID = cData.SlotItems[i].ItemID;
		FindItemByClassIDFilter(ClassID, iInfos);
		j = 0;
		while((j < iInfos.Length))
		{
			canregist = collectionSystemScript.API_IsCollectionRegistEnableItemWithReason(iInfos[j].Id, cData.collection_ID, SlotID, failReason);
			if((!canregist && (int(failReason) == 0)))
			{
				j++;
				continue;
			}
			iInfos[j].Reserved64 = INT64(cData.SlotItems[i].ItemCount);
			switch(failReason)
			{
				case CRFR_UnderNeedEnchant:
					notEnoughEnchantedList[notEnoughEnchantedList.Length] = iInfos[j];
					break;
				case CRFR_HaveNotEnoughItem:
					haveNotEnoughList[haveNotEnoughList.Length] = iInfos[j];
					break;
				case CRFR_OverNeedEnchant:
					overNeedEnchantList[overNeedEnchantList.Length] = iInfos[j];
					break;
				default:
					iInfosResult[iInfosResult.Length] = iInfos[j];
					break;
			}
			j++;
		}
		i++;
	}
	return iInfosResult;
}

function bool GetReplaceItems(CollectionData cData, int SlotID, out array<ItemInfo> replaceInfos)
{
	local int i;
	local ItemInfo iInfo;

	i = 0;
	while((i < cData.SlotItems.Length))
	{
		if((cData.SlotItems[i].SlotID == SlotID))
		{
			if((cData.SlotItems[i].Representative == false))
			{
				getSlotItemInfo(cData.SlotItems[i], iInfo);
				replaceInfos[replaceInfos.Length] = iInfo;
			}
		}
		i++;
	}
	return (replaceInfos.Length > 0);
}

function bool getSlotItemInfo(CollectionSlotItem cSItem, out ItemInfo slotItemInfo)
{
	if(!Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(cSItem.ItemID), slotItemInfo))
	{
		return false;
	}
	slotItemInfo.IsBlessedItem = false;
	slotItemInfo.Enchanted = cSItem.EnchantCondition;
	slotItemInfo.ItemNum = INT64(cSItem.ItemCount);
	slotItemInfo.BlessPanelDrawType = EBlessPanelDrawType(cSItem.BlessCondition);
	slotItemInfo.bShowCount = IsStackableItem(slotItemInfo.ConsumeType);
	return true;
}

function NeedItemDialogHide()
{
	needItemDialogScript.Hide();
	ItemRegistrationList_ItemWnd.EnableWindow();
	GetButtonHandle((m_Windowname $ ".ItemRegistrationList_Wnd.ItemRegistrationListClose_Btn")).EnableWindow();
	GetButtonHandle((m_Windowname $ ".PopupDetailsContents.Close_Btn")).EnableWindow();
	GetButtonHandle((m_Windowname $ ".PopupDetailsContents.OK_Btn")).EnableWindow();
	CheckRegistBtn();
	return;
}

function NeedItemDialogShow()
{
	needItemDialogScript.Show();
	ItemRegistrationList_ItemWnd.DisableWindow();
	GetButtonHandle((m_Windowname $ ".ItemRegistrationList_Wnd.ItemRegistrationListClose_Btn")).DisableWindow();
	GetButtonHandle((m_Windowname $ ".PopupDetailsContents.Close_Btn")).DisableWindow();
	GetButtonHandle((m_Windowname $ ".PopupDetailsContents.OK_Btn")).DisableWindow();
	CheckRegistBtn();
	return;
}

function OnClickEsc()
{
	if(needItemDialogScript.Me.IsShowWindow())
	{
		NeedItemDialogHide();
	}
	else if(ItemRegistrationList_Wnd.IsShowWindow())
	{
		HandleHideItemRegistrationList();
	}
	else
	{
		collectionSystemScript.SetState(Sub);
	}
	return;
}

function ItemInfo getItemInfoBySkillInfo(SkillInfo rSkilInfo)
{
	local ItemInfo infItem;

	infItem.Id.ClassID = rSkilInfo.SkillID;
	infItem.Level = 1;
	infItem.SubLevel = 0;
	infItem.Name = rSkilInfo.SkillName;
	infItem.IconName = rSkilInfo.TexName;
	infItem.IconPanel = rSkilInfo.IconPanel;
	infItem.Description = rSkilInfo.SkillDesc;
	infItem.ShortcutType = 2;
	infItem.ItemType = 1;
	return infItem;
}

function string Int2Str2(int i)
{
	if((i < 10))
	{
		return ("0" $ string(i));
	}
	return string(i);
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
	if(!CheckBtnName(btnName, someString))
	{
		return false;
	}
	strID = Mid(btnName, Len(someString));
	return true;
}

function bool CheckBtnName(string btnName, string someString)
{
	return (Left(btnName, Len(someString)) == someString);
}

function bool ChkSerVer()
{
	return getInstanceUIData().GetIsLiveServer();
}

function string GetEndDateTime(string endDateTime)
{
	local array<string> endDatatimes;

	if((endDateTime == ""))
	{
		return "";
	}
	Split(endDateTime, "T", endDatatimes);
	if(((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)))
	{
		return (GetSystemString(13714) @ endDatatimes[0]);
	}
	return (endDatatimes[0] @ GetSystemString(13714));
}

function string _GetResetTimeString(int RemainTime)
{
	if((RemainTime > 0))
	{
		return GetSystemString(14877);
	}
	else
	{
		return GetSystemString(14876);
	}
}

function string GetRemainTimeString(int Period, int RemainTime)
{
	local string periodStr, dateString, timeString;

	if((((Period / 60) / 60) > 24))
	{
		periodStr = string((((Period / 60) / 60) / 24));
		dateString = GetSystemString(1109);
	}
	else
	{
		periodStr = string(((Period / 60) / 60));
		dateString = GetSystemString(1110);
	}
	if((RemainTime > 0))
	{
		timeString = util.getTimeStringBySec2(RemainTime);
		if((timeString != ""))
		{
			timeString = ("-" @ timeString);
		}
		return (MakeFullSystemMsg(GetSystemMessage(13314), (periodStr $ dateString)) @ timeString);
	}
	return MakeFullSystemMsg(GetSystemMessage(13314), (periodStr $ dateString));
}
