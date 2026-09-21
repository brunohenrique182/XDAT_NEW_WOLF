class BOTsystemWnd extends UICommonAPI;

const TIMER_ID = 1234;
const TIMER_DELAY = 5000;
const TIMER_ID2 = 12345;
const TIMER_DELAY2 = 1000;
const DIALOG_ID = 1234;
const INPUT_MAX = 6;

var ButtonHandle Help_Button;
var ButtonHandle btnOk;
var ButtonHandle Refresh_Button;
var ButtonHandle btnKey1;
var ButtonHandle btnKey2;
var ButtonHandle btnKey3;
var ButtonHandle btnKey4;
var ButtonHandle btnKey5;
var ButtonHandle btnKey6;
var ButtonHandle btnKey7;
var ButtonHandle btnKey8;
var ButtonHandle btnKey9;
var ButtonHandle btnKey0;
var ButtonHandle btnKeyClear;
var ButtonHandle btnKeyBack;
var TextBoxHandle Notice_textBox;
var TextBoxHandle InputTime_textBox;
var TextBoxHandle InputCaptcha_textBox;
var TextureHandle CaptchaImg_texture;
var WindowHandle Me;
var INT64 TransactionID;
var int TryCount;
var int RemainTime;
var array<int> keyArray;
var L2Util util;

function Initialize()
{
	Me = GetWindowHandle("BOTsystemWnd");
	Notice_textBox = GetTextBoxHandle("BOTsystemWnd.Notice_textBox");
	Help_Button = GetButtonHandle("BOTsystemWnd.Help_Button");
	btnOk = GetButtonHandle("BOTsystemWnd.btnOk");
	Refresh_Button = GetButtonHandle("BOTsystemWnd.Refresh_Button");
	btnKey1 = GetButtonHandle("BOTsystemWnd.btnKey1");
	btnKey2 = GetButtonHandle("BOTsystemWnd.btnKey2");
	btnKey3 = GetButtonHandle("BOTsystemWnd.btnKey3");
	btnKey4 = GetButtonHandle("BOTsystemWnd.btnKey4");
	btnKey5 = GetButtonHandle("BOTsystemWnd.btnKey5");
	btnKey6 = GetButtonHandle("BOTsystemWnd.btnKey6");
	btnKey7 = GetButtonHandle("BOTsystemWnd.btnKey7");
	btnKey8 = GetButtonHandle("BOTsystemWnd.btnKey8");
	btnKey9 = GetButtonHandle("BOTsystemWnd.btnKey9");
	btnKey0 = GetButtonHandle("BOTsystemWnd.btnKey0");
	btnKeyClear = GetButtonHandle("BOTsystemWnd.btnKeyClear");
	btnKeyBack = GetButtonHandle("BOTsystemWnd.btnKeyBack");
	CaptchaImg_texture = GetTextureHandle("BOTsystemWnd.CaptchaImg_texture");
	InputCaptcha_textBox = GetTextBoxHandle("BOTsystemWnd.InputCaptcha_textBox");
	InputTime_textBox = GetTextBoxHandle("BOTsystemWnd.InputTime_textBox");
	return;
}

function OnShow()
{
	makeRandomPasswordButton();
	InputCaptcha_textBox.SetText("");
	btnOk.SetEnable(false);
	setDefaultPosistionOnShow();
	return;
}

function setDefaultPosistionOnShow()
{
	local int currentScreenWidth, currentScreenHeight;
	local Rect rectWnd;

	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	rectWnd = Me.GetRect();
	Me.MoveTo(10, ((currentScreenHeight - 341) - rectWnd.nHeight));
	return;
}

function OnLoad()
{
	Initialize();
	util = L2Util(GetScript("L2Util"));
	Notice_textBox.SetText(GetSystemMessage(6803));
	return;
}

function makeRandomPasswordButton()
{
	local int i;

	i = 0;
	while((i < 10))
	{
		keyArray[i] = i;
		i++;
	}
	util.arrayShuffleInt(keyArray);
	i = 0;
	while((i < 10))
	{
		GetButtonHandle(("BOTsystemWnd.btnKey" $ string(i))).SetTexture(("L2UI_CT1.Button.Botsystem_DF_Key" $ string(keyArray[i])), ("L2UI_CT1.Button.Botsystem_DF_Key" $ string(keyArray[i])), (("L2UI_CT1.Button.Botsystem_DF_Key" $ string(keyArray[i])) $ "_over"));
		i++;
	}
	return;
}

function OnHide()
{
	Me.KillTimer(12345);
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Refresh_Button":
			handleRefreshCaptchImage();
			break;
		case "Help_Button":
			helpClick();
			break;
		case "btnOk":
			tryPasswordCheck();
			break;
		case "btnKey1":
		case "btnKey2":
		case "btnKey3":
		case "btnKey4":
		case "btnKey5":
		case "btnKey6":
		case "btnKey7":
		case "btnKey8":
		case "btnKey9":
		case "btnKey0":
		case "btnKeyClear":
		case "btnKeyBack":
			passwordKeyBoardClick(Name);
			break;
		default:
			break;
	}
	return;
}

function tryPasswordCheck()
{
	RequestCaptchaAnswer(TransactionID, int(InputCaptcha_textBox.GetText()));
	InputCaptcha_textBox.SetText("");
	btnOk.SetEnable(false);
	return;
}

function helpClick()
{
	local string strParam;

	ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "antibot_help001.htm"));
	ExecuteEvent(1210, strParam);
	return;
}

function handleRefreshCaptchImage()
{
	RequestRefreshCaptchaImage(TransactionID);
	Me.SetTimer(1234, 5000);
	Refresh_Button.SetEnable(false);
	InputCaptcha_textBox.SetText("");
	btnOk.SetEnable(false);
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 1234:
			Refresh_Button.SetEnable(true);
			break;
		case 12345:
			refreshTime();
			break;
		default:
			break;
	}
	return;
}

function refreshTime()
{
	InputTime_textBox.SetText(((i2s((RemainTime / 60)) @ ":") @ i2s(int((float(RemainTime) % 60.0000000)))));
	if((RemainTime == 0))
	{
		Me.KillTimer(12345);
	}
	RemainTime--;
	return;
}

function string i2s(int Num)
{
	if((Num < 10))
	{
		return ("0" $ string(Num));
	}
	else
	{
		return string(Num);
	}
}

function passwordKeyBoardClick(string Name)
{
	local string inputNumChar, tempStr;

	if((Name == "btnKeyClear"))
	{
		InputCaptcha_textBox.SetText("");
	}
	else if((Name == "btnKeyBack"))
	{
		tempStr = InputCaptcha_textBox.GetText();
		if((Len(tempStr) > 0))
		{
			InputCaptcha_textBox.SetText(Left(tempStr, (Len(tempStr) - 1)));
		}
	}
	else
	{
		tempStr = InputCaptcha_textBox.GetText();
		if((Len(tempStr) < 6))
		{
			inputNumChar = Right(Name, 1);
			InputCaptcha_textBox.SetText((tempStr $ string(keyArray[int(inputNumChar)])));
		}
	}
	btnOk.SetEnable((Len(InputCaptcha_textBox.GetText()) >= 6));
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(10090);
	RegisterEvent(10091);
	RegisterEvent(161);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 10090:
			handleCapchaInfo(param);
			break;
		case 10091:
			Me.SetUnConditionalShow(false);
			Me.HideWindow();
			break;
		case 161:
			Me.SetUnConditionalShow(false);
			break;
		default:
			break;
	}
	return;
}

function handleCapchaInfo(string param)
{
	Me.SetUnConditionalShow(true);
	Me.ShowWindow();
	Me.SetFocus();
	ParseINT64(param, "TransactionID", TransactionID);
	ParseInt(param, "TryCount", TryCount);
	ParseInt(param, "RemainTime", RemainTime);
	Me.KillTimer(12345);
	Me.SetTimer(12345, 1000);
	CaptchaImg_texture.SetTextureWithObject(GetCaptchaImageTex());
	return;
}
