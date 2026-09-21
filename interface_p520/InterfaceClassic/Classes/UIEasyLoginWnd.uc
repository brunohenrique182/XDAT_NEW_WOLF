class UIEasyLoginWnd extends UICommonAPI;

const TIMER_ID_CHANGETEXT = 10234599;
const TIMER_ID = 10234510;

var WindowHandle Me;
var ListCtrlHandle IDList;
var ButtonHandle loginButton;
var ButtonHandle addButton;
var ButtonHandle delButton;
var ButtonHandle managerButton;
var TextBoxHandle descTxt;
var EditBoxHandle idEditBox;
var EditBoxHandle pwEditBox;
var EditBoxHandle serverEditBox;
var EditBoxHandle charEditBox;
var string lastKeyValue;
var bool isEditMode;

function OnRegisterEvent()
{
	RegisterEvent(5630);
	return;
}

function OnLoad()
{
	RegisterState("LogIn", "LoginState");
	SetClosingOnESC();
	Initialize();
	return;
}

function OnShow()
{
	local UIEventManager.ELanguageType Language;

	Me.KillTimer(10234599);
	Me.SetTimer(10234599, 4000);
	Me.KillTimer(10234510);
	Me.SetTimer(10234510, 100);
	Language = GetLanguage();
	if((int(Language) == 0))
	{
		descTxt.SetText("편한 로그인 툴!");  // EN: handy login tool!
	}
	Me.SetFocus();
	return;
}

function AddList(string Id, string pW, string Server, string character)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 3;
	Record.LVDataList[0].szData = Id;
	Record.LVDataList[0].szReserved = pW;
	Record.LVDataList[1].szData = Server;
	Record.LVDataList[2].szData = character;
	IDList.InsertRecord(Record);
	return;
}

function GetSelectedRecord()
{
	local LVDataRecord Record;

	IDList.GetSelectedRec(Record);
	idEditBox.SetString(Record.LVDataList[0].szData);
	pwEditBox.SetString(Record.LVDataList[0].szReserved);
	serverEditBox.SetString(Record.LVDataList[1].szData);
	charEditBox.SetString(Record.LVDataList[2].szData);
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 5630))
	{
		switch(GetReleaseMode())
		{
			case RM_DEV:
				if((Me.IsShowWindow() == false))
				{
					checkAndShowEasyLogin();
				}
			default:
				break;
		}
	}
	return;
}

function Initialize()
{
	Me = GetWindowHandle("UIEasyLoginWnd");
	IDList = GetListCtrlHandle("UIEasyLoginWnd.idList");
	loginButton = GetButtonHandle("UIEasyLoginWnd.loginButton");
	addButton = GetButtonHandle("UIEasyLoginWnd.addButton");
	delButton = GetButtonHandle("UIEasyLoginWnd.delButton");
	managerButton = GetButtonHandle("UIEasyLoginWnd.managerButton");
	descTxt = GetTextBoxHandle("UIEasyLoginWnd.descTxt");
	idEditBox = GetEditBoxHandle("UIEasyLoginWnd.idEditBox");
	pwEditBox = GetEditBoxHandle("UIEasyLoginWnd.pwEditBox");
	serverEditBox = GetEditBoxHandle("UIEasyLoginWnd.serverEditBox");
	charEditBox = GetEditBoxHandle("UIEasyLoginWnd.charEditBox");
	setWindowTitleByString("UITools - EasyLogin");
	return;
}

function OnHide()
{
	Me.KillTimer(10234599);
	Me.KillTimer(10234510);
	return;
}

function OnTimer(int TimerID)
{
	local UIEventManager.ELanguageType Language;

	if((TimerID == 10234599))
	{
		Language = GetLanguage();
		if((int(Language) == 0))
		{
			switch(Rand(8))
			{
				case 1:
					descTxt.SetText("- 리지니2 System폴더에 UIDEV.ini 파일에서, [EASYLOGIN] 항목을 직접 편집하여도 된니다.");  // EN: - you can also edit the [EASYLOGIN] section directly in UIDEV.ini in the Lineage 2 System folder.
					break;
				case 2:
					descTxt.SetText("- 버그나 요청이 있으면 dongland@ncsoft.com 으로 메일주세요.");  // EN: - for bugs or requests, mail dongland@ncsoft.com.
					break;
				case 3:
					descTxt.SetText("- dongland에게 Donation 하셔도 됩니다. -_-");  // EN: - you may send a donation to dongland. -_-
					break;
				case 4:
					descTxt.SetText("- (-_-)/~~~~이 글은 한글 버전에서만 보입니다~ ");  // EN: - (-_-)/~~~~this text is only visible in the Korean version~
					break;
				case 5:
					descTxt.SetText("- 로그인과 암호를 매번 넣기 힘들어서 만든 로그인 툴입니다.");  // EN: - a login tool, made because typing the login and password every time is tedious.
					break;
				case 6:
					descTxt.SetText("- 최대 50개의 아이디 암호를 저장 할 수 있습니다.");  // EN: - up to 50 id/password pairs can be stored.
					break;
				case 7:
					descTxt.SetText("- Server와 Char(캐릭터 선택)는 숫자로 입력 해야 됩니다.");  // EN: - Server and Char (character select) must be entered as numbers.
					break;
				default:
					descTxt.SetText("- 추가 기능이 꼭 필요하면 알려주세요. ");  // EN: - if you really need another feature, let me know.
					break;
			}
		}
	}
	else if((TimerID == 10234510))
	{
		if((IsKeyDown(IK_Home) || IsKeyDown(IK_RightMouse)))
		{
			OnLoginButtonClickHandler();
		}
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "loginButton":
			OnLoginButtonClickHandler();
			break;
		case "addButton":
			OnAddButtonClickHandler();
			break;
		case "delButton":
			OnDelButtonClickHandler();
			break;
		case "managerButton":
			OnManagerButtonClickHandler();
			break;
		case "gmToolBtn":
			ShowWindowWithFocus("GMWnd");
			break;
		case "uiEditBtn":
			ExecuteCommand("///ui");
			break;
		default:
			break;
	}
	return;
}

function OnAddButtonClickHandler()
{
	local int nMax;

	if(((idEditBox.GetString() != "") && (pwEditBox.GetString() != "")))
	{
		nMax = IDList.GetRecordCount();
		SetINIString("EASYLOGIN", ("id" $ string((nMax + 1))), idEditBox.GetString(), "UIDEV.ini");
		SetINIString("EASYLOGIN", ("pw" $ string((nMax + 1))), pwEditBox.GetString(), "UIDEV.ini");
		SetINIString("EASYLOGIN", ("server" $ string((nMax + 1))), serverEditBox.GetString(), "UIDEV.ini");
		SetINIString("EASYLOGIN", ("char" $ string((nMax + 1))), charEditBox.GetString(), "UIDEV.ini");
		AddList(idEditBox.GetString(), pwEditBox.GetString(), serverEditBox.GetString(), charEditBox.GetString());
	}
	return;
}

function OnDelButtonClickHandler()
{
	local int idx;
	local string Id, pW, Server, character;
	local int i;
	local string oldid;
	local LVDataRecord Record;

	idx = IDList.GetSelectedIndex();
	if((idx > -1))
	{
		IDList.DeleteRecord(idx);
		SetINIString("EASYLOGIN", ("id" $ string((idx + 1))), "", "UIDEV.ini");
		SetINIString("EASYLOGIN", ("pw" $ string((idx + 1))), "", "UIDEV.ini");
		SetINIString("EASYLOGIN", ("server" $ string((idx + 1))), "", "UIDEV.ini");
		SetINIString("EASYLOGIN", ("char" $ string((idx + 1))), "", "UIDEV.ini");
		i = 1;
		while((i < 51))
		{
			if((IDList.GetRecordCount() >= i))
			{
				IDList.GetRec((i - 1), Record);
				Id = Record.LVDataList[0].szData;
				pW = Record.LVDataList[0].szReserved;
				Server = Record.LVDataList[1].szData;
				character = Record.LVDataList[2].szData;
			}
			else
			{
				Id = "";
				pW = "";
				Server = "";
				character = "";
			}
			if((Id == ""))
			{
				GetINIString("EASYLOGIN", ("id" $ string(i)), oldid, "UIDEV.ini");
			}
			if(((Id != "") || (oldid != "")))
			{
				SetINIString("EASYLOGIN", ("id" $ string(i)), Id, "UIDEV.ini");
				SetINIString("EASYLOGIN", ("pw" $ string(i)), pW, "UIDEV.ini");
				SetINIString("EASYLOGIN", ("server" $ string(i)), Server, "UIDEV.ini");
				SetINIString("EASYLOGIN", ("char" $ string(i)), character, "UIDEV.ini");
			}
			i++;
		}
	}
	return;
}

function OnManagerButtonClickHandler(optional bool bUseBasicUI)
{
	local int W, h;

	Me.GetWindowSize(W, h);
	if(((W > 400) || bUseBasicUI))
	{
		Me.SetWindowSize(240, 375);
		descTxt.HideWindow();
		addButton.HideWindow();
		delButton.HideWindow();
		idEditBox.HideWindow();
		pwEditBox.HideWindow();
		serverEditBox.HideWindow();
		charEditBox.HideWindow();
		GetTextBoxHandle("UIEasyLoginWnd.addTxt").HideWindow();
		GetTextBoxHandle("UIEasyLoginWnd.idTxt").HideWindow();
		GetTextBoxHandle("UIEasyLoginWnd.pwTxt").HideWindow();
		GetTextBoxHandle("UIEasyLoginWnd.serverTxt").HideWindow();
		GetTextBoxHandle("UIEasyLoginWnd.charTxt").HideWindow();
		GetTextBoxHandle("UIEasyLoginWnd.delTxt").HideWindow();
		GetTextBoxHandle("UIEasyLoginWnd.descTxt").HideWindow();
		GetTextureHandle("UIEasyLoginWnd.ListBG1").HideWindow();
		isEditMode = false;
	}
	else
	{
		Me.SetWindowSize(580, 375);
		descTxt.ShowWindow();
		addButton.ShowWindow();
		delButton.ShowWindow();
		idEditBox.ShowWindow();
		pwEditBox.ShowWindow();
		serverEditBox.ShowWindow();
		charEditBox.ShowWindow();
		GetTextBoxHandle("UIEasyLoginWnd.addTxt").ShowWindow();
		GetTextBoxHandle("UIEasyLoginWnd.idTxt").ShowWindow();
		GetTextBoxHandle("UIEasyLoginWnd.pwTxt").ShowWindow();
		GetTextBoxHandle("UIEasyLoginWnd.serverTxt").ShowWindow();
		GetTextBoxHandle("UIEasyLoginWnd.charTxt").ShowWindow();
		GetTextBoxHandle("UIEasyLoginWnd.delTxt").ShowWindow();
		GetTextBoxHandle("UIEasyLoginWnd.descTxt").ShowWindow();
		GetTextureHandle("UIEasyLoginWnd.ListBG1").ShowWindow();
		isEditMode = true;
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "idList":
			if(isEditMode)
			{
				GetSelectedRecord();
			}
			else
			{
				OnLoginButtonClickHandler();
			}
			break;
		default:
			break;
	}
	return;
}

function setUseEasyLogin(bool flag)
{
	SetINIString("EASYLOGIN", "use", string(boolToNum(flag)), "UIDEV.ini");
	return;
}

function bool getUseEasyLogin()
{
	local string stringValue;

	GetINIString("EASYLOGIN", "use", stringValue, "UIDEV.ini");
	return numToBool(int(stringValue));
}

function OnLoginButtonClickHandler()
{
	local LVDataRecord Record;
	local int serverNum, characterNum;

	IDList.GetSelectedRec(Record);
	if((Record.LVDataList[0].szData != ""))
	{
		Login(GetScript("LogIn")).OnCallUCFunction("setLogin", (((("ID=" $ Record.LVDataList[0].szData) $ " ") $ "pass=") $ Record.LVDataList[0].szReserved));
		SetINIString("EASYLOGIN", "lastLoginIndex", string(IDList.GetSelectedIndex()), "UIDEV.ini");
		if((Record.LVDataList[1].szData != ""))
		{
			serverNum = int(Record.LVDataList[1].szData);
			if((Record.LVDataList[2].szData != ""))
			{
				characterNum = int(Record.LVDataList[2].szData);
			}
			else
			{
				characterNum = -1;
			}
			AutoLogin(serverNum, characterNum);
		}
	}
	return;
}

function checkAndShowEasyLogin()
{
	local string stringValue;

	GetINIString("EASYLOGIN", "use", stringValue, "UIDEV.ini");
	if((int(stringValue) > 0))
	{
		OnManagerButtonClickHandler(true);
		Me.ShowWindow();
		loadListByINI();
	}
	return;
}

function loadListByINI()
{
	local string Id, pW, Server, character, listIndex;
	local int i;

	IDList.DeleteAllItem();
	i = 1;
	while((i < 51))
	{
		Id = "";
		pW = "";
		Server = "";
		character = "";
		GetINIString("EASYLOGIN", ("id" $ string(i)), Id, "UIDEV.ini");
		GetINIString("EASYLOGIN", ("pw" $ string(i)), pW, "UIDEV.ini");
		GetINIString("EASYLOGIN", ("server" $ string(i)), Server, "UIDEV.ini");
		GetINIString("EASYLOGIN", ("char" $ string(i)), character, "UIDEV.ini");
		if((Id != ""))
		{
			AddList(Id, pW, Server, character);
		}
		i++;
	}
	GetINIString("EASYLOGIN", "lastLoginIndex", listIndex, "UIDEV.ini");
	IDList.SetSelectedIndex(int(listIndex), true);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
