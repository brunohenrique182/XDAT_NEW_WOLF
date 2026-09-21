class MacroListWnd extends UICommonAPI;

const MACRO_MAX_COUNT = 48;

var string m_Windowname;
var bool m_bShow;
var ItemID m_DeleteItemID;
var int m_Max;
var WindowHandle m_hMacroListWnd;

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1230);
	RegisterEvent(1240);
	RegisterEvent(1250);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	m_hMacroListWnd = GetWindowHandle(m_Windowname);
	m_bShow = false;
	ClearItemID(m_DeleteItemID);
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	Class'NWindow.MacroAPI'.static.RequestMacroList();
	return;
}

function OnShow()
{
	m_bShow = true;
	return;
}

function OnHide()
{
	m_bShow = false;
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
	if(GetWindowHandle("MacroPresetWnd").IsShowWindow())
	{
		GetWindowHandle("MacroPresetWnd").HideWindow();
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnHelp":
			OnClickHelp();
			break;
		case "btnAdd":
			OnClickAdd();
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 1230))
	{
		HandleMacroShowListWnd();
	}
	else if((Event_ID == 1240))
	{
		HandleMacroUpdate();
	}
	else if((Event_ID == 1250))
	{
		HandleMacroList(param);
	}
	else if((Event_ID == 1710))
	{
		if(DialogIsMine())
		{
			if(IsValidItemID(m_DeleteItemID))
			{
				Class'NWindow.MacroAPI'.static.RequestDeleteMacro(m_DeleteItemID);
				ClearItemID(m_DeleteItemID);
				if((m_Max == 1))
				{
					HandleMacroList("");
				}
			}
		}
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo infItem;

	if(((strID == "MacroItem") && (Index > -1)))
	{
		if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("MacroListWnd.MacroItem", Index, infItem))
		{
			Class'NWindow.MacroAPI'.static.RequestUseMacro(infItem.Id);
		}
	}
	return;
}

function OnClickHelp()
{
	local string strParam;

	if(getInstanceUIData().GetIsClassicServer())
	{
		if(IsAdenServer())
		{
			ExecuteEvent(1210, "37");
		}
		else
		{
			ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "help_general_control_macro.htm"));
			ExecuteEvent(1210, strParam);
		}
	}
	else
	{
		ExecuteEvent(1210, "37");
	}
	return;
}

function OnClickAdd()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("MacroEditWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("MacroEditWnd");
		ExecuteEvent(1260, "");
	}
	return;
}

function HandleMacroUpdate()
{
	Class'NWindow.MacroAPI'.static.RequestMacroList();
	return;
}

function HandleMacroShowListWnd()
{
	if(m_bShow)
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		m_hMacroListWnd.HideWindow();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		m_hMacroListWnd.ShowWindow();
		m_hMacroListWnd.SetFocus();
	}
	return;
}

function Clear()
{
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("MacroListWnd.MacroItem");
	return;
}

function HandleMacroList(string param)
{
	local int idx, Max;
	local string strIconName, strMacroName, strDescription, strTexture, strTmp;
	local ItemInfo infItem;

	Clear();
	ParseInt(param, "Max", Max);
	m_Max = Max;
	idx = 0;
	while((idx < Max))
	{
		strIconName = "";
		strMacroName = "";
		strDescription = "";
		strTexture = "";
		ParseItemIDWithIndex(param, infItem.Id, idx);
		ParseString(param, ("IconName_" $ string(idx)), strIconName);
		ParseString(param, ("MacroName_" $ string(idx)), strMacroName);
		ParseString(param, ("Description_" $ string(idx)), strDescription);
		ParseString(param, ("TextureName_" $ string(idx)), strTexture);
		infItem.Name = strMacroName;
		infItem.AdditionalName = strIconName;
		infItem.IconName = strTexture;
		infItem.Description = strDescription;
		infItem.ShortcutType = 4;
		Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("MacroListWnd.MacroItem", infItem);
		idx++;
	}
	if((Max < 10))
	{
		strTmp = (strTmp $ "0");
	}
	strTmp = (strTmp $ string(Max));
	strTmp = (((("(" $ strTmp) $ "/") $ string(48)) $ ")");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("MacroListWnd.txtCount", strTmp);
	return;
}

function OnDropItem(string strID, ItemInfo infItem, int X, int Y)
{
	switch(strID)
	{
		case "btnTrash":
			DeleteMacro(infItem);
			break;
		case "btnEdit":
			EditMacro(infItem);
			break;
		default:
			break;
	}
	return;
}

function DeleteMacro(ItemInfo infItem)
{
	local string strMsg;

	if((infItem.ShortcutType != 4))
	{
		return;
	}
	strMsg = MakeFullSystemMsg(GetSystemMessage(828), infItem.Name, "");
	m_DeleteItemID = infItem.Id;
	DialogShow(DialogModalType_Modalless, DialogType_Warning, strMsg);
	return;
}

function EditMacro(ItemInfo infItem)
{
	local string param;

	Debug("------------------ > ");
	Debug(("infItem Name" @ infItem.Name));
	if((infItem.ShortcutType != 4))
	{
		return;
	}
	Debug(("------------EShortCutItemType ------ > " @ string(4)));
	ParamAddItemID(param, infItem.Id);
	ExecuteEvent(1260, param);
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");
	Debug(("쇼쇼쇼 " @ param));  // EN: show show show
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hMacroListWnd.HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="MacroListWnd"
}
