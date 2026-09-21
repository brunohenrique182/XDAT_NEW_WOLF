class LoginServerSelect extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

var array<int> arrID;
var array<int> arrAgeLimit;
var int currentScreenWidth;
var int currentScreenHeight;

function int getLanguageNum()
{
	local UIEventManager.ELanguageType Language;

	Language = GetLanguage();
	return int(Language);
}

function OnShow()
{
	return;
}

function OnFlashLoaded()
{
	return;
}

function checkWarnimgMode()
{
	local string Msg;

	if((getLanguageNum() == 0))
	{
		Msg = GetSystemMessage(5070);
	}
	CallGFxFunction("LoginServerSelect", "showWarningMode", Msg);
	return;
}

function OnHide()
{
	return;
}

function OnCallUCFunction(string funcName, string param)
{
	local int severNum;
	local string strParam;

	switch(funcName)
	{
		case "selectServer":
			ParseInt(param, "serverNum", severNum);
			FindAge(severNum);
			RequestLoginServer(severNum);
			break;
		case "selectServerCancle":
			GotoLogin();
			break;
		case "sortServerList":
			RequestSortedServerInfo();
			break;
		case "showHelp":
			ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "server_help.htm"));
			ExecuteEvent(1210, strParam);
			break;
		default:
			break;
	}
	return;
}

function FindAge(int ServerID)
{
	local int i, intAge;
	local string strParam;

	i = 0;
	while((i < arrID.Length))
	{
		if((ServerID == arrID[i]))
		{
			if((arrAgeLimit[i] == 15))
			{
				intAge = 0;
			}
			else if((arrAgeLimit[i] == 18))
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

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case 5690:
			if((IsShowWindow() == false))
			{
				ShowWindow();
			}
			sendServerListStart();
			break;
		case 5691:
			handleServerList(a_Param);
			break;
		case 5692:
			sendServerListEnd();
			break;
		default:
			break;
	}
	return;
}

function handleServerList(string a_Param)
{
	local int Id, AgeLimit, IsWorldRaidServer;

	ParseInt(a_Param, "IsWorldRaidServer", IsWorldRaidServer);
	if((IsWorldRaidServer == 1))
	{
		return;
	}
	ParseInt(a_Param, "ID", Id);
	arrID.Length = (arrID.Length + 1);
	arrID[(arrID.Length - 1)] = Id;
	ParseInt(a_Param, "AgeLimit", AgeLimit);
	arrAgeLimit.Length = (arrAgeLimit.Length + 1);
	arrAgeLimit[(arrAgeLimit.Length - 1)] = AgeLimit;
	CallGFxFunction("LoginServerSelect", "sendServerList", a_Param);
	return;
}

function sendServerListStart()
{
	local string param;

	param = makeVar2Str("IsChinaClient", string(IsChinaClient()));
	param = (param @ makeVar2Str("PkString", GetChinaPkString()));
	CallGFxFunction("LoginServerSelect", "sendServerListStart", param);
	return;
}

function string makeVar2Str(string varName, string vars)
{
	return ((varName $ "=") $ vars);
}

function sendServerListEnd()
{
	CallGFxFunction("LoginServerSelect", "sendServerListEnd", "");
	return;
}
