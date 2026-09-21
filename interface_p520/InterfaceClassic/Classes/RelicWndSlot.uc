class RelicWndSlot extends UICommonAPI;

var RelicWnd.RelicInfo _info;
var WindowHandle Me;
var TextBoxHandle upgradeTextBox;
var TextBoxHandle countTextBox;
var TextureHandle relicTex;
var TextureHandle gradeTex;
var TextureHandle reddotTex;
var TextureHandle activeOnTex;
var TextureHandle activeOffTex;
var TextureHandle newDotTex;
var TextureHandle newAnimTex;
var TextureHandle activeAnimTex;
var TextureHandle selectedTex;
var ButtonHandle slotBtn;

function Init(WindowHandle ownerWnd)
{
	local string ownerFullPath;

	Me = ownerWnd;
	ownerFullPath = ownerWnd.m_WindowNameWithFullPath;
	upgradeTextBox = GetTextBoxHandle((ownerFullPath $ ".UpgradeNumber_txt"));
	countTextBox = GetTextBoxHandle((ownerFullPath $ ".RelicNumber_txt"));
	relicTex = GetTextureHandle((ownerFullPath $ ".RelicItem_tex"));
	gradeTex = GetTextureHandle((ownerFullPath $ ".RelicCardBG_Tex"));
	activeOnTex = GetTextureHandle((ownerFullPath $ ".RelicOn_tex"));
	activeOffTex = GetTextureHandle((ownerFullPath $ ".RelicOff_tex"));
	newDotTex = GetTextureHandle((ownerFullPath $ ".Registration_tex"));
	newAnimTex = GetTextureHandle((ownerFullPath $ ".RegistrationAni_tex"));
	activeAnimTex = GetTextureHandle((ownerFullPath $ ".RelicOnStarAni_tex"));
	selectedTex = GetTextureHandle((ownerFullPath $ ".SelectTexture"));
	slotBtn = GetButtonHandle((ownerFullPath $ ".RelicSlot_btn"));
	return;
}

function SetInfo(RelicWnd.RelicInfo Info, optional bool isStaticMode, optional bool isUnkownItem)
{
	local ItemInfo relicItemInfo;
	local string levelStr, countStr;
	local bool isEnabled;

	_info = Info;
	isEnabled = Info.isEnabled;
	relicItemInfo = GetItemInfoByClassID(Info.Data.ItemID);
	if((isUnkownItem == true))
	{
		relicTex.SetTexture("L2UI_NewTex.RelicWnd.TradeSlotCover");
	}
	else
	{
		relicTex.SetTexture(relicItemInfo.IconName);
	}
	if(isStaticMode)
	{
		slotBtn.SetAlpha(0);
		activeOffTex.SetAlpha(0);
		selectedTex.SetAlpha(0);
		countTextBox.HideWindow();
		isEnabled = true;
	}
	else
	{
		slotBtn.SetAlpha(255);
		if((isEnabled == false))
		{
			countTextBox.HideWindow();
		}
		else
		{
			countTextBox.ShowWindow();
		}
	}
	if((Info.Level > 0))
	{
		levelStr = ("+" $ string(Info.Level));
	}
	if(Info.IsActive)
	{
		activeOnTex.ShowWindow();
		activeOffTex.HideWindow();
		activeAnimTex.ShowWindow();
	}
	else
	{
		activeOnTex.HideWindow();
		activeOffTex.ShowWindow();
		activeAnimTex.HideWindow();
	}
	if(Info.IsNew)
	{
		newDotTex.ShowWindow();
		newAnimTex.ShowWindow();
	}
	else
	{
		newDotTex.HideWindow();
		newAnimTex.HideWindow();
	}
	if((isEnabled && (Info.isStuffDisable == false)))
	{
		relicTex.SetAlpha(255);
		countTextBox.SetAlpha(255);
	}
	else
	{
		relicTex.SetAlpha(100);
		countTextBox.SetAlpha(100);
	}
	if((isUnkownItem == false))
	{
		slotBtn.SetTooltipCustomType(MakeTooltipSimpleColorText(getInstanceL2Util().GetDollNameWithGrade(relicItemInfo.Name, ERelicGrade(Info.Data.Grade)), getInstanceL2Util().GetRelicTextColor(ERelicGrade(Info.Data.Grade))));
	}
	if((Info.Count > INT64(999)))
	{
		countStr = "999+";
	}
	else
	{
		countStr = string(Info.Count);
	}
	upgradeTextBox.SetText(levelStr);
	countTextBox.SetText(("x" $ countStr));
	gradeTex.SetTexture(GetBackgroundTextureName(ERelicGrade(Info.Data.Grade), isEnabled));
	Me.ShowWindow();
	return;
}

function string GetBackgroundTextureName(UIConstants.ERelicGrade Grade, bool isEnable)
{
	if(isEnable)
	{
		switch(Grade)
		{
			case RG_N:
				return "L2UI_NewTex.RelicWnd.DollCard_N";
			case RG_D:
				return "L2UI_NewTex.RelicWnd.DollCard_D";
			case RG_C:
				return "L2UI_NewTex.RelicWnd.DollCard_C";
			case RG_B:
				return "L2UI_NewTex.RelicWnd.DollCard_B";
			case RG_A:
				return "L2UI_NewTex.RelicWnd.DollCard_A";
			case RG_S:
				return "L2UI_NewTex.RelicWnd.DollCard_S";
			case RG_R:
				return "L2UI_NewTex.RelicWnd.DollCard_R";
			default:
				break;
		}
	}
	else
	{
		switch(Grade)
		{
			case RG_N:
				return "L2UI_NewTex.RelicWnd.DollCardDis_N";
			case RG_D:
				return "L2UI_NewTex.RelicWnd.DollCardDis_D";
			case RG_C:
				return "L2UI_NewTex.RelicWnd.DollCardDis_C";
			case RG_B:
				return "L2UI_NewTex.RelicWnd.DollCardDis_B";
			case RG_A:
				return "L2UI_NewTex.RelicWnd.DollCardDis_A";
			case RG_S:
				return "L2UI_NewTex.RelicWnd.DollCardDis_S";
			case RG_R:
				return "L2UI_NewTex.RelicWnd.DollCardDis_R";
			default:
				break;
		}
	}
	return "";
}

function ResetInfo()
{
	local RelicWnd.RelicInfo defaultInfo;

	_info = defaultInfo;
	Me.HideWindow();
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	Debug(("RelicWndSlot OnClickButtonWithHandle" @ a_ButtonHandle.GetParentWindowName()));
	return;
}
