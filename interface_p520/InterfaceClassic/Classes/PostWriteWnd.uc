class PostWriteWnd extends UICommonAPI
	dependson(UIPacket);

const FEEMUITIPLIER = 2;
const MAX_APPEND_ITEM_NUM = 8;
const DIALOG_STACKABLE_ITEM_ACCOMPANY_TO_INVEN = 1111;
const DIALOG_STACKABLE_ITEM_INVEN_TO_ACCOMPANY = 2222;
const DIALOG_RECEIVE_ADENA = 3333;
const DIALOG_NOTIFY_SEND_POST = 4444;
const MAX_CHAR_LENGTH = 24;
const MAX_TITLE_LENGTH = 50;
const MAX_CONTENTS_LENGTH = 1000;
const MAX_ITEMNUM_MAX_ADENA_ADENSERVER = 10000000000;
const MAX_ITEMNUM_MAX_ADENSERVER = 1000000;
const MAX_PAGE_ITEM_NUM = 24;

enum PostType
{
	gernal,                         // 0
	safety                          // 1
};

var WindowHandle PostBoxWnd;
var WindowHandle PostDetailWnd_General;
var WindowHandle PostDetailWnd_SafetyTrade;
var TextureHandle SafetyReceiveAdenaIcon;
var TextBoxHandle ChargeAdenaText;
var TextBoxHandle ChargeLcoinText;
var TextBoxHandle Title_SafetyTradeAdena;
var WindowHandle ChargeLcoinWnd;
var UIControlTextInput ReceiverID;
var UIControlTextInput PostTitle;
var UIControlTextInput SafetyTradeAdenaTextBox;
var ButtonHandle SafetyReceiveAdena;
var MultiEditBoxHandle contents;
var ButtonHandle sendBtn;
var ItemWindowHandle AccompanyItem;
var ItemWindowHandle InventoryItem;
var TextureHandle effectTexture00;
var TextureHandle effectTexture01;
var TextureHandle effectTexture02;
var bool bOpenPostReceiverList;
var string strSendID;
var array<RequestItem> itemIDList;
var ItemInfo adenaInfo;
var int curTradeType;
var PostType currentPostType;
var Color disableColor;
var Color enableColor;
var TextBoxHandle Wintitle_tex;
var WindowHandle SafetyTradeAdena_win;
var WindowHandle disableWnd;
var UIControlDialogAssets uicontrolDialogAssetScr;
var L2UITweenTwinkleObject twinkleObject;
var PostFeeSettingData postFeeData;
var PostBillingData billingData;

function InitializeCOD()
{
	PostBoxWnd = GetWindowHandle("PostBoxWnd");
	PostDetailWnd_General = GetWindowHandle("PostDetailWnd_General");
	PostDetailWnd_SafetyTrade = GetWindowHandle("PostDetailWnd_SafetyTrade");
	ChargeAdenaText = GetTextBoxHandle("PostWriteWnd.ChargeAdenaText");
	ChargeLcoinText = GetTextBoxHandle("PostWriteWnd.ChargeLcoinWnd.ChargeLcoinText");
	ChargeLcoinWnd = GetWindowHandle("PostWriteWnd.ChargeLcoinWnd");
	Title_SafetyTradeAdena = GetTextBoxHandle("PostWriteWnd.SafetyTradeAdena_win.Title_SafetyTradeAdena");
	SafetyReceiveAdenaIcon = GetTextureHandle("PostWriteWnd.SafetyTradeAdena_win.SafetyReceiveAdenaIcon");
	contents = GetMultiEditBoxHandle("PostWriteWnd.PostContents");
	AccompanyItem = GetItemWindowHandle("PostWriteWnd.AccompanyItem");
	InventoryItem = GetItemWindowHandle("PostWriteWnd.InventoryItem");
	sendBtn = GetButtonHandle("PostWriteWnd.SendBtn");
	SafetyReceiveAdena = GetButtonHandle("PostWriteWnd.SafetyTradeAdena_win.SafetyReceiveAdena");
	Wintitle_tex = GetTextBoxHandle("PostWriteWnd.Wintitle_tex");
	SafetyTradeAdena_win = GetWindowHandle("PostWriteWnd.SafetyTradeAdena_win");
	disableWnd = GetWindowHandle("PostWriteWnd.disableWindow");
	effectTexture00 = GetTextureHandle("postWriteWnd.effectTexture00");
	effectTexture01 = GetTextureHandle("postWriteWnd.effectTexture01");
	effectTexture02 = GetTextureHandle("postWriteWnd.effectTexture02");
	effectTexture00.SetAlpha(0);
	effectTexture01.SetAlpha(0);
	effectTexture02.SetAlpha(0);
	InitUIControlDialogAsset();
	SetUIControlTextInput();
	return;
}

function SetTweenTwinkle(int Step)
{
	twinkleObject._Stop();
	effectTexture00.SetAlpha(0);
	effectTexture01.SetAlpha(0);
	effectTexture02.SetAlpha(0);
	switch(Step)
	{
		case 0:
			twinkleObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(effectTexture00, 3.5000000, 0.5000000, 800.0000000, 0, 255, 0.0000000);
			break;
		case 1:
			twinkleObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(effectTexture01, 3.5000000, 0.5000000, 800.0000000, 0, 255, 0.0000000);
			break;
		case 2:
			twinkleObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(effectTexture02, 3.5000000, 0.5000000, 800.0000000, 0, 255, 0.0000000);
			break;
		default:
			break;
	}
	return;
}

function SetUIControlTextInput()
{
	ReceiverID = Class'InterfaceClassic.UIControlTextInput'.static.InitScript(GetWindowHandle("PostWriteWnd.ReceiverID"));
	ReceiverID.DelegateESCKey = DelegateESCKey;
	ReceiverID.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	ReceiverID.DelegateOnKeyUP = DelegateOnKeyUP;
	ReceiverID.SetMaxLength(24);
	ReceiverID.SetDefaultString(GetSystemString(13792));
	ReceiverID.SetEdtiable(true);
	PostTitle = Class'InterfaceClassic.UIControlTextInput'.static.InitScript(GetWindowHandle("PostWriteWnd.PostTitle"));
	PostTitle.DelegateESCKey = DelegateESCKey;
	PostTitle.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	PostTitle.DelegateOnKeyUP = DelegateOnKeyUP;
	PostTitle.SetMaxLength(50);
	PostTitle.SetDefaultString(GetSystemString(14727));
	PostTitle.SetEdtiable(true);
	PostTitle._UseCostString(false);
	SafetyTradeAdenaTextBox = Class'InterfaceClassic.UIControlTextInput'.static.InitScript(GetWindowHandle("PostWriteWnd.SafetyTradeAdena_win.SafetyTradeAdenaTextBox"));
	SafetyTradeAdenaTextBox.DelegateESCKey = DelegateESCKey;
	SafetyTradeAdenaTextBox.DelegateOnChangeEdited = DelegateOnChangeEdited;
	SafetyTradeAdenaTextBox.DelegateOnClear = DelegateOnClear;
	SafetyTradeAdenaTextBox.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	SafetyTradeAdenaTextBox.DelegateOnKeyUP = DelegateOnKeyUP;
	SafetyTradeAdenaTextBox.SetEdtiable(true);
	SafetyTradeAdenaTextBox._SetEditType("number");
	SafetyTradeAdenaTextBox._UseNumericColor(true);
	SafetyTradeAdenaTextBox._UseCostString(true);
	return;
}

function DelegateOnKeyUP(Interactions.EInputKey nKey)
{
	OnKeyUp(none, nKey);
	return;
}

function DelegateESCKey()
{
	return;
}

function DelegateOnClear()
{
	SafetyTradeAdenaTextBox._SetExtraString("");
	return;
}

function DelegateOnChangeEdited(string Text)
{
	SetCalculateBillingExtra(Text);
	return;
}

function DelegateOnCompleteEditBox(string Text)
{
	SetCalculateBillingExtra(Text);
	RotateFocusEditbox();
	return;
}

function InitUIControlDialogAsset()
{
	local WindowHandle assetWnd;

	assetWnd = GetWindowHandle("PostWriteWnd.DisableWindow.UIControlDialogAsset");
	uicontrolDialogAssetScr = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(assetWnd);
	uicontrolDialogAssetScr.SetDisableWindow(disableWnd);
	uicontrolDialogAssetScr.DelegateOnCancel = OnClickPopupCancel;
	uicontrolDialogAssetScr.DelegateOnClickBuy = OnClickPopupOK;
	uicontrolDialogAssetScr.SetUseBuyItem(false);
	uicontrolDialogAssetScr.SetUseNeedItem(true);
	uicontrolDialogAssetScr.SetUseNumberInput(false);
	uicontrolDialogAssetScr.StartNeedItemList(2);
	return;
}

function ToWrite(string Name)
{
	ReceiverID.SetString(Name);
	return;
}

function SetBoolPostReceiverList(bool B)
{
	bOpenPostReceiverList = B;
	return;
}

function SetPostWriteWnd(string senderName, string Title, string Context)
{
	ClearAll();
	ReceiverID.SetString(senderName);
	PostTitle.SetString(Title);
	contents.SetString(Context);
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if((int(nKey) == 9))
	{
		RotateFocusEditbox();
	}
	return false;
}

function RotateFocusEditbox()
{
	if(IsKeyDown(IK_Shift))
	{
		if(ReceiverID._IsFocused())
		{
			SafetyTradeAdenaTextBox.Focus();
		}
		else if(PostTitle._IsFocused())
		{
			ReceiverID.Focus();
		}
		else if(contents.IsFocused())
		{
			PostTitle.Focus();
		}
		else if(SafetyTradeAdenaTextBox._IsFocused())
		{
			contents.SetFocus();
		}
	}
	else if(ReceiverID._IsFocused())
	{
		PostTitle.Focus();
	}
	else if(PostTitle._IsFocused())
	{
		contents.SetFocus();
	}
	else if(contents.IsFocused())
	{
		SafetyTradeAdenaTextBox.Focus();
	}
	else if(SafetyTradeAdenaTextBox._IsFocused())
	{
		ReceiverID.Focus();
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(4790);
	RegisterEvent(4791);
	RegisterEvent(4792);
	RegisterEvent(1710);
	RegisterEvent(4799);
	RegisterEvent(EV_PacketID(437));
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	InitializeCOD();
	m_hOwnerWnd.HideWindow();
	enableColor.R = 220;
	enableColor.G = 220;
	enableColor.B = 220;
	disableColor.R = 130;
	disableColor.G = 130;
	disableColor.B = 130;
	ClearAll();
	bOpenPostReceiverList = false;
	return;
}

event OnTick()
{
	SetEnableWindowInputsText();
	m_hOwnerWnd.DisableTick();
	return;
}

event OnShow()
{
	SetDisableWindowInputsText();
	if(PostBoxWnd.IsShowWindow())
	{
		PostBoxWnd.HideWindow();
	}
	if(PostDetailWnd_General.IsShowWindow())
	{
		PostDetailWnd_General.HideWindow();
	}
	if(PostDetailWnd_SafetyTrade.IsShowWindow())
	{
		PostDetailWnd_SafetyTrade.HideWindow();
	}
	if((ReceiverID.GetString() == ""))
	{
		ReceiverID.Focus();
	}
	else
	{
		contents.SetFocus();
	}
	m_hOwnerWnd.SetAnchor("PostBoxWnd", "TopCenter", "TopCenter", 0, 0);
	SafetyTradeAdenaTextBox._ClearTooltip();
	uicontrolDialogAssetScr.Hide();
	disableWnd.HideWindow();
	m_hOwnerWnd.EnableTick();
	return;
}

event OnHide()
{
	if(DialogIsMine())
	{
		Class'InterfaceClassic.DialogBox'.static.Inst().HideDialog();
	}
	return;
}

event OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		case "SendBtn":
			HandleSendBtn();
			break;
		case "SafetyReceiveAdena":
			HandleSafetyReceiveAdena();
			break;
		case "ReceiverListBtn":
			OnReceiverListButton();
			break;
		case "BackWin_BTN":
			HandleBack();
			break;
		case "AddBtn":
			HandleAddBtn();
			break;
		default:
			break;
	}
	return;
}

function HandleAddBtn()
{
	local UserInfo UserInfo;
	local string UserName, AddName;

	AddName = ReceiverID.GetString();
	if(GetPlayerInfo(UserInfo))
	{
		UserName = UserInfo.Name;
	}
	if((AddName != ""))
	{
		if((UserName == AddName))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3221));
		}
		else if(PostReceiverListAddWnd(GetScript("PostReceiverListAddWnd")).SearchPostFriend(AddName))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3216));
		}
		else
		{
			Class'NWindow.PostWndAPI'.static.RequestAddingPostFriend(AddName);
		}
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(2270));
	}
	return;
}

event OnDropItem(string strID, ItemInfo infItem, int X, int Y)
{
	if(((strID == "AccompanyItem") && (infItem.DragSrcName == "InventoryItem")))
	{
		UseInvenToAccompany(infItem);
	}
	else if(((strID == "InventoryItem") && (infItem.DragSrcName == "AccompanyItem")))
	{
		UseAccompanyToInven(infItem);
	}
	return;
}

event OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	local ItemInfo Info;

	if(a_hItemWindow.GetItem(Index, Info))
	{
		if((a_hItemWindow.GetWindowName() == "AccompanyItem"))
		{
			UseAccompanyToInven(Info);
		}
		else if((a_hItemWindow.GetWindowName() == "InventoryItem"))
		{
			UseInvenToAccompany(Info);
		}
	}
	return;
}

event OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	local ItemInfo Info;

	if(a_hItemWindow.GetItem(Index, Info))
	{
		if((a_hItemWindow.GetWindowName() == "AccompanyItem"))
		{
			UseAccompanyToInven(Info);
		}
		else if((a_hItemWindow.GetWindowName() == "InventoryItem"))
		{
			UseInvenToAccompany(Info);
		}
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			HandleSetForm();
			break;
		case 4790:
			HandlePostWriteOpen();
			break;
		case 4791:
			HandleSentEnableAddItem(param);
			break;
		case 4792:
			HandlePostWriteEnd();
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 4799:
			HandleReplyWritePost(param);
			break;
		case 40:
			ReceiverID._ClearHistory();
			break;
		case EV_PacketID(437):
			RT_S_EX_POST_ITEM_FEE();
			break;
		default:
			break;
	}
	return;
}

event OnReceivedCloseUI()
{
	HandleBack();
	return;
}

function HandleSetForm()
{
	API_GetPostFeeSettingData(postFeeData);
	API_GetPostBillingData(billingData);
	if((billingData.MinBilling == 0))
	{
		billingData.MinBilling = 1;
	}
	ChargeAdenaText.SetText(MakeCostStringINT64(CalculateFeeAdena()));
	if(IsAdenServer())
	{
		GetTextBoxHandle("PostWriteWnd.Description_Txt").SetText(MakeFullSystemMsg(GetSystemMessage(14011), MakeCostString(string(postFeeData.SlotPerFee))));
	}
	else
	{
		GetTextBoxHandle("PostWriteWnd.Description_Txt").SetText(MakeFullSystemMsg(GetSystemMessage(14021), MakeCostString(string(postFeeData.SlotPerFee))));
	}
	SafetyTradeAdenaTextBox._SetLimitNum(billingData.MaxBilling);
	if((billingData.MinBilling > 0))
	{
		SafetyTradeAdenaTextBox.SetDefaultString(((GetSystemString(13267) $ ":") @ MakeCostStringINT64(INT64(billingData.MinBilling))));
	}
	else
	{
		SafetyTradeAdenaTextBox.SetDefaultString("0");
	}
	if(IsAdenServer())
	{
		ChargeLcoinWnd.ShowWindow();
	}
	else
	{
		ChargeLcoinWnd.HideWindow();
	}
	return;
}

function HandlePostWriteOpen()
{
	if(PostBoxWnd.IsShowWindow())
	{
		PostBoxWnd.HideWindow();
	}
	return;
}

function HandleSentEnableAddItem(string param)
{
	local ItemInfo Info;

	ParamToItemInfo(param, Info);
	InventoryItem.AddItem(Info);
	if((Info.Id.ClassID == 57))
	{
		adenaInfo = Info;
		InventoryItem.SwapItems(0, (InventoryItem.GetItemNum() - 1));
	}
	return;
}

function HandlePostWriteEnd()
{
	return;
}

function HandleReplyWritePost(string param)
{
	local int iSuccess;

	ParseInt(param, "Success", iSuccess);
	if((iSuccess == 1))
	{
		ReceiverID._AddItemToAutoCompleteHistory(ReceiverID.GetString());
		m_hOwnerWnd.HideWindow();
		ClearAll();
	}
	return;
}

function HandleSendBtn()
{
	DialogHide();
	if((ReceiverID.GetString() == ""))
	{
		ReceiverID.Focus();
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(2007));
		SetTweenTwinkle(0);
	}
	else if(((int(currentPostType) == 1) && (AccompanyItem.GetItemNum() <= 0)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(2966));
		SetTweenTwinkle(1);
	}
	else if(((int(currentPostType) == 1) && ((GetSafetyTradeAdena() == INT64(0)) || (INT64(SafetyTradeAdenaTextBox.GetString()) < INT64(billingData.MinBilling)))))
	{
		SetTweenTwinkle(2);
		SafetyTradeAdenaTextBox.Focus();
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(3020), MakeCostStringINT64(INT64(billingData.MinBilling))));
	}
	else if((Len(ReceiverID.GetString()) > 24))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3074));
	}
	else if((Len(PostTitle.GetString()) > 50))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3075));
	}
	else if((Len(contents.GetString()) > 1000))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3076));
	}
	else
	{
		if((int(currentPostType) == 0))
		{
			if(IsAdenServer())
			{
				HandleAssetShowDialog(14701);
			}
			else
			{
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(2967));
				disableWnd.ShowWindow();
				disableWnd.SetFocus();
				Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnHide = HandleDelegateOnHide;
				Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(0, 0);
			}
		}
		else if(IsAdenServer())
		{
			HandleAssetShowDialog(14702);
		}
		else
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(3078));
			disableWnd.ShowWindow();
			disableWnd.SetFocus();
			Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnHide = HandleDelegateOnHide;
			Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(0, 0);
		}
		DialogSetID(4444);
	}
	return;
}

function HandleDelegateOnHide()
{
	disableWnd.HideWindow();
	return;
}

function INT64 GetSafetyTradeAdena()
{
	return INT64(SafetyTradeAdenaTextBox.GetString());
}

function HandleSafetyReceiveAdena()
{
	DialogSetID(3333);
	DialogShow(DialogModalType_Modal, DialogType_NumberPad, GetSystemMessage(2987));
	DialogSetParamInt64(billingData.MaxBilling);
	DialogSetInputlimit(billingData.MaxBilling);
	Class'InterfaceClassic.UICommonAPI'.static.DialogSetDefaultOK();
	Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(0, 0);
	return;
}

function SendPostMsg()
{
	local int i;
	local ItemInfo ItemInfo;
	local RequestItem item;
	local string receivername;

	itemIDList.Remove(0, itemIDList.Length);
	i = 0;
	while((i < AccompanyItem.GetItemNum()))
	{
		AccompanyItem.GetItem(i, ItemInfo);
		item.Id = ItemInfo.Id.ServerID;
		item.Amount = ItemInfo.ItemNum;
		itemIDList.Insert(itemIDList.Length, 1);
		itemIDList[(itemIDList.Length - 1)] = item;
		i++;
	}
	strSendID = ReceiverID.GetString();
	receivername = ReceiverID.GetString();
	if((Len(receivername) > 0))
	{
		switch(currentPostType)
		{
			case gernal:
				RequestSendPost(ReceiverID.GetString(), 0, GetPostTitleString(), contents.GetString(), itemIDList, INT64(0));
				break;
			case safety:
				RequestSendPost(ReceiverID.GetString(), 1, GetPostTitleString(), contents.GetString(), itemIDList, GetSafetyTradeAdena());
				break;
			default:
				break;
		}
	}
	else
	{
		AddSystemMessage(3002);
	}
	return;
}

function string GetPostTitleString()
{
	local string postTitleStr;

	postTitleStr = PostTitle.GetString();
	if((postTitleStr == ""))
	{
		return PostTitle._defaultString;
	}
	return postTitleStr;
}

function HandleBack()
{
	local string param;

	ParamAdd(param, "Name", "Post");
	ExecuteEvent(3080, param);
	GetWindowHandle("PostBoxWnd").SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "TopCenter", "TopCenter", 0, 0);
	return;
}

function OnReceiverListButton()
{
	bOpenPostReceiverList = !bOpenPostReceiverList;
	if(bOpenPostReceiverList)
	{
		GetWindowHandle("PostReceiverListWnd").ShowWindow();
		PostListUpdate();
	}
	else
	{
		PostReceiverListWnd(GetScript("PostReceiverListWnd")).selectedInit();
		GetWindowHandle("PostReceiverListWnd").HideWindow();
	}
	return;
}

function UseInvenToAccompany(ItemInfo infItem)
{
	local int AccompanyItemID;

	AccompanyItemID = AccompanyItem.FindItem(infItem.Id);
	if(((AccompanyItem.GetItemNum() == 8) && ((IsStackableItem(infItem.ConsumeType) == false) || (AccompanyItemID == -1))))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3016));
		return;
	}
	if(((IsStackableItem(infItem.ConsumeType) && (infItem.ItemNum > INT64(1))) && !Class'NWindow.InputAPI'.static.IsAltPressed()))
	{
		DialogSetID(2222);
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), infItem.Name, ""));
		DialogSetReservedItemInfo(infItem);
		DialogSetInputlimit(infItem.ItemNum);
		DialogSetParamInt64(infItem.ItemNum);
		return;
	}
	ItemInvenToAccompanyUtil(infItem, infItem.ItemNum);
	return;
}

function UseAccompanyToInven(ItemInfo infItem)
{
	if(((IsStackableItem(infItem.ConsumeType) && (infItem.ItemNum > INT64(1))) && !Class'NWindow.InputAPI'.static.IsAltPressed()))
	{
		DialogSetID(1111);
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), infItem.Name, ""));
		DialogSetReservedItemInfo(infItem);
		DialogSetParamInt64(infItem.ItemNum);
		DialogSetInputlimit(infItem.ItemNum);
	}
	else
	{
		ItemAccompanyToInvenUtil(infItem, infItem.ItemNum);
	}
	return;
}

function INT64 ItemInvenToAccompany(ItemInfo invenInfo, INT64 ItemNum)
{
	local INT64 addedItemNum;
	local int AccompanyItemID, invenItemID;
	local ItemInfo AccompanyInfo;

	invenItemID = InventoryItem.FindItem(invenInfo.Id);
	AccompanyItemID = AccompanyItem.FindItem(invenInfo.Id);
	if((AccompanyItemID == -1))
	{
		AccompanyInfo = invenInfo;
		AccompanyInfo.ItemNum = INT64(0);
	}
	else
	{
		AccompanyItem.GetItem(AccompanyItemID, AccompanyInfo);
	}
	addedItemNum = AddAccompanyInfoItemNum(AccompanyInfo, ItemNum);
	if((AccompanyItemID == -1))
	{
		AccompanyItem.AddItem(AccompanyInfo);
	}
	else
	{
		AccompanyItem.SetItem(AccompanyItemID, AccompanyInfo);
	}
	InventoryItemRefresh(invenItemID, addedItemNum);
	return addedItemNum;
}

function INT64 AddAccompanyInfoItemNum(out ItemInfo iInfo, INT64 toAdditemNum)
{
	local INT64 addedItemNum, MAXITEMNUM;

	addedItemNum = toAdditemNum;
	MAXITEMNUM = GetLimitItemNumMaxByClassID(iInfo.Id.ClassID);
	if(IsAdenServer())
	{
		if(((iInfo.ItemNum + addedItemNum) > MAXITEMNUM))
		{
			addedItemNum = (MAXITEMNUM - iInfo.ItemNum);
		}
	}
	iInfo.ItemNum = (iInfo.ItemNum + addedItemNum);
	return addedItemNum;
}

function InventoryItemRefresh(int invenItemID, INT64 AccompanyAddedItemNum)
{
	local ItemInfo invenInfo;

	InventoryItem.GetItem(invenItemID, invenInfo);
	invenInfo.ItemNum = (invenInfo.ItemNum - AccompanyAddedItemNum);
	if((invenInfo.ItemNum <= INT64(0)))
	{
		InventoryItem.DeleteItem(invenItemID);
	}
	else
	{
		InventoryItem.SetItem(invenItemID, invenInfo);
	}
	return;
}

function ItemAccompanyToInven(ItemInfo AccompanyInfo, INT64 ItemNum)
{
	local int AccompanyItemID, invenItemID;
	local ItemInfo invenInfo;

	invenItemID = InventoryItem.FindItem(AccompanyInfo.Id);
	AccompanyItemID = AccompanyItem.FindItem(AccompanyInfo.Id);
	if((invenItemID == -1))
	{
		invenInfo = AccompanyInfo;
		invenInfo.ItemNum = ItemNum;
		InventoryItem.AddItem(invenInfo);
	}
	else
	{
		InventoryItem.GetItem(invenItemID, invenInfo);
		invenInfo.ItemNum = (invenInfo.ItemNum + ItemNum);
		InventoryItem.SetItem(invenItemID, invenInfo);
	}
	AccompanyItemRefresh(AccompanyItemID, ItemNum);
	return;
}

function AccompanyItemRefresh(int AccompanyItemID, INT64 InvenAddedItemNum)
{
	local ItemInfo AccompanyInfo;

	AccompanyItem.GetItem(AccompanyItemID, AccompanyInfo);
	AccompanyInfo.ItemNum = (AccompanyInfo.ItemNum - InvenAddedItemNum);
	if((AccompanyInfo.ItemNum <= INT64(0)))
	{
		AccompanyItem.DeleteItem(AccompanyItemID);
	}
	else
	{
		AccompanyItem.SetItem(AccompanyItemID, AccompanyInfo);
	}
	return;
}

function SetDisableWindowInputsText()
{
	contents.DisableWindow();
	ReceiverID.SetDisable(true);
	PostTitle.SetDisable(true);
	return;
}

function SetEnableWindowInputsText()
{
	contents.EnableWindow();
	ReceiverID.SetDisable(false);
	PostTitle.SetDisable(false);
	ReceiverID.Focus();
	return;
}

function OnClickPopupOK()
{
	disableWnd.HideWindow();
	uicontrolDialogAssetScr.Hide();
	SendPostMsg();
	return;
}

function OnClickPopupCancel()
{
	disableWnd.HideWindow();
	uicontrolDialogAssetScr.Hide();
	return;
}

function HandleAssetShowDialog(int sysStringNum)
{
	uicontrolDialogAssetScr.SetDialogDescHtml(GetSystemString(sysStringNum));
	uicontrolDialogAssetScr.AddNeedItemClassID(91663, CaculateFeePerSlot());
	uicontrolDialogAssetScr.AddNeedItemClassID(57, CalculateFeeAdena());
	uicontrolDialogAssetScr.SetItemNum(1);
	uicontrolDialogAssetScr.Show();
	disableWnd.SetFocus();
	return;
}

function HandleDialogOK()
{
	local ItemInfo scInfo;
	local INT64 inputNum, Adena;
	local int Id;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		if((Id == 4444))
		{
			SendPostMsg();
		}
		else if((Id == 3333))
		{
			Adena = INT64(DialogGetString());
			if(((Adena > Class'InterfaceClassic.DialogBox'.static.Inst().inputLimit) || (Adena < INT64(0))))
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(1369));
			}
			else
			{
				SafetyTradeAdenaTextBox.SetString(MakeCostString(DialogGetString()));
			}
		}
		else if(((Id == 1111) || (Id == 2222)))
		{
			DialogGetReservedItemInfo(scInfo);
			inputNum = INT64(DialogGetString());
			if((inputNum > INT64(0)))
			{
				if((inputNum >= scInfo.ItemNum))
				{
					inputNum = scInfo.ItemNum;
				}
				if((Id == 1111))
				{
					ItemAccompanyToInvenUtil(scInfo, inputNum);
				}
				else if((Id == 2222))
				{
					ItemInvenToAccompanyUtil(scInfo, inputNum);
				}
			}
		}
	}
	return;
}

function DisableSafetyAdena()
{
	currentPostType = gernal;
	Title_SafetyTradeAdena.DisableWindow();
	SafetyReceiveAdena.DisableWindow();
	SafetyReceiveAdenaIcon.DisableWindow();
	Title_SafetyTradeAdena.SetTextColor(disableColor);
	SafetyTradeAdenaTextBox.SetString("");
	SafetyTradeAdenaTextBox._SetExtraString("");
	Wintitle_tex.SetText(((GetSystemString(2031) $ " - ") $ GetSystemString(2071)));
	Wintitle_tex.SetTextColor(getInstanceL2Util().White);
	SafetyTradeAdena_win.HideWindow();
	sendBtn.SetNameText(MakeFullSystemMsg(GetSystemMessage(4412), GetSystemString(2071)));
	Title_SafetyTradeAdena.SetTextColor(getInstanceL2Util().White);
	return;
}

function EnableSafetyAdena()
{
	currentPostType = safety;
	Title_SafetyTradeAdena.EnableWindow();
	SafetyReceiveAdena.EnableWindow();
	SafetyReceiveAdenaIcon.EnableWindow();
	Title_SafetyTradeAdena.SetTextColor(enableColor);
	Wintitle_tex.SetText(((GetSystemString(2031) $ " - ") $ GetSystemString(2072)));
	Wintitle_tex.SetTextColor(GetColor(220, 100, 38, 255));
	SafetyTradeAdena_win.ShowWindow();
	sendBtn.SetNameText(MakeFullSystemMsg(GetSystemMessage(4412), GetSystemString(2072)));
	Title_SafetyTradeAdena.SetTextColor(getInstanceL2Util().Yellow);
	return;
}

function SetFeeAdena()
{
	ChargeAdenaText.SetText(MakeCostStringINT64(CalculateFeeAdena()));
	if(IsAdenServer())
	{
		ChargeLcoinText.SetText(MakeCostStringINT64(CaculateFeePerSlot()));
	}
	return;
}

function ClearAll()
{
	ReceiverID.Clear();
	PostTitle.SetString("");
	SafetyTradeAdenaTextBox._SetExtraString("");
	contents.SetString("");
	itemIDList.Remove(0, itemIDList.Length);
	SafetyTradeAdenaTextBox.SetString("");
	ChargeAdenaText.SetText(MakeCostStringINT64(CalculateFeeAdena()));
	ChargeLcoinText.SetText("0");
	AccompanyItem.Clear();
	InventoryItem.Clear();
	DisableSafetyAdena();
	return;
}

function API_GetPostFeeSettingData(out PostFeeSettingData o_data)
{
	GetPostFeeSettingData(o_data);
	return;
}

function API_GetPostBillingData(out PostBillingData o_data)
{
	GetPostBillingData(o_data);
	return;
}

function INT64 API_CalculateBilling(INT64 billing)
{
	return CalculateBilling(billing);
}

function RQ_C_EX_POST_ITEM_FEE()
{
	local int i;
	local array<byte> stream;
	local ItemInfo iInfo;
	local array<UIPacket._ItemServerInfo> isInfos;
	local UIPacket._C_EX_POST_ITEM_FEE packet;

	isInfos.Length = AccompanyItem.GetItemNum();
	i = 0;
	while((i < isInfos.Length))
	{
		AccompanyItem.GetItem(i, iInfo);
		isInfos[i].nItemServerId = iInfo.Id.ServerID;
		isInfos[i].nAmount = iInfo.ItemNum;
		Debug((("RQ_C_EX_POST_ITEM_FEE" @ string(isInfos[i].nItemServerId)) @ string(isInfos[i].nAmount)));
		i++;
	}
	packet.Items = isInfos;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_POST_ITEM_FEE(stream, packet))
	{
		return;
	}
	Debug(("RQ_C_EX_POST_ITEM_FEE" @ string(packet.Items.Length)));
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(318, stream);
	return;
}

function RT_S_EX_POST_ITEM_FEE()
{
	local UIPacket._S_EX_POST_ITEM_FEE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_POST_ITEM_FEE(packet))
	{
		return;
	}
	ChargeLcoinText.SetText(MakeCostStringINT64(packet.nPostItemFee));
	Debug((" -->  Decode_S_EX_POST_ITEM_FEE : " @ string(packet.nPostItemFee)));
	return;
}

function INT64 GetLimitItemNumMaxByClassID(int ClassID)
{
	if((ClassID == 57))
	{
		return 6056184812580896770;
	}
	return INT64(1000000);
}

function ItemInvenToAccompanyUtil(ItemInfo iInfo, INT64 ItemNum)
{
	ItemInvenToAccompany(iInfo, ItemNum);
	SetFeeAdena();
	return;
}

function ItemAccompanyToInvenUtil(ItemInfo iInfo, INT64 ItemNum)
{
	ItemAccompanyToInven(iInfo, ItemNum);
	SetFeeAdena();
	return;
}

function INT64 CalculateFeeAdena()
{
	if(IsAdenServer())
	{
		return INT64(postFeeData.BaseFee);
	}
	return (INT64(postFeeData.BaseFee) + CaculateFeePerSlot());
}

function INT64 CaculateFeePerSlot()
{
	return INT64((postFeeData.SlotPerFee * AccompanyItem.GetItemNum()));
}

function PostListUpdate()
{
	Class'NWindow.PostWndAPI'.static.RequestFriendList();
	Class'NWindow.PostWndAPI'.static.RequestPledgeMemberList();
	Class'NWindow.PostWndAPI'.static.RequestPostFriendList();
	return;
}

function SetCalculateBillingExtra(string Text)
{
	local INT64 CalculateBilling;

	CalculateBilling = API_CalculateBilling(INT64(Text));
	Debug(("DelegateOnChangeEdited -- " @ Text));
	if(((int(Text) > 0) && (CalculateBilling > INT64(0))))
	{
		SafetyTradeAdenaTextBox._SetExtraString(((GetSystemString(14106) $ ": ") $ string(API_CalculateBilling(INT64(Text)))));
	}
	else
	{
		SafetyTradeAdenaTextBox._SetExtraString("");
	}
	return;
}
