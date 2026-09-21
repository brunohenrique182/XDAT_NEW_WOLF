class PostDetailWnd_SafetyTrade extends UICommonAPI;

const DIALOG_RECEIVE_TRADE_POST = 1111;
const DIALOG_RETURN_POST = 2222;
const DIALOG_DELETE_SELECTED_MAIL = 3333;

var WindowHandle Me;
var WindowHandle General;
var TextBoxHandle Title_SenderID;
var TextBoxHandle SenderID;
var TextBoxHandle PostType;
var TextBoxHandle PostTitle;
var TextListBoxHandle PostContents;
var TextBoxHandle SafetyTradeAdenaText;
var INT64 ReceivedTradeAdena;
var ButtonHandle ReceiveBtn;
var ButtonHandle ReturnBtn;
var ButtonHandle SendCancelBtn;
var ButtonHandle ReplyBtn;
var ButtonHandle AddBtn;
var int TRADE;
var int returnd;
var int mailID;
var int returnAble;
var int sentBySystem;
var Color impactcolor;
var PostDetailWnd_SafetyTradeListWnd PostDetailWnd_SafetyTradeListWndScript;
var TextBoxHandle Wintitle_tex;
var TextBoxHandle InventoryNum_Txt;
var TextBoxHandle InventoryPlus_Txt;
var TextBoxHandle InventoryAll_Txt;
var TextureHandle ReplyIcon_Tex;
var ButtonHandle ReceiveDelBtn;
var TextureHandle TrashCanIcon_Tex;

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
	impactcolor.R = 255;
	impactcolor.G = 114;
	impactcolor.B = 0;
	return;
}

event OnShow()
{
	local Rect rectMov;

	if(General.IsShowWindow())
	{
		rectMov = General.GetRect();
		Me.MoveTo(rectMov.nX, rectMov.nY);
		General.HideWindow();
	}
	PostDetailWnd_SafetyTradeListWndScript.HandleShow();
	SetItemNum();
	return;
}

event OnHide()
{
	PostDetailWnd_SafetyTradeListWndScript.HandleHide();
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("PostDetailWnd_SafetyTrade");
	General = GetWindowHandle("PostDetailWnd_General");
	Title_SenderID = GetTextBoxHandle("PostDetailWnd_SafetyTrade.Title_SenderID");
	SenderID = GetTextBoxHandle("PostDetailWnd_SafetyTrade.SenderID");
	PostType = GetTextBoxHandle("PostDetailWnd_SafetyTrade.PostType");
	PostTitle = GetTextBoxHandle("PostDetailWnd_SafetyTrade.PostTitle");
	PostContents = GetTextListBoxHandle("PostDetailWnd_SafetyTrade.PostContents");
	SafetyTradeAdenaText = GetTextBoxHandle("PostDetailWnd_SafetyTrade.SafetyTradeAdenaText");
	ReceiveBtn = GetButtonHandle("PostDetailWnd_SafetyTradeListWnd.ReceiveBtn");
	ReturnBtn = GetButtonHandle("PostDetailWnd_SafetyTradeListWnd.ReturnBtn");
	SendCancelBtn = GetButtonHandle("PostDetailWnd_SafetyTradeListWnd.SendCancelBtn");
	ReplyBtn = GetButtonHandle("PostDetailWnd_SafetyTrade.ReplyBtn");
	AddBtn = GetButtonHandle("PostDetailWnd_SafetyTrade.AddBtn");
	PostDetailWnd_SafetyTradeListWndScript = PostDetailWnd_SafetyTradeListWnd(GetScript("PostDetailWnd_SafetyTradeListWnd"));
	Wintitle_tex = GetTextBoxHandle("PostDetailWnd_SafetyTrade.Wintitle_tex");
	InventoryNum_Txt = GetTextBoxHandle("PostDetailWnd_SafetyTrade.InventoryNum_Txt");
	InventoryPlus_Txt = GetTextBoxHandle("PostDetailWnd_SafetyTrade.InventoryPlus_Txt");
	InventoryAll_Txt = GetTextBoxHandle("PostDetailWnd_SafetyTrade.InventoryAll_Txt");
	ReplyIcon_Tex = GetTextureHandle("PostDetailWnd_SafetyTrade.ReplyIcon_Tex");
	ReceiveDelBtn = GetButtonHandle("PostDetailWnd_SafetyTrade.ReceiveDelBtn");
	TrashCanIcon_Tex = GetTextureHandle("PostDetailWnd_SafetyTrade.TrashCanIcon_Tex");
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

event OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		case "ReceiveBtn":
			if(((returnd == 0) && (TRADE == 1)))
			{
				DialogHide();
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3086), SenderID.GetText(), ConvertNumToText(string(ReceivedTradeAdena))));
				DialogSetID(1111);
				Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(220, 0);
			}
			else
			{
				RequestReceivePost(mailID);
				Me.HideWindow();
			}
			break;
		case "ReturnBtn":
			if((((returnd == 0) && (TRADE == 1)) && (returnAble == 1)))
			{
				DialogHide();
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(3069));
				DialogSetID(2222);
				Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(220, 0);
			}
			break;
		case "SendCancelBtn":
			RequestCancelSentPost(mailID);
			Me.HideWindow();
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
	GetWindowHandle("PostDetailWnd_SafetyTrade").HideWindow();
	return;
}

function _AddWeight(int Weight)
{
	Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InvenWeight"), INT64(Weight));
	return;
}

function OnEVReplyReceivedPostStart(string param)
{
	ClearAll();
	ParseInt(param, "trade", TRADE);
	ParseInt(param, "Returnd", returnd);
	if(((returnd == 0) && (TRADE == 1)))
	{
		Wintitle_tex.SetText(((GetSystemString(2075) @ "-") @ GetSystemString(2072)));
		ReceiveBtn.HideWindow();
		ReturnBtn.HideWindow();
		SendCancelBtn.HideWindow();
		Me.ShowWindow();
		Me.SetFocus();
	}
	return;
}

function OnEVReplyReceivedPostAddItem(string param)
{
	if(((returnd == 0) && (TRADE == 1)))
	{
		PostDetailWnd_SafetyTradeListWndScript.AddItem(param);
		ReceiveBtn.ShowWindow();
	}
	return;
}

function HandleButtonsOnRecived()
{
	if((returnAble == 1))
	{
		ReturnBtn.ShowWindow();
	}
	if((PostDetailWnd_SafetyTradeListWndScript.GetItemListCount() == 0))
	{
		ReturnBtn.HideWindow();
		ReceiveDelBtn.ShowWindow();
		TrashCanIcon_Tex.ShowWindow();
	}
	else
	{
		ReceiveBtn.ShowWindow();
		ReceiveDelBtn.HideWindow();
		TrashCanIcon_Tex.HideWindow();
	}
	switch(sentBySystem)
	{
		case 1:
			ReturnBtn.HideWindow();
			ReplyBtnHide();
			break;
		case 2:
			ReplyBtnShow();
			break;
		default:
			ReplyBtnShow();
			break;
	}
	return;
}

function OnEVReplyReceivedPostEnd(string param)
{
	local string senderName, Title, contents, fixedtitle;
	local int SendId;
	local string NpcName;
	local CustomTooltip cTooltip;
	local int itemlistcount;

	itemlistcount = PostDetailWnd_SafetyTradeListWndScript.GetItemListCount();
	if((itemlistcount == 0))
	{
		InventoryPlus_Txt.SetText("");
		InventoryAll_Txt.SetAnchor(InventoryNum_Txt.m_WindowNameWithFullPath, "CenterRight", "CenterLeft", 0, 0);
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
	if(((returnd == 0) && (TRADE == 1)))
	{
		ParseInt(param, "MailID", mailID);
		ParseString(param, "SenderName", senderName);
		ParseInt(param, "SenderId", SendId);
		ParseString(param, "Title", Title);
		ParseString(param, "Content", contents);
		ParseINT64(param, "TradeMoney", ReceivedTradeAdena);
		ParseInt(param, "ReturnAble", returnAble);
		ParseInt(param, "Sentbysystem", sentBySystem);
		PostType.SetTextColor(impactcolor);
		PostType.SetText(GetSystemString(2072));
		fixedtitle = DivideStringWithWidth(Title, 380);
		if((fixedtitle != Title))
		{
			fixedtitle = (fixedtitle $ "...");
		}
		PostTitle.SetText(fixedtitle);
		PostContents.AddString(contents, GetChatColorByType(0));
		PostContents.SetTextListBoxScrollPosition(0);
		Title_SenderID.SetText(GetSystemString(2078));
		SafetyTradeAdenaText.SetTextColor(impactcolor);
		SafetyTradeAdenaText.SetText(MakeCostString(string(ReceivedTradeAdena)));
		addToolTipDrawList(cTooltip, addDrawItemText(((ConvertNumToTextNoAdena(string(ReceivedTradeAdena)) $ " ") $ GetSystemString(469)), getInstanceL2Util().White, "", false));
		SafetyTradeAdenaText.SetTooltipCustomType(cTooltip);
		switch(sentBySystem)
		{
			case 1:
				if((returnd == 1))
				{
					SenderID.SetText(((("[" $ GetSystemString(2090)) $ "]") @ GetSystemString(2073)));
				}
				else
				{
					SenderID.SetText(GetSystemString(2211));
				}
				break;
			case 2:
				NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(SendId);
				if((Len(NpcName) > 0))
				{
					SenderID.SetText(NpcName);
				}
				else
				{
					SenderID.SetText(senderName);
				}
				break;
			default:
				SenderID.SetText(senderName);
				break;
		}
		HandleButtonsOnRecived();
	}
	return;
}

function OnEVReplySentPostStart(string param)
{
	ClearAll();
	ParseInt(param, "trade", TRADE);
	if((TRADE == 1))
	{
		Wintitle_tex.SetText(((GetSystemString(2076) @ "-") @ GetSystemString(2072)));
		ReceiveBtn.HideWindow();
		ReturnBtn.HideWindow();
		SendCancelBtn.HideWindow();
		Me.ShowWindow();
		Me.SetFocus();
	}
	return;
}

function OnEVReplySentPostAddItem(string param)
{
	if((TRADE == 1))
	{
		PostDetailWnd_SafetyTradeListWndScript.AddItem(param);
	}
	return;
}

function OnEVReplySentPostEnd(string param)
{
	local string receivername, Title, contents;
	local INT64 tradeMoney;
	local int notOpend;
	local string fixedtitle;
	local CustomTooltip cTooltip;

	if((TRADE == 1))
	{
		ParseInt(param, "MailID", mailID);
		ParseString(param, "ReceiverName", receivername);
		ParseString(param, "Title", Title);
		ParseString(param, "Content", contents);
		ParseINT64(param, "TradeMoney", tradeMoney);
		ParseInt(param, "NotOpend", notOpend);
		PostType.SetTextColor(impactcolor);
		PostType.SetText(GetSystemString(2072));
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
		ReceiveBtn.HideWindow();
		ReturnBtn.HideWindow();
		ReplyBtnHide();
		SafetyTradeAdenaText.SetTextColor(impactcolor);
		SafetyTradeAdenaText.SetText(MakeCostString(string(tradeMoney)));
		addToolTipDrawList(cTooltip, addDrawItemText(((ConvertNumToTextNoAdena(string(tradeMoney)) $ " ") $ GetSystemString(469)), getInstanceL2Util().White, "", false));
		SafetyTradeAdenaText.SetTooltipCustomType(cTooltip);
		if((PostDetailWnd_SafetyTradeListWndScript.GetItemListCount() != 0))
		{
			SendCancelBtn.ShowWindow();
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
	SenderID.SetText("");
	PostType.SetTextColor(impactcolor);
	PostType.SetText(GetSystemString(2072));
	PostTitle.SetText("");
	PostContents.Clear();
	SafetyTradeAdenaText.SetTextColor(impactcolor);
	SafetyTradeAdenaText.SetText("0");
	SafetyTradeAdenaText.ClearTooltip();
	ReceiveBtn.HideWindow();
	ReturnBtn.HideWindow();
	SendCancelBtn.HideWindow();
	PostDetailWnd_SafetyTradeListWndScript.Clear();
	Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InvenWeight"));
	InventoryPlus_Txt.SetText("");
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
			RequestReceivePost(mailID);
			Me.HideWindow();
		}
		else if((Id == 2222))
		{
			RequestRejectPost(mailID);
			Me.HideWindow();
		}
		else if((Id == 3333))
		{
			API_RequestDeleteReceivedPost();
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

function HandleAddBtn()
{
	Class'NWindow.PostWndAPI'.static.RequestAddingPostFriend(SenderID.GetText());
	return;
}

function SetItemNum()
{
	InventoryNum_Txt.SetText(string(Class'NWindow.UIDATA_PLAYER'.static.GetInventoryCount()));
	InventoryAll_Txt.SetText(("/" $ string(Class'NWindow.UIDATA_PLAYER'.static.GetInventoryLimit())));
	return;
}

function ViewDelDialog()
{
	DialogHide();
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(14018));
	DialogSetID(3333);
	Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(0, 0);
	return;
}

function SetDeleteBtn()
{
	if((PostDetailWnd_SafetyTradeListWndScript.GetItemListCount() == 0))
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

function API_RequestDeleteReceivedPost()
{
	local array<int> mailIDs;

	mailIDs[0] = mailID;
	RequestDeleteReceivedPost(mailIDs);
	return;
}
