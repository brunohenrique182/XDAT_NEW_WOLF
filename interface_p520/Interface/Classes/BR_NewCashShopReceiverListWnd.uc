class BR_NewCashShopReceiverListWnd extends UICommonAPI;

const DIALOGID_DelFriend = 1;
const MAX_FRIEND = 128;
const MAX_PLEDGE = 220;
const MAX_POSTFRIEND = 100;
const FRIEND_TAB = 0;
const PLEDGE_TAB = 1;
const POSTFRIEND_TAB = 2;

var string m_Windowname;
var WindowHandle Me;
var TextBoxHandle Description;
var TextureHandle DescriptionGroupBox;
var TextBoxHandle ListCount;
var TabHandle TabCtrl;
var TextureHandle ListGroupBox;
var TextureHandle TabLineTop;
var TextureHandle tabBg;
var WindowHandle BR_NewCashShopReceiverListWnd_Friends;
var ListCtrlHandle FriendsList;
var TextureHandle FriendsListDeco;
var WindowHandle BR_NewCashShopReceiverListWnd_Clan;
var ListCtrlHandle ClanList;
var TextureHandle ClanListDeco;
var WindowHandle BR_NewCashShopReceiverListWnd_Add;
var ListCtrlHandle AddList;
var ButtonHandle Btn_Add;
var ButtonHandle Btn_Del;
var TextureHandle AddListGroupBoxLine;
var TextureHandle AddListDeco;
var ButtonHandle CloseButton;
var WindowHandle BR_CashShopReceiverListAddWnd;
var int m_selectedTab;
var string countFriend;
var string countPledge;
var string countPostFriend;
var string selectFriend;
var int NumPostFriend;
var bool bPostFriendSelect;

function OnRegisterEvent()
{
	RegisterEvent(4970);
	RegisterEvent(5000);
	RegisterEvent(4990);
	RegisterEvent(4980);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(5040);
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	RegisterState("BR_NewCashShopReceiverListWnd", "TRAININGROOMSTATE");
	SetClosingOnESC();
	Initialize();
	Load();
	m_selectedTab = 0;
	selectedInit();
	return;
}

function selectedInit()
{
	selectFriend = "";
	bPostFriendSelect = false;
	return;
}

function Initialize()
{
	Me = GetWindowHandle("BR_NewCashShopReceiverListWnd");
	Description = GetTextBoxHandle("BR_NewCashShopReceiverListWnd.Description");
	DescriptionGroupBox = GetTextureHandle("BR_NewCashShopReceiverListWnd.DescriptionGroupBox");
	ListCount = GetTextBoxHandle("BR_NewCashShopReceiverListWnd.ListCount");
	TabCtrl = GetTabHandle("BR_NewCashShopReceiverListWnd.TabCtrl");
	ListGroupBox = GetTextureHandle("BR_NewCashShopReceiverListWnd.ListGroupBox");
	TabLineTop = GetTextureHandle("BR_NewCashShopReceiverListWnd.TabLineTop");
	tabBg = GetTextureHandle("BR_NewCashShopReceiverListWnd.tabBg");
	BR_NewCashShopReceiverListWnd_Friends = GetWindowHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Friends");
	FriendsList = GetListCtrlHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Friends.FriendsList");
	FriendsListDeco = GetTextureHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Friends.FriendsListDeco");
	BR_NewCashShopReceiverListWnd_Clan = GetWindowHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Clan");
	ClanList = GetListCtrlHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Clan.ClanList");
	ClanListDeco = GetTextureHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Clan.ClanListDeco");
	BR_NewCashShopReceiverListWnd_Add = GetWindowHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Add");
	AddList = GetListCtrlHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Add.AddList");
	Btn_Add = GetButtonHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Add.Btn_Add");
	Btn_Del = GetButtonHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Add.Btn_Del");
	AddListGroupBoxLine = GetTextureHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Add.AddListGroupBoxLine");
	AddListDeco = GetTextureHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Add.AddListDeco");
	CloseButton = GetButtonHandle("BR_NewCashShopReceiverListWnd.CloseButton");
	BR_CashShopReceiverListAddWnd = GetWindowHandle("BR_CashShopReceiverListAddWnd");
	return;
}

function Load()
{
	return;
}

function OnShow()
{
	SetCount(m_selectedTab);
	Btn_Del.DisableWindow();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Btn_Add":
			OnBtn_AddClick();
			break;
		case "Btn_Del":
			OnBtn_DelClick();
			break;
		case "CloseButton":
			OnCloseButtonClick();
			break;
		case "TabCtrl0":
			setFriendCount();
			break;
		case "TabCtrl1":
			setPledgeCount();
			break;
		case "TabCtrl2":
			setPostFrienddCount();
			break;
		default:
			break;
	}
	return;
}

function setFriendCount()
{
	m_selectedTab = 0;
	SetCount(m_selectedTab);
	return;
}

function setPledgeCount()
{
	m_selectedTab = 1;
	SetCount(m_selectedTab);
	return;
}

function setPostFrienddCount()
{
	m_selectedTab = 2;
	SetCount(m_selectedTab);
	return;
}

function SetCount(int Count)
{
	switch(Count)
	{
		case 0:
			ListCount.SetText(countFriend);
			break;
		case 1:
			ListCount.SetText(countPledge);
			break;
		case 2:
			ListCount.SetText(countPostFriend);
			break;
		default:
			break;
	}
	return;
}

function OnBtn_AddClick()
{
	DisableTab();
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("BR_CashShopReceiverListAddWnd.Name", "");
	BR_CashShopReceiverListAddWnd.ShowWindow();
	BR_CashShopReceiverListAddWnd.SetFocus();
	return;
}

function DisableTab()
{
	local ButtonHandle sendBtn;

	sendBtn = GetButtonHandle("PostWriteWnd.SendBtn");
	sendBtn.DisableWindow();
	AddList.DisableWindow();
	TabCtrl.DisableWindow();
	Btn_Add.DisableWindow();
	Btn_Del.DisableWindow();
	CloseButton.DisableWindow();
	return;
}

function EnableTab()
{
	local ButtonHandle sendBtn;

	sendBtn = GetButtonHandle("PostWriteWnd.SendBtn");
	sendBtn.EnableWindow();
	TabCtrl.EnableWindow();
	AddList.EnableWindow();
	Btn_Add.EnableWindow();
	if(bPostFriendSelect)
	{
		Btn_Del.EnableWindow();
	}
	CloseButton.EnableWindow();
	return;
}

function OnBtn_DelClick()
{
	if((selectFriend != ""))
	{
		DisableTab();
		DialogSetID(1);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3218), selectFriend, ""));
	}
	return;
}

function HandleDialogOK()
{
	if(DialogIsMine())
	{
		switch(DialogGetID())
		{
			case 1:
				EnableTab();
				Btn_Del.DisableWindow();
				DeletePostFriend();
				break;
			default:
				EnableTab();
				break;
		}
	}
	else
	{
		EnableTab();
	}
	return;
}

function HandleDialogCancel()
{
	if(DialogIsMine())
	{
		switch(DialogGetID())
		{
			case 1:
				EnableTab();
				AddSystemMessage(3220);
				break;
			default:
				EnableTab();
				break;
		}
	}
	else
	{
		EnableTab();
	}
	return;
}

function DeletePostFriend()
{
	local int i;

	NumPostFriend = (NumPostFriend - 1);
	countPostFriend = (((("(" $ string(NumPostFriend)) $ "/") $ string(100)) $ ") ");
	SetCount(2);
	i = AddList.GetSelectedIndex();
	AddList.DeleteRecord(i);
	Class'NWindow.PostWndAPI'.static.RequestDeletingPostFriend(selectFriend);
	Class'NWindow.PostWndAPI'.static.RequestPostFriendList();
	selectedInit();
	return;
}

function OnCloseButtonClick()
{
	local BR_NewPresentBuyingWnd Script;

	Script = BR_NewPresentBuyingWnd(GetScript("BR_NewPresentBuyingWnd"));
	Script.SetBoolCashShopReceiverList(false);
	HandleRestart();
	Me.HideWindow();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 4970:
			FriendsList.DeleteAllItem();
			HandleReceiveFriendList(param);
			break;
		case 5000:
			ClanList.DeleteAllItem();
			HandleReceivePledgeMemberList(param);
			break;
		case 4990:
			AddList.DeleteAllItem();
			HandleReceivePostFriendList(param);
			break;
		case 4980:
			HandleConfirmAddingPostFriend(param);
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			HandleDialogCancel();
			break;
		case 5040:
			HandleListCtrlLose(param);
			break;
		case 40:
			HandleRestart();
			break;
		default:
			break;
	}
	return;
}

function HandleRestart()
{
	selectFriend = "";
	bPostFriendSelect = false;
	return;
}

function HandleReceiveFriendList(string param)
{
	local int Num, i;
	local string strName;
	local int FriendClass, FriendLevel;
	local LVDataRecord Record;
	local EditBoxHandle e_handle;
	local array<string> AddName;

	e_handle = GetEditBoxHandle("BR_NewPresentBuyingWnd.ReceiverID");
	ParseInt(param, "Num", Num);
	countFriend = (((("(" $ string(Num)) $ "/") $ string(128)) $ ") ");
	i = 0;
	while((i < Num))
	{
		ParseString(param, ("Name" $ string(i)), strName);
		ParseInt(param, ("FriendClass" $ string(i)), FriendClass);
		ParseInt(param, ("FriendLevel" $ string(i)), FriendLevel);
		AddName[i] = strName;
		Record.LVDataList.Length = 3;
		Record.LVDataList[0].szData = strName;
		Record.LVDataList[1].szTexture = GetClassRoleIconName(FriendClass);
		Record.LVDataList[1].nTextureWidth = 11;
		Record.LVDataList[1].nTextureHeight = 11;
		Record.LVDataList[1].szData = string(FriendClass);
		Record.LVDataList[2].szData = string(FriendLevel);
		Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("BR_NewCashShopReceiverListWnd.FriendsList", Record);
		i++;
	}
	e_handle.FillAdditionalSearchList(AddName, SLT_FRIEND_LIST);
	SetCount(m_selectedTab);
	return;
}

function HandleReceivePledgeMemberList(string param)
{
	local int Num, i;
	local string strName;
	local int ClanClass, ClanLevel;
	local LVDataRecord Record;
	local EditBoxHandle e_handle;
	local array<string> AddName;

	e_handle = GetEditBoxHandle("BR_NewPresentBuyingWnd.ReceiverID");
	ParseInt(param, "Num", Num);
	countPledge = (((("(" $ string(Num)) $ "/") $ string(220)) $ ") ");
	i = 0;
	while((i < Num))
	{
		ParseString(param, ("Name" $ string(i)), strName);
		ParseInt(param, ("FriendClass" $ string(i)), ClanClass);
		ParseInt(param, ("FriendLevel" $ string(i)), ClanLevel);
		AddName[i] = strName;
		Record.LVDataList.Length = 3;
		Record.LVDataList[0].szData = strName;
		Record.LVDataList[1].szTexture = GetClassRoleIconName(ClanClass);
		Record.LVDataList[1].nTextureWidth = 11;
		Record.LVDataList[1].nTextureHeight = 11;
		Record.LVDataList[1].szData = string(ClanClass);
		Record.LVDataList[2].szData = string(ClanLevel);
		Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("BR_NewCashShopReceiverListWnd.ClanList", Record);
		i++;
	}
	e_handle.FillAdditionalSearchList(AddName, SLT_PLEDGEMEMBER_LIST);
	SetCount(m_selectedTab);
	return;
}

function HandleReceivePostFriendList(string param)
{
	local int Num, i;
	local string strName;
	local LVDataRecord Record;
	local EditBoxHandle e_handle;
	local array<string> AddName;

	e_handle = GetEditBoxHandle("BR_NewPresentBuyingWnd.ReceiverID");
	ParseInt(param, "Num", Num);
	NumPostFriend = Num;
	countPostFriend = (((("(" $ string(NumPostFriend)) $ "/") $ string(100)) $ ") ");
	i = 0;
	while((i < Num))
	{
		ParseString(param, ("Name" $ string(i)), strName);
		AddName[i] = strName;
		Record.LVDataList.Length = 1;
		Record.LVDataList[0].szData = strName;
		Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("BR_NewCashShopReceiverListWnd.AddList", Record);
		i++;
	}
	e_handle.FillAdditionalSearchList(AddName, SLT_ADDITIONALFRIEND_LIST);
	SetCount(m_selectedTab);
	return;
}

function HandleConfirmAddingPostFriend(string param)
{
	PostReceiverListWnd(GetScript("PostReceiverListWnd"))._HandleConfirmAddingPostFriend(param);
	EnableTab();
	return;
}

function HandleListCtrlLose(string param)
{
	local string ListCtrlName;

	ParseString(param, "ListCtrlName", ListCtrlName);
	if((ListCtrlName == AddList.GetWindowName()))
	{
		bPostFriendSelect = false;
		Btn_Del.DisableWindow();
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;

	switch(ListCtrlID)
	{
		case "FriendsList":
			FriendsList.GetSelectedRec(Record);
			Class'NWindow.UIAPI_EDITBOX'.static.SetString("BR_NewPresentBuyingWnd.ReceiverID", Record.LVDataList[0].szData);
			break;
		case "ClanList":
			ClanList.GetSelectedRec(Record);
			Class'NWindow.UIAPI_EDITBOX'.static.SetString("BR_NewPresentBuyingWnd.ReceiverID", Record.LVDataList[0].szData);
			break;
		case "AddList":
			AddList.GetSelectedRec(Record);
			Class'NWindow.UIAPI_EDITBOX'.static.SetString("BR_NewPresentBuyingWnd.ReceiverID", Record.LVDataList[0].szData);
			break;
		default:
			break;
	}
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;

	switch(ListCtrlID)
	{
		case "AddList":
			bPostFriendSelect = true;
			Btn_Del.EnableWindow();
			AddList.GetSelectedRec(Record);
			selectFriend = Record.LVDataList[0].szData;
			break;
		default:
			break;
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="BR_NewCashShopReceiverListWnd"
}
