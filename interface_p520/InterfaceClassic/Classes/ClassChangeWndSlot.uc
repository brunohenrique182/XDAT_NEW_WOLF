class ClassChangeWndSlot extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle nameTextBox;
var TextureHandle classIconTex;
var TextureHandle historyIconTex;
var ButtonHandle slotBtn;

function Init(WindowHandle ownerWnd)
{
	local string ownerFullPath;

	Me = ownerWnd;
	ownerFullPath = ownerWnd.m_WindowNameWithFullPath;
	nameTextBox = GetTextBoxHandle((ownerFullPath $ ".ClassName_txt"));
	classIconTex = GetTextureHandle((ownerFullPath $ ".BtnClassMark_tex"));
	historyIconTex = GetTextureHandle((ownerFullPath $ ".HistoryIcon_tex"));
	slotBtn = GetButtonHandle((ownerFullPath $ ".Class_Btn"));
	return;
}

function SetInfo(ChangeClassData Info, bool isChangedBefore)
{
	nameTextBox.SetText(Info.ClassName);
	classIconTex.SetTexture(GetClassMarkSmallTextureName(Info.ClassID));
	if(isChangedBefore)
	{
		historyIconTex.ShowWindow();
		slotBtn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14921)));
	}
	else
	{
		historyIconTex.HideWindow();
		slotBtn.SetTooltipCustomType(MakeTooltipSimpleText(""));
	}
	Me.ShowWindow();
	return;
}

function string GetClassMarkSmallTextureName(int ClassID)
{
	return (("L2UI_NewTex.ClassChangeWnd.ClassChangeWnd_ClassMark_" $ string(ClassID)) $ "_Small");
}

function ResetInfo()
{
	Me.HideWindow();
	return;
}
