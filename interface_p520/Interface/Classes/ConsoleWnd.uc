class ConsoleWnd extends UICommonAPI;

const DLG_ID_RESTART = 0;
const DLG_ID_QUIT = 1;
const DIG_ID_ASK_COUPLEACTION = 1112;
const TIMER_ID_POSTION = 1001110;

var WindowHandle m_hSystemMenuWnd;
var WindowHandle Me;
var DialogBox dScript;

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(4900);
	RegisterEvent(4920);
	RegisterEvent(13);
	RegisterEvent(14);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	Me = GetWindowHandle("ConsoleWnd");
	dScript = DialogBox(GetScript("DialogBox"));
	return;
}

function firstRunSetDefaultPosition()
{
	SetINIInt("ScreenSize", "f", 1, "WindowsInfo.ini");
	SetDefaultPosition();
	Debug("---------- SetDefaultPosition ---------------");
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1001110))
	{
		firstRunSetDefaultPosition();
		Me.KillTimer(1001110);
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local string htm;
	local int nFirstRun;

	switch(Event_ID)
	{
		case 9750:
			GetINIInt("ScreenSize", "f", nFirstRun, "WindowsInfo.ini");
			if((nFirstRun == 0))
			{
				Me.SetTimer(1001110, 1500);
			}
			break;
		case 11:
			SetINIInt("PartyWndClassic", "e", 1, "WindowsInfo.ini");
			SetINIInt("PartyWnd", "e", 1, "WindowsInfo.ini");
			break;
		case 13:
			htm = ((((((((gfxHtmlAddText("받을 아이템 : ", "#FFEE33", "22") $ gfxHtmlAddItemTexture(1, 32, 32, -5)) $ brPixel(5)) $ gfxHtmlAddItemTexture(2, 24, 24, -5)) $ gfxHtmlAddText("행운을 잡으셨네요!", "#00FF00", "25")) $ br()) $ gfxHtmlAddItemTexture(352, 32, 32, -4)) $ gfxHtmlAddText("마법사의 보은:", "#FF0F20", "22")) $ gfxHtmlAddText("고양이", "#CC2F3F", "24"));  // EN?: You'll get: | EN?: Good luck! | EN?: Wizard's Boeing:
			htm = getInstanceL2Util().htmlSetHtmlStart(htm);
			Debug(("htm" @ htm));
			getInstanceL2Util().showGfxScreenMessage(htm);
			break;
		case 14:
			getInstanceL2Util().showGfxScreenMessage(param);
			break;
		case 1710:
			HandleDlgOk();
			break;
		case 4900:
			HandleCoupleActionAskStart(param);
			break;
		case 4920:
			HandleUploadAllianceCrestFile();
			break;
		case 1720:
			HandleDialogCancel();
			break;
		default:
			break;
	}
	return;
}

function HandleDlgOk()
{
	if(!DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case 1112:
			dScript._SetButtonName(1337, 1342);
			AnswerCoupleAction(DialogGetReservedInt(), 1, DialogGetReservedInt3());
			break;
		default:
			break;
	}
	return;
}

function HandleCoupleActionAskStart(string param)
{
	local bool bOption;
	local int pActionID, pRequestUserID;
	local string UserName, actionStr;

	bOption = GetOptionBool("Communication", "IsCoupleAction");
	ParseInt(param, "ActionID", pActionID);
	ParseInt(param, "requestUserID", pRequestUserID);
	if((bOption == true))
	{
		AnswerCoupleAction(pActionID, -1, pRequestUserID);
	}
	else
	{
		if(IsShowWindow("DialogBox"))
		{
			AnswerCoupleAction(pActionID, 0, pRequestUserID);
			return;
		}
		UserName = Class'NWindow.UIDATA_USER'.static.GetUserName(pRequestUserID);
		DialogSetID(1112);
		DialogSetCancelD(1112);
		DialogSetReservedInt(pActionID);
		DialogSetReservedInt3(pRequestUserID);
		DialogSetParamInt64(INT64((10 * 1000)));
		dScript._SetButtonName(184, 185);
		Class'NWindow.ActionAPI'.static.GetActionNameBySocialIndex(pActionID, actionStr);
		DialogShow(DialogModalType_Modalless, DialogType_Progress, MakeFullSystemMsg(GetSystemMessage(3118), UserName, actionStr));
	}
	return;
}

function HandleDialogCancel()
{
	local bool bOption;

	dScript._SetButtonName(1337, 1342);
	if(DialogIsMine())
	{
		if(DialogCheckCancelByID(1112))
		{
			bOption = GetOptionBool("Communication", "IsCoupleAction");
			Debug("=====================커플액션========================================");  // EN: =====================couple action========================================
			Debug(("==> DialogGetReservedInt() " @ string(DialogGetReservedInt())));
			Debug(("==> DialogGetReservedInt3() " @ string(DialogGetReservedInt3())));
			Debug(("==> Answer " @ string(0)));
			AnswerCoupleAction(DialogGetReservedInt(), 0, DialogGetReservedInt3());
		}
	}
	return;
}

function HandleUploadAllianceCrestFile()
{
	local array<string> fileextarr;

	if((Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("FileRegisterWnd") == false))
	{
		AddSystemMessage(3143);
		fileextarr.Length = 1;
		fileextarr[0] = "bmp";
		ClearFileRegisterWndFileExt();
		AddFileRegisterWndFileExt(GetSystemString(2811), fileextarr);
		FileRegisterWndShow(FH_ALLIANCE_CREST_UPLOAD);
	}
	return;
}
