class BlockCurTriggerWnd extends UIScript;

var WindowHandle Me;
var ButtonHandle BlockCurTriggerBtn;
var WindowHandle BlockCurWnd;

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
	if((1 == 0))
	{
		Initialize();
	}
	else
	{
		InitializeCOD();
	}
	Me.HideWindow();
	return;
}

function Initialize()
{
	Me = GetHandle("BlockCurTriggerWnd");
	BlockCurTriggerBtn = ButtonHandle(GetHandle("BlockCurTriggerBtn"));
	BlockCurWnd = GetHandle("BlockCurWnd");
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("BlockCurTriggerWnd");
	BlockCurTriggerBtn = GetButtonHandle("BlockCurTriggerWnd.BlockTriggerBtn");
	BlockCurWnd = GetWindowHandle("BlockCurWnd");
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 3890:
			Me.ShowWindow();
			break;
		case 3900:
			Me.ShowWindow();
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
		case "BlockCurTriggerBtn":
			BlockCurWnd.ShowWindow();
			break;
		default:
			break;
	}
	return;
}
