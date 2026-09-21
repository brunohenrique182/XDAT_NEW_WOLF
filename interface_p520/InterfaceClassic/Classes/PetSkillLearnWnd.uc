class PetSkillLearnWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var TextBoxHandle LearningSkillTitle_Text;
var ButtonHandle SkillLearnEnter_Btn;
var RichListCtrlHandle LearningSkillList_RichList;
var TextureHandle LearningSkillBG_tex;
var WindowHandle LearningSkillCondition_Window;
var TextBoxHandle LearningSkillCondition01_text;
var TextBoxHandle LearningSkillCondition02_text;
var TextBoxHandle NoCost_text;
var ItemWindowHandle SkillCostIcon01_ItemWindow;
var ItemWindowHandle SkillCostIcon02_ItemWindow;
var TextBoxHandle SkillCost01_Txt;
var TextBoxHandle SkillCost02_Txt;
var TextBoxHandle SkillMyCost01_Txt;
var TextBoxHandle SkillMyCost02_Txt;
var PetWndClassic petWndClassicScript;
var array<PetAcquireSkillInfo> arrAcquireSkill;
var int selectedListIndex;
var int needItemArrIndex;
var int beforeSelectedIndex;
var bool bLearningCondition;
//var delegate<OnSortCompare> __OnSortCompare__Delegate;

function OnRegisterEvent()
{
	RegisterEvent(9570);
	RegisterEvent(11480);
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("PetSkillLearnWnd");
	LearningSkillTitle_Text = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillTitle_Text");
	SkillLearnEnter_Btn = GetButtonHandle("PetSkillLearnWnd.SkillLearnEnter_Btn");
	NoCost_text = GetTextBoxHandle("PetSkillLearnWnd.NoCost_text");
	LearningSkillList_RichList = GetRichListCtrlHandle("PetSkillLearnWnd.LearningSkillList_RichList");
	LearningSkillBG_tex = GetTextureHandle("PetSkillLearnWnd.LearningSkillBG_tex");
	LearningSkillCondition_Window = GetWindowHandle("PetSkillLearnWnd.LearningSkillCondition_Window");
	LearningSkillCondition01_text = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.LearningSkillCondition01_text");
	LearningSkillCondition02_text = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.LearningSkillCondition02_text");
	SkillCostIcon01_ItemWindow = GetItemWindowHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCostIcon01_ItemWindow");
	SkillCostIcon02_ItemWindow = GetItemWindowHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCostIcon02_ItemWindow");
	SkillCost01_Txt = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCost01_Txt");
	SkillCost02_Txt = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCost02_Txt");
	SkillMyCost01_Txt = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillMyCost01_Txt");
	SkillMyCost02_Txt = GetTextBoxHandle("PetSkillLearnWnd.LearningSkillCondition_Window.SkillMyCost02_Txt");
	petWndClassicScript = PetWndClassic(GetScript("PetWndClassic"));
	LearningSkillList_RichList.SetSelectedSelTooltip(false);
	LearningSkillList_RichList.SetAppearTooltipAtMouseX(true);
	LearningSkillList_RichList.SetTooltipType("Skill");
	return;
}

function Load()
{
	return;
}

function OnShow()
{
	ClearAll();
	refreshAcquireSkill();
	return;
}

function refreshAcquireSkill()
{
	local int i;

	needItemArrIndex = -1;
	Class'NWindow.PetAPI'.static.GetPetAcquireSkillList(petWndClassicScript.nEvolvePetID, petWndClassicScript.nPetLevel, petWndClassicScript.nEvolutionStep, arrAcquireSkill);
	// arrAcquireSkill.Sort(OnSortCompare);   // array.Sort() unsupported by this compiler
	LearningSkillList_RichList.DeleteAllItem();
	i = 0;
	while((i < arrAcquireSkill.Length))
	{
		addSkillList(arrAcquireSkill[i].SkillID, arrAcquireSkill[i].SkillLevel, arrAcquireSkill[i].bEnable);
		i++;
	}
	if((arrAcquireSkill.Length > 0))
	{
		if((getSkillSelectedIndex() <= beforeSelectedIndex))
		{
			LearningSkillList_RichList.SetSelectedIndex(getSkillSelectedIndex(), true);
		}
		else
		{
			LearningSkillList_RichList.SetSelectedIndex(beforeSelectedIndex, true);
		}
		OnClickListCtrlRecord("LearningSkillList_RichList");
	}
	else
	{
		LearningSkillCondition01_text.SetText("");
		LearningSkillCondition02_text.SetText("");
		clearNeedCost();
	}
	return;
}

function int getSkillSelectedIndex()
{
	local int i;

	i = 0;
	while((i < arrAcquireSkill.Length))
	{
		if((arrAcquireSkill[i].bEnable == false))
		{
			if(((i - 1) >= 0))
			{
				return (i - 1);
				i++;
				continue;
			}
			return i;
		}
		i++;
	}
	if((i == 0))
	{
		return 0;
	}
	return (i - 1);
}

function updateNeedItem()
{
	local int i;
	local bool bUpgradeEnable;

	if(!Me.IsShowWindow())
	{
		return;
	}
	clearNeedCost();
	bUpgradeEnable = true;
	if(((needItemArrIndex > -1) && (arrAcquireSkill.Length > 0)))
	{
		if((arrAcquireSkill[needItemArrIndex].NeedItem.Length > 0))
		{
			i = 0;
			while((i < arrAcquireSkill[needItemArrIndex].NeedItem.Length))
			{
				setNeedCost((i + 1), arrAcquireSkill[needItemArrIndex].NeedItem[i].Id, arrAcquireSkill[needItemArrIndex].NeedItem[i].Amount);
				if((getInventoryItemNumByClassID(arrAcquireSkill[needItemArrIndex].NeedItem[i].Id) >= arrAcquireSkill[needItemArrIndex].NeedItem[i].Amount))
				{
					i++;
					continue;
				}
				bUpgradeEnable = false;
				i++;
			}
		}
	}
	if((arrAcquireSkill[needItemArrIndex].NeedItem.Length > 0))
	{
		NoCost_text.HideWindow();
	}
	else
	{
		NoCost_text.ShowWindow();
	}
	if((bUpgradeEnable && bLearningCondition))
	{
		SkillLearnEnter_Btn.EnableWindow();
	}
	else
	{
		SkillLearnEnter_Btn.DisableWindow();
	}
	return;
}

function int getSkillArrayIndex(int SkillID, int SkillLevel)
{
	local int i;

	i = 0;
	while((i < arrAcquireSkill.Length))
	{
		if(((arrAcquireSkill[i].SkillID == SkillID) && (arrAcquireSkill[i].SkillLevel == SkillLevel)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function setNeedCost(int SlotIndex, int ItemID, INT64 ItemCount)
{
	local TextBoxHandle myCostText, needCostText;
	local ItemWindowHandle SkillCostItemWindow;
	local TextureHandle SkillCostIconBg_Texture;
	local INT64 itemCountMine;
	local ItemInfo CostItem;

	needCostText = GetTextBoxHandle((("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCost0" $ string(SlotIndex)) $ "_Txt"));
	myCostText = GetTextBoxHandle((("PetSkillLearnWnd.LearningSkillCondition_Window.SkillMyCost0" $ string(SlotIndex)) $ "_Txt"));
	SkillCostItemWindow = GetItemWindowHandle((("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCostIcon0" $ string(SlotIndex)) $ "_ItemWindow"));
	SkillCostIconBg_Texture = GetTextureHandle((("PetSkillLearnWnd.LearningSkillCondition_Window.SkillCostIconBg0" $ string(SlotIndex)) $ "_Tex"));
	if((ItemID > 0))
	{
		CostItem = GetItemInfoByClassID(ItemID);
		needCostText.SetText(("x" $ MakeCostString(string(ItemCount))));
		SkillCostIconBg_Texture.ShowWindow();
		SkillCostItemWindow.ShowWindow();
		SkillCostItemWindow.Clear();
		SkillCostItemWindow.AddItem(CostItem);
		itemCountMine = GetInstanceL2UIInventory().GetInventoryItemCount(GetItemID(ItemID));
		myCostText.SetText((("(" $ MakeCostString(string(itemCountMine))) $ ")"));
		if((ItemCount > itemCountMine))
		{
			myCostText.SetTextColor(GTColor().DRed);
		}
		else
		{
			myCostText.SetTextColor(GTColor().BLUE01);
		}
	}
	else
	{
		needCostText.SetText("");
		myCostText.SetText("");
		SkillCostItemWindow.HideWindow();
		SkillCostItemWindow.Clear();
		SkillCostIconBg_Texture.HideWindow();
	}
	return;
}

function clearNeedCost()
{
	setNeedCost(1, 0, INT64(0));
	setNeedCost(2, 0, INT64(0));
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 11480:
			ParsePacket_S_EX_PET_SKILL_LIST(param);
			break;
		case 9570:
			updateNeedItem();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "SkillLearnEnter_Btn":
			OnSkillLearnEnter_BtnClick();
			break;
		case "Close_BTN":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnSkillLearnEnter_BtnClick()
{
	if((needItemArrIndex > -1))
	{
		if((arrAcquireSkill[needItemArrIndex].SkillID > 0))
		{
			beforeSelectedIndex = LearningSkillList_RichList.GetSelectedIndex();
			API_C_EX_ACQUIRE_PET_SKILL(arrAcquireSkill[needItemArrIndex].SkillID, arrAcquireSkill[needItemArrIndex].SkillLevel);
		}
		else
		{
			Debug(("SkillId 가 잘못되었습니다" @ string(arrAcquireSkill[needItemArrIndex].SkillID)));  // EN?: SkillId is invalid
		}
	}
	return;
}

function setLearningCondition(int nLevel, int evolStep)
{
	LearningSkillCondition01_text.SetText(("Lv : " $ MakeFullSystemMsg(GetSystemMessage(7028), string(nLevel))));
	LearningSkillCondition02_text.SetText(((GetSystemString(3792) $ " : ") $ MakeFullSystemMsg(GetSystemMessage(7028), (" " $ MakeFullSystemMsg(GetSystemMessage(5203), string(evolStep))))));
	bLearningCondition = true;
	if((petWndClassicScript.nPetLevel >= nLevel))
	{
		LearningSkillCondition01_text.SetTextColor(GTColor().White);
	}
	else
	{
		bLearningCondition = false;
		LearningSkillCondition01_text.SetTextColor(GTColor().Red);
	}
	if((petWndClassicScript.nEvolutionStep >= evolStep))
	{
		LearningSkillCondition02_text.SetTextColor(GTColor().White);
	}
	else
	{
		bLearningCondition = false;
		LearningSkillCondition02_text.SetTextColor(GTColor().Red);
	}
	if((arrAcquireSkill[needItemArrIndex].bEnable == false))
	{
		bLearningCondition = false;
	}
	return;
}

function API_C_EX_ACQUIRE_PET_SKILL(int SkillID, int skillLv)
{
	local array<byte> stream;
	local UIPacket._C_EX_ACQUIRE_PET_SKILL packet;

	packet.nSkillID = SkillID;
	packet.nSkillLv = skillLv;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_ACQUIRE_PET_SKILL(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(664, stream);
	return;
}

function ParsePacket_S_EX_PET_SKILL_LIST(string param)
{
	ClearAll();
	refreshAcquireSkill();
	return;
}

function addSkillList(int SkillID, int SkillLevel, bool bLearning)
{
	local RichListCtrlRowData rowData;
	local SkillInfo Info;
	local int nW, nH;
	local Color applyColor;

	rowData.cellDataList.Length = 1;
	if(GetSkillInfo(SkillID, SkillLevel, 0, Info))
	{
		if(bLearning)
		{
			applyColor = GTColor().White;
		}
		else
		{
			applyColor = GTColor().Gray;
		}
		GetTextSizeDefault(Info.SkillName, nW, nH);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, Info.TexName, 32, 32, 5);
		if((Info.IconPanel != ""))
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, Info.IconPanel, 32, 32, -32);
		}
		switch(Class'NWindow.UIDATA_SKILL'.static.GetAutomaticUseSkillType(GetItemID(SkillID)))
		{
			case AUST_BUFF_SKILL:
			case AUST_SEQUENTIAL_SKILL:
				addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "Icon.autoskill_panel_01", 32, 32, -32);
				break;
			default:
				break;
		}
		if(isActiveSkill(Info.IconType))
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -32);
		}
		else
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "l2ui_ct1.SkillWnd_DF_ListIcon_Passive", 32, 32, -32);
		}
		if((bLearning == false))
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.ItemWindow.ItemWindow_IconDisable", 32, 32, -32, 0);
		}
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, Info.SkillName, applyColor, false, 5, 1);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("Lv" $ string(SkillLevel)), applyColor, false, -nW, (nH + 2));
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "l2ui_ct1.SkillWnd_DF_ListIcon_MP", 16, 16, 5, 2);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, getInstanceL2Util().MakeTimeString1(float(Info.MpConsume)), applyColor, false, -2, -2);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "l2ui_ct1.SkillWnd_DF_ListIcon_use", 16, 16, 5, 2);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, getInstanceL2Util().MakeTimeString1((Info.HitTime + Info.CoolTime)), applyColor, false, -2, -2);
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "l2ui_ct1.SkillWnd_DF_ListIcon_Reuse", 16, 16, 5, 2);
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, getInstanceL2Util().MakeTimeString1(Info.ReuseDelay), applyColor, false, -2, -2);
		rowData.nReserved1 = INT64(SkillID);
		rowData.nReserved2 = INT64(SkillLevel);
		rowData.nReserved3 = INT64(0);
		LearningSkillList_RichList.InsertRecord(rowData);
	}
	return;
}

function OnClickListCtrlRecord(string strID)
{
	local int idx;
	local RichListCtrlRowData rowData;

	if((strID == "LearningSkillList_RichList"))
	{
		idx = LearningSkillList_RichList.GetSelectedIndex();
		if((idx <= -1))
		{
			return;
		}
		LearningSkillList_RichList.GetRec(idx, rowData);
		if((rowData.nReserved1 > INT64(-1)))
		{
			selectedListIndex = idx;
			needItemArrIndex = getSkillArrayIndex(int(rowData.nReserved1), int(rowData.nReserved2));
			setLearningCondition(arrAcquireSkill[needItemArrIndex].NeedPetLevel, arrAcquireSkill[needItemArrIndex].NeedPetEvolveStep);
			updateNeedItem();
		}
	}
	return;
}

delegate int OnSortCompare(PetAcquireSkillInfo A, PetAcquireSkillInfo B)
{
	if(((A.bEnable == false) && (B.bEnable == true)))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function ClearAll()
{
	LearningSkillList_RichList.DeleteAllItem();
	LearningSkillCondition01_text.SetText("");
	LearningSkillCondition02_text.SetText("");
	clearNeedCost();
	SkillLearnEnter_Btn.DisableWindow();
	return;
}

function OnHide()
{
	ClearAll();
	return;
}
