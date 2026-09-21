class PledgeCreateWnd extends UICommonAPI;

var WindowHandle Me;
var EditBoxHandle PledgeNameInput_Edit;
var ButtonHandle PledgeCreateBtn_Button;

function OnRegisterEvent()
{
	RegisterEvent(10800);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("PledgeCreateWnd");
	PledgeNameInput_Edit = GetEditBoxHandle("PledgeCreateWnd.PledgeNameInput_Edit");
	PledgeCreateBtn_Button = GetButtonHandle("PledgeCreateWnd.PledgeCreateBtn_Button");
	GetTextBoxHandle("PledgeCreateWnd.CreateConditionTitle_text").SetText(((((GetSystemString(3763) $ " : ") $ GetSystemString(2381)) $ " 10 ") $ GetSystemString(3692)));
	return;
}

function OnShow()
{
	PledgeNameInput_Edit.SetString("");
	PledgeNameInput_Edit.SetFocus();
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 10800))
	{
		Me.ShowWindow();
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "PledgeCreateBtn_Button":
			OnPledgeCreateBtn_ButtonClick();
			break;
		case "WndBTNHelp_Button":
			ExecuteEvent(1210, "147");
			break;
		default:
			break;
	}
	return;
}

function OnPledgeCreateBtn_ButtonClick()
{
	local string ClanName;

	ClanName = PledgeNameInput_Edit.GetString();
	if((ClanName != ""))
	{
		RequestCreatePledge(ClanName);
		Me.HideWindow();
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
