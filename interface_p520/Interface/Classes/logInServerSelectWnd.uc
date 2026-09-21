class logInServerSelectWnd extends UICommonAPI;

const HARDCODING_VALAKAS_SEVER1 = 83;
const MAX_SERVER_LIST = 120;
const MaxNewSeverCount = 5;
const Size_BIG = 3;
const Size_MIDDLE = 2;
const Size_NORMAL = 1;
const DIALOG_PolicyCheck = 12500;

struct ServerData
{
	var int Priority;
	var int buttonIndex;
	var int newServerButtonIndex;
	var int lastLogin;
	var int Id;
	var string Name;
	var string State;
	var Color stateColor;
	var int charCnt;
	var int AgeLimit;
	var int IsRelaxServer;
	var int IsTestServer;
	var int IsBroadServer;
	var int IsCreateRestrictServer;
	var int IsEventServer;
	var int IsFreeServer;
	var int IsNewServer;
	var int IsForbiddenServer;
	var int IsWorldRaidServer;
	var int IsClassicServer;
	var int IsArenaServer;
	var int IsBloodyServer;
	var int IsAdenServer;
	var int IsPVPServer;
	var int IsEvaServer;
	var int IsWolfServer;
	var string AgeLimitTexName;
};

var WindowHandle Me;
var WindowHandle List_ScrollArea;
var WindowHandle ServerListWnd;
var TabHandle Server_1Tab;
var TabHandle Server_2Tab;
var TabHandle Server_3Tab;
var array<ServerData> serverData_Array;
var int currentSelectedServerDataArrayIndex;
var int nAdenServerCount;
var int nTalkingIslandServerCount;
var int nLiveServerCount;
var int currentNewServerCount;
var int currentEvaServerCount;
var int currentWolfServerCount;
var string tabButtonText1;
var string tabButtonText2;
var string tabButtonText3;
var TextureHandle LobbyCopyright;
var string JpPolicyString;
var int nIsShowNewServerList;
//var delegate<OnSortServerListTypeEva> __OnSortServerListTypeEva__Delegate;
//var delegate<OnSortServerListTypeWolf> __OnSortServerListTypeWolf__Delegate;
//var delegate<OnSortServerList> __OnSortServerList__Delegate;

function OnRegisterEvent()
{
	RegisterEvent(5690);
	RegisterEvent(5691);
	RegisterEvent(5692);
	RegisterEvent(1710);
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local string mainKey;

	mainKey = Class'NWindow.InputAPI'.static.GetKeyString(nKey);
	Debug(("MainKey" @ mainKey));
	if((int(nKey) == 13))
	{
		if((currentSelectedServerDataArrayIndex > -1))
		{
			connectServer(currentSelectedServerDataArrayIndex);
		}
	}
	else if((int(nKey) == 27))
	{
		if(ServerListWnd.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			OnClose_BtnClick();
			GetWindowHandle("loginServerInfoWnd").ShowWindow();
		}
		else
		{
			OnserverSelect_BTNClick();
		}
	}
	return false;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("logInServerSelectWnd");
	ServerListWnd = GetWindowHandle("logInServerSelectWnd.NormalWnd");
	List_ScrollArea = GetWindowHandle("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea");
	Server_1Tab = GetTabHandle("logInServerSelectWnd.NormalWnd.ServerListWnd.Server_1Tab");
	Server_2Tab = GetTabHandle("logInServerSelectWnd.NormalWnd.ServerListWnd.Server_2Tab");
	Server_3Tab = GetTabHandle("logInServerSelectWnd.NormalWnd.ServerListWnd.Server_3Tab");
	LobbyCopyright = GetTextureHandle("logInServerSelectWnd.LobbyCopyright_tex");
	LobbyCopyright.HideWindow();
	JpPolicyString = "";
	return;
}

function OnLButtonDown(WindowHandle btnHandle, int X, int Y)
{
	local int buttonIndex, numCount, arrayIndex;

	if((Left(btnHandle.GetParentWindowName(), Len("ServerSelectAsset")) == "ServerSelectAsset"))
	{
		numCount = (Len(btnHandle.GetParentWindowName()) - Len("ServerSelectAsset"));
		buttonIndex = int(Right(btnHandle.GetParentWindowName(), numCount));
		arrayIndex = getServerDataIndexByButtonIndex(buttonIndex);
		if((arrayIndex > -1))
		{
			Debug((serverData_Array[arrayIndex].Name @ string(serverData_Array[arrayIndex].Id)));
			currentSelectedServerDataArrayIndex = arrayIndex;
			setConnectServerInfo();
			OnClose_BtnClick();
		}
	}
	else if((Left(btnHandle.GetParentWindowName(), Len("NewBTN0")) == "NewBTN0"))
	{
		buttonIndex = int(Right(btnHandle.GetParentWindowName(), 1));
		arrayIndex = getServerDataIndexByNewServerButtonIndex(buttonIndex);
		if((arrayIndex > -1))
		{
			currentSelectedServerDataArrayIndex = arrayIndex;
			setConnectServerInfo();
			OnClose_BtnClick();
		}
	}
	return;
}

function setConnectServerInfo()
{
	GetWindowHandle("loginServerInfoWnd").ShowWindow();
	GetTextBoxHandle("logInServerSelectWnd.loginServerInfoWnd.LastServerNAME_txt").SetAlpha(50);
	GetTextBoxHandle("logInServerSelectWnd.loginServerInfoWnd.LastServerNAME_txt").SetText(serverData_Array[currentSelectedServerDataArrayIndex].Name);
	GetTextBoxHandle("logInServerSelectWnd.loginServerInfoWnd.LastServerType_txt").SetText(getCurrentSelectedServerTypeString());
	GetTextBoxHandle("logInServerSelectWnd.loginServerInfoWnd.LastServerCondition_txt").SetText(serverData_Array[currentSelectedServerDataArrayIndex].State);
	if((serverData_Array[currentSelectedServerDataArrayIndex].State == GetSystemString(456)))
	{
		GetTextBoxHandle("logInServerSelectWnd.loginServerInfoWnd.LastServerCondition_txt").SetTextColor(GetColor(85, 85, 85, 255));
	}
	else
	{
		GetTextBoxHandle("logInServerSelectWnd.loginServerInfoWnd.LastServerCondition_txt").SetTextColor(serverData_Array[currentSelectedServerDataArrayIndex].stateColor);
	}
	GetTextBoxHandle("logInServerSelectWnd.loginServerInfoWnd.LastServerNAME_txt").SetAlpha(255, 0.4000000);
	return;
}

function string getCurrentSelectedServerTypeString()
{
	local string rStr;

	if((serverData_Array[currentSelectedServerDataArrayIndex].IsClassicServer == 1))
	{
		rStr = GetSystemString(13036);
	}
	else
	{
		rStr = GetSystemString(13037);
	}
	return rStr;
}

function OnClickButton(string Name)
{
	Debug(("Name" @ Name));
	switch(Name)
	{
		case "serverSelect_BTN":
			OnserverSelect_BTNClick();
			break;
		case "Close_btn":
			OnClose_BtnClick();
			GetWindowHandle("loginServerInfoWnd").ShowWindow();
			break;
		case "ServerSelectOK_btn":
			if((false && (int(GetLanguage()) == 2)))
			{
				JpPolicyString = JapanPolicyCheck();
				if((Len(JpPolicyString) > 0))
				{
					DialogSetID(12500);
					DialogShow(DialogModalType_Modal, DialogType_OK, GetSystemMessage(6890));
				}
				else
				{
					connectServer(currentSelectedServerDataArrayIndex);
				}
			}
			else
			{
				connectServer(currentSelectedServerDataArrayIndex);
			}
			break;
		case "ServerSelectCancel_btn":
			GotoLogin();
			break;
		case "Server_1Tab0":
			initServerList();
			selectshowServerList(tabButtonText1);
			break;
		case "Server_2Tab0":
			initServerList();
			selectshowServerList(tabButtonText1);
			break;
		case "Server_2Tab1":
			initServerList();
			selectshowServerList(tabButtonText2);
			break;
		case "Server_3Tab0":
			initServerList();
			selectshowServerList(tabButtonText1);
			break;
		case "Server_3Tab1":
			initServerList();
			selectshowServerList(tabButtonText2);
			break;
		case "Server_3Tab2":
			initServerList();
			selectshowServerList(tabButtonText3);
			break;
		default:
			break;
	}
	return;
}

function selectshowServerList(string tabButtonText)
{
	if((tabButtonText == GetSystemString(888)))
	{
		showServerList(1, 1, false);
	}
	else if((tabButtonText == GetSystemString(3924)))
	{
		showServerList(1, 0, false);
	}
	else if((tabButtonText == GetSystemString(3923)))
	{
		showServerList(0, 0, false);
	}
	else if((tabButtonText == GetSystemString(2731)))
	{
		showServerList(0, 0, false, true);
	}
	else if((tabButtonText == GetSystemString(13036)))
	{
		showServerList(1, 0, true, false);
	}
	else if((tabButtonText == GetSystemString(13037)))
	{
		showServerList(0, 0, false, false);
	}
	return;
}

function SetCurrentSelectedServerTab()
{
	if(Server_1Tab.IsShowWindow())
	{
		Server_1Tab.SetTopOrder(0, false);
		OnClickButton("Server_1Tab0");
	}
	else if(Server_2Tab.IsShowWindow())
	{
		if(isKr())
		{
			if((serverData_Array[currentSelectedServerDataArrayIndex].IsClassicServer == 1))
			{
				Server_2Tab.SetTopOrder(0, false);
				OnClickButton("Server_2Tab0");
			}
			else
			{
				Server_2Tab.SetTopOrder(1, false);
				OnClickButton("Server_2Tab1");
			}
		}
		else if((((nAdenServerCount == 0) && (nTalkingIslandServerCount > 0)) && (nLiveServerCount > 0)))
		{
			if((serverData_Array[currentSelectedServerDataArrayIndex].IsClassicServer == 0))
			{
				Server_2Tab.SetTopOrder(0, false);
				OnClickButton("Server_2Tab0");
			}
			else
			{
				Server_2Tab.SetTopOrder(1, false);
				OnClickButton("Server_2Tab1");
			}
		}
		else if((((nAdenServerCount > 0) && (nTalkingIslandServerCount == 0)) && (nLiveServerCount > 0)))
		{
			if((serverData_Array[currentSelectedServerDataArrayIndex].IsAdenServer == 1))
			{
				Server_2Tab.SetTopOrder(0, false);
				OnClickButton("Server_2Tab0");
			}
			else
			{
				Server_2Tab.SetTopOrder(1, false);
				OnClickButton("Server_2Tab1");
			}
		}
		else if((((nAdenServerCount > 0) && (nTalkingIslandServerCount > 0)) && (nLiveServerCount == 0)))
		{
			if((serverData_Array[currentSelectedServerDataArrayIndex].IsAdenServer == 1))
			{
				Server_2Tab.SetTopOrder(0, false);
				OnClickButton("Server_2Tab0");
			}
			else
			{
				Server_2Tab.SetTopOrder(1, false);
				OnClickButton("Server_2Tab1");
			}
		}
	}
	else if(Server_3Tab.IsShowWindow())
	{
		if((serverData_Array[currentSelectedServerDataArrayIndex].IsAdenServer == 1))
		{
			Server_3Tab.SetTopOrder(0, false);
			OnClickButton("Server_3Tab0");
		}
		else if((serverData_Array[currentSelectedServerDataArrayIndex].IsClassicServer == 0))
		{
			Server_3Tab.SetTopOrder(1, false);
			OnClickButton("Server_3Tab1");
		}
		else if(((serverData_Array[currentSelectedServerDataArrayIndex].IsClassicServer == 1) && (serverData_Array[currentSelectedServerDataArrayIndex].IsAdenServer == 0)))
		{
			Server_3Tab.SetTopOrder(2, false);
			OnClickButton("Server_3Tab2");
		}
	}
	return;
}

function ShowNormalServerList()
{
	ServerListWnd.ShowWindow();
	GetWindowHandle("logInServerSelectWnd.NormalWnd.ServerListWnd").ClearAnchor();
	GetWindowHandle("logInServerSelectWnd.NormalWnd.ServerListWnd").MoveC(0, 40);
	GetWindowHandle("logInServerSelectWnd.NormalWnd.ServerListWnd").Move(0, -40, 0.3000000);
	GetWindowHandle("logInServerSelectWnd.NormalWnd.ServerListWnd").SetAlpha(100);
	GetWindowHandle("logInServerSelectWnd.NormalWnd.ServerListWnd").SetAlpha(255, 0.3000000);
	return;
}

function OnserverSelect_BTNClick()
{
	Debug("----------------> OnserverSelect_BTNClick");
	if(ServerListWnd.IsShowWindow())
	{
		OnClose_BtnClick();
		GetWindowHandle("loginServerInfoWnd").ShowWindow();
	}
	else
	{
		GetButtonHandle("logInServerSelectWnd.ServerSelectOK_btn").HideWindow();
		GetButtonHandle("logInServerSelectWnd.ServerSelectCancel_btn").HideWindow();
		ShowNormalServerList();
		SetCurrentSelectedServerTab();
		ServerListWnd.SetFocus();
		GetWindowHandle("loginServerInfoWnd").HideWindow();
	}
	return;
}

function OnClose_BtnClick()
{
	ServerListWnd.HideWindow();
	GetButtonHandle("logInServerSelectWnd.ServerSelectOK_btn").ShowWindow();
	GetButtonHandle("logInServerSelectWnd.ServerSelectCancel_btn").ShowWindow();
	return;
}

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case 5690:
			ServerListStart(a_Param);
			break;
		case 5691:
			handleServerList(a_Param);
			break;
		case 5692:
			ServerListEnd(a_Param);
			break;
		case 1710:
			if((DialogIsMine() && (DialogGetID() == 12500)))
			{
				OpenWebSite(JpPolicyString);
				ExecQuit();
			}
			break;
		default:
			break;
	}
	return;
}

function ServerListStart(string a_Param)
{
	ParseInt(a_Param, "IsShowNewServerList", nIsShowNewServerList);
	Debug(("ServerListStart : nIsShowNewServerList" @ string(nIsShowNewServerList)));
	OnClose_BtnClick();
	currentSelectedServerDataArrayIndex = -1;
	currentNewServerCount = 0;
	currentEvaServerCount = 0;
	currentWolfServerCount = 0;
	nAdenServerCount = 0;
	nTalkingIslandServerCount = 0;
	nLiveServerCount = 0;
	serverData_Array.Remove(0, serverData_Array.Length);
	return;
}

function handleServerList(string a_Param)
{
	local int IsWorldRaidServer, R, G, B, ExtID;
	local string Name;

	Debug(("handleServerList : " @ a_Param));
	ParseInt(a_Param, "IsWorldRaidServer", IsWorldRaidServer);
	if((IsWorldRaidServer == 1))
	{
		return;
	}
	serverData_Array.Insert(serverData_Array.Length, 1);
	ParseInt(a_Param, "ID", serverData_Array[(serverData_Array.Length - 1)].Id);
	ParseInt(a_Param, "ExtID", ExtID);
	if((ExtID != 0))
	{
		ParseString(a_Param, "Name", Name);
		serverData_Array[(serverData_Array.Length - 1)].Name = ((("[" $ getInstanceUIData().Int2Str(ExtID)) $ "]") @ Name);
	}
	else
	{
		ParseString(a_Param, "Name", serverData_Array[(serverData_Array.Length - 1)].Name);
	}
	ParseString(a_Param, "State", serverData_Array[(serverData_Array.Length - 1)].State);
	ParseInt(a_Param, "StateColorR", R);
	ParseInt(a_Param, "StateColorG", G);
	ParseInt(a_Param, "StateColorB", B);
	serverData_Array[(serverData_Array.Length - 1)].stateColor.R = byte(R);
	serverData_Array[(serverData_Array.Length - 1)].stateColor.G = byte(G);
	serverData_Array[(serverData_Array.Length - 1)].stateColor.B = byte(B);
	serverData_Array[(serverData_Array.Length - 1)].stateColor.A = 255;
	ParseInt(a_Param, "CharCnt", serverData_Array[(serverData_Array.Length - 1)].charCnt);
	ParseInt(a_Param, "AgeLimit", serverData_Array[(serverData_Array.Length - 1)].AgeLimit);
	ParseInt(a_Param, "IsRelaxServer", serverData_Array[(serverData_Array.Length - 1)].IsRelaxServer);
	ParseInt(a_Param, "IsTestServer", serverData_Array[(serverData_Array.Length - 1)].IsTestServer);
	ParseInt(a_Param, "IsBroadServer", serverData_Array[(serverData_Array.Length - 1)].IsBloodyServer);
	ParseInt(a_Param, "IsCreateRestrictServer", serverData_Array[(serverData_Array.Length - 1)].IsCreateRestrictServer);
	ParseInt(a_Param, "IsEventServer", serverData_Array[(serverData_Array.Length - 1)].IsEventServer);
	ParseInt(a_Param, "IsFreeServer", serverData_Array[(serverData_Array.Length - 1)].IsFreeServer);
	ParseInt(a_Param, "IsNewServer", serverData_Array[(serverData_Array.Length - 1)].IsNewServer);
	ParseInt(a_Param, "IsForbiddenServer", serverData_Array[(serverData_Array.Length - 1)].IsForbiddenServer);
	ParseInt(a_Param, "IsWorldRaidServer", serverData_Array[(serverData_Array.Length - 1)].IsWorldRaidServer);
	ParseInt(a_Param, "IsClassicServer", serverData_Array[(serverData_Array.Length - 1)].IsClassicServer);
	ParseInt(a_Param, "IsArenaServer", serverData_Array[(serverData_Array.Length - 1)].IsArenaServer);
	ParseInt(a_Param, "IsBloodyServer", serverData_Array[(serverData_Array.Length - 1)].IsBloodyServer);
	ParseInt(a_Param, "IsAdenServer", serverData_Array[(serverData_Array.Length - 1)].IsAdenServer);
	ParseInt(a_Param, "IsPVPServer", serverData_Array[(serverData_Array.Length - 1)].IsPVPServer);
	ParseInt(a_Param, "IsEvaServer", serverData_Array[(serverData_Array.Length - 1)].IsEvaServer);
	ParseInt(a_Param, "IsWolfServer", serverData_Array[(serverData_Array.Length - 1)].IsWolfServer);
	ParseInt(a_Param, "Priority", serverData_Array[(serverData_Array.Length - 1)].Priority);
	ParseString(a_Param, "AgeLimitTexName", serverData_Array[(serverData_Array.Length - 1)].AgeLimitTexName);
	if((serverData_Array[(serverData_Array.Length - 1)].IsAdenServer == 1))
	{
		nAdenServerCount++;
	}
	if(((serverData_Array[(serverData_Array.Length - 1)].IsClassicServer == 1) && (serverData_Array[(serverData_Array.Length - 1)].IsAdenServer == 0)))
	{
		nTalkingIslandServerCount++;
	}
	if((serverData_Array[(serverData_Array.Length - 1)].IsClassicServer == 0))
	{
		nLiveServerCount++;
	}
	serverData_Array[(serverData_Array.Length - 1)].buttonIndex = -1;
	serverData_Array[(serverData_Array.Length - 1)].newServerButtonIndex = -1;
	if((serverData_Array[(serverData_Array.Length - 1)].IsEvaServer > 0))
	{
		currentEvaServerCount++;
	}
	if((serverData_Array[(serverData_Array.Length - 1)].IsWolfServer > 0))
	{
		currentWolfServerCount++;
	}
	Debug(("currentEvaServerCount" @ string(currentEvaServerCount)));
	Debug(("currentWolfServerCount" @ string(currentWolfServerCount)));
	if((serverData_Array[(serverData_Array.Length - 1)].IsNewServer == 1))
	{
		currentNewServerCount++;
	}
	if(((serverData_Array.Length - 1) == 0))
	{
		serverData_Array[(serverData_Array.Length - 1)].lastLogin = 1;
		currentSelectedServerDataArrayIndex = 0;
		setConnectServerInfo();
	}
	return;
}

function ServerListEnd(string a_Param)
{
	local int i, serverCount;

	Debug(("ServerListEnd " @ a_Param));
	setNewServerGroupWindowResize(currentNewServerCount);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop("logInServerSelectWnd", true);
	// serverData_Array.Sort(OnSortServerList);   // array.Sort() unsupported by this compiler
	// serverData_Array.Sort(OnSortServerListTypeEva);   // array.Sort() unsupported by this compiler
	// serverData_Array.Sort(OnSortServerListTypeWolf);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < serverData_Array.Length))
	{
		if((serverData_Array[i].lastLogin == 1))
		{
			currentSelectedServerDataArrayIndex = i;
			break;
		}
		i++;
	}
	serverCount = 0;
	i = 0;
	while((i < serverData_Array.Length))
	{
		if((serverData_Array[i].IsNewServer == 1))
		{
			serverCount++;
			setNewServerBtn(serverCount, i);
			serverData_Array[i].newServerButtonIndex = serverCount;
		}
		i++;
	}
	setTabShowState();
	Debug(("nIsShowNewServerList" @ string(nIsShowNewServerList)));
	if((nIsShowNewServerList == 1))
	{
		ShowNormalServerList();
		SetCurrentSelectedServerTab();
		GetWindowHandle("loginServerInfoWnd").HideWindow();
		GetButtonHandle("logInServerSelectWnd.ServerSelectOK_btn").HideWindow();
		GetButtonHandle("logInServerSelectWnd.ServerSelectCancel_btn").HideWindow();
	}
	else
	{
		GetWindowHandle("loginServerInfoWnd").ShowWindow();
	}
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function setTabShowState()
{
	Debug(("nAdenServerCount" @ string(nAdenServerCount)));
	Debug(("nTalkingIslandServerCount" @ string(nTalkingIslandServerCount)));
	Debug(("nLiveServerCount" @ string(nLiveServerCount)));
	if((isKr() && (int(GetReleaseMode()) == 2)))
	{
		Server_1Tab.ShowWindow();
		Server_2Tab.HideWindow();
		Server_3Tab.HideWindow();
		tabButtonText1 = GetSystemString(2731);
		Server_1Tab.SetButtonName(0, tabButtonText1);
	}
	else if(isKr())
	{
		Server_1Tab.HideWindow();
		Server_2Tab.ShowWindow();
		Server_3Tab.HideWindow();
		tabButtonText1 = GetSystemString(13036);
		tabButtonText2 = GetSystemString(13037);
		Server_2Tab.SetButtonName(0, tabButtonText1);
		Server_2Tab.SetButtonName(1, tabButtonText2);
	}
	else
	{
		Server_1Tab.HideWindow();
		Server_2Tab.HideWindow();
		Server_3Tab.HideWindow();
		if((((nAdenServerCount > 0) && (nTalkingIslandServerCount == 0)) && (nLiveServerCount == 0)))
		{
			Server_1Tab.ShowWindow();
			tabButtonText1 = GetSystemString(888);
			Server_1Tab.SetButtonName(0, tabButtonText1);
		}
		else if((((nAdenServerCount == 0) && (nTalkingIslandServerCount > 0)) && (nLiveServerCount == 0)))
		{
			Server_1Tab.ShowWindow();
			tabButtonText1 = GetSystemString(3924);
			Server_1Tab.SetButtonName(0, tabButtonText1);
		}
		else if((((nAdenServerCount == 0) && (nTalkingIslandServerCount == 0)) && (nLiveServerCount > 0)))
		{
			Server_1Tab.ShowWindow();
			tabButtonText1 = GetSystemString(3923);
			Server_1Tab.SetButtonName(0, tabButtonText1);
		}
		else if((((nAdenServerCount == 0) && (nTalkingIslandServerCount > 0)) && (nLiveServerCount > 0)))
		{
			Server_2Tab.ShowWindow();
			tabButtonText1 = GetSystemString(3923);
			tabButtonText2 = GetSystemString(3924);
			Server_2Tab.SetButtonName(0, tabButtonText1);
			Server_2Tab.SetButtonName(1, tabButtonText2);
		}
		else if((((nAdenServerCount > 0) && (nTalkingIslandServerCount == 0)) && (nLiveServerCount > 0)))
		{
			Server_2Tab.ShowWindow();
			tabButtonText1 = GetSystemString(888);
			tabButtonText2 = GetSystemString(3923);
			Server_2Tab.SetButtonName(0, tabButtonText1);
			Server_2Tab.SetButtonName(1, tabButtonText2);
		}
		else if((((nAdenServerCount > 0) && (nTalkingIslandServerCount > 0)) && (nLiveServerCount == 0)))
		{
			Server_2Tab.ShowWindow();
			tabButtonText1 = GetSystemString(888);
			tabButtonText2 = GetSystemString(3924);
			Server_2Tab.SetButtonName(0, tabButtonText1);
			Server_2Tab.SetButtonName(1, tabButtonText2);
		}
		else if((((nAdenServerCount > 0) && (nTalkingIslandServerCount > 0)) && (nLiveServerCount > 0)))
		{
			Server_3Tab.ShowWindow();
			tabButtonText1 = GetSystemString(888);
			tabButtonText2 = GetSystemString(3923);
			tabButtonText3 = GetSystemString(3924);
			Server_3Tab.SetButtonName(0, tabButtonText1);
			Server_3Tab.SetButtonName(1, tabButtonText2);
			Server_3Tab.SetButtonName(2, tabButtonText3);
		}
	}
	return;
}

delegate int OnSortServerListTypeEva(ServerData A, ServerData B)
{
	if((A.IsEvaServer < B.IsEvaServer))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

delegate int OnSortServerListTypeWolf(ServerData A, ServerData B)
{
	if((A.IsWolfServer < B.IsWolfServer))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

delegate int OnSortServerList(ServerData A, ServerData B)
{
	if((A.Priority > B.Priority))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function initServerList()
{
	local int i;

	GetWindowHandle("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea").SetScrollHeight(0);
	GetWindowHandle("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea").SetScrollPosition(0);
	i = 0;
	while((i < 120))
	{
		GetWindowHandle(("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(i))).HideWindow();
		GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(i)) $ ".NEWRibbon_tex")).HideWindow();
		GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(i)) $ ".ServerDisable_tex")).HideWindow();
		GetTextBoxHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(i)) $ ".ServerName_Txt")).SetText("");
		GetTextBoxHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(i)) $ ".CharacterNum_txt")).SetText("");
		i++;
	}
	return;
}

function int getServerDataIndexByButtonIndex(int buttonIndex)
{
	local int i;

	i = 0;
	while((i < serverData_Array.Length))
	{
		if((serverData_Array[i].buttonIndex == buttonIndex))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int getServerDataIndexByNewServerButtonIndex(int newServerButtonIndex)
{
	local int i;

	i = 0;
	while((i < serverData_Array.Length))
	{
		if((serverData_Array[i].newServerButtonIndex == newServerButtonIndex))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function showServerList(int IsClassicServer, int IsAdenServer, optional bool bAllClassic, optional bool testServer)
{
	local int i, Index, W, h, posX, posY, selectedH, nShowEvaServerCount, nShowWolfServerCount;
	local bool bEvaSkiped, bWolfSkiped;
	local int nWidthSizeStep;

	i = 0;
	while((i < serverData_Array.Length))
	{
		serverData_Array[i].buttonIndex = -1;
		if((testServer == false))
		{
			if((IsClassicServer == 1))
			{
				if((serverData_Array[i].IsClassicServer == 0))
				{
					i++;
					continue;
				}
				if((bAllClassic == false))
				{
					if((IsAdenServer == 1))
					{
						if((serverData_Array[i].IsAdenServer == 0))
						{
							i++;
							continue;
						}
					}
					else if((IsAdenServer == 0))
					{
						if((serverData_Array[i].IsAdenServer == 1))
						{
							continue;
						}
					}
				}
			}
			else if((serverData_Array[i].IsClassicServer == 1))
			{
				continue;
			}
		}
		if((testServer == false))
		{
			if((((currentEvaServerCount != 0) && (nShowEvaServerCount >= currentEvaServerCount)) && !bEvaSkiped))
			{
				W = 0;
				h++;
				bEvaSkiped = true;
				Debug(("bEvaSkiped," @ string(h)));
			}
			else if((((currentWolfServerCount != 0) && (nShowWolfServerCount >= currentWolfServerCount)) && !bWolfSkiped))
			{
				W = 0;
				h++;
				bWolfSkiped = true;
				Debug(("bWolfSkiped," @ string(h)));
			}
			else if((W == 4))
			{
				W = 0;
				h++;
				Debug(("w==4, " @ string(h)));
			}
		}
		else if((W == 4))
		{
			W = 0;
			h++;
			Debug(("test w==4, " @ string(h)));
		}
		if(((serverData_Array[i].IsWolfServer == 1) && (currentWolfServerCount == 2)))
		{
			nWidthSizeStep = 3;
			GetWindowHandle(("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index))).SetWindowSize(502, 98);
			GetButtonHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".Server_BTN")).SetTexture("L2UI_CT1.Button.emptyBtn", "L2UI_CT1.Button.emptyBtn", "L2UI_NewTex.logInServerSelectWnd.ServerListBGLong_over");
			posX = (502 * W);
		}
		else if(((serverData_Array[i].IsWolfServer == 1) && (currentWolfServerCount == 3)))
		{
			nWidthSizeStep = 2;
			GetWindowHandle(("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index))).SetWindowSize(335, 98);
			GetButtonHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".Server_BTN")).SetTexture("L2UI_CT1.Button.emptyBtn", "L2UI_CT1.Button.emptyBtn", "L2UI_NewTex.logInServerSelectWnd.ServerListBGmedium_over");
			posX = (335 * W);
		}
		else
		{
			nWidthSizeStep = 1;
			GetWindowHandle(("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index))).SetWindowSize(251, 98);
			GetButtonHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".Server_BTN")).SetTexture("L2UI_CT1.Button.emptyBtn", "L2UI_CT1.Button.emptyBtn", "L2UI_NewTex.logInServerSelectWnd.ServerListBG_over");
			posX = ((251 + 0) * W);
		}
		posY = ((98 + 0) * h);
		W++;
		GetWindowHandle(("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index))).ShowWindow();
		GetWindowHandle(("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index))).MoveC(posX, posY);
		serverData_Array[i].buttonIndex = Index;
		GetTextBoxHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerName_Txt")).SetText(serverData_Array[i].Name);
		GetTextBoxHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".CharacterNum_txt")).SetText(string(serverData_Array[i].charCnt));
		GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerCondition_tex")).SetColorModify(serverData_Array[i].stateColor);
		if((serverData_Array[i].State == GetSystemString(456)))
		{
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerDisable_tex")).ShowWindow();
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerCondition_tex")).SetColorModify(GetColor(85, 85, 85, 255));
		}
		if((serverData_Array[i].IsNewServer == 1))
		{
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".NEWRibbon_tex")).ShowWindow();
		}
		if((serverData_Array[i].IsPVPServer == 1))
		{
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".NonPVP_tex")).ShowWindow();
			GetTextBoxHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerDesc_txt")).ShowWindow();
			GetTextBoxHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerDesc_txt")).SetText(GetSystemString(14229));
		}
		else if((serverData_Array[i].IsPVPServer == 2))
		{
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".NonPVP_tex")).ShowWindow();
			GetTextBoxHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerDesc_txt")).ShowWindow();
			GetTextBoxHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerDesc_txt")).SetText(GetSystemString(14292));
		}
		else
		{
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".NonPVP_tex")).HideWindow();
			GetTextBoxHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerDesc_txt")).HideWindow();
		}
		if((serverData_Array[i].IsClassicServer == 1))
		{
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".CharacterICON_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.CharacterIcon_L2Aden");
			if((serverData_Array[i].IsEvaServer == 1))
			{
				GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".NEWRibbon_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ribbonNEW_L2Eva");
			}
			else if((serverData_Array[i].IsWolfServer == 1))
			{
				GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".NEWRibbon_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ribbonNEW_L2Eva");
			}
			else
			{
				GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".NEWRibbon_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ribbonNEW_L2Aden");
			}
		}
		else
		{
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".CharacterICON_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.CharacterIcon_L2");
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".NEWRibbon_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ribbonNEW_L2");
		}
		if((serverData_Array[i].IsClassicServer == 1))
		{
			if((currentSelectedServerDataArrayIndex == i))
			{
				GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetAlpha(50);
				if((serverData_Array[i].IsEvaServer == 1))
				{
					GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGEva_Select");
				}
				else if((serverData_Array[i].IsWolfServer == 1))
				{
					if((nWidthSizeStep == 3))
					{
						GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGWolfLong_Select");
					}
					else if((nWidthSizeStep == 2))
					{
						if((serverData_Array[i].Id == 83))
						{
							GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGValakas_Select");
						}
						else
						{
							GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGWolfmedium_Select");
						}
					}
					else
					{
						GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGWolf_Select");
					}
				}
				else
				{
					GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGL2Aden_Select");
				}
				GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetAlpha(255, 0.4000000);
				selectedH = h;
			}
			else if((serverData_Array[i].IsEvaServer == 1))
			{
				GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGEva");
			}
			else if((serverData_Array[i].IsWolfServer == 1))
			{
				if((nWidthSizeStep == 3))
				{
					GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGWolfLong");
				}
				else if((nWidthSizeStep == 2))
				{
					if((serverData_Array[i].Id == 83))
					{
						GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGValakas");
					}
					else
					{
						GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGWolfmedium");
					}
				}
				else
				{
					GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGWolf");
				}
			}
			else
			{
				GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGL2Aden");
			}
		}
		else if((currentSelectedServerDataArrayIndex == i))
		{
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetAlpha(50);
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGL2_Select");
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetAlpha(255, 0.4000000);
			selectedH = h;
		}
		else
		{
			GetTextureHandle((("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea.ServerSelectAsset" $ string(Index)) $ ".ServerListBG_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListBGL2");
		}
		Index++;
		if((serverData_Array[i].IsEvaServer == 1))
		{
			nShowEvaServerCount++;
		}
		if((serverData_Array[i].IsWolfServer == 1))
		{
			nShowWolfServerCount++;
		}
		i++;
	}
	GetWindowHandle("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea").SetScrollHeight((98 * (h + 1)));
	if((selectedH > 2))
	{
		GetWindowHandle("logInServerSelectWnd.NormalWnd.ServerListWnd.List_Wnd.List_ScrollArea").SetScrollPosition((98 * (selectedH - 2)));
	}
	return;
}

function setNewServerGroupWindowResize(int newServerCount)
{
	if((newServerCount > 0))
	{
		GetTextBoxHandle("logInServerSelectWnd.NewserverDiscription_txt").ShowWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd").ShowWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN01").HideWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN02").HideWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN03").HideWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN04").HideWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN05").HideWindow();
		if((newServerCount > 5))
		{
			newServerCount = 5;
		}
		switch(newServerCount)
		{
			case 5:
				GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN05").ShowWindow();
			case 4:
				GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN04").ShowWindow();
			case 3:
				GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN03").ShowWindow();
			case 2:
				GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN02").ShowWindow();
			case 1:
				GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN01").ShowWindow();
			default:
				GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd").SetWindowSize(((234 + 2) * newServerCount), 42);
		}
	}
	else
	{
		GetTextBoxHandle("logInServerSelectWnd.NewserverDiscription_txt").HideWindow();
		GetWindowHandle("logInServerSelectWnd.NewServerBTNGroup_Wnd").HideWindow();
	}
	return;
}

function setNewServerBtn(int Index, int serverDataIndex)
{
	Debug((("신서버 setNewServerBtn " @ string(Index)) @ string(serverDataIndex)));  // EN?: New server setNewServerBtn
	if((Index > 5))
	{
		Debug((("- 경고!!!!! setNewServerBtn Index값이 너무 큰 값이 들어 왔습니다. " @ string(Index)) @ string(serverDataIndex)));  // EN?: - Warning!!!!! setNewServerBtn Index value is too large.
		return;
	}
	GetTextBoxHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".ServerName_txt")).SetText(serverData_Array[serverDataIndex].Name);
	if((serverData_Array[serverDataIndex].State == GetSystemString(456)))
	{
		GetTextureHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".ServerCondition_tex")).SetColorModify(GetColor(85, 85, 85, 255));
		GetTextureHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".NewServerDisable_tex")).ShowWindow();
	}
	else
	{
		GetTextureHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".ServerCondition_tex")).SetColorModify(serverData_Array[serverDataIndex].stateColor);
		GetTextureHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".NewServerDisable_tex")).HideWindow();
	}
	if((serverData_Array[serverDataIndex].IsNewServer == 1))
	{
		GetTextureHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".NEWRibbon_tex")).ShowWindow();
	}
	if((((serverData_Array[serverDataIndex].IsClassicServer == 1) && (serverData_Array[serverDataIndex].IsEvaServer == 0)) && (serverData_Array[serverDataIndex].IsWolfServer == 0)))
	{
		GetTextureHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".NEWRibbon_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ribbonNEW_L2Aden");
		GetButtonHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".newserverBTN")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2Aden", "L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2Aden_Down", "L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2Aden_Over");
	}
	else if((serverData_Array[serverDataIndex].IsEvaServer == 1))
	{
		GetTextureHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".NEWRibbon_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ribbonNEW_L2Eva");
		GetButtonHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".newserverBTN")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2Eva", "L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2Eva_Down", "L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2Eva_Over");
	}
	else if((serverData_Array[serverDataIndex].IsWolfServer == 1))
	{
		GetTextureHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".NEWRibbon_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ribbonNEW_L2Eva");
		GetButtonHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".newserverBTN")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2Eva", "L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2Eva_Down", "L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2Eva_Over");
	}
	else
	{
		GetTextureHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".NEWRibbon_tex")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ribbonNEW_L2");
		GetButtonHandle((("logInServerSelectWnd.NewServerBTNGroup_Wnd.NewBTN0" $ string(Index)) $ ".newserverBTN")).SetTexture("L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2", "L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2_Down", "L2UI_NewTex.logInServerSelectWnd.ServerListNEWBGL2_Over");
	}
	return;
}

function FindAge(int ServerID)
{
	local int i, intAge;
	local string strParam;

	i = 0;
	while((i < serverData_Array.Length))
	{
		if((ServerID == serverData_Array[i].Id))
		{
			if((serverData_Array[i].AgeLimit == 15))
			{
				intAge = 0;
			}
			else if((serverData_Array[i].AgeLimit == 18))
			{
				intAge = 1;
			}
			else
			{
				intAge = 1;
			}
			ParamAdd(strParam, "ServerAgeLimit", string(intAge));
			ParamAdd(strParam, "GlobalVersion", string(getLanguageNum()));
			ExecuteEvent(170, strParam);
			break;
		}
		i++;
	}
	return;
}

function connectServer(int arrayIndex)
{
	ServerListWnd.HideWindow();
	GetWindowHandle("loginServerInfoWnd").ShowWindow();
	GetButtonHandle("logInServerSelectWnd.ServerSelectOK_btn").ShowWindow();
	GetButtonHandle("logInServerSelectWnd.ServerSelectCancel_btn").ShowWindow();
	FindAge(serverData_Array[arrayIndex].Id);
	RequestLoginServer(serverData_Array[arrayIndex].Id);
	return;
}

function int getLanguageNum()
{
	local UIEventManager.ELanguageType Language;

	Language = GetLanguage();
	return int(Language);
}

function bool isKr()
{
	return (int(GetLanguage()) == 0);
}
