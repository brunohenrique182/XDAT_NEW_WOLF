class PayBackEventWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle PayBackEvent_Btn;
var int Activate;

function OnLoad()
{
	Initialize();
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(11144);
	RegisterEvent(150);
	return;
}

function Initialize()
{
	Me = GetWindowHandle("PayBackEventWnd");
	PayBackEvent_Btn = GetButtonHandle("PayBackEventWnd.PayBackEvent_Btn");
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 11144:
			openUI(param);
			break;
		case 150:
			if((Activate == 1))
			{
				Me.ShowWindow();
			}
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "PayBackEvent_Btn":
			OpenPayBackWnd();
			break;
		default:
			break;
	}
	return;
}

function openUI(string param)
{
	ParseInt(param, "Activate", Activate);
	if((Activate == 1))
	{
		Me.ShowWindow();
	}
	return;
}

function OpenPayBackWnd()
{
	RequestPaybackList(1);
	return;
}
