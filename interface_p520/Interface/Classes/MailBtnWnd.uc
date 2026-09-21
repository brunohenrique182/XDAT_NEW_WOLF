class MailBtnWnd extends UICommonAPI;

var ButtonHandle btnItemPop;
var int buttonType;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	buttonType = 0;
	Initialize();
	return;
}

function Initialize()
{
	if((1 == 0))
	{
		btnItemPop = ButtonHandle(GetHandle("MailBtnWnd.btnMail"));
	}
	else
	{
		btnItemPop = GetButtonHandle("MailBtnWnd.btnMail");
	}
	btnItemPop.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(3064)));
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int iEffectNumber;

	ParseInt(param, "IdxMail", iEffectNumber);
	switch(Event_ID)
	{
		case 1530:
			ShowWindowWithFocus("MailBtnWnd");
			Class'NWindow.UIAPI_EFFECTBUTTON'.static.BeginEffect("MailBtnWnd.btnMail", iEffectNumber);
			buttonType = 1;
			break;
		case 4700:
			ShowWindowWithFocus("MailBtnWnd");
			Class'NWindow.UIAPI_EFFECTBUTTON'.static.BeginEffect("MailBtnWnd.btnMail", iEffectNumber);
			buttonType = 2;
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnMail":
			HideWindow("MailBtnWnd");
			if((buttonType == 2))
			{
				RequestRequestReceivedPostList();
			}
			break;
		default:
			break;
	}
	return;
}
