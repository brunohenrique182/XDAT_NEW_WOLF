class AbilitySlot extends UICommonAPI;

var WindowHandle Me;
var TextureHandle RelationShipLineTexture;
var TextureHandle skillIconTexture;
var TextureHandle Panel1Texture;
var TextureHandle SlotStateTexture;
var ButtonHandle SlotButton;
var TextureHandle DisableTexture;
var AnimTextureHandle SlotAnimTexture;
var TextBoxHandle UseApTextbox;
var AbilityUIWnd rootScript;
var int Category;
var int slotX;
var int slotY;
var int apApplied;
var int apUse;
var AbilityItemUIData Data;

function OnLoad()
{
	return;
}

function Init(WindowHandle Owner, AbilityUIWnd rootScr, int nCategory, int nSlotx, int nSlotY)
{
	local string ownerFullPath;

	rootScript = rootScr;
	ownerFullPath = Owner.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	RelationShipLineTexture = GetTextureHandle((ownerFullPath $ ".RelationShipLineTexture"));
	skillIconTexture = GetTextureHandle((ownerFullPath $ ".skillIconTexture"));
	Panel1Texture = GetTextureHandle((ownerFullPath $ ".Panel1Texture"));
	SlotStateTexture = GetTextureHandle((ownerFullPath $ ".SlotStateTexture"));
	SlotButton = GetButtonHandle((ownerFullPath $ ".SlotButton"));
	DisableTexture = GetTextureHandle((ownerFullPath $ ".DisableTexture"));
	SlotAnimTexture = GetAnimTextureHandle((ownerFullPath $ ".SlotAnimTexture"));
	UseApTextbox = GetTextBoxHandle((ownerFullPath $ ".UseApTextbox"));
	SlotAnimTexture.HideWindow();
	Category = nCategory;
	slotX = nSlotx;
	slotY = nSlotY;
	if(Class'NWindow.UIDataManager'.static.GetAbilityItem((nCategory + 1), nSlotY, nSlotx, Data))
	{
		Me.ShowWindow();
		skillIconTexture.SetTexture(Data.Icon);
		if(((Data.IconPanel == "") || (Data.IconPanel == "none")))
		{
			Panel1Texture.SetTexture("L2UI_ct1.Button.emptyBtn");
		}
		else
		{
			Panel1Texture.SetTexture(Data.IconPanel);
		}
	}
	else
	{
		Me.HideWindow();
		return;
	}
	_updateSlot();
	return;
}

function setSlotState(int nState)
{
	if((nState == 0))
	{
		SlotStateTexture.HideWindow();
	}
	else
	{
		switch(Category)
		{
			case 0:
				SlotStateTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityEffectRedAni00001");
				break;
			case 1:
				SlotStateTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityEffectBlueAni00001");
				break;
			case 2:
				SlotStateTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityEffectGreenAni00001");
				break;
			default:
				break;
		}
		SlotStateTexture.ShowWindow();
	}
	return;
}

function CustomTooltip getCustomToolTip()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local SkillInfo SkillInfo;
	local int i;
	local string Desc;

	drawListArr[drawListArr.Length] = addDrawItemText(Data.Name, GTColor().Orange2, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	if((Data.RequireCount > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemText((GetSystemString(3165) $ " : "), GTColor().White, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemText((((getCategoryName(Category) $ " (") $ string(Data.RequireCount)) $ "P)"), GTColor().Red2, "", false, true);
	}
	if((Data.RequireAbilityID > 0))
	{
		GetSkillInfo(Data.RequireAbilityID, 1, 0, SkillInfo);
		drawListArr[drawListArr.Length] = addDrawItemText((GetSystemString(3166) $ " : "), GTColor().White, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemText((((SkillInfo.SkillName $ " ") $ GetSystemString(88)) $ string(rootScript._findMaxRequireAbilityLev(Category, Data.RequireAbilityID))), GTColor().Red2, "", false, true);
	}
	i = 0;
	while((i < Data.LevelDesc.Length))
	{
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
		drawListArr[drawListArr.Length] = addDrawItemBlank(4);
		Desc = Substitute(Data.LevelDesc[i], "<br>", "\\n", false);
		if((_getCurrentAP() == (i + 1)))
		{
			drawListArr[drawListArr.Length] = addDrawItemText((GetSystemString(88) $ string((i + 1))), GTColor().Yellow, "", true, true);
			drawListArr[drawListArr.Length] = addDrawItemText(Desc, GTColor().Yellow, "", true, false);
			i++;
			continue;
		}
		drawListArr[drawListArr.Length] = addDrawItemText((GetSystemString(88) $ string((i + 1))), GTColor().BrightGray, "", true, true);
		drawListArr[drawListArr.Length] = addDrawItemText(Desc, GTColor().BrightGray, "", true, false);
		i++;
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function string getCategoryName(int nCategory)
{
	local string rName;

	switch(nCategory)
	{
		case 0:
			rName = GetSystemString(3153);
			break;
		case 1:
			rName = GetSystemString(3152);
			break;
		case 2:
			rName = GetSystemString(14294);
			break;
		default:
			break;
	}
	return rName;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	if(!_getIsLearn())
	{
		return;
	}
	if((Data.RequireCount > rootScript._getAPCategory(Category)))
	{
		return;
	}
	if((((apUse + apApplied) < Data.AbilityLev) && (rootScript._getAPTotal() > 0)))
	{
		apUse++;
		rootScript._useAP(Category);
		_updateSlot();
		rootScript._updateCategory(Category);
		switch(Category)
		{
			case 0:
				SlotAnimTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityGetEffectRedAni01");
				break;
			case 1:
				SlotAnimTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityGetEffectBlueAni01");
				break;
			case 2:
				SlotAnimTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityGetEffectGreenAni01");
				break;
			default:
				break;
		}
		AnimTexturePlay(SlotAnimTexture, true, 1);
		rootScript._callBackSlotClick(Category, slotX, slotY, Data.AbilityID);
	}
	return;
}

event OnRClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	if(!rootScript._checkEnableRClick(Category, slotY, Data.AbilityID))
	{
		return;
	}
	if((apUse > 0))
	{
		apUse--;
		rootScript._removeAP(Category);
		_updateSlot();
		rootScript._updateCategory(Category);
		rootScript._callBackSlotClick(Category, slotX, slotY, Data.AbilityID);
	}
	return;
}

function _cancelAP()
{
	apUse = 0;
	_updateSlot();
	return;
}

function _initAP(bool bNoUseAPInit)
{
	if((bNoUseAPInit == false))
	{
		apUse = 0;
	}
	apApplied = 0;
	_updateSlot();
	return;
}

function bool _isShow()
{
	return Me.IsShowWindow();
}

function bool _getIsLearn()
{
	return (Me.IsShowWindow() && !DisableTexture.IsShowWindow());
}

function _updateSlot()
{
	UseApTextbox.SetText(((string((apUse + apApplied)) $ "/") $ string(Data.AbilityLev)));
	if(((apUse + apApplied) == Data.AbilityLev))
	{
		UseApTextbox.SetTextColor(GetColor(255, 221, 102, 255));
	}
	else
	{
		UseApTextbox.SetTextColor(GetColor(255, 255, 255, 255));
	}
	if(((Data.RequireCount <= rootScript._getAPCategory(Category)) && (rootScript._findCurrentAP(Category, Data.RequireAbilityID) >= rootScript._findMaxRequireAbilityLev(Category, Data.RequireAbilityID))))
	{
		DisableTexture.HideWindow();
	}
	else
	{
		DisableTexture.ShowWindow();
	}
	if((apApplied > 0))
	{
		setSlotState(1);
	}
	else
	{
		setSlotState(0);
	}
	if((Data.RequireAbilityID > 0))
	{
		RelationShipLineTexture.ShowWindow();
		if(DisableTexture.IsShowWindow())
		{
			RelationShipLineTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityArrowDisable");
		}
		else
		{
			switch(Category)
			{
				case 0:
					RelationShipLineTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityArrowRed");
					break;
				case 1:
					RelationShipLineTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityArrowBlue");
					break;
				case 2:
					RelationShipLineTexture.SetTexture("L2UI_NewTex.AbilityWnd.AbilityArrowGreen");
					break;
				default:
					break;
			}
		}
	}
	else
	{
		RelationShipLineTexture.HideWindow();
	}
	SlotButton.SetTooltipCustomType(getCustomToolTip());
	return;
}

function int _getMaxAbilityLev(int RequireAbilityID)
{
	if((Data.AbilityID == RequireAbilityID))
	{
		return Data.AbilityLev;
	}
}

function int _getRequireAbilityID()
{
	return Data.RequireAbilityID;
}

function int _getAbilityLev()
{
	return Data.AbilityLev;
}

function int _getRequireCount()
{
	return Data.RequireCount;
}

function int _getAbilityID()
{
	return Data.AbilityID;
}

function int _getCurrentAP()
{
	return (apApplied + apUse);
}

function _setAppliedAP(int updateAp)
{
	apApplied = updateAp;
	if((apUse > 0))
	{
	}
	apUse = 0;
	rootScript._setCategoryApApplied(Category, updateAp);
	_updateSlot();
	return;
}

function int _getCurrentAppliedAP()
{
	return apApplied;
}

function int _getCurrentUseAP()
{
	return apUse;
}
