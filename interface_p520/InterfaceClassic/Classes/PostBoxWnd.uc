class PostBoxWnd extends UICommonAPI;

const MAX_MAILNUM = 240;
const MAIL_PER_PAGE = 6;
const RECEIVED_WINDOW_TAB = 0;
const SENT_WINDOW_TAB = 1;
const DIALOG_DELETE_SELECTED_RECEIVED_MAIL = 1111;
const DIALOG_NO_DETECTED_DELETE_RECEIVED_MAIL = 2222;
const DIALOG_DELETE_SELECTED_SENT_MAIL = 3333;
const DIALOG_NO_DETECTED_DELETE_SENT_MAIL = 4444;
const DIALOG_CONFIRM_TRADE_POST = 5555;
const VALIDATE_ID_listRefresh_Received = 0;
const VALIDATE_ID_listRefresh_Sent = 1;
const VALIDATE_ID_pageNumChanged_Received = 2;
const VALIDATE_ID_pageNumChanged_Sent = 3;

struct ReceivedPostMSG
{
	var int mailID;
	var string Title;
	var string senderName;
	var int TRADE;
	var int notOpend;
	var int returnAble;
	var int withItem;
	var int returnd;
	var int sentBySystem;
	var float diffTime;
	var int CheckBoxState;
};

struct SentPostMSG
{
	var int mailID;
	var string Title;
	var string receivername;
	var int TRADE;
	var int notOpend;
	var int returnAble;
	var int withItem;
	var int sentBySystem;
	var float diffTime;
	var int CheckBoxState;
};

var int validateFlag;
var WindowHandle Me;
var WindowHandle PostWriteWnd;
var WindowHandle PostDetailWnd_General;
var WindowHandle PostDetailWnd_SafetyTrade;
var TabHandle TabCtrl;
var TextureHandle TexTabBg;
var TextureHandle TexTabBgLine;
var TextureHandle GroupBox;
var TextureHandle ReceiveGroupLine;
var TextureHandle ReceiveSafetyTradeIcon;
var TextureHandle ReceiveAccompanyIcon;
var TextureHandle ReceivePostListDeco;
var TextureHandle SendGroupLine;
var TextureHandle SendSafetyTradeIcon;
var TextureHandle SendAccompanyIcon;
var TextureHandle SendPostListDeco;
var TextBoxHandle ReceiveListNumber;
var TextBoxHandle SendListNumber;
var ButtonHandle ReceiveListPrevBtn;
var ButtonHandle ReceiveListNextBtn;
var ButtonHandle ReceiveDelBtn;
var ButtonHandle PostSendBtn;
var ButtonHandle SendListPrevBtn;
var ButtonHandle SendListNextBtn;
var ButtonHandle SendDelBtn;
var ButtonHandle PaymentPostSendBtn;
var RichListCtrlHandle receivedPostList;
var RichListCtrlHandle SentPostList;
var TextBoxHandle Limit_Txt_Receive;
var TextBoxHandle Limit_Txt_Sent;
var CheckBoxHandle ReceivePostCheck_all;
var CheckBoxHandle SendPostCheck_all;
var array<ReceivedPostMSG> receivedInfoList;
var array<SentPostMSG> sentInfoList;
var int receivedPageNum;
var int sentPageNum;
var int curReceivedPage;
var int curSentPage;
var string m_Windowname;
var int checkState[6];
var TextBoxHandle Empty_Txt;
var bool bNotOpen;

event OnRegisterEvent()
{
	RegisterEvent(4710);
	RegisterEvent(4720);
	RegisterEvent(4730);
	RegisterEvent(4750);
	RegisterEvent(4760);
	RegisterEvent(4770);
	RegisterEvent(1710);
	RegisterEvent(4793);
	RegisterEvent(4794);
	RegisterEvent(4795);
	RegisterEvent(4796);
	RegisterEvent(4797);
	RegisterEvent(4798);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	InitializeCOD();
	Me.HideWindow();
	ShowReceiveListNumber();
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle(m_Windowname);
	PostWriteWnd = GetWindowHandle("PostWriteWnd");
	PostDetailWnd_General = GetWindowHandle("PostDetailWnd_General");
	PostDetailWnd_SafetyTrade = GetWindowHandle("PostDetailWnd_SafetyTrade");
	ReceiveListNumber = GetTextBoxHandle((m_Windowname $ ".ReceivePost.ReceiveListNumber"));
	SendListNumber = GetTextBoxHandle((m_Windowname $ ".SendPost.SendListNumber"));
	TabCtrl = GetTabHandle((m_Windowname $ ".TabCtrl"));
	TexTabBg = GetTextureHandle((m_Windowname $ ".TexTabBg"));
	TexTabBgLine = GetTextureHandle((m_Windowname $ ".TexTabBgLine"));
	GroupBox = GetTextureHandle((m_Windowname $ ".groupbox"));
	ReceiveGroupLine = GetTextureHandle((m_Windowname $ ".ReceiveGroupLine"));
	ReceiveSafetyTradeIcon = GetTextureHandle((m_Windowname $ ".ReceiveSafetyTradeIcon"));
	ReceiveAccompanyIcon = GetTextureHandle((m_Windowname $ ".ReceiveAccompanyIcon"));
	ReceivePostListDeco = GetTextureHandle((m_Windowname $ ".ReceivePostListDeco"));
	SendGroupLine = GetTextureHandle((m_Windowname $ ".SendGroupLine"));
	SendSafetyTradeIcon = GetTextureHandle((m_Windowname $ ".SendSafetyTradeIcon"));
	SendAccompanyIcon = GetTextureHandle((m_Windowname $ ".SendAccompanyIcon"));
	SendPostListDeco = GetTextureHandle((m_Windowname $ ".SendPostListDeco"));
	ReceiveListPrevBtn = GetButtonHandle((m_Windowname $ ".ReceiveListPrevBtn"));
	ReceiveListNextBtn = GetButtonHandle((m_Windowname $ ".ReceiveListNextBtn"));
	ReceiveDelBtn = GetButtonHandle((m_Windowname $ ".ReceiveDelBtn"));
	PostSendBtn = GetButtonHandle((m_Windowname $ ".PostSendBtn"));
	PaymentPostSendBtn = GetButtonHandle((m_Windowname $ ".PaymentPostSendBtn"));
	SendListPrevBtn = GetButtonHandle((m_Windowname $ ".SendListPrevBtn"));
	SendListNextBtn = GetButtonHandle((m_Windowname $ ".SendListNextBtn"));
	SendDelBtn = GetButtonHandle((m_Windowname $ ".SendDelBtn"));
	Empty_Txt = GetTextBoxHandle((m_Windowname $ ".Empty_Txt"));
	Empty_Txt.HideWindow();
	ReceivePostCheck_all = GetCheckBoxHandle((m_Windowname $ ".ReceivePost.ReceivePostCheck_all"));
	SendPostCheck_all = GetCheckBoxHandle((m_Windowname $ ".SendPost.SendPostCheck_all"));
	Limit_Txt_Receive = GetTextBoxHandle((m_Windowname $ ".ReceivePost.Limit_Txt"));
	Limit_Txt_Sent = GetTextBoxHandle((m_Windowname $ ".SendPost.Limit_Txt"));
	receivedPostList = GetRichListCtrlHandle((m_Windowname $ ".ReceivePost.ReceivePostList"));
	receivedPostList.SetAppearTooltipAtMouseX(true);
	receivedPostList.SetUseStripeBackTexture(false);
	receivedPostList.SetSelectedSelTooltip(false);
	SentPostList = GetRichListCtrlHandle((m_Windowname $ ".SendPost.SendPostList"));
	SentPostList.SetAppearTooltipAtMouseX(true);
	SentPostList.SetUseStripeBackTexture(false);
	SentPostList.SetSelectedSelTooltip(false);
	return;
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	getInstanceL2Util().checkIsPrologueGrowType(string(self));
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 4710:
			OnEVStartReceivedPostList(param);
			break;
		case 4720:
			OnEVAddReceivedPostList(param);
			break;
		case 4730:
			OnEVEndReceivedPostList();
			break;
		case 4750:
			OnEVStartSentPostList(param);
			break;
		case 4760:
			OnEVAddSentPostList(param);
			break;
		case 4770:
			OnEVEndSentPostList();
			break;
		case 1710:
			OnEVDialogOk();
			break;
		case 4793:
			OnDeleteReceivedPost(param);
			break;
		case 4794:
			OnOpenStateReceivedPost(param);
			break;
		case 4795:
			OnReceivedStateReceivedPost(param);
			break;
		case 4796:
			OnDeleteSentPost(param);
			break;
		case 4797:
			OnOpenStateSentPost(param);
			break;
		case 4798:
			OnReceivedStateSentPost(param);
			break;
		default:
			break;
	}
	return;
}

function HandleTabDisable()
{
	TabCtrl.DisableWindow();
	Me.SetTimer(0, 1000);
	return;
}

event OnTimer(int tID)
{
	TabCtrl.EnableWindow();
	Me.KillTimer(tID);
	return;
}

event OnClickButton(string a_ButtonID)
{
	local PostWriteWnd Script;

	switch(a_ButtonID)
	{
		case "TabCtrl0":
			ReceivePostCheck_all.ShowWindow();
			SendPostCheck_all.HideWindow();
			RequestRequestReceivedPostList();
			HandleTabDisable();
			break;
		case "TabCtrl1":
			ReceivePostCheck_all.HideWindow();
			SendPostCheck_all.ShowWindow();
			RequestRequestSentPostList();
			HandleTabDisable();
			break;
		case "ReceiveListPrevBtn":
			ReceivedListPrevBtn();
			break;
		case "ReceiveListNextBtn":
			ReceivedListNextBtn();
			break;
		case "SendListPrevBtn":
			SentListPrevBtn();
			break;
		case "SendListNextBtn":
			SentListNextBtn();
			break;
		case "PostSendBtn":
			if(!GetWindowHandle("PostWriteWnd").IsShowWindow())
			{
				Script = PostWriteWnd(GetScript("PostWriteWnd"));
				RequestPostItemList();
				Script.ClearAll();
				GetWindowHandle("PostWriteWnd").ShowWindow();
				GetWindowHandle("PostWriteWnd").SetFocus();
			}
			break;
		case "PaymentPostSendBtn":
			if(!GetWindowHandle("PostWriteWnd").IsShowWindow())
			{
				Script = PostWriteWnd(GetScript("PostWriteWnd"));
				RequestPostItemList();
				Script.ClearAll();
				GetWindowHandle("PostWriteWnd").ShowWindow();
				GetWindowHandle("PostWriteWnd").SetFocus();
				Script.EnableSafetyAdena();
			}
			break;
		case "ReceiveDelBtn":
			ViewReceiveDelDialog();
			break;
		case "SendDelBtn":
			ViewSendDelDialog();
			break;
		default:
			ChkBoxHandle(a_ButtonID);
			break;
	}
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "ReceivePostList":
			HandleOnDbClickListCtrlReceivePost();
			return;
		case "SendPostList":
			HandleOnDbClickListCtrlSendPost();
			break;
		default:
			break;
	}
	return;
}

event OnClickCheckBox(string strID)
{
	if((strID == "ReceivePostCheck_all"))
	{
		HandleClickReceivedPostCheckBoxAll();
	}
	else if((strID == "SendPostCheck_all"))
	{
		HandleClickSentPostCheckBoxAll();
	}
	return;
}

event OnTick()
{
	HandleValidate();
	m_hOwnerWnd.DisableTick();
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

function OnDeleteReceivedPost(string param)
{
	local int mailID, mailIndex;

	ParseInt(param, "mailID", mailID);
	mailIndex = GetReceivedPostMailIndex(mailID);
	if((mailIndex < 0))
	{
		return;
	}
	receivedInfoList.Remove(mailIndex, 1);
	if((CurrentState() != 0))
	{
		return;
	}
	Validate(2);
	Validate(0);
	return;
}

function OnOpenStateReceivedPost(string param)
{
	local int mailID, mailIndex;

	ParseInt(param, "mailID", mailID);
	mailIndex = GetReceivedPostMailIndex(mailID);
	if((mailIndex < 0))
	{
		return;
	}
	receivedInfoList[mailIndex].notOpend = 0;
	if((CurrentState() == 0))
	{
		ModifyRichlistReceive(mailID);
	}
	return;
}

function OnReceivedStateReceivedPost(string param)
{
	local int mailID, mailIndex;

	ParseInt(param, "mailID", mailID);
	mailIndex = GetReceivedPostMailIndex(mailID);
	if((mailIndex < 0))
	{
		return;
	}
	receivedInfoList[mailIndex].withItem = 0;
	if((CurrentState() == 0))
	{
		ModifyRichlistReceive(mailID);
	}
	return;
}

function OnDeleteSentPost(string param)
{
	local int mailID, mailIndex;

	ParseInt(param, "mailID", mailID);
	mailIndex = GetSentPostMailIndex(mailID);
	if((mailIndex < 0))
	{
		return;
	}
	sentInfoList.Remove(mailIndex, 1);
	if((CurrentState() != 1))
	{
		return;
	}
	Validate(3);
	Validate(1);
	return;
}

function OnOpenStateSentPost(string param)
{
	local int mailID, mailIndex;

	ParseInt(param, "mailID", mailID);
	mailIndex = GetSentPostMailIndex(mailID);
	if((mailIndex < 0))
	{
		return;
	}
	sentInfoList[mailIndex].notOpend = 0;
	if((CurrentState() == 1))
	{
		ModifyRichlistSent(mailID);
	}
	return;
}

function OnReceivedStateSentPost(string param)
{
	local int mailID, mailIndex;

	ParseInt(param, "mailID", mailID);
	mailIndex = GetSentPostMailIndex(mailID);
	if((mailIndex < 0))
	{
		return;
	}
	sentInfoList[mailIndex].withItem = 0;
	if((CurrentState() == 1))
	{
		ModifyRichlistSent(mailID);
	}
	return;
}

function OnEVStartReceivedPostList(string param)
{
	local int ReceivedMailCount;

	if(!bNotOpen)
	{
		ClearReceivedInfo();
		ParseInt(param, "ReceivedMailCount", ReceivedMailCount);
		receivedInfoList.Length = 0;
		Me.ShowWindow();
		Me.SetFocus();
		TabCtrl.SetTopOrder(0, true);
	}
	bNotOpen = false;
	return;
}

function OnEVAddReceivedPostList(string param)
{
	local ReceivedPostMSG receivedMSG;

	ParseInt(param, "MailID", receivedMSG.mailID);
	ParseString(param, "Title", receivedMSG.Title);
	ParseString(param, "SenderName", receivedMSG.senderName);
	ParseInt(param, "Trade", receivedMSG.TRADE);
	ParseInt(param, "NotOpend", receivedMSG.notOpend);
	ParseInt(param, "ReturnAble", receivedMSG.returnAble);
	ParseInt(param, "WithItem", receivedMSG.withItem);
	ParseInt(param, "Returnd", receivedMSG.returnd);
	ParseInt(param, "SentBySystem", receivedMSG.sentBySystem);
	ParseFloat(param, "DiffTime", receivedMSG.diffTime);
	receivedMSG.CheckBoxState = 0;
	receivedInfoList.Insert(GetReceivedPostLength(), 1);
	receivedInfoList[(GetReceivedPostLength() - 1)] = receivedMSG;
	return;
}

function ReverseReceivedPostListArray()
{
	local array<ReceivedPostMSG> ArrayItem;
	local int Index, i;

	Index = GetReceivedPostLength();
	i = (Index - 1);
	while((i >= 0))
	{
		ArrayItem.Insert(ArrayItem.Length, 1);
		ArrayItem[(ArrayItem.Length - 1)] = receivedInfoList[i];
		i--;
	}
	receivedInfoList = ArrayItem;
	return;
}

function OnEVEndReceivedPostList()
{
	ReverseReceivedPostListArray();
	curReceivedPage = 0;
	ResetReceivedPostPageNum();
	Validate(2);
	Validate(0);
	if((GetReceivedPostLength() > 0))
	{
		Empty_Txt.HideWindow();
	}
	return;
}

function OnEVStartSentPostList(string param)
{
	local int SentMailCount;
	local WindowHandle m_inventoryWnd;

	m_inventoryWnd = GetWindowHandle("InventoryWnd");
	ClearSentInfo();
	ParseInt(param, "SentMailCount", SentMailCount);
	sentInfoList.Length = 0;
	Me.ShowWindow();
	TabCtrl.SetTopOrder(1, true);
	if(m_inventoryWnd.IsShowWindow())
	{
		m_inventoryWnd.HideWindow();
	}
	return;
}

function OnEVAddSentPostList(string param)
{
	local SentPostMSG sentMsg;

	ParseInt(param, "MailID", sentMsg.mailID);
	ParseString(param, "Title", sentMsg.Title);
	ParseString(param, "ReceiverName", sentMsg.receivername);
	ParseInt(param, "Trade", sentMsg.TRADE);
	ParseInt(param, "NotOpend", sentMsg.notOpend);
	ParseInt(param, "ReturnAble", sentMsg.returnAble);
	ParseInt(param, "WithItem", sentMsg.withItem);
	ParseInt(param, "SentBySystem", sentMsg.sentBySystem);
	ParseFloat(param, "DiffTime", sentMsg.diffTime);
	sentMsg.CheckBoxState = 0;
	sentInfoList.Insert(GetSentPostLength(), 1);
	sentInfoList[(GetSentPostLength() - 1)] = sentMsg;
	return;
}

function ReverseSendPostListArray()
{
	local array<SentPostMSG> ArrayItem;
	local int Index, i;

	Index = GetSentPostLength();
	i = (Index - 1);
	while((i >= 0))
	{
		ArrayItem.Insert(ArrayItem.Length, 1);
		ArrayItem[(ArrayItem.Length - 1)] = sentInfoList[i];
		i--;
	}
	sentInfoList = ArrayItem;
	return;
}

function OnEVEndSentPostList()
{
	ReverseSendPostListArray();
	sentPageNum = (GetSentPostLength() / 6);
	if(((float(GetSentPostLength()) % 6.0000000) != 0.0000000))
	{
		sentPageNum++;
	}
	curSentPage = 0;
	ShowSentLists();
	ShowSentNumber();
	if((GetSentPostLength() > 0))
	{
		Empty_Txt.HideWindow();
	}
	Validate(3);
	Validate(1);
	return;
}

function OnEVDialogOk()
{
	local int Id, Reserved;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		if((Id == 1111))
		{
			DeleteSelectedReceivedMail();
			ClearReceivedCheckBox();
		}
		else if((Id == 3333))
		{
			DeleteSelectedSentMail();
			ClearSentCheckBox();
		}
		else if((Id == 5555))
		{
			Reserved = DialogGetReservedInt();
			RequestRequestReceivedPost(Reserved);
		}
	}
	return;
}

function ChkBoxHandle(string btnStr)
{
	local int Index;
	local array<string> splited;

	if((InStr(btnStr, "unsableReceiveTexture_") > 0))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(14019));
		return;
	}
	else if((InStr(btnStr, "unsableSentTexture_") > 0))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(14020));
		return;
	}
	if((InStr(btnStr, "chkBox_") < 0))
	{
		return;
	}
	Split(btnStr, "_", splited);
	Index = int(splited[1]);
	switch(CurrentState())
	{
		case 0:
			RevertReceiveCheckState(Index);
			break;
		case 1:
			RevertSentCheckState(Index);
			break;
		default:
			break;
	}
	return;
}

function ViewReceiveDelDialog()
{
	local int i;

	i = 0;
	while((i < GetReceivedPostLength()))
	{
		if((receivedInfoList[i].CheckBoxState == 0))
		{
			i++;
			continue;
		}
		DialogHide();
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(3014));
		DialogSetID(1111);
		return;
		i++;
	}
	DialogHide();
	DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3015));
	DialogSetID(2222);
	return;
}

function ViewSendDelDialog()
{
	local int i;

	i = 0;
	while((i < GetSentPostLength()))
	{
		if((sentInfoList[i].CheckBoxState == 0))
		{
			i++;
			continue;
		}
		DialogHide();
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(3014));
		DialogSetID(3333);
		return;
		i++;
	}
	DialogHide();
	DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3015));
	DialogSetID(4444);
	return;
}

function DeleteSelectedReceivedMail()
{
	local int i;
	local array<int> deleteReceivedList;

	i = 0;
	while((i < GetReceivedPostLength()))
	{
		if((receivedInfoList[i].CheckBoxState == 1))
		{
			deleteReceivedList.Insert(deleteReceivedList.Length, 1);
			deleteReceivedList[(deleteReceivedList.Length - 1)] = receivedInfoList[i].mailID;
		}
		i++;
	}
	if((deleteReceivedList.Length > 0))
	{
		RequestDeleteReceivedPost(deleteReceivedList);
	}
	return;
}

function DeleteSelectedSentMail()
{
	local int i;
	local array<int> deleteSentList;

	i = 0;
	while((i < GetSentPostLength()))
	{
		if((sentInfoList[i].CheckBoxState == 1))
		{
			deleteSentList.Insert(deleteSentList.Length, 1);
			deleteSentList[(deleteSentList.Length - 1)] = sentInfoList[i].mailID;
		}
		i++;
	}
	if((deleteSentList.Length > 0))
	{
		RequestDeleteSentPost(deleteSentList);
	}
	return;
}

function ChkPageBtnsReceive()
{
	if((curReceivedPage == 0))
	{
		ReceiveListPrevBtn.DisableWindow();
	}
	else
	{
		ReceiveListPrevBtn.EnableWindow();
	}
	if((curReceivedPage == (receivedPageNum - 1)))
	{
		ReceiveListNextBtn.DisableWindow();
	}
	else
	{
		ReceiveListNextBtn.EnableWindow();
	}
	return;
}

function ReceivedListPrevBtn()
{
	curReceivedPage = Max(0, (curReceivedPage - 1));
	Validate(0);
	return;
}

function ReceivedListNextBtn()
{
	curReceivedPage = Min((curReceivedPage + 1), (receivedPageNum - 1));
	Validate(0);
	return;
}

function ChkPageBtnsSent()
{
	if((curSentPage == 0))
	{
		SendListPrevBtn.DisableWindow();
	}
	else
	{
		SendListPrevBtn.EnableWindow();
	}
	if((curSentPage == (sentPageNum - 1)))
	{
		SendListNextBtn.DisableWindow();
	}
	else
	{
		SendListNextBtn.EnableWindow();
	}
	return;
}

function SentListPrevBtn()
{
	curSentPage = Max(0, (curSentPage - 1));
	Validate(1);
	return;
}

function SentListNextBtn()
{
	curSentPage = Min((curSentPage + 1), (sentPageNum - 1));
	Validate(1);
	return;
}

function ResetReceivedPostPageNum()
{
	receivedPageNum = (GetReceivedPostLength() / 6);
	if(((float(GetReceivedPostLength()) % 6.0000000) != 0.0000000))
	{
		receivedPageNum++;
	}
	return;
}

function ReSetReceivedPostCurPage()
{
	curReceivedPage = Max(0, Min((receivedPageNum - 1), curReceivedPage));
	return;
}

function ResetSentPostPageNum()
{
	sentPageNum = (GetSentPostLength() / 6);
	if(((float(GetSentPostLength()) % 6.0000000) != 0.0000000))
	{
		sentPageNum++;
	}
	return;
}

function ReSetSentPostCurPage()
{
	curSentPage = Max(0, Min((sentPageNum - 1), curSentPage));
	return;
}

function ShowReceiveNumber()
{
	Limit_Txt_Receive.SetText(((string(GetReceivedPostLength()) $ "/") $ string(240)));
	return;
}

function ShowReceiveListNumber()
{
	ReceiveListNumber.SetText(((string((curReceivedPage + 1)) $ "/") $ string(Max(receivedPageNum, 1))));
	ChkPageBtnsReceive();
	return;
}

function ShowSentNumber()
{
	Limit_Txt_Sent.SetText(((string(GetSentPostLength()) $ "/") $ string(240)));
	return;
}

function ShowSentListNumber()
{
	SendListNumber.SetText(((string((curSentPage + 1)) $ "/") $ string(Max(sentPageNum, 1))));
	ChkPageBtnsSent();
	return;
}

function ShowReceivedLists()
{
	local int i, Start, End;

	receivedPostList.ShowWindow();
	SentPostList.HideWindow();
	receivedPostList.DeleteAllItem();
	if(((curReceivedPage < 0) || (curReceivedPage >= receivedPageNum)))
	{
		return;
	}
	Start = (curReceivedPage * 6);
	End = Min(GetReceivedPostLength(), (Start + 6));
	i = Start;
	while((i < End))
	{
		receivedPostList.InsertRecord(MakeRowDataReceive(i));
		i++;
	}
	ViewReceivedCheckBoxAll();
	ShowReceiveListNumber();
	return;
}

function RichListCtrlRowData MakeRowDataReceive(int listIndex)
{
	local RichListCtrlRowData rowData;
	local ReceivedPostMSG currentReceivedPostMSG;
	local Color tmpColor;

	rowData.cellDataList.Length = 4;
	currentReceivedPostMSG = receivedInfoList[listIndex];
	tmpColor = GetTextColorByType(currentReceivedPostMSG.notOpend, currentReceivedPostMSG.TRADE);
	rowData.nReserved1 = INT64(listIndex);
	if(((currentReceivedPostMSG.withItem == 0) && (currentReceivedPostMSG.notOpend == 0)))
	{
		rowData.cellDataList[0].nReserved1 = receivedInfoList[listIndex].CheckBoxState;
		if((rowData.cellDataList[0].nReserved1 == 1))
		{
			AddRichListCtrlButton(rowData.cellDataList[0].drawitems, ("chkBox_" $ string(listIndex)), 0, 0, "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox", "L2UI.Control.CheckBox_checked", 16, 16, 16, 16);
		}
		else
		{
			AddRichListCtrlButton(rowData.cellDataList[0].drawitems, ("chkBox_" $ string(listIndex)), 0, 0, "L2UI.Control.CheckBox", "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox", 16, 16, 16, 16);
		}
	}
	else
	{
		AddRichListCtrlButton(rowData.cellDataList[0].drawitems, ("unsableSentTexture_" $ string(listIndex)), 0, 0, "L2UI_NewTex.PostWnd.CheckBox_unable", "L2UI_NewTex.PostWnd.CheckBox_unable", "L2UI_NewTex.PostWnd.CheckBox_unable", 16, 16, 16, 16);
	}
	if((currentReceivedPostMSG.sentBySystem > 0))
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_NewTex.PostWnd.PostWndIcon_L2", 52, 52);
	}
	else if((currentReceivedPostMSG.TRADE == 1))
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_NewTex.PostWnd.PostWndIcon_Adena", 52, 52);
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_NewTex.PostWnd.PostWndIcon_Letter", 52, 52);
	}
	if((currentReceivedPostMSG.withItem == 1))
	{
		if((currentReceivedPostMSG.notOpend == 0))
		{
			addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_NewTex.PostWnd.Icon_Clip2", 16, 39, 0, 5);
		}
		else
		{
			addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_NewTex.PostWnd.Icon_Clip", 16, 39, 0, 5);
		}
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_CT1.EmptyBtn", 16, 39, 0, 5);
	}
	if(((currentReceivedPostMSG.sentBySystem == 1) && (currentReceivedPostMSG.returnd == 1)))
	{
		if((currentReceivedPostMSG.returnd == 1))
		{
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, ((("[" $ GetSystemString(2090)) $ "]") @ currentReceivedPostMSG.senderName), tmpColor, false, 4, 2);
		}
		else
		{
			AddRichListCtrlString(rowData.cellDataList[2].drawitems, (("[" $ GetSystemString(2211)) $ "]"), tmpColor, false, 4, 2);
		}
	}
	else if((currentReceivedPostMSG.sentBySystem > 0))
	{
		AddRichListCtrlString(rowData.cellDataList[2].drawitems, currentReceivedPostMSG.senderName, tmpColor, false, 4, 2);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[2].drawitems, currentReceivedPostMSG.senderName, tmpColor, false, 4, 2);
	}
	AddRichListCtrlNewLine(rowData.cellDataList[2].drawitems, 14, 0);
	if((currentReceivedPostMSG.returnd == 1))
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_NewTex.PostWnd.Icon_Return", 26, 26, 4, 0);
		AddEllipsisString(rowData.cellDataList[2].drawitems, currentReceivedPostMSG.Title, 308, tmpColor, false, true, 2, 7);
	}
	else if((currentReceivedPostMSG.notOpend == 0))
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_NewTex.PostWnd.Icon_ReadLetter", 26, 26);
		AddEllipsisString(rowData.cellDataList[2].drawitems, currentReceivedPostMSG.Title, 308, tmpColor, false, true, 0, 7);
	}
	else if((currentReceivedPostMSG.notOpend == 1))
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_NewTex.PostWnd.Icon_NewLetter", 26, 26);
		AddEllipsisString(rowData.cellDataList[2].drawitems, currentReceivedPostMSG.Title, 308, tmpColor, false, true, 0, 7);
	}
	if((currentReceivedPostMSG.diffTime < 86400.0000000))
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, ConvertTimeToString(currentReceivedPostMSG.diffTime), getInstanceL2Util().Red, false, 2, 2);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, ConvertTimeToString(currentReceivedPostMSG.diffTime), getInstanceL2Util().BrightWhite, false, 2, 2);
	}
	return rowData;
}

function ShowSentLists()
{
	local int i, Start, End;

	receivedPostList.HideWindow();
	SentPostList.ShowWindow();
	SentPostList.DeleteAllItem();
	if(((curSentPage < 0) || (curSentPage >= sentPageNum)))
	{
		return;
	}
	Start = (curSentPage * 6);
	End = Min(GetSentPostLength(), (Start + 6));
	i = Start;
	while((i < End))
	{
		SentPostList.InsertRecord(MakeRowDataSent(i));
		i++;
	}
	ViewSentCheckBoxAll();
	ShowSentListNumber();
	return;
}

function RichListCtrlRowData MakeRowDataSent(int listIndex)
{
	local Color tmpColor;
	local RichListCtrlRowData rowData;
	local SentPostMSG currentSentPostMSG;

	rowData.cellDataList.Length = 4;
	currentSentPostMSG = sentInfoList[listIndex];
	tmpColor = GetTextColorByType(currentSentPostMSG.notOpend, currentSentPostMSG.TRADE);
	rowData.nReserved1 = INT64(listIndex);
	if((currentSentPostMSG.withItem == 0))
	{
		rowData.cellDataList[0].nReserved1 = currentSentPostMSG.CheckBoxState;
		if((rowData.cellDataList[0].nReserved1 == 1))
		{
			AddRichListCtrlButton(rowData.cellDataList[0].drawitems, ("chkBox_" $ string(listIndex)), 0, 0, "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox", "L2UI.Control.CheckBox_checked", 16, 16, 16, 16);
		}
		else
		{
			AddRichListCtrlButton(rowData.cellDataList[0].drawitems, ("chkBox_" $ string(listIndex)), 0, 0, "L2UI.Control.CheckBox", "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox", 16, 16, 16, 16);
		}
	}
	else
	{
		AddRichListCtrlButton(rowData.cellDataList[0].drawitems, ("unsableReceiveTexture_" $ string(listIndex)), 0, 0, "L2UI_NewTex.PostWnd.CheckBox_unable", "L2UI_NewTex.PostWnd.CheckBox_unable", "L2UI_NewTex.PostWnd.CheckBox_unable", 16, 16, 16, 16);
	}
	if((currentSentPostMSG.sentBySystem > 0))
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_NewTex.PostWnd.PostWndIcon_L2", 52, 52);
	}
	else if((currentSentPostMSG.TRADE == 1))
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_NewTex.PostWnd.PostWndIcon_Adena", 52, 52);
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_NewTex.PostWnd.PostWndIcon_Letter", 52, 52);
	}
	if((currentSentPostMSG.withItem == 1))
	{
		if((currentSentPostMSG.notOpend == 0))
		{
			addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_NewTex.PostWnd.Icon_Clip2", 16, 39, 0, 5);
		}
		else
		{
			addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_NewTex.PostWnd.Icon_Clip", 16, 39, 0, 5);
		}
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_CT1.EmptyBtn", 16, 39, 0, 5);
	}
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, currentSentPostMSG.receivername, tmpColor, false, 4, 2);
	AddRichListCtrlNewLine(rowData.cellDataList[2].drawitems, 14, 0);
	if((currentSentPostMSG.notOpend == 0))
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_NewTex.PostWnd.Icon_ReadLetter", 26, 26);
	}
	else if((currentSentPostMSG.notOpend == 1))
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_NewTex.PostWnd.Icon_NewLetter", 26, 26);
	}
	AddEllipsisString(rowData.cellDataList[2].drawitems, currentSentPostMSG.Title, 308, tmpColor, false, true, 0, 7);
	if((currentSentPostMSG.diffTime < 86400.0000000))
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, ConvertTimeToString(currentSentPostMSG.diffTime), getInstanceL2Util().Red, false, 2, 2);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, ConvertTimeToString(currentSentPostMSG.diffTime), getInstanceL2Util().BrightWhite, false, 2, 2);
	}
	return rowData;
}

function HandleOnDbClickListCtrlReceivePost()
{
	local int Index;
	local ReceivedPostMSG receivedPostInfo;

	if((GetSelectedReceivedInfoListIndex(Index) == false))
	{
		return;
	}
	receivedPostInfo = receivedInfoList[Index];
	if(((receivedPostInfo.withItem == 1) && ((receivedPostInfo.returnd == 1) || (receivedPostInfo.TRADE == 1))))
	{
		DialogHide();
		DialogSetReservedInt(receivedPostInfo.mailID);
		if((receivedPostInfo.returnd == 1))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13193));
		}
		else if((receivedPostInfo.TRADE == 1))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(3087));
		}
		DialogSetID(5555);
		Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(0, 0);
	}
	else
	{
		RequestRequestReceivedPost(receivedPostInfo.mailID);
	}
	return;
}

function HandleOnDbClickListCtrlSendPost()
{
	local int mailID;

	if((GetMailIDSelectedSentPost(mailID) == false))
	{
		return;
	}
	RequestRequestSentPost(mailID);
	return;
}

function ClearReceivedInfo()
{
	curReceivedPage = 0;
	receivedPageNum = 1;
	receivedInfoList.Length = 0;
	ReceivePostCheck_all.SetCheck(false);
	Empty_Txt.ShowWindow();
	ShowReceiveListNumber();
	ShowReceiveNumber();
	ReceiveListPrevBtn.DisableWindow();
	ReceiveListNextBtn.DisableWindow();
	return;
}

function ClearSentInfo()
{
	curSentPage = 0;
	sentPageNum = 1;
	sentInfoList.Length = 0;
	SendPostCheck_all.SetCheck(false);
	ShowSentNumber();
	ShowSentListNumber();
	Empty_Txt.ShowWindow();
	SendListPrevBtn.DisableWindow();
	SendListPrevBtn.DisableWindow();
	return;
}

function RevertSentCheckState(int Index)
{
	if((sentInfoList[Index].CheckBoxState == 0))
	{
		SetCheckSent(Index);
	}
	else
	{
		SetUnCheckSent(Index);
	}
	ViewSentCheckBoxAll();
	return;
}

function ClearSentCheckBox()
{
	SendPostCheck_all.SetCheck(false);
	return;
}

function ViewSentCheckBoxAll()
{
	if((IsAllCheckSentCheckBoxCurrentPage() == true))
	{
		SendPostCheck_all.SetCheck(true);
	}
	else
	{
		SendPostCheck_all.SetCheck(false);
	}
	return;
}

function bool IsAllCheckSentCheckBoxCurrentPage()
{
	local int i, Start, End;
	local bool chkAble;

	Start = (curSentPage * 6);
	End = Min(GetSentPostLength(), (Start + 6));
	i = Start;
	while((i < End))
	{
		if((sentInfoList[i].withItem == 0))
		{
			chkAble = true;
			if((sentInfoList[i].CheckBoxState == 0))
			{
				return false;
			}
		}
		i++;
	}
	return chkAble;
}

function HandleClickSentPostCheckBoxAll()
{
	local int i, Start, End;
	local bool chkAble;

	Start = (curSentPage * 6);
	End = Min(GetSentPostLength(), (Start + 6));
	i = Start;
	while((i < End))
	{
		if((sentInfoList[i].withItem == 1))
		{
			i++;
			continue;
		}
		chkAble = true;
		if(SendPostCheck_all.IsChecked())
		{
			SetCheckSent(i);
			sentInfoList[i].CheckBoxState = 1;
		}
		else
		{
			SetUnCheckSent(i);
			sentInfoList[i].CheckBoxState = 0;
		}
		Debug((("체크 상태 변경 :" @ string(i)) @ string(sentInfoList[i].CheckBoxState)));  // EN?: Check status change:
		i++;
	}
	if(!chkAble)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(14020));
	}
	if((!chkAble && SendPostCheck_all.IsChecked()))
	{
		SendPostCheck_all.SetCheck(false);
	}
	return;
}

function SetCheckSent(int Index)
{
	local int listIndex;
	local RichListCtrlRowData rowData;

	sentInfoList[Index].CheckBoxState = 1;
	listIndex = int((float(Index) % 6.0000000));
	SentPostList.GetRec(listIndex, rowData);
	rowData.cellDataList[0].nReserved1 = 1;
	rowData.cellDataList[0].drawitems[0].btnInfo.normalTex.sTex = "L2UI.Control.CheckBox_checked";
	rowData.cellDataList[0].drawitems[0].btnInfo.pushedTex.sTex = "L2UI.Control.CheckBox_checked";
	rowData.cellDataList[0].drawitems[0].btnInfo.highlightTex.sTex = "L2UI.Control.CheckBox_checked";
	SentPostList.ModifyRecord(listIndex, rowData);
	return;
}

function SetUnCheckSent(int Index)
{
	local int listIndex;
	local RichListCtrlRowData rowData;

	SentPostList.GetRec(Index, rowData);
	listIndex = int((float(Index) % 6.0000000));
	SentPostList.GetRec(listIndex, rowData);
	sentInfoList[Index].CheckBoxState = 0;
	rowData.cellDataList[0].nReserved1 = 0;
	rowData.cellDataList[0].drawitems[0].btnInfo.normalTex.sTex = "L2UI.Control.CheckBox";
	rowData.cellDataList[0].drawitems[0].btnInfo.highlightTex.sTex = "L2UI.Control.CheckBox";
	rowData.cellDataList[0].drawitems[0].btnInfo.pushedTex.sTex = "L2UI.Control.CheckBox";
	SentPostList.ModifyRecord(listIndex, rowData);
	return;
}

function _RequestCommitionOnly()
{
	RequestRequestReceivedPostList();
	bNotOpen = true;
	return;
}

function RevertReceiveCheckState(int Index)
{
	if((receivedInfoList[Index].CheckBoxState == 0))
	{
		SetCheckReceive(Index);
	}
	else
	{
		SetUnCheckReceive(Index);
	}
	ViewReceivedCheckBoxAll();
	return;
}

function ClearReceivedCheckBox()
{
	ReceivePostCheck_all.SetCheck(false);
	return;
}

function ViewReceivedCheckBoxAll()
{
	if((IsAllCheckReceivedCheckBoxCurrentPage() == true))
	{
		ReceivePostCheck_all.SetCheck(true);
	}
	else
	{
		ReceivePostCheck_all.SetCheck(false);
	}
	return;
}

function bool IsAllCheckReceivedCheckBoxCurrentPage()
{
	local int i, Start, End;
	local bool chkAble;

	Start = (curReceivedPage * 6);
	End = Min(GetReceivedPostLength(), (Start + 6));
	i = Start;
	while((i < End))
	{
		if(((receivedInfoList[i].withItem == 0) && (receivedInfoList[i].notOpend == 0)))
		{
			chkAble = true;
			if((receivedInfoList[i].CheckBoxState == 0))
			{
				return false;
			}
		}
		i++;
	}
	return chkAble;
}

function HandleClickReceivedPostCheckBoxAll()
{
	local int i, Start, End;
	local bool chkAble;

	Start = (curReceivedPage * 6);
	End = Min(GetReceivedPostLength(), (Start + 6));
	i = Start;
	while((i < End))
	{
		if((receivedInfoList[i].withItem == 1))
		{
			i++;
			continue;
		}
		if((receivedInfoList[i].notOpend == 1))
		{
			i++;
			continue;
		}
		chkAble = true;
		if(ReceivePostCheck_all.IsChecked())
		{
			SetCheckReceive(i);
			receivedInfoList[i].CheckBoxState = 1;
			i++;
			continue;
		}
		SetUnCheckReceive(i);
		receivedInfoList[i].CheckBoxState = 0;
		i++;
	}
	if(!chkAble)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(14019));
	}
	if((!chkAble && ReceivePostCheck_all.IsChecked()))
	{
		ReceivePostCheck_all.SetCheck(false);
	}
	return;
}

function SetCheckReceive(int Index)
{
	local int listIndex;
	local RichListCtrlRowData rowData;

	receivedInfoList[Index].CheckBoxState = 1;
	listIndex = int((float(Index) % 6.0000000));
	receivedPostList.GetRec(listIndex, rowData);
	rowData.cellDataList[0].nReserved1 = 1;
	rowData.cellDataList[0].drawitems[0].btnInfo.normalTex.sTex = "L2UI.Control.CheckBox_checked";
	rowData.cellDataList[0].drawitems[0].btnInfo.pushedTex.sTex = "L2UI.Control.CheckBox";
	rowData.cellDataList[0].drawitems[0].btnInfo.highlightTex.sTex = "L2UI.Control.CheckBox_checked";
	receivedPostList.ModifyRecord(listIndex, rowData);
	return;
}

function SetUnCheckReceive(int Index)
{
	local int listIndex;
	local RichListCtrlRowData rowData;

	receivedPostList.GetRec(Index, rowData);
	listIndex = int((float(Index) % 6.0000000));
	receivedPostList.GetRec(listIndex, rowData);
	receivedInfoList[Index].CheckBoxState = 0;
	rowData.cellDataList[0].nReserved1 = 0;
	rowData.cellDataList[0].drawitems[0].btnInfo.normalTex.sTex = "L2UI.Control.CheckBox";
	rowData.cellDataList[0].drawitems[0].btnInfo.highlightTex.sTex = "L2UI.Control.CheckBox";
	rowData.cellDataList[0].drawitems[0].btnInfo.pushedTex.sTex = "L2UI.Control.CheckBox_checked";
	receivedPostList.ModifyRecord(listIndex, rowData);
	return;
}

function Validate(int flag)
{
	validateFlag = (validateFlag | GetBitSlotNum(flag));
	m_hOwnerWnd.EnableTick();
	return;
}

function HandleValidate()
{
	if(((validateFlag & GetBitSlotNum(3)) > 0))
	{
		ResetSentPostPageNum();
		ReSetSentPostCurPage();
		ShowSentNumber();
		ShowSentListNumber();
	}
	if(((validateFlag & GetBitSlotNum(2)) > 0))
	{
		ResetReceivedPostPageNum();
		ReSetReceivedPostCurPage();
		ShowReceiveNumber();
		ShowReceiveListNumber();
	}
	if(((validateFlag & GetBitSlotNum(0)) > 0))
	{
		ShowReceivedLists();
	}
	if(((validateFlag & GetBitSlotNum(1)) > 0))
	{
		ShowSentLists();
	}
	validateFlag = 0;
	return;
}

function ModifyRichlistSent(int mailID)
{
	local int richlistIndex;
	local RichListCtrlRowData rowData;

	richlistIndex = GetRichIndexWithMailIDSent(mailID);
	if((richlistIndex == -1))
	{
		return;
	}
	SentPostList.GetRec(richlistIndex, rowData);
	SentPostList.ModifyRecord(richlistIndex, MakeRowDataSent(int(rowData.nReserved1)));
	return;
}

function ModifyRichlistReceive(int mailID)
{
	local int richlistIndex;
	local RichListCtrlRowData rowData;

	richlistIndex = GetRichIndexWithMailIDReceived(mailID);
	if((richlistIndex == -1))
	{
		return;
	}
	receivedPostList.GetRec(richlistIndex, rowData);
	receivedPostList.ModifyRecord(richlistIndex, MakeRowDataReceive(int(rowData.nReserved1)));
	return;
}

function int CurrentState()
{
	return TabCtrl.GetTopIndex();
}

function int GetSentPostLength()
{
	return sentInfoList.Length;
}

function int GetReceivedPostLength()
{
	return receivedInfoList.Length;
}

function int GetBitSlotNum(int flag)
{
	return ExpInt(2, flag);
}

function Color GetTextColorByType(int notOpened, int TRADE)
{
	if(((notOpened == 0) && (TRADE == 0)))
	{
		return GetColor(130, 130, 130, 255);
	}
	else if(((notOpened == 1) && (TRADE == 0)))
	{
		return GetColor(220, 220, 220, 255);
	}
	else if(((notOpened == 0) && (TRADE == 1)))
	{
		return GetColor(145, 84, 35, 255);
	}
	return GetColor(255, 114, 0, 255);
}

function bool GetSentSelectedListCtrlItem(out RichListCtrlRowData rowData)
{
	local int Index;

	Index = SentPostList.GetSelectedIndex();
	if((Index >= 0))
	{
		SentPostList.GetRec(Index, rowData);
		return true;
	}
	return false;
}

function bool GetSelectedReceivedInfoListIndex(out int Index)
{
	local RichListCtrlRowData rowData;

	receivedPostList.GetSelectedRec(rowData);
	Index = int(rowData.nReserved1);
	return (receivedPostList.GetSelectedIndex() > -1);
}

function bool GetMailIDSelected(out int mailID)
{
	local int Index;

	if((GetSelectedReceivedInfoListIndex(Index) == false))
	{
		return false;
	}
	mailID = receivedInfoList[Index].mailID;
	return true;
}

function bool GetSelectedSentInfoListIndex(out int Index)
{
	local RichListCtrlRowData rowData;

	SentPostList.GetSelectedRec(rowData);
	Index = int(rowData.nReserved1);
	return (SentPostList.GetSelectedIndex() > -1);
}

function bool GetMailIDSelectedSentPost(out int mailID)
{
	local int Index;

	if((GetSelectedSentInfoListIndex(Index) == false))
	{
		return false;
	}
	mailID = sentInfoList[Index].mailID;
	return true;
}

function int GetReceivedPostMailIndex(int mailID)
{
	local int i;

	i = 0;
	while((i < GetReceivedPostLength()))
	{
		if((receivedInfoList[i].mailID == mailID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int GetSentPostMailIndex(int mailID)
{
	local int i;

	i = 0;
	while((i < GetSentPostLength()))
	{
		if((sentInfoList[i].mailID == mailID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int GetRichIndexWithMailIDReceived(int mailID)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < 6))
	{
		receivedPostList.GetRec(i, rowData);
		if((receivedInfoList[int(rowData.nReserved1)].mailID == mailID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int GetRichIndexWithMailIDSent(int mailID)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < 6))
	{
		SentPostList.GetRec(i, rowData);
		if((sentInfoList[int(rowData.nReserved1)].mailID == mailID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

defaultproperties
{
	m_Windowname="PostBoxWnd"
}
