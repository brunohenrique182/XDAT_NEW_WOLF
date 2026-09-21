class PostReceiverListWnd extends UICommonAPI;

const DIALOGID_DelFriend = 1;
const MAX_FRIEND = 128;
const MAX_PLEDGE = 220;
const MAX_POSTFRIEND = 100;
const POSTFRIEND_TAB = 0;
const FRIEND_TAB = 1;
const PLEDGE_TAB = 2;

var string m_Windowname;
var WindowHandle Me;
var TextBoxHandle Description;
var TextureHandle DescriptionGroupBox;
var TextBoxHandle ListCount;
var TabHandle TabCtrl;
var TextureHandle ListGroupBox;
var TextureHandle TabLineTop;
var TextureHandle tabBg;
var WindowHandle PostReceiverListWnd_Friends;
var ListCtrlHandle FriendsList;
var TextureHandle FriendsListDeco;
var WindowHandle PostReceiverListWnd_Clan;
var ListCtrlHandle ClanList;
var TextureHandle ClanListDeco;
var WindowHandle PostReceiverListWnd_Add;
var ListCtrlHandle AddList;
var ButtonHandle Btn_Add;
var ButtonHandle Btn_Del;
var TextureHandle AddListGroupBoxLine;
var TextureHandle AddListDeco;
var ButtonHandle CloseButton;
var WindowHandle PostReceiverListAddWnd;
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
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(5040);
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
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
	Me = GetWindowHandle("PostReceiverListWnd");
	Description = GetTextBoxHandle("PostReceiverListWnd.Description");
	DescriptionGroupBox = GetTextureHandle("PostReceiverListWnd.DescriptionGroupBox");
	ListCount = GetTextBoxHandle("PostReceiverListWnd.ListCount");
	TabCtrl = GetTabHandle("PostReceiverListWnd.TabCtrl");
	ListGroupBox = GetTextureHandle("PostReceiverListWnd.ListGroupBox");
	TabLineTop = GetTextureHandle("PostReceiverListWnd.TabLineTop");
	tabBg = GetTextureHandle("PostReceiverListWnd.tabBg");
	PostReceiverListWnd_Friends = GetWindowHandle("PostReceiverListWnd.PostReceiverListWnd_Friends");
	FriendsList = GetListCtrlHandle("PostReceiverListWnd.PostReceiverListWnd_Friends.FriendsList");
	FriendsListDeco = GetTextureHandle("PostReceiverListWnd.PostReceiverListWnd_Friends.FriendsListDeco");
	PostReceiverListWnd_Clan = GetWindowHandle("PostReceiverListWnd.PostReceiverListWnd_Clan");
	ClanList = GetListCtrlHandle("PostReceiverListWnd.PostReceiverListWnd_Clan.ClanList");
	ClanListDeco = GetTextureHandle("PostReceiverListWnd.PostReceiverListWnd_Clan.ClanListDeco");
	PostReceiverListWnd_Add = GetWindowHandle("PostReceiverListWnd.PostReceiverListWnd_Add");
	AddList = GetListCtrlHandle("PostReceiverListWnd.PostReceiverListWnd_Add.AddList");
	Btn_Add = GetButtonHandle("PostReceiverListWnd.PostReceiverListWnd_Add.Btn_Add");
	Btn_Del = GetButtonHandle("PostReceiverListWnd.PostReceiverListWnd_Add.Btn_Del");
	AddListGroupBoxLine = GetTextureHandle("PostReceiverListWnd.PostReceiverListWnd_Add.AddListGroupBoxLine");
	AddListDeco = GetTextureHandle("PostReceiverListWnd.PostReceiverListWnd_Add.AddListDeco");
	CloseButton = GetButtonHandle("PostReceiverListWnd.CloseButton");
	PostReceiverListAddWnd = GetWindowHandle("PostReceiverListAddWnd");
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
			setPostFrienddCount();
			break;
		case "TabCtrl1":
			setFriendCount();
			break;
		case "TabCtrl2":
			setPledgeCount();
			break;
		default:
			break;
	}
	return;
}

function setFriendCount()
{
	m_selectedTab = 1;
	SetCount(m_selectedTab);
	return;
}

function setPledgeCount()
{
	m_selectedTab = 2;
	SetCount(m_selectedTab);
	return;
}

function setPostFrienddCount()
{
	m_selectedTab = 0;
	SetCount(m_selectedTab);
	return;
}

function SetCount(int Count)
{
	switch(Count)
	{
		case 0:
			ListCount.SetText(countPostFriend);
			break;
		case 1:
			ListCount.SetText(countFriend);
			break;
		case 2:
			ListCount.SetText(countPledge);
			break;
		default:
			break;
	}
	return;
}

function OnBtn_AddClick()
{
	DisableTab();
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("PostReceiverListAddWnd.Name", "");
	PostReceiverListAddWnd.ShowWindow();
	PostReceiverListAddWnd.SetFocus();
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
		Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(0, 0);
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
	SetCount(0);
	i = AddList.GetSelectedIndex();
	AddList.DeleteRecord(i);
	Class'NWindow.PostWndAPI'.static.RequestDeletingPostFriend(selectFriend);
	Class'NWindow.PostWndAPI'.static.RequestPostFriendList();
	selectedInit();
	return;
}

function OnCloseButtonClick()
{
	local PostWriteWnd Script;

	Script = PostWriteWnd(GetScript("PostWriteWnd"));
	Script.SetBoolPostReceiverList(false);
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

	e_handle = GetEditBoxHandle("PostWriteWnd.ReceiverID");
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
		Record.LVDataList[1].HiddenStringForSorting = string(GetClassRoleType(FriendClass));
		Record.LVDataList[2].szData = string(FriendLevel);
		Debug(("Record.LVDataList[1].szTexture" @ Record.LVDataList[1].szTexture));
		Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("PostReceiverListWnd.FriendsList", Record);
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

	e_handle = GetEditBoxHandle("PostWriteWnd.ReceiverID");
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
		Record.LVDataList[1].HiddenStringForSorting = string(GetClassRoleType(ClanClass));
		Record.LVDataList[2].szData = string(ClanLevel);
		Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("PostReceiverListWnd.ClanList", Record);
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

	e_handle = GetEditBoxHandle("PostWriteWnd.ReceiverID");
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
		Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("PostReceiverListWnd.AddList", Record);
		i++;
	}
	e_handle.FillAdditionalSearchList(AddName, SLT_ADDITIONALFRIEND_LIST);
	SetCount(m_selectedTab);
	return;
}

function _HandleConfirmAddingPostFriend(string param)
{
	local string strName;
	local int Result;

	ParseString(param, "Name", strName);
	ParseInt(param, "Result", Result);
	if((Result == 1))
	{
		Class'NWindow.PostWndAPI'.static.RequestPostFriendList();
	}
	else if((Result == -1))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3223));
	}
	else if(((Result == -2) || (Result == 0)))
	{
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(3215), strName, ""));
	}
	else if((Result == -3))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3222));
	}
	else if((Result == -4))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3216));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3217));
	}
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
			break;
		case "ClanList":
			ClanList.GetSelectedRec(Record);
			break;
		case "AddList":
			AddList.GetSelectedRec(Record);
			break;
		default:
			break;
	}
	PostWriteWnd(GetScript("PostWriteWnd")).ToWrite(Record.LVDataList[0].szData);
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
	m_Windowname="PostReceiverListWnd"
}
