class FortressBattleInfoWnd extends UICommonAPI;

const TELEPORT_ID = 432;

var string m_Windowname;
var WindowHandle Me;
var WindowHandle FortressBattleInfoPopupWnd;
var TextBoxHandle Txt_TeleportInfo;

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	FortressBattleInfoPopupWnd = GetWindowHandle((m_Windowname $ ".FortressBattleInfoPopupWnd"));
	Txt_TeleportInfo = GetTextBoxHandle((m_Windowname $ ".FortressBattleInfoPopupWnd.DescriptionTextBox"));
	return;
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

function OnShow()
{
	FortressBattleInfoPopupWnd.HideWindow();
	return;
}

function OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "OkButton":
			FortressBattleInfoPopupWnd.HideWindow();
			Class'NWindow.TeleportListAPI'.static.RequestTeleport(432);
			Me.HideWindow();
			break;
		case "CancleButton":
			FortressBattleInfoPopupWnd.HideWindow();
			break;
		case "Teleport_Btn":
			FortressBattleInfoPopupWnd.ShowWindow();
			SetTeleportInfo();
			break;
		default:
			break;
	}
	return;
}

function SetTeleportInfo()
{
	Txt_TeleportInfo.SetText(MakeFullSystemMsg(GetSystemMessage(13166), MakeCostStringINT64(getInstanceUIData().GetTeleportPriceByID(432))));
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if(FortressBattleInfoPopupWnd.IsShowWindow())
	{
		FortressBattleInfoPopupWnd.HideWindow();
	}
	else
	{
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
	return;
}

defaultproperties
{
	m_Windowname="FortressBattleInfoWnd"
}
