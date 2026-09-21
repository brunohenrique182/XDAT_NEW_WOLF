class TeleportBookMarkDrawerWnd extends UICommonAPI;

const TEMPLATEICONNAME = "L2ui_ct1.TeleportBookMark_DF_Icon_";
const BOOKMARKICON_MAX_COUNT = 42;

var WindowHandle Me;
var TextBoxHandle txtHead;
var TextBoxHandle txtSaveSlotHead;
var EditBoxHandle EditCurrentSaveBookMarkName;
var TextBoxHandle txtIconName;
var TextBoxHandle txtTeleportBookMarkDrawerWndNameHead;
var EditBoxHandle EditCurrentSaveBookMarkIcn;
var TextureHandle TexItemTemplate;
var ButtonHandle btnIconPrev;
var ButtonHandle btnIconNext;
var ButtonHandle btnSave;
var ButtonHandle btnCancel;
var TextBoxHandle txtSaveLocHead;
var TextBoxHandle txtSaveName;
var TextureHandle IconBack;
var TextBoxHandle txtTeleportFlagCount;
var int bUseTeleportFlag;
var ItemWindowHandle ItemBookMarkItem;
var int m_CurIconNum;

function OnLoad()
{
	SetClosingOnESC();
	InitializeCOD();
	Load();
	m_CurIconNum = 1;
	HandleIconList();
	GetINIBool("Localize", "UseTeleportFlag", bUseTeleportFlag, "L2.ini");
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(2420);
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("TeleportBookMarkDrawerWnd");
	txtHead = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtHead");
	txtSaveSlotHead = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtSaveSlotHead");
	EditCurrentSaveBookMarkName = GetEditBoxHandle("TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkName");
	txtIconName = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtIconName");
	EditCurrentSaveBookMarkIcn = GetEditBoxHandle("TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkIcn");
	txtTeleportBookMarkDrawerWndNameHead = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtTeleportBookMarkDrawerWndNameHead");
	TexItemTemplate = GetTextureHandle("TeleportBookMarkDrawerWnd.TexItemTemplate");
	btnIconPrev = GetButtonHandle("TeleportBookMarkDrawerWnd.btnIconPrev");
	btnIconNext = GetButtonHandle("TeleportBookMarkDrawerWnd.btnIconNext");
	btnSave = GetButtonHandle("TeleportBookMarkDrawerWnd.btnSave");
	btnCancel = GetButtonHandle("TeleportBookMarkDrawerWnd.btnCancel");
	txtSaveLocHead = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtSaveLocHead");
	txtSaveName = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtSaveName");
	IconBack = GetTextureHandle("TeleportBookMarkDrawerWnd.IconBack");
	txtTeleportFlagCount = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtTeleportFlagCount");
	ItemBookMarkItem = GetItemWindowHandle("TeleportBookMarkDrawerWnd.ItemBookMarkItem");
	return;
}

function Load()
{
	return;
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 2420:
			break;
		default:
			break;
	}
	return;
}

function OnChangeEditBox(string strID)
{
	switch(strID)
	{
		case "EditCurrentSaveBookMarkIcn":
			UpdateIconName();
			break;
		default:
			break;
	}
	return;
}

function UpdateIconName()
{
	local string strShortName;

	strShortName = EditCurrentSaveBookMarkIcn.GetString();
	txtIconName.SetText(strShortName);
	return;
}

function OnShow()
{
	local TeleportBookMarkWnd Script;

	UpdateIcon();
	txtTeleportFlagCount.SetText("");
	return;
}

function UpdateCurrentLocation()
{
	EditCurrentSaveBookMarkName.SetString(GetCurrentZoneName());
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnSave":
			OnbtnSaveClick();
			break;
		case "btnCancel":
			OnbtnCancelClick();
			break;
		default:
			break;
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	m_CurIconNum = (Index + 1);
	UpdateIcon();
	return;
}

function OnbtnSaveClick()
{
	local string slotTitle;
	local int IconID;
	local string iconTitle;
	local TeleportBookMarkWnd Script;

	Script = TeleportBookMarkWnd(GetScript("TeleportBookMarkWnd"));
	slotTitle = EditCurrentSaveBookMarkName.GetString();
	IconID = m_CurIconNum;
	iconTitle = EditCurrentSaveBookMarkIcn.GetString();
	iconTitle = Left(iconTitle, 4);
	if((slotTitle != ""))
	{
		if(IsValidItemID(Script.m_CurBookMarkItemID))
		{
			if(Class'NWindow.BookMarkAPI'.static.RequestModifyBookMarkSlot(Script.m_CurBookMarkItemID, slotTitle, IconID, iconTitle))
			{
				Me.HideWindow();
			}
		}
		else if(Class'NWindow.BookMarkAPI'.static.RequestSaveBookMarkSlot(slotTitle, IconID, iconTitle))
		{
			Me.HideWindow();
		}
	}
	return;
}

function HandleIconList()
{
	local int idx;
	local ItemInfo infItem;

	ItemBookMarkItem.Clear();
	idx = 0;
	while((idx < 42))
	{
		infItem.IconName = ("L2ui_ct1.TeleportBookMark_DF_Icon_" $ itoStr((idx + 1)));
		ItemBookMarkItem.AddItem(infItem);
		idx++;
	}
	return;
}

function string itoStr(int tmpNum)
{
	local string tmpStr;

	if((tmpNum < 10))
	{
		tmpStr = ("0" $ string(tmpNum));
	}
	else
	{
		tmpStr = string(tmpNum);
	}
	return tmpStr;
}

function OnbtnCancelClick()
{
	Me.HideWindow();
	return;
}

function UpdateIcon()
{
	TexItemTemplate.SetTexture(("L2ui_ct1.TeleportBookMark_DF_Icon_" $ itoStr(m_CurIconNum)));
	return;
}

function InitializeUI()
{
	m_CurIconNum = 1;
	ItemBookMarkItem.SetSelectedNum((m_CurIconNum - 1));
	EditCurrentSaveBookMarkName.SetString("");
	EditCurrentSaveBookMarkIcn.SetString("");
	txtTeleportBookMarkDrawerWndNameHead.SetText(GetSystemString(1746));
	txtIconName.SetText("");
	UpdateIcon();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("TeleportBookMarkDrawerWnd").HideWindow();
	return;
}
