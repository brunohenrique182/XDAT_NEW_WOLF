class MacroEditWnd extends UICommonAPI;

const MACRO_MAX_COUNT = 48;
const DEFAULT_MACROICON_ID = 105;
const MACRO_ICONANME = "L2UI.MacroWnd.MACRO_ICON";

var string m_Windowname;
var int MACROCOMMAND_MAX_COUNT;
var bool m_bShow;
var int m_CurIconNum;
var int m_CurSkillID;
var ItemID m_CurMacroItemID;
var string m_CurFocusedBoxName;
var int m_CurFocusedBoxIndex;
var WindowHandle MacroEditWnd_Input;
var WindowHandle MacroEditWnd_IconList;
var WindowHandle MacroListWnd;
var WindowHandle Me;
var ButtonHandle m_EditUpButton;
var ButtonHandle m_EditDownButton;
var MultiEditBoxHandle MacroDesc_MultiEdit;

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1260);
	RegisterEvent(1270);
	RegisterEvent(40);
	RegisterEvent(20);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	OnRegisterEvent();
	settingMacroCommandCount();
	Me = GetWindowHandle("MacroEditWnd");
	MacroEditWnd_Input = GetWindowHandle("MacroEditWnd.MacroEditWnd_Input");
	MacroEditWnd_IconList = GetWindowHandle("MacroEditWnd.MacroEditWnd_IconList");
	MacroListWnd = GetWindowHandle("MacroListWnd");
	m_EditUpButton = GetButtonHandle("MacroEditWnd.BtnEditUp");
	m_EditDownButton = GetButtonHandle("MacroEditWnd.BtnEditDown");
	MacroDesc_MultiEdit = GetMultiEditBoxHandle("MacroEditWnd.MacroDesc_MultiEdit");
	m_bShow = false;
	m_CurIconNum = 1;
	ClearItemID(m_CurMacroItemID);
	InitTabOrder();
	Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("MacroEditWnd.texMacro", ("L2UI.MacroWnd.MACRO_ICON" $ string(105)));
	Clear();
	return;
}

function settingMacroCommandCount()
{
	local int i;

	i = 0;
	while((GetWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MacroEditWnd_Input.txtEdit") $ string(i))).m_pTargetWnd != none))
	{
		i++;
	}
	MACROCOMMAND_MAX_COUNT = i;
	ToolTip(GetScript("Tooltip")).MACROCOMMAND_MAX_COUNT = MACROCOMMAND_MAX_COUNT;
	MacroPresetWnd(GetScript("MacroPresetWnd")).MACROCOMMAND_MAX_COUNT = MACROCOMMAND_MAX_COUNT;
	return;
}

function setLockEditSlash(bool bLock)
{
	local int idx;

	idx = 0;
	while((idx < MACROCOMMAND_MAX_COUNT))
	{
		GetEditBoxHandle(("MacroEditWnd.txtEdit" $ string(idx))).SetLockCommandCharacter(bLock);
		idx++;
	}
	return;
}

function OnShow()
{
	if(IsAdenServer())
	{
		GetMeButton("Preset_Btn").HideWindow();
		if(IsBuilderPC())
		{
			setLockEditSlash(false);
		}
		else
		{
			setLockEditSlash(true);
		}
	}
	else
	{
		GetMeButton("Preset_Btn").ShowWindow();
	}
	HandleMacroList();
	if(MacroEditWnd_IconList.IsShowWindow())
	{
		swapWindow();
	}
	m_bShow = true;
	Debug(("MACROCOMMAND_MAX_COUNT" @ string(MACROCOMMAND_MAX_COUNT)));
	return;
}

function OnHide()
{
	m_bShow = false;
	return;
}

function bool hasIconInArray(string targetIconName)
{
	local int idx, itemLen;
	local bool flag;
	local ItemInfo ItemInfo;

	itemLen = GetItemWindowHandle("MacroEditWnd.MacroEditWnd_IconList.MacroItem").GetItemNum();
	idx = 0;
	while((idx < itemLen))
	{
		GetItemWindowHandle("MacroEditWnd.MacroEditWnd_IconList.MacroItem").GetItem(idx, ItemInfo);
		if((targetIconName == ItemInfo.IconName))
		{
			flag = true;
			break;
		}
		idx++;
	}
	return flag;
}

function HandleMacroList()
{
	local int idx;
	local ItemInfo infItem, nullItemInfo;
	local array<ItemID> mySkillIDArray;
	local string iconStr;
	local SkillInfo tempSkillInfo;

	GetItemWindowHandle("MacroEditWnd.MacroItem").Clear();
	infItem.IconName = ("L2UI.MacroWnd.MACRO_ICON" $ string(105));
	infItem.ShortcutType = 4;
	Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("MacroEditWnd.MacroEditWnd_IconList.MacroItem", infItem);
	idx = 0;
	while((idx < 7))
	{
		infItem.IconName = ("L2UI.MacroWnd.MACRO_ICON" $ string((idx + 1)));
		infItem.ShortcutType = 4;
		Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("MacroEditWnd.MacroEditWnd_IconList.MacroItem", infItem);
		idx++;
	}
	Class'NWindow.UIDATA_SKILL'.static.GetCurrentSkillList(mySkillIDArray);
	idx = 0;
	while((idx < mySkillIDArray.Length))
	{
		if(GetSkillInfo(mySkillIDArray[idx].ClassID, 1, 0, tempSkillInfo))
		{
			infItem = nullItemInfo;
			if((isActiveSkill(tempSkillInfo.IconType) && (tempSkillInfo.MagicType != 8)))
			{
				iconStr = Class'NWindow.UIDATA_SKILL'.static.GetIconName(mySkillIDArray[idx], 1, 0);
				if((iconStr != ""))
				{
					if(!hasIconInArray(iconStr))
					{
						infItem.Name = tempSkillInfo.SkillName;
						infItem.IconName = iconStr;
						infItem.ShortcutType = 4;
						infItem.Level = mySkillIDArray[idx].ClassID;
						Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("MacroEditWnd.MacroEditWnd_IconList.MacroItem", infItem);
					}
				}
			}
		}
		idx++;
	}
	idx = 7;
	while((idx < 64))
	{
		infItem = nullItemInfo;
		infItem.IconName = ("L2UI.MacroWnd.MACRO_ICON" $ string((idx + 1)));
		infItem.ShortcutType = 4;
		Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("MacroEditWnd.MacroEditWnd_IconList.MacroItem", infItem);
		idx++;
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
		case "btnCancel":
			OnClickCancel();
			break;
		case "btnSave":
			OnClickSave();
			break;
		case "btnIconChange":
			onClickIconChange();
			break;
		case "BtnEditUp":
			LineSwap("up");
			break;
		case "BtnEditDown":
			LineSwap("down");
			break;
		case "BtnEditdel":
			CurClearLine();
			break;
		case "BtnEditAdd":
			CurInsertLine();
			break;
		case "Preset_Btn":
			toggleWindow("MacroPresetWnd", true);
			break;
		case "MacroCopy_Btn":
			macroTotalCopy();
			break;
		case "MacroPaste_Btn":
			macroTotalPaste();
			break;
		case "BtnEditAlldel":
			clearAllMacrocommandEditbox();
			break;
		default:
			break;
	}
	return;
}

function macroTotalCopy()
{
	local int idx;
	local string CommandString;

	idx = 0;
	while((idx < MACROCOMMAND_MAX_COUNT))
	{
		if((GetEditBoxHandle(("MacroEditWnd.txtEdit" $ string(idx))).GetString() != ""))
		{
			CommandString = ((CommandString $ GetEditBoxHandle(("MacroEditWnd.txtEdit" $ string(idx))).GetString()) $ Chr(13));
		}
		idx++;
	}
	if((Len(CommandString) > 0))
	{
		CommandString = Left(CommandString, (Len(CommandString) - 1));
	}
	Debug(("클립 보드에 카피 되었습니다.:" @ CommandString));  // EN: copied to the clipboard.:
	AddSystemMessage(4399);
	ClipboardCopy(CommandString);
	return;
}

function macroTotalPaste()
{
	pastByClipboard(true);
	return;
}

function onClickIconChange()
{
	swapWindow();
	return;
}

function swapWindow()
{
	local ButtonHandle btnIconChange;

	btnIconChange = GetButtonHandle("MacroEditWnd.btnIconChange");
	if(MacroEditWnd_Input.IsShowWindow())
	{
		btnIconChange.SetButtonName(2817);
		MacroEditWnd_Input.HideWindow();
		MacroEditWnd_IconList.ShowWindow();
		MacroEditWnd_IconList.SetFocus();
	}
	else
	{
		btnIconChange.SetButtonName(2815);
		MacroEditWnd_Input.ShowWindow();
		MacroEditWnd_IconList.HideWindow();
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	local int StrLen;
	local ItemInfo infItem;

	if(((strID == "MacroItem") && (Index > -1)))
	{
		if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("MacroEditWnd.MacroItem", Index, infItem))
		{
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("MacroEditWnd.texMacro", infItem.IconName);
			if((infItem.Level > 0))
			{
				m_CurSkillID = infItem.Level;
			}
			else
			{
				m_CurSkillID = 0;
				StrLen = (Len(infItem.IconName) - Len("L2UI.MacroWnd.MACRO_ICON"));
				m_CurIconNum = int(Right(infItem.IconName, StrLen));
			}
			Debug(("스킬 Name" @ infItem.Name));  // EN: skill Name
			Debug(("스킬 ID" @ string(infItem.Level)));  // EN: skill ID
			Debug(("m_CurIconNum : " @ string(m_CurIconNum)));
			swapWindow();
		}
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 1260))
	{
		HandleMacroShowEditWnd(param);
	}
	else if((Event_ID == 1270))
	{
		HandleMacroDeleted(param);
	}
	else if((Event_ID == 1710))
	{
		if(DialogIsMine())
		{
			ProcessInsertLine();
		}
	}
	else if((Event_ID == 1720))
	{
	}
	else if((Event_ID == 20))
	{
		if(Me.IsShowWindow())
		{
			pastByClipboard(true);
		}
	}
	else if((Event_ID == 40))
	{
		Clear();
	}
	return;
}

function setEditMacroInfo(string macroName, string IconTextureName)
{
	local int StrLen;

	GetEditBoxHandle("MacroEditWnd.txtName").SetString(macroName);
	GetTextBoxHandle("MacroEditWnd.txtMacroName").SetText(Left(macroName, 4));
	m_CurSkillID = 0;
	StrLen = (Len(IconTextureName) - Len("L2UI.MacroWnd.MACRO_ICON"));
	m_CurIconNum = int(Right(IconTextureName, StrLen));
	Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("MacroEditWnd.texMacro", ("L2UI.MacroWnd.MACRO_ICON" $ string(m_CurIconNum)));
	return;
}

function pastByClipboard(bool bLastEditBoxFocus)
{
	local string clipboardstr;
	local int idx;

	clipboardstr = ClipboardPaste();
	if((Len(clipboardstr) > 0))
	{
		if(GetEditBoxHandle(m_CurFocusedBoxName).IsFocused())
		{
			idx = GetCurTextBoxIndex(m_CurFocusedBoxName);
			pasteMacroEdit(idx, clipboardstr, bLastEditBoxFocus);
			Debug(("현재 위치 부터" @ string(idx)));  // EN: from the current position
		}
		else
		{
			pasteMacroEdit(0, clipboardstr, bLastEditBoxFocus);
			Debug("첫줄 부터");  // EN: from the first line
		}
	}
	return;
}

function pasteMacroEdit(int nEditLine, string CommandStr, optional bool bLastEditBoxFocus, optional bool onelineOverwrite)
{
	local array<string> commandArray;
	local int idx;
	local string pasteString;

	if(IsAdenServer())
	{
		if(!IsBuilderPC())
		{
			CommandStr = Substitute(CommandStr, "/", "", false);
		}
	}
	Split(CommandStr, Chr(13), commandArray);
	Debug(("Length : " @ string(commandArray.Length)));
	if((InStr(CommandStr, Chr(13)) != -1))
	{
		idx = 0;
		while((idx < commandArray.Length))
		{
			if(((nEditLine + idx) < MACROCOMMAND_MAX_COUNT))
			{
				pasteString = deleteEnter(commandArray[idx]);
				Class'NWindow.UIAPI_EDITBOX'.static.SetString(("MacroEditWnd.txtEdit" $ string((nEditLine + idx))), pasteString);
				Debug(((("여러줄  넣기" @ string((nEditLine + idx))) @ ": ") @ commandArray[idx]));  // EN: insert multiple lines
				Debug(((("여러줄  pasteString:" @ string((nEditLine + idx))) @ ": ") @ pasteString));  // EN: multi-line pasteString:
				if(bLastEditBoxFocus)
				{
					if(((nEditLine + idx) < (MACROCOMMAND_MAX_COUNT - 1)))
					{
						GetEditBoxHandle(("MacroEditWnd.txtEdit" $ string(((nEditLine + idx) + 1)))).SetFocus();
					}
				}
			}
			idx++;
		}
	}
	else if(onelineOverwrite)
	{
		GetEditBoxHandle(("MacroEditWnd.txtEdit" $ string(nEditLine))).SetString(CommandStr);
	}
	else
	{
		Debug(("한줄 넣기" @ CommandStr));  // EN: insert one line
		GetEditBoxHandle(("MacroEditWnd.txtEdit" $ string(nEditLine))).DeleteClipBoard();
		GetEditBoxHandle(("MacroEditWnd.txtEdit" $ string(nEditLine))).AddString(CommandStr);
	}
	return;
}

function InitTabOrder()
{
	local int idx;

	Class'NWindow.UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd", "MacroEditWnd.txtName", "MacroEditWnd.MacroDesc_MultiEdit");
	Class'NWindow.UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtName", "MacroEditWnd.MacroDesc_MultiEdit", "MacroEditWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.MacroDesc_MultiEdit", "MacroEditWnd.txtEdit0", "MacroEditWnd.txtName");
	idx = 0;
	while((idx < MACROCOMMAND_MAX_COUNT))
	{
		if((idx == 0))
		{
			Class'NWindow.UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtEdit0", "MacroEditWnd.txtEdit1", "MacroEditWnd.MacroDesc_MultiEdit");
			idx++;
			continue;
		}
		if((idx == (MACROCOMMAND_MAX_COUNT - 1)))
		{
			Class'NWindow.UIAPI_WINDOW'.static.SetTabOrder(("MacroEditWnd.txtEdit" $ string((MACROCOMMAND_MAX_COUNT - 1))), "MacroEditWnd.txtName", ("MacroEditWnd.txtEdit" $ string((MACROCOMMAND_MAX_COUNT - 2))));
			idx++;
			continue;
		}
		Class'NWindow.UIAPI_WINDOW'.static.SetTabOrder(("MacroEditWnd.txtEdit" $ string(idx)), ("MacroEditWnd.txtEdit" $ string((idx + 1))), ("MacroEditWnd.txtEdit" $ string((idx - 1))));
		idx++;
	}
	return;
}

function OnClickHelp()
{
	local string strParam;

	ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "help_general_control_macro.htm"));
	ExecuteEvent(1210, strParam);
	return;
}

function OnClickCancel()
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
	return;
}

function OnClickSave()
{
	SaveMacro();
	return;
}

function OnDropItem(string strID, ItemInfo infItem, int X, int Y)
{
	local int nEditLine;

	if(IsAdenServer())
	{
		if(!IsBuilderPC())
		{
			return;
		}
		if((infItem.ShortcutType == 4))
		{
			return;
		}
	}
	if((Len(strID) < 1))
	{
		return;
	}
	if((Left(strID, 7) != "txtEdit"))
	{
		return;
	}
	Class'NWindow.UIAPI_EDITBOX'.static.SetHighLight(("MacroEditWnd." $ strID), false);
	nEditLine = int(Mid(strID, Len("txtEdit"), Len(strID)));
	pasteMacroEdit(nEditLine, infItem.MacroCommand, false, true);
	return;
}

function OnDragItemStart(string strID, ItemInfo infItem)
{
	if(IsAdenServer())
	{
		if(!IsBuilderPC())
		{
			return;
		}
		if((infItem.ShortcutType == 4))
		{
			return;
		}
	}
	if((Len(strID) < 1))
	{
		return;
	}
	if((Left(strID, 7) != "txtEdit"))
	{
		return;
	}
	Class'NWindow.UIAPI_EDITBOX'.static.SetHighLight(("MacroEditWnd." $ strID), true);
	return;
}

function OnDragItemEnd(string strID)
{
	if(IsAdenServer())
	{
		if(!IsBuilderPC())
		{
			return;
		}
	}
	if((Len(strID) < 1))
	{
		return;
	}
	if((Left(strID, 7) != "txtEdit"))
	{
		return;
	}
	Class'NWindow.UIAPI_EDITBOX'.static.SetHighLight(("MacroEditWnd." $ strID), false);
	return;
}

function OnChangeEditBox(string strID)
{
	switch(strID)
	{
		case "txtName":
			UpdateIconName();
			break;
		default:
			break;
	}
	return;
}

function UpdateIcon()
{
	local string iconStr;

	if((m_CurSkillID > 0))
	{
		iconStr = Class'NWindow.UIDATA_SKILL'.static.GetIconName(GetItemID(m_CurSkillID), 1, 0);
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("MacroEditWnd.texMacro", iconStr);
	}
	else
	{
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("MacroEditWnd.texMacro", ("L2UI.MacroWnd.MACRO_ICON" $ string(m_CurIconNum)));
	}
	return;
}

function UpdateIconName()
{
	local string strShortName;

	strShortName = Left(Class'NWindow.UIAPI_EDITBOX'.static.GetString("MacroEditWnd.txtName"), 4);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("MacroEditWnd.txtMacroName", strShortName);
	return;
}

function Clear()
{
	m_CurSkillID = 0;
	m_CurIconNum = 105;
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtName", "");
	MacroDesc_MultiEdit.SetString("");
	clearAllMacrocommandEditbox();
	UpdateIcon();
	UpdateIconName();
	return;
}

function clearAllMacrocommandEditbox()
{
	local int idx;

	idx = 0;
	while((idx < MACROCOMMAND_MAX_COUNT))
	{
		Class'NWindow.UIAPI_EDITBOX'.static.SetString(("MacroEditWnd.txtEdit" $ string(idx)), "");
		idx++;
	}
	return;
}

function HandleMacroDeleted(string param)
{
	local ItemID cID;

	ParseItemID(param, cID);
	if(m_bShow)
	{
		Clear();
		ClearItemID(m_CurMacroItemID);
	}
	return;
}

function HandleMacroShowEditWnd(string param)
{
	local int MacroCount;
	local Color TextColor;

	Clear();
	ClearItemID(m_CurMacroItemID);
	Debug(("param" @ param));
	if(ParseItemID(param, m_CurMacroItemID))
	{
		SetMacroID(m_CurMacroItemID);
		if(!m_bShow)
		{
			PlayConsoleSound(IFST_WINDOW_OPEN);
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");
		}
		GetEditBoxHandle("MacroEditWnd.txtEdit0").SetFocus();
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtName");
	}
	else if(m_bShow)
	{
	}
	else
	{
		MacroCount = Class'NWindow.UIDATA_MACRO'.static.GetMacroCount();
		if((MacroCount >= 48))
		{
			TextColor.R = 176;
			TextColor.G = 155;
			TextColor.B = 121;
			TextColor.A = 255;
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(797));
			DialogSetID(0);
			return;
		}
		PlayConsoleSound(IFST_WINDOW_OPEN);
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");
		GetEditBoxHandle("MacroEditWnd.txtEdit0").SetFocus();
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtName");
	}
	return;
}

function SetMacroID(ItemID cID)
{
	local int idx;
	local MacroInfo Info;
	local int StrLen;

	if(!IsValidItemID(cID))
	{
		return;
	}
	if(Class'NWindow.UIDATA_MACRO'.static.GetMacroInfo(cID, Info))
	{
		Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtName", Info.Name);
		if((Info.IconSkillId > 0))
		{
			m_CurSkillID = Info.IconSkillId;
			m_CurIconNum = 105;
		}
		else
		{
			StrLen = (Len(Info.IconTextureName) - Len("L2UI.MacroWnd.MACRO_ICON"));
			m_CurIconNum = int(Right(Info.IconTextureName, StrLen));
		}
		if((m_CurIconNum < 1))
		{
			m_CurIconNum = 105;
		}
		UpdateIcon();
		MacroDesc_MultiEdit.SetString(Info.Description);
		idx = 0;
		while((idx < MACROCOMMAND_MAX_COUNT))
		{
			Class'NWindow.UIAPI_EDITBOX'.static.SetString(("MacroEditWnd.txtEdit" $ string(idx)), Info.CommandList[idx]);
			idx++;
		}
	}
	return;
}

function SaveMacro()
{
	local int idx, saveIdx;
	local string Name, Description, Command;
	local array<string> CommandList;

	Name = Class'NWindow.UIAPI_EDITBOX'.static.GetString("MacroEditWnd.txtName");
	Description = MacroDesc_MultiEdit.GetString();
	idx = 0;
	while((idx < MACROCOMMAND_MAX_COUNT))
	{
		Command = Class'NWindow.UIAPI_EDITBOX'.static.GetString(("MacroEditWnd.txtEdit" $ string(idx)));
		if(IsAdenServer())
		{
			if(!IsBuilderPC())
			{
				Command = Substitute(Command, "/", "", false);
			}
		}
		if((Command != ""))
		{
			CommandList.Insert(CommandList.Length, 1);
			CommandList[(CommandList.Length - 1)] = Command;
		}
		idx++;
	}
	saveIdx = CommandList.Length;
	while((saveIdx < MACROCOMMAND_MAX_COUNT))
	{
		CommandList.Insert(CommandList.Length, 1);
		CommandList[(CommandList.Length - 1)] = "";
		saveIdx++;
	}
	Debug(("------> Call RequestMakeMacro,  m_CurIconNum: " @ string((m_CurIconNum - 1))));
	if(Class'NWindow.MacroAPI'.static.RequestMakeMacro(m_CurMacroItemID, Name, Left(Name, 4), (m_CurIconNum - 1), m_CurSkillID, Description, CommandList))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
	}
	return;
}

function CurClearLine()
{
	local int idx, i;
	local string nextString, curString;
	local array<string> List;

	idx = GetCurTextBoxIndex(m_CurFocusedBoxName);
	List.Remove(0, List.Length);
	Class'NWindow.UIAPI_EDITBOX'.static.SetString(("MacroEditWnd.txtEdit" $ string(idx)), "");
	i = (idx + 1);
	while((i < MACROCOMMAND_MAX_COUNT))
	{
		curString = Class'NWindow.UIAPI_EDITBOX'.static.GetString(("MacroEditWnd.txtEdit" $ string(i)));
		Class'NWindow.UIAPI_EDITBOX'.static.SetString(("MacroEditWnd.txtEdit" $ string(i)), "");
		List.Insert(List.Length, 1);
		List[(List.Length - 1)] = curString;
		i++;
	}
	i = idx;
	while((i < (List.Length + idx)))
	{
		nextString = List[(i - idx)];
		Class'NWindow.UIAPI_EDITBOX'.static.SetString(("MacroEditWnd.txtEdit" $ string(i)), nextString);
		i++;
	}
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus(("MacroEditWnd.txtEdit" $ string(idx)));
	return;
}

function removeAllEditBox()
{
	local int i;

	i = 0;
	while((i < MACROCOMMAND_MAX_COUNT))
	{
		Class'NWindow.UIAPI_EDITBOX'.static.SetString(("MacroEditWnd.txtEdit" $ string(i)), "");
		i++;
	}
	return;
}

function CurInsertLine()
{
	m_CurFocusedBoxIndex = GetCurTextBoxIndex(m_CurFocusedBoxName);
	if((Class'NWindow.UIAPI_EDITBOX'.static.GetString(("MacroEditWnd.txtEdit" $ string((MACROCOMMAND_MAX_COUNT - 1)))) != ""))
	{
		DialogShow(DialogModalType_Modal, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(4208), string(MACROCOMMAND_MAX_COUNT)));
		DialogSetID(0);
		return;
	}
	ProcessInsertLine();
	return;
}

function ProcessInsertLine()
{
	local int idx, i, Id;
	local string nextString, curString;
	local array<string> List;

	idx = m_CurFocusedBoxIndex;
	i = idx;
	while((i < MACROCOMMAND_MAX_COUNT))
	{
		curString = Class'NWindow.UIAPI_EDITBOX'.static.GetString(("MacroEditWnd.txtEdit" $ string(i)));
		List.Insert(List.Length, 1);
		List[(List.Length - 1)] = curString;
		i++;
	}
	i = idx;
	while((i < MACROCOMMAND_MAX_COUNT))
	{
		Id = (i - idx);
		if((Id >= 0))
		{
			nextString = List[Id];
			if(((i + 1) < MACROCOMMAND_MAX_COUNT))
			{
				Class'NWindow.UIAPI_EDITBOX'.static.SetString(("MacroEditWnd.txtEdit" $ string((i + 1))), nextString);
			}
		}
		i++;
	}
	Class'NWindow.UIAPI_EDITBOX'.static.SetString(("MacroEditWnd.txtEdit" $ string(idx)), "");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus(("MacroEditWnd.txtEdit" $ string(idx)));
	return;
}

function LineSwap(string strType)
{
	local int idx;

	idx = GetCurTextBoxIndex(m_CurFocusedBoxName);
	if((strType == "up"))
	{
		if((idx > 0))
		{
			SwapString(idx, (idx - 1));
		}
	}
	else if((strType == "down"))
	{
		if((idx < (MACROCOMMAND_MAX_COUNT - 1)))
		{
			SwapString(idx, (idx + 1));
		}
	}
	return;
}

function SwapString(int firstID, int lastID)
{
	local string lastString, curString;

	curString = Class'NWindow.UIAPI_EDITBOX'.static.GetString(("MacroEditWnd.txtEdit" $ string(firstID)));
	lastString = Class'NWindow.UIAPI_EDITBOX'.static.GetString(("MacroEditWnd.txtEdit" $ string(lastID)));
	Class'NWindow.UIAPI_EDITBOX'.static.SetString(("MacroEditWnd.txtEdit" $ string(firstID)), lastString);
	Class'NWindow.UIAPI_EDITBOX'.static.SetString(("MacroEditWnd.txtEdit" $ string(lastID)), curString);
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus(("MacroEditWnd.txtEdit" $ string(lastID)));
	return;
}

function int GetCurTextBoxIndex(string boxName)
{
	local string Str;
	local int idx;

	if((Left(boxName, 7) == "txtEdit"))
	{
		Str = Right(boxName, 2);
		if((Left(Str, 1) == "t"))
		{
			idx = int(Right(boxName, 1));
		}
		else
		{
			idx = int(Right(Str, 2));
		}
	}
	return idx;
}

function OnSetFocus(WindowHandle Handle, bool bFocused)
{
	local int idx;

	super.OnSetFocus(Handle, bFocused);
	if((string(Handle.Name) == "EditBoxHandle"))
	{
		m_CurFocusedBoxName = Handle.GetWindowName();
		idx = GetCurTextBoxIndex(m_CurFocusedBoxName);
		m_EditUpButton.EnableWindow();
		m_EditDownButton.EnableWindow();
		m_EditUpButton.SetTexture("L2UI_CT1.Button.BtnEditUp", "", "");
		m_EditDownButton.SetTexture("L2UI_CT1.Button.BtnEditDown", "", "");
		if((idx == 0))
		{
			m_EditUpButton.DisableWindow();
			m_EditUpButton.SetTexture("L2UI_CT1.Button.BtnEditUp_disable", "", "");
		}
		else if((idx == (MACROCOMMAND_MAX_COUNT - 1)))
		{
			m_EditDownButton.DisableWindow();
			m_EditDownButton.SetTexture("L2UI_CT1.Button.BtnEditDown_disable", "", "");
		}
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{
	local int nEditLine;

	if(((int(Key) == 38) || (int(Key) == 40)))
	{
		nEditLine = int(Mid(m_CurFocusedBoxName, Len("txtEdit"), Len(m_CurFocusedBoxName)));
		if(!GetEditBoxHandle(("MacroEditWnd.txtEdit" $ string(nEditLine))).IsFocused())
		{
			nEditLine = -1;
			return false;
		}
	}
	switch(Key)
	{
		case IK_Up:
			if((nEditLine > 0))
			{
				nEditLine--;
				GetEditBoxHandle(("MacroEditWnd.txtEdit" $ string(nEditLine))).SetFocus();
			}
			break;
		case IK_Down:
			if((nEditLine < (MACROCOMMAND_MAX_COUNT - 1)))
			{
				nEditLine++;
				GetEditBoxHandle(("MacroEditWnd.txtEdit" $ string(nEditLine))).SetFocus();
			}
			break;
		case IK_Slash:
			if(IsAdenServer())
			{
				if(!IsBuilderPC())
				{
					if((MacroDesc_MultiEdit.IsFocused() || GetEditBoxHandle("MacroEditWnd.txtName").IsFocused()))
					{
					}
					else if(isLineEditorFocus())
					{
						getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(14626));
					}
				}
			}
		default:
			break;
	}
	return false;
}

function bool isLineEditorFocus()
{
	local int idx;
	local bool bFocus;

	idx = 0;
	while((idx < MACROCOMMAND_MAX_COUNT))
	{
		if(GetEditBoxHandle(("MacroEditWnd.txtEdit" $ string(idx))).IsFocused())
		{
			bFocus = true;
			break;
		}
		idx++;
	}
	return bFocus;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="MacroEditWnd"
}
