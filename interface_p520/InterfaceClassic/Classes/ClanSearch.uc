class ClanSearch extends L2UIGFxScript;

var int clanID;

function OnRegisterEvent()
{
	RegisterGFxEvent(9620);
	RegisterGFxEvent(9621);
	RegisterGFxEvent(9600);
	RegisterGFxEvent(9601);
	RegisterGFxEvent(9580);
	RegisterGFxEvent(9581);
	RegisterGFxEvent(9590);
	RegisterGFxEvent(9582);
	RegisterGFxEvent(9583);
	RegisterGFxEvent(9610);
	RegisterGFxEvent(9591);
	RegisterGFxEvent(9640);
	RegisterGFxEvent(340);
	RegisterGFxEvent(10520);
	RegisterGFxEvent(430);
	RegisterGFxEvent(10510);
	RegisterGFxEvent(40);
	RegisterGFxEvent(420);
	RegisterGFxEvent(10470);
	return;
}

function OnShow()
{
	getInstanceL2Util().checkIsPrologueGrowType(string(self));
	return;
}

function OnLoad()
{
	SetSaveWnd(true, false);
	SetContainerWindow("SkinnedWindow", 3068);
	AddState("GAMINGSTATE");
	AddState("ARENAGAMINGSTATE");
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "getClanID":
			getClanID();
			break;
		case "sendPost":
			sendPost(param);
			break;
		case "whisperToUser":
			whisperToUser(param);
			break;
		case "askJoin":
			askJoin(param);
			break;
		default:
			break;
	}
	return;
}

function getClanID()
{
	local UserInfo UserInfo;

	if(GetPlayerInfo(UserInfo))
	{
		clanID = UserInfo.nClanID;
	}
	return;
}

function sendPost(string UserName)
{
	local PostBoxWnd postBoxWndScript;
	local PostWriteWnd postWriteWndScript;

	if((UserName != ""))
	{
		postBoxWndScript = PostBoxWnd(GetScript("PostBoxWnd"));
		postWriteWndScript = PostWriteWnd(GetScript("PostWriteWnd"));
		postBoxWndScript.OnClickButton("PostSendBtn");
		postWriteWndScript.ToWrite(UserName);
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

function askJoin(string UserID)
{
	local int nID;
	local InviteClanPopWnd InviteClanPopWndScript;

	nID = int(UserID);
	if((nID > 0))
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			ClanWndClassicNew(GetScript("ClanWndClassicNew")).askJoin();
		}
		else
		{
			InviteClanPopWndScript = InviteClanPopWnd(GetScript("InviteClanPopWnd"));
			InviteClanPopWndScript.showByClanWnd();
		}
	}
	return;
}
