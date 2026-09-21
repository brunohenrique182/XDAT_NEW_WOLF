class ClanGfxWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
	RegisterGFxEvent(10350);
	RegisterGFxEvent(10360);
	RegisterGFxEvent(10370);
	RegisterGFxEvent(10420);
	RegisterGFxEvent(10430);
	RegisterGFxEvent(10450);
	RegisterGFxEvent(10460);
	RegisterGFxEvent(10470);
	RegisterGFxEvent(10480);
	RegisterGFxEvent(10490);
	RegisterGFxEvent(10500);
	RegisterGFxEvent(10510);
	RegisterGFxEvent(10520);
	RegisterGFxEvent(10530);
	RegisterGFxEvent(10540);
	RegisterGFxEvent(10550);
	RegisterGFxEvent(10560);
	RegisterGFxEvent(10570);
	RegisterGFxEvent(10590);
	RegisterGFxEvent(10600);
	RegisterGFxEvent(10610);
	RegisterGFxEvent(10620);
	RegisterGFxEvent(10630);
	RegisterGFxEvent(10640);
	RegisterGFxEvent(10650);
	RegisterGFxEvent(10660);
	RegisterGFxEvent(10580);
	RegisterGFxEvent(10710);
	RegisterGFxEvent(10720);
	RegisterGFxEvent(10730);
	RegisterGFxEvent(10740);
	RegisterGFxEvent(10670);
	RegisterGFxEvent(10680);
	RegisterGFxEvent(10690);
	RegisterGFxEvent(10750);
	RegisterGFxEvent(10760);
	RegisterGFxEvent(10770);
	RegisterGFxEvent(10780);
	RegisterGFxEvent(10790);
	RegisterGFxEvent(10830);
	RegisterGFxEvent(10840);
	RegisterGFxEvent(10850);
	RegisterGFxEvent(10451);
	RegisterGFxEvent(150);
	RegisterGFxEvent(160);
	RegisterGFxEventForLoaded(40);
	return;
}

function OnLoad()
{
	SetSaveWnd(true, false);
	AddState("GAMINGSTATE");
	AddState("ARENAGAMINGSTATE");
	SetContainerWindow("SkinnedWindow", 7285);
	return;
}

function OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_PledgeWnd);
	return;
}

function OnShow()
{
	getInstanceL2Util().checkIsPrologueGrowType(string(self));
	return;
}

function OnCallUCFunction(string funcName, string param)
{
	local FileRegisterWnd Script;
	local string strParam;

	Debug(("funcName:" @ funcName));
	Debug(("param:" @ param));
	if((funcName == "FileRegisterWndShowByTypeStr"))
	{
		Script = FileRegisterWnd(GetScript("FileRegisterWnd"));
		Script.FileRegisterWndShowByTypeStr(param);
	}
	else if((funcName == "pledgepenalty"))
	{
		ExecuteCommandFromAction("pledgepenalty");
	}
	else if((funcName == "ClanSearch"))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanSearch"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ClanSearch");
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ClanSearch");
			Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ClanSearch");
		}
	}
	else if((funcName == "ClanShopWnd"))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanShopWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ClanShopWnd");
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ClanShopWnd");
			Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ClanShopWnd");
		}
	}
	else if((funcName == "ToDoListClanWnd"))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ToDoListClanWnd"))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ToDoListClanWnd");
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ToDoListClanWnd");
			Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ToDoListClanWnd");
		}
	}
	else if((funcName == "InviteFriend"))
	{
		Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(param);
	}
	else if((funcName == "InviteParty"))
	{
		RequestInviteParty(param);
	}
	else if((funcName == "ClanBoard"))
	{
		strParam = "";
		ParamAdd(strParam, "Index", "3");
		ExecuteEvent(1190, strParam);
	}
	else if((funcName == "ClanHelp"))
	{
		ExecuteEvent(1210, "147");
	}
	else if((funcName == "benefit"))
	{
		ExecuteEvent(1210, "153");
	}
	else if((funcName == "agit"))
	{
	}
	else if((funcName == "addFriend"))
	{
		Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(param);
	}
	else if((funcName == "inviteParty"))
	{
		RequestInviteParty(param);
	}
	else if((funcName == "whisper"))
	{
		whisperToUser(param);
	}
	return;
}

function whisperToUser(string UserName)
{
	local ChatWnd chatWndScript;

	if((UserName != ""))
	{
		chatWndScript = ChatWnd(GetScript("ChatWnd"));
		chatWndScript.SetChatEditBox((("\"" $ UserName) $ " "));
	}
	return;
}
