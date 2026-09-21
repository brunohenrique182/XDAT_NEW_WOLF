class NewUserPetitionWnd extends UICommonAPI;

const MAX_PetitionCategory = 100;

var ComboBoxHandle m_hFirstCategory;
var ComboBoxHandle m_hSecondCategory;
var HtmlHandle m_hDescriptionViewer;
var HtmlHandle m_hHtmlViewer;
var HtmlHandle m_hContentsViewer;
var WindowHandle Drawer;
var WindowHandle Me;
var int selectedCategoryId;
var string StartHtml;
var string EndHtml;

function OnRegisterEvent()
{
	RegisterEvent(4800);
	RegisterEvent(4810);
	RegisterEvent(4820);
	RegisterEvent(4830);
	RegisterEvent(4850);
	RegisterEvent(4840);
	return;
}

function OnLoad()
{
	selectedCategoryId = 0;
	OnRegisterEvent();
	Me = GetWindowHandle("NewUserPetitionWnd");
	Drawer = GetWindowHandle("NewUserPetitionDrawerWnd");
	m_hFirstCategory = GetComboBoxHandle("NewUserPetitionWnd.PetitionTypeComboBox_1st");
	m_hSecondCategory = GetComboBoxHandle("NewUserPetitionWnd.PetitionTypeComboBox_2nd");
	m_hDescriptionViewer = GetHtmlHandle("NewUserPetitionWnd.HelpDialogHtmlCtrl");
	m_hHtmlViewer = GetHtmlHandle("NewUserPetitionWnd.HelpHtmlCtrl");
	m_hContentsViewer = GetHtmlHandle("NewUserPetitionDrawerWnd.ContentsTextBox");
	m_hSecondCategory.DisableWindow();
	StartHtml = "<HTML><HEAD><BODY>";
	EndHtml = "</BODY></HTML>";
	return;
}

function OnHide()
{
	Clear();
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 4800:
			HandleShowNewUserPetitionWnd();
			break;
		case 4810:
			HandleAddNewCategoryStepOne(a_Param);
			break;
		case 4820:
			HandleShowDescription(a_Param);
			break;
		case 4830:
			HandleAddNewCategoryStepTwo(a_Param);
			break;
		case 4850:
			HandleLoadPetitionHtml(a_Param);
			break;
		case 4840:
			HandleShowNewUserPetitionContents(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandleShowNewUserPetitionWnd()
{
	Clear();
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	m_hHtmlViewer.LoadHtml((GetLocalizedL2TextPathNameUC() $ "newpet_help_main.htm"));
	return;
}

function HandleAddNewCategoryStepOne(string a_Param)
{
	local int categoryId;
	local string categoryName;

	ParseInt(a_Param, "CategoryId_", categoryId);
	ParseString(a_Param, "CategoryName_", categoryName);
	m_hFirstCategory.AddStringWithReserved(categoryName, categoryId);
	return;
}

function HandleAddNewCategoryStepTwo(string a_Param)
{
	local int categoryId;
	local string categoryName;

	ParseInt(a_Param, "CategoryId_", categoryId);
	ParseString(a_Param, "CategoryName_", categoryName);
	m_hSecondCategory.AddStringWithReserved(categoryName, categoryId);
	return;
}

function HandleShowDescription(string a_Param)
{
	local int Num;
	local string categoryDescription;

	ParseInt(a_Param, "Count", Num);
	if((Num > 0))
	{
		m_hSecondCategory.EnableWindow();
		DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemMessage(2992));
		selectedCategoryId = 0;
	}
	ParseString(a_Param, "CategoryDescription", categoryDescription);
	m_hDescriptionViewer.LoadHtmlFromString(((StartHtml $ categoryDescription) $ EndHtml));
	return;
}

function HandleLoadPetitionHtml(string a_Param)
{
	local string HtmlString;

	ParseString(a_Param, "HtmlString", HtmlString);
	if((Len(HtmlString) > 0))
	{
		m_hHtmlViewer.Clear();
		m_hHtmlViewer.LoadHtmlFromString(HtmlString);
	}
	return;
}

function HandleShowNewUserPetitionContents(string a_Param)
{
	local string ContentsString;

	m_hContentsViewer.Clear();
	ParseString(a_Param, "Contents", ContentsString);
	m_hContentsViewer.LoadHtmlFromString(((StartHtml $ ContentsString) $ EndHtml));
	Drawer.ShowWindow();
	return;
}

function OnComboBoxItemSelected(string a_ControlID, int a_SelectedIndex)
{
	local int passingCategoryId;

	if((a_ControlID == "PetitionTypeComboBox_1st"))
	{
		Drawer.HideWindow();
		m_hSecondCategory.DisableWindow();
		if((a_SelectedIndex >= 1))
		{
			m_hSecondCategory.Clear();
			m_hSecondCategory.AddStringWithReserved(GetSystemString(2024), 100);
			Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("NewUserPetitionWnd.PetitionTypeComboBox_2nd", 0);
			m_hDescriptionViewer.Clear();
			m_hHtmlViewer.Clear();
			passingCategoryId = m_hFirstCategory.GetReserved(a_SelectedIndex);
			selectedCategoryId = m_hFirstCategory.GetReserved(a_SelectedIndex);
			RequestShowStepTwo(passingCategoryId);
		}
		else
		{
			selectedCategoryId = 0;
			m_hSecondCategory.Clear();
			m_hSecondCategory.AddStringWithReserved(GetSystemString(2024), 100);
			Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("NewUserPetitionWnd.PetitionTypeComboBox_2nd", 0);
			m_hDescriptionViewer.Clear();
			m_hHtmlViewer.Clear();
			m_hHtmlViewer.LoadHtml((GetLocalizedL2TextPathNameUC() $ "newpet_help_main.htm"));
		}
	}
	else if((a_ControlID == "PetitionTypeComboBox_2nd"))
	{
		Drawer.HideWindow();
		if((a_SelectedIndex >= 1))
		{
			m_hHtmlViewer.Clear();
			passingCategoryId = m_hSecondCategory.GetReserved(a_SelectedIndex);
			selectedCategoryId = m_hSecondCategory.GetReserved(a_SelectedIndex);
			RequestShowStepThree(passingCategoryId);
		}
		else
		{
			selectedCategoryId = 0;
			m_hHtmlViewer.Clear();
			m_hHtmlViewer.LoadHtml((GetLocalizedL2TextPathNameUC() $ "newpet_help_main.htm"));
		}
	}
	return;
}

function OnClickButton(string a_ControlID)
{
	switch(a_ControlID)
	{
		case "OKButton":
			OnClickOKButton();
			break;
		case "CancelButton":
			OnClickCancelButton();
			break;
		case "DrawerCloseButton":
			if(Drawer.IsShowWindow())
			{
				m_hContentsViewer.Clear();
				Drawer.HideWindow();
			}
			break;
		default:
			break;
	}
	return;
}

function OnClickOKButton()
{
	local WindowHandle NewPetitionWndHandle;
	local NewPetitionWnd NewPetitionWndScript;

	if(!Drawer.IsShowWindow())
	{
		DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(804));
	}
	else
	{
		NewPetitionWndHandle = GetWindowHandle("NewPetitionWnd");
		NewPetitionWndScript = NewPetitionWnd(GetScript("NewPetitionWnd"));
		NewPetitionWndScript.SetCategoryId(selectedCategoryId);
		NewPetitionWndHandle.ShowWindow();
		Clear();
		Me.HideWindow();
	}
	return;
}

function OnClickCancelButton()
{
	Clear();
	HideWindow("NewUserPetitionWnd");
	return;
}

function Clear()
{
	m_hFirstCategory.Clear();
	m_hSecondCategory.Clear();
	m_hSecondCategory.DisableWindow();
	m_hFirstCategory.AddStringWithReserved(GetSystemString(2024), 100);
	m_hSecondCategory.AddStringWithReserved(GetSystemString(2024), 100);
	Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("NewUserPetitionWnd.PetitionTypeComboBox_1st", 0);
	Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("NewUserPetitionWnd.PetitionTypeComboBox_2nd", 0);
	m_hDescriptionViewer.Clear();
	m_hContentsViewer.Clear();
	m_hHtmlViewer.Clear();
	Drawer.HideWindow();
	selectedCategoryId = 0;
	return;
}
