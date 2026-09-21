class SheathingWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle m_hWnd;
var WindowHandle m_hAnimBlendingWnd;
var EditBoxHandle m_hEbLeftAttachBoneName;
var ButtonHandle m_hBtnLeftApplyAttachBoneName;
var EditBoxHandle m_hEbLeftRotPitch;
var EditBoxHandle m_hEbLeftRotYaw;
var EditBoxHandle m_hEbLeftRotRoll;
var ButtonHandle m_hBtnLeftApplyAttachRotation;
var EditBoxHandle m_hEbLeftOffsetX;
var EditBoxHandle m_hEbLeftOffsetY;
var EditBoxHandle m_hEbLeftOffsetZ;
var ButtonHandle m_hBtnLeftApplyOffset;
var EditBoxHandle m_hEbLeftMantleOffsetX;
var EditBoxHandle m_hEbLeftMantleOffsetY;
var EditBoxHandle m_hEbLeftMantleOffsetZ;
var ButtonHandle m_hBtnLeftApplyMantleOffset;
var ComboBoxHandle m_hCbLeftSheathingHide;
var EditBoxHandle m_hEbRightAttachBoneName;
var ButtonHandle m_hBtnRightApplyAttachBoneName;
var EditBoxHandle m_hEbRightRotPitch;
var EditBoxHandle m_hEbRightRotYaw;
var EditBoxHandle m_hEbRightRotRoll;
var ButtonHandle m_hBtnRightApplyAttachRotation;
var EditBoxHandle m_hEbRightOffsetX;
var EditBoxHandle m_hEbRightOffsetY;
var EditBoxHandle m_hEbRightOffsetZ;
var ButtonHandle m_hBtnRightApplyOffset;
var EditBoxHandle m_hEbRightMantleOffsetX;
var EditBoxHandle m_hEbRightMantleOffsetY;
var EditBoxHandle m_hEbRightMantleOffsetZ;
var ButtonHandle m_hBtnRightApplyMantleOffset;
var ComboBoxHandle m_hCbRightSheathingHide;
var ButtonHandle m_hBtnPlaySheathingAnim;

function OnRegisterEvent()
{
	RegisterEvent(5160);
	RegisterEvent(5170);
	return;
}

function OnLoad()
{
	InitializeHandle();
	setWindowTitleByString(m_Windowname);
	return;
}

function InitializeHandle()
{
	m_hWnd = GetWindowHandle(m_Windowname);
	m_hEbLeftAttachBoneName = GetEditBoxHandle((m_Windowname $ ".ebLeftAttachBoneName"));
	m_hBtnLeftApplyAttachBoneName = GetButtonHandle((m_Windowname $ ".btnLeftApplyAttachBoneName"));
	m_hEbLeftRotPitch = GetEditBoxHandle((m_Windowname $ ".ebLeftAttachRotationPitch"));
	m_hEbLeftRotYaw = GetEditBoxHandle((m_Windowname $ ".ebLeftAttachRotationYaw"));
	m_hEbLeftRotRoll = GetEditBoxHandle((m_Windowname $ ".ebLeftAttachRotationRoll"));
	m_hBtnLeftApplyAttachRotation = GetButtonHandle((m_Windowname $ ".btnLeftApplyAttachRotation"));
	m_hEbLeftOffsetX = GetEditBoxHandle((m_Windowname $ ".ebLeftAttachOffsetX"));
	m_hEbLeftOffsetY = GetEditBoxHandle((m_Windowname $ ".ebLeftAttachOffsetY"));
	m_hEbLeftOffsetZ = GetEditBoxHandle((m_Windowname $ ".ebLeftAttachOffsetZ"));
	m_hBtnLeftApplyOffset = GetButtonHandle((m_Windowname $ ".btnLeftApplyAttachOffset"));
	m_hEbLeftMantleOffsetX = GetEditBoxHandle((m_Windowname $ ".ebLeftMantleOffsetX"));
	m_hEbLeftMantleOffsetY = GetEditBoxHandle((m_Windowname $ ".ebLeftMantleOffsetY"));
	m_hEbLeftMantleOffsetZ = GetEditBoxHandle((m_Windowname $ ".ebLeftMantleOffsetZ"));
	m_hBtnLeftApplyMantleOffset = GetButtonHandle((m_Windowname $ ".btnLeftApplyMantleOffset"));
	m_hCbLeftSheathingHide = GetComboBoxHandle((m_Windowname $ ".cbLeftHideSheathing"));
	m_hEbRightAttachBoneName = GetEditBoxHandle((m_Windowname $ ".ebRightAttachBoneName"));
	m_hBtnRightApplyAttachBoneName = GetButtonHandle((m_Windowname $ ".btnRightApplyAttachBoneName"));
	m_hEbRightRotPitch = GetEditBoxHandle((m_Windowname $ ".ebRightAttachRotationPitch"));
	m_hEbRightRotYaw = GetEditBoxHandle((m_Windowname $ ".ebRightAttachRotationYaw"));
	m_hEbRightRotRoll = GetEditBoxHandle((m_Windowname $ ".ebRightAttachRotationRoll"));
	m_hBtnRightApplyAttachRotation = GetButtonHandle((m_Windowname $ ".btnRightApplyAttachRotation"));
	m_hEbRightOffsetX = GetEditBoxHandle((m_Windowname $ ".ebRightAttachOffsetX"));
	m_hEbRightOffsetY = GetEditBoxHandle((m_Windowname $ ".ebRightAttachOffsetY"));
	m_hEbRightOffsetZ = GetEditBoxHandle((m_Windowname $ ".ebRightAttachOffsetZ"));
	m_hBtnRightApplyOffset = GetButtonHandle((m_Windowname $ ".btnRightApplyAttachOffset"));
	m_hEbRightMantleOffsetX = GetEditBoxHandle((m_Windowname $ ".ebRightMantleOffsetX"));
	m_hEbRightMantleOffsetY = GetEditBoxHandle((m_Windowname $ ".ebRightMantleOffsetY"));
	m_hEbRightMantleOffsetZ = GetEditBoxHandle((m_Windowname $ ".ebRightMantleOffsetZ"));
	m_hBtnRightApplyMantleOffset = GetButtonHandle((m_Windowname $ ".btnRightApplyMantleOffset"));
	m_hCbRightSheathingHide = GetComboBoxHandle((m_Windowname $ ".cbRightHideSheathing"));
	m_hBtnPlaySheathingAnim = GetButtonHandle((m_Windowname $ ".btnPlaySheathingAnim"));
	return;
}

function OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		case 5160:
			m_hWnd.ShowWindow();
			break;
		case 5170:
			HandleSheathingInfo(param);
			break;
		default:
			break;
	}
	return;
}

function HandleSheathingInfo(string param)
{
	local string leftBoneName;
	local int leftRotPitch, leftRotYaw, leftRotRoll;
	local float leftOffsetX, leftOffsetY, leftOffsetZ, leftMantleOffsetX, leftMantleOffsetY, leftMantleOffsetZ;
	local int LeftHideSheathing;
	local string RightBoneName;
	local int RightRotPitch, RightRotYaw, RightRotRoll;
	local float RightOffsetX, RightOffsetY, RightOffsetZ, RightMantleOffsetX, RightMantleOffsetY, RightMantleOffsetZ;
	local int RightHideSheathing;

	ParseString(param, "LeftBoneName", leftBoneName);
	ParseInt(param, "LeftRotationPitch", leftRotPitch);
	ParseInt(param, "LeftRotationYaw", leftRotYaw);
	ParseInt(param, "LeftRotationRoll", leftRotRoll);
	ParseFloat(param, "LeftOffsetX", leftOffsetX);
	ParseFloat(param, "LeftOffsetY", leftOffsetY);
	ParseFloat(param, "LeftOffsetZ", leftOffsetZ);
	ParseFloat(param, "LeftMantleOffsetX", leftMantleOffsetX);
	ParseFloat(param, "LeftMantleOffsetY", leftMantleOffsetY);
	ParseFloat(param, "LeftMantleOffsetZ", leftMantleOffsetZ);
	ParseInt(param, "LeftHideSheathing", LeftHideSheathing);
	ParseString(param, "RightBoneName", RightBoneName);
	ParseInt(param, "RightRotationPitch", RightRotPitch);
	ParseInt(param, "RightRotationYaw", RightRotYaw);
	ParseInt(param, "RightRotationRoll", RightRotRoll);
	ParseFloat(param, "RightOffsetX", RightOffsetX);
	ParseFloat(param, "RightOffsetY", RightOffsetY);
	ParseFloat(param, "RightOffsetZ", RightOffsetZ);
	ParseFloat(param, "RightMantleOffsetX", RightMantleOffsetX);
	ParseFloat(param, "RightMantleOffsetY", RightMantleOffsetY);
	ParseFloat(param, "RightMantleOffsetZ", RightMantleOffsetZ);
	ParseInt(param, "RightHideSheathing", RightHideSheathing);
	m_hEbLeftAttachBoneName.SetString(leftBoneName);
	m_hEbLeftRotPitch.SetString(string(leftRotPitch));
	m_hEbLeftRotYaw.SetString(string(leftRotYaw));
	m_hEbLeftRotRoll.SetString(string(leftRotRoll));
	m_hEbLeftOffsetX.SetString(string(leftOffsetX));
	m_hEbLeftOffsetY.SetString(string(leftOffsetY));
	m_hEbLeftOffsetZ.SetString(string(leftOffsetZ));
	m_hEbLeftMantleOffsetX.SetString(string(leftMantleOffsetX));
	m_hEbLeftMantleOffsetY.SetString(string(leftMantleOffsetY));
	m_hEbLeftMantleOffsetZ.SetString(string(leftMantleOffsetZ));
	m_hCbLeftSheathingHide.SetSelectedNum(LeftHideSheathing);
	m_hEbRightAttachBoneName.SetString(RightBoneName);
	m_hEbRightRotPitch.SetString(string(RightRotPitch));
	m_hEbRightRotYaw.SetString(string(RightRotYaw));
	m_hEbRightRotRoll.SetString(string(RightRotRoll));
	m_hEbRightOffsetX.SetString(string(RightOffsetX));
	m_hEbRightOffsetY.SetString(string(RightOffsetY));
	m_hEbRightOffsetZ.SetString(string(RightOffsetZ));
	m_hEbRightMantleOffsetX.SetString(string(RightMantleOffsetX));
	m_hEbRightMantleOffsetY.SetString(string(RightMantleOffsetY));
	m_hEbRightMantleOffsetZ.SetString(string(RightMantleOffsetZ));
	m_hCbRightSheathingHide.SetSelectedNum(RightHideSheathing);
	return;
}

function OnClickButtonWithHandle(ButtonHandle a_WindowHandle)
{
	local string str1, str2, str3, str4, str5, str6;
	local float X, Y, Z;

	if((a_WindowHandle == m_hBtnLeftApplyAttachBoneName))
	{
		str1 = m_hEbLeftAttachBoneName.GetString();
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyLeftAttachBoneName(str1);
	}
	else if((a_WindowHandle == m_hBtnLeftApplyAttachRotation))
	{
		str1 = m_hEbLeftRotPitch.GetString();
		str2 = m_hEbLeftRotYaw.GetString();
		str3 = m_hEbLeftRotRoll.GetString();
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyLeftRotation(int(str1), int(str2), int(str3));
	}
	else if((a_WindowHandle == m_hBtnLeftApplyOffset))
	{
		str1 = m_hEbLeftOffsetX.GetString();
		str2 = m_hEbLeftOffsetY.GetString();
		str3 = m_hEbLeftOffsetZ.GetString();
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyLeftOffset(float(str1), float(str2), float(str3));
	}
	else if((a_WindowHandle == m_hBtnLeftApplyMantleOffset))
	{
		str1 = m_hEbLeftOffsetX.GetString();
		str2 = m_hEbLeftOffsetY.GetString();
		str3 = m_hEbLeftOffsetZ.GetString();
		str4 = m_hEbLeftMantleOffsetX.GetString();
		str5 = m_hEbLeftMantleOffsetY.GetString();
		str6 = m_hEbLeftMantleOffsetZ.GetString();
		X = (float(str1) + float(str4));
		Y = (float(str2) + float(str5));
		Z = (float(str3) + float(str6));
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyLeftOffset(X, Y, Z);
	}
	else if((a_WindowHandle == m_hBtnRightApplyAttachBoneName))
	{
		str1 = m_hEbRightAttachBoneName.GetString();
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyRightAttachBoneName(str1);
	}
	else if((a_WindowHandle == m_hBtnRightApplyAttachRotation))
	{
		str1 = m_hEbRightRotPitch.GetString();
		str2 = m_hEbRightRotYaw.GetString();
		str3 = m_hEbRightRotRoll.GetString();
		Debug(((((("" $ str1) $ ", ") $ str2) $ ", ") $ str3));
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyRightRotation(int(str1), int(str2), int(str3));
	}
	else if((a_WindowHandle == m_hBtnRightApplyOffset))
	{
		str1 = m_hEbRightOffsetX.GetString();
		str2 = m_hEbRightOffsetY.GetString();
		str3 = m_hEbRightOffsetZ.GetString();
		Debug(((((("" $ str1) $ ", ") $ str2) $ ", ") $ str3));
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyRightOffset(float(str1), float(str2), float(str3));
	}
	else if((a_WindowHandle == m_hBtnRightApplyMantleOffset))
	{
		str1 = m_hEbRightOffsetX.GetString();
		str2 = m_hEbRightOffsetY.GetString();
		str3 = m_hEbRightOffsetZ.GetString();
		str4 = m_hEbRightMantleOffsetX.GetString();
		str5 = m_hEbRightMantleOffsetY.GetString();
		str6 = m_hEbRightMantleOffsetZ.GetString();
		X = (float(str1) + float(str4));
		Y = (float(str2) + float(str5));
		Z = (float(str3) + float(str6));
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyRightOffset(X, Y, Z);
	}
	else if((a_WindowHandle == m_hBtnPlaySheathingAnim))
	{
		ExecuteCommand("///playsheathinganim");
	}
	return;
}

function OnComboBoxItemSelected(string strID, int Index)
{
	local bool bHide;

	switch(strID)
	{
		case "cbLeftHideSheathing":
			bHide = bool(m_hCbLeftSheathingHide.GetSelectedNum());
			Debug(("" $ string(bHide)));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyLeftSheathingHide(bHide);
			break;
		case "cbRightHideSheathing":
			bHide = bool(m_hCbRightSheathingHide.GetSelectedNum());
			Debug(("" $ string(bHide)));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyRightSheathingHide(bHide);
			break;
		default:
			break;
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if((int(nKey) == 13))
	{
	}
	return false;
}

defaultproperties
{
	m_Windowname="SheathingWnd"
}
