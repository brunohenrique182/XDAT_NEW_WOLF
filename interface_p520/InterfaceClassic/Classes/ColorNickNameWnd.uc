class ColorNickNameWnd extends UICommonAPI;

var WindowHandle Me;
var EditBoxHandle NickNameEditBox;
var ComboBoxHandle ColorComboBox;
var array<Color> ColorTable;
var array<int> ColorIndexs;
var ButtonHandle btnOk;
var ButtonHandle btnCancel;
var ItemID m_ClickedItemID;

function OnRegisterEvent()
{
	RegisterEvent(3440);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("ColorNickNameWnd");
	NickNameEditBox = GetEditBoxHandle("ColorNickNameWnd.Edit_NickName");
	ColorComboBox = GetComboBoxHandle("ColorNickNameWnd.ColorCombo");
	btnOk = GetButtonHandle("ColorNickNameWnd.BtnOk");
	btnCancel = GetButtonHandle("ColorNickNameWnd.BtnCancel");
	return;
}

function OnChangeEditBox(string strID)
{
	switch(strID)
	{
		case "Edit_NickName":
			btnOk.EnableWindow();
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 3440:
			OnOpenWnd(param);
			break;
		default:
			break;
	}
	return;
}

function OnOpenWnd(string param)
{
	local UserInfo UserInfo;
	local Color colNickNameColor;
	local string strNickName;
	local int i, numOfColorIndex, ColorIndex, colorSysStringID;

	ParseItemID(param, m_ClickedItemID);
	ParseInt(param, "numOfColorIndex", numOfColorIndex);
	ColorTable.Remove(0, ColorTable.Length);
	ColorIndexs.Remove(0, ColorIndexs.Length);
	ColorTable.Length = (numOfColorIndex + 1);
	ColorIndexs.Length = (numOfColorIndex + 1);
	ColorTable[0].A = 255;
	ColorTable[0].R = 162;
	ColorTable[0].G = 249;
	ColorTable[0].B = 236;
	ColorComboBox.Clear();
	i = 1;
	while((i <= numOfColorIndex))
	{
		ParseInt(param, ("ColorIndex" $ string(i)), ColorIndex);
		ColorTable[i] = GetNicknameColorWithIndex(ColorIndex);
		ColorIndexs[i] = ColorIndex;
		ParseInt(param, ("ColorSysStringID" $ string(i)), colorSysStringID);
		ColorComboBox.AddStringWithColor(GetSystemString(colorSysStringID), ColorTable[i]);
		i++;
	}
	Me.ShowWindow();
	NickNameEditBox.SetFocus();
	if(GetPlayerInfo(UserInfo))
	{
		strNickName = UserInfo.strNickName;
		colNickNameColor = UserInfo.NicknameColor;
		NickNameEditBox.Clear();
		NickNameEditBox.SetString(strNickName);
		i = 0;
		while((i < numOfColorIndex))
		{
			if((ColorTable[i] == colNickNameColor))
			{
				ColorComboBox.SetSelectedNum((i - 1));
				btnOk.DisableWindow();
				break;
			}
			i++;
		}
	}
	return;
}

function OnComboBoxItemSelected(string ComboboxName, int Id)
{
	local UserInfo UserInfo;
	local Color colNickNameColor;

	if(GetPlayerInfo(UserInfo))
	{
		colNickNameColor = UserInfo.NicknameColor;
		if((ColorTable[(Id + 1)] == colNickNameColor))
		{
			btnOk.DisableWindow();
		}
		else
		{
			btnOk.EnableWindow();
		}
	}
	return;
}

function OnClickButton(string buttonName)
{
	local int selectedNum;

	switch(buttonName)
	{
		case "BtnOk":
			if((NickNameEditBox.GetString() != ""))
			{
				selectedNum = ColorComboBox.GetSelectedNum();
				selectedNum = selectedNum;
				RequestChangeNicknameNColor(ColorIndexs[(selectedNum + 1)], NickNameEditBox.GetString(), m_ClickedItemID);
				Me.HideWindow();
			}
			break;
		case "BtnCancel":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("ColorNickNameWnd").HideWindow();
	return;
}
