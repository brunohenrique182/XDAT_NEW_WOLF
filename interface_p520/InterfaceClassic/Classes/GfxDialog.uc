class GfxDialog extends L2UIGFxScript;

const DIALOG_ID_JOINOTP = 100001;
const DIALOG_ID_NOTICE = 100002;

var UserInfo currentUserInfo;
var bool isDualMoviePlay;
var int _classID;
var string _linkageName;
var string _userName;
var DialogBox ucDialogScript;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(5641);
	RegisterEvent(1710);
	return;
}

function OnLoad()
{
	RegisterState(getCurrentWindowName(string(self)), "GamingState");
	SetAlwaysOnTop(true);
	SetClosingOnESC();
	ucDialogScript = DialogBox(GetScript("DialogBox"));
	return;
}

function OnFlashLoaded()
{
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 0, 0);
	return;
}

function OnShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
	return;
}

function OnHide()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 5641))
	{
		showUCDialogBox(param);
	}
	else if((Event_ID == 40))
	{
		HideWindow();
	}
	else if((Event_ID == 1710))
	{
		dialogOK_Handler();
	}
	return;
}

function dialogOK_Handler()
{
	if(!DialogIsMineWithTarget("GfxDialog"))
	{
		return;
	}
	switch(ucDialogScript.GetID())
	{
		case 100001:
			OpenGivenURL(GetSystemString(3911));
			if(IsUseTokenLogin())
			{
				ExecQuit();
			}
			else
			{
				GotoLogin();
			}
			break;
		case 100002:
			if((int(GetLanguage()) == 3))
			{
				RequestExit();
			}
		default:
			break;
	}
	return;
}

function showUCDialogBox(string param)
{
	local int nErrorSystemMessageID, dialogID;
	local UIScript.EDialogType dialogStyle;
	local string dialogBoxMsg, parseType;

	ParseString(param, "Type", parseType);
	if((parseType == "d"))
	{
		ParseInt(param, "ErrorID", nErrorSystemMessageID);
		dialogBoxMsg = GetSystemMessage(nErrorSystemMessageID);
		if((nErrorSystemMessageID == 5073))
		{
			dialogID = 100001;
			if(IsUseTokenLogin())
			{
				dialogStyle = DialogType_OK;
			}
			else
			{
				dialogStyle = DialogType_OKCancel;
			}
			ucDialogScript._SetButtonName(3910);
		}
		else
		{
			dialogID = 100002;
			dialogStyle = DialogType_OK;
		}
	}
	else
	{
		dialogID = 100002;
		ParseString(param, "ErrorMsg", dialogBoxMsg);
		dialogStyle = DialogType_OK;
	}
	ucDialogScript._DialogShowHtmlWithTarget(DialogModalType_Modal, dialogStyle, dialogBoxMsg, "GfxDialog");
	ucDialogScript.setId(dialogID);
	return;
}

function showGfxDialog(string linkageName, string Type, string param)
{
	local int ClassID, EventID;
	local array<GFxValue> args;
	local GFxValue invokeResult;

	_linkageName = Type;
	if((Type != "AwakeNoticeDialog"))
	{
		SetModal(true);
	}
	else
	{
		SetModal(false);
	}
	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	CreateObject(args[1]);
	if((Type == "DualPayDialogStep1"))
	{
		GetPlayerInfo(currentUserInfo);
		ParseInt(param, "Class", ClassID);
		_classID = ClassID;
		_userName = currentUserInfo.Name;
		EventID = 1;
		args[1].SetMemberString("userName", currentUserInfo.Name);
		args[1].SetMemberString(linkageName, Type);
		args[1].SetMemberInt("classID", ClassID);
		ShowWindow();
	}
	else if((Type == "DualPayDialogStep2"))
	{
		GetPlayerInfo(currentUserInfo);
		EventID = 1;
		args[1].SetMemberString(linkageName, Type);
		ShowWindow();
	}
	else if((Type == "AwakeNoticeDialog"))
	{
		if(!GetPlayerInfo(currentUserInfo))
		{
			DeallocGFxValue(invokeResult);
			DeallocGFxValues(args);
			return;
		}
		if(((currentUserInfo.nClassID <= 147) && (currentUserInfo.nClassID >= 139)))
		{
			HideWindow();
			DeallocGFxValue(invokeResult);
			DeallocGFxValues(args);
			return;
		}
		else
		{
			ParseInt(param, "Class", ClassID);
			_classID = ClassID;
			EventID = 1;
			args[1].SetMemberString(linkageName, Type);
			args[1].SetMemberInt("classID", ClassID);
			ShowWindow();
		}
	}
	args[0].SetInt(EventID);
	Invoke("onEvent", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}

function OnCallUCLogic(int logicID, string param)
{
	local string dialogName;

	ParseString(param, "Name", dialogName);
	switch(dialogName)
	{
		case "AwakeNoticeDialog":
			AwakeNoticeDialogHandler(logicID, param);
			break;
		case "DualPayDialogStep1":
			DualPayDialogStep1(logicID, param);
			break;
		case "DualPayDialogStep2":
			DualPayDialogStep2(logicID, param);
			break;
		default:
			break;
	}
	if((logicID == 3))
	{
		OpenL2Home();
	}
	return;
}

function DualPayDialogStep1(int logicID, string param)
{
	isDualMoviePlay = true;
	RequestShowVisionMovie();
	return;
}

function onMovieEnd()
{
	if(isDualMoviePlay)
	{
		isDualMoviePlay = false;
		showGfxDialog("dialogLinkageName", "DualPayDialogStep2", "");
	}
	return;
}

function DualPayDialogStep2(int logicID, string param)
{
	local InventoryWnd Script;

	if((logicID == 1))
	{
		OpenGivenURL(GetSystemString(3120));
	}
	Script = InventoryWnd(GetScript("InventoryWnd"));
	Script.SaveInventoryOrder();
	ExecQuit();
	return;
}

function AwakeNoticeDialogHandler(int logicID, string param)
{
	local string strParam;
	local int ClassID;

	GetPlayerInfo(currentUserInfo);
	if(((currentUserInfo.nClassID <= 147) && (currentUserInfo.nClassID >= 139)))
	{
	}
	else if((logicID == 1))
	{
		RequestCallToChangeClass();
	}
	else if((logicID == 2))
	{
		ParseInt(param, "Class", ClassID);
		ParamAdd(strParam, "Class", string(ClassID));
		ParamAdd(strParam, "Immediate", string(0));
		ParamAdd(strParam, "UserType", string(1));
		ExecuteEvent(5470, strParam);
	}
	return;
}

function OnReceivedCloseUI()
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 1);
	AllocGFxValue(invokeResult);
	Invoke("onReceivedCloseUI", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}
