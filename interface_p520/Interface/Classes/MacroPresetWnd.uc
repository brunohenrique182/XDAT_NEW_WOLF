class MacroPresetWnd extends UICommonAPI;

var int MACROCOMMAND_MAX_COUNT;
var WindowHandle Me;
var ItemWindowHandle MacroItem_ItemWnd;
var HtmlHandle PresetViewer_Html;
var ButtonHandle MacroCopy_Btn;
var ButtonHandle Close_Btn;
var TextureHandle SlotGroupBoxBg_Tex;
var array<int> macroPresetIDArray;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function OnShow()
{
	Debug("Show updateMacroPreset");
	updateMacroPreset();
	return;
}

function updateMacroPreset()
{
	local int i;
	local MacroPresetInfo mPresetInfo;
	local ItemInfo infItem;

	macroPresetIDArray.Length = 0;
	Class'NWindow.UIDATA_MACRO'.static.GetMacroPresetIDs(macroPresetIDArray);
	Debug(("macroPresetIDArray" @ string(macroPresetIDArray.Length)));
	MacroItem_ItemWnd.Clear();
	i = 0;
	while((i < macroPresetIDArray.Length))
	{
		Class'NWindow.UIDATA_MACRO'.static.GetMacroPresetInfo(macroPresetIDArray[i], mPresetInfo);
		infItem.Name = mPresetInfo.Name;
		infItem.AdditionalName = mPresetInfo.IconName;
		infItem.Id.ClassID = mPresetInfo.Id;
		infItem.Description = mPresetInfo.Description;
		infItem.IconName = mPresetInfo.IconTextureName;
		infItem.ShortcutType = 4;
		infItem.IconNameEx4 = mPresetInfo.PresetDescription;
		infItem.MacroCommand = macroCommandArrayToString(mPresetInfo);
		MacroItem_ItemWnd.AddItem(infItem);
		if(((i == 0) && (mPresetInfo.PresetDescription != "")))
		{
			MacroItem_ItemWnd.SetSelectedNum(0);
			Debug((("html open :" @ GetLocalizedL2TextPathNameUC()) $ mPresetInfo.PresetDescription));
			PresetViewer_Html.LoadHtml((GetLocalizedL2TextPathNameUC() $ mPresetInfo.PresetDescription));
		}
		i++;
	}
	return;
}

function Initialize()
{
	Me = GetWindowHandle("MacroPresetWnd");
	MacroItem_ItemWnd = GetItemWindowHandle("MacroPresetWnd.MacroItem_ItemWnd");
	PresetViewer_Html = GetHtmlHandle("MacroPresetWnd.PresetViewer_Html");
	Close_Btn = GetButtonHandle("MacroPresetWnd.Close_Btn");
	MacroCopy_Btn = GetButtonHandle("MacroPresetWnd.MacroCopy_Btn");
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "MacroCopy_Btn":
			OnMacroCopy_BtnClick();
			break;
		case "Close_Btn":
			OnClose_BtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnMacroCopy_BtnClick(optional int gfxSystemMessageNum)
{
	local int selectedNum;
	local ItemInfo Info;

	selectedNum = MacroItem_ItemWnd.GetSelectedNum();
	if((selectedNum > -1))
	{
		MacroItem_ItemWnd.GetItem(selectedNum, Info);
		if((Info.MacroCommand != ""))
		{
			if((gfxSystemMessageNum > 0))
			{
				AddSystemMessage(gfxSystemMessageNum);
			}
			else
			{
				AddSystemMessage(4399);
			}
			ClipboardCopy(Info.MacroCommand);
			Debug(("클립보드 카피:" @ Info.MacroCommand));  // EN: clipboard copy:
		}
		else
		{
			Debug("클립보드 카피할게 없어..");  // EN: nothing to copy to the clipboard..
		}
	}
	return;
}

function OnClose_BtnClick()
{
	Me.HideWindow();
	return;
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo Info;

	if((strID == "MacroItem_ItemWnd"))
	{
		if((Index > -1))
		{
			MacroItem_ItemWnd.SetSelectedNum(Index);
			MacroItem_ItemWnd.GetItem(Index, Info);
			if((Info.IconNameEx4 != ""))
			{
				PresetViewer_Html.LoadHtml((GetLocalizedL2TextPathNameUC() $ Info.IconNameEx4));
			}
		}
	}
	return;
}

function OnDBClickItem(string strID, int Index)
{
	local ItemInfo Info;

	if((strID == "MacroItem_ItemWnd"))
	{
		if(GetWindowHandle("MacroEditWnd").IsShowWindow())
		{
			OnMacroCopy_BtnClick(4401);
			MacroItem_ItemWnd.GetItem(Index, Info);
			MacroEditWnd(GetScript("MacroEditWnd")).setEditMacroInfo(Info.Name, Info.IconName);
			MacroEditWnd(GetScript("MacroEditWnd")).pastByClipboard(false);
			Debug("전체 프리셋 붙이기 시도");  // EN: attempting to paste all presets
		}
		else
		{
			Debug("에디터 창이 닫혀 있어서 붙이기 안함.");  // EN: the editor window is closed, so not pasting.
		}
	}
	return;
}

function string macroCommandArrayToString(out MacroPresetInfo mPresetInfo)
{
	local string CommandString;
	local int i;

	i = 0;
	while((i < MACROCOMMAND_MAX_COUNT))
	{
		if((mPresetInfo.CommandList[i] != ""))
		{
			CommandString = ((CommandString $ mPresetInfo.CommandList[i]) $ Chr(13));
		}
		i++;
	}
	if((Len(CommandString) > 0))
	{
		CommandString = Left(CommandString, (Len(CommandString) - 1));
	}
	return CommandString;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
