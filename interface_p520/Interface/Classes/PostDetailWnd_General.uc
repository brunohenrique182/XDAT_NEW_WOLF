class PostDetailWnd_General extends UICommonAPI;

const DIALOG_RETURN_POST = 1111;
const DIALOG_NOTIFY_SEND_CANCLE_PRIMESHOP = 2222;
const DIALOG_DELETE_SELECTED_MAIL = 3333;

var WindowHandle Me;
var WindowHandle SafetyTrade;
var TextBoxHandle Title_SenderID;
var TextBoxHandle SenderID;
var TextBoxHandle PostType;
var TextBoxHandle PostTitle;
var TextListBoxHandle PostContents;
var ButtonHandle SendCancelBtn;
var ButtonHandle ReceiveBtn;
var ButtonHandle ReturnBtn;
var ButtonHandle ReplyBtn;
var ButtonHandle AddBtn;
var ButtonHandle ReceiveDelBtn;
var TextureHandle TrashCanIcon_Tex;
var ItemWindowHandle AccompanyItem;
var int TRADE;
var int returnd;
var int mailID;
var int returnAble;
var int sentBySystem;
var TextBoxHandle InventoryNum_Txt;
var TextBoxHandle InventoryPlus_Txt;
var TextBoxHandle InventoryAll_Txt;
var TextureHandle ReplyIcon_Tex;
var TextureHandle ReturnIcon_Tex;
var TextBoxHandle BottomDescription_Txt;
var bool isSentMail;

event OnRegisterEvent()
{
	RegisterEvent(4740);
	RegisterEvent(4741);
	RegisterEvent(4742);
	RegisterEvent(4780);
	RegisterEvent(4781);
	RegisterEvent(4782);
	RegisterEvent(1710);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	InitializeCOD();
	Me.HideWindow();
	return;
}

event OnShow()
{
	local Rect rectMov;

	if(SafetyTrade.IsShowWindow())
	{
		rectMov = SafetyTrade.GetRect();
		Me.MoveTo(rectMov.nX, rectMov.nY);
		SafetyTrade.HideWindow();
	}
	SetInventoryItemNum();
	return;
}

function SetInventoryItemNum()
{
	InventoryNum_Txt.SetText(string(Class'NWindow.UIDATA_PLAYER'.static.GetInventoryCount()));
	InventoryAll_Txt.SetText(("/" $ string(Class'NWindow.UIDATA_PLAYER'.static.GetInventoryLimit())));
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("PostDetailWnd_General.PostDetailWnd_General");
	SafetyTrade = GetWindowHandle("PostDetailWnd_SafetyTrade");
	Title_SenderID = GetTextBoxHandle("PostDetailWnd_General.Title_SenderID");
	SenderID = GetTextBoxHandle("PostDetailWnd_General.SenderID");
	PostType = GetTextBoxHandle("PostDetailWnd_General.PostType");
	PostTitle = GetTextBoxHandle("PostDetailWnd_General.PostTitle");
	PostContents = GetTextListBoxHandle("PostDetailWnd_General.PostContents");
	SendCancelBtn = GetButtonHandle("PostDetailWnd_General.SendCancelBtn");
	ReceiveBtn = GetButtonHandle("PostDetailWnd_General.ReceiveBtn");
	ReturnBtn = GetButtonHandle("PostDetailWnd_General.ReturnBtn");
	ReplyBtn = GetButtonHandle("PostDetailWnd_General.ReplyBtn");
	AddBtn = GetButtonHandle("PostDetailWnd_General.AddBtn");
	AccompanyItem = GetItemWindowHandle("PostDetailWnd_General.AccompanyItem");
	InventoryNum_Txt = GetTextBoxHandle("PostDetailWnd_General.InventoryNum_Txt");
	InventoryPlus_Txt = GetTextBoxHandle("PostDetailWnd_General.InventoryPlus_Txt");
	InventoryAll_Txt = GetTextBoxHandle("PostDetailWnd_General.InventoryAll_Txt");
	ReplyIcon_Tex = GetTextureHandle("PostDetailWnd_General.ReplyIcon_Tex");
	ReturnIcon_Tex = GetTextureHandle("PostDetailWnd_General.ReturnIcon_Tex");
	BottomDescription_Txt = GetTextBoxHandle("PostDetailWnd_General.BottomDescription_Txt");
	ReceiveDelBtn = GetButtonHandle("PostDetailWnd_General.ReceiveDelBtn");
	TrashCanIcon_Tex = GetTextureHandle("PostDetailWnd_General.TrashCanIcon_Tex");
	return;
}

event OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		case "ReceiveBtn":
			RequestReceivePost(mailID);
			Me.HideWindow();
			break;
		case "ReturnBtn":
			if(((returnd == 1) || ((TRADE == 0) && (returnAble == 1))))
			{
				DialogHide();
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(3063));
				DialogSetID(1111);
			}
			break;
		case "SendCancelBtn":
			if((sentBySystem == 7))
			{
				DialogHide();
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(6066));
				DialogSetID(2222);
			}
			else
			{
				RequestCancelSentPost(mailID);
				Me.HideWindow();
			}
			break;
		case "ReplyBtn":
			HandleReplyBtn();
			break;
		case "AddBtn":
			HandleAddBtn();
			break;
		case "ReceiveDelBtn":
			ViewDelDialog();
			break;
		default:
			break;
	}
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PostDetailWnd_General");
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 4740:
			OnEVReplyReceivedPostStart(param);
			break;
		case 4741:
			OnEVReplyReceivedPostAddItem(param);
			break;
		case 4742:
			OnEVReplyReceivedPostEnd(param);
			break;
		case 4780:
			OnEVReplySentPostStart(param);
			break;
		case 4781:
			OnEVReplySentPostAddItem(param);
			break;
		case 4782:
			OnEVReplySentPostEnd(param);
			break;
		case 1710:
			HandleDialogOK();
			break;
		default:
			break;
	}
	return;
}

function OnEVReplyReceivedPostStart(string param)
{
	ClearAll();
	ParseInt(param, "trade", TRADE);
	ParseInt(param, "Returnd", returnd);
	if(((returnd == 1) || (TRADE == 0)))
	{
		if((returnd == 1))
		{
			Me.SetWindowTitle(((("[" $ GetSystemString(2090)) $ "]") @ GetSystemString(2075)));
		}
		else
		{
			Me.SetWindowTitle(((GetSystemString(2075) @ "-") @ GetSystemString(2071)));
		}
		ReceiveBtnHide();
		ReturnBtnShow();
		SendCancelBtn.HideWindow();
		Me.ShowWindow();
		Me.SetFocus();
	}
	return;
}

function OnEVReplyReceivedPostAddItem(string param)
{
	local ItemInfo Info;

	if(((returnd == 1) || (TRADE == 0)))
	{
		ParamToItemInfo(param, Info);
		if((int(byte(Info.EtcItemType)) == 7))
		{
			Info.Id.ServerID = -1;
		}
		AccompanyItem.AddItem(Info);
		Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InvenWeight"), INT64((Info.Weight * int(Info.ItemNum))));
	}
	return;
}

function string addComma(bool bComma, string Text)
{
	if(bComma)
	{
		return (", " $ Text);
	}
	return Text;
}

function SetAddedItemNum()
{
	local int itemlistcount;

	itemlistcount = AccompanyItem.GetItemNum();
	if((itemlistcount == 0))
	{
		InventoryPlus_Txt.SetText("");
		InventoryAll_Txt.SetAnchor(InventoryNum_Txt.m_WindowNameWithFullPath, "CenterRight", "CenterLeft", 0, 0);
		BottomDescription_Txt.SetText(GetSystemString(14729));
	}
	else
	{
		InventoryPlus_Txt.SetText((("(+" $ string(itemlistcount)) $ ")"));
		InventoryAll_Txt.SetAnchor(InventoryPlus_Txt.m_WindowNameWithFullPath, "CenterRight", "CenterLeft", 0, 0);
	}
	if(((itemlistcount + Class'NWindow.UIDATA_PLAYER'.static.GetInventoryCount()) > Class'NWindow.UIDATA_PLAYER'.static.GetInventoryLimit()))
	{
		InventoryPlus_Txt.SetTextColor(getInstanceL2Util().Red);
	}
	else
	{
		InventoryPlus_Txt.SetTextColor(getInstanceL2Util().BLUE01);
	}
	return;
}

function SetDeleteBtn()
{
	if((AccompanyItem.GetItemNum() == 0))
	{
		ReceiveDelBtn.ShowWindow();
		TrashCanIcon_Tex.ShowWindow();
	}
	else
	{
		ReceiveDelBtn.HideWindow();
		TrashCanIcon_Tex.HideWindow();
	}
	return;
}

function OnEVReplyReceivedPostEnd(string param)
{
	local string senderName, Title, contents;
	local INT64 tradeMoney;
	local string fixedtitle;
	local int SendId, contentSystemMsgID, ClassID, Enchant;
	local string NpcName;
	local int titleSystemMsgId, valueFire, valueWater, valueWind, valueEarth, valueHoly, valueUnholy;
	local bool isAttribute;
	local string attStr;
	local ItemID cItemID;
	local ItemInfo cItemInfo;
	local int itemlistcount;

	Title_SenderID.SetText(GetSystemString(2078));
	SetAddedItemNum();
	SetDeleteBtn();
	if(((returnd == 1) || (TRADE == 0)))
	{
		ParseInt(param, "MailID", mailID);
		ParseString(param, "SenderName", senderName);
		ParseInt(param, "SenderId", SendId);
		ParseString(param, "Title", Title);
		ParseInt(param, "TitleSystemMsgId", titleSystemMsgId);
		ParseString(param, "Content", contents);
		ParseInt(param, "ContentSystemMsgID", contentSystemMsgID);
		ParseInt(param, "ClassID", ClassID);
		ParseInt(param, "Enchant", Enchant);
		ParseINT64(param, "TradeMoney", tradeMoney);
		ParseInt(param, "ReturnAble", returnAble);
		ParseInt(param, "Sentbysystem", sentBySystem);
		ParseInt(param, "attrFire", valueFire);
		ParseInt(param, "attrWater", valueWater);
		ParseInt(param, "attrWind", valueWind);
		ParseInt(param, "attrEarth", valueEarth);
		ParseInt(param, "attrHoly", valueHoly);
		ParseInt(param, "attrUnholy", valueUnholy);
		if((sentBySystem == 7))
		{
			PostType.SetText(GetSystemString(5080));
		}
		else
		{
			PostType.SetText(GetSystemString(2071));
		}
		if(((sentBySystem == 4) || (sentBySystem == 5)))
		{
			Title = GetSystemMessage(titleSystemMsgId);
		}
		fixedtitle = DivideStringWithWidth(Title, 380);
		if((fixedtitle != Title))
		{
			fixedtitle = (fixedtitle $ "...");
		}
		if((returnd == 1))
		{
			fixedtitle = ((("[" $ GetSystemString(2090)) $ "] ") $ fixedtitle);
			PostTitle.SetText(fixedtitle);
		}
		else
		{
			PostTitle.SetText(fixedtitle);
		}
		isAttribute = false;
		if((sentBySystem == 4))
		{
			contents = GetSystemMessage(contentSystemMsgID);
		}
		else if((sentBySystem == 5))
		{
			cItemID.ClassID = ClassID;
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cItemID, cItemInfo);
			if((cItemInfo.ItemType == 0))
			{
				if((Enchant > 0))
				{
					contents = ((("+" $ string(Enchant)) $ " ") $ contents);
				}
				contents = (((contents $ "( ") $ GetSystemString(1596)) $ ": ");
				if((valueFire > 0))
				{
					attStr = (attStr $ addComma(isAttribute, (GetSystemString(1622) $ string(valueFire))));
					isAttribute = true;
				}
				if((valueWater > 0))
				{
					attStr = (attStr $ addComma(isAttribute, (GetSystemString(1623) $ string(valueWater))));
					isAttribute = true;
				}
				if((valueWind > 0))
				{
					attStr = (attStr $ addComma(isAttribute, (GetSystemString(1624) $ string(valueWind))));
					isAttribute = true;
				}
				if((valueEarth > 0))
				{
					attStr = (attStr $ addComma(isAttribute, (GetSystemString(1625) $ string(valueEarth))));
					isAttribute = true;
				}
				if((valueHoly > 0))
				{
					attStr = (attStr $ addComma(isAttribute, (GetSystemString(1626) $ string(valueHoly))));
					isAttribute = true;
				}
				if((valueUnholy > 0))
				{
					attStr = (attStr $ addComma(isAttribute, (GetSystemString(1627) $ string(valueUnholy))));
					isAttribute = true;
				}
				if(((((((valueFire + valueWater) + valueWind) + valueEarth) + valueHoly) + valueUnholy) <= 0))
				{
					attStr = (attStr $ GetSystemString(27));
				}
				contents = ((contents $ attStr) $ " )");
				contents = MakeFullSystemMsg(GetSystemMessage(contentSystemMsgID), contents);
			}
			else if((cItemInfo.ItemType == 1))
			{
				if((Enchant > 0))
				{
					contents = ((("+" $ string(Enchant)) $ " ") $ contents);
				}
				contents = (((contents $ "( ") $ GetSystemString(1596)) $ ": ");
				if((valueFire > 0))
				{
					attStr = (attStr $ addComma(isAttribute, (MakeFullSystemMsg(GetSystemMessage(2215), (GetSystemString(1622) $ " ")) $ string(valueFire))));
					isAttribute = true;
				}
				if((valueWater > 0))
				{
					attStr = (attStr $ addComma(isAttribute, (MakeFullSystemMsg(GetSystemMessage(2215), (GetSystemString(1623) $ " ")) $ string(valueWater))));
					isAttribute = true;
				}
				if((valueWind > 0))
				{
					attStr = (attStr $ addComma(isAttribute, (MakeFullSystemMsg(GetSystemMessage(2215), (GetSystemString(1624) $ " ")) $ string(valueWind))));
					isAttribute = true;
				}
				if((valueEarth > 0))
				{
					attStr = (attStr $ addComma(isAttribute, (MakeFullSystemMsg(GetSystemMessage(2215), (GetSystemString(1625) $ " ")) $ string(valueEarth))));
					isAttribute = true;
				}
				if((valueHoly > 0))
				{
					attStr = (attStr $ addComma(isAttribute, (MakeFullSystemMsg(GetSystemMessage(2215), (GetSystemString(1626) $ " ")) $ string(valueHoly))));
					isAttribute = true;
				}
				if((valueUnholy > 0))
				{
					attStr = (attStr $ addComma(isAttribute, (MakeFullSystemMsg(GetSystemMessage(2215), (GetSystemString(1627) $ " ")) $ string(valueUnholy))));
					isAttribute = true;
				}
				if(((((((valueFire + valueWater) + valueWind) + valueEarth) + valueHoly) + valueUnholy) <= 0))
				{
					attStr = (attStr $ GetSystemString(27));
				}
				contents = ((contents $ attStr) $ " )");
				contents = MakeFullSystemMsg(GetSystemMessage(contentSystemMsgID), contents);
			}
			else
			{
				contents = MakeFullSystemMsg(GetSystemMessage(contentSystemMsgID), contents);
			}
		}
		PostContents.AddString(contents, GetChatColorByType(0));
		PostContents.SetTextListBoxScrollPosition(0);
		itemlistcount = AccompanyItem.GetItemNum();
		if((itemlistcount != 0))
		{
			ReceiveBtnShow();
		}
		if((returnAble == 1))
		{
			ReturnBtnShow();
		}
		else
		{
			ReturnBtnHide();
		}
		if((sentBySystem == 1))
		{
			if((returnd == 1))
			{
				SenderID.SetText(((("[" $ GetSystemString(2090)) $ "]") @ senderName));
			}
			else
			{
				SenderID.SetText(GetSystemString(2211));
			}
		}
		else if((sentBySystem == 2))
		{
			NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(SendId);
			if((Len(NpcName) > 0))
			{
				SenderID.SetText(NpcName);
			}
		}
		else if((sentBySystem == 3))
		{
			SenderID.SetText(GetSystemString(2316));
		}
		else if(((sentBySystem == 4) || (sentBySystem == 5)))
		{
			SenderID.SetText(GetSystemString(Class'NWindow.ConsignmentSaleAPI'.static.GetCommissionSellerID()));
		}
		else if((sentBySystem == 6))
		{
			SendId = Class'NWindow.UIDATA_NPC'.static.GetMentoringNPCId();
			if((SendId > 0))
			{
				NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(SendId);
				if((Len(NpcName) > 0))
				{
					SenderID.SetText(NpcName);
				}
			}
			else
			{
				Debug(("Error : 'SendId' is wrong" @ string(SendId)));
			}
		}
		else
		{
			SenderID.SetText(senderName);
		}
		if((sentBySystem == 0))
		{
			ReplyBtn.EnableWindow();
			ReplyBtnShow();
			AddBtn.EnableWindow();
		}
		else
		{
			ReturnBtnHide();
			ReplyBtnHide();
			AddBtn.DisableWindow();
		}
		if((itemlistcount == 0))
		{
			ReturnBtnHide();
		}
	}
	return;
}

function OnEVReplySentPostStart(string param)
{
	ClearAll();
	isSentMail = true;
	ParseInt(param, "trade", TRADE);
	ParseInt(param, "Sentbysystem", sentBySystem);
	if((TRADE == 0))
	{
		Me.SetWindowTitle(((GetSystemString(2076) @ "-") @ GetSystemString(2071)));
		ReceiveBtnHide();
		ReturnBtnHide();
		SendCancelBtnShow();
		ReplyBtnHide();
		Me.ShowWindow();
		Me.SetFocus();
	}
	return;
}

function OnEVReplySentPostAddItem(string param)
{
	local ItemInfo Info;

	if((TRADE == 0))
	{
		ParamToItemInfo(param, Info);
		if((int(byte(Info.EtcItemType)) == 7))
		{
			Info.Id.ServerID = -1;
		}
		AccompanyItem.AddItem(Info);
		Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InvenWeight"), INT64((Info.Weight * int(Info.ItemNum))));
	}
	return;
}

function OnEVReplySentPostEnd(string param)
{
	local string receivername, Title, contents;
	local INT64 tradeMoney;
	local int notOpend;
	local string fixedtitle;

	SetAddedItemNum();
	SetDeleteBtn();
	ParseInt(param, "Sentbysystem", sentBySystem);
	if((TRADE == 0))
	{
		ParseInt(param, "MailID", mailID);
		ParseString(param, "ReceiverName", receivername);
		ParseString(param, "Title", Title);
		ParseString(param, "Content", contents);
		ParseINT64(param, "TradeMoney", tradeMoney);
		ParseInt(param, "NotOpend", notOpend);
		ParseInt(param, "Sentbysystem", sentBySystem);
		if((sentBySystem == 7))
		{
			PostType.SetText(GetSystemString(5080));
		}
		else
		{
			PostType.SetText(GetSystemString(2071));
		}
		fixedtitle = DivideStringWithWidth(Title, 380);
		if((fixedtitle != Title))
		{
			fixedtitle = (fixedtitle $ "...");
		}
		PostTitle.SetText(fixedtitle);
		Title_SenderID.SetText(GetSystemString(2087));
		PostContents.AddString(contents, GetChatColorByType(0));
		PostContents.SetTextListBoxScrollPosition(0);
		SenderID.SetText(receivername);
		if((AccompanyItem.GetItemNum() != 0))
		{
			SendCancelBtnShow();
		}
		else
		{
			SendCancelBtn.HideWindow();
		}
	}
	return;
}

function ClearAll()
{
	isSentMail = false;
	SenderID.SetText("");
	PostType.SetText(GetSystemString(2071));
	PostTitle.SetText("");
	PostContents.Clear();
	ReceiveBtnHide();
	ReturnBtnHide();
	SendCancelBtn.HideWindow();
	AccompanyItem.Clear();
	Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InvenWeight"));
	InventoryPlus_Txt.SetText("");
	return;
}

function ViewDelDialog()
{
	DialogHide();
	if(isSentMail)
	{
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(14017));
	}
	else
	{
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(14018));
	}
	DialogSetID(3333);
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner(0, 0);
	return;
}

function HandleDialogOK()
{
	local int Id;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		if((Id == 1111))
		{
			RequestRejectPost(mailID);
			Me.HideWindow();
		}
		else if((Id == 2222))
		{
			RequestCancelSentPost(mailID);
			Me.HideWindow();
		}
		else if((Id == 3333))
		{
			if(isSentMail)
			{
				API_RequestDeleteSentPost();
			}
			else
			{
				API_RequestDeleteReceivedPost();
			}
			m_hOwnerWnd.HideWindow();
		}
	}
	return;
}

function HandleReplyBtn()
{
	local PostWriteWnd Script;
	local string Title;

	if((returnd != 1))
	{
		RequestPostItemList();
		Script = PostWriteWnd(GetScript("PostWriteWnd"));
		Me.HideWindow();
		Title = ("[Re]" $ PostTitle.GetText());
		Script.SetPostWriteWnd(SenderID.GetText(), Title, "");
	}
	return;
}

function ReplyBtnShow()
{
	ReplyBtn.ShowWindow();
	ReplyIcon_Tex.ShowWindow();
	return;
}

function ReplyBtnHide()
{
	ReplyBtn.HideWindow();
	ReplyIcon_Tex.HideWindow();
	return;
}

function ReturnBtnShow()
{
	ReturnBtn.ShowWindow();
	ReturnIcon_Tex.ShowWindow();
	ReplyBtn.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "BottomCenter", "BottomCenter", 86, -8);
	return;
}

function ReturnBtnHide()
{
	ReturnBtn.HideWindow();
	ReturnIcon_Tex.HideWindow();
	ReplyBtn.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "BottomCenter", "BottomCenter", 0, -8);
	return;
}

function ReceiveBtnShow()
{
	BottomDescription_Txt.HideWindow();
	ReceiveBtn.ShowWindow();
	return;
}

function ReceiveBtnHide()
{
	BottomDescription_Txt.ShowWindow();
	ReceiveBtn.HideWindow();
	return;
}

function SendCancelBtnShow()
{
	SendCancelBtn.ShowWindow();
	BottomDescription_Txt.SetText(GetSystemString(14728));
	return;
}

function API_RequestDeleteReceivedPost()
{
	local array<int> mailIDs;

	mailIDs[0] = mailID;
	RequestDeleteReceivedPost(mailIDs);
	return;
}

function API_RequestDeleteSentPost()
{
	local array<int> mailIDs;

	mailIDs[0] = mailID;
	RequestDeleteSentPost(mailIDs);
	return;
}

function HandleAddBtn()
{
	Class'NWindow.PostWndAPI'.static.RequestAddingPostFriend(SenderID.GetText());
	return;
}
