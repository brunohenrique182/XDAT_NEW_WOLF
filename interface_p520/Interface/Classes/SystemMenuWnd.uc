class SystemMenuWnd extends UICommonAPI;

const DIALOGID_Gohome = 0;

var string m_Windowname;
var WindowHandle m_hOptionWnd;
var WindowHandle m_hUserPetitionWnd;
var WindowHandle m_hNewUserPetitionWnd;
var WindowHandle m_hMovieCaptureWnd;
var WindowHandle m_hArchiveViewWnd;
var WindowHandle m_hMovieCaptureWnd_Expand;
var WindowHandle PostBoxWnd;
var TextBoxHandle m_hTbBBS;
var TextBoxHandle m_hTbMacro;
var int IsPeaceZone;

function OnRegisterEvent()
{
	RegisterEvent(1900);
	RegisterEvent(110);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	if((1 == 0))
	{
		m_hArchiveViewWnd = GetHandle("ArchiveViewWnd");
		m_hMovieCaptureWnd = GetHandle("MovieCaptureWnd");
		m_hMovieCaptureWnd_Expand = GetHandle("MovieCaptureWnd_Expand");
		m_hOptionWnd = GetHandle("OptionWnd");
		m_hUserPetitionWnd = GetHandle("UserPetitionWnd");
		m_hNewUserPetitionWnd = GetHandle("NewUserPetitionWnd");
		m_hTbBBS = TextBoxHandle(GetHandle("SystemMenuWnd.txtBBS"));
		m_hTbMacro = TextBoxHandle(GetHandle("SystemMenuWnd.txtMacro"));
		PostBoxWnd = GetHandle("PostBoxWnd");
	}
	else
	{
		m_hArchiveViewWnd = GetWindowHandle("ArchiveViewWnd");
		m_hMovieCaptureWnd = GetWindowHandle("MovieCaptureWnd");
		m_hMovieCaptureWnd_Expand = GetWindowHandle("MovieCaptureWnd_Expand");
		m_hOptionWnd = GetWindowHandle("OptionWnd");
		m_hUserPetitionWnd = GetWindowHandle("UserPetitionWnd");
		m_hNewUserPetitionWnd = GetWindowHandle("NewUserPetitionWnd");
		m_hTbBBS = GetTextBoxHandle("SystemMenuWnd.txtBBS");
		m_hTbMacro = GetTextBoxHandle("SystemMenuWnd.txtMacro");
		PostBoxWnd = GetWindowHandle("PostBoxWnd");
	}
	SetMenuString();
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnArchive":
			HandlebtnArchive();
			break;
		case "btnPersonalConnections":
			HandlePersonalConnectionsWnd();
			break;
		case "btnPost":
			HandleShowPostBoxWnd();
			break;
		case "btnBBS":
			HandleShowBoardWnd();
			break;
		case "btnMacro":
			HandleShowMacroListWnd();
			break;
		case "btnMovieCapture":
			HandleShowMovieCaptureWnd();
			break;
		case "btnHelpHtml":
			HandleShowHelpHtmlWnd();
			break;
		case "btnPetition":
			HandleShowPetitionBegin();
			break;
		case "btnOption":
			HandleShowOptionWnd();
			break;
		case "btnHomepage":
			linkHomePage();
			break;
		case "btnRestart":
			ExecuteEvent(3350);
			break;
		case "btnQuit":
			ExecuteEvent(3340);
			break;
		default:
			break;
	}
	return;
}

function HandlebtnArchive()
{
	Debug("HandlebtnArchive button clicked");
	ExecuteEvent(5590);
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int zonetype;

	if((Event_ID == 1900))
	{
		SetMenuString();
	}
	else if((Event_ID == 110))
	{
		ParseInt(param, "ZoneCode", zonetype);
		if((zonetype == 12))
		{
			IsPeaceZone = 1;
		}
		else
		{
			IsPeaceZone = 0;
		}
	}
	else if((Event_ID == 1710))
	{
		HandleDialogOK();
	}
	else if((Event_ID == 1720))
	{
	}
	return;
}

function HandlePersonalConnectionsWnd()
{
	if(GetWindowHandle("PersonalConnectionsWnd").IsShowWindow())
	{
		GetWindowHandle("PersonalConnectionsWnd").HideWindow();
	}
	else
	{
		GetWindowHandle("PersonalConnectionsWnd").ShowWindow();
		GetWindowHandle("PersonalConnectionsWnd").SetFocus();
	}
	return;
}

function linkHomePage()
{
	DialogSetID(0);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(3208));
	return;
}

function HandleDialogOK()
{
	if(!DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case 0:
			OpenL2Home();
			break;
		default:
			break;
	}
	return;
}

function HandleShowPostBoxWnd()
{
	if(PostBoxWnd.IsShowWindow())
	{
		PostBoxWnd.HideWindow();
	}
	else
	{
		RequestRequestReceivedPostList();
		if((IsPeaceZone == 0))
		{
			AddSystemMessage(3066);
		}
	}
	return;
}

function HandleShowBoardWnd()
{
	local string strParam;

	ParamAdd(strParam, "Init", "1");
	ExecuteEvent(1190, strParam);
	return;
}

function HandleShowHelpHtmlWnd()
{
	local AgeWnd script1;
	local string strParam;

	ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "help.htm"));
	ExecuteEvent(1210, strParam);
	script1 = AgeWnd(GetScript("AgeWnd"));
	if((script1.bBlock == false))
	{
		script1.startAge();
	}
	return;
}

function HandleShowMacroListWnd()
{
	ExecuteEvent(1230);
	return;
}

function HandleShowMovieCaptureWnd()
{
	local bool tmpBool;

	tmpBool = IsNowMovieCapturing();
	if(tmpBool)
	{
		m_hMovieCaptureWnd.HideWindow();
		if(m_hMovieCaptureWnd_Expand.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			m_hMovieCaptureWnd_Expand.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			m_hMovieCaptureWnd_Expand.ShowWindow();
			m_hMovieCaptureWnd_Expand.SetFocus();
		}
	}
	else if(m_hMovieCaptureWnd.IsShowWindow())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		m_hMovieCaptureWnd.HideWindow();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		m_hMovieCaptureWnd.ShowWindow();
		m_hMovieCaptureWnd.SetFocus();
	}
	return;
}

function HandleShowPetitionBegin()
{
	local WindowHandle win, win1, win2;
	local UIScript.PetitionMethod useNewPetition;

	win = GetWindowHandle("NewUserPetitionWnd");
	win1 = GetWindowHandle("UserPetitionWnd");
	win2 = GetWindowHandle("WebPetitionWnd");
	useNewPetition = PetitionMethod(GetPetitionMethod());
	if((int(useNewPetition) == 1))
	{
		if(win.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			RequestShowPetitionAsMethod();
		}
	}
	else if((int(useNewPetition) == 0))
	{
		if(win1.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win1.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			win1.ShowWindow();
			win1.SetFocus();
		}
	}
	else if((int(useNewPetition) == 2))
	{
		if(win2.IsShowWindow())
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			win2.HideWindow();
		}
		else
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			RequestShowPetitionAsMethod();
		}
	}
	return;
}

function HandleShowOptionWnd()
{
	if(m_hOptionWnd.IsShowWindow())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		m_hOptionWnd.HideWindow();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		m_hOptionWnd.ShowWindow();
		m_hOptionWnd.SetFocus();
	}
	return;
}

function SetMenuString()
{
	m_hTbBBS.SetText((GetSystemString(387) $ "(Alt+B)"));
	m_hTbMacro.SetText((GetSystemString(711) $ "(Alt+R)"));
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="SystemMenuWnd"
}
