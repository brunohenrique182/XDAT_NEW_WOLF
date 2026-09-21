class UserPetitionWnd extends UICommonAPI;

const MAX_PetitionCategory = 32;

var int PetitionCategoryCount;
var int PetitionCategoryTitle[32];
var string PetitionCategoryLink[32];
var HtmlHandle m_hUserPetitionWndHelpHtmlCtrl;

function OnRegisterEvent()
{
	RegisterEvent(1921);
	RegisterEvent(1221);
	return;
}

function OnLoad()
{
	local int i;

	if((1 == 0))
	{
		OnRegisterEvent();
	}
	m_hUserPetitionWndHelpHtmlCtrl = GetHtmlHandle("UserPetitionWnd.HelpHtmlCtrl");
	i = 0;
	while((i < PetitionCategoryCount))
	{
		Class'NWindow.UIAPI_COMBOBOX'.static.SYS_AddString("UserPetitionWnd.PetitionTypeComboBox", PetitionCategoryTitle[i]);
		++i;
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 1921:
			HandleShowUserPetitionWnd(a_Param);
			break;
		case 1221:
			HandleLoadPetitionHtml(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandleShowUserPetitionWnd(string a_Param)
{
	local string Message;

	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	if(ParseString(a_Param, "Message", Message))
	{
		Class'NWindow.UIAPI_MULTIEDITBOX'.static.SetString("UserPetitionWnd.PetitionMultiEdit", Message);
	}
	return;
}

function HandleLoadPetitionHtml(string a_Param)
{
	local string HtmlString;

	ParseString(a_Param, "HtmlString", HtmlString);
	if((Len(HtmlString) > 0))
	{
		m_hUserPetitionWndHelpHtmlCtrl.LoadHtmlFromString(HtmlString);
	}
	return;
}

function OnComboBoxItemSelected(string a_ControlID, int a_SelectedIndex)
{
	if((a_ControlID == "PetitionTypeComboBox"))
	{
		if((a_SelectedIndex >= 1))
		{
			m_hUserPetitionWndHelpHtmlCtrl.LoadHtml((GetLocalizedL2TextPathNameUC() $ PetitionCategoryLink[(a_SelectedIndex - 1)]));
		}
		else
		{
			m_hUserPetitionWndHelpHtmlCtrl.Clear();
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
		default:
			break;
	}
	return;
}

function OnClickOKButton()
{
	local string PetitionMessage;
	local int PetitionMessageLen, PetitionType;
	local string param;
	local PetitionWnd PetitionWndScript;

	PetitionType = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("UserPetitionWnd.PetitionTypeComboBox");
	PetitionMessage = Class'NWindow.UIAPI_MULTIEDITBOX'.static.GetString("UserPetitionWnd.PetitionMultiEdit");
	PetitionMessageLen = Len(PetitionMessage);
	if((0 == PetitionType))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemMessage(804));
	}
	else if((5 > PetitionMessageLen))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemMessage(386));
	}
	else if((800 <= PetitionMessageLen))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemMessage(971));
	}
	else
	{
		Class'NWindow.PetitionAPI'.static.RequestPetition(PetitionMessage, PetitionType);
		Clear();
		HideWindow("UserPetitionWnd");
		PetitionWndScript = PetitionWnd(GetScript("PetitionWnd"));
		if((none != PetitionWndScript))
		{
			PetitionWndScript.Clear();
			ParamAdd(param, "Message", ((GetSystemString(708) $ " : ") $ PetitionMessage));
			ParamAdd(param, "ColorR", "220");
			ParamAdd(param, "ColorG", "220");
			ParamAdd(param, "ColorB", "220");
			ParamAdd(param, "ColorA", "255");
			PetitionWndScript.HandlePetitionChatMessage(param);
		}
	}
	return;
}

function OnClickCancelButton()
{
	Class'NWindow.PetitionAPI'.static.RequestPetitionCancel();
	Clear();
	HideWindow("UserPetitionWnd");
	return;
}

function Clear()
{
	Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("UserPetitionWnd.PetitionTypeComboBox", 0);
	Class'NWindow.UIAPI_MULTIEDITBOX'.static.SetString("UserPetitionWnd.PetitionMultiEdit", "");
	m_hUserPetitionWndHelpHtmlCtrl.Clear();
	return;
}

defaultproperties
{
	PetitionCategoryCount=9
	PetitionCategoryTitle=696
	PetitionCategoryTitle[1]=697
	PetitionCategoryTitle[2]=698
	PetitionCategoryTitle[3]=699
	PetitionCategoryTitle[4]=700
	PetitionCategoryTitle[5]=701
	PetitionCategoryTitle[6]=702
	PetitionCategoryTitle[7]=703
	PetitionCategoryTitle[8]=704
	PetitionCategoryLink="pet_help_move.htm"
	PetitionCategoryLink[1]="pet_help_recover.htm"
	PetitionCategoryLink[2]="pet_help_bug.htm"
	PetitionCategoryLink[3]="pet_help_quest.htm"
	PetitionCategoryLink[4]="pet_help_report.htm"
	PetitionCategoryLink[5]="pet_help_suggest.htm"
	PetitionCategoryLink[6]="pet_help_game.htm"
	PetitionCategoryLink[7]="pet_help_oprn.htm"
	PetitionCategoryLink[8]="pet_help_etc.htm"
}
