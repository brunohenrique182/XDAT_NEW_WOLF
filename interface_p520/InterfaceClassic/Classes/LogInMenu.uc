class LogInMenu extends GFxUIScript;

const DLG_ID_WAITING = 100021;

var array<GFxValue> args;
var GFxValue invokeResult;
var L2Util util;
var DialogBox dScript;
var string m_Windowname;
var bool useMiniLogo;

function OnRegisterEvent()
{
	RegisterEvent(5630);
	RegisterEvent(2900);
	RegisterEvent(3410);
	RegisterEvent(5651);
	RegisterEvent(1710);
	return;
}

function OnLoad()
{
	m_Windowname = "LoginMenu";
	useMiniLogo = true;
	SetHavingFocus(false);
	SetContainer("ContainerHUD");
	dScript = DialogBox(GetScript("DialogBox"));
	return;
}

function OnFlashLoaded()
{
	SendCurrLanguage();
	return;
}

function OnFocus(bool bFlag, bool bTransparency)
{
	return;
}

function OnHide()
{
	return;
}

function OnCallUCFunction(string logicID, string param)
{
	local string strParam;

	if((logicID == "0"))
	{
		if(((IsNative() == false) && (getLanguageNum() == 5)))
		{
			ParamAdd(strParam, "type", "s");
			ParamAdd(strParam, "ErrorMsg", MakeFullSystemMsg(GetSystemMessage(6090), GetSystemMessage(6088), GetSystemMessage(6089)));
		}
		else
		{
			ParamAdd(strParam, "type", "s");
			ParamAdd(strParam, "ErrorMsg", GetSystemMessage(5019));
		}
		ExecuteEvent(5641, strParam);
	}
	else if((logicID == "1"))
	{
		if(((IsNative() == false) && (getLanguageNum() == 5)))
		{
			ParamAdd(strParam, "ErrorMsg", MakeFullSystemMsg(GetSystemMessage(6087), GetSystemMessage(6088), GetSystemMessage(6089)));
		}
		else
		{
			ParamAdd(strParam, "ErrorMsg", GetSystemMessage(5020));
		}
		ExecuteEvent(5641, strParam);
	}
	else if((logicID == "2"))
	{
		OpenL2Home();
	}
	else if((logicID == "3"))
	{
		StartCredit();
	}
	else if((logicID == "4"))
	{
		SetUIState("ReplaySelectState");
	}
	else if((logicID == "5"))
	{
		HandleShowOptionWnd();
	}
	else if((logicID == "6"))
	{
		ParamAdd(strParam, "type", "s");
		ParamAdd(strParam, "ErrorMsg", GetSystemMessage(4082));
		ExecuteEvent(5641, strParam);
	}
	else if((logicID == "7"))
	{
		RefuseLogin();
	}
	else if((logicID == "100"))
	{
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 5630))
	{
		if((IsShowWindow() == false))
		{
			ShowWindow();
			SendScreenSize();
		}
	}
	else if((Event_ID == 2900))
	{
		SendScreenSize();
	}
	else if((Event_ID == 3410))
	{
		switch(param)
		{
			case "LoginState":
				if((int(GetLanguage()) == 0))
				{
					SendSetButtonVisible(false);
				}
				else
				{
					SendSetButtonVisible(true);
				}
				break;
			case "ReplaySelectState":
			case "LOGINWAITSTATE":
			case "EULAMSGSTATE":
			case "SERVERLISTSTATE":
			case "LOGINWAITSTATE":
				ShowWindow();
				SendScreenSize();
				if(IsTencentLoginSystem())
				{
					SendSetButtonVisible(false);
					RequestAuthLoginForTCLS();
				}
				else
				{
					SendSetButtonVisible(false);
				}
				break;
			default:
				HideWindow();
		}
	}
	else if((Event_ID == 5651))
	{
		waitingProcess(param);
	}
	else if((Event_ID == 1710))
	{
		if(!Class'InterfaceClassic.UICommonAPI'.static.DialogIsMineWithTarget(m_Windowname))
		{
			return;
		}
		switch(dScript.GetID())
		{
			case 100021:
				CancelWaitingQueueTicket();
				if(!IsTencentLoginSystem())
				{
					SetUIState("LoginState");
				}
				break;
			default:
				break;
		}
	}
	return;
}

function waitingProcess(string param)
{
	local int nResult, nWaiterCount;
	local string MessageString;

	ParseInt(param, "nResult", nResult);
	ParseInt(param, "nWaiterCount", nWaiterCount);
	MessageString = "";
	dScript.HideDialog();
	if(((nResult == 1) && (nWaiterCount > 0)))
	{
		MessageString = MakeFullSystemMsg(GetSystemMessage(6830), string(nWaiterCount));
		if((Len(MessageString) > 0))
		{
			dScript._DialogShowWithTarget(DialogModalType_Modal, DialogType_Notice, MessageString, m_Windowname);
			dScript.setId(100021);
		}
	}
	else if(((nResult == 1) && (nWaiterCount == 0)))
	{
	}
	else
	{
		MessageString = MakeFullSystemMsg(GetSystemMessage(7203), string(nWaiterCount));
		dScript._DialogShowWithTarget(DialogModalType_Modal, DialogType_Notice, MessageString, m_Windowname);
		dScript.setId(100021);
	}
	return;
}

function SendSetButtonVisible(bool B)
{
	if(IsTencentLoginSystem())
	{
		CallGFxFunction("LogInMenu", "SendSetStartButtonVisible", ("bool=" $ string(B)));
	}
	CallGFxFunction("LogInMenu", "SendSetButtonVisible", ("bool=" $ string(B)));
	return;
}

function SendCurrLanguage()
{
	local int languageNum;

	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	args[0].SetInt(51);
	CreateObject(args[1]);
	languageNum = getLanguageNum();
	if(((IsNative() == false) && (getLanguageNum() == 5)))
	{
		languageNum = 1;
	}
	CallGFxFunction(m_Windowname, "SendCurrLanguage", ("language=" $ string(languageNum)));
	args[1].SetMemberInt("language", languageNum);
	Invoke("_root.onEvent", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}

function int getLanguageNum()
{
	local UIEventManager.ELanguageType Language;

	Language = GetLanguage();
	return int(Language);
}

function SendScreenSize()
{
	CallGFxFunction(m_Windowname, "SendScreenSize", "");
	return;
}

function HandleShowOptionWnd()
{
	local OptionWnd win;

	win = OptionWnd(GetScript("OptionWnd"));
	win.ToggleOpenMeWnd(false);
	return;
}
