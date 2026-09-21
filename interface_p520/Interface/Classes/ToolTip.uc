class ToolTip extends UICommonAPI;

const TOOLTIP_MINIMUM_WIDTH = 154;
const TOOLTIP_MINIMUM_SETITEM_WIDTH = 200;
const TOOLTIP_SETITEM_MAX = 3;
const BIGSIZE_ICON_ADD = 16;
const TOOLTIP_LINE_HGAP = 2;
const ATTRIBUTE_FIRE = 0;
const ATTRIBUTE_WATER = 1;
const ATTRIBUTE_WIND = 2;
const ATTRIBUTE_EARTH = 3;
const ATTRIBUTE_HOLY = 4;
const ATTRIBUTE_UNHOLY = 5;

var int MACROCOMMAND_MAX_COUNT;
var CustomTooltip m_Tooltip;
var DrawItemInfo m_Info;
var array<int> AttackAttLevel;
var array<int> AttackAttCurrValue;
var array<int> AttackAttMaxValue;
var array<int> DefAttLevel;
var array<int> DefAttCurrValue;
var array<int> DefAttMaxValue;
var int NowAttrLv;
var int NowMaxValue;
var int NowValue;
var bool BoolSelect;
var bool bLine;
var TextBoxHandle ItemCountText;

function OnRegisterEvent()
{
	RegisterEvent(2960);
	return;
}

function OnLoad()
{
	BoolSelect = true;
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2960:
			HandleRequestTooltipInfo(param);
			break;
		default:
			break;
	}
	return;
}

function setBoolSelect(bool B)
{
	BoolSelect = B;
	return;
}

function HandleRequestTooltipInfo(string param)
{
	local string TooltipType;
	local int SourceType;
	local UIEventManager.ETooltipSourceType eSourceType;

	ClearTooltip();
	if(!ParseString(param, "TooltipType", TooltipType))
	{
		return;
	}
	if(!ParseInt(param, "SourceType", SourceType))
	{
		return;
	}
	eSourceType = ETooltipSourceType(SourceType);
	if((TooltipType == "Text"))
	{
		ReturnTooltip_NTT_TEXT(param, eSourceType, false);
	}
	else if((TooltipType == "Description"))
	{
		ReturnTooltip_NTT_TEXT(param, eSourceType, true);
	}
	else if((TooltipType == "Action"))
	{
		ReturnTooltip_NTT_ACTION(param, eSourceType);
	}
	else if((TooltipType == "TeleportAction"))
	{
		ReturnTooltip_NTT_ACTION(param, eSourceType);
	}
	else if((TooltipType == "Macro"))
	{
		ReturnTooltip_NTT_MACRO(param, eSourceType);
	}
	else if((TooltipType == "Skill"))
	{
		ReturnTooltip_NTT_SKILL(param, eSourceType);
	}
	else if((TooltipType == "NormalItem"))
	{
		ReturnTooltip_NTT_NORMALITEM(param, eSourceType);
	}
	else if((TooltipType == "PremiumNormalItem"))
	{
		ReturnTooltip_NTT_PREMIUMNORMALITEM(param, eSourceType);
	}
	else if((TooltipType == "Shortcut"))
	{
		ReturnTooltip_NTT_SHORTCUT(param, eSourceType);
	}
	else if((TooltipType == "AbnormalStatus"))
	{
		ReturnTooltip_NTT_ABNORMALSTATUS(param, eSourceType);
	}
	else if((TooltipType == "RecipeManufacture"))
	{
		ReturnTooltip_NTT_RECIPE_MANUFACTURE(param, eSourceType);
	}
	else if((TooltipType == "Recipe"))
	{
		ReturnTooltip_NTT_RECIPE(param, eSourceType, false);
	}
	else if((TooltipType == "RecipePrice"))
	{
		ReturnTooltip_NTT_RECIPE(param, eSourceType, true);
	}
	else if(((((((((((((((((TooltipType == "Inventory") || (TooltipType == "InventoryPrice1")) || (TooltipType == "InventoryPrice2")) || (TooltipType == "InventoryPrice1HideEnchant")) || (TooltipType == "InventoryPrice1HideEnchantStackable")) || (TooltipType == "InventoryPrice2PrivateShop")) || (TooltipType == "InventoryWithIcon")) || (TooltipType == "InventoryPawnViewer")) || (TooltipType == "HtmlViewer")) || (TooltipType == "InventoryPet")) || (TooltipType == "EnsoulSlot")) || (TooltipType == "WorldExchange")) || (TooltipType == "InventoryNeedItem")) || (TooltipType == "InventoryAgathionEct")) || (TooltipType == "RankingItemRewardOn")) || (TooltipType == "RankingItemRewardOff")))
	{
		ReturnTooltip_NTT_ITEM(param, TooltipType, eSourceType);
	}
	else if((TooltipType == "RoomList"))
	{
		ReturnTooltip_NTT_ROOMLIST(param, eSourceType);
	}
	else if((TooltipType == "UserList"))
	{
		ReturnTooltip_NTT_USERLIST(param, eSourceType);
	}
	else if((TooltipType == "PartyMatch"))
	{
		ReturnTooltip_NTT_PARTYMATCH(param, eSourceType);
	}
	else if((TooltipType == "UnionList"))
	{
		ReturnTooltip_NTT_UNIONLIST(param, eSourceType);
	}
	else if((TooltipType == "QuestInfo"))
	{
		ReturnTooltip_NTT_QUESTINFO(param, eSourceType);
	}
	else if((TooltipType == "QuestList"))
	{
		ReturnTooltip_NTT_QUESTLIST(param, eSourceType);
	}
	else if((TooltipType == "RaidList"))
	{
		ReturnTooltip_NTT_RAIDLIST(param, eSourceType);
	}
	else if((TooltipType == "ClanInfo"))
	{
		ReturnTooltip_NTT_CLANINFO(param, eSourceType);
	}
	else if((TooltipType == "FriendInfo"))
	{
		ReturnTooltip_NTT_FRIENDINFO(param, eSourceType);
	}
	else if((TooltipType == "ClanWarInfo"))
	{
		ReturnTooltip_NTT_CLANWARINFO(param, eSourceType);
	}
	else if((TooltipType == "ClanWarList"))
	{
		ReturnTooltip_NTT_CLANWARList(param, eSourceType);
	}
	else if((TooltipType == "EllipsedList"))
	{
		ReturnTooltip_NTT_EllipsedList(param, eSourceType);
	}
	else if((TooltipType == "EllipsedQuest"))
	{
		ReturnTooltip_NTT_EllipsedQuest(param, eSourceType);
	}
	else if((TooltipType == "SellItemList"))
	{
		ReturnTooltip_NTT_SellItemList(param, eSourceType);
	}
	else if((TooltipType == "UIControlNeedItemList"))
	{
		ReturnTooltip_NTT_UIControlNeedItemList(param, eSourceType);
	}
	else if((TooltipType == "EnsoulOptionType"))
	{
		ReturnTooltip_NTT_EnsoulOptionList(param, eSourceType);
	}
	else if((TooltipType == "AgitDecoListType"))
	{
		ReturnTooltip_NTT_AgitDecoList(param, eSourceType);
	}
	else if((TooltipType == "PostInfo"))
	{
		ReturnTooltip_NTT_POSTINFO(param, eSourceType);
	}
	else if(((((((TooltipType == "ManorSeedInfo") || (TooltipType == "ManorCropInfo")) || (TooltipType == "ManorSeedSetting")) || (TooltipType == "ManorCropSetting")) || (TooltipType == "ManorDefaultInfo")) || (TooltipType == "ManorCropSell")))
	{
		ReturnTooltip_NTT_MANOR(param, TooltipType, eSourceType);
	}
	else if((TooltipType == "QuestItem"))
	{
		ReturnTooltip_NTT_QUESTREWARDS(param, eSourceType);
	}
	else if((TooltipType == "GFxCardItem"))
	{
		ReturnTooltip_NTT_GFXCARD(param, eSourceType);
	}
	else if((TooltipType == "UserFakeInfo"))
	{
		ReturnTooltip_NTT_CHAT_USERFAKEINFO(param, eSourceType);
	}
	else if((TooltipType == "LookChangeItem"))
	{
		ReturnTooltip_NTT_LOOCKCHANGEITEM(param);
	}
	else if((TooltipType == "InventoryStackableUnitPrice"))
	{
		ReturnTooltip_NTT_ITEM(param, TooltipType, NTST_ITEM);
	}
	else if((TooltipType == "RegionInfo"))
	{
		ReturnTooltip_NTT_MAP_REGIONINFO(param, eSourceType);
	}
	else if((TooltipType == "GfxCustomTooltip"))
	{
		ReturnTooltip_NTT_GFxTooltip(param);
	}
	else if((TooltipType == "privateShopHistory"))
	{
		ReturnTooltip_NTT_PrivateShopHistory(param);
	}
	else if((TooltipType == "DevToolDebug"))
	{
		ReturnTooltip_DevToolDebug(param);
	}
	else if((TooltipType == "CursedWeapon"))
	{
		Debug(("CursedWeapon :" @ param));
		ReturnTooltip_CursedWeapon(param);
	}
	else if((TooltipType == "PrivateShopFind"))
	{
		ReturnTooltip_PrivateShopFind(param, eSourceType);
	}
	else if((TooltipType == "WorldExchangeBuyWnd"))
	{
		ReturnTooltip_WorldExchangeHistory(param, eSourceType);
	}
	else if((TooltipType == "RankingReward"))
	{
		ReturnTooltip_RankingReward_Character(param, eSourceType);
	}
	else if((TooltipType == "RankingRewardInstanceZone"))
	{
		ReturnTooltip_RankingReward_InstanceZone(param, eSourceType);
	}
	else if((TooltipType == "SuppressRichList"))
	{
		ReturnTooltip_SuppressRichList(param, eSourceType);
	}
	else if((TooltipType == "RankingPet"))
	{
		ReturnTooltip_RankingPet(param, eSourceType);
	}
	else if((TooltipType == "RankingPvp"))
	{
		ReturnTooltip_RankingPvp(param, eSourceType);
	}
	else if((TooltipType == "RankingOlympiad"))
	{
		ReturnTooltip_RankingOlympiad(param, eSourceType);
	}
	else if((TooltipType == "SimpleRichListTooltip"))
	{
		ReturnTooltip_SimpleRichListTooltip(param, eSourceType);
	}
	else if((TooltipType == "DethroneMissionTooltip"))
	{
		ReturnTooltip_DethroneMissionTooltip(param, eSourceType);
	}
	else if((TooltipType == "Revenge"))
	{
		ReturnTooltip_Revenge(param, eSourceType);
	}
	else if((TooltipType == "RevengeHelp"))
	{
		ReturnTooltip_RevengeHelp(param, eSourceType);
	}
	else if((TooltipType == "ShopLcoinCraftTooltip"))
	{
		ReturnTooltip_ShopLcoinCraftTooltip(param, eSourceType);
	}
	else if((TooltipType == "CollectionSystemListTooltip"))
	{
		ReturnTooltip_CollectionSystemListTooltip(param, eSourceType);
	}
	else if((TooltipType == "CollectionSystemOptionListTooltip"))
	{
		ReturnTooltip_CollectionSystemOptionListTooltip(param, eSourceType);
	}
	else if((TooltipType == "L2PassAdvanceListTooltip"))
	{
		ReturnTooltip_L2PassAdvanceListTooltip(param, eSourceType);
	}
	else if((TooltipType == "FightInfo"))
	{
		ReturnTooltip_FightInfo(param, eSourceType);
	}
	else if((TooltipType == "TeleportWndListTooltip"))
	{
		ReturnTooltip_TeleportWndListTooltip(param, eSourceType);
	}
	else if((TooltipType == "SkillLearnCostListTooltip"))
	{
		ReturnTooltip_SkillLearnCostListTooltip(param, eSourceType);
	}
	else if((TooltipType == "VirtualItemListTooltip"))
	{
		ReturnTooltip_VirtualItemListTooltip(param, eSourceType);
	}
	else if((TooltipType == "PetSkillLearnCostListTooltip"))
	{
		ReturnTooltip_PetSkillLearnCostListTooltip(param, eSourceType);
	}
	else if((TooltipType == "DetailTooltipList"))
	{
		ReturnTooltip_DetailTooltipList(param, TooltipType, eSourceType);
	}
	else if((TooltipType == "RelicSummonListTooltip"))
	{
		ReturnTooltip_RelicSummonListTooltip(param, TooltipType, eSourceType);
	}
	return;
}

function ReturnTooltip_DetailTooltipList(string param, string TooltipType, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int ItemClassID;
	local ItemInfo ItemInfo;
	local string itemParam;

	ParamToRecord(param, Record);
	if((Record.nReserved1 > INT64(0)))
	{
		ItemClassID = int(Record.nReserved1);
		ItemInfo = GetItemInfoByClassID(ItemClassID);
		if((Record.nReserved2 > INT64(0)))
		{
			ItemInfo.Enchanted = int(Record.nReserved2);
		}
		ItemInfoToParam(ItemInfo, itemParam);
		ReturnTooltip_NTT_ITEM(itemParam, TooltipType, eSourceType);
	}
	return;
}

function ReturnTooltip_L2PassAdvanceListTooltip(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local bool isTitleRecord;
	local int ItemID;
	local ItemInfo advanceItemInfo;
	local string itemParam, textParam;

	ParamToRecord(param, Record);
	if((Record.nReserved1 == INT64(0)))
	{
		isTitleRecord = true;
	}
	if((isTitleRecord == true))
	{
		ParamAdd(textParam, "text", Record.szReserved);
		ReturnTooltip_NTT_TEXT(textParam, NTST_TEXT, false);
	}
	else
	{
		ItemID = int(Record.nReserved2);
		advanceItemInfo = GetItemInfoByClassID(ItemID);
		ItemInfoToParam(advanceItemInfo, itemParam);
		ReturnTooltip_NTT_ITEM(itemParam, "inventory", NTST_LIST);
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_FightInfo(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = 220;
	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		if((Record.szReserved != ""))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.szReserved, getInstanceL2Util().White, "", true, true));
		}
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_TeleportWndListTooltip(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local int isFavorites;

	if((int(eSourceType) == 3))
	{
		ParseInt(param, "ReservedID", isFavorites);
		if((isFavorites == 0))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13306), getInstanceL2Util().Blue, "", true, true));
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13307), getInstanceL2Util().Red, "", true, true));
		}
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_SkillLearnCostListTooltip(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int ConsumePriorityItemID, ConsumeItemID, SystemMsgID;
	local ItemInfo tmpItemInfo;

	ParamToRecord(param, Record);
	ParseInt(param, "nReserved1", ConsumePriorityItemID);
	ParseInt(param, "nReserved2", ConsumeItemID);
	ParseInt(param, "nReserved3", SystemMsgID);
	if((ConsumePriorityItemID > 0))
	{
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_NewTex.SkillWnd.Icon_Substitution", false, false, 0, 0, 16, 16, 20, 20));
		addToolTipDrawList(m_Tooltip, addDrawItemText((GetSystemString(14395) $ ":"), getInstanceL2Util().White, "", false, true));
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ConsumePriorityItemID), tmpItemInfo);
		addToolTipDrawList(m_Tooltip, addDrawItemText(tmpItemInfo.Name, getInstanceL2Util().Gold, "", true, true));
		if((Len(tmpItemInfo.AdditionalName) > 0))
		{
			AddTooltipColorText(tmpItemInfo.AdditionalName, GetColor(255, 217, 105, 255), false, true, true, "", 4);
		}
		AddTooltipColorText((("(" $ GetSystemString(14401)) $ ")"), GetColor(255, 101, 101, 255), false, true, true, "", 4);
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ConsumeItemID), tmpItemInfo);
		addToolTipDrawList(m_Tooltip, addDrawItemText(tmpItemInfo.Name, getInstanceL2Util().Gold, "", true, true));
		if((Len(tmpItemInfo.AdditionalName) > 0))
		{
			AddTooltipColorText(tmpItemInfo.AdditionalName, GetColor(255, 217, 105, 255), false, true, true, "", 4);
		}
	}
	if((ConsumeItemID > 0))
	{
		if((ConsumePriorityItemID > 0))
		{
			AddCrossLine();
		}
		if((SystemMsgID > 0))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_NewTex.SkillWnd.Icon_Help", false, false, 0, 0, 16, 16, 20, 20));
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemMessage(SystemMsgID), getInstanceL2Util().White, "", false, true));
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_NewTex.SkillWnd.Icon_Magnifier", false, false, 0, 0, 16, 16, 20, 20));
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14394), getInstanceL2Util().White, "", false, true));
		}
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_VirtualItemListTooltip(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local int isEquip;

	if((int(eSourceType) == 3))
	{
		ParseInt(param, "ReservedID", isEquip);
		if((isEquip == 0))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(5293), getInstanceL2Util().Blue, "", true, true));
		}
	}
	else if((int(eSourceType) == 2))
	{
		ReturnTooltip_NTT_ITEM(param, "inventory", NTST_LIST);
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_PetSkillLearnCostListTooltip(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int ConsumePriorityItemID, ConsumeItemID;
	local ItemInfo tmpItemInfo;

	ParamToRecord(param, Record);
	ParseInt(param, "nReserved1", ConsumePriorityItemID);
	ParseInt(param, "nReserved2", ConsumeItemID);
	if((ConsumePriorityItemID > 0))
	{
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_NewTex.SkillWnd.Icon_Substitution", false, false, 0, 0, 16, 16, 20, 20));
		addToolTipDrawList(m_Tooltip, addDrawItemText((GetSystemString(14395) $ ":"), getInstanceL2Util().White, "", false, true));
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ConsumePriorityItemID), tmpItemInfo);
		addToolTipDrawList(m_Tooltip, addDrawItemText(tmpItemInfo.Name, getInstanceL2Util().Gold, "", true, true));
		if((Len(tmpItemInfo.AdditionalName) > 0))
		{
			AddTooltipColorText(tmpItemInfo.AdditionalName, GetColor(255, 217, 105, 255), false, true, true, "", 4);
		}
		AddTooltipColorText((("(" $ GetSystemString(14401)) $ ")"), GetColor(255, 101, 101, 255), false, true, true, "", 4);
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ConsumeItemID), tmpItemInfo);
		addToolTipDrawList(m_Tooltip, addDrawItemText(tmpItemInfo.Name, getInstanceL2Util().Gold, "", true, true));
		if((Len(tmpItemInfo.AdditionalName) > 0))
		{
			AddTooltipColorText(tmpItemInfo.AdditionalName, GetColor(255, 217, 105, 255), false, true, true, "", 4);
		}
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_CollectionSystemOptionListTooltip(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int Period, CollectionID;
	local CollectionInfo cInfo;
	local string remainTimeString;

	m_Tooltip.MinimumWidth = 154;
	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		Period = int(Record.nReserved2);
		if((Period == 0))
		{
			return;
		}
		CollectionID = int(Record.nReserved1);
		if(!CollectionSystem(GetScript("CollectionSystem")).API_GetCollectionInfo(CollectionID, cInfo))
		{
			return;
		}
		addTooltipTexture("L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 11, 11, 11, 11, true, false);
		remainTimeString = CollectionSystemPopupDetails(GetScript("CollectionSystem.CollectionSystemPopupDetails")).GetRemainTimeString(Period, cInfo.RemainTime);
		AddTooltipColorText(remainTimeString, getInstanceL2Util().Yellow, false, true, false);
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_CollectionSystemListTooltip(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local CollectionData cData;
	local CollectionInfo cInfo;
	local int CollectionID;
	local string remainTimeString, TooltipDesc;

	m_Tooltip.MinimumWidth = 154;
	ParamToRecord(param, Record);
	CollectionID = int(Record.nReserved1);
	if((int(eSourceType) == 2))
	{
		if(!GetCollectionData(CollectionID, cData))
		{
			return;
		}
		AddTooltipText(cData.collection_name, true, true);
		if((cData.endDateTime != ""))
		{
			AddTooltipColorText(CollectionSystemPopupDetails(GetScript("CollectionSystem.CollectionSystemPopupDetails")).GetEndDateTime(cData.endDateTime), GetColor(255, 221, 102, 255), true, true);
		}
		AddTooltipColorText(CollectionSystemSub(GetScript("CollectionSystem.CollectionSystemSub")).GetOptionByOptionID(cData.option_id), getInstanceL2Util().ColorGold, true, true);
		if(!CollectionSystem(GetScript("CollectionSystem")).API_GetCollectionInfo(CollectionID, cInfo))
		{
			return;
		}
		if((cData.bDurationEvent == true))
		{
			remainTimeString = CollectionSystemPopupDetails(GetScript("CollectionSystem.CollectionSystemPopupDetails"))._GetResetTimeString(cInfo.RemainTime);
		}
		else if((cData.Period > 0))
		{
			remainTimeString = CollectionSystemPopupDetails(GetScript("CollectionSystem.CollectionSystemPopupDetails")).GetRemainTimeString(cData.Period, cInfo.RemainTime);
		}
		if((remainTimeString != ""))
		{
			addTooltipTexture("L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 11, 11, 11, 11, true, true, 0, 2);
			if((cInfo.RemainTime > 0))
			{
				AddTooltipColorText(remainTimeString, getInstanceL2Util().Yellow, false, true, false);
			}
			else
			{
				AddTooltipColorText(remainTimeString, getInstanceL2Util().Gray, false, true, false);
			}
		}
	}
	else
	{
		ParseString(param, "TooltipDesc", TooltipDesc);
		if((TooltipDesc != ""))
		{
			AddTooltipText(GetSystemString(14875), true, true);
		}
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_ShopLcoinCraftTooltip(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local int ItemCount, countCost, i;
	local INT64 ItemAmount, CostItemAmount;
	local ItemID tmpItemID;
	local int itemEnchant, costItemEnchant, costItemBlessed;
	local ItemInfo peeItemInfo, tmpItemInfo;
	local string autoUsePanel;

	m_Tooltip.MinimumWidth = 154;
	if((int(eSourceType) == 3))
	{
	}
	else if((int(eSourceType) == 2))
	{
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13278), getInstanceL2Util().Yellow, "", true, true));
		AddTooltipItemBlank(4);
		ParseInt(param, "itemCount", ItemCount);
		i = 0;
		while((i < ItemCount))
		{
			ParseInt(param, ("itemCount" $ string(i)), ItemCount);
			ParseInt(param, ("buyItem" $ string(i)), tmpItemID.ClassID);
			ParseInt(param, ("buyItemEnchant" $ string(i)), itemEnchant);
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(tmpItemID, tmpItemInfo);
			tmpItemInfo.Enchanted = itemEnchant;
			addItemIcon(tmpItemInfo, "");
			AddItemEnchantedImg(itemEnchant);
			AddTooltipColorText(tmpItemInfo.Name, getInstanceL2Util().Gold, true, true, true, "", 36, -31);
			if((Len(tmpItemInfo.AdditionalName) > 0))
			{
				AddTooltipColorText(tmpItemInfo.AdditionalName, GetColor(255, 217, 105, 255), false, true, true, "", 6, -31);
			}
			ParseINT64(param, ("buyItemCount" $ string(i)), ItemAmount);
			addToolTipDrawList(m_Tooltip, addDrawItemText(("x" $ MakeCostStringINT64(ItemAmount)), getInstanceL2Util().BWhite, "", true, true, 36, -16));
			AddTooltipItemBlank(4);
			i++;
		}
		AddCrossLine();
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13184), getInstanceL2Util().Yellow, "", true, true));
		AddTooltipItemBlank(4);
		ParseInt(param, "countCost", countCost);
		i = 0;
		while((i < countCost))
		{
			ParseInt(param, ("costItemID" $ string(i)), tmpItemID.ClassID);
			if((-800 == tmpItemID.ClassID))
			{
				addTexture("Icon.etc_sayha_point_01", 32, 32, 32, 32, 0, 0);
				AddTooltipColorText(GetSystemString(2492), getInstanceL2Util().BrightWhite, true, true, true, "", 36, -31);
				ParseINT64(param, ("costItemAmout" $ string(i)), CostItemAmount);
				addToolTipDrawList(m_Tooltip, addDrawItemText(("x" $ MakeCostStringINT64(CostItemAmount)), getInstanceL2Util().White, "", true, true, 36, -16));
			}
			else
			{
				Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(tmpItemID, peeItemInfo);
				ParseInt(param, ("costItemEnchant" $ string(i)), costItemEnchant);
				peeItemInfo.Enchanted = costItemEnchant;
				ParseInt(param, ("costItemBlessed" $ string(i)), costItemBlessed);
				peeItemInfo.IsBlessedItem = bool(costItemBlessed);
				switch(Class'NWindow.UIDATA_ITEM'.static.GetAutomaticUseItemType(tmpItemID.ClassID))
				{
					case AUIT_ITEM:
						autoUsePanel = "Icon.autoskill_panel_01";
						break;
					default:
						break;
				}
				addItemIcon(peeItemInfo, peeItemInfo.ForeTexture, autoUsePanel);
				AddItemEnchantedImg(costItemEnchant);
				AddTooltipColorText(peeItemInfo.Name, getInstanceL2Util().BrightWhite, true, true, true, "", 36, -31);
				if((Len(peeItemInfo.AdditionalName) > 0))
				{
					AddTooltipColorText(peeItemInfo.AdditionalName, GetColor(255, 217, 105, 255), false, true, true, "", 6, -31);
				}
				ParseINT64(param, ("costItemAmout" $ string(i)), CostItemAmount);
				addToolTipDrawList(m_Tooltip, addDrawItemText(("x" $ MakeCostStringINT64(CostItemAmount)), getInstanceL2Util().White, "", true, true, 36, -16));
			}
			AddTooltipItemBlank(4);
			i++;
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_Revenge(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = 154;
	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText((Record.LVDataList[2].szData $ " "), GetColor(187, 170, 136, 255), "", false, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().BWhite, "", false, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(((" (" $ Record.LVDataList[1].szData) $ ")"), getInstanceL2Util().ColorLightBrown, "", false, true));
		if((Record.LVDataList[5].szData == "2"))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(347), getInstanceL2Util().Yellow, "", true, true));
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(348), getInstanceL2Util().Gray, "", true, true));
		}
		ReturnTooltipInfo(m_Tooltip);
		return;
	}
	return;
}

function ReturnTooltip_RevengeHelp(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = 154;
	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText((GetSystemString(13505) $ " "), GetColor(187, 170, 136, 255), "", false, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(((GetSystemString(88) $ string(Record.LVDataList[1].nReserved1)) $ " "), GetColor(187, 170, 136, 255), "", true, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().BWhite, "", false, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[1].szData, getInstanceL2Util().ColorLightBrown, "", true, true));
		if((Record.LVDataList[5].szData != ""))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(((Record.LVDataList[5].szData $ " ") $ GetSystemString(314)), getInstanceL2Util().BWhite, "", true, true));
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText((GetSystemString(431) $ " "), GetColor(187, 170, 136, 255), "", true, true));
		}
		ReturnTooltipInfo(m_Tooltip);
		return;
	}
	return;
}

function ReturnTooltip_SimpleRichListTooltip(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local string TooltipDesc;

	m_Tooltip.MinimumWidth = 50;
	if((int(eSourceType) == 3))
	{
		ParseString(param, "TooltipDesc", TooltipDesc);
		if((TooltipDesc != ""))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(TooltipDesc, getInstanceL2Util().White, "", true, true));
		}
	}
	else if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		if((Record.szReserved != ""))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.szReserved, getInstanceL2Util().White, "", true, true));
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_DethroneMissionTooltip(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local string TooltipDesc;
	local DethroneDailyMissionData missionData;

	if((int(eSourceType) == 3))
	{
		m_Tooltip.MinimumWidth = 50;
		ParseString(param, "TooltipDesc", TooltipDesc);
		if((TooltipDesc != ""))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(TooltipDesc, getInstanceL2Util().White, "", true, true));
		}
	}
	else if((int(eSourceType) == 2))
	{
		m_Tooltip.MinimumWidth = 260;
		ParamToRecord(param, Record);
		GetDethroneDailyMissionData(int(Record.nReserved1), missionData);
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14314), GTColor().White, "", true, true));
		AddCrossLine();
		addToolTipDrawList(m_Tooltip, addDrawItemText(missionData.ProgressDetailDesc, GTColor().ColorDesc, "", true, false));
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_RankingPvp(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = 154;
	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[1].szData, getInstanceL2Util().Yellow, "", false, false));
		addToolTipDrawList(m_Tooltip, addDrawItemText((" " $ Record.LVDataList[0].szData), getInstanceL2Util().BWhite, "", false, true));
		AddCrossLine();
		AddTooltipItemOption(164, Record.LVDataList[4].szData, true, true, false);
		AddTooltipItemOption(2290, Record.LVDataList[2].szData, true, true, false);
		AddTooltipItemOption(439, Record.LVDataList[3].szData, true, true, false);
		AddTooltipItemBlank(4);
		addToolTipDrawList(m_Tooltip, addDrawItemText((GetSystemString(2240) $ " : "), GTColor().Blue, "", true, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText((MakeCostStringINT64(Record.nReserved1) $ "  "), GTColor().Sandrift, "", false, false));
		addToolTipDrawList(m_Tooltip, addDrawItemText((GetSystemString(13412) $ " : "), GTColor().Red, "", false, true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(MakeCostStringINT64(Record.nReserved2), GTColor().Sandrift, "", false, false));
		ReturnTooltipInfo(m_Tooltip);
		return;
	}
	return;
}

function ReturnTooltip_RankingOlympiad(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local string firstSpace, tm;
	local int i;
	local array<string> ArrayStr;

	m_Tooltip.MinimumWidth = 154;
	if((int(eSourceType) == 3))
	{
	}
	else if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		if((Record.nReserved1 == INT64(1001)))
		{
			if((Record.szReserved != ""))
			{
				firstSpace = " ";
				Split(Record.szReserved, ", ", ArrayStr);
				addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13153), getInstanceL2Util().Yellow, "", true, true));
				AddCrossLine();
				i = 0;
				while((i < ArrayStr.Length))
				{
					addToolTipDrawList(m_Tooltip, addDrawItemText((firstSpace $ ArrayStr[i]), getInstanceL2Util().White, "", true, false));
					firstSpace = "";
					i++;
				}
				m_Tooltip.MinimumWidth = 200;
			}
		}
		else if((Record.nReserved1 == INT64(1000)))
		{
			if((Record.szReserved != ""))
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13163), getInstanceL2Util().Yellow, "", true, true));
				AddCrossLine();
				addToolTipDrawList(m_Tooltip, addDrawItemText(Record.szReserved, getInstanceL2Util().White, "", true, true));
				m_Tooltip.MinimumWidth = 200;
			}
			else
			{
				return;
			}
		}
		else if((Record.nReserved1 == INT64(1002)))
		{
			ParamToRecord(param, Record);
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().Yellow, "", false, true));
			AddCrossLine();
			AddTooltipItemOption(2694, Record.LVDataList[2].szData, true, true, false);
			AddTooltipItemOption(2290, Record.LVDataList[1].szData, true, true, false);
			if((Record.LVDataList[3].szData == ""))
			{
				tm = GetSystemString(431);
			}
			else
			{
				tm = Record.LVDataList[3].szData;
			}
			AddTooltipItemOption(439, tm, true, true, false);
		}
		else if((Record.nReserved1 == INT64(1003)))
		{
			ParamToRecord(param, Record);
			addToolTipDrawList(m_Tooltip, addDrawItemText(("Lv." $ string(Record.nReserved2)), getInstanceL2Util().Yellow, "", false, false));
			addToolTipDrawList(m_Tooltip, addDrawItemText((" " $ Record.LVDataList[2].szData), getInstanceL2Util().BWhite, "", false, true));
			AddCrossLine();
			AddTooltipItemOption(2290, Record.szReserved, true, true, false);
			if((Record.LVDataList[3].szData == ""))
			{
				tm = GetSystemString(431);
			}
			else
			{
				tm = Record.LVDataList[3].szData;
			}
			AddTooltipItemOption(439, tm, true, true, false);
			if(getInstanceUIData().GetIsLiveServer())
			{
				AddTooltipItemBlank(2);
				AddCrossLine();
				AddTooltipItemBlank(2);
				if((int(Record.LVDataList[5].szData) > 0))
				{
					addToolTipDrawList(m_Tooltip, addDrawItemText(MakeFullSystemMsg(GetSystemMessage(14052), string(Record.nReserved3)), getInstanceL2Util().White, "", true, true));
				}
				else
				{
					addToolTipDrawList(m_Tooltip, addDrawItemText(MakeFullSystemMsg(GetSystemMessage(14053), string(Record.nReserved3)), getInstanceL2Util().White, "", true, true));
				}
			}
			ReturnTooltipInfo(m_Tooltip);
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_RankingPet(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = 154;
	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[1].szData, getInstanceL2Util().Yellow, "", false, false));
		addToolTipDrawList(m_Tooltip, addDrawItemText((" " $ Record.LVDataList[0].szData), getInstanceL2Util().BWhite, "", false, true));
		AddCrossLine();
		AddTooltipItemOption(13331, Record.LVDataList[2].szData, true, true, false);
		ReturnTooltipInfo(m_Tooltip);
		return;
	}
	return;
}

function string getStringShopType(int nShopType)
{
	if((nShopType == 2))
	{
		return GetSystemString(13851);
	}
	else if((nShopType == 1))
	{
		return GetSystemString(13850);
	}
	return GetSystemString(1157);
}

function ReturnTooltip_WorldExchangeHistory(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local RichListCtrlRowData rowData;
	local int reservedID;
	local WorldExchangeRegiWndItemHistoryTabWnd src;
	local string strAdenaComma;
	local Color lcoinColor;
	local string TooltipDesc;

	if((int(eSourceType) == 3))
	{
		ParseString(param, "TooltipDesc", TooltipDesc);
		if((TooltipDesc == "btnTooltipAdena"))
		{
			if(Class'Interface.WorldExchangeBuyWnd'.static.Inst()._IsNewServer())
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14424), getInstanceL2Util().White));
			}
			else
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14192), getInstanceL2Util().White));
			}
		}
		else
		{
			src = Class'Interface.WorldExchangeRegiWnd'.static.Inst().historyScr;
			ParseInt(param, "ReservedID", reservedID);
			if((src.GetRichListCtrlRowData(INT64(reservedID), rowData) == -1))
			{
				return;
			}
			m_Tooltip.MinimumWidth = 154;
			switch(int(rowData.nReserved3))
			{
				case 0:
					addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14091), getInstanceL2Util().Red, "", true, true));
					AddCrossLine();
					strAdenaComma = MakeCostString(string(rowData.nReserved2));
					lcoinColor = GetNumericColor(strAdenaComma);
					addToolTipDrawList(m_Tooltip, addDrawItemText((GetSystemString(14106) $ ": "), getInstanceL2Util().BWhite, "gameDefault11", true, true));
					addToolTipDrawList(m_Tooltip, addDrawItemText(strAdenaComma, lcoinColor, "gameDefault11", false, true));
					break;
				case 1:
					addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14090), getInstanceL2Util().Red, "", true, true));
					break;
				case 3:
					addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14867), getInstanceL2Util().Gray, "", true, true));
					break;
				case 2:
					addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14073), getInstanceL2Util().Gray, "", true, true));
					AddCrossLine();
					strAdenaComma = MakeCostString(string(rowData.nReserved2));
					lcoinColor = GetNumericColor(strAdenaComma);
					addToolTipDrawList(m_Tooltip, addDrawItemText((GetSystemString(14107) $ ": "), getInstanceL2Util().BWhite, "gameDefault11", true, true));
					addToolTipDrawList(m_Tooltip, addDrawItemText(strAdenaComma, lcoinColor, "gameDefault11", false, true));
					break;
				default:
					break;
			}
		}
		ReturnTooltipInfo(m_Tooltip);
	}
	return;
}

function ReturnTooltip_RelicSummonListTooltip(string param, string TooltipType, UIEventManager.ETooltipSourceType eSourceType)
{
	local int i;
	local ItemInfo iInfo;
	local RelicsPlayUIData relicPlayData;
	local RichListCtrlRowData rowData;

	if((int(eSourceType) == 2))
	{
		ParamToRowData(param, rowData);
		if((rowData.nReserved1 < INT64(1)))
		{
			return;
		}
		API_GetRelicsPlayData(ERPDT_Summon, int(rowData.nReserved1), relicPlayData);
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(14783), getInstanceL2Util().Yellow));
		AddCrossLine();
		i = 0;
		while((i < relicPlayData.CostItems.Length))
		{
			AddTooltipItemBlank(2);
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(relicPlayData.CostItems[i].ItemClassID), iInfo);
			AddDrawItemItemInfo(m_Tooltip.DrawList, iInfo);
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetItemNameAll(iInfo), getInstanceL2Util().White, "", false, true, 4, 3));
			addToolTipDrawList(m_Tooltip, addDrawItemText(("x" $ string(relicPlayData.CostItems[i].ItemAmount)), getInstanceL2Util().Yellow, "", true, true, 37, -15));
			i++;
		}
		ReturnTooltipInfo(m_Tooltip);
	}
	return;
}

function ReturnTooltip_PrivateShopFind(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local string TooltipDesc, shopTypeString;
	local Color tColor;
	local int Count, nShopType, nEnchant, i;
	local INT64 adenaNum;

	m_Tooltip.MinimumWidth = 154;
	if((int(eSourceType) == 3))
	{
		ParseString(param, "TooltipDesc", TooltipDesc);
		if((TooltipDesc == ""))
		{
			m_Tooltip.MinimumWidth = 10;
			if(IsPrivateStoreBypass())
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(7244), getInstanceL2Util().Yellow, "", true, true));
			}
			else
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(687), getInstanceL2Util().Yellow, "", true, true));
			}
		}
		else
		{
			ParseInt(param, "count", Count);
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13849), getInstanceL2Util().White, "", true, true));
			AddCrossLine();
			if((Count <= 0))
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(13885), getInstanceL2Util().White, "", true, true));
			}
			else
			{
				i = 1;
				while((i <= Count))
				{
					ParseINT64(param, ("adenaString" $ string(i)), adenaNum);
					ParseInt(param, ("shopType" $ string(i)), nShopType);
					ParseInt(param, ("enchant" $ string(i)), nEnchant);
					if((nShopType == 1))
					{
						tColor = GetColor(255, 102, 102, 255);
					}
					else if((nShopType == 2))
					{
						tColor = GetColor(136, 136, 255, 255);
					}
					else
					{
						tColor = GetColor(85, 153, 255, 255);
					}
					shopTypeString = getStringShopType(nShopType);
					addToolTipDrawList(m_Tooltip, addDrawItemText((shopTypeString $ " "), tColor, "", true, true));
					addToolTipDrawList(m_Tooltip, addDrawItemText((ConvertNumToText(string(adenaNum)) $ " "), GTColor().White, "", false, true));
					if((nEnchant > 0))
					{
						addToolTipDrawList(m_Tooltip, addDrawItemText(((("(+" $ string(nEnchant)) $ GetSystemString(2066)) $ ")"), GTColor().Yellow, "", false, true));
					}
					AddTooltipItemBlank(1);
					i++;
				}
			}
		}
		ReturnTooltipInfo(m_Tooltip);
	}
	return;
}

function ReturnTooltip_RankingReward_Character(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local SkillInfo Info;
	local LVDataRecord Record;
	local string TooltipDesc;
	local int Id;

	m_Tooltip.MinimumWidth = 154;
	if((int(eSourceType) == 3))
	{
		if(ParseInt(param, "ReservedID", Id))
		{
			m_Tooltip.MinimumWidth = 260;
			ParseString(param, "TooltipDesc", TooltipDesc);
			GetSkillInfo(Id, 1, 0, Info);
			if((TooltipDesc == "on"))
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(Info.SkillName, getInstanceL2Util().Yellow, "", true, true));
				AddCrossLine();
				addToolTipDrawList(m_Tooltip, addDrawItemText(Info.SkillDesc, getInstanceL2Util().ColorLightBrown, "", true, false));
			}
			else if((TooltipDesc == "off"))
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(Info.SkillName, getInstanceL2Util().Gray, "", true, true));
				AddCrossLine();
				addToolTipDrawList(m_Tooltip, addDrawItemText(Info.SkillDesc, getInstanceL2Util().Gray, "", true, false));
			}
		}
		else
		{
			return;
		}
		ReturnTooltipInfo(m_Tooltip);
	}
	else if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[1].szData, getInstanceL2Util().Yellow, "", false, false));
		addToolTipDrawList(m_Tooltip, addDrawItemText((" " $ Record.LVDataList[0].szData), getInstanceL2Util().BWhite, "", false, true));
		AddCrossLine();
		AddTooltipItemOption(164, Record.LVDataList[4].szData, true, true, false);
		AddTooltipItemOption(2290, Record.LVDataList[2].szData, true, true, false);
		AddTooltipItemOption(439, Record.LVDataList[3].szData, true, true, false);
		ReturnTooltipInfo(m_Tooltip);
		return;
	}
	return;
}

function ReturnTooltip_RankingReward_InstanceZone(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local SkillInfo Info;
	local LVDataRecord Record;
	local string TooltipDesc;
	local int Id;

	m_Tooltip.MinimumWidth = 154;
	if((int(eSourceType) == 3))
	{
		if(ParseInt(param, "ReservedID", Id))
		{
			m_Tooltip.MinimumWidth = 260;
			ParseString(param, "TooltipDesc", TooltipDesc);
			GetSkillInfo(Id, 1, 0, Info);
			if((TooltipDesc == "on"))
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(Info.SkillName, getInstanceL2Util().Yellow, "", true, true));
				AddCrossLine();
				addToolTipDrawList(m_Tooltip, addDrawItemText(Info.SkillDesc, getInstanceL2Util().ColorLightBrown, "", true, false));
			}
			else
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(Info.SkillName, getInstanceL2Util().Gray, "", true, true));
				AddCrossLine();
				addToolTipDrawList(m_Tooltip, addDrawItemText(Info.SkillDesc, getInstanceL2Util().Gray, "", true, false));
			}
		}
		else
		{
			return;
		}
		ReturnTooltipInfo(m_Tooltip);
	}
	else if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[1].szData, getInstanceL2Util().Yellow, "", false, false));
		addToolTipDrawList(m_Tooltip, addDrawItemText((" " $ Record.LVDataList[0].szData), getInstanceL2Util().BWhite, "", false, true));
		AddCrossLine();
		AddTooltipItemOption(164, Record.LVDataList[4].szData, true, true, false);
		AddTooltipItemOption(2290, Record.LVDataList[2].szData, true, true, false);
		AddTooltipItemOption(439, Record.LVDataList[3].szData, true, true, false);
		ReturnTooltipInfo(m_Tooltip);
		return;
	}
	return;
}

function ReturnTooltip_SuppressRichList(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local string TooltipDesc;

	m_Tooltip.MinimumWidth = 154;
	if((int(eSourceType) == 3))
	{
		m_Tooltip.MinimumWidth = 50;
		ParseString(param, "TooltipDesc", TooltipDesc);
		if((TooltipDesc != ""))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(TooltipDesc, getInstanceL2Util().BWhite, "", true, true));
		}
		else
		{
			return;
		}
		ReturnTooltipInfo(m_Tooltip);
	}
	else if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		addToolTipDrawList(m_Tooltip, addDrawItemText(Record.szReserved, getInstanceL2Util().BWhite, "", true, true));
		ReturnTooltipInfo(m_Tooltip);
	}
	return;
}

function ReturnTooltip_CursedWeapon(string param)
{
	local string t_param, strAdenaComma;
	local Color AdenaColor;
	local array<string> arrSplit;

	m_Tooltip.MinimumWidth = 154;
	ParseString(param, "Text", t_param);
	Split(t_param, "|", arrSplit);
	if((arrSplit.Length <= 0))
	{
		return;
	}
	if((arrSplit[0] == "sword"))
	{
		if((arrSplit.Length <= 4))
		{
			AddTooltipColorText(arrSplit[1], getInstanceL2Util().Red, false, false, true);
			AddCrossLine();
			strAdenaComma = MakeCostString(arrSplit[2]);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(3950, ((strAdenaComma $ " ") $ GetSystemString(469)), true, true, false, , , , , AdenaColor);
			strAdenaComma = MakeCostString(arrSplit[3]);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(3951, ((strAdenaComma $ " ") $ GetSystemString(469)), true, true, false, , , , , AdenaColor);
		}
		else
		{
			AddTooltipColorText(arrSplit[1], getInstanceL2Util().Red, false, false, true);
			strAdenaComma = MakeCostString(arrSplit[2]);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(3950, ((strAdenaComma $ " ") $ GetSystemString(469)), true, true, false, , , , , AdenaColor);
			strAdenaComma = MakeCostString(arrSplit[3]);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(3951, ((strAdenaComma $ " ") $ GetSystemString(469)), true, true, false, , , , , AdenaColor);
			AddCrossLine();
			AddTooltipColorText(arrSplit[4], getInstanceL2Util().Red, false, false, true);
			strAdenaComma = MakeCostString(arrSplit[5]);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(3950, ((strAdenaComma $ " ") $ GetSystemString(469)), true, true, false, , , , , AdenaColor);
			strAdenaComma = MakeCostString(arrSplit[6]);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(3951, ((strAdenaComma $ " ") $ GetSystemString(469)), true, true, false, , , , , AdenaColor);
		}
	}
	else
	{
		m_Tooltip.MinimumWidth = 60;
		AddTooltipColorText(arrSplit[1], getInstanceL2Util().DRed, false, true, true);
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_GFxTooltip(string param)
{
	local string Text;
	local int Count, i, R, G, B, A, MinWidth, W, h, uw, uh, OffsetX, OffsetY, lineBreak, oneline, DrawItemType;

	ParseInt(param, "count", Count);
	ParseInt(param, "min", MinWidth);
	m_Tooltip.MinimumWidth = MinWidth;
	i = 0;
	while((i < Count))
	{
		ParseInt(param, ("t_" $ string(i)), DrawItemType);
		switch(byte(DrawItemType))
		{
			case 0:
				ParseString(param, ("txt_" $ string(i)), Text);
				AddTooltipItemBlank(int(Text));
				break;
			case 1:
				ParseString(param, ("txt_" $ string(i)), Text);
				ParseInt(param, ("R_" $ string(i)), R);
				ParseInt(param, ("G_" $ string(i)), G);
				ParseInt(param, ("B_" $ string(i)), B);
				ParseInt(param, ("A_" $ string(i)), A);
				ParseInt(param, ("oX_" $ string(i)), OffsetX);
				ParseInt(param, ("oY_" $ string(i)), OffsetY);
				ParseInt(param, ("lb_" $ string(i)), lineBreak);
				ParseInt(param, ("ol_" $ string(i)), oneline);
				AddTooltipColorText(Text, GetColor(R, G, B, A), bool(lineBreak), bool(oneline), (i == 0), "", OffsetX, OffsetY);
				break;
			case 2:
				ParseString(param, ("textu_" $ string(i)), Text);
				ParseInt(param, ("w_" $ string(i)), W);
				ParseInt(param, ("h_" $ string(i)), h);
				ParseInt(param, ("uw_" $ string(i)), uw);
				ParseInt(param, ("uh_" $ string(i)), uh);
				ParseInt(param, ("oX_" $ string(i)), OffsetX);
				ParseInt(param, ("oY_" $ string(i)), OffsetY);
				ParseInt(param, ("lb_" $ string(i)), lineBreak);
				ParseInt(param, ("ol_" $ string(i)), oneline);
				addTooltipTexture(Text, W, h, uw, uh, bool(lineBreak), bool(oneline), OffsetX, OffsetY);
				break;
			case 3:
				AddCrossLine();
				break;
			case 4:
				break;
			default:
				break;
		}
		i++;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_MAP_REGIONINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local L2FactionUIData FactionData;
	local int nType, nHuntingZoneType;
	local HuntingZoneUIData huntingZoneData;
	local string tmpStr, textStr, seedMessage, addStr, CastleName, OwnerClanName, OwnerClanNameToolTip, NextSiegeTime, siegeState, CastleType, taxRate, DateTotal, AgitName, OwnerClanMasterName, LocationName, ToolTipString, tooltipString2;
	local int Index, nActive, i, nFactionID, nFactionLevel, nCastleID;
	local UIConstants.RaidUIData pRaidUIData;
	local UIEventManager.ELanguageType Language;

	if((int(eSourceType) == 0))
	{
		ParseInt(param, "Type", nType);
		ParseInt(param, "Index", Index);
		ParseInt(param, "Active", nActive);
		ParseString(param, "Text", textStr);
		m_Tooltip.MinimumWidth = 154;
		Debug(("--> 맵 툴팁 " @ param));  // EN?: -- > Map Tooltip
		if((nType == 0))
		{
			ParseString(param, "CastleName", CastleName);
			ParseInt(param, "CastleID", nCastleID);
			ParseString(param, "OwnerClanNameToolTip", OwnerClanNameToolTip);
			ParseString(param, "OwnerClanName", OwnerClanName);
			ParseString(param, "NextSiegeTime", NextSiegeTime);
			ParseString(param, "SiegeState", siegeState);
			ParseString(param, "CastleType", CastleType);
			ParseString(param, "TaxRate", taxRate);
			AddTooltipColorText(CastleName, getInstanceL2Util().White, false, false, true);
			if(IsBloodyServer())
			{
				Debug(("nCastleID" @ string(nCastleID)));
				if((nCastleID == 5))
				{
					if((CastleType != ""))
					{
						AddTooltipColorText(((" (" $ CastleType) $ ")"), getInstanceL2Util().ColorLightBrown, false, false, true);
					}
					AddCrossLine();
					AddTooltipColorText(((GetSystemString(1607) $ " : ") $ OwnerClanName), getInstanceL2Util().ColorYellow, true, true, false);
					AddTooltipColorText(((GetSystemString(1612) $ " : ") $ siegeState), getInstanceL2Util().ColorYellow, true, true, false);
					AddTooltipColorText(((GetSystemString(1608) $ " : ") $ taxRate), getInstanceL2Util().ColorYellow, true, true, false);
					AddTooltipColorText(((GetSystemString(1609) $ " : ") $ NextSiegeTime), getInstanceL2Util().ColorYellow, true, true, false);
				}
			}
			else
			{
				if((CastleType != ""))
				{
					AddTooltipColorText(((" (" $ CastleType) $ ")"), getInstanceL2Util().ColorLightBrown, false, false, true);
				}
				AddCrossLine();
				AddTooltipColorText(((GetSystemString(1607) $ " : ") $ OwnerClanName), getInstanceL2Util().ColorYellow, true, true, false);
				AddTooltipColorText(((GetSystemString(1612) $ " : ") $ siegeState), getInstanceL2Util().ColorYellow, true, true, false);
				AddTooltipColorText(((GetSystemString(1608) $ " : ") $ taxRate), getInstanceL2Util().ColorYellow, true, true, false);
				AddTooltipColorText(((GetSystemString(1609) $ " : ") $ NextSiegeTime), getInstanceL2Util().ColorYellow, true, true, false);
			}
		}
		else if((nType == 1))
		{
			ParseString(param, "CastleName", CastleName);
			ParseString(param, "OwnerClanName", OwnerClanName);
			ParseString(param, "SiegeState", siegeState);
			ParseString(param, "DateTotal", DateTotal);
			ParseString(param, "LocationName", LocationName);
			AddTooltipColorText(((CastleName $ " | ") $ MakeFullSystemMsg(GetSystemMessage(4436), LocationName)), getInstanceL2Util().White, true, true, true);
			if((IsBloodyServer() == false))
			{
				AddCrossLine();
				AddTooltipColorText(((GetSystemString(1607) $ " : ") $ OwnerClanName), getInstanceL2Util().ColorYellow, true, true, false);
				AddTooltipColorText(((GetSystemString(1612) $ " : ") $ siegeState), getInstanceL2Util().ColorYellow, true, true, false);
				if((DateTotal != ""))
				{
					AddTooltipColorText(((GetSystemString(1615) $ " : ") $ DateTotal), getInstanceL2Util().ColorYellow, true, true, false);
				}
			}
		}
		else if((nType == 2))
		{
			ParseString(param, "AgitName", AgitName);
			ParseString(param, "OwnerClanName", OwnerClanName);
			ParseString(param, "OwnerClanMasterName", OwnerClanMasterName);
			ParseString(param, "NextSiegeTime", NextSiegeTime);
			ParseString(param, "LocationName", LocationName);
			if((LocationName != ""))
			{
				AddTooltipColorText(((AgitName $ " | ") $ MakeFullSystemMsg(GetSystemMessage(4436), LocationName)), getInstanceL2Util().White, true, true, true);
			}
			if((IsBloodyServer() == false))
			{
				AddCrossLine();
				if((OwnerClanName == ""))
				{
					OwnerClanName = GetSystemString(27);
				}
				AddTooltipColorText(((GetSystemString(1607) $ " : ") $ OwnerClanName), getInstanceL2Util().ColorYellow, true, true, false);
				if((OwnerClanMasterName != ""))
				{
					AddTooltipColorText(((GetSystemString(342) $ " : ") $ OwnerClanMasterName), getInstanceL2Util().ColorYellow, true, true, false);
				}
				if((NextSiegeTime != ""))
				{
					AddTooltipColorText(((GetSystemString(3545) $ " : ") $ NextSiegeTime), getInstanceL2Util().ColorYellow, true, true, false);
				}
			}
		}
		else if(((nType == 3) || (nType == 5)))
		{
			ParseString(param, "SeedMessage", seedMessage);
			Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(Index, huntingZoneData);
			tmpStr = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(huntingZoneData.nSearchZoneID);
			AddTooltipColorText(((huntingZoneData.strName $ " | ") $ tmpStr), getInstanceL2Util().White, true, true, true);
			if((IsBloodyServer() == false))
			{
				AddCrossLine();
				if((seedMessage != ""))
				{
					AddTooltipColorText(seedMessage, GetColor(255, 204, 0, 255), true, true, false);
				}
				if(((huntingZoneData.nMinLevel != 0) && (huntingZoneData.nMaxLevel != 0)))
				{
					AddTooltipColorText(((((GetSystemString(922) $ " : ") $ string(huntingZoneData.nMinLevel)) $ "~") $ string(huntingZoneData.nMaxLevel)), GetColor(255, 204, 0, 255), true, true, false);
				}
				nHuntingZoneType = huntingZoneData.nType;
				tmpStr = getHuntingZoneTypeString(nHuntingZoneType);
				if((tmpStr != ""))
				{
					AddTooltipColorText(tmpStr, GetColor(255, 204, 0, 255), true, true, false);
				}
			}
		}
		else if((nType == 4))
		{
			ParseInt(param, "nFactionID", nFactionID);
			ParseInt(param, "nFactionLevel", nFactionLevel);
			GetFactionData(nFactionID, FactionData);
			AddTooltipColorText(FactionData.strFactionName, getInstanceL2Util().White, true, true, true);
			if((IsBloodyServer() == false))
			{
				AddCrossLine();
				Language = GetLanguage();
				if((((int(Language) == 8) || (int(Language) == 9)) || (int(Language) == 1)))
				{
					AddTooltipColorText(((((GetSystemString(3521) $ " : ") $ GetSystemString(1328)) $ " ") $ string(nFactionLevel)), GetColor(255, 204, 0, 255), true, true, false);
				}
				else
				{
					AddTooltipColorText((((GetSystemString(3521) $ " : ") $ string(nFactionLevel)) $ GetSystemString(1328)), GetColor(255, 204, 0, 255), true, true, false);
				}
				if((FactionData.arrFactionAreaName.Length > 0))
				{
					AddTooltipColorText((GetSystemString(3449) $ " : "), GetColor(255, 204, 0, 255), true, true, false);
					i = 0;
					while((i < FactionData.arrFactionAreaName.Length))
					{
						AddTooltipColorText(FactionData.arrFactionAreaName[i], GetColor(255, 204, 0, 255), false, true, false);
						if((i < (FactionData.arrFactionAreaName.Length - 1)))
						{
							AddTooltipColorText(", ", GetColor(255, 204, 0, 255), false, true, false);
						}
						i++;
					}
				}
			}
		}
		else if((nType == 7))
		{
			pRaidUIData = getRaidDataByIndex(Index);
			AddTooltipColorText(((pRaidUIData.raidMonsterName $ " | ") $ pRaidUIData.RaidMonsterZoneName), getInstanceL2Util().White, true, true, true);
			AddCrossLine();
			Language = GetLanguage();
			if((((int(Language) == 8) || (int(Language) == 9)) || (int(Language) == 1)))
			{
				AddTooltipColorText(MakeFullSystemMsg(GetSystemMessage(4425), ((GetSystemString(537) $ " ") $ string(pRaidUIData.nRaidMonsterLevel))), GetColor(255, 204, 0, 255), true, true, false);
			}
			else
			{
				AddTooltipColorText(MakeFullSystemMsg(GetSystemMessage(4425), (string(pRaidUIData.nRaidMonsterLevel) $ GetSystemString(537))), GetColor(255, 204, 0, 255), true, true, false);
			}
			if((nActive > 0))
			{
				tmpStr = GetSystemString(3525);
			}
			else
			{
				tmpStr = GetSystemString(3526);
			}
			AddTooltipColorText(((GetSystemString(3524) $ " : ") $ tmpStr), GetColor(255, 204, 0, 255), true, true, false);
		}
		else if((nType == 6))
		{
			ParseInt(param, "Active", nActive);
			Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(Index, huntingZoneData);
			tmpStr = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(huntingZoneData.nSearchZoneID);
			AddTooltipColorText(((huntingZoneData.strName $ " | ") $ tmpStr), getInstanceL2Util().White, true, true, true);
			if((IsBloodyServer() == false))
			{
				AddCrossLine();
				nHuntingZoneType = huntingZoneData.nType;
				tmpStr = getHuntingZoneTypeString(nHuntingZoneType);
				if((tmpStr != ""))
				{
					AddTooltipColorText(tmpStr, GetColor(255, 204, 0, 255), true, true, false);
				}
				if(((huntingZoneData.nMinLevel != 0) && (huntingZoneData.nMaxLevel != 0)))
				{
					AddTooltipColorText(((((GetSystemString(922) $ " : ") $ string(huntingZoneData.nMinLevel)) $ "~") $ string(huntingZoneData.nMaxLevel)), GetColor(255, 204, 0, 255), true, true, false);
				}
				AddTooltipColorText(((GetSystemString(3522) $ " : ") $ Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingDescription(Index)), GetColor(255, 204, 0, 255), true, true, false);
				if((huntingZoneData.arrQuestIDs.Length > 0))
				{
					AddTooltipColorText((GetSystemString(3523) $ " : "), GetColor(255, 204, 0, 255), true, true, false);
					i = 0;
					while((i < huntingZoneData.arrQuestIDs.Length))
					{
						addStr = GetQuestNameUtil(huntingZoneData.arrQuestIDs[i]);
						AddTooltipColorText(addStr, GetColor(255, 204, 0, 255), false, true, false);
						if((i < (huntingZoneData.arrQuestIDs.Length - 1)))
						{
							AddTooltipColorText(", ", GetColor(255, 204, 0, 255), false, true, false);
						}
						i++;
					}
				}
				if((nActive <= 0))
				{
					AddTooltipColorText(((GetSystemString(3524) $ " : ") $ GetSystemString(5099)), GetColor(255, 204, 0, 255), true, true, false);
				}
			}
		}
		else if(((nType == 9) || (nType == 8)))
		{
			m_Tooltip.MinimumWidth = (154 / 4);
			ParseString(param, "tooltipString", ToolTipString);
			ParseString(param, "tooltipString2", tooltipString2);
			if((ToolTipString != ""))
			{
				AddTooltipColorText(ToolTipString, getInstanceL2Util().White, false, true, false);
			}
			if((tooltipString2 != ""))
			{
				AddTooltipColorText(tooltipString2, GetColor(255, 204, 0, 255), true, true, false);
			}
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_TEXT(string param, UIEventManager.ETooltipSourceType eSourceType, bool bDesc)
{
	local string strText;
	local int Id;
	local array<TextSectionInfo> TextInfos;
	local string FullText, strDesc;

	if((int(eSourceType) == 0))
	{
		if(ParseString(param, "Text", strText))
		{
			if((Len(strText) > 0))
			{
				if(bDesc)
				{
					m_Tooltip.MinimumWidth = 154;
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_color.R = 178;
					m_Info.t_color.G = 190;
					m_Info.t_color.B = 207;
					m_Info.t_color.A = 255;
					m_Info.t_strText = strText;
					EndItem();
				}
				else
				{
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_color.R = 200;
					m_Info.t_color.G = 200;
					m_Info.t_color.B = 200;
					m_Info.t_color.A = 255;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = strText;
					EndItem();
				}
			}
		}
		else if(ParseInt(param, "ID", Id))
		{
			if((Id > 0))
			{
				StartItem();
				GetItemTextSectionInfos(GetSystemString(Id), FullText, TextInfos);
				if((TextInfos.Length > 0))
				{
					strDesc = FullText;
					m_Info.t_SectionList = TextInfos;
				}
				else
				{
					strDesc = GetSystemString(Id);
				}
				m_Info.eType = DIT_TEXT;
				m_Info.t_bDrawOneLine = true;
				m_Info.t_color.R = 200;
				m_Info.t_color.G = 200;
				m_Info.t_color.B = 200;
				m_Info.t_color.A = 255;
				m_Info.t_strText = strDesc;
				EndItem();
			}
		}
	}
	else if((int(eSourceType) == 3))
	{
		if(ParseString(param, "TooltipDesc", strText))
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.t_color.R = 200;
			m_Info.t_color.G = 200;
			m_Info.t_color.B = 200;
			m_Info.t_color.A = 255;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_strText = strText;
			EndItem();
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function bool addItemIcon(ItemInfo item, string ForeTexture, optional string ForeTexture1, optional bool bBigSizeIcon)
{
	local int nAddBigsize;

	if((item.IconName == ""))
	{
		return false;
	}
	if(bBigSizeIcon)
	{
		nAddBigsize = 16;
	}
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = (34 + nAddBigsize);
	m_Info.u_nTextureHeight = (34 + nAddBigsize);
	m_Info.u_nTextureUWidth = (34 + nAddBigsize);
	m_Info.u_nTextureUHeight = (34 + nAddBigsize);
	m_Info.u_strTexture = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	EndItem();
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = (32 + nAddBigsize);
	m_Info.u_nTextureHeight = (32 + nAddBigsize);
	m_Info.u_nTextureUWidth = (32 + nAddBigsize);
	m_Info.u_nTextureUHeight = (32 + nAddBigsize);
	m_Info.nOffSetX = -(33 + nAddBigsize);
	m_Info.nOffSetY = 1;
	m_Info.u_strTexture = item.IconName;
	EndItem();
	if(item.IsBlessedItem)
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_nTextureWidth = (32 + nAddBigsize);
		m_Info.u_nTextureHeight = (32 + nAddBigsize);
		m_Info.u_nTextureUWidth = (32 + nAddBigsize);
		m_Info.u_nTextureUHeight = (32 + nAddBigsize);
		m_Info.nOffSetX = -(32 + nAddBigsize);
		m_Info.nOffSetY = 1;
		m_Info.u_strTexture = "Icon.icon_panel.bless_panel";
		EndItem();
	}
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = (32 + nAddBigsize);
	m_Info.u_nTextureHeight = (32 + nAddBigsize);
	m_Info.u_nTextureUWidth = (32 + nAddBigsize);
	m_Info.u_nTextureUHeight = (32 + nAddBigsize);
	m_Info.nOffSetX = -(32 + nAddBigsize);
	m_Info.nOffSetY = 1;
	m_Info.u_strTexture = item.IconPanel;
	EndItem();
	if((ForeTexture1 != ""))
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_nTextureWidth = (32 + nAddBigsize);
		m_Info.u_nTextureHeight = (32 + nAddBigsize);
		m_Info.u_nTextureUWidth = (32 + nAddBigsize);
		m_Info.u_nTextureUHeight = (32 + nAddBigsize);
		m_Info.nOffSetX = -(32 + nAddBigsize);
		m_Info.nOffSetY = 1;
		m_Info.u_strTexture = ForeTexture1;
		EndItem();
	}
	if((ForeTexture != ""))
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_nTextureWidth = (32 + nAddBigsize);
		m_Info.u_nTextureHeight = (32 + nAddBigsize);
		m_Info.u_nTextureUWidth = (32 + nAddBigsize);
		m_Info.u_nTextureUHeight = (32 + nAddBigsize);
		m_Info.nOffSetX = -(32 + nAddBigsize);
		m_Info.nOffSetY = 1;
		m_Info.u_strTexture = ForeTexture;
		EndItem();
	}
	if((item.bSecurityLock && isDamagedItem(item)))
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_nTextureWidth = (32 + nAddBigsize);
		m_Info.u_nTextureHeight = (32 + nAddBigsize);
		m_Info.u_nTextureUWidth = (32 + nAddBigsize);
		m_Info.u_nTextureUHeight = (32 + nAddBigsize);
		m_Info.nOffSetX = -(32 + nAddBigsize);
		m_Info.nOffSetY = 1;
		m_Info.u_strTexture = "Icon.icon_panel.BrokenItemLock_Panel";
		EndItem();
	}
	else
	{
		if(isDamagedItem(item))
		{
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.u_nTextureWidth = (32 + nAddBigsize);
			m_Info.u_nTextureHeight = (32 + nAddBigsize);
			m_Info.u_nTextureUWidth = (32 + nAddBigsize);
			m_Info.u_nTextureUHeight = (32 + nAddBigsize);
			m_Info.nOffSetX = -(32 + nAddBigsize);
			m_Info.nOffSetY = 1;
			m_Info.u_strTexture = "L2UI_NewTex.etc.BrokenItemPanel";
			EndItem();
		}
		if(item.bSecurityLock)
		{
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.u_nTextureWidth = (32 + nAddBigsize);
			m_Info.u_nTextureHeight = (32 + nAddBigsize);
			m_Info.u_nTextureUWidth = (32 + nAddBigsize);
			m_Info.u_nTextureUHeight = (32 + nAddBigsize);
			m_Info.nOffSetX = -(32 + nAddBigsize);
			m_Info.nOffSetY = 1;
			m_Info.u_strTexture = "Icon.Icon_panel.ItemLock_Panel";
			EndItem();
		}
	}
	return true;
}

function addItemIconSmallType(ItemInfo item, string ForeTexture)
{
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = 16;
	m_Info.u_nTextureHeight = 16;
	m_Info.u_nTextureUWidth = 32;
	m_Info.u_nTextureUHeight = 32;
	m_Info.nOffSetX = 4;
	m_Info.nOffSetY = 2;
	m_Info.u_strTexture = item.IconName;
	EndItem();
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = 16;
	m_Info.u_nTextureHeight = 16;
	m_Info.u_nTextureUWidth = 32;
	m_Info.u_nTextureUHeight = 32;
	m_Info.nOffSetX = -16;
	m_Info.nOffSetY = 2;
	m_Info.u_strTexture = item.IconPanel;
	EndItem();
	if((ForeTexture != ""))
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_nTextureWidth = 16;
		m_Info.u_nTextureHeight = 16;
		m_Info.u_nTextureUWidth = 32;
		m_Info.u_nTextureUHeight = 32;
		m_Info.nOffSetX = -16;
		m_Info.nOffSetY = 2;
		m_Info.u_strTexture = ForeTexture;
		EndItem();
	}
	return;
}

function addItemIconCustom(ItemInfo item, string ForeTexture, int iconWidth, int iconHeight, optional string DisableTexture, optional int FirstX, optional int FirstY)
{
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = iconWidth;
	m_Info.u_nTextureHeight = iconHeight;
	m_Info.u_nTextureUWidth = 32;
	m_Info.u_nTextureUHeight = 32;
	m_Info.nOffSetX = FirstX;
	m_Info.nOffSetY = FirstY;
	m_Info.u_strTexture = item.IconName;
	EndItem();
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = iconWidth;
	m_Info.u_nTextureHeight = iconHeight;
	m_Info.u_nTextureUWidth = 32;
	m_Info.u_nTextureUHeight = 32;
	m_Info.nOffSetX = -iconWidth;
	m_Info.nOffSetY = FirstY;
	m_Info.u_strTexture = item.IconPanel;
	EndItem();
	if((ForeTexture != ""))
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_nTextureWidth = iconWidth;
		m_Info.u_nTextureHeight = iconHeight;
		m_Info.u_nTextureUWidth = 32;
		m_Info.u_nTextureUHeight = 32;
		m_Info.nOffSetX = -iconWidth;
		m_Info.nOffSetY = FirstY;
		m_Info.u_strTexture = ForeTexture;
		EndItem();
	}
	if((DisableTexture != ""))
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_nTextureWidth = iconWidth;
		m_Info.u_nTextureHeight = iconHeight;
		m_Info.u_nTextureUWidth = 32;
		m_Info.u_nTextureUHeight = 32;
		m_Info.nOffSetX = -iconWidth;
		m_Info.nOffSetY = FirstY;
		m_Info.u_strTexture = DisableTexture;
		EndItem();
	}
	return;
}

function addTexture(string IconName, int u_nTextureWidth, int u_nTextureHeight, int u_nTextureUWidth, int u_nTextureUHeight, optional int nOffSetX, optional int nOffSetY)
{
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = u_nTextureWidth;
	m_Info.u_nTextureHeight = u_nTextureHeight;
	m_Info.u_nTextureUWidth = u_nTextureUWidth;
	m_Info.u_nTextureUHeight = u_nTextureUHeight;
	m_Info.nOffSetX = nOffSetX;
	m_Info.nOffSetY = nOffSetY;
	m_Info.u_strTexture = IconName;
	EndItem();
	return;
}

function AddTooltipItemLevelUpBonus(ItemInfo item, string TooltipType, optional int IsCtrlPressing)
{
	local UIEventManager.EItemType EItemType;
	local UserInfo myInfo;
	local int nPhysicalBonus, nMagicaBonus;
	local PetInfo pInfo;
	local int nLevel;

	if((TooltipType == "InventoryPet"))
	{
		GetPetInfo(pInfo);
		nLevel = pInfo.nLevel;
	}
	else
	{
		GetPlayerInfo(myInfo);
		nLevel = myInfo.nLevel;
	}
	nPhysicalBonus = GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, nLevel);
	nMagicaBonus = GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, nLevel);
	if(((nPhysicalBonus > 0) || (nMagicaBonus > 0)))
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_LV_small", GetSystemString(13167));
		AddTooltipColorText(GetSystemString(13169), GetColor(176, 155, 121, 255), true, true);
		if(item.bEquipped)
		{
			EItemType = EItemType(item.ItemType);
			if((int(EItemType) == 0))
			{
				if(((TooltipType == "InventoryPet") && (IsCtrlPressing == 1)))
				{
				}
				else
				{
					AddTooltipItemOption(94, string(nPhysicalBonus), true, true, false, , , , getInstanceL2Util().CAPRI, getInstanceL2Util().CAPRI);
					AddTooltipItemOption(98, string(nMagicaBonus), true, true, false, , , , getInstanceL2Util().CAPRI, getInstanceL2Util().CAPRI);
				}
			}
		}
	}
	return;
}

function string getSlotTypeWithItemTypeString(ItemInfo item)
{
	local string SlotString, strTmp;
	local UIEventManager.EItemType EItemType;

	if((int(byte(item.EtcItemType)) == 94))
	{
		return GetSystemString(14288);
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		if((int(byte(item.ItemType)) == 4))
		{
			return "";
		}
	}
	EItemType = EItemType(item.ItemType);
	SlotString = GetSlotTypeString(item.ItemType, item.SlotBitType, item.ArmorType);
	if((int(EItemType) == 0))
	{
		strTmp = GetWeaponTypeString(item.WeaponType);
		if((Len(strTmp) > 0))
		{
			SlotString = ((strTmp $ " / ") $ SlotString);
		}
	}
	return SlotString;
}

function CustomTooltip ReturnCustomTooltip_ITEM(string param)
{
	local CustomTooltip resultTooltip;

	ClearTooltip();
	ReturnTooltip_NTT_ITEM(param, "Inventory", NTST_ITEM, true);
	resultTooltip = m_Tooltip;
	ClearTooltip();
	return resultTooltip;
}

function ReturnTooltip_NTT_ITEM(string param, string TooltipType, UIEventManager.ETooltipSourceType eSourceType, optional bool onlyMakeCustomTooltip)
{
	local ItemInfo item;
	local UIEventManager.EItemType EItemType;
	local UIEventManager.EEtcItemType EEtcItemType;
	local int nTmp;
	local string strAdena, strAdenaComma;
	local Color AdenaColor;
	local EnchantValidateUIData EnchantData;
	local bool bMagicWeapon;
	local float fSoulShotPower, fSpiritShotPower;
	local int nEnchantedPhysicalDamageBonus, nEnchantedMagicalDamageBonus, nEnchantedMagicalDefenseBonus, nEnchantedPhysicalDefenseBonus, nEnchantedShieldDefenseBonus, nAddPhysicalDefendValue, nAddMagicalDefendValue;
	local string ForeTexture, ItemSlotWithItemTypeStr;
	local int IsCompareItem, IsComparingEquip, IsCtrlKeyPressing, nEnchantValueTextGap, bMainIconGap;
	local UserInfo myInfo;
	local int nPhysicalBonus, nMagicaBonus;
	local string autoUsePanel;
	local PetNameInfo PetNameInfo;
	local string petNameStr;
	local PetInfo PetInfo;
	local int nUseSimpleTooltip, nIsSelectMode;
	local bool bBigSizeIcon, isForeTexture;
	local int isDualEquip, isEmptyItem, isEqualItem;
	local bool isLiveServer, isShowPetEquipNotice;
	local string TooltipDesc;

	isLiveServer = getInstanceUIData().GetIsLiveServer();
	if(((int(eSourceType) == 1) || (int(eSourceType) == 2)))
	{
		ParamToItemInfo(param, item);
		if((item.Id.ClassID <= 0))
		{
			return;
		}
		ParseInt(param, "IsCompareItem", IsCompareItem);
		ParseInt(param, "IsComparingEquip", IsComparingEquip);
		ParseInt(param, "UseSimpleTooltip", nUseSimpleTooltip);
		ParseInt(param, "IsSelectMode", nIsSelectMode);
		ParseInt(param, "PressCtrl", IsCtrlKeyPressing);
		if(((((isLiveServer == false) && (TooltipType == "InventoryPet")) && (item.bEquipped == true)) && (IsCtrlKeyPressing == 0)))
		{
			item = ConvertPetItemStat(item);
			isShowPetEquipNotice = true;
		}
		if((TooltipType == "EnsoulSlot"))
		{
			if((item.Id.ClassID <= 0))
			{
				return;
			}
		}
		Class'NWindow.UIDATA_ITEM'.static.GetEnchantValidateValue(item.Id.ClassID, item.Enchanted, EnchantData);
		EItemType = EItemType(item.ItemType);
		EEtcItemType = EEtcItemType(item.EtcItemType);
		nEnchantedShieldDefenseBonus = int(EnchantData.EnchantValue[12]);
		nEnchantedPhysicalDefenseBonus = int(EnchantData.EnchantValue[0]);
		nEnchantedMagicalDefenseBonus = int(EnchantData.EnchantValue[1]);
		nEnchantedPhysicalDamageBonus = int(EnchantData.EnchantValue[2]);
		nEnchantedMagicalDamageBonus = int(EnchantData.EnchantValue[3]);
		ParseString(param, "ForeTexture", ForeTexture);
		isForeTexture = (ForeTexture == "L2UI_CT1.Icon.WearPanel");
		if((item.tooltipBGDecoTexture != ""))
		{
			addOverlayTexture(item.tooltipBGDecoTexture, 256, 378, 256, 378, 3, 3);
		}
		if(((TooltipType == "RankingItemRewardOn") || (TooltipType == "RankingItemRewardOff")))
		{
			if((TooltipType == "RankingItemRewardOn"))
			{
				AddTooltipColorText(GetSystemString(14979), GTColor().Yellow, true, true, true);
			}
			else
			{
				AddTooltipColorText(GetSystemString(14979), GTColor().Gray, true, true, true);
			}
			AddCrossLine();
		}
		ParseInt(param, "isDualEquip", isDualEquip);
		if((isDualEquip == 1))
		{
			if(((InventoryWnd(GetScript("InventoryWnd"))._GetSwapSelectButtonIndex() ^ 1) == 0))
			{
				AddTooltipColorText((("[" $ GetSystemString(14277)) $ "]"), GetColor(255, 204, 0, 255), true, true, true);
			}
			else
			{
				AddTooltipColorText((("[" $ GetSystemString(14278)) $ "]"), GetColor(255, 204, 0, 255), true, true, true);
			}
			AddTooltipItemBlank(0);
			AddCrossLine();
		}
		else if(((IsCompareItem == 1) || isForeTexture))
		{
			if(((IsComparingEquip == 1) || isForeTexture))
			{
				AddTooltipColorText((("[" $ GetSystemString(3556)) $ "]"), GetColor(255, 204, 0, 255), true, true, true);
				if(item.IsVirtualItem)
				{
					AddTooltipColorText((("[" $ GetSystemString(5247)) $ "]"), GetColor(46, 255, 223, 255), false, true, false);
				}
			}
			else
			{
				AddTooltipColorText((("[" $ GetSystemString(3555)) $ "]"), GetColor(182, 182, 182, 255), true, true, true);
				if(item.IsVirtualItem)
				{
					AddTooltipColorText((("[" $ GetSystemString(5247)) $ "]"), GetColor(46, 255, 223, 255), false, true, false);
				}
			}
			AddTooltipItemBlank(0);
			AddCrossLine();
		}
		else if(item.IsVirtualItem)
		{
			AddTooltipColorText((("[" $ GetSystemString(5247)) $ "]"), GetColor(46, 255, 223, 255), true, true, true);
			AddTooltipItemBlank(0);
			AddCrossLine();
		}
		ParseInt(param, "isEmptyItem", isEmptyItem);
		if((isEmptyItem == 1))
		{
			AddTooltipItemBlank(10);
			AddTooltipColorText(GetSystemString(14279), getInstanceL2Util().Gray, true, true, true);
			m_Tooltip.DrawList[(m_Tooltip.DrawList.Length - 1)].eAlignType = DIAT_CENTER;
			AddTooltipItemBlank(10);
			ReturnTooltipInfo(m_Tooltip);
			return;
		}
		ParseInt(param, "isEqualItem", isEqualItem);
		if((isEqualItem == 1))
		{
			AddTooltipItemBlank(10);
			AddTooltipColorText(GetSystemString(14280), getInstanceL2Util().White, true, true, true);
			m_Tooltip.DrawList[(m_Tooltip.DrawList.Length - 1)].eAlignType = DIAT_CENTER;
			AddTooltipItemBlank(10);
			ReturnTooltipInfo(m_Tooltip);
			return;
		}
		switch(Class'NWindow.UIDATA_ITEM'.static.GetAutomaticUseItemType(item.Id.ClassID))
		{
			case AUIT_ITEM:
				autoUsePanel = "Icon.autoskill_panel_01";
				break;
			default:
				break;
		}
		if(IsAdenServer())
		{
			switch(item.Id.ClassID)
			{
				case 93864:
				case 96927:
				case 96928:
				case 96929:
				case 96930:
				case 96931:
				case 96932:
				case 96933:
				case 96935:
				case 96938:
				case 96939:
				case 96940:
				case 97088:
				case 97089:
				case 98203:
					if((TooltipType != "InventoryPet"))
					{
						bBigSizeIcon = true;
					}
					break;
				default:
					break;
			}
		}
		if(addItemIcon(item, ForeTexture, autoUsePanel, bBigSizeIcon))
		{
			bMainIconGap = 3;
		}
		if(isDamagedItem(item))
		{
			AddTooltipColorText((("(" $ GetSystemString(14895)) $ ")"), GTColor().Red, false, true, false, "gameDefault10", bMainIconGap, 1);
		}
		AddPrimeItemSymbol(item, true);
		if(((TooltipType != "InventoryPrice1HideEnchant") && (TooltipType != "InventoryPrice1HideEnchantStackable")))
		{
			AddTooltipItemEnchant(item, true, "gameDefault10", 6, 1);
			nEnchantValueTextGap = 3;
		}
		AddTooltipItemName(item, "gameDefault10", (bMainIconGap + nEnchantValueTextGap), 1);
		ItemSlotWithItemTypeStr = getSlotTypeWithItemTypeString(item);
		if((TooltipType != "InventoryPrice1HideEnchantStackable"))
		{
			if((TooltipType == "InventoryNeedItem"))
			{
				if(IsStackableItem(item.ConsumeType))
				{
					ItemSlotWithItemTypeStr = "";
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.bLineBreak = true;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = ("x" $ MakeCostString(string(item.Reserved64)));
					m_Info.nOffSetX = 40;
					m_Info.nOffSetY = -16;
					m_Info.t_color = Class'Interface.L2Util'.static.Inst().White;
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.bLineBreak = false;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = ((" (" $ MakeCostString(string(item.ItemNum))) $ ")");
					m_Info.nOffSetX = 0;
					m_Info.nOffSetY = -16;
					if((item.Reserved64 <= item.ItemNum))
					{
						m_Info.t_color = GetColor(0, 176, 255, 255);
					}
					else
					{
						m_Info.t_color = Class'Interface.L2Util'.static.Inst().Red;
					}
					EndItem();
				}
			}
			else if((TooltipType != "QuestReward"))
			{
				if((item.ItemNum > INT64(0)))
				{
					AddTooltipItemCount(item, 0, 1);
				}
			}
		}
		AddTooltipItemGrade(item, 0, 1);
		if((ItemSlotWithItemTypeStr != ""))
		{
			AddTooltipItemBlank(1);
			if(bBigSizeIcon)
			{
				AddTooltipColorText(ItemSlotWithItemTypeStr, GetColor(176, 155, 121, 255), false, true, false, "", (38 + 16), -(19 + 16));
			}
			else if((GetSystemString(14288) == ItemSlotWithItemTypeStr))
			{
				if((item.bSimpleExchangeItem == true))
				{
					addTooltipTexture("L2UI_NewTex.ToolTip.TooltipIcon_Swipe", 24, 24, 32, 32, true, false, 36, -22);
					AddTooltipColorText(GetSystemString(14289), getInstanceL2Util().Green, false, true, false, "", 2, -16);
				}
			}
			else
			{
				AddTooltipColorText(ItemSlotWithItemTypeStr, GetColor(176, 155, 121, 255), false, true, false, "", 38, -17);
			}
		}
		else if((isLiveServer == false))
		{
			if(((int(byte(item.EtcItemType)) == 7) && (item.PetEvolveStep > 0)))
			{
				AddTooltipItemBlank(1);
				Class'NWindow.PetAPI'.static.GetPetEvolveNameInfo(item.PetNamePrefixID, PetNameInfo);
				AddTooltipColorText(PetNameInfo.Desc, GetColor(176, 155, 121, 255), false, true, false, "", 38, -17);
			}
		}
		if((int(EEtcItemType) == 7))
		{
			if(getInstanceUIData().GetIsClassicServer())
			{
			}
			else
			{
				AddItemEnchantedImg(item.Enchanted);
			}
		}
		else
		{
			AddItemEnchantedImg(item.Enchanted);
		}
		if(isSImpleTooltipNoSelect(nUseSimpleTooltip, nIsSelectMode))
		{
			if((((((isAttribute(item) || isLevelUpBonus(item, TooltipType)) || isEnsoulOption(item)) || isBlessed(item)) || isCollectionItem(item)) || isHeroBookItem(item)))
			{
				AddTooltipItemBlank(0);
				addTooltipTextureSplitLineType("L2UI_NewTex.Tooltip.TooltipLine_BasicIconBG", 1, 35, 0, 0, 0, 0);
				if(isLevelUpBonus(item, TooltipType))
				{
					addTooltipTexture("L2UI_NewTex.Tooltip.TooltipICON_LV", 26, 26, 0, 0, true, false, 2, 5);
				}
				if(isBlessed(item))
				{
					addTooltipTexture("L2UI_NewTex.Tooltip.TooltipICON_bless", 26, 26, 0, 0, true, false, 2, 5);
				}
				if(isEnsoulOption(item))
				{
					AddSimpleIcon_EnsoulOption(item);
				}
				if(isAttribute(item))
				{
					addTooltipTexture("L2UI_NewTex.Tooltip.TooltipICON_AttackAttributeValue", 26, 26, 0, 0, true, false, 2, 5);
				}
				if(isCollectionItem(item))
				{
					addTooltipTexture("L2UI_NewTex.ToolTip.TooltipICON_Collection", 26, 26, 0, 0, true, false, 2, 5);
				}
				if(isHeroBookItem(item))
				{
					addTooltipTexture("L2UI_NewTex.ToolTip.TooltipIcon_Herobook", 26, 26, 0, 0, true, false, 2, 5);
				}
				AddTooltipItemBlank(0);
			}
			else
			{
				AddCrossLine();
				AddTooltipItemBlank(0);
			}
		}
		else
		{
			AddCrossLine();
			AddTooltipItemBlank(0);
		}
		if((IsAdena(item.Id) && (item.ItemNum > INT64(0))))
		{
			AddTooltipText((("(" $ ConvertNumToText(string(item.ItemNum))) $ ")"), true, true);
		}
		if(((TooltipType == "InventoryStackableUnitPrice") && !item.bEquipped))
		{
			strAdena = string(item.Price);
			strAdenaComma = MakeCostString(strAdena);
			AdenaColor = GetNumericColor(strAdenaComma);
			if((IsStackableItem(item.ConsumeType) && (item.ItemNum > INT64(1))))
			{
				AddTooltipItemBlank(2);
				AddTooltipColorText((GetSystemString(2511) $ " : "), GetColor(255, 180, 0, 255), true, true, false);
				AddTooltipColorText(((strAdenaComma $ " ") $ GetSystemString(469)), AdenaColor, false, true, , "", 0, 0);
			}
			else
			{
				AddTooltipItemOption(322, ((strAdenaComma $ " ") $ GetSystemString(469)), true, true, false, , , , , AdenaColor);
			}
			if((IsStackableItem(item.ConsumeType) && (item.ItemNum > INT64(1))))
			{
				strAdena = string((item.Price * item.ItemNum));
				strAdenaComma = MakeCostString(strAdena);
				AdenaColor = GetNumericColor(strAdenaComma);
				AddTooltipItemOption(2595, ((strAdenaComma $ " ") $ GetSystemString(469)), true, true, false, , , , , AdenaColor);
			}
			if((item.Price > INT64(0)))
			{
				AddTooltipItemOption(0, (("(" $ ConvertNumToText(strAdena)) $ ")"), false, true, false);
				SetTooltipItemColor(int(AdenaColor.R), int(AdenaColor.G), int(AdenaColor.B), 0);
			}
		}
		if(((((TooltipType == "InventoryPrice1") || (TooltipType == "InventoryPrice1HideEnchant")) || (TooltipType == "InventoryPrice1HideEnchantStackable")) && !item.bEquipped))
		{
			strAdena = string(item.Price);
			strAdenaComma = MakeCostString(strAdena);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(322, ((strAdenaComma $ " ") $ GetSystemString(469)), true, true, false);
			if((item.Price > INT64(0)))
			{
				AddTooltipItemOption(0, (("(" $ ConvertNumToText(strAdena)) $ ")"), false, true, false);
				SetTooltipItemColor(int(AdenaColor.R), int(AdenaColor.G), int(AdenaColor.B), 0);
			}
		}
		if(((TooltipType == "InventoryPrice2") || (TooltipType == "InventoryPrice2PrivateShop")))
		{
			strAdena = string(item.Price);
			strAdenaComma = MakeCostString(strAdena);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption2(322, 468, true, true, false);
			SetTooltipItemColor(int(AdenaColor.R), int(AdenaColor.G), int(AdenaColor.B), 0);
			AddTooltipColorText((((" " $ strAdenaComma) $ " ") $ GetSystemString(469)), AdenaColor, false, true, , , , 2);
			if((item.Price > INT64(0)))
			{
				AddTooltipColorText("(", AdenaColor, true, true);
				AddTooltipColorText(GetSystemString(468), AdenaColor, false, true);
				AddTooltipColorText(((" " $ ConvertNumToText(strAdena)) $ ")"), AdenaColor, false, true);
			}
		}
		if((TooltipType == "InventoryPrice2PrivateShop"))
		{
			if((IsStackableItem(item.ConsumeType) && (item.Reserved64 > INT64(0))))
			{
				AddTooltipItemOption(808, string(item.Reserved64), true, true, false);
			}
		}
		if((isShowPetEquipNotice == true))
		{
			GetPetInfo(PetInfo);
			if((PetInfo.nPetType == 1))
			{
				addTooltipTexture("L2UI_NewTex.PetWnd.Icon_Tooltip_Mercenary", 24, 24, 24, 24, true, false);
			}
			else
			{
				addTooltipTexture("L2UI_NewTex.PetWnd.Icon_Tooltip_Pet", 24, 24, 24, 24, true, false);
			}
			AddTooltipColorText(GetSystemString(14956), GetColor(255, 221, 102, 255), false, true, true, "", 1, 5);
			AddTooltipItemBlank(0);
			AddCrossLine();
		}
		switch(EItemType)
		{
			case ITEM_WEAPON:
				if((TooltipType == "InventoryPet"))
				{
					GetPetInfo(PetInfo);
				}
				GetPlayerInfo(myInfo);
				if(isLiveServer)
				{
					if((TooltipType == "InventoryPet"))
					{
						nPhysicalBonus = GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, PetInfo.nLevel);
						nMagicaBonus = GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, PetInfo.nLevel);
					}
					else
					{
						nPhysicalBonus = GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, myInfo.nLevel);
						nMagicaBonus = GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, myInfo.nLevel);
					}
					if((EnchantData.PropertyValue[2] != 0.0000000))
					{
						if((TooltipType == "InventoryPet"))
						{
							AddTooltipItemOption(94, cutZeroDecimalFloat((((item.pAttack + EnchantData.EnchantValue[2]) + float(GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, PetInfo.nLevel))) + EnchantData.PropertyValue[2])), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						else
						{
							AddTooltipItemOption(94, cutZeroDecimalFloat(((((item.pAttack + EnchantData.EnchantValue[2]) + float(GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, myInfo.nLevel))) + EnchantData.PropertyValue[2]) + float(myInfo.nAddPAttack))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						if((TooltipType == "InventoryPet"))
						{
							AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 3, nPhysicalBonus);
						}
						else
						{
							AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 3, nPhysicalBonus, myInfo.nAddPAttack);
						}
					}
					else if((item.pAttack != 0.0000000))
					{
						if((TooltipType == "InventoryPet"))
						{
							AddTooltipItemOption(94, cutZeroDecimalFloat(((item.pAttack + EnchantData.EnchantValue[2]) + float(GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, PetInfo.nLevel)))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						else
						{
							AddTooltipItemOption(94, cutZeroDecimalFloat((((item.pAttack + EnchantData.EnchantValue[2]) + float(GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, myInfo.nLevel))) + float(myInfo.nAddPAttack))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						if((TooltipType == "InventoryPet"))
						{
							AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 3, nPhysicalBonus);
						}
						else
						{
							AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 3, nPhysicalBonus, myInfo.nAddPAttack);
						}
					}
				}
				else
				{
					if(item.bEquipped)
					{
						if((TooltipType == "InventoryPet"))
						{
							if((IsCtrlKeyPressing == 1))
							{
								nPhysicalBonus = 0;
								nMagicaBonus = 0;
							}
							else
							{
								nPhysicalBonus = GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, PetInfo.nLevel);
								nMagicaBonus = GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, PetInfo.nLevel);
							}
						}
						else
						{
							nPhysicalBonus = GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, myInfo.nLevel);
							nMagicaBonus = GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, myInfo.nLevel);
						}
					}
					if((EnchantData.PropertyValue[2] != 0.0000000))
					{
						if(item.bEquipped)
						{
							if((TooltipType == "InventoryPet"))
							{
								AddTooltipItemOption(94, cutZeroDecimalFloat((((item.pAttack + EnchantData.EnchantValue[2]) + float(nPhysicalBonus)) + EnchantData.PropertyValue[2])), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
							else
							{
								AddTooltipItemOption(94, cutZeroDecimalFloat(((((item.pAttack + EnchantData.EnchantValue[2]) + float(nPhysicalBonus)) + EnchantData.PropertyValue[2]) + float(myInfo.nAddPAttack))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
						}
						else
						{
							AddTooltipItemOption(94, string((int(item.pAttack) + nEnchantedPhysicalDamageBonus)), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						if((TooltipType == "InventoryPet"))
						{
							AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 3, nPhysicalBonus);
						}
						else
						{
							AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 3, nPhysicalBonus, myInfo.nAddPAttack);
						}
					}
					else if((item.pAttack != 0.0000000))
					{
						if(item.bEquipped)
						{
							if((TooltipType == "InventoryPet"))
							{
								AddTooltipItemOption(94, cutZeroDecimalFloat(((item.pAttack + EnchantData.EnchantValue[2]) + float(nPhysicalBonus))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
							else
							{
								AddTooltipItemOption(94, cutZeroDecimalFloat((((item.pAttack + EnchantData.EnchantValue[2]) + float(nPhysicalBonus)) + float(myInfo.nAddPAttack))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							}
						}
						else
						{
							AddTooltipItemOption(94, string((int(item.pAttack) + nEnchantedPhysicalDamageBonus)), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						if((TooltipType == "InventoryPet"))
						{
							AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 3, nPhysicalBonus);
						}
						else
						{
							AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 3, nPhysicalBonus, myInfo.nAddPAttack);
						}
					}
				}
				if(isLiveServer)
				{
					if((EnchantData.PropertyValue[3] != 0.0000000))
					{
						if((TooltipType == "InventoryPet"))
						{
							AddTooltipItemOption(98, cutZeroDecimalFloat((((item.mAttack + EnchantData.EnchantValue[3]) + float(GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, PetInfo.nLevel))) + EnchantData.PropertyValue[3])), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						else
						{
							AddTooltipItemOption(98, cutZeroDecimalFloat(((((item.mAttack + EnchantData.EnchantValue[3]) + float(GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, myInfo.nLevel))) + EnchantData.PropertyValue[3]) + float(myInfo.nAddMAttack))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						if((TooltipType == "InventoryPet"))
						{
							AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 3, nMagicaBonus);
						}
						else
						{
							AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 3, nMagicaBonus, myInfo.nAddMAttack);
						}
					}
					else if((item.mAttack != 0.0000000))
					{
						if((TooltipType == "InventoryPet"))
						{
							AddTooltipItemOption(98, cutZeroDecimalFloat(((item.mAttack + EnchantData.EnchantValue[3]) + float(GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, PetInfo.nLevel)))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 3, nMagicaBonus);
						}
						else
						{
							AddTooltipItemOption(98, cutZeroDecimalFloat((((item.mAttack + EnchantData.EnchantValue[3]) + float(GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, myInfo.nLevel))) + float(myInfo.nAddMAttack))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 3, nMagicaBonus, myInfo.nAddMAttack);
						}
					}
				}
				else if((EnchantData.PropertyValue[3] != 0.0000000))
				{
					if(item.bEquipped)
					{
						if((TooltipType == "InventoryPet"))
						{
							AddTooltipItemOption(98, cutZeroDecimalFloat((((item.mAttack + EnchantData.EnchantValue[3]) + float(nMagicaBonus)) + EnchantData.PropertyValue[3])), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						else
						{
							AddTooltipItemOption(98, cutZeroDecimalFloat(((((item.mAttack + EnchantData.EnchantValue[3]) + float(nMagicaBonus)) + EnchantData.PropertyValue[3]) + float(myInfo.nAddMAttack))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
					}
					else
					{
						AddTooltipItemOption(98, string(int(((item.mAttack + EnchantData.PropertyValue[3]) + float(nEnchantedMagicalDamageBonus)))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
					}
					if((TooltipType == "InventoryPet"))
					{
						AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 3, nMagicaBonus);
					}
					else
					{
						AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 3, nMagicaBonus, myInfo.nAddMAttack);
					}
				}
				else if((item.mAttack != 0.0000000))
				{
					if(item.bEquipped)
					{
						if((TooltipType == "InventoryPet"))
						{
							AddTooltipItemOption(98, cutZeroDecimalFloat(((item.mAttack + EnchantData.EnchantValue[3]) + float(nMagicaBonus))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 3, nMagicaBonus);
						}
						else
						{
							AddTooltipItemOption(98, cutZeroDecimalFloat((((item.mAttack + EnchantData.EnchantValue[3]) + float(nMagicaBonus)) + float(myInfo.nAddMAttack))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 3, nMagicaBonus, myInfo.nAddMAttack);
						}
					}
					else if((TooltipType == "InventoryPet"))
					{
						AddTooltipItemOption(98, string(int(((item.mAttack + EnchantData.PropertyValue[3]) + float(nEnchantedMagicalDamageBonus)))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 3, nMagicaBonus);
					}
					else
					{
						AddTooltipItemOption(98, string(int(((item.mAttack + EnchantData.PropertyValue[3]) + float(nEnchantedMagicalDamageBonus)))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 3, nMagicaBonus, myInfo.nAddMAttack);
					}
				}
				AddTooltipItemOption(111, GetAttackSpeedString(int(item.pAttackSpeed)), true, true, false);
				if((item.pDefense > 0.0000000))
				{
					AddTooltipItemOption(54, string(item.pDefense), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				}
				if((item.mDefense > 0.0000000))
				{
					AddTooltipItemOption(99, string(item.mDefense), true, true, false);
				}
				if(((item.pHitRate + EnchantData.PropertyValue[7]) != 0.0000000))
				{
					AddTooltipItemOption(96, string((item.pHitRate + EnchantData.PropertyValue[7])), true, true, false);
				}
				if(((item.pCriRate + EnchantData.PropertyValue[9]) > 0.0000000))
				{
					AddTooltipItemOption(113, string((item.pCriRate + EnchantData.PropertyValue[9])), true, true, false);
				}
				if(((item.MoveSpeed + EnchantData.PropertyValue[11]) != 0.0000000))
				{
					AddTooltipItemOption(432, string((item.MoveSpeed + EnchantData.PropertyValue[11])), true, true, false);
				}
				if((item.ShieldDefense > 0.0000000))
				{
					AddTooltipItemOption(95, string(item.ShieldDefense), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				}
				if((item.ShieldDefenseRate > 0.0000000))
				{
					AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
				}
				if(((item.pAvoid + EnchantData.PropertyValue[14]) > 0.0000000))
				{
					AddTooltipItemOption(2361, string((item.pAvoid + EnchantData.PropertyValue[14])), true, true, false);
				}
				if(((item.mAvoid + EnchantData.PropertyValue[15]) > 0.0000000))
				{
					AddTooltipItemOption(2364, string((item.mAvoid + EnchantData.PropertyValue[15])), true, true, false);
				}
				if(((item.mAttackSpeed + EnchantData.PropertyValue[5]) > 0.0000000))
				{
					AddTooltipItemOption(112, string((item.mAttackSpeed + EnchantData.PropertyValue[5])), true, true, false);
				}
				bMagicWeapon = Class'NWindow.UIDATA_ITEM'.static.IsMagicWeapon(item.Id);
				if((item.SoulshotCount > 0))
				{
					AddTooltipItemOption(404, ("X" $ string(item.SoulshotCount)), true, true, false);
				}
				if((item.SpiritshotCount > 0))
				{
					AddTooltipItemOption(496, ("X" $ string(item.SpiritshotCount)), true, true, false);
				}
				if(((item.SoulshotCount > 0) || (item.SpiritshotCount > 0)))
				{
					fSoulShotPower = GetSoulShotPower(item.CrystalType, item.Enchanted, item.WeaponType, bMagicWeapon);
					fSpiritShotPower = GetSpiritShotPower(item.CrystalType, item.Enchanted, item.WeaponType, bMagicWeapon);
					if((fSoulShotPower == fSpiritShotPower))
					{
						if((fSoulShotPower > 0.0000000))
						{
							AddTooltipItemBlank(2);
							AddTooltipColorText((GetSystemMessage(4297) $ " : "), GetColor(163, 163, 163, 255), true, true);
							AddTooltipColorText((("+" $ string(fSoulShotPower)) $ "%"), GetColor(238, 170, 34, 255), false, true);
						}
					}
					else
					{
						AddTooltipItemBlank(2);
						AddTooltipColorText((GetSystemMessage(4297) $ " : "), GetColor(163, 163, 163, 255), true, true);
						AddTooltipColorText(((((("+" $ string(fSoulShotPower)) $ "%") $ ", ") $ string(fSpiritShotPower)) $ "%"), GetColor(238, 170, 34, 255), false, true);
					}
				}
				if((item.Weight == 0))
				{
					AddTooltipItemOption(52, " 0 ", true, true, false);
				}
				else
				{
					AddTooltipItemOption(52, string(item.Weight), true, true, false);
				}
				if((item.MpConsume != 0))
				{
					AddTooltipItemOption(320, string(item.MpConsume), true, true, false);
				}
				break;
			case ITEM_ARMOR:
				nAddPhysicalDefendValue = Class'NWindow.UIDATA_PLAYER'.static.GetAddPhysicalDefendValue(item.SlotBitType);
				StartItem();
				ParamAdd(m_Info.Condition, "Type", "AddPDefend");
				ParamAdd(m_Info.Condition, "Value", string(nAddPhysicalDefendValue));
				EndItem();
				if(((item.SlotBitType == INT64(256)) && (item.ArmorType == 4)))
				{
					if((((item.pDefense + EnchantData.EnchantValue[0]) + float(nAddPhysicalDefendValue)) != 0.0000000))
					{
						AddTooltipItemOption(95, cutZeroDecimalFloat(((item.pDefense + EnchantData.EnchantValue[0]) + float(nAddPhysicalDefendValue))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 3, , nAddPhysicalDefendValue);
					}
					if((EnchantData.PropertyValue[14] != 0.0000000))
					{
						AddTooltipItemOption(2361, string((item.pAvoid + EnchantData.PropertyValue[14])), true, true, false);
					}
					else if((item.pAvoid != 0.0000000))
					{
						AddTooltipItemOption(2361, string(item.pAvoid), true, true, false);
					}
					if(((item.pAttack + EnchantData.PropertyValue[2]) > 0.0000000))
					{
						AddTooltipItemOption(94, string((item.pAttack + EnchantData.PropertyValue[2])), true, true, false);
					}
					if(((item.mAttack + EnchantData.PropertyValue[3]) > 0.0000000))
					{
						AddTooltipItemOption(98, string((item.mAttack + EnchantData.PropertyValue[3])), true, true, false);
					}
					if(((item.mAttackSpeed + EnchantData.PropertyValue[5]) > 0.0000000))
					{
						AddTooltipItemOption(112, string((item.mAttackSpeed + EnchantData.PropertyValue[5])), true, true, false);
					}
					if(((item.pHitRate + EnchantData.PropertyValue[7]) > 0.0000000))
					{
						AddTooltipItemOption(2360, string((item.pHitRate + EnchantData.PropertyValue[7])), true, true, false);
					}
					if(((item.mHitRate + EnchantData.PropertyValue[8]) > 0.0000000))
					{
						AddTooltipItemOption(2363, string((item.mHitRate + EnchantData.PropertyValue[8])), true, true, false);
					}
					if(((item.pCriRate + EnchantData.PropertyValue[9]) > 0.0000000))
					{
						AddTooltipItemOption(2362, string((item.pCriRate + EnchantData.PropertyValue[9])), true, true, false);
					}
					if(((item.mCriRate + EnchantData.PropertyValue[10]) > 0.0000000))
					{
						AddTooltipItemOption(2365, string((item.mCriRate + EnchantData.PropertyValue[10])), true, true, false);
					}
					if(((item.MoveSpeed + EnchantData.PropertyValue[11]) != 0.0000000))
					{
						AddTooltipItemOption(432, string((item.MoveSpeed + EnchantData.PropertyValue[11])), true, true, false);
					}
					if((item.ShieldDefense > 0.0000000))
					{
						AddTooltipItemOption(95, string(item.ShieldDefense), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
					}
					if((item.ShieldDefenseRate > 0.0000000))
					{
						AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
					}
					if(((item.pAvoid + EnchantData.PropertyValue[14]) > 0.0000000))
					{
						AddTooltipItemOption(2361, string((item.pAvoid + EnchantData.PropertyValue[14])), true, true, false);
					}
					if(((item.mAvoid + EnchantData.PropertyValue[15]) > 0.0000000))
					{
						AddTooltipItemOption(2364, string((item.mAvoid + EnchantData.PropertyValue[15])), true, true, false);
					}
					if((item.mDefense > 0.0000000))
					{
						AddTooltipItemOption(99, string(int(item.mDefense)), true, true, false);
					}
					if((item.Weight != 0))
					{
						AddTooltipItemOption(52, string(item.Weight), true, true, false);
					}
				}
				else if(((item.SlotBitType == INT64(256)) || (item.SlotBitType == INT64(128))))
				{
					if((item.ShieldDefense != 0.0000000))
					{
						AddTooltipItemOption(13206, cutZeroDecimalFloat((item.ShieldDefense + EnchantData.EnchantValue[12])), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						AddTooltipItemBonus(int(item.ShieldDefense), nEnchantedShieldDefenseBonus, 0, 3);
					}
					if((EnchantData.PropertyValue[14] != 0.0000000))
					{
						AddTooltipItemOption(2361, string((item.pAvoid + EnchantData.PropertyValue[14])), true, true, false);
					}
					else if((item.pAvoid != 0.0000000))
					{
						AddTooltipItemOption(2361, string(item.pAvoid), true, true, false);
					}
					if((item.pDefense > 0.0000000))
					{
						AddTooltipItemOption(54, string(item.pDefense), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
					}
					if((item.mDefense > 0.0000000))
					{
						AddTooltipItemOption(99, string(int(item.mDefense)), true, true, false);
					}
					if(((item.pAttack + EnchantData.PropertyValue[2]) > 0.0000000))
					{
						AddTooltipItemOption(94, string((item.pAttack + EnchantData.PropertyValue[2])), true, true, false);
					}
					if(((item.mAttack + EnchantData.PropertyValue[3]) > 0.0000000))
					{
						AddTooltipItemOption(98, string((item.mAttack + EnchantData.PropertyValue[3])), true, true, false);
					}
					if(((item.mAttackSpeed + EnchantData.PropertyValue[5]) > 0.0000000))
					{
						AddTooltipItemOption(112, string((item.mAttackSpeed + EnchantData.PropertyValue[5])), true, true, false);
					}
					if(((item.pHitRate + EnchantData.PropertyValue[7]) > 0.0000000))
					{
						AddTooltipItemOption(2360, string((item.pHitRate + EnchantData.PropertyValue[7])), true, true, false);
					}
					if(((item.mHitRate + EnchantData.PropertyValue[8]) > 0.0000000))
					{
						AddTooltipItemOption(2363, string((item.mHitRate + EnchantData.PropertyValue[8])), true, true, false);
					}
					if(((item.pCriRate + EnchantData.PropertyValue[9]) > 0.0000000))
					{
						AddTooltipItemOption(2362, string((item.pCriRate + EnchantData.PropertyValue[9])), true, true, false);
					}
					if(((item.mCriRate + EnchantData.PropertyValue[10]) > 0.0000000))
					{
						AddTooltipItemOption(2365, string((item.mCriRate + EnchantData.PropertyValue[10])), true, true, false);
					}
					if(((item.MoveSpeed + EnchantData.PropertyValue[11]) != 0.0000000))
					{
						AddTooltipItemOption(432, string((item.MoveSpeed + EnchantData.PropertyValue[11])), true, true, false);
					}
					if((item.ShieldDefenseRate > 0.0000000))
					{
						AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
					}
					if(((item.pAvoid + EnchantData.PropertyValue[14]) > 0.0000000))
					{
						AddTooltipItemOption(2361, string((item.pAvoid + EnchantData.PropertyValue[14])), true, true, false);
					}
					if(((item.mAvoid + EnchantData.PropertyValue[15]) > 0.0000000))
					{
						AddTooltipItemOption(2364, string((item.mAvoid + EnchantData.PropertyValue[15])), true, true, false);
					}
					if((item.Weight != 0))
					{
						AddTooltipItemOption(52, string(item.Weight), true, true, false);
					}
				}
				else if(IsMagicalArmor(item.Id))
				{
					if((item.MpBonus > 0))
					{
						AddTooltipItemOption(388, string(item.MpBonus), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
					}
					if((((item.SlotBitType == INT64(65536)) || (item.SlotBitType == INT64(524288))) || (item.SlotBitType == INT64(262144))))
					{
						if((((item.pDefense + EnchantData.EnchantValue[0]) + float(nAddPhysicalDefendValue)) != 0.0000000))
						{
							AddTooltipItemOption(95, cutZeroDecimalFloat(((item.pDefense + EnchantData.EnchantValue[0]) + float(nAddPhysicalDefendValue))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 3, , nAddPhysicalDefendValue);
						}
					}
					else
					{
						if((((item.pDefense + EnchantData.EnchantValue[0]) + float(nAddPhysicalDefendValue)) != 0.0000000))
						{
							AddTooltipItemOption(95, cutZeroDecimalFloat(((item.pDefense + EnchantData.EnchantValue[0]) + float(nAddPhysicalDefendValue))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 3, , nAddPhysicalDefendValue);
						}
						if((item.mDefense > 0.0000000))
						{
							AddTooltipItemOption(99, string(int(item.mDefense)), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						if(((item.pAttack + EnchantData.PropertyValue[2]) > 0.0000000))
						{
							AddTooltipItemOption(94, string((item.pAttack + EnchantData.PropertyValue[2])), true, true, false);
						}
						if(((item.mAttack + EnchantData.PropertyValue[3]) > 0.0000000))
						{
							AddTooltipItemOption(98, string((item.mAttack + EnchantData.PropertyValue[3])), true, true, false);
						}
						if(((item.mAttackSpeed + EnchantData.PropertyValue[5]) > 0.0000000))
						{
							AddTooltipItemOption(112, string((item.mAttackSpeed + EnchantData.PropertyValue[5])), true, true, false);
						}
						if(((item.pHitRate + EnchantData.PropertyValue[7]) > 0.0000000))
						{
							AddTooltipItemOption(2360, string((item.pHitRate + EnchantData.PropertyValue[7])), true, true, false);
						}
						if(((item.mHitRate + EnchantData.PropertyValue[8]) > 0.0000000))
						{
							AddTooltipItemOption(2363, string((item.mHitRate + EnchantData.PropertyValue[8])), true, true, false);
						}
						if(((item.pCriRate + EnchantData.PropertyValue[9]) > 0.0000000))
						{
							AddTooltipItemOption(2362, string((item.pCriRate + EnchantData.PropertyValue[9])), true, true, false);
						}
						if(((item.mCriRate + EnchantData.PropertyValue[10]) > 0.0000000))
						{
							AddTooltipItemOption(2365, string((item.mCriRate + EnchantData.PropertyValue[10])), true, true, false);
						}
						if(((item.MoveSpeed + EnchantData.PropertyValue[11]) != 0.0000000))
						{
							AddTooltipItemOption(432, string((item.MoveSpeed + EnchantData.PropertyValue[11])), true, true, false);
						}
						if((item.ShieldDefenseRate > 0.0000000))
						{
							AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
						}
						if(((item.pAvoid + EnchantData.PropertyValue[14]) > 0.0000000))
						{
							AddTooltipItemOption(2361, string((item.pAvoid + EnchantData.PropertyValue[14])), true, true, false);
						}
						if(((item.mAvoid + EnchantData.PropertyValue[15]) > 0.0000000))
						{
							AddTooltipItemOption(2364, string((item.mAvoid + EnchantData.PropertyValue[15])), true, true, false);
						}
						if((item.ShieldDefense > 0.0000000))
						{
							AddTooltipItemOption(95, string(item.ShieldDefense), true, true, false);
						}
						if((item.ShieldDefenseRate > 0.0000000))
						{
							AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
						}
					}
					if((item.Weight != 0))
					{
						AddTooltipItemOption(52, string(item.Weight), true, true, false);
					}
				}
				else
				{
					if((((item.SlotBitType == INT64(65536)) || (item.SlotBitType == INT64(524288))) || (item.SlotBitType == INT64(262144))))
					{
						if((((item.pDefense + EnchantData.EnchantValue[0]) + float(nAddPhysicalDefendValue)) != 0.0000000))
						{
							AddTooltipItemOption(95, cutZeroDecimalFloat(((item.pDefense + EnchantData.EnchantValue[0]) + float(nAddPhysicalDefendValue))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 3, , nAddPhysicalDefendValue);
						}
					}
					else
					{
						if((((item.pDefense + EnchantData.EnchantValue[0]) + float(nAddPhysicalDefendValue)) != 0.0000000))
						{
							AddTooltipItemOption(95, cutZeroDecimalFloat(((item.pDefense + EnchantData.EnchantValue[0]) + float(nAddPhysicalDefendValue))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
							AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 3, , nAddPhysicalDefendValue);
						}
						if((item.mDefense > 0.0000000))
						{
							AddTooltipItemOption(99, string(int(item.mDefense)), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						if(((item.pAttack + EnchantData.PropertyValue[2]) > 0.0000000))
						{
							AddTooltipItemOption(94, string((item.pAttack + EnchantData.PropertyValue[2])), true, true, false);
						}
						if(((item.mAttack + EnchantData.PropertyValue[3]) > 0.0000000))
						{
							AddTooltipItemOption(98, string((item.mAttack + EnchantData.PropertyValue[3])), true, true, false);
						}
						if(((item.mAttackSpeed + EnchantData.PropertyValue[5]) > 0.0000000))
						{
							AddTooltipItemOption(112, string((item.mAttackSpeed + EnchantData.PropertyValue[5])), true, true, false);
						}
						if(((item.pHitRate + EnchantData.PropertyValue[7]) > 0.0000000))
						{
							AddTooltipItemOption(2360, string((item.pHitRate + EnchantData.PropertyValue[7])), true, true, false);
						}
						if(((item.mHitRate + EnchantData.PropertyValue[8]) > 0.0000000))
						{
							AddTooltipItemOption(2363, string((item.mHitRate + EnchantData.PropertyValue[8])), true, true, false);
						}
						if(((item.pCriRate + EnchantData.PropertyValue[9]) > 0.0000000))
						{
							AddTooltipItemOption(2362, string((item.pCriRate + EnchantData.PropertyValue[9])), true, true, false);
						}
						if(((item.mCriRate + EnchantData.PropertyValue[10]) > 0.0000000))
						{
							AddTooltipItemOption(2365, string((item.mCriRate + EnchantData.PropertyValue[10])), true, true, false);
						}
						if(((item.MoveSpeed + EnchantData.PropertyValue[11]) != 0.0000000))
						{
							AddTooltipItemOption(432, string((item.MoveSpeed + EnchantData.PropertyValue[11])), true, true, false);
						}
						if((item.ShieldDefenseRate > 0.0000000))
						{
							AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
						}
						if(((item.pAvoid + EnchantData.PropertyValue[14]) > 0.0000000))
						{
							AddTooltipItemOption(2361, string((item.pAvoid + EnchantData.PropertyValue[14])), true, true, false);
						}
						if(((item.mAvoid + EnchantData.PropertyValue[15]) > 0.0000000))
						{
							AddTooltipItemOption(2364, string((item.mAvoid + EnchantData.PropertyValue[15])), true, true, false);
						}
						if((item.ShieldDefense > 0.0000000))
						{
							AddTooltipItemOption(95, string(item.ShieldDefense), true, true, false);
						}
						if((item.ShieldDefenseRate > 0.0000000))
						{
							AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
						}
					}
					if((item.Weight != 0))
					{
						AddTooltipItemOption(52, string(item.Weight), true, true, false);
					}
				}
				break;
			case ITEM_ACCESSARY:
				nAddMagicalDefendValue = Class'NWindow.UIDATA_PLAYER'.static.GetAddMagicalDefendValue(item.SlotBitType);
				StartItem();
				ParamAdd(m_Info.Condition, "Type", "AddMDefend");
				ParamAdd(m_Info.Condition, "Value", string(nAddMagicalDefendValue));
				EndItem();
				if(((((((item.SlotBitType == INT64("206158430208")) || (item.SlotBitType == INT64(16))) || (item.SlotBitType == INT64(32))) || (item.SlotBitType == INT64(64))) || (item.SlotBitType == INT64(128))) || (item.SlotBitType == INT64(256))))
				{
					AddAgathionSkillTooltip(item, (TooltipType == "InventoryAgathionEct"));
				}
				if(getInstanceUIData().GetIsClassicServer())
				{
					if((((((item.SlotBitType != INT64(536870912)) && (item.SlotBitType != INT64(1073741824))) && (item.SlotBitType != INT64(1048576))) && (item.SlotBitType != INT64(2097152))) && !IsArtifactRuneItem(item)))
					{
						if((((item.mDefense + EnchantData.EnchantValue[1]) + float(nAddMagicalDefendValue)) > 0.0000000))
						{
							AddTooltipItemOption(99, cutZeroDecimalFloat(((item.mDefense + EnchantData.EnchantValue[1]) + float(nAddMagicalDefendValue))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
						}
						AddTooltipItemBonus(int(item.mDefense), nEnchantedMagicalDefenseBonus, 0, 3, , nAddMagicalDefendValue);
					}
				}
				else if((((((item.SlotBitType != INT64(1073741824)) && (item.SlotBitType != INT64(4194304))) && (item.SlotBitType != INT64(1048576))) && (item.SlotBitType != INT64(2097152))) && !IsArtifactRuneItem(item)))
				{
					if((((item.mDefense + EnchantData.EnchantValue[1]) + float(nAddMagicalDefendValue)) > 0.0000000))
					{
						AddTooltipItemOption(99, cutZeroDecimalFloat(((item.mDefense + EnchantData.EnchantValue[1]) + float(nAddMagicalDefendValue))), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
					}
					AddTooltipItemBonus(int(item.mDefense), nEnchantedMagicalDefenseBonus, 0, 3, , nAddMagicalDefendValue);
				}
				if((item.Weight == 0))
				{
					AddTooltipItemOption(52, " 0 ", true, true, false);
				}
				else
				{
					AddTooltipItemOption(52, string(item.Weight), true, true, false);
				}
				break;
			case ITEM_QUESTITEM:
				break;
			case ITEM_ETCITEM:
				if((int(EEtcItemType) == 54))
				{
					CardEventImgTooltip(item, "inventory");
				}
				else if((int(EEtcItemType) == 7))
				{
					if(getInstanceUIData().GetIsLiveServer())
					{
						if((item.Damaged == 0))
						{
							nTmp = 971;
						}
						else
						{
							nTmp = 970;
						}
						AddTooltipItemOption2(969, nTmp, true, true, false);
						AddTooltipItemOption(88, string(item.Enchanted), true, true, false);
					}
					else
					{
						if((item.PetEvolveStep <= 0))
						{
							AddTooltipItemOption2(969, 971, true, true, false);
						}
						else
						{
							Class'NWindow.PetAPI'.static.GetPetEvolveNameInfo(item.PetNameID, PetNameInfo);
							petNameStr = PetNameInfo.Name;
							Class'NWindow.PetAPI'.static.GetPetEvolveNameInfo(item.PetNamePrefixID, PetNameInfo);
							petNameStr = (PetNameInfo.Name @ petNameStr);
							AddTooltipItemOption(969, petNameStr, true, true, false);
						}
						AddTooltipItemOption(88, string(item.Enchanted), true, true, false);
						if((item.PetID > 0))
						{
							AddTooltipItemOption(14808, (((GetSystemString(getInstanceL2Util().GetPetEvolveStepStringId(EPetType(Class'NWindow.PetAPI'.static.GetPetType(item.PetID)), item.PetEvolveStep)) @ "(") $ MakeFullSystemMsg(GetSystemMessage(5203), string(item.PetEvolveStep))) $ ")"), true, true, false);
						}
						else
						{
							AddTooltipItemOption(14808, "", true, true, false);
						}
					}
				}
				else if((int(EEtcItemType) == 15))
				{
					AddTooltipItemOption(972, string(item.Enchanted), true, true, false);
				}
				else if((int(EEtcItemType) == 13))
				{
					AddTooltipItemOption(670, string(item.Blessed), true, true, false);
					AddTooltipItemOption(671, GetLottoString(item.LookChangeItemID), true, true, false);
				}
				else if((int(EEtcItemType) == 14))
				{
					AddTooltipItemOption(670, string(item.Enchanted), true, true, false);
					AddTooltipItemOption(671, GetRaceTicketString(item.Blessed), true, true, false);
					AddTooltipItemOption(744, string((item.Damaged * 100)), true, true, false);
				}
				else if((item.MaxUseCount > 0))
				{
					AddCrossLine();
					AddTooltipItemBlank(0);
					if(IsAdenServer())
					{
						if((item.MaxReuseDelay != 0.0000000))
						{
							addTexture("l2ui_ct1.SkillWnd_DF_ListIcon_use", 12, 11, 12, 11, 3, 7);
							AddTooltipColorText((GetSystemString(2378) $ " : "), GetColor(163, 163, 163, 255), false, true, false, "", 0, 2);
							StartItem();
							m_Info.eType = DIT_TEXT;
							m_Info.nOffSetY = 2;
							m_Info.bLineBreak = false;
							m_Info.t_bDrawOneLine = true;
							m_Info.t_color = GetColor(176, 155, 121, 255);
							if((item.MaxReuseDelay < 0.0000000))
							{
								m_Info.t_strText = GetSystemString(3804);
							}
							else if((item.RemainReuseDelay == 0.0000000))
							{
								m_Info.t_strText = GetSystemString(3537);
							}
							else
							{
								m_Info.t_strText = MakeTimeStr(int(item.RemainReuseDelay));
								ParamAdd(m_Info.Condition, "Type", "ReuseDelay");
							}
							EndItem();
						}
						AddTooltipItemBlank(0);
						addTexture("L2UI_EPIC.ToolTip.use_count_caution", 12, 11, 12, 11, 3, 7);
						AddTooltipColorText((GetSystemString(3802) $ " : "), GetColor(163, 163, 163, 255), false, true, false, "", 0, 2);
						AddTooltipColorText(((string((item.MaxUseCount - item.CurUseCount)) $ "/") $ string(item.MaxUseCount)), GetColor(176, 155, 121, 255), false, true, false, "", 0, 2);
						AddTooltipColorText((("  (" $ GetSystemString(3803)) $ ")"), GetColor(238, 170, 34, 255), true, true);
						AddCrossLine();
						AddTooltipItemBlank(0);
					}
					else
					{
						AddTooltipText((("<" $ GetSystemString(3801)) $ ">"), true, true);
						AddTooltipItemBlank(0);
						addTexture("l2ui_ct1.SkillWnd_DF_ListIcon_use", 12, 11, 12, 11, 3, 7);
						AddTooltipColorText((GetSystemString(2378) $ " : "), GetColor(163, 163, 163, 255), false, true, false, "", 0, 2);
						StartItem();
						m_Info.eType = DIT_TEXT;
						m_Info.nOffSetY = 2;
						m_Info.bLineBreak = false;
						m_Info.t_bDrawOneLine = true;
						m_Info.t_color = GetColor(176, 155, 121, 255);
						if((item.MaxReuseDelay < 0.0000000))
						{
							m_Info.t_strText = GetSystemString(3804);
						}
						else if((item.RemainReuseDelay == 0.0000000))
						{
							m_Info.t_strText = GetSystemString(3537);
						}
						else
						{
							m_Info.t_strText = MakeTimeStr(int(item.RemainReuseDelay));
							ParamAdd(m_Info.Condition, "Type", "ReuseDelay");
						}
						EndItem();
						AddTooltipItemBlank(0);
						addTexture("l2ui_ct1.Icon.Tooltip_CubeIcon", 12, 11, 12, 11, 3, 7);
						AddTooltipColorText((GetSystemString(3802) $ " : "), GetColor(163, 163, 163, 255), false, true, false, "", 0, 2);
						AddTooltipColorText(((string((item.MaxUseCount - item.CurUseCount)) $ "/") $ string(item.MaxUseCount)), GetColor(176, 155, 121, 255), false, true, false, "", 0, 2);
						AddTooltipColorText((("  (" $ GetSystemString(3803)) $ ")"), GetColor(238, 170, 34, 255), true, true);
						AddCrossLine();
						AddTooltipItemBlank(0);
					}
				}
				if((int(EEtcItemType) != 54))
				{
					if((item.Weight == 0))
					{
						AddTooltipItemOption(52, " 0 ", true, true, false);
					}
					else
					{
						AddTooltipItemOption(52, string(item.Weight), true, true, false);
					}
				}
				break;
			default:
				break;
		}
		if(isSImpleTooltipNoSelect(nUseSimpleTooltip, nIsSelectMode))
		{
			AddItemDesc(item);
			if((TooltipType != "DetailTooltipList"))
			{
			}
			AddPetPreviewInfo(item);
			if((TooltipType != "DetailTooltipList"))
			{
			}
			AddItemSimpleExchangeItem(item);
			if((TooltipType != "DetailTooltipList"))
			{
			}
			AddTooltipCreateInfos(item);
			AddTooltipItemCurrentPeriod(item);
			AddAutomaticUseItem(item);
			AddTooltipItemDurability(item);
			AddTooltipItemQuestList(item);
			AddTooltipItemWeaponLookChange(item);
			AddTooltipRefinery(item);
			AddSimpleSetitem(item);
		}
		else
		{
			AddItemDesc(item);
			if((TooltipType != "DetailTooltipList"))
			{
			}
			AddPetPreviewInfo(item);
			if((TooltipType != "DetailTooltipList"))
			{
				AddItemSimpleExchangeItem(item);
			}
			if((TooltipType != "DetailTooltipList"))
			{
				AddTooltipCreateInfos(item);
			}
			AddTooltipItemCurrentPeriod(item);
			AddAutomaticUseItem(item);
			AddTooltipItemDurability(item);
			AddTooltipItemQuestList(item);
			AddTooltipBR_MaxEnergy(item);
			AddTooltipRefinery(item);
			AddSetitemTooltip(item);
			AddTooltipItemLevelUpBonus(item, TooltipType, IsCtrlKeyPressing);
			AddEnchantEffectDescTooltip(item);
			AddAdenLabCardEffectTooltip(item);
			AddTooltipEventSeventhdayOfSeventhMonth(item);
			AddEnsoulOption(item);
			if((TooltipType != "InventoryPet"))
			{
				AddTooltipItemAttributeGage(item);
			}
			AddBlessed(item);
			AddCollectionItem(item);
			AddHeroBookItem(item);
			AddSecurityLock(item);
			AddTooltipItemWeaponLookChange(item);
			AddActiveRelicInfo(item);
			if((TooltipType == "InventoryPawnViewer"))
			{
				AddTooltipText(("ID : " $ string(item.Id.ClassID)), true, true);
			}
		}
	}
	else
	{
		return;
	}
	if(!IsAdena(item.Id))
	{
		addForbidItemDesc(item);
		AddDeleteDBData(item);
		if((item.tooltipBGDecoTexture != ""))
		{
			m_Tooltip.MinimumWidth = 300;
		}
		else
		{
			switch(EItemType)
			{
				case ITEM_WEAPON:
				case ITEM_ARMOR:
				case ITEM_ACCESSARY:
					m_Tooltip.MinimumWidth = 230;
					break;
				default:
					if((item.CurrentPeriod > 0))
					{
						setMakeTimeStrMaxWidth();
					}
					else if((item.nDBDeleteDate > INT64(0)))
					{
						m_Tooltip.MinimumWidth = 230;
					}
					else
					{
						m_Tooltip.MinimumWidth = 230;
					}
			}
		}
	}
	if(!onlyMakeCustomTooltip)
	{
		ReturnTooltipInfo(m_Tooltip);
	}
	return;
}

function ItemInfo ConvertPetItemStat(ItemInfo ItemInfo)
{
	local PetAPI.PetEquipInfo PetEquipInfo;

	if((Class'NWindow.PetAPI'.static.GetPetEquipInfo(ItemInfo.Id.ClassID, byte(ItemInfo.Enchanted), PetEquipInfo) == false))
	{
		return ItemInfo;
	}
	ItemInfo.pDefense = PetEquipInfo.pDefense;
	ItemInfo.mDefense = PetEquipInfo.mDefense;
	ItemInfo.pAttack = PetEquipInfo.pAttack;
	ItemInfo.mAttack = PetEquipInfo.mAttack;
	ItemInfo.pAttackSpeed = PetEquipInfo.pAttackSpeed;
	ItemInfo.pHitRate = PetEquipInfo.pHitRate;
	ItemInfo.pCriRate = PetEquipInfo.pCriRate;
	ItemInfo.ShieldDefense = PetEquipInfo.ShieldDefense;
	ItemInfo.ShieldDefenseRate = PetEquipInfo.ShieldDefenseRate;
	ItemInfo.pAvoid = PetEquipInfo.pAvoid;
	ItemInfo.SoulshotCount = int(PetEquipInfo.SoulshotCount);
	ItemInfo.SpiritshotCount = int(PetEquipInfo.SpiritshotCount);
	return ItemInfo;
}

function GetItemDescriptionAdditionData(ItemID ItemClassID, int enchantNum, out string forbidItemDesc, out string enableItemDesc)
{
	local ItemInfo ItemData;
	local string EtcStr, EmptyStr;
	local bool bIsChange;
	local KeepSelectInfo keepInfo;
	local UIEventManager.EKeepType keepSelectNum;
	local int DescCheckLen;

	EtcStr = "/";
	EmptyStr = " ";
	bIsChange = false;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(ItemClassID, ItemData);
	if(((((int(GetLanguage()) == 8) || (int(GetLanguage()) == 1)) || (int(GetLanguage()) == 9)) || (int(GetLanguage()) == 14)))
	{
		bIsChange = true;
	}
	if(((((((bIsChange && ItemData.bIsNpcTradeAble) && ItemData.bIsAuctionAble) && ItemData.bIsPrivateType) && ItemData.bIsDesturctAble) && ItemData.bIsDropAble) && ItemData.bIsTradeAble))
	{
		bIsChange = false;
	}
	if(bIsChange)
	{
		forbidItemDesc = (forbidItemDesc $ GetSystemString(3342));
		forbidItemDesc = (forbidItemDesc $ EmptyStr);
		DescCheckLen = Len(forbidItemDesc);
	}
	if(IsAdenServer())
	{
		if((ItemData.bIsTradeAble == false))
		{
			forbidItemDesc = (forbidItemDesc $ GetSystemString(14699));
			forbidItemDesc = (forbidItemDesc $ EtcStr);
		}
	}
	else if((ItemData.bIsTradeAble == false))
	{
		if((((((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)) || (int(GetLanguage()) == 12)) || (int(GetLanguage()) == 14)) || (int(GetLanguage()) == 1)))
		{
			forbidItemDesc = (forbidItemDesc $ GetSystemString(3336));
		}
		else
		{
			forbidItemDesc = (forbidItemDesc $ GetSystemString(445));
		}
		forbidItemDesc = (forbidItemDesc $ EtcStr);
	}
	if(!IsAdenServer())
	{
		if((ItemData.bIsDropAble == false))
		{
			forbidItemDesc = (forbidItemDesc $ GetSystemString(3337));
			forbidItemDesc = (forbidItemDesc $ EtcStr);
		}
	}
	if((ItemData.bIsDesturctAble == false))
	{
		forbidItemDesc = (forbidItemDesc $ GetSystemString(3338));
		forbidItemDesc = (forbidItemDesc $ EtcStr);
	}
	if(!IsAdenServer())
	{
		if((ItemData.bIsPrivateType == false))
		{
			forbidItemDesc = (forbidItemDesc $ GetSystemString(3339));
			forbidItemDesc = (forbidItemDesc $ EtcStr);
		}
	}
	if((ItemData.bIsAuctionAble == false))
	{
		if(getInstanceUIData().GetIsLiveServer())
		{
			if(((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)))
			{
				forbidItemDesc = (forbidItemDesc $ GetSystemString(5245));
			}
			else
			{
				forbidItemDesc = (forbidItemDesc $ GetSystemString(3340));
			}
			forbidItemDesc = (forbidItemDesc $ EtcStr);
		}
		else if(IsAdenServer())
		{
			if(((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)))
			{
				forbidItemDesc = (forbidItemDesc $ GetSystemString(5245));
			}
			else
			{
				forbidItemDesc = (forbidItemDesc $ GetSystemString(14063));
			}
			forbidItemDesc = (forbidItemDesc $ EtcStr);
		}
	}
	if((ItemData.bIsNpcTradeAble == false))
	{
		forbidItemDesc = (forbidItemDesc $ GetSystemString(3341));
		forbidItemDesc = (forbidItemDesc $ EtcStr);
	}
	if((Len(forbidItemDesc) > 0))
	{
		if(bIsChange)
		{
			forbidItemDesc = Left(forbidItemDesc, (Len(forbidItemDesc) - 1));
			forbidItemDesc = (forbidItemDesc $ ".");
		}
		else
		{
			forbidItemDesc = Left(forbidItemDesc, (Len(forbidItemDesc) - 1));
			forbidItemDesc = (forbidItemDesc $ EmptyStr);
			forbidItemDesc = (forbidItemDesc $ GetSystemString(3342));
		}
	}
	if((DescCheckLen == Len(forbidItemDesc)))
	{
		forbidItemDesc = "";
	}
	if(GetItemKeepSelectInfo(ItemClassID, keepInfo))
	{
		if((int(keepInfo.KeepSelectType) == 1))
		{
			if((enchantNum < keepInfo.KeepEnchantCondition))
			{
				keepSelectNum = EKeepType(keepInfo.KeepOption1);
			}
			else
			{
				keepSelectNum = EKeepType(keepInfo.KeepOption2);
			}
		}
		else
		{
			keepSelectNum = EKeepType(ItemData.nKeepType);
		}
		switch(keepSelectNum)
		{
			case EKT_INDIVIDUAL:
				enableItemDesc = (enableItemDesc $ GetSystemString(3321));
				break;
			case EKT_PLEDGE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3322));
				break;
			case EKT_INDIVIDUAL_PLEDGE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3323));
				break;
			case EKT_CASTLE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3324));
				break;
			case EKT_INDIVIDUAL_CASTLE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3325));
				break;
			case EKT_PLEDGE_CASTLE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3326));
				break;
			case EKT_ACCOUNTSHARE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3328));
				break;
			case EKT_INDIVIDUAL_ACCOUNTSHARE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3329));
				break;
			case EKT_PLEDGE_ACCOUNTSHARE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3330));
				break;
			case EKT_INDIVIDUAL_PLEDGE_ACCOUNTSHARE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3331));
				break;
			case EKT_CASTLE_ACCOUNTSHARE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3332));
				break;
			case EKT_INDIVIDUAL_CASTLE_ACCOUNTSHARE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3333));
				break;
			case EKT_PLEDGE_CASTLE_ACCOUNTSHARE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3334));
				break;
			case EKT_ALL_ACCOUNTSHARE:
				enableItemDesc = (enableItemDesc $ GetSystemString(3335));
				break;
			default:
				break;
		}
	}
	return;
}

function bool addForbidItemDesc(ItemInfo Info)
{
	local string forbidItemDesc, enableItemDesc;
	local bool flag;

	if(Info.IsVirtualItem)
	{
		return false;
	}
	flag = false;
	GetItemDescriptionAdditionData(Info.Id, Info.Enchanted, forbidItemDesc, enableItemDesc);
	if(getInstanceUIData().GetIsClassicServer())
	{
		switch(Info.SlotBitType)
		{
			case INT64(536870912):
			case INT64(268435456):
			case INT64(1048576):
			case INT64(2097152):
				AddCrossLine();
				AddTooltipColorText(GetSystemString(14286), GetColor(158, 127, 87, 255), true, false);
				break;
			default:
				break;
		}
	}
	if(((forbidItemDesc != "") || (enableItemDesc != "")))
	{
		if(((m_Tooltip.DrawList[(m_Tooltip.DrawList.Length - 2)].u_strTexture == "L2UI_NewTex.Tooltip.TooltipLine_BasicShotBG") || (m_Tooltip.DrawList[(m_Tooltip.DrawList.Length - 2)].u_strTexture == "L2UI_NewTex.Tooltip.TooltipLine_Unable")))
		{
		}
		else
		{
			AddTooltipItemBlank(2);
			addTooltipTextureSplitLineType("L2UI_NewTex.Tooltip.TooltipLine_Unable", 1, 5, 8, 5, 0, 0);
		}
		if((enableItemDesc != ""))
		{
			AddTooltipColorText(enableItemDesc, GetColor(158, 127, 87, 255), true, false);
		}
		if((forbidItemDesc != ""))
		{
			AddTooltipItemBlank(2);
			AddTooltipColorText(forbidItemDesc, GetColor(152, 83, 45, 200), true, false);
		}
		flag = true;
	}
	return flag;
}

function CardEventImgTooltip(ItemInfo item, optional string Sender)
{
	StartItem();
	m_Tooltip.SimpleLineCount = 1;
	EndItem();
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.u_nTextureWidth = 242;
	m_Info.u_nTextureHeight = 344;
	m_Info.u_strTexture = item.tooltipTexutre;
	EndItem();
	if((Sender == "inventory"))
	{
		if(((item.Id.ClassID >= 38907) && (item.Id.ClassID <= 38922)))
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.t_bDrawOneLine = true;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 255;
			m_Info.t_color.G = 255;
			m_Info.t_color.B = 255;
			m_Info.t_color.A = 255;
			m_Info.t_strText = GetSystemString(3218);
			EndItem();
		}
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_GFXCARD(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local ItemInfo item;

	if((int(eSourceType) == 1))
	{
		ParamToItemInfo(param, item);
		AddTooltipItemName(item);
		CardEventImgTooltip(item);
	}
	return;
}

function ReturnTooltip_NTT_CHAT_USERFAKEINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	if((int(eSourceType) == 0))
	{
		if(!Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone())
		{
			ChatUserFakeInfoTooltip(param);
		}
	}
	return;
}

function ChatUserFakeInfoTooltip(string param)
{
	local string charName;
	local int isFriend, isGM, isPledge, isAlliance, isMentoring;

	ParseString(param, "CharName", charName);
	ParseInt(param, "IsFriend", isFriend);
	ParseInt(param, "IsPledge", isPledge);
	ParseInt(param, "IsMentoring", isMentoring);
	ParseInt(param, "IsAlliance", isAlliance);
	ParseInt(param, "IsGM", isGM);
	if((isFriend != 0))
	{
		AddTooltipItemColorOption(2273, GetSystemString(3175), 77, 255, 99, true, true, true);
	}
	else
	{
		AddTooltipItemColorOption(2273, GetSystemString(3176), 255, 66, 66, true, true, true);
	}
	if((isPledge != 0))
	{
		AddTooltipItemColorOption(314, GetSystemString(3179), 77, 255, 99, true, true, false);
	}
	else
	{
		AddTooltipItemColorOption(314, GetSystemString(3180), 255, 66, 66, true, true, false);
	}
	if(((isMentoring != 0) && !getInstanceUIData().GetIsClassicServer()))
	{
		AddTooltipItemColorOption(2767, GetSystemString(3177), 77, 255, 99, true, true, false);
	}
	else if(!getInstanceUIData().GetIsClassicServer())
	{
		AddTooltipItemColorOption(2767, GetSystemString(3178), 255, 66, 66, true, true, false);
	}
	if((isAlliance != 0))
	{
		AddTooltipItemColorOption(490, GetSystemString(3181), 77, 255, 99, true, true, false);
	}
	else
	{
		AddTooltipItemColorOption(490, GetSystemString(3182), 255, 66, 66, true, true, false);
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_MACRO(string param, UIEventManager.ETooltipSourceType eSourceType, optional bool bUseUserMacro)
{
	local ItemInfo item;
	local MacroInfo MacroInfo;
	local int idx;
	local array<string> commandArray;
	local bool bCustomMacro;

	if((int(eSourceType) == 1))
	{
		ParamToItemInfo(param, item);
		bCustomMacro = Class'NWindow.UIDATA_MACRO'.static.GetMacroInfo(item.Id, MacroInfo);
		if((MacroInfo.IconSkillId > 0))
		{
			item.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(GetItemID(MacroInfo.IconSkillId), 1, 0);
		}
		addItemIcon(item, "");
		m_Tooltip.MinimumWidth = 154;
		AddTooltipText(item.Name, false, true, true, "gameDefault10", 5, 1);
		if((Len(item.Description) > 0))
		{
			AddTooltipColorText(item.Description, GetColor(178, 190, 207, 255), true, false);
		}
		if(((item.MacroCommand != "") && !bUseUserMacro))
		{
			StringIntoArray(item.MacroCommand, Chr(13), commandArray);
			idx = 0;
			while((idx < commandArray.Length))
			{
				if((commandArray[idx] != ""))
				{
					AddTooltipColorText(commandArray[idx], GetColor(176, 155, 121, 255), true, true);
				}
				idx++;
			}
		}
		else if(bCustomMacro)
		{
			idx = 0;
			while((idx < MACROCOMMAND_MAX_COUNT))
			{
				if((trim(MacroInfo.CommandList[idx]) != ""))
				{
					AddTooltipColorText(makeShortStringByPixel(MacroInfo.CommandList[idx], 300, ".."), GetColor(176, 155, 121, 255), true, true);
				}
				idx++;
			}
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_ACTION(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local string TooltipType;

	if((int(eSourceType) == 1))
	{
		ParamToItemInfo(param, item);
		ParseString(param, "TooltipType", TooltipType);
		if(((Class'NWindow.ActionAPI'.static.GetActionAutomaticUseType(item.Id.ClassID) > 0) && (TooltipType != "TeleportAction")))
		{
			addItemIcon(item, "icon.icon_panel.autoaction_panel_01");
		}
		else
		{
			addItemIcon(item, "");
		}
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_strFontName = "gameDefault10";
		m_Info.nOffSetX = 5;
		m_Info.nOffSetY = 0;
		m_Info.t_color.R = 230;
		m_Info.t_color.G = 230;
		m_Info.t_color.B = 230;
		m_Info.t_color.A = 250;
		m_Info.t_strText = item.Name;
		EndItem();
		AddTooltipItemBlank(2);
		if((Len(item.Description) > 0))
		{
			m_Tooltip.MinimumWidth = 154;
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.t_bDrawOneLine = false;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = item.Description;
			EndItem();
		}
		if(((Class'NWindow.ActionAPI'.static.GetActionAutomaticUseType(item.Id.ClassID) > 0) && (TooltipType != "TeleportAction")))
		{
			AddTooltipItemBlank(1);
			addTexture("L2UI_ct1.AutoShotItemWnd.AutoAllArrow_On", 24, 24, 32, 32, -2, 0);
			AddTooltipColorText(GetSystemString(3962), getInstanceL2Util().Green, false, false, false, "", 2, 6);
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_SKILL(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local UIEventManager.EItemParamType EItemParamType;
	local int nTmp, SkillLevel, ConsumeItemCount, consumeClassID;
	local SkillInfo SkillInfo;
	local string tempStr;
	local int nSkillID, nSkillLevel, nSkillSubLevel;
	local bool bUseCross1;

	if(((int(eSourceType) == 1) || (int(eSourceType) == 2)))
	{
		if((int(eSourceType) == 2))
		{
			ParseInt(param, "nReserved1", nSkillID);
			ParseInt(param, "nReserved2", nSkillLevel);
			ParseInt(param, "nReserved3", nSkillSubLevel);
			GetSkillInfo(nSkillID, nSkillLevel, nSkillSubLevel, SkillInfo);
			item.Id.ClassID = SkillInfo.SkillID;
			item.Name = SkillInfo.SkillName;
			item.Description = SkillInfo.SkillDesc;
			item.Level = nSkillLevel;
			item.SubLevel = nSkillSubLevel;
		}
		else
		{
			ParseItemID(param, item.Id);
			ParseString(param, "Name", item.Name);
			ParseString(param, "AdditionalName", item.AdditionalName);
			ParseString(param, "Description", item.Description);
			ParseInt(param, "Level", item.Level);
			ParseInt(param, "SubLevel", item.SubLevel);
			GetSkillInfo(item.Id.ClassID, item.Level, item.SubLevel, SkillInfo);
		}
		if((item.Id.ClassID == 0))
		{
			return;
		}
		item.IconName = SkillInfo.TexName;
		item.IconPanel = SkillInfo.IconPanel;
		EItemParamType = EItemParamType(item.ItemType);
		SkillLevel = item.Level;
		if(getInstanceUIData().GetIsClassicServer())
		{
			m_Tooltip.MinimumWidth = 270;
		}
		else
		{
			m_Tooltip.MinimumWidth = 154;
		}
		switch(Class'NWindow.UIDATA_SKILL'.static.GetAutomaticUseSkillType(item.Id))
		{
			case AUST_BUFF_SKILL:
			case AUST_SEQUENTIAL_SKILL:
			case AUST_PRIORITY_BUFF_SKILL:
				addItemIcon(item, "Icon.autoskill_panel_01");
				break;
			default:
				addItemIcon(item, "");
		}
		if(IsUseRenewalSkillWnd())
		{
			if((item.SubLevel > 0))
			{
				AddTooltipColorText(("+" $ string(int((float(item.SubLevel) % 1000.0000000)))), GetColor(202, 117, 255, 255), false, true, false, "gameDefault10", 5);
				AddTooltipColorText((item.Name $ " "), getInstanceL2Util().BrightWhite, false, true, false, "gameDefault10", 3);
			}
			else
			{
				AddTooltipColorText((item.Name $ " "), getInstanceL2Util().BrightWhite, false, true, false, "gameDefault10", 5);
			}
		}
		else
		{
			AddTooltipColorText((item.Name $ " "), getInstanceL2Util().BrightWhite, false, true, false, "gameDefault10", 5);
		}
		if(getInstanceUIData().GetIsLiveServer())
		{
			if(!SkillInfo.LevelHide)
			{
				AddTooltipColorText(GetSystemString(88), GetColor(163, 163, 163, 255), false, true, false, "gameDefault10");
				AddTooltipColorText((" " $ string(SkillLevel)), GetColor(176, 155, 121, 255), false, true, false, "gameDefault10");
			}
		}
		else if(!SkillInfo.LevelHide)
		{
			AddTooltipColorText(GetSystemString(88), GetColor(238, 170, 34, 255), false, true, false, "gameDefault10");
			AddTooltipColorText((" " $ string(SkillLevel)), GetColor(238, 170, 34, 255), false, true, false, "gameDefault10");
		}
		if((Len(item.AdditionalName) > 0))
		{
			AddTooltipColorText(item.AdditionalName, GetColor(255, 217, 105, 255), false, true, false, "gameDefault10", 5);
		}
		AddTooltipItemBlank(1);
		AddTooltipColorText(getSkillTypeString(SkillInfo.IconType), GetColor(176, 155, 121, 255), true, true, false, "", 38, -17);
		if(getInstanceUIData().GetIsLiveServer())
		{
			nTmp = Class'NWindow.UIDATA_SKILL'.static.GetHpConsume(item.Id, item.Level, item.SubLevel);
			if((nTmp > 0))
			{
				AddTooltipItemOption(1195, string(nTmp), true, true, false);
			}
			nTmp = Class'NWindow.UIDATA_SKILL'.static.GetMpConsume(item.Id, item.Level, item.SubLevel);
			if((nTmp > 0))
			{
				AddTooltipItemOption(320, string(nTmp), true, true, false, "gameDefault11", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
			}
			nTmp = Class'NWindow.UIDATA_SKILL'.static.GetCastRange(item.Id, item.Level, item.SubLevel);
			if((nTmp >= 0))
			{
				AddTooltipItemOption(321, string(nTmp), true, true, false);
			}
			if(((SkillInfo.HitTime + SkillInfo.CoolTime) > 0.0000000))
			{
				AddTooltipItemOption(2377, getInstanceL2Util().MakeTimeString((SkillInfo.HitTime + SkillInfo.CoolTime)), true, true, false);
			}
			if((SkillInfo.ReuseDelay > 0.0000000))
			{
				AddTooltipItemOption(2378, getInstanceL2Util().MakeTimeString(SkillInfo.ReuseDelay), true, true, false);
			}
		}
		else
		{
			nTmp = Class'NWindow.UIDATA_SKILL'.static.GetLpConsume(item.Id, item.Level, item.SubLevel);
			if((nTmp > 0))
			{
				AddTooltipItemOption(14697, string(nTmp), true, true, false, "", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				bUseCross1 = true;
			}
			nTmp = Class'NWindow.UIDATA_SKILL'.static.GetHpConsume(item.Id, item.Level, item.SubLevel);
			if((nTmp > 0))
			{
				AddTooltipItemOption(1195, string(nTmp), true, true, false, "", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				bUseCross1 = true;
			}
			nTmp = Class'NWindow.UIDATA_SKILL'.static.GetMpConsume(item.Id, item.Level, item.SubLevel);
			if((nTmp > 0))
			{
				AddTooltipItemOption(320, string(nTmp), true, true, false, "", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				bUseCross1 = true;
			}
			if((SkillInfo.DpConsume > 0))
			{
				AddTooltipItemOption(13578, string(SkillInfo.DpConsume), true, true, false, "", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				bUseCross1 = true;
			}
			if((SkillInfo.EnergyConsume > 0))
			{
				AddTooltipItemOption(13579, MakeFullSystemMsg(GetSystemMessage(13396), string(SkillInfo.EnergyConsume)), true, true, false, "", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				bUseCross1 = true;
			}
			Class'NWindow.UIDATA_SKILL'.static.GetMSCondItem(SkillInfo.SkillID, SkillInfo.SkillLevel, SkillInfo.SkillSubLevel, consumeClassID, ConsumeItemCount);
			if((consumeClassID > 0))
			{
				AddTooltipItemOption(13580, MakeFullSystemMsg(GetSystemMessage(1983), ((Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(consumeClassID)) $ " ") $ string(ConsumeItemCount))), true, true, false, "", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
				bUseCross1 = true;
			}
			if(bUseCross1)
			{
				AddCrossLine();
			}
			bUseCross1 = false;
			nTmp = Class'NWindow.UIDATA_SKILL'.static.GetCastRange(item.Id, item.Level, item.SubLevel);
			if(((nTmp >= 0) && (nTmp < 1300)))
			{
				AddTooltipItemOption(321, string(nTmp), true, true, false);
				bUseCross1 = true;
			}
			if(((SkillInfo.HitTime + SkillInfo.CoolTime) > 0.0000000))
			{
				AddTooltipItemOption(2377, getInstanceL2Util().MakeTimeString((SkillInfo.HitTime + SkillInfo.CoolTime)), true, true, false);
				bUseCross1 = true;
			}
			if((SkillInfo.ReuseDelay > 0.0000000))
			{
				AddTooltipItemOption(2378, getInstanceL2Util().GetTimeStringBySec5(SkillInfo.ReuseDelay), true, true, false);
				bUseCross1 = true;
			}
			tempStr = getSkillTraitString(SkillInfo.TraitType);
			if((tempStr != ""))
			{
				bUseCross1 = true;
				if(getInstanceUIData().GetIsClassicServer())
				{
					AddTooltipItemOption(13636, tempStr, true, true, false);
				}
				else
				{
					AddTooltipItemOption(13637, tempStr, true, true, false);
				}
			}
			if((SkillInfo.AbnormalTime > 0))
			{
				bUseCross1 = true;
				AddTooltipItemOption(13582, getInstanceL2Util().GetTimeStringBySec5(float(SkillInfo.AbnormalTime)), true, true, false);
			}
			tempStr = getSkillTargetTypeString(SkillInfo.TargetType);
			if((tempStr != ""))
			{
				bUseCross1 = true;
				AddTooltipItemOption(13584, tempStr, true, true, false);
			}
			tempStr = getSkillAffectTypeString(SkillInfo.AffectScope);
			if((tempStr != ""))
			{
				bUseCross1 = true;
				AddTooltipItemOption(13585, tempStr, true, true, false);
			}
			tempStr = getSkillEquipNameStr(SkillInfo.SkillID, SkillInfo.SkillLevel, SkillInfo.SkillSubLevel);
			if((tempStr != ""))
			{
				bUseCross1 = true;
				AddTooltipColorText((GetSystemString(13586) $ " : "), GetColor(163, 163, 163, 255), true, true, false, "", 0, 4);
				AddTooltipColorText(tempStr, GetColor(176, 155, 121, 255), false, false, false, "", 0, 4);
			}
		}
		if((Len(item.Description) > 0))
		{
			if(bUseCross1)
			{
				AddCrossLine();
			}
			AddTooltipItemBlank(2);
			AddTooltipColorText(item.Description, GetColor(178, 190, 207, 255), true, false);
		}
		if((Len(item.AdditionalName) > 0))
		{
			AddCrossLine();
			AddTooltipItemBlank(2);
			AddTooltipColorText((GetSystemString(3350) $ " : "), GetColor(163, 163, 163, 255), true, false);
			AddTooltipColorText(item.AdditionalName, GetColor(255, 217, 105, 255), false, true);
			AddTooltipColorText(SkillInfo.EnchantDesc, GetColor(178, 190, 207, 255), true, false);
		}
		switch(Class'NWindow.UIDATA_SKILL'.static.GetAutomaticUseSkillType(item.Id))
		{
			case AUST_BUFF_SKILL:
			case AUST_SEQUENTIAL_SKILL:
			case AUST_PRIORITY_BUFF_SKILL:
				AddTooltipItemBlank(1);
				addTexture("L2UI_ct1.AutoShotItemWnd.AutoAllArrow_On", 24, 24, 32, 32, -2, 0);
				AddTooltipColorText(GetSystemString(3962), getInstanceL2Util().Green, false, false, false, "", 2, 6);
				break;
			default:
				break;
		}
		AddDeleteDBDataByInt64(SkillInfo.DBDeleteDate);
		if(((SkillInfo.DBDeleteDate > INT64(0)) && getInstanceUIData().GetIsLiveServer()))
		{
			m_Tooltip.MinimumWidth = 230;
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function AddDeleteDBDataByInt64(INT64 DBDeleteDate)
{
	local string dbDeleteDateStr;

	dbDeleteDateStr = Class'NWindow.UIDATA_ITEM'.static.GetDBDeleteDateString(DBDeleteDate);
	if((dbDeleteDateStr != ""))
	{
		AddTooltipItemBlank(2);
		addTooltipTextureSplitLineType("L2UI_NewTex.Tooltip.TooltipLine_Unable", 1, 5, 8, 5, 0, 0);
		AddTooltipItemBlank(2);
		AddTooltipColorText((("<" $ GetSystemString(13406)) $ ">"), getInstanceL2Util().Red, true, false, false, "", 0, 0);
		addTooltipTexture("L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 16, 16, 0, 0, true, true, 0, 1);
		AddTooltipColorText(dbDeleteDateStr, getInstanceL2Util().White, false, true, false, "", 0, 0);
		AddTooltipColorText(" (", getInstanceL2Util().PowderPink, false, true, false, "", 0, 0);
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.bLineBreak = false;
		m_Info.t_bDrawOneLine = true;
		m_Info.nOffSetY = 0;
		m_Info.t_color = getInstanceL2Util().PowderPink;
		m_Info.t_strText = dbDeleteDateStr;
		ParamAdd(m_Info.Condition, "Type", "DBDeleteRemainTime");
		ParamAdd(m_Info.Condition, "Value", string(DBDeleteDate));
		EndItem();
		AddTooltipColorText(")", getInstanceL2Util().PowderPink, false, true, false, "", 0, 0);
	}
	return;
}

function ReturnTooltip_NTT_ABNORMALSTATUS(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local int ShowLevel;
	local UIEventManager.EItemParamType EItemParamType;
	local SkillInfo SkillInfo;
	local bool IsToppingSkill;
	local array<TextSectionInfo> TextInfos;
	local string FullText, strDesc;

	if((int(eSourceType) == 1))
	{
		ParseItemID(param, item.Id);
		ParseString(param, "Name", item.Name);
		ParseString(param, "AdditionalName", item.AdditionalName);
		ParseString(param, "Description", item.Description);
		ParseInt(param, "Level", item.Level);
		ParseInt(param, "SubLevel", item.SubLevel);
		ParseInt(param, "Reserved", item.Reserved);
		IsToppingSkill = Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(item.Id, item.Level, item.SubLevel);
		GetSkillInfo(item.Id.ClassID, item.Level, item.SubLevel, SkillInfo);
		EItemParamType = EItemParamType(item.ItemType);
		if(getInstanceUIData().GetIsLiveServer())
		{
			m_Tooltip.MinimumWidth = 154;
		}
		else
		{
			m_Tooltip.MinimumWidth = 270;
		}
		item.IconName = SkillInfo.TexName;
		item.IconPanel = SkillInfo.IconPanel;
		EItemParamType = EItemParamType(item.ItemType);
		addItemIcon(item, "");
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.nOffSetX = 5;
		m_Info.t_strText = item.Name;
		m_Info.t_strFontName = "gameDefault10";
		EndItem();
		ShowLevel = item.Level;
		if(getInstanceUIData().GetIsLiveServer())
		{
			if(!IsToppingSkill)
			{
				if(!SkillInfo.LevelHide)
				{
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = " ";
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_color.R = 163;
					m_Info.t_color.G = 163;
					m_Info.t_color.B = 163;
					m_Info.t_color.A = 255;
					m_Info.t_ID = 88;
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_color.R = 176;
					m_Info.t_color.G = 155;
					m_Info.t_color.B = 121;
					m_Info.t_color.A = 255;
					m_Info.t_strText = (" " $ string(ShowLevel));
					EndItem();
				}
			}
		}
		else if(!IsToppingSkill)
		{
			if(!SkillInfo.LevelHide)
			{
				AddTooltipColorText((((" " $ GetSystemString(88)) $ " ") $ string(ShowLevel)), GetColor(238, 170, 34, 255), false, true);
			}
		}
		if((Len(item.AdditionalName) > 0))
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetX = 5;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 255;
			m_Info.t_color.G = 217;
			m_Info.t_color.B = 105;
			m_Info.t_color.A = 255;
			m_Info.t_strText = item.AdditionalName;
			EndItem();
		}
		if((item.Reserved >= 0))
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 37;
			m_Info.nOffSetY = -15;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_ID = 1199;
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetY = -15;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_strText = " : ";
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetY = -15;
			m_Info.t_color.R = 255;
			m_Info.t_color.G = 221;
			m_Info.t_color.B = 102;
			m_Info.t_color.A = 255;
			if(IsToppingSkill)
			{
				m_Info.t_strText = MakeToppingBuffTimeStr(item.Reserved);
				ParamAdd(m_Info.Condition, "Type", "ToppingRemainTime");
			}
			else
			{
				m_Info.t_strText = MakeBuffTimeStr(item.Reserved);
				ParamAdd(m_Info.Condition, "Type", "RemainTime");
			}
			EndItem();
		}
		if((Len(item.Description) > 0))
		{
			GetItemTextSectionInfos(item.Description, FullText, TextInfos);
			StartItem();
			if((TextInfos.Length > 0))
			{
				strDesc = FullText;
				m_Info.t_SectionList = TextInfos;
			}
			else
			{
				strDesc = item.Description;
			}
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = strDesc;
			EndItem();
		}
		if((Len(item.AdditionalName) > 0))
		{
			AddCrossLine();
			AddTooltipColorText((GetSystemString(3350) $ " : "), GetColor(163, 163, 163, 255), true, false);
			AddTooltipColorText(item.AdditionalName, GetColor(255, 217, 105, 255), false, true);
			AddTooltipColorText(SkillInfo.EnchantDesc, GetColor(178, 190, 207, 255), true, false);
		}
		AddDeleteDBDataByInt64(SkillInfo.DBDeleteDate);
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_LOOCKCHANGEITEM(string param)
{
	local string Name;

	ParseString(param, "Name", Name);
	StartItem();
	m_Info.eType = DIT_TEXT;
	m_Info.t_strText = Name;
	EndItem();
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_NORMALITEM(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local array<TextSectionInfo> TextInfos;
	local string FullText, strDesc;

	if((int(eSourceType) == 1))
	{
		ParseString(param, "Name", item.Name);
		ParseString(param, "Description", item.Description);
		ParseString(param, "AdditionalName", item.AdditionalName);
		ParseInt(param, "CrystalType", item.CrystalType);
		AddTooltipItemName(item);
		AddTooltipItemGrade(item);
		if((Len(item.Description) > 0))
		{
			m_Tooltip.MinimumWidth = 154;
			GetItemTextSectionInfos(item.Description, FullText, TextInfos);
			StartItem();
			if((TextInfos.Length > 0))
			{
				strDesc = FullText;
				m_Info.t_SectionList = TextInfos;
			}
			else
			{
				strDesc = item.Description;
			}
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = strDesc;
			EndItem();
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_PREMIUMNORMALITEM(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local ItemInfo item;

	if((int(eSourceType) == 1))
	{
		ParseString(param, "Name", item.Name);
		ParseString(param, "Description", item.Description);
		ParseString(param, "AdditionalName", item.AdditionalName);
		ParseInt(param, "CrystalType", item.CrystalType);
		ParseInt(param, "CurrentPeriod", item.CurrentPeriod);
		AddTooltipItemName(item);
		AddTooltipItemGrade(item);
		if((Len(item.Description) > 0))
		{
			m_Tooltip.MinimumWidth = 154;
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = item.Description;
			EndItem();
		}
		if((item.CurrentPeriod > 0))
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_ID = 1199;
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_strText = " : ";
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = ("" $ MakeTimeStr(item.CurrentPeriod));
			ParamAdd(m_Info.Condition, "Type", "PeriodTime");
			EndItem();
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_RECIPE(string param, UIEventManager.ETooltipSourceType eSourceType, bool bShowPrice)
{
	local ItemInfo item;
	local string strAdena, strAdenaComma;
	local Color AdenaColor;

	if((int(eSourceType) == 1))
	{
		ParseString(param, "Name", item.Name);
		ParseString(param, "Description", item.Description);
		ParseString(param, "AdditionalName", item.AdditionalName);
		ParseInt(param, "CrystalType", item.CrystalType);
		ParseInt(param, "Weight", item.Weight);
		ParseINT64(param, "Price", item.Price);
		AddTooltipItemName(item);
		AddTooltipItemGrade(item);
		if(bShowPrice)
		{
			strAdena = string(item.Price);
			strAdenaComma = MakeCostString(strAdena);
			AdenaColor = GetNumericColor(strAdenaComma);
			AddTooltipItemOption(641, (strAdenaComma $ " "), true, true, false);
			SetTooltipItemColor(int(AdenaColor.R), int(AdenaColor.G), int(AdenaColor.B), 0);
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color = AdenaColor;
			m_Info.t_ID = 469;
			EndItem();
			if((strAdena != ""))
			{
				AddTooltipItemOption(0, (("(" $ ConvertNumToText(strAdena)) $ ")"), false, true, false);
				SetTooltipItemColor(int(AdenaColor.R), int(AdenaColor.G), int(AdenaColor.B), 0);
			}
		}
		AddTooltipItemOption(52, string(item.Weight), true, true, false);
		if((Len(item.Description) > 0))
		{
			m_Tooltip.MinimumWidth = 154;
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = item.Description;
			EndItem();
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_SHORTCUT(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local UIEventManager.EItemParamType EItemParamType;
	local UIEventManager.EShortCutItemType eShortCutType;
	local string ItemName;
	local ShortcutCommandItem commandItem;
	local int ShortcutID;
	local string strShort;
	local OptionWnd Script;
	local int nIsBlessed;

	Script = OptionWnd(GetScript("OptionWnd"));
	strShort = (("<" $ GetSystemString(1523)) $ ": ");
	if((int(eSourceType) == 1))
	{
		ParseInt(param, "IsBlessedItem", nIsBlessed);
		item.IsBlessedItem = numToBool(nIsBlessed);
		if(BoolSelect)
		{
			ParseInt(param, "ShortcutType", item.ShortcutType);
			ParseString(param, "Name", item.Name);
			ParseInt(param, "RefineryOp1", item.RefineryOp1);
			ParseInt(param, "RefineryOp2", item.RefineryOp2);
			ParseInt(param, "RefineryOp3", item.RefineryOp3);
			eShortCutType = EShortCutItemType(item.ShortcutType);
			ItemName = item.Name;
			switch(eShortCutType)
			{
				case SCIT_ITEM:
				case SCIT_DELETED_ITEM:
					ReturnTooltip_NTT_ITEM(param, "inventory", eSourceType);
					break;
				case SCIT_SKILL:
				case SCIT_ATTRIBUTE:
					ReturnTooltip_NTT_SKILL(param, eSourceType);
					break;
				case SCIT_ACTION:
					ReturnTooltip_NTT_ACTION(param, eSourceType);
					break;
				case SCIT_MACRO:
					ReturnTooltip_NTT_MACRO(param, eSourceType, true);
					break;
				case SCIT_RECIPE:
				case SCIT_BOOKMARK:
					m_Tooltip.MinimumWidth = 154;
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = ItemName;
					EndItem();
					break;
				default:
					break;
			}
			ParseInt(param, "ShortcutID", ShortcutID);
			if(getInstanceUIData().getIsArenaServer())
			{
				Class'NWindow.ShortcutAPI'.static.GetAssignedKeyFromCommand("ArenaGamingEnterChattingShortcut", ("UseShortcutItem Num=" $ string(ShortcutID)), commandItem);
			}
			else if(GetChatFilterBool("Global", "EnterChatting"))
			{
				Class'NWindow.ShortcutAPI'.static.GetAssignedKeyFromCommand("TempStateShortcut", ("UseShortcutItem Num=" $ string(ShortcutID)), commandItem);
			}
			else
			{
				Class'NWindow.ShortcutAPI'.static.GetAssignedKeyFromCommand("GamingStateShortcut", ("UseShortcutItem Num=" $ string(ShortcutID)), commandItem);
			}
			if((commandItem.subkey1 != ""))
			{
				strShort = ((strShort $ Script.GetUserReadableKeyName(commandItem.subkey1)) $ "+");
			}
			if((commandItem.subkey2 != ""))
			{
				strShort = ((strShort $ Script.GetUserReadableKeyName(commandItem.subkey2)) $ "+");
			}
			if((commandItem.Key != ""))
			{
				strShort = ((strShort $ Script.GetUserReadableKeyName(commandItem.Key)) $ ">");
			}
			if((((commandItem.subkey1 == "") && (commandItem.subkey2 == "")) && (commandItem.Key == "")))
			{
				strShort = ((strShort $ GetSystemString(27)) $ ">");
			}
			AddTooltipItemBlank(6);
			StartItem();
			m_Info.eType = DIT_SPLITLINE;
			m_Info.u_nTextureWidth = 154;
			m_Info.u_nTextureHeight = 1;
			m_Info.u_strTexture = "L2ui_ch3.tooltip_line";
			EndItem();
			if((ItemName != ""))
			{
				AddTooltipItemBlank(5);
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.t_color.R = 230;
				m_Info.t_color.G = 230;
				m_Info.t_color.B = 230;
				m_Info.t_color.A = 255;
				m_Info.t_strText = strShort;
				EndItem();
				AddTooltipItemBlank(1);
				ReturnTooltipInfo(m_Tooltip);
			}
			return;
		}
		else
		{
			ParseItemID(param, item.Id);
			ParseString(param, "Name", item.Name);
			ParseString(param, "AdditionalName", item.AdditionalName);
			ParseInt(param, "Level", item.Level);
			ParseInt(param, "SubLevel", item.SubLevel);
			ParseInt(param, "Reserved", item.Reserved);
			ParseInt(param, "Enchanted", item.Enchanted);
			ParseInt(param, "ItemType", item.ItemType);
			ParseInt(param, "ShortcutType", item.ShortcutType);
			ParseInt(param, "CrystalType", item.CrystalType);
			ParseInt(param, "ConsumeType", item.ConsumeType);
			ParseInt(param, "RefineryOp1", item.RefineryOp1);
			ParseInt(param, "RefineryOp2", item.RefineryOp2);
			ParseInt(param, "RefineryOp3", item.RefineryOp3);
			ParseINT64(param, "ItemNum", item.ItemNum);
			ParseInt(param, "MpConsume", item.MpConsume);
			ParseInt(param, "IsBRPremium", item.IsBRPremium);
			eShortCutType = EShortCutItemType(item.ShortcutType);
			EItemParamType = EItemParamType(item.ItemType);
			ItemName = item.Name;
			switch(eShortCutType)
			{
				case SCIT_ITEM:
				case SCIT_DELETED_ITEM:
					AddPrimeItemSymbol(item);
					AddTooltipItemEnchant(item);
					AddTooltipItemName(item);
					AddTooltipItemGrade(item);
					AddTooltipItemCount(item);
					break;
				case SCIT_SKILL:
				case SCIT_ATTRIBUTE:
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = ItemName;
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = " ";
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_color.R = 163;
					m_Info.t_color.G = 163;
					m_Info.t_color.B = 163;
					m_Info.t_color.A = 255;
					m_Info.t_ID = 88;
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_color.R = 176;
					m_Info.t_color.G = 155;
					m_Info.t_color.B = 121;
					m_Info.t_color.A = 255;
					m_Info.t_strText = (" " $ string(item.Level));
					EndItem();
					if((Len(item.AdditionalName) > 0))
					{
						StartItem();
						m_Info.eType = DIT_TEXT;
						m_Info.nOffSetX = 5;
						m_Info.t_bDrawOneLine = true;
						m_Info.t_color.R = 255;
						m_Info.t_color.G = 217;
						m_Info.t_color.B = 105;
						m_Info.t_color.A = 255;
						m_Info.t_strText = item.AdditionalName;
						EndItem();
					}
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.nOffSetX = -4;
					m_Info.bLineBreak = true;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = " (";
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_ID = 91;
					EndItem();
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = ((":" $ string(item.MpConsume)) $ ")");
					EndItem();
					break;
				case SCIT_ACTION:
				case SCIT_MACRO:
				case SCIT_RECIPE:
				case SCIT_BOOKMARK:
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = ItemName;
					EndItem();
					break;
				default:
					break;
			}
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_RECIPE_MANUFACTURE(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local ItemInfo item;
	local array<TextSectionInfo> TextInfos;
	local string FullText, strDesc;

	if((int(eSourceType) == 1))
	{
		ParseString(param, "Name", item.Name);
		ParseString(param, "Description", item.Description);
		ParseString(param, "AdditionalName", item.AdditionalName);
		ParseINT64(param, "Reserved64", item.Reserved64);
		ParseInt(param, "CrystalType", item.CrystalType);
		ParseINT64(param, "ItemNum", item.ItemNum);
		m_Tooltip.MinimumWidth = 154;
		AddTooltipItemName(item);
		AddTooltipItemGrade(item);
		AddTooltipItemOption(736, string(item.Reserved64), true, true, false);
		AddTooltipItemOption(737, string(item.ItemNum), true, true, false);
		if((Len(item.Description) > 0))
		{
			GetItemTextSectionInfos(item.Description, FullText, TextInfos);
			StartItem();
			if((TextInfos.Length > 0))
			{
				strDesc = FullText;
				m_Info.t_SectionList = TextInfos;
			}
			else
			{
				strDesc = item.Description;
			}
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.bLineBreak = true;
			m_Info.t_color.R = 178;
			m_Info.t_color.G = 190;
			m_Info.t_color.B = 207;
			m_Info.t_color.A = 255;
			m_Info.t_strText = strDesc;
			EndItem();
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_FRIENDINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[2].szData)), true, true, true);
		if((Record.szReserved != ""))
		{
			AddTooltipItemOption(403, Record.szReserved, true, true, true);
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_CLANINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[2].szData)), true, true, true);
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_AgitDecoList(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int nUse, totalCnt, i, nItemID, Period;
	local string toolTipParam, Desc;
	local INT64 nItemCount;

	if((int(eSourceType) == 2))
	{
		m_Tooltip.MinimumWidth = (154 + 30);
		ParamToRecord(param, Record);
		if((Record.LVDataList[0].szData == GetSystemString(869)))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(3440), getInstanceL2Util().White, "", false));
			ReturnTooltipInfo(m_Tooltip);
			return;
		}
		toolTipParam = param;
		ParseInt(toolTipParam, "totalCnt", totalCnt);
		ParseInt(toolTipParam, "period", Period);
		ParseString(toolTipParam, "desc", Desc);
		nUse = Record.LVDataList[0].nReserved2;
		if((nUse > 0))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().BrightWhite, "", false, true));
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().White, "", false, true));
		}
		AddCrossLine();
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(3430), getInstanceL2Util().Yellow, "", true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(Desc, getInstanceL2Util().ColorDesc, "", true));
		AddTooltipItemBlank(10);
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(3442), getInstanceL2Util().ColorYellow, "", true, true));
		i = 0;
		while((i < totalCnt))
		{
			ParseInt(toolTipParam, ("item_" $ string(i)), nItemID);
			ParseINT64(toolTipParam, ("count_" $ string(i)), nItemCount);
			addToolTipDrawList(m_Tooltip, addDrawItemBlank(5));
			addToolTipDrawList(m_Tooltip, addDrawItemText(Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(nItemID)), getInstanceL2Util().White, "", true, true));
			addToolTipDrawList(m_Tooltip, addDrawItemText(("x" @ MakeCostString(string(nItemCount))), getInstanceL2Util().White, "", true, true));
			i++;
		}
		if((totalCnt <= 0))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(27), getInstanceL2Util().White, "", true, true));
		}
		addToolTipDrawList(m_Tooltip, addDrawItemBlank(10));
		addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(3431), getInstanceL2Util().ColorYellow, "", true));
		addToolTipDrawList(m_Tooltip, addDrawItemText(MakeFullSystemMsg(GetSystemMessage(3418), string(Period)), getInstanceL2Util().White, "", true));
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_EnsoulOptionList(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local UIConstants.EnsoulOptionUIInfo optionInfo;
	local LVDataRecord Record;
	local int OptionID;

	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		OptionID = Record.LVDataList[0].nReserved2;
		if((OptionID > 0))
		{
			GetEnsoulOptionUIInfo(OptionID, optionInfo);
			addToolTipDrawList(m_Tooltip, addDrawItemTexture(optionInfo.IconPanelTex, false, false, 2));
			addToolTipDrawList(m_Tooltip, addDrawItemTexture(optionInfo.Icontex, false, false, -16));
			addToolTipDrawList(m_Tooltip, addDrawItemText("", getInstanceL2Util().White, "", false, , 4, 2));
			if((optionInfo.OptionStep > 0))
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(MakeFullSystemMsg(GetSystemMessage(4347), optionInfo.Name, string(optionInfo.OptionStep)), getInstanceL2Util().White, "", false));
			}
			else
			{
				addToolTipDrawList(m_Tooltip, addDrawItemText(optionInfo.Name, getInstanceL2Util().White, "", false));
			}
			addToolTipDrawList(m_Tooltip, addDrawItemText(" : ", getInstanceL2Util().White, "", false));
			addToolTipDrawList(m_Tooltip, addDrawItemText(optionInfo.Desc, getInstanceL2Util().ColorDesc, "", false));
			addToolTipDrawList(m_Tooltip, addDrawItemBlank(1));
		}
		else
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().White, "", false, , 4, 2));
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_SellItemList(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	if((int(eSourceType) == 2))
	{
		ReturnTooltip_NTT_ITEM(param, "SellItemList", NTST_ITEM);
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_UIControlNeedItemList(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local string TooltipDesc;

	if((int(eSourceType) == 2))
	{
	}
	else if((int(eSourceType) == 3))
	{
		ParseString(param, "TooltipDesc", TooltipDesc);
		if((TooltipDesc != ""))
		{
			m_Tooltip.MinimumWidth = 10;
			addToolTipDrawList(m_Tooltip, addDrawItemText(TooltipDesc, getInstanceL2Util().White, "", true, true));
		}
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_CLANWARList(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local L2UITime UITimeStruct;
	local PledgeEnemyDeletePenaltyUIData uData;

	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		m_Tooltip.MinimumWidth = 200;
		uData = API_GetPledgeEnemyDeletePenaltyData();
		if((uData.CostLCoin <= 0))
		{
			return;
		}
		if((int(Record.nReserved2) <= Class'Interface.UIData'.static.Inst().GetCurrentRealLocalTimeSec()))
		{
			return;
		}
		GetTimeStruct(int(Record.nReserved2), UITimeStruct);
		addToolTipDrawList(m_Tooltip, addDrawItemText(MakeFullSystemMsg(GetSystemMessage(13869), Class'Interface.UIData'.static.Inst().getMakeTimeString(UITimeStruct)), getInstanceL2Util().White));
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_CLANWARINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int Width1, Width2, Height, toolTipLineCount;

	toolTipLineCount = 0;
	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		GetTextSizeDefault(getWarSituationString(Record.LVDataList[2].nReserved1), Width1, Height);
		GetTextSizeDefault((GetSystemString(2968) $ string(Record.LVDataList[4].nReserved1)), Width2, Height);
		if((Width2 > Width1))
		{
			Width1 = Width2;
		}
		if((154 > Width1))
		{
			Width1 = 154;
		}
		m_Tooltip.MinimumWidth = Width1;
		if((Record.LVDataList[5].nReserved1 > 0))
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.bLineBreak = true;
			m_Info.t_strText = ((GetSystemString(1108) $ ":") $ getSecToDateStr(Record.LVDataList[6].nReserved1, false));
			EndItem();
			toolTipLineCount++;
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.bLineBreak = true;
			m_Info.t_strText = (((GetSystemString(2986) $ ":") $ string(Record.LVDataList[5].nReserved1)) $ GetSystemString(1013));
			EndItem();
			toolTipLineCount++;
		}
		else
		{
			if((Record.LVDataList[2].nReserved1 < 5))
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.bLineBreak = true;
				m_Info.t_color.R = 220;
				m_Info.t_color.G = 220;
				m_Info.t_color.B = 220;
				m_Info.t_color.A = 255;
				m_Info.t_strText = getWarSituationString(Record.LVDataList[2].nReserved1);
				EndItem();
				toolTipLineCount++;
			}
			if((Record.LVDataList[3].nReserved1 > -500))
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.bLineBreak = true;
				m_Info.t_color.R = 175;
				m_Info.t_color.G = 152;
				m_Info.t_color.B = 120;
				m_Info.t_color.A = 255;
				m_Info.t_strText = (GetSystemString(2968) $ string(Record.LVDataList[4].nReserved1));
				EndItem();
				toolTipLineCount++;
			}
		}
		if((toolTipLineCount == 0))
		{
			return;
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_EllipsedList(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local string TooltipDesc;
	local int textW, textH;

	if((int(eSourceType) == 3))
	{
		if(ParseString(param, "TooltipDesc", TooltipDesc))
		{
			GetTextSizeDefault(TooltipDesc, textW, textH);
			m_Tooltip.MinimumWidth = textW;
			addToolTipDrawList(m_Tooltip, addDrawItemText(TooltipDesc, getInstanceL2Util().White));
			ReturnTooltipInfo(m_Tooltip);
		}
	}
	return;
	return;
}

function ReturnTooltip_NTT_EllipsedQuest(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local string TooltipDesc;
	local int textW, textH;
	local LVDataRecord Record;
	local array<string> strings;
	local int i;

	if((int(eSourceType) == 3))
	{
		ParseString(param, "TooltipDesc", TooltipDesc);
		if(ParseString(param, "TooltipDesc", TooltipDesc))
		{
			GetTextSizeDefault(TooltipDesc, textW, textH);
			m_Tooltip.MinimumWidth = textW;
			addToolTipDrawList(m_Tooltip, addDrawItemText(TooltipDesc, getInstanceL2Util().White));
			ReturnTooltipInfo(m_Tooltip);
		}
	}
	else if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		if((Record.szReserved == ""))
		{
			return;
		}
		m_Tooltip.MinimumWidth = 261;
		SplitByKeyStrings("<br>", Record.szReserved, strings);
		i = 0;
		while((i < strings.Length))
		{
			addToolTipDrawList(m_Tooltip, addDrawItemText(strings[i], getInstanceL2Util().White));
			if((i != (strings.Length - 1)))
			{
				AddTooltipItemBlank(10);
			}
			i++;
		}
		ReturnTooltipInfo(m_Tooltip);
	}
	return;
}

function SplitByKeyStrings(string keyString, string wordString, out array<string> strings)
{
	local int startIndex;

	startIndex = InStr(wordString, keyString);
	if((startIndex == -1))
	{
		if((wordString != ""))
		{
			strings[strings.Length] = wordString;
		}
		return;
	}
	strings[strings.Length] = Left(wordString, startIndex);
	SplitByKeyStrings(keyString, Right(wordString, ((Len(wordString) - startIndex) - Len(keyString))), strings);
	return;
}

function ReturnTooltip_NTT_POSTINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[1].szData)), true, true, true);
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_ROOMLIST(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local int i;
	local LVDataRecord Record;
	local int Len;

	m_Tooltip.MinimumWidth = (154 + 30);
	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		Len = int(Record.LVDataList[5].szData);
		i = 0;
		while((i < Len))
		{
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.u_nTextureWidth = 11;
			m_Info.u_nTextureHeight = 11;
			m_Info.u_strTexture = GetClassRoleIconName(Record.LVDataList[(7 + i)].nReserved1);
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.t_bDrawOneLine = false;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_strText = (" " $ Record.LVDataList[(7 + i)].szData);
			EndItem();
			if((i != (Len - 1)))
			{
				AddTooltipItemBlank(2);
			}
			i++;
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_DevToolDebug(string param)
{
	local LVDataRecord Record;
	local Color applyColor;
	local int tWidth, tHeight;

	return;
	ParamToRecord(param, Record);
	if((Record.LVDataList[1].szData == ""))
	{
		return;
	}
	if((Len(Record.szReserved) > 0))
	{
		applyColor = GetColor(212, 111, 111, 255);
		AddTooltipColorText(Record.szReserved, applyColor, true, false, true);
	}
	applyColor = GetColor(222, 222, 111, 255);
	AddTooltipColorText(Record.LVDataList[1].szReserved, applyColor, true, false, true);
	GetTextSizeDefault(Record.LVDataList[1].szReserved, tWidth, tHeight);
	if((800 < tWidth))
	{
		m_Tooltip.MinimumWidth = 800;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_PrivateShopHistory(string param)
{
	local LVDataRecord Record;

	ParamToRecord(param, Record);
	if((Record.szReserved == ""))
	{
		return;
	}
	StartItem();
	m_Info.eType = DIT_TEXT;
	m_Info.t_color.R = byte(int(Record.nReserved1));
	m_Info.t_color.G = byte(int(Record.nReserved2));
	m_Info.t_color.B = byte(int(Record.nReserved3));
	m_Info.t_color.A = 255;
	m_Info.t_strText = Record.szReserved;
	EndItem();
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_USERLIST(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = (154 + 70);
	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[1].szData)), true, true, true);
		AddTooltipItemBlank(0);
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_strText = (GetSystemString(2276) $ " : ");
		EndItem();
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		if((Record.LVDataList[4].szData == ""))
		{
			m_Info.t_strText = GetSystemString(27);
		}
		else
		{
			m_Info.t_strText = Record.LVDataList[4].szData;
		}
		EndItem();
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_PARTYMATCH(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	m_Tooltip.MinimumWidth = (154 + 70);
	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[1].szData)), true, true, true);
		AddTooltipItemBlank(0);
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_strText = (GetSystemString(2276) $ " : ");
		EndItem();
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		if((Record.LVDataList[3].szData == ""))
		{
			m_Info.t_strText = GetSystemString(27);
		}
		else
		{
			m_Info.t_strText = Record.LVDataList[3].szData;
		}
		EndItem();
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_UNIONLIST(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[1].szData)), true, true, true);
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_QUESTLIST(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local NQuestUIData o_data;
	local bool isComplete;
	local Color TextColor;
	local int nType, nTmp;

	ParamToRecord(param, Record);
	if((int(eSourceType) == 2))
	{
		API_GetNQuestData(int(Record.nReserved1), o_data);
		isComplete = (o_data.Goal.Num <= int(Record.nReserved2));
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom(Class'Interface.QuestWnd'.static.Inst()._GetIconTextureByState(int(Record.nReserved3), isComplete), false, false, 0, 0, 24, 24, 24, 24));
		switch(int(Record.nReserved3))
		{
			case -1:
				TextColor = getInstanceL2Util().White;
				AddTooltipColorText(GetSystemString(14405), TextColor, false, true, true, "gameDefault10", 0, 5);
				break;
			case 1:
				if(isComplete)
				{
					TextColor = GetColor(255, 221, 102, 255);
					AddTooltipColorText(GetSystemString(14845), TextColor, false, true, true, "gameDefault10", 0, 5);
				}
				else
				{
					TextColor = GetColor(170, 153, 119, 255);
					AddTooltipColorText(GetSystemString(324), TextColor, false, true, true, "gameDefault10", 0, 5);
				}
				break;
			case 2:
				TextColor = GetColor(170, 153, 119, 100);
				AddTooltipColorText(GetSystemString(14846), TextColor, false, true, true, "gameDefault10", 0, 5);
				break;
			default:
				break;
		}
		AddCrossLine();
		if((int(Record.nReserved3) == -1))
		{
			if((IsAdenServer() || getInstanceUIData().GetIsLiveServer()))
			{
				ReturnTooltip_NTT_QUESTRECOMMAND_MAPLIST_NEW(param, eSourceType);
			}
			else
			{
				ReturnTooltip_NTT_QUESTRECOMMAND_MAPLIST(param, eSourceType);
			}
			return;
		}
		AddTooltipItemOption(1200, Record.LVDataList[0].szData, true, true, true);
		if((IsAdenServer() || getInstanceUIData().GetIsLiveServer()))
		{
			nType = int(o_data.Type);
			switch(nType)
			{
				case 1:
					nTmp = 862;
					break;
				case 2:
					nTmp = 2788;
					break;
				case 3:
					nTmp = 14389;
					break;
				case 4:
					nTmp = 861;
					break;
				default:
					break;
			}
		}
		else
		{
			switch(Record.LVDataList[3].nReserved1)
			{
				case 0:
				case 2:
					nTmp = 861;
					break;
				case 1:
				case 3:
					nTmp = 862;
					break;
				default:
					break;
			}
		}
		AddTooltipItemOption2(1202, nTmp, true, true, false);
	}
	else if((int(Record.nReserved3) == -1))
	{
		AddTooltipSimpleText(GetSystemString(14179));
	}
	else
	{
		AddTooltipSimpleText(GetSystemString(1253));
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_RAIDLIST(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;

	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		if((Len(Record.szReserved) < 1))
		{
			return;
		}
		m_Tooltip.MinimumWidth = 154;
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = false;
		m_Info.t_color.R = 178;
		m_Info.t_color.G = 190;
		m_Info.t_color.B = 207;
		m_Info.t_color.A = 255;
		m_Info.t_strText = Record.szReserved;
		EndItem();
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_QUESTINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int nTmp, Width1, Width2, Height;

	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		AddTooltipItemOption(1200, Record.LVDataList[0].szData, true, true, true);
		AddTooltipItemOption(1201, Record.LVDataList[1].szData, true, true, false);
		GetTextSizeDefault(((GetSystemString(1200) $ " : ") $ Record.LVDataList[0].szData), Width1, Height);
		GetTextSizeDefault(((GetSystemString(1201) $ " : ") $ Record.LVDataList[1].szData), Width2, Height);
		if((Width2 > Width1))
		{
			Width1 = Width2;
		}
		if((154 > Width1))
		{
			Width1 = 154;
		}
		m_Tooltip.MinimumWidth = (Width1 + 30);
		AddTooltipItemOption(922, Record.LVDataList[2].szData, true, true, false);
		switch(Record.LVDataList[3].nReserved1)
		{
			case 0:
			case 2:
				nTmp = 861;
				break;
			case 1:
			case 3:
				nTmp = 862;
				break;
			default:
				break;
		}
		AddTooltipItemOption2(1202, nTmp, true, true, false);
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.nOffSetY = 2;
		m_Info.t_bDrawOneLine = false;
		m_Info.bLineBreak = true;
		m_Info.t_color.R = 178;
		m_Info.t_color.G = 190;
		m_Info.t_color.B = 207;
		m_Info.t_color.A = 255;
		m_Info.t_strText = Record.szReserved;
		EndItem();
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_QUESTRECOMMAND_MAPLIST(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local array<int> RewardIDList;
	local array<INT64> rewardNumList;
	local int NpcID, QuestID;
	local string requirementStr, NpcName, itemText;
	local ItemInfo tmpInfo;
	local int i, nWidth, nHeight;
	local string levelText, QuestTypeText, questName;

	if((int(eSourceType) == 2))
	{
		m_Tooltip.MinimumWidth = 330;
		AddTooltipColorText(GetSystemString(14405), getInstanceL2Util().BrightWhite, true, true, true, "gameDefault10");
		AddCrossLine();
		ParamToRecord(param, Record);
		QuestID = int(Record.nReserved1);
		ParseString(param, "QuestName", questName);
		ParseString(param, "QuestTypeText", QuestTypeText);
		ParseString(param, "LevelText", levelText);
		AddTooltipColorText(((("[" $ levelText) $ "]") @ questName), getInstanceL2Util().BrightWhite, true, true, true);
		NpcID = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(QuestID, 1);
		NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
		if((NpcName == ""))
		{
			NpcName = GetSystemString(27);
		}
		AddTooltipItemOption(1203, NpcName, true, true, false, , , , , GetColor(170, 153, 119, 255));
		AddTooltipItemOption(1202, QuestTypeText, true, true, false, , , , , GetColor(170, 153, 119, 255));
		requirementStr = Class'NWindow.UIDATA_QUEST'.static.GetRequirement(QuestID, 1);
		GetTextSizeDefault(requirementStr, nWidth, nHeight);
		if((nWidth > 400))
		{
			AddTooltipColorText((GetSystemString(1201) @ ": "), GetColor(163, 163, 163, 255), true, true, false);
			AddTooltipItemBlank(0);
			AddTooltipColorText(requirementStr, GetColor(170, 153, 119, 255), false, false, false);
		}
		else
		{
			AddTooltipItemOption(1201, requirementStr, true, true, false, , , , , GetColor(170, 153, 119, 255));
		}
		AddTooltipItemBlank(10);
		AddTooltipColorText(Class'NWindow.UIDATA_QUEST'.static.GetIntro(QuestID, 1), GetColor(178, 190, 207, 255), true, false, false);
		AddTooltipItemBlank(0);
		AddCrossLine();
		AddTooltipColorText(GetSystemString(2006), GetColor(211, 211, 211, 255), true, true, true);
		AddTooltipItemBlank(3);
		Class'NWindow.UIDATA_QUEST'.static.GetQuestReward(QuestID, 1, RewardIDList, rewardNumList);
		i = 0;
		while((i < RewardIDList.Length))
		{
			AddTooltipItemBlank(0);
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(RewardIDList[i]), tmpInfo);
			addItemIcon(tmpInfo, tmpInfo.IconPanel);
			if((rewardNumList[i] == INT64(0)))
			{
				itemText = GetSystemString(584);
			}
			else if((((((((((((((RewardIDList[i] == 57) || (RewardIDList[i] == 15623)) || (RewardIDList[i] == 15624)) || (RewardIDList[i] == 15625)) || (RewardIDList[i] == 15626)) || (RewardIDList[i] == 15627)) || (RewardIDList[i] == 15628)) || (RewardIDList[i] == 15629)) || (RewardIDList[i] == 15630)) || (RewardIDList[i] == 15631)) || (RewardIDList[i] == 15632)) || (RewardIDList[i] == 15633)) || (RewardIDList[i] == 47130)))
			{
				itemText = MakeCostString(string(rewardNumList[i]));
			}
			else
			{
				itemText = MakeFullSystemMsg(GetSystemMessage(1983), MakeCostString(string(rewardNumList[i])));
			}
			AddTooltipColorText(tmpInfo.Name, getInstanceL2Util().BrightWhite, false, true, false, , 3, 4);
			AddTooltipColorText(itemText, GetColor(170, 153, 119, 255), true, true, false, , 36, -16);
			i++;
		}
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_QUESTRECOMMAND_MAPLIST_NEW(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int QuestID, nWidth, nHeight;
	local string requirementStr, NpcName, QuestTypeText, questName;
	local NQuestUIData questUIData;
	local NQuestDialogUIData questDialogUIData;

	if((int(eSourceType) == 2))
	{
		m_Tooltip.MinimumWidth = 330;
		ParamToRecord(param, Record);
		QuestID = int(Record.nReserved1);
		API_GetNQuestData(QuestID, questUIData);
		questName = questUIData.Name;
		AddTooltipColorText(questName, getInstanceL2Util().BrightWhite, true, true, true);
		NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(questUIData.StartNPC.Id);
		if((NpcName == ""))
		{
			NpcName = GetSystemString(27);
		}
		AddTooltipItemOption(1203, NpcName, true, true, false, , , , , GetColor(170, 153, 119, 255));
		if((QuestID < 20001))
		{
			QuestTypeText = GetSystemString(2738);
		}
		else if((QuestID < 30001))
		{
			QuestTypeText = GetSystemString(2341);
		}
		else
		{
			QuestTypeText = GetSystemString(1796);
		}
		switch(questUIData.Type)
		{
			case NQT_ONETIME:
				QuestTypeText = (QuestTypeText @ GetSystemString(862));
				break;
			case NQT_DAILY:
				QuestTypeText = (QuestTypeText @ GetSystemString(2788));
				break;
			case NQT_WEEKLY:
				QuestTypeText = (QuestTypeText @ GetSystemString(14389));
				break;
			case NQT_REPEAT:
				QuestTypeText = (QuestTypeText @ GetSystemString(861));
				break;
			default:
				break;
		}
		AddTooltipItemOption(1202, QuestTypeText, true, true, false, , , , , GetColor(170, 153, 119, 255));
		API_GetNQuestDialogData(QuestID, questDialogUIData);
		if((questUIData.Goal.Num > 1))
		{
			requirementStr = ((questUIData.Goal.Name @ "x") $ string(questUIData.Goal.Num));
		}
		else
		{
			requirementStr = questUIData.Goal.Name;
		}
		GetTextSizeDefault(requirementStr, nWidth, nHeight);
		if((nWidth > 400))
		{
			AddTooltipColorText((GetSystemString(1201) @ ": "), GetColor(163, 163, 163, 255), true, true, false);
			AddTooltipItemBlank(0);
			AddTooltipColorText(requirementStr, GetColor(170, 153, 119, 255), false, false, false);
		}
		else
		{
			AddTooltipItemOption(1201, requirementStr, true, true, false, , , , , GetColor(170, 153, 119, 255));
		}
		AddTooltipItemBlank(0);
		AddCrossLine();
		AddTooltipColorText(GetSystemString(2006), GetColor(211, 211, 211, 255), true, true, true);
		AddTooltipItemBlank(3);
		SetQuestRewardItem(questUIData.Reward);
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function SetQuestRewardItem(NQuestRewardData rewardDatas)
{
	local int i;
	local array<NQuestRewardItemData> Items;
	local NQuestRewardItemData rewardItemData;

	if((rewardDatas.Level > 0))
	{
		rewardItemData.ItemClassID = 95641;
		rewardItemData.Amount = INT64(rewardDatas.Level);
		Items[Items.Length] = rewardItemData;
	}
	if((rewardDatas.Exp > INT64(0)))
	{
		rewardItemData.ItemClassID = 15623;
		rewardItemData.Amount = rewardDatas.Exp;
		Items[Items.Length] = rewardItemData;
	}
	if((rewardDatas.Sp > 0))
	{
		rewardItemData.ItemClassID = 15624;
		rewardItemData.Amount = INT64(rewardDatas.Sp);
		Items[Items.Length] = rewardItemData;
	}
	i = 0;
	while((i < rewardDatas.Items.Length))
	{
		Items[Items.Length] = rewardDatas.Items[i];
		i++;
	}
	InsertQuestRewardItems(Items);
	return;
}

function InsertQuestRewardItems(array<NQuestRewardItemData> Items)
{
	local int i;
	local ItemInfo tmpInfo;
	local string itemText;
	local int DisplayType;

	i = 0;
	while((i < Items.Length))
	{
		AddTooltipItemBlank(0);
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(Items[i].ItemClassID), tmpInfo);
		addItemIcon(tmpInfo, tmpInfo.IconPanel);
		if((Items[i].Amount == INT64(0)))
		{
			itemText = GetSystemString(584);
		}
		else
		{
			DisplayType = getInstanceL2Util()._GetItemDisplayType(Items[i].ItemClassID);
			itemText = getInstanceL2Util()._GetItemDisplayString(DisplayType, Items[i].Amount);
		}
		AddTooltipColorText(tmpInfo.Name, getInstanceL2Util().BrightWhite, false, true, false, , 3, 4);
		AddTooltipColorText(itemText, GetColor(170, 153, 119, 255), true, true, false, , 36, -16);
		i++;
	}
	return;
}

function ReturnTooltip_NTT_MANOR(string param, string TooltipType, UIEventManager.ETooltipSourceType eSourceType)
{
	local LVDataRecord Record;
	local int idx1, idx2, idx3;

	if((int(eSourceType) == 2))
	{
		ParamToRecord(param, Record);
		if((TooltipType == "ManorSeedInfo"))
		{
			idx1 = 4;
			idx2 = 5;
			idx3 = 6;
		}
		else if((TooltipType == "ManorCropInfo"))
		{
			idx1 = 5;
			idx2 = 6;
			idx3 = 7;
		}
		else if((TooltipType == "ManorSeedSetting"))
		{
			idx1 = 7;
			idx2 = 8;
			idx3 = 9;
		}
		else if((TooltipType == "ManorCropSetting"))
		{
			idx1 = 9;
			idx2 = 10;
			idx3 = 11;
		}
		else if((TooltipType == "ManorDefaultInfo"))
		{
			idx1 = 1;
			idx2 = 4;
			idx3 = 5;
		}
		else if((TooltipType == "ManorCropSell"))
		{
			idx1 = 7;
			idx2 = 8;
			idx3 = 9;
		}
		AddTooltipItemOption(0, Record.LVDataList[0].szData, false, true, true);
		AddTooltipItemOption(537, Record.LVDataList[idx1].szData, true, true, false);
		AddTooltipItemOption(1134, Record.LVDataList[idx2].szData, true, true, false);
		AddTooltipItemOption(1135, Record.LVDataList[idx3].szData, true, true, false);
	}
	else
	{
		return;
	}
	ReturnTooltipInfo(m_Tooltip);
	return;
}

function ReturnTooltip_NTT_QUESTREWARDS(string param, UIEventManager.ETooltipSourceType eSourceType)
{
	ReturnTooltip_NTT_ITEM(param, "QuestReward", eSourceType);
	return;
}

function SetTooltipItemColor(int R, int G, int B, int offset)
{
	local int idx;

	idx = ((m_Tooltip.DrawList.Length - 1) - offset);
	m_Tooltip.DrawList[idx].t_color.R = byte(R);
	m_Tooltip.DrawList[idx].t_color.G = byte(G);
	m_Tooltip.DrawList[idx].t_color.B = byte(B);
	m_Tooltip.DrawList[idx].t_color.A = 255;
	return;
}

function int AddTooltipItemEnchant(ItemInfo item, optional bool bFirstLineWidthCount, optional string FontName, optional int OffsetX, optional int OffsetY)
{
	local int nSumWidth, sizeWidth, sizeHeight;
	local UIEventManager.EItemParamType EItemParamType;

	EItemParamType = EItemParamType(item.ItemType);
	if(((item.Enchanted > 0) && IsEnchantableItem(EItemParamType)))
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 170;
		m_Info.t_color.G = 110;
		m_Info.t_color.B = 230;
		m_Info.t_color.A = 255;
		m_Info.t_strText = ("+" $ string(item.Enchanted));
		m_Info.nOffSetX = (m_Info.nOffSetX + OffsetX);
		m_Info.nOffSetY = (m_Info.nOffSetY + OffsetY);
		m_Info.t_strFontName = FontName;
		EndItem();
		GetTextSizeDefault(m_Info.t_strText, sizeWidth, sizeHeight);
		nSumWidth = (nSumWidth + sizeWidth);
	}
	return nSumWidth;
}

function AddItemEnchantedImg(int nEnchanted)
{
	local string s1, S2, ss;

	if((nEnchanted > 0))
	{
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom("L2UI_CT1.ENCHANTNUMBER_SMALL_plus", false, true, 0, -9, 6, 8, 6, 8));
	}
	if((nEnchanted > 9))
	{
		ss = string(nEnchanted);
		s1 = Left(ss, 1);
		S2 = Right(ss, 1);
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom(("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s1), true, false, 0, -9, 6, 8, 6, 8));
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom(("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ S2), true, false, 0, -9, 6, 8, 6, 8));
	}
	else if(((nEnchanted > 0) && (nEnchanted < 10)))
	{
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom(("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string(nEnchanted)), true, false, 0, -9, 6, 8, 6, 8));
	}
	return;
}

function AddItemEnsoulStepNumImg(int nStep)
{
	local string s1, S2, ss;

	if((nStep > 9))
	{
		ss = string(nStep);
		s1 = Left(ss, 1);
		S2 = Right(ss, 1);
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom(("L2UI_NewTex.ToolTip.TooltipNUMBER" $ s1), true, false, -12, 22, 6, 8, 6, 8));
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom(("L2UI_NewTex.ToolTip.TooltipNUMBER" $ S2), true, false, 0, 22, 6, 8, 6, 8));
	}
	else if(((nStep > 0) && (nStep < 10)))
	{
		addToolTipDrawList(m_Tooltip, addDrawItemTextureCustom(("L2UI_NewTex.ToolTip.TooltipNUMBER" $ string(nStep)), true, false, -6, 22, 6, 8, 6, 8));
	}
	return;
}

function AddTooltipItemName(ItemInfo item, optional string FontName, optional int OffsetX, optional int OffsetY)
{
	local string ItemName;

	if(isBlessed(item))
	{
		if((OffsetX == 0))
		{
			ItemName = (GetSystemString(13403) $ " ");
		}
		else
		{
			ItemName = GetSystemString(13403);
		}
		AddTooltipColorText(ItemName, getInstanceL2Util().Blue, false, true, false, FontName, OffsetX, OffsetY);
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		ItemName = Class'NWindow.UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);
	}
	else
	{
		ItemName = item.Name;
	}
	StartItem();
	m_Info.eType = DIT_TEXT;
	m_Info.t_bDrawOneLine = true;
	m_Info.t_color = _GetItemNameColor(item.Id);
	m_Info.nOffSetX = (m_Info.nOffSetX + OffsetX);
	m_Info.nOffSetY = (m_Info.nOffSetY + OffsetY);
	m_Info.t_strText = ItemName;
	m_Info.t_strFontName = FontName;
	EndItem();
	if((Len(item.AdditionalName) > 0))
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 255;
		m_Info.t_color.G = 217;
		m_Info.t_color.B = 105;
		m_Info.t_color.A = 255;
		m_Info.nOffSetX = (m_Info.nOffSetX + OffsetX);
		m_Info.nOffSetY = (m_Info.nOffSetY + OffsetY);
		m_Info.t_strFontName = FontName;
		m_Info.t_strText = (" " $ item.AdditionalName);
		EndItem();
	}
	return;
}

function Color _GetItemNameColor(ItemID Id)
{
	local int nAddTooltipItemName;

	nAddTooltipItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(Id);
	switch(nAddTooltipItemName)
	{
		case 0:
			return GetColor(137, 137, 137, 255);
		case 1:
			return GetColor(230, 230, 230, 255);
		case 2:
			return GetColor(255, 251, 4, 255);
		case 3:
			return GetColor(240, 68, 68, 255);
		case 4:
			return GetColor(33, 164, 255, 255);
		case 5:
			return GetColor(255, 0, 255, 255);
		default:
			return GetColor(137, 137, 137, 255);
	}
}

function AddTooltipItemGrade(ItemInfo item, optional int OffsetX, optional int OffsetY)
{
	local string TextureName;

	TextureName = GetItemGradeTextureName(item.CrystalType);
	if((Len(TextureName) > 0))
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.u_strTexture = TextureName;
		m_Info.nOffSetX = ((m_Info.nOffSetX + OffsetX) + 8);
		m_Info.nOffSetY = (m_Info.nOffSetY + OffsetY);
		m_Info.u_nTextureHeight = 16;
		m_Info.u_nTextureUHeight = 16;
		if((((((item.CrystalType == 6) || (item.CrystalType == 7)) || (item.CrystalType == 9)) || (item.CrystalType == 10)) || (item.CrystalType == 11)))
		{
			m_Info.u_nTextureWidth = 32;
			m_Info.u_nTextureUWidth = 32;
		}
		else
		{
			m_Info.u_nTextureWidth = 16;
			m_Info.u_nTextureUWidth = 16;
		}
		EndItem();
	}
	return;
}

function AddTooltipItemCount(ItemInfo item, optional int OffsetX, optional int OffsetY)
{
	if(IsStackableItem(item.ConsumeType))
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_strText = ((" (" $ MakeCostString(string(item.ItemNum))) $ ")");
		m_Info.nOffSetX = (m_Info.nOffSetX + OffsetX);
		m_Info.nOffSetY = (m_Info.nOffSetY + OffsetY);
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		EndItem();
	}
	return;
}

function GetRefineryColor(int Quality, out int R, out int G, out int B)
{
	switch(Quality)
	{
		case 1:
			R = 187;
			G = 181;
			B = 138;
			break;
		case 2:
			R = 132;
			G = 174;
			B = 216;
			break;
		case 3:
			R = 193;
			G = 112;
			B = 202;
			break;
		case 4:
			R = 225;
			G = 109;
			B = 109;
			break;
		default:
			R = 187;
			G = 181;
			B = 138;
			break;
	}
	return;
}

function AddTooltipItemAttributeGage(ItemInfo item)
{
	local int i;
	local array<string> TextureName, tooltipStr;

	i = 0;
	while((i < 6))
	{
		TextureName[i] = "";
		tooltipStr[i] = "";
		i++;
	}
	NowAttrLv = 0;
	NowMaxValue = 0;
	NowValue = 0;
	if((item.AttackAttributeValue > 0))
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_AttackAttributeValue_small", GetSystemString(1596));
		SetAttackAttribute(item.AttackAttributeValue, 0);
		SetAttackAttribute(item.AttackAttributeValue, 1);
		SetAttackAttribute(item.AttackAttributeValue, 2);
		SetAttackAttribute(item.AttackAttributeValue, 3);
		SetAttackAttribute(item.AttackAttributeValue, 4);
		SetAttackAttribute(item.AttackAttributeValue, 5);
		switch(item.AttackAttributeType)
		{
			case 0:
				TextureName[0] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_FIRE";
				tooltipStr[0] = (((((((((GetSystemString(1622) $ " Lv ") $ string(AttackAttLevel[0])) $ " (") $ GetSystemString(1622)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")");
				break;
			case 1:
				TextureName[1] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WATER";
				tooltipStr[1] = (((((((((GetSystemString(1623) $ " Lv ") $ string(AttackAttLevel[1])) $ " (") $ GetSystemString(1623)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")");
				break;
			case 2:
				TextureName[2] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WIND";
				tooltipStr[2] = (((((((((GetSystemString(1624) $ " Lv ") $ string(AttackAttLevel[2])) $ " (") $ GetSystemString(1624)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")");
				break;
			case 3:
				TextureName[3] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_EARTH";
				tooltipStr[3] = (((((((((GetSystemString(1625) $ " Lv ") $ string(AttackAttLevel[3])) $ " (") $ GetSystemString(1625)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")");
				break;
			case 4:
				TextureName[4] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DIVINE";
				tooltipStr[4] = (((((((((GetSystemString(1626) $ " Lv ") $ string(AttackAttLevel[4])) $ " (") $ GetSystemString(1626)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")");
				break;
			case 5:
				TextureName[5] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DARK";
				tooltipStr[5] = (((((((((GetSystemString(1627) $ " Lv ") $ string(AttackAttLevel[5])) $ " (") $ GetSystemString(1627)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")");
				break;
			default:
				break;
		}
	}
	else
	{
		SetDefAttribute(item.DefenseAttributeValueFire, 0);
		SetDefAttribute(item.DefenseAttributeValueWater, 1);
		SetDefAttribute(item.DefenseAttributeValueWind, 2);
		SetDefAttribute(item.DefenseAttributeValueEarth, 3);
		SetDefAttribute(item.DefenseAttributeValueHoly, 4);
		SetDefAttribute(item.DefenseAttributeValueUnholy, 5);
		if((item.DefenseAttributeValueFire != 0))
		{
			TextureName[0] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_FIRE";
			tooltipStr[0] = (((((((((GetSystemString(1623) $ " Lv ") $ string(DefAttLevel[0])) $ " (") $ GetSystemString(1622)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueFire)) $ ")");
		}
		if((item.DefenseAttributeValueWater != 0))
		{
			TextureName[1] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WATER";
			tooltipStr[1] = (((((((((GetSystemString(1622) $ " Lv ") $ string(DefAttLevel[1])) $ " (") $ GetSystemString(1623)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueWater)) $ ")");
		}
		if((item.DefenseAttributeValueWind != 0))
		{
			TextureName[2] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WIND";
			tooltipStr[2] = (((((((((GetSystemString(1625) $ " Lv ") $ string(DefAttLevel[2])) $ " (") $ GetSystemString(1624)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueWind)) $ ")");
		}
		if((item.DefenseAttributeValueEarth != 0))
		{
			TextureName[3] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_EARTH";
			tooltipStr[3] = (((((((((GetSystemString(1624) $ " Lv ") $ string(DefAttLevel[3])) $ " (") $ GetSystemString(1625)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueEarth)) $ ")");
		}
		if((item.DefenseAttributeValueHoly != 0))
		{
			TextureName[4] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DIVINE";
			tooltipStr[4] = (((((((((GetSystemString(1627) $ " Lv ") $ string(DefAttLevel[4])) $ " (") $ GetSystemString(1626)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueHoly)) $ ")");
		}
		if((item.DefenseAttributeValueUnholy != 0))
		{
			TextureName[5] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DARK";
			tooltipStr[5] = (((((((((GetSystemString(1626) $ " Lv ") $ string(DefAttLevel[5])) $ " (") $ GetSystemString(1627)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueUnholy)) $ ")");
		}
	}
	if((item.AttackAttributeValue > 0))
	{
		i = 0;
		while((i < 6))
		{
			if((tooltipStr[i] == ""))
			{
				i++;
				continue;
			}
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_strText = tooltipStr[i];
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 0;
			m_Info.nOffSetY = 2;
			m_Info.u_nTextureWidth = 140;
			m_Info.u_nTextureHeight = 7;
			m_Info.u_strTexture = (TextureName[i] $ "_BG");
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 0;
			m_Info.nOffSetY = -7;
			m_Info.u_nTextureWidth = ((AttackAttCurrValue[i] * 140) / AttackAttMaxValue[i]);
			if((m_Info.u_nTextureWidth > 140))
			{
				m_Info.u_nTextureWidth = 140;
			}
			m_Info.u_nTextureHeight = 7;
			m_Info.u_strTexture = TextureName[i];
			EndItem();
			i++;
		}
	}
	else
	{
		if(((((((item.DefenseAttributeValueFire > 0) || (item.DefenseAttributeValueWater > 0)) || (item.DefenseAttributeValueWind > 0)) || (item.DefenseAttributeValueEarth > 0)) || (item.DefenseAttributeValueHoly > 0)) || (item.DefenseAttributeValueUnholy > 0)))
		{
			AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_AttackAttributeValue_small", GetSystemString(1596));
		}
		i = 0;
		while((i < 6))
		{
			if((tooltipStr[i] == ""))
			{
				i++;
				continue;
			}
			StartItem();
			m_Info.eType = DIT_TEXT;
			m_Info.nOffSetY = 2;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.t_strText = tooltipStr[i];
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 0;
			m_Info.nOffSetY = 2;
			m_Info.u_nTextureWidth = 140;
			m_Info.u_nTextureHeight = 7;
			m_Info.u_strTexture = (TextureName[i] $ "_BG");
			EndItem();
			StartItem();
			m_Info.eType = DIT_TEXTURE;
			m_Info.bLineBreak = true;
			m_Info.t_bDrawOneLine = true;
			m_Info.nOffSetX = 0;
			m_Info.nOffSetY = -7;
			m_Info.u_nTextureWidth = ((DefAttCurrValue[i] * 140) / DefAttMaxValue[i]);
			if((m_Info.u_nTextureWidth > 140))
			{
				m_Info.u_nTextureWidth = 140;
			}
			m_Info.u_nTextureHeight = 7;
			m_Info.u_strTexture = TextureName[i];
			EndItem();
			i++;
		}
	}
	return;
}

function AddTooltipItemCurrentPeriod(ItemInfo item)
{
	if(((item.CurrentPeriod > 0) || (item.CurrentPeriod == -8888)))
	{
		AddCrossLine();
		AddTooltipItemBlank(0);
		if(((item.LookChangeItemID > 0) && (item.Id.ClassID != 4442)))
		{
			AddTooltipItemOption(5144, "", true, false, false);
		}
		else
		{
			AddTooltipItemOption(1739, "", true, false, false);
		}
		SetTooltipItemColor(230, 230, 230, 0);
		AddTooltipItemBlank(0);
		addTexture("l2ui_ct1.SkillWnd_DF_ListIcon_use", 12, 11, 12, 11, 3, 7);
		AddTooltipColorText((GetSystemString(1199) $ " : "), GetColor(163, 163, 163, 255), false, true, false, "", 0, 2);
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.nOffSetY = 2;
		m_Info.bLineBreak = false;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 178;
		m_Info.t_color.G = 190;
		m_Info.t_color.B = 207;
		m_Info.t_color.A = 255;
		if((item.CurrentPeriod == -8888))
		{
			m_Info.t_strText = GetSystemString(1263);
		}
		else
		{
			m_Info.t_strText = MakeTimeStr(item.CurrentPeriod);
		}
		ParamAdd(m_Info.Condition, "Type", "PeriodTime");
		EndItem();
	}
	return;
}

function setMakeTimeStrMaxWidth()
{
	local string timeStr;
	local int Width, Height;

	timeStr = ((GetSystemString(1199) $ " : ") $ MakeTimeStr(1981320));
	GetTextSizeDefault(timeStr, Width, Height);
	if((m_Tooltip.MinimumWidth < Width))
	{
		m_Tooltip.MinimumWidth = Width;
	}
	return;
}

function AddTooltipItemWeaponLookChange(ItemInfo item)
{
	local ItemInfo tmpInfo;

	if(item.IsBlessedItem)
	{
		return;
	}
	if(((item.LookChangeItemID > 0) && (item.Id.ClassID != 4442)))
	{
		AddCrossLine();
		if((((item.BodyPart == 25) || (item.BodyPart == 26)) || (item.BodyPart == 10)))
		{
			AddTooltipItemOption(5115, "", true, false, false, , , , GetColor(230, 230, 230, 255));
		}
		else if((int(byte(item.ItemType)) == 1))
		{
			AddTooltipItemOption(5101, "", true, false, false, , , , GetColor(230, 230, 230, 255));
		}
		else
		{
			AddTooltipItemOption(5082, "", true, false, false, , , , GetColor(230, 230, 230, 255));
		}
		AddTooltipItemBlank(0);
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(item.LookChangeItemID), tmpInfo);
		addItemIconSmallType(tmpInfo, "");
		AddTooltipColorText(item.LookChangeItemName, GetColor(0, 255, 0, 255), false, true, false, "", 3, 3);
	}
	return;
}

function AddActiveRelicInfo(ItemInfo item)
{
	local int activeRelicId;
	local SkillInfo relicSkillInfo;

	if((item.bEquipped == false))
	{
		return;
	}
	if((item.ItemType != 0))
	{
		return;
	}
	if((IsUseRelicSystem() == false))
	{
		return;
	}
	activeRelicId = Class'Interface.RelicWnd'.static.Inst().GetActiveRelicId();
	if((activeRelicId <= 0))
	{
		return;
	}
	relicSkillInfo = Class'Interface.RelicWnd'.static.Inst().GetActiveRelicSkill();
	if((relicSkillInfo.SkillID > 0))
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.ToolTip.TooltipIcon_Relic_small", GetSystemString(14497));
		SetTooltipItemColor(230, 230, 230, 0);
		addToolTipDrawList(m_Tooltip, addDrawItemTexture(relicSkillInfo.TexName, false, false, 2, 0));
		addToolTipDrawList(m_Tooltip, addDrawItemText("", getInstanceL2Util().White, "", false, , 4, 4));
		addToolTipDrawList(m_Tooltip, addDrawItemText(relicSkillInfo.SkillName, getInstanceL2Util().ColorYellow, "", false));
		addToolTipDrawList(m_Tooltip, addDrawItemText(relicSkillInfo.SkillDesc, getInstanceL2Util().ColorGray, "", true));
		addToolTipDrawList(m_Tooltip, addDrawItemBlank(3));
	}
	return;
}

function AddTooltipItemQuestList(ItemInfo item)
{
	local int i, Count, QuestType;
	local string questTypeStr;

	i = 0;
	while((i < 10))
	{
		if((item.RelatedQuestID[i] > 0))
		{
			questTypeStr = "";
			if((getInstanceUIData().GetIsClassicServer() && !IsAdenServer()))
			{
				switch(Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(item.RelatedQuestID[i], 1))
				{
					case 0:
						questTypeStr = GetSystemString(862);
						break;
					case 1:
						QuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(item.RelatedQuestID[i], 1);
						if(((QuestType == 4) || (QuestType == 5)))
						{
							questTypeStr = GetSystemString(2788);
						}
						else
						{
							questTypeStr = GetSystemString(861);
						}
						break;
					case 2:
						questTypeStr = GetSystemString(1998);
						break;
					case 3:
						questTypeStr = GetSystemString(1999);
						break;
					case 4:
						questTypeStr = GetSystemString(2000);
						break;
					default:
						break;
				}
			}
			else if((item.RelatedQuestID[i] < 20001))
			{
				questTypeStr = GetSystemString(2738);
			}
			else if((item.RelatedQuestID[i] < 30001))
			{
				questTypeStr = GetSystemString(2341);
			}
			else
			{
				questTypeStr = GetSystemString(1796);
			}
			if((questTypeStr != ""))
			{
				questTypeStr = (("[" $ questTypeStr) $ "]");
			}
			if((GetQuestNameUtil(item.RelatedQuestID[i]) != ""))
			{
				if((Count == 0))
				{
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.nOffSetY = 2;
					m_Info.bLineBreak = true;
					m_Info.t_bDrawOneLine = true;
					m_Info.t_strText = GetSystemString(1721);
					EndItem();
				}
				Count++;
				AddTooltipColorText((questTypeStr @ GetQuestNameUtil(item.RelatedQuestID[i])), GetColor(163, 163, 163, 255), true, true, false, "", 0, 2);
			}
		}
		i++;
	}
	return;
}

function SetAttackAttribute(int Attvalue, int Type)
{
	if((Attvalue >= 375))
	{
		AttackAttLevel[Type] = 9;
		AttackAttMaxValue[Type] = 75;
		AttackAttCurrValue[Type] = (Attvalue - 375);
	}
	else if((Attvalue >= 325))
	{
		AttackAttLevel[Type] = 8;
		AttackAttMaxValue[Type] = 50;
		AttackAttCurrValue[Type] = (Attvalue - 325);
	}
	else if((Attvalue >= 300))
	{
		AttackAttLevel[Type] = 7;
		AttackAttMaxValue[Type] = 25;
		AttackAttCurrValue[Type] = (Attvalue - 300);
	}
	else if((Attvalue >= 225))
	{
		AttackAttLevel[Type] = 6;
		AttackAttMaxValue[Type] = 75;
		AttackAttCurrValue[Type] = (Attvalue - 225);
	}
	else if((Attvalue >= 175))
	{
		AttackAttLevel[Type] = 5;
		AttackAttMaxValue[Type] = 50;
		AttackAttCurrValue[Type] = (Attvalue - 175);
	}
	else if((Attvalue >= 150))
	{
		AttackAttLevel[Type] = 4;
		AttackAttMaxValue[Type] = 25;
		AttackAttCurrValue[Type] = (Attvalue - 150);
	}
	else if((Attvalue >= 75))
	{
		AttackAttLevel[Type] = 3;
		AttackAttMaxValue[Type] = 75;
		AttackAttCurrValue[Type] = (Attvalue - 75);
	}
	else if((Attvalue >= 25))
	{
		AttackAttLevel[Type] = 2;
		AttackAttMaxValue[Type] = 50;
		AttackAttCurrValue[Type] = (Attvalue - 25);
	}
	else
	{
		AttackAttLevel[Type] = 1;
		AttackAttMaxValue[Type] = 25;
		AttackAttCurrValue[Type] = Attvalue;
	}
	return;
}

function SetDefAttribute(int Defvalue, int Type)
{
	if((Defvalue >= 150))
	{
		DefAttLevel[Type] = 9;
		DefAttMaxValue[Type] = 30;
		DefAttCurrValue[Type] = (Defvalue - 150);
	}
	else if((Defvalue >= 132))
	{
		DefAttLevel[Type] = 8;
		DefAttMaxValue[Type] = 18;
		DefAttCurrValue[Type] = (Defvalue - 132);
	}
	else if((Defvalue >= 120))
	{
		DefAttLevel[Type] = 7;
		DefAttMaxValue[Type] = 12;
		DefAttCurrValue[Type] = (Defvalue - 120);
	}
	else if((Defvalue >= 90))
	{
		DefAttLevel[Type] = 6;
		DefAttMaxValue[Type] = 30;
		DefAttCurrValue[Type] = (Defvalue - 90);
	}
	else if((Defvalue >= 72))
	{
		DefAttLevel[Type] = 5;
		DefAttMaxValue[Type] = 18;
		DefAttCurrValue[Type] = (Defvalue - 72);
	}
	else if((Defvalue >= 60))
	{
		DefAttLevel[Type] = 4;
		DefAttMaxValue[Type] = 12;
		DefAttCurrValue[Type] = (Defvalue - 60);
	}
	else if((Defvalue >= 30))
	{
		DefAttLevel[Type] = 3;
		DefAttMaxValue[Type] = 30;
		DefAttCurrValue[Type] = (Defvalue - 30);
	}
	else if((Defvalue >= 12))
	{
		DefAttLevel[Type] = 2;
		DefAttMaxValue[Type] = 18;
		DefAttCurrValue[Type] = (Defvalue - 12);
	}
	else
	{
		DefAttLevel[Type] = 1;
		DefAttMaxValue[Type] = 12;
		DefAttCurrValue[Type] = Defvalue;
	}
	return;
}

function AddTooltipBR_MaxEnergy(ItemInfo item)
{
	if((item.BR_MaxEnergy > 0))
	{
		AddTooltipItemBlank(2);
		AddTooltipItemOption(5065, "", true, false, false);
		SetTooltipItemColor(230, 230, 230, 0);
		AddTooltipColorText(GetSystemString(5066), GetColor(163, 163, 163, 255), true, true);
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.t_bDrawOneLine = true;
		m_Info.bLineBreak = true;
		if(((item.BR_CurrentEnergy == 0) || ((item.BR_MaxEnergy / item.BR_CurrentEnergy) > 10)))
		{
			m_Info.t_color.R = 255;
			m_Info.t_color.G = 0;
			m_Info.t_color.B = 0;
		}
		else
		{
			m_Info.t_color.R = 176;
			m_Info.t_color.G = 155;
			m_Info.t_color.B = 121;
		}
		m_Info.t_color.A = 255;
		m_Info.t_strText = " ";
		ParamAdd(m_Info.Condition, "Type", "CurrentEnergy");
		EndItem();
	}
	return;
}

function AddTooltipRefinery(ItemInfo item)
{
	local string strDesc1, strDesc2, strDesc3;
	local int ColorR, ColorG, ColorB, Quality;

	if(((item.RefineryOp1 != 0) || (item.RefineryOp2 != 0)))
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_Refinery_small", GetSystemString(1490));
		SetTooltipItemColor(230, 230, 230, 0);
		if((item.SlotBitType == INT64(8192)))
		{
			Quality = Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(item.RefineryOp1);
			GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		}
		else
		{
			Quality = GetRefineryGradeQuality(item.RefineryOp1, item.RefineryOp2, item.RefineryOp3);
			GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		}
		if((item.RefineryOp1 != 0))
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp1, strDesc1, strDesc2, strDesc3))
			{
				if((Len(strDesc1) > 0))
				{
					AddTooltipColorText(strDesc1, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
				}
				if((Len(strDesc2) > 0))
				{
					AddTooltipColorText(strDesc2, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
				}
				if((Len(strDesc3) > 0))
				{
					AddTooltipColorText(strDesc3, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
				}
			}
		}
		if((item.SlotBitType == INT64(8192)))
		{
			Quality = Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(item.RefineryOp2);
			GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		}
		if((item.RefineryOp2 != 0))
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp2, strDesc1, strDesc2, strDesc3))
			{
				if((Len(strDesc1) > 0))
				{
					AddTooltipColorText(strDesc1, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
				}
				if((Len(strDesc2) > 0))
				{
					AddTooltipColorText(strDesc2, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
				}
				if((Len(strDesc3) > 0))
				{
					AddTooltipColorText(strDesc3, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
				}
			}
		}
		if((item.RefineryOp3 != 0))
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp3, strDesc1, strDesc2, strDesc3))
			{
				if((GetRefineryGradeQuality(item.RefineryOp1, item.RefineryOp2, item.RefineryOp3) != 0))
				{
					if((Len(strDesc1) > 0))
					{
						AddRefineryEffectTooltipText(strDesc1, GetColor(ColorR, ColorG, ColorB, 255), true, false, false, "L2UI_EPIC.RefineryWnd.SpecialTooltipAni0000", 256, 16);
					}
					if((Len(strDesc2) > 0))
					{
						AddRefineryEffectTooltipText(strDesc2, GetColor(ColorR, ColorG, ColorB, 255), true, false, false, "L2UI_EPIC.RefineryWnd.SpecialTooltipAni0000", 256, 16);
					}
					if((Len(strDesc3) > 0))
					{
						AddRefineryEffectTooltipText(strDesc3, GetColor(ColorR, ColorG, ColorB, 255), true, false, false, "L2UI_EPIC.RefineryWnd.SpecialTooltipAni0000", 256, 16);
					}
				}
				else
				{
					if((Len(strDesc1) > 0))
					{
						AddTooltipColorText(strDesc1, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
					}
					if((Len(strDesc2) > 0))
					{
						AddTooltipColorText(strDesc2, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
					}
					if((Len(strDesc3) > 0))
					{
						AddTooltipColorText(strDesc3, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
					}
				}
			}
		}
		if((!getInstanceUIData().GetIsClassicServer() && (item.SlotBitType != INT64(8192))))
		{
			AddTooltipItemOption(1491, "", true, false, false);
			SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
		}
		AddTooltipItemBlank(2);
	}
	return;
}

function AddItemDesc(ItemInfo item, optional bool bDoNotUseLine)
{
	if((Len(item.Description) > 0))
	{
		if(bDoNotUseLine)
		{
			AddTooltipItemBlank(0);
		}
		else
		{
			AddCrossLine();
			AddTooltipItemBlank(2);
		}
		AddTooltipColorText(item.Description, GetColor(178, 190, 207, 255), true, false);
	}
	return;
}

function AddSecurityLock(ItemInfo item)
{
	if(item.bSecurityLock)
	{
		AddCrossLine();
		AddTooltipColorText((("<" $ GetSystemString(3805)) $ ">"), GetColor(230, 230, 230, 255), false, false);
		AddTooltipColorText(GetSystemString(3806), GetColor(178, 190, 207, 255), true, false);
	}
	return;
}

function AddDeleteDBData(ItemInfo item)
{
	local string dbDeleteDateStr, dbDeleteRemainTimeStr;

	if(item.IsVirtualItem)
	{
		return;
	}
	dbDeleteDateStr = Class'NWindow.UIDATA_ITEM'.static.GetDBDeleteDateString(item.nDBDeleteDate);
	dbDeleteRemainTimeStr = Class'NWindow.UIDATA_ITEM'.static.GetDBDeleteRemainTimeString(item.nDBDeleteDate);
	if((dbDeleteDateStr != ""))
	{
		AddCrossLine();
		AddTooltipItemBlank(2);
		AddTooltipColorText((("<" $ GetSystemString(13406)) $ ">"), getInstanceL2Util().Red, true, false, false, "", 0, 0);
		addTooltipTexture("L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 16, 16, 0, 0, true, true, 0, 1);
		AddTooltipColorText(dbDeleteDateStr, getInstanceL2Util().White, false, true, false, "", 0, 0);
		AddTooltipColorText(" (", getInstanceL2Util().PowderPink, false, true, false, "", 0, 0);
		StartItem();
		m_Info.eType = DIT_TEXT;
		m_Info.bLineBreak = false;
		m_Info.t_bDrawOneLine = true;
		m_Info.nOffSetY = 0;
		m_Info.t_color = getInstanceL2Util().PowderPink;
		m_Info.t_strText = dbDeleteDateStr;
		ParamAdd(m_Info.Condition, "Type", "DBDeleteRemainTime");
		ParamAdd(m_Info.Condition, "Value", string(item.nDBDeleteDate));
		EndItem();
		AddTooltipColorText(")", getInstanceL2Util().PowderPink, false, true, false, "", 0, 0);
	}
	return;
}

function AddAutomaticUseItem(ItemInfo item)
{
	if(item.IsVirtualItem)
	{
		return;
	}
	if(Class'NWindow.UIDATA_ITEM'.static.IsDefaultActionPeel(item.Id.ClassID))
	{
		AddTooltipItemBlank(0);
		addTexture("L2UI_ct1.AutoShotItemWnd.AutoAllArrow_On", 24, 24, 32, 32, -2, 0);
		AddTooltipColorText(GetSystemString(14087), getInstanceL2Util().Green, false, false, false, "", 2, 6);
		return;
	}
	switch(Class'NWindow.UIDATA_ITEM'.static.GetAutomaticUseItemType(item.Id.ClassID))
	{
		case AUIT_ITEM:
			AddTooltipItemBlank(0);
			addTexture("L2UI_ct1.AutoShotItemWnd.AutoAllArrow_On", 24, 24, 32, 32, -2, 0);
			AddTooltipColorText(GetSystemString(3962), getInstanceL2Util().Green, false, false, false, "", 2, 6);
			break;
		case AUIT_HP_POTION:
			AddTooltipItemBlank(0);
			addTexture("L2UI_CT1.AutoPotionTooltipICON", 24, 24, 32, 32, -2, 0);
			AddTooltipColorText(GetSystemString(13007), getInstanceL2Util().DRed, false, false, false, "", 2, 6);
			break;
		case AUIT_HP_PET_POTION:
			AddTooltipItemBlank(0);
			addTexture("L2UI_CT1.AutoPotionTooltipICON", 24, 24, 32, 32, -2, 0);
			AddTooltipColorText(GetSystemString(13382), getInstanceL2Util().DRed, false, false, false, "", 2, 6);
			break;
		default:
			break;
	}
	return;
}

function AddEnsoulOption(ItemInfo weaponInfo)
{
	local UIConstants.EnsoulOptionUIInfo optionInfo;
	local int i, N, Cnt, OptionID;
	local bool bUseTitle;
	local int nNormalCount, nBMCount;

	if(getInstanceUIData().GetIsClassicServer())
	{
		if((((weaponInfo.ItemType == 0) || (weaponInfo.ItemType == 1)) || (weaponInfo.ItemType == 2)))
		{
		}
		else
		{
			return;
		}
		i = 1;
		while((i < 3))
		{
			Cnt = (Cnt + weaponInfo.EnsoulOption[(i - 1)].OptionArray.Length);
			i++;
		}
		nNormalCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(weaponInfo.Id, 1);
		nBMCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(weaponInfo.Id, 2);
		if(((Cnt == 0) && ((nNormalCount + nBMCount) > 0)))
		{
			AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_EnSoul_small", GetSystemString(13725), true);
			AddEnsoulOptionSlotIcon(weaponInfo);
			AddTooltipItemBlank(2);
			AddTooltipColorText(GetSystemString(3393), GTColor().Gray, true, false, false, "", 0, 0);
			return;
		}
	}
	else if((((weaponInfo.ItemType == 0) || (weaponInfo.ItemType == 1)) || (weaponInfo.ItemType == 2)))
	{
	}
	else
	{
		return;
	}
	bUseTitle = true;
	i = 1;
	while((i < 3))
	{
		Cnt = weaponInfo.EnsoulOption[(i - 1)].OptionArray.Length;
		N = 1;
		while((N < (1 + Cnt)))
		{
			OptionID = weaponInfo.EnsoulOption[(i - 1)].OptionArray[(N - 1)];
			if((OptionID > 0))
			{
				if(bUseTitle)
				{
					if(getInstanceUIData().GetIsClassicServer())
					{
						AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_EnSoul_small", GetSystemString(13725), true);
						bUseTitle = false;
						AddEnsoulOptionSlotIcon(weaponInfo);
						addToolTipDrawList(m_Tooltip, addDrawItemBlank(3));
					}
					else
					{
						AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_EnSoul_small", GetSystemString(3394));
						SetTooltipItemColor(230, 230, 230, 0);
						bUseTitle = false;
					}
				}
				GetEnsoulOptionUIInfo(OptionID, optionInfo);
				addToolTipDrawList(m_Tooltip, addDrawItemTexture(optionInfo.Icontex, false, false, 2, 0));
				addToolTipDrawList(m_Tooltip, addDrawItemText("", getInstanceL2Util().White, "", false, , 4, 4));
				if((optionInfo.OptionStep > 0))
				{
					addToolTipDrawList(m_Tooltip, addDrawItemText(MakeFullSystemMsg(GetSystemMessage(4347), optionInfo.Name, string(optionInfo.OptionStep)), getInstanceL2Util().ColorYellow, "", false));
				}
				else
				{
					addToolTipDrawList(m_Tooltip, addDrawItemText(optionInfo.Name, getInstanceL2Util().ColorYellow, "", false));
				}
				addToolTipDrawList(m_Tooltip, addDrawItemText(optionInfo.Desc, getInstanceL2Util().ColorGray, "", true));
				addToolTipDrawList(m_Tooltip, addDrawItemBlank(3));
			}
			N++;
		}
		i++;
	}
	return;
}

function AddEnsoulOptionSlotIcon(ItemInfo weaponInfo)
{
	local UIConstants.EnsoulOptionUIInfo optionInfo;
	local int i, N, M, Cnt, OptionID, nNormalCount, nBMCount, nFirstX;

	nFirstX = 4;
	nNormalCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(weaponInfo.Id, 1);
	nBMCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(weaponInfo.Id, 2);
	i = 1;
	while((i < 3))
	{
		Cnt = weaponInfo.EnsoulOption[(i - 1)].OptionArray.Length;
		if((i == 1))
		{
			M = 0;
			while((M < (nNormalCount - Cnt)))
			{
				weaponInfo.EnsoulOption[(i - 1)].OptionArray.Insert(weaponInfo.EnsoulOption[(i - 1)].OptionArray.Length, 1);
				weaponInfo.EnsoulOption[(i - 1)].OptionArray[(weaponInfo.EnsoulOption[(i - 1)].OptionArray.Length - 1)] = 0;
				M++;
			}
			Cnt = nNormalCount;
		}
		else if((i == 2))
		{
			M = 0;
			while((M < (nBMCount - Cnt)))
			{
				weaponInfo.EnsoulOption[(i - 1)].OptionArray.Insert(weaponInfo.EnsoulOption[(i - 1)].OptionArray.Length, 1);
				weaponInfo.EnsoulOption[(i - 1)].OptionArray[(weaponInfo.EnsoulOption[(i - 1)].OptionArray.Length - 1)] = 0;
				M++;
			}
			Cnt = nBMCount;
		}
		N = 1;
		while((N < (1 + Cnt)))
		{
			OptionID = weaponInfo.EnsoulOption[(i - 1)].OptionArray[(N - 1)];
			if((OptionID > 0))
			{
				GetEnsoulOptionUIInfo(OptionID, optionInfo);
				if((i == 1))
				{
					addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotBG", 18, 18, 18, 18, false, false, nFirstX, 2);
					addTooltipTexture(optionInfo.Icontex, 14, 14, 14, 14, false, false, -14, 4);
					addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotTop", 18, 18, 18, 18, false, false, -16, 2);
				}
				else if((i == 2))
				{
					addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotBG", 18, 18, 18, 18, false, false, nFirstX, 2);
					addTooltipTexture(optionInfo.Icontex, 14, 14, 14, 14, false, false, -14, 4);
					addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotTop_Rare", 18, 18, 18, 18, false, false, -16, 2);
				}
			}
			else if((i == 1))
			{
				addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotBG", 18, 18, 18, 18, false, false, (nFirstX + 2), 2);
				addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotTop", 18, 18, 18, 18, false, false, -18, 2);
			}
			else if((i == 2))
			{
				addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotBG", 18, 18, 18, 18, false, false, (nFirstX + 2), 2);
				addTooltipTexture("L2UI_EPIC.ToolTip.ICON_EnSoulslotTop_Rare", 18, 18, 18, 18, false, false, -18, 2);
			}
			if((nFirstX > 0))
			{
				nFirstX = 0;
			}
			N++;
		}
		i++;
	}
	return;
}

function AddTooltipEventSeventhdayOfSeventhMonth(ItemInfo item)
{
	return;
}

function AddTooltipItemDurability(ItemInfo item)
{
	local Color tempColor;

	if(((item.CurrentDurability >= 0) && (item.Durability > 0)))
	{
		AddTooltipItemBlank(2);
		AddTooltipItemOption(1492, "", true, false, false);
		SetTooltipItemColor(230, 230, 230, 0);
		AddTooltipColorText(GetSystemString(1493), GetColor(163, 163, 163, 255), true, true);
		if(((item.CurrentDurability + 1) <= 5))
		{
			tempColor = GetColor(255, 0, 0, 255);
		}
		else
		{
			tempColor = GetColor(176, 155, 121, 255);
		}
		AddTooltipColorText((((" " $ string(item.CurrentDurability)) $ "/") $ string(item.Durability)), tempColor, false, true);
		AddTooltipItemBlank(2);
	}
	return;
}

function int AddPrimeItemSymbol(ItemInfo item, optional bool bFirstLineWidthCount)
{
	local int nSumWidth;
	local string TextureName;

	if((item.IsBRPremium != 2))
	{
		return nSumWidth;
	}
	TextureName = GetPrimeItemSymbolName();
	if((Len(TextureName) > 0))
	{
		StartItem();
		m_Info.eType = DIT_TEXTURE;
		m_Info.nOffSetX = 4;
		m_Info.nOffSetY = 1;
		m_Info.u_nTextureWidth = 14;
		m_Info.u_nTextureHeight = 14;
		m_Info.u_nTextureUWidth = 14;
		m_Info.u_nTextureUHeight = 14;
		m_Info.u_strTexture = TextureName;
		EndItem();
		nSumWidth = ((nSumWidth + m_Info.u_nTextureUWidth) + m_Info.nOffSetX);
	}
	return nSumWidth;
}

function AddEnchantEffectDescTooltip(ItemInfo item)
{
	local int i;
	local array<string> descriptions;
	local int nFontLevel;

	if(Class'NWindow.UIDATA_ITEM'.static.GetEnchantedItemSkillDesc(item.Id.ClassID, item.Enchanted, descriptions, nFontLevel))
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_Enchant_small", GetSystemString(2214));
		i = 0;
		while((i < descriptions.Length))
		{
			AddTooltipColorText(descriptions[i], GetColorEnchentEffectDescFontLevel(nFontLevel), true, false, false);
			i++;
		}
	}
	return;
}

function AddAdenLabCardEffectTooltip(ItemInfo iInfo)
{
	local int BossID;
	local string bossNameString, Msg;
	local EquipAddOptionData eData;

	if((Class'Interface.UIData'.static.Inst()._GetCurrentTranscendEnchant() == 0))
	{
		return;
	}
	BossID = GetEquipAddOptionData(iInfo, eData);
	if((BossID == -1))
	{
		return;
	}
	if(Class'NWindow.UIDATA_INVENTORY'.static.IsEquipItem(iInfo.Id.ServerID))
	{
		Msg = GetSystemMessage(14025);
	}
	else
	{
		Msg = GetSystemMessage(14024);
	}
	bossNameString = Class'Interface.UIData'.static.Inst()._GetAdenLabBossName(BossID);
	AddTitleIconWithHeadLine("L2UI_NewTex.ToolTip.TooltipICON_AdenLab_small", ((GetSystemString(14620) @ "-") @ bossNameString));
	AddTooltipColorText(Msg, GetColor(170, 110, 230, 255), true, false, false);
	return;
}

function API_GetEquipAddOptionData(int Id, out array<EquipAddOptionData> o_OptionArray)
{
	Class'NWindow.UIDataManager'.static.GetEquipAddOptionData(Id, o_OptionArray);
	return;
}

function int GetEquipAddOptionData(ItemInfo iInfo, out EquipAddOptionData oEData)
{
	local int i;
	local array<EquipAddOptionData> o_OptionArray;
	local CardSelectTranscendStage cardSelectTranscendStageData;

	if(!getInstanceUIData().GetIsClassicServer())
	{
		return -1;
	}
	API_GetTranscendStageData(Class'Interface.UIData'.static.Inst()._GetCurrentStageIndex(), cardSelectTranscendStageData);
	API_GetEquipAddOptionData(cardSelectTranscendStageData.EquipOption, o_OptionArray);
	i = 0;
	while((i < o_OptionArray.Length))
	{
		if(((o_OptionArray[i].ItemID == iInfo.Id.ClassID) && (int(o_OptionArray[i].RequiredEnchant) == iInfo.Enchanted)))
		{
			return 1;
		}
		i++;
	}
	return -1;
}

function Color GetColorEnchentEffectDescFontLevel(int nFontLevel)
{
	switch(nFontLevel)
	{
		case 1:
			return GetColor(255, 229, 127, 255);
		case 2:
			return GetColor(103, 120, 255, 255);
		case 3:
			return GetColor(203, 119, 251, 255);
		case 4:
			return GetColor(220, 0, 254, 255);
		default:
			return GetColor(255, 0, 0, 255);
	}
}

function addItemIconSetitem(ItemInfo item, bool bDisable, optional bool bDamaged)
{
	local string disableTex;

	if((bDisable || bDamaged))
	{
		disableTex = "l2ui_ct1.ItemWindow_IconDisable";
	}
	addItemIconCustom(item, "", 26, 26, disableTex, 9, 2);
	return;
}

function AddSetitemTooltip(ItemInfo item)
{
	local int i, j;
	local string strTmp;
	local ItemID tmpItemID;
	local int setId, totalNum;
	local bool IsSigil;
	local ItemInfo tmpInfo;
	local bool bSetDrawTitle;
	local array<ItemID> arrSetIDs;
	local bool bEquiped, bDamaged;

	if(IsValidItemID(item.Id))
	{
		i = 0;
		while((i < 3))
		{
			setId = 0;
			while((setId < Class'NWindow.UIDATA_ITEM'.static.GetSetItemNum(item.Id, i)))
			{
				tmpItemID.ClassID = Class'NWindow.UIDATA_ITEM'.static.GetSetItemFirstID(item.Id, i, setId);
				if((tmpItemID.ClassID > 0))
				{
					if((i == 0))
					{
						totalNum = setId;
					}
					if((bSetDrawTitle == false))
					{
						if(IsAdenServer())
						{
							AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_Set_small", GetSystemString(3881));
						}
						else
						{
							AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_Set_small", GetSystemString(2347));
						}
						bSetDrawTitle = true;
					}
					strTmp = Class'NWindow.UIDATA_ITEM'.static.GetItemName(tmpItemID);
					Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(tmpItemID, tmpInfo);
					bEquiped = false;
					bDamaged = false;
					if(((item.bEquipped == true) && Class'NWindow.UIDATA_ITEM'.static.GetSetItemID(item.Id, i, setId, arrSetIDs)))
					{
						if(Class'NWindow.UIDATA_INVENTORY'.static.IsEquipItem(item.Id.ServerID))
						{
							j = 0;
							while((j < arrSetIDs.Length))
							{
								if(IsAdenServer())
								{
									bDamaged = Class'NWindow.UIDATA_INVENTORY'.static.IsEquippedBreakItemByClassID(arrSetIDs[j].ClassID);
								}
								if(Class'NWindow.UIDATA_INVENTORY'.static.IsEquipItemByClassID(arrSetIDs[j].ClassID))
								{
									bEquiped = true;
									break;
								}
								j++;
							}
						}
						else if(IsAdenServer())
						{
							j = 0;
							while((j < arrSetIDs.Length))
							{
								if(Class'NWindow.UIDATA_INVENTORY'.static.IsPetInventoryItemByClassID(arrSetIDs[j].ClassID))
								{
									bEquiped = true;
									break;
								}
								j++;
							}
						}
					}
					addItemIconSetitem(tmpInfo, !bEquiped, bDamaged);
				}
				setId++;
			}
			i++;
		}
		i = 0;
		while((i < 3))
		{
			j = 0;
			while((j < Class'NWindow.UIDATA_ITEM'.static.GetSetItemPeaceEffectNum(item.Id, i)))
			{
				strTmp = Class'NWindow.UIDATA_ITEM'.static.GetSetItemPeaceEffectDescription(item.Id, i, j);
				if((strTmp == ""))
				{
					j++;
					continue;
				}
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.nOffSetY = 2;
				m_Info.bLineBreak = true;
				m_Info.t_bDrawOneLine = true;
				SetTooltipTextColor(100, 70, 0, 255);
				if((i == 0))
				{
					m_Info.t_strText = ((string((j + 2)) $ GetSystemString(2345)) $ " : ");
				}
				else if((i == 1))
				{
					if((IsSigil == true))
					{
						m_Info.t_strText = ((((string((totalNum + 1)) $ GetSystemString(2345)) $ "+") $ GetSystemString(1987)) $ ": ");
					}
					else
					{
						m_Info.t_strText = ((((string((totalNum + 1)) $ GetSystemString(2345)) $ "+") $ GetSystemString(2346)) $ ": ");
					}
				}
				ParamAdd(m_Info.Condition, "Type", "SetEffect");
				ParamAddItemID(m_Info.Condition, item.Id);
				ParamAdd(m_Info.Condition, "EffectID", string(i));
				ParamAdd(m_Info.Condition, "SetEffectIndex", string(j));
				ParamAdd(m_Info.Condition, "NormalColor", "100,70,0");
				ParamAdd(m_Info.Condition, "EnableColor", "255,180,0");
				EndItem();
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.nOffSetY = 2;
				SetTooltipTextColor(68, 68, 68, 255);
				m_Info.t_strText = strTmp;
				ParamAdd(m_Info.Condition, "Type", "SetEffect");
				ParamAddItemID(m_Info.Condition, item.Id);
				ParamAdd(m_Info.Condition, "EffectID", string(i));
				ParamAdd(m_Info.Condition, "SetEffectIndex", string(j));
				ParamAdd(m_Info.Condition, "NormalColor", "68,68,68");
				ParamAdd(m_Info.Condition, "EnableColor", "200,200,200");
				EndItem();
				j++;
			}
			i++;
		}
		j = 0;
		while((j < Class'NWindow.UIDATA_ITEM'.static.GetItemSetEnchantEffectNum(item.Id)))
		{
			strTmp = Class'NWindow.UIDATA_ITEM'.static.GetSetItemEnchantEffectDescription(item.Id, j);
			if((Len(strTmp) > 0))
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				m_Info.nOffSetY = 2;
				m_Info.bLineBreak = true;
				m_Info.t_color.R = 110;
				m_Info.t_color.G = 140;
				m_Info.t_color.B = 170;
				m_Info.t_color.A = 255;
				m_Info.t_strText = strTmp;
				ParamAdd(m_Info.Condition, "Type", "EnchantEffect");
				ParamAddItemID(m_Info.Condition, item.Id);
				ParamAdd(m_Info.Condition, "NormalColor", "74,92,104");
				ParamAdd(m_Info.Condition, "EnableColor", "110,140,170");
				ParamAdd(m_Info.Condition, "SetEnchantEffectIndex", string(j));
				EndItem();
			}
			j++;
		}
	}
	return;
}

function string getWarSituationString(int warSituation)
{
	local string returnStr;

	switch(warSituation)
	{
		case 0:
			returnStr = (returnStr $ GetSystemString(2355));
			break;
		case 1:
			returnStr = (returnStr $ GetSystemString(2354));
			break;
		case 2:
			returnStr = (returnStr $ GetSystemString(2353));
			break;
		case 3:
			returnStr = (returnStr $ GetSystemString(2352));
			break;
		case 4:
			returnStr = (returnStr $ GetSystemString(2351));
			break;
		default:
			break;
	}
	return returnStr;
}

function bool IsEnchantableItem(UIEventManager.EItemParamType Type)
{
	return ((((int(Type) == 0) || (int(Type) == 1)) || (int(Type) == 3)) || (int(Type) == 2));
}

function ClearTooltip()
{
	m_Tooltip.SimpleLineCount = 0;
	m_Tooltip.MinimumWidth = 0;
	m_Tooltip.DrawList.Remove(0, m_Tooltip.DrawList.Length);
	return;
}

function StartItem()
{
	local DrawItemInfo infoClear;

	m_Info = infoClear;
	return;
}

function EndItem()
{
	m_Tooltip.DrawList.Length = (m_Tooltip.DrawList.Length + 1);
	m_Tooltip.DrawList[(m_Tooltip.DrawList.Length - 1)] = m_Info;
	return;
}

function SetTooltipTextColor(int R, int G, int B, int A)
{
	m_Info.t_color.R = byte(R);
	m_Info.t_color.G = byte(G);
	m_Info.t_color.B = byte(B);
	m_Info.t_color.A = byte(A);
	return;
}

function SetTooltipText(string strDesc, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine)
{
	m_Info.eType = DIT_TEXT;
	if(!isFirstLine)
	{
		m_Info.nOffSetY = 2;
	}
	m_Info.t_strText = strDesc;
	m_Info.bLineBreak = bLineBreak;
	m_Info.t_bDrawOneLine = t_bDrawOneLine;
	return;
}

function AddCrossLine()
{
	if((m_Tooltip.DrawList.Length > 1))
	{
		if((m_Tooltip.DrawList[(m_Tooltip.DrawList.Length - 2)].u_strTexture == "L2UI_NewTex.Tooltip.TooltipLine_BasicShotBG"))
		{
			return;
		}
		if((m_Tooltip.DrawList[(m_Tooltip.DrawList.Length - 2)].u_strTexture == "L2UI_NewTex.Tooltip.TooltipLine_Unable"))
		{
			return;
		}
	}
	AddTooltipItemBlank(4);
	StartItem();
	m_Info.eType = DIT_SPLITLINE;
	m_Info.u_nTextureUWidth = 154;
	m_Info.u_nTextureHeight = 1;
	m_Info.u_strTexture = "L2ui_ch3.tooltip_line";
	EndItem();
	AddTooltipItemBlank(4);
	return;
}

function AddCrossLineThick()
{
	AddTooltipItemBlank(0);
	StartItem();
	m_Info.eType = DIT_SPLITLINE;
	m_Info.u_nTextureUWidth = 154;
	m_Info.u_nTextureHeight = 7;
	m_Info.u_strTexture = "L2UI_NewTex.Tooltip.TooltipLine_BasicShotBG";
	EndItem();
	AddTooltipItemBlank(0);
	return;
}

function AddTooltipText(string strDesc, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine, optional string FontName, optional int OffsetX, optional int OffsetY)
{
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	StartItem();
	GetItemTextSectionInfos(strDesc, FullText, TextInfos);
	if((TextInfos.Length > 0))
	{
		strDesc = FullText;
		m_Info.t_SectionList = TextInfos;
	}
	m_Info.eType = DIT_TEXT;
	if(!isFirstLine)
	{
		m_Info.nOffSetY = 2;
	}
	m_Info.nOffSetX = (m_Info.nOffSetX + OffsetX);
	m_Info.nOffSetY = (m_Info.nOffSetY + OffsetY);
	m_Info.t_strFontName = FontName;
	m_Info.t_strText = strDesc;
	m_Info.bLineBreak = bLineBreak;
	m_Info.t_bDrawOneLine = t_bDrawOneLine;
	EndItem();
	return;
}

function AddTooltipColorText(string strDesc, Color TextColor, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine, optional string FontName, optional int OffsetX, optional int OffsetY)
{
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	StartItem();
	GetItemTextSectionInfos(strDesc, FullText, TextInfos);
	if((TextInfos.Length > 0))
	{
		strDesc = FullText;
		m_Info.t_SectionList = TextInfos;
	}
	m_Info.eType = DIT_TEXT;
	if(!isFirstLine)
	{
		m_Info.nOffSetY = 2;
	}
	m_Info.bLineBreak = bLineBreak;
	m_Info.t_bDrawOneLine = t_bDrawOneLine;
	m_Info.nOffSetX = (m_Info.nOffSetX + OffsetX);
	m_Info.nOffSetY = (m_Info.nOffSetY + OffsetY);
	m_Info.t_strFontName = FontName;
	m_Info.t_color = TextColor;
	m_Info.t_strText = strDesc;
	m_Info.nOffSetX = OffsetX;
	m_Info.nOffSetY = OffsetY;
	EndItem();
	return;
}

function AddRefineryEffectTooltipText(string strDesc, Color TextColor, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine, optional string effectTexStr, optional int effectTexWidth, optional int effectTexHeight)
{
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	StartItem();
	GetItemTextSectionInfos(strDesc, FullText, TextInfos);
	if((TextInfos.Length > 0))
	{
		strDesc = FullText;
		m_Info.t_SectionList = TextInfos;
	}
	m_Info.eType = DIT_TEXT;
	if(!isFirstLine)
	{
		m_Info.nOffSetY = 2;
	}
	m_Info.bLineBreak = bLineBreak;
	m_Info.t_bDrawOneLine = t_bDrawOneLine;
	m_Info.t_color = TextColor;
	m_Info.t_strFontName = "hs10_S";
	m_Info.t_strText = strDesc;
	if((Len(effectTexStr) != 0))
	{
		m_Info.u_strTexture = effectTexStr;
		m_Info.u_nTextureU = effectTexWidth;
		m_Info.u_nTextureV = effectTexHeight;
		m_Info.u_nTextureUWidth = effectTexWidth;
		m_Info.u_nTextureUHeight = effectTexHeight;
	}
	EndItem();
	return;
}

function AddAgathionSkillTooltip(ItemInfo Info, optional bool IsActive)
{
	local int i;
	local Color titleColor, DescColor;
	local array<SkillInfo> mainSkillList, subSkillList;

	GetAgathionMainSkillList(Info.Id.ClassID, Info.Enchanted, mainSkillList);
	GetAgathionSubSkillList(Info.Id.ClassID, Info.Enchanted, subSkillList);
	if((mainSkillList.Length > 0))
	{
		if(((GetAgathionIndex(Info.Id) == 0) || IsActive))
		{
			titleColor.R = 255;
			titleColor.G = 153;
			titleColor.B = 153;
			titleColor.A = 255;
			DescColor.R = 182;
			DescColor.G = 182;
			DescColor.B = 182;
			DescColor.A = 255;
		}
		else
		{
			titleColor.R = 170;
			titleColor.G = 70;
			titleColor.B = 70;
			titleColor.A = 255;
			DescColor.R = 95;
			DescColor.G = 95;
			DescColor.B = 95;
			DescColor.A = 255;
		}
		AddTooltipItemBlank(4);
		AddTooltipColorText(GetSystemString(3640), titleColor, true, false);
		AddTooltipItemBlank(2);
		i = 0;
		while((i < mainSkillList.Length))
		{
			AddTooltipColorText(" - ", DescColor, true, false);
			AddTooltipColorText(mainSkillList[i].SkillDesc, DescColor, false, false);
			AddTooltipItemBlank(2);
			i++;
		}
	}
	if((subSkillList.Length > 0))
	{
		if((((GetAgathionIndex(Info.Id) > 0) || (GetAgathionIndex(Info.Id) == 0)) || IsActive))
		{
			titleColor.R = 255;
			titleColor.G = 153;
			titleColor.B = 153;
			titleColor.A = 255;
			DescColor.R = 182;
			DescColor.G = 182;
			DescColor.B = 182;
			DescColor.A = 255;
		}
		else
		{
			titleColor.R = 170;
			titleColor.G = 70;
			titleColor.B = 70;
			titleColor.A = 255;
			DescColor.R = 95;
			DescColor.G = 95;
			DescColor.B = 95;
			DescColor.A = 255;
		}
		AddTooltipItemBlank(4);
		AddTooltipColorText(GetSystemString(3641), titleColor, true, false);
		AddTooltipItemBlank(2);
		i = 0;
		while((i < subSkillList.Length))
		{
			AddTooltipColorText(" - ", DescColor, true, false);
			AddTooltipColorText(subSkillList[i].SkillDesc, DescColor, false, false);
			AddTooltipItemBlank(2);
			i++;
		}
	}
	return;
}

function AddTooltipItemBlank(int Height)
{
	StartItem();
	m_Info.eType = DIT_BLANK;
	m_Info.b_nHeight = Height;
	EndItem();
	return;
}

function AddTooltipSimpleText(string strText, optional int OffsetX, optional int OffsetY)
{
	StartItem();
	m_Info.eType = DIT_TEXT;
	m_Info.t_bDrawOneLine = true;
	m_Info.t_strText = strText;
	m_Info.nOffSetX = (m_Info.nOffSetX + OffsetX);
	m_Info.nOffSetY = (m_Info.nOffSetY + OffsetY);
	EndItem();
	return;
}

function AddTooltipItemOption(int TitleID, string content, bool bTitle, bool bContent, bool isFirstLine, optional string FontName, optional int OffsetX, optional int OffsetY, optional Color titleTextColor, optional Color contentTextColor)
{
	if(bTitle)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		if(!isFirstLine)
		{
			m_Info.nOffSetY = 2;
		}
		m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		if(((((int(titleTextColor.R) == 0) && (int(titleTextColor.G) == 0)) && (int(titleTextColor.B) == 0)) && (int(titleTextColor.A) == 0)))
		{
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
		}
		else
		{
			m_Info.t_color = titleTextColor;
		}
		m_Info.nOffSetX = (m_Info.nOffSetX + OffsetX);
		m_Info.nOffSetY = (m_Info.nOffSetY + OffsetY);
		m_Info.t_strFontName = FontName;
		m_Info.t_ID = TitleID;
		EndItem();
	}
	if((content != "0"))
	{
		if(bContent)
		{
			if(bTitle)
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				if(!isFirstLine)
				{
					m_Info.nOffSetY = 2;
				}
				m_Info.t_bDrawOneLine = true;
				if(((((int(titleTextColor.R) == 0) && (int(titleTextColor.G) == 0)) && (int(titleTextColor.B) == 0)) && (int(titleTextColor.A) == 0)))
				{
					m_Info.t_color.R = 163;
					m_Info.t_color.G = 163;
					m_Info.t_color.B = 163;
					m_Info.t_color.A = 255;
				}
				else
				{
					m_Info.t_color = titleTextColor;
				}
				m_Info.nOffSetX = (m_Info.nOffSetX + OffsetX);
				m_Info.nOffSetY = (m_Info.nOffSetY + OffsetY);
				m_Info.t_strFontName = FontName;
				m_Info.t_strText = " : ";
				EndItem();
			}
			StartItem();
			m_Info.eType = DIT_TEXT;
			if(!isFirstLine)
			{
				m_Info.nOffSetY = 2;
			}
			if(!bTitle)
			{
				m_Info.bLineBreak = true;
			}
			m_Info.t_bDrawOneLine = true;
			if(((((int(contentTextColor.R) == 0) && (int(contentTextColor.G) == 0)) && (int(contentTextColor.B) == 0)) && (int(contentTextColor.A) == 0)))
			{
				m_Info.t_color.R = 176;
				m_Info.t_color.G = 155;
				m_Info.t_color.B = 121;
				m_Info.t_color.A = 255;
			}
			else
			{
				m_Info.t_color = contentTextColor;
			}
			m_Info.nOffSetX = (m_Info.nOffSetX + OffsetX);
			m_Info.nOffSetY = (m_Info.nOffSetY + OffsetY);
			m_Info.t_strFontName = FontName;
			m_Info.t_strText = content;
			EndItem();
		}
	}
	return;
}

function AddTooltipItemOptionString(string TitleContent, string content, bool bTitle, bool bContent, bool isFirstLine, Color titleColor, Color ContentColor)
{
	if(bTitle)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		if(!isFirstLine)
		{
			m_Info.nOffSetY = 2;
		}
		m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = titleColor.R;
		m_Info.t_color.G = titleColor.G;
		m_Info.t_color.B = titleColor.B;
		m_Info.t_color.A = titleColor.A;
		m_Info.t_strText = TitleContent;
		EndItem();
	}
	if((content != "0"))
	{
		if(bContent)
		{
			if(bTitle)
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				if(!isFirstLine)
				{
					m_Info.nOffSetY = 2;
				}
				m_Info.t_bDrawOneLine = true;
				m_Info.t_color.R = ContentColor.R;
				m_Info.t_color.G = ContentColor.G;
				m_Info.t_color.B = ContentColor.B;
				m_Info.t_color.A = ContentColor.A;
				m_Info.t_strText = " : ";
				EndItem();
			}
			StartItem();
			m_Info.eType = DIT_TEXT;
			if(!isFirstLine)
			{
				m_Info.nOffSetY = 2;
			}
			if(!bTitle)
			{
				m_Info.bLineBreak = true;
			}
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = ContentColor.R;
			m_Info.t_color.G = ContentColor.G;
			m_Info.t_color.B = ContentColor.B;
			m_Info.t_color.A = ContentColor.A;
			m_Info.t_strText = content;
			EndItem();
		}
	}
	return;
}

function AddTooltipItemOption2(int TitleID, int contentID, bool bTitle, bool bContent, bool isFirstLine)
{
	if(bTitle)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		if(!isFirstLine)
		{
			m_Info.nOffSetY = 2;
		}
		m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_ID = TitleID;
		EndItem();
	}
	if(bContent)
	{
		if(bTitle)
		{
			StartItem();
			m_Info.eType = DIT_TEXT;
			if(!isFirstLine)
			{
				m_Info.nOffSetY = 2;
			}
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = 163;
			m_Info.t_color.G = 163;
			m_Info.t_color.B = 163;
			m_Info.t_color.A = 255;
			m_Info.t_strText = " : ";
			EndItem();
		}
		StartItem();
		m_Info.eType = DIT_TEXT;
		if(!isFirstLine)
		{
			m_Info.nOffSetY = 2;
		}
		if(!bTitle)
		{
			m_Info.bLineBreak = true;
		}
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 176;
		m_Info.t_color.G = 155;
		m_Info.t_color.B = 121;
		m_Info.t_color.A = 255;
		m_Info.t_ID = contentID;
		EndItem();
	}
	return;
}

function AddTooltipItemColorOption(int TitleID, string content, int R, int G, int B, bool bTitle, bool bContent, bool isFirstLine)
{
	if(bTitle)
	{
		StartItem();
		m_Info.eType = DIT_TEXT;
		if(!isFirstLine)
		{
			m_Info.nOffSetY = 2;
		}
		m_Info.bLineBreak = true;
		m_Info.t_bDrawOneLine = true;
		m_Info.t_color.R = 163;
		m_Info.t_color.G = 163;
		m_Info.t_color.B = 163;
		m_Info.t_color.A = 255;
		m_Info.t_ID = TitleID;
		EndItem();
	}
	if((content != "0"))
	{
		if(bContent)
		{
			if(bTitle)
			{
				StartItem();
				m_Info.eType = DIT_TEXT;
				if(!isFirstLine)
				{
					m_Info.nOffSetY = 2;
				}
				m_Info.t_bDrawOneLine = true;
				m_Info.t_color.R = byte(R);
				m_Info.t_color.G = byte(G);
				m_Info.t_color.B = byte(B);
				m_Info.t_color.A = 255;
				m_Info.t_strText = " : ";
				EndItem();
			}
			StartItem();
			m_Info.eType = DIT_TEXT;
			if(!isFirstLine)
			{
				m_Info.nOffSetY = 2;
			}
			if(!bTitle)
			{
				m_Info.bLineBreak = true;
			}
			m_Info.t_bDrawOneLine = true;
			m_Info.t_color.R = byte(R);
			m_Info.t_color.G = byte(G);
			m_Info.t_color.B = byte(B);
			m_Info.t_color.A = 255;
			m_Info.t_strText = content;
			EndItem();
		}
	}
	return;
}

function AddTooltipItemBonus(int nBasic, int nBonus, optional int OffsetX, optional int OffsetY, optional int nBonus2, optional int nAddAttack)
{
	if((nBonus > 0))
	{
		AddTooltipColorText(((" (" $ string(nBasic)) $ " "), GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
		AddTooltipColorText(("+" $ string(nBonus)), GetColor(238, 170, 34, 255), false, true, false, "", OffsetX, OffsetY);
		if((nBonus2 > 0))
		{
			AddTooltipColorText((" +" $ string(nBonus2)), getInstanceL2Util().CAPRI, false, true, false, "", OffsetX, OffsetY);
		}
		if((nAddAttack > 0))
		{
			AddTooltipColorText(((" +" $ string(nAddAttack)) $ ""), GetColor(119, 255, 153, 255), false, true, false, "", OffsetX, OffsetY);
		}
		AddTooltipColorText(")", GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
	}
	else if((nBonus2 > 0))
	{
		AddTooltipColorText(((" (" $ string(nBasic)) $ ""), GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
		if((nBonus2 > 0))
		{
			AddTooltipColorText(("+" $ string(nBonus2)), getInstanceL2Util().CAPRI, false, true, false, "", OffsetX, OffsetY);
		}
		if((nAddAttack > 0))
		{
			AddTooltipColorText(((" +" $ string(nAddAttack)) $ " "), GetColor(119, 255, 153, 255), false, true, false, "", OffsetX, OffsetY);
		}
		AddTooltipColorText(")", GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
	}
	else if((nAddAttack > 0))
	{
		AddTooltipColorText(((" (" $ string(nBasic)) $ ""), GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
		AddTooltipColorText(((" +" $ string(nAddAttack)) $ " "), GetColor(119, 255, 153, 255), false, true, false, "", OffsetX, OffsetY);
		AddTooltipColorText(")", GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
	}
	return;
}

function addTooltipTextureSplitLineType(string Texture, int Width, int Height, int UWidth, int UHeight, optional int OffsetX, optional int OffsetY)
{
	StartItem();
	m_Info.eType = DIT_SPLITLINE;
	m_Info.t_bDrawOneLine = true;
	m_Info.bLineBreak = false;
	m_Info.u_nTextureWidth = Width;
	m_Info.u_nTextureHeight = Height;
	m_Info.nOffSetX = OffsetX;
	m_Info.nOffSetY = OffsetY;
	m_Info.u_nTextureUWidth = UWidth;
	m_Info.u_nTextureUHeight = UHeight;
	m_Info.u_strTexture = Texture;
	EndItem();
	return;
}

function addTooltipTexture(string Texture, int Width, int Height, int UWidth, int UHeight, optional bool oneline, optional bool bLineBreak, optional int OffsetX, optional int OffsetY)
{
	StartItem();
	m_Info.eType = DIT_TEXTURE;
	m_Info.t_bDrawOneLine = oneline;
	m_Info.bLineBreak = bLineBreak;
	m_Info.u_nTextureWidth = Width;
	m_Info.u_nTextureHeight = Height;
	m_Info.nOffSetX = OffsetX;
	m_Info.nOffSetY = OffsetY;
	m_Info.u_nTextureUWidth = UWidth;
	m_Info.u_nTextureUHeight = UHeight;
	m_Info.u_strTexture = Texture;
	EndItem();
	return;
}

function addOverlayTexture(string IconName, int u_nTextureWidth, int u_nTextureHeight, int u_nTextureUWidth, int u_nTextureUHeight, optional int nOffSetX, optional int nOffSetY)
{
	StartItem();
	m_Info.eType = DIT_OVERLAY_TEXTURE;
	m_Info.eAlignType = DIAT_RIGHT_BOTTOM;
	m_Info.u_nTextureWidth = u_nTextureWidth;
	m_Info.u_nTextureHeight = u_nTextureHeight;
	m_Info.u_nTextureUWidth = u_nTextureUWidth;
	m_Info.u_nTextureUHeight = u_nTextureUHeight;
	m_Info.nOffSetX = nOffSetX;
	m_Info.nOffSetY = nOffSetY;
	m_Info.u_strTexture = IconName;
	EndItem();
	return;
}

function string GetAttributeIcon(int nAttributeType)
{
	local string rStr;

	switch(nAttributeType)
	{
		case 0:
			rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_fire";
			break;
		case 1:
			rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_water";
			break;
		case 2:
			rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_wind";
			break;
		case 3:
			rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_earth";
			break;
		case 4:
			rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_Sacred";
			break;
		case 5:
			rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_dark";
			break;
		default:
			break;
	}
	return rStr;
}

function AddItemSimpleExchangeItem(out ItemInfo item)
{
	if(item.bSimpleExchangeItem)
	{
		AddCrossLine();
		AddTooltipItemBlank(4);
		AddTooltipColorText(GetSystemString(14669), GTColor().Yellow03, false, false);
		AddTooltipItemBlank(1);
	}
	return;
}

function AddPetPreviewInfo(ItemInfo item)
{
	if((getInstanceUIData().GetIsLiveServer() == false))
	{
		if(((int(byte(item.EtcItemType)) == 7) && ((item.Id.ServerID > 0) || (item.Id.ServerID == -1))))
		{
			AddCrossLine();
			AddTooltipItemBlank(4);
			AddTooltipColorText(GetSystemString(14850), GTColor().Yellow03, false, false);
			AddTooltipItemBlank(1);
		}
	}
	return;
}

function AddTooltipCreateInfos(out ItemInfo item)
{
	if(item.IsCreateItem)
	{
		AddCrossLine();
		AddTooltipItemBlank(4);
		AddTooltipColorText(GetSystemString(13961), GTColor().Yellow03, false, false);
		AddTooltipItemBlank(1);
	}
	if((item.EtcItemType == 97))
	{
		AddCrossLine();
		AddTooltipItemBlank(4);
		AddTooltipColorText(GetSystemString(14864), GTColor().Yellow03, false, false);
		AddTooltipItemBlank(1);
	}
	return;
}

function AddTitleIconWithHeadLine(string Icontex, string titleStr, optional bool bDoNotAddBlank)
{
	AddTooltipItemBlank(4);
	addTooltipTextureSplitLineType("L2UI_NewTex.Tooltip.TooltipLine_DetailTitleBG", 1, 25, 0, 0, 0, 0);
	if((Icontex != ""))
	{
		addTooltipTexture(Icontex, 18, 18, 0, 0, false, false, 1, 2);
	}
	AddTooltipColorText(titleStr, getInstanceL2Util().Gold, false, true, false, "", 4, 4);
	if((bDoNotAddBlank == false))
	{
		AddTooltipItemBlank(4);
	}
	return;
}

function bool isSImpleTooltipNoSelect(int nUseSimpleTooltip, int nIsSelectMode)
{
	if(((nUseSimpleTooltip > 0) && (nIsSelectMode == 0)))
	{
		return true;
	}
	return false;
}

function bool isEnchanted(out ItemInfo item)
{
	if((int(byte(item.EtcItemType)) == 7))
	{
		return false;
	}
	if((item.Enchanted > 0))
	{
		return true;
	}
	return false;
}

function bool isRefinery(out ItemInfo item)
{
	if((item.RefineryOp1 != 0))
	{
		return true;
	}
	return false;
}

function bool isHeroBookItem(out ItemInfo item)
{
	if(((item.HeroBookPoint > 0) && (item.Enchanted == 0)))
	{
		return true;
	}
	return false;
}

function bool isAttribute(out ItemInfo item)
{
	if((item.AttackAttributeValue > 0))
	{
		return true;
	}
	if((item.DefenseAttributeValueFire > 0))
	{
		return true;
	}
	if((item.DefenseAttributeValueWater > 0))
	{
		return true;
	}
	if((item.DefenseAttributeValueWind > 0))
	{
		return true;
	}
	if((item.DefenseAttributeValueEarth > 0))
	{
		return true;
	}
	if((item.DefenseAttributeValueHoly > 0))
	{
		return true;
	}
	if((item.DefenseAttributeValueUnholy > 0))
	{
		return true;
	}
	return false;
}

function bool isLevelUpBonus(out ItemInfo item, string TooltipType)
{
	local UserInfo myInfo;
	local PetInfo pInfo;
	local int nLevel;

	if((TooltipType == "InventoryPet"))
	{
		GetPetInfo(pInfo);
		nLevel = pInfo.nLevel;
	}
	else
	{
		GetPlayerInfo(myInfo);
		nLevel = myInfo.nLevel;
	}
	if((GetLevelUpItemPhysicalDamageBonus(item.Id.ClassID, nLevel) > 0))
	{
		return true;
	}
	if((GetLevelUpItemMagicalDamageBonus(item.Id.ClassID, nLevel) > 0))
	{
		return true;
	}
	return false;
}

function bool isEnsoulOption(ItemInfo weaponInfo)
{
	local int i, N, Cnt, OptionID;

	if(getInstanceUIData().GetIsClassicServer())
	{
		if((((weaponInfo.ItemType == 0) || (weaponInfo.ItemType == 1)) || (weaponInfo.ItemType == 2)))
		{
		}
		else
		{
			return false;
		}
	}
	else if((((weaponInfo.ItemType == 0) || (weaponInfo.ItemType == 1)) || (weaponInfo.ItemType == 2)))
	{
	}
	else
	{
		return false;
	}
	i = 1;
	while((i < 3))
	{
		Cnt = weaponInfo.EnsoulOption[(i - 1)].OptionArray.Length;
		N = 1;
		while((N < (1 + Cnt)))
		{
			OptionID = weaponInfo.EnsoulOption[(i - 1)].OptionArray[(N - 1)];
			if((OptionID > 0))
			{
				return true;
			}
			N++;
		}
		i++;
	}
	return false;
}

function bool isBlessed(ItemInfo item)
{
	if(item.IsBlessedItem)
	{
		return true;
	}
	return false;
}

function AddCollectionItem(ItemInfo item)
{
	if(isCollectionItem(item))
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.ToolTip.TooltipICON_Collection_small", GetSystemString(13490));
		AddTooltipColorText(GetSystemString(13697), GTColor().Gray, true, false, false, "", 0, 0);
		if((isEnsoulOption(item) || isRefinery(item)))
		{
			AddTooltipColorText(GetSystemString(13712), GTColor().Gray, true, false, false, "", 0, 0);
		}
	}
	return;
}

function AddHeroBookItem(ItemInfo item)
{
	if(isHeroBookItem(item))
	{
		AddTitleIconWithHeadLine("L2UI_NewTex.ToolTip.TooltipIcon_Herobook_small", GetSystemString(14157));
		AddTooltipColorText(GetSystemString(14161), GTColor().Gray, true, false, false, "", 0, 0);
	}
	return;
}

function AddBlessed(ItemInfo item)
{
	local BlessOptionUIData optionList;
	local int i;
	local Color applyColor;
	local ItemInfo tmpInfo;
	local bool hasBaseEffectsStr;

	if(item.IsBlessedItem)
	{
		Class'NWindow.UIDATA_ITEM'.static.GetBlessOptionData(item.Id.ClassID, optionList);
		AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_bless_small", GetSystemString(13405));
		if((item.LookChangeItemID != 0))
		{
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(item.LookChangeItemID), tmpInfo);
			addItemIconSmallType(tmpInfo, "");
			AddTooltipColorText(GetItemNameAll(GetItemInfoByClassID(item.LookChangeItemID)), GetColor(0, 255, 0, 255), false, true, false, "", 3, 3);
			AddTooltipItemBlank(0);
		}
		i = 0;
		while((i < optionList.BaseEffects.Length))
		{
			if((item.BlessBaseEffectID == optionList.BaseEffects[i].Id))
			{
				if((optionList.BaseEffects[i].OptionDesc != ""))
				{
					AddTooltipColorText(optionList.BaseEffects[i].OptionDesc, GetColor(178, 190, 207, 255), true, false, false, "", 0, 0);
				}
			}
			i++;
		}
		i = 0;
		while((i < optionList.EnchantEffects.Length))
		{
			if((item.Enchanted >= optionList.EnchantEffects[i].EnchantedValue))
			{
				applyColor = getInstanceL2Util().ColorYellow;
			}
			else
			{
				applyColor = getInstanceL2Util().Gray;
			}
			AddTooltipColorText((((" +" $ string(optionList.EnchantEffects[i].EnchantedValue)) $ " ") $ optionList.EnchantEffects[i].OptionDesc), applyColor, true, false, false, "", 0, 0);
			i++;
		}
	}
	return;
}

function AddSimpleIcon_EnsoulOption(ItemInfo weaponInfo)
{
	local UIConstants.EnsoulOptionUIInfo optionInfo;
	local int i, N, Cnt, OptionID, ensoulSlotCount;

	if(getInstanceUIData().GetIsClassicServer())
	{
		if((((weaponInfo.ItemType == 0) || (weaponInfo.ItemType == 1)) || (weaponInfo.ItemType == 2)))
		{
		}
		else
		{
			return;
		}
	}
	else if((((weaponInfo.ItemType == 0) || (weaponInfo.ItemType == 1)) || (weaponInfo.ItemType == 2)))
	{
	}
	else
	{
		return;
	}
	i = 1;
	while((i < 3))
	{
		Cnt = weaponInfo.EnsoulOption[(i - 1)].OptionArray.Length;
		N = 1;
		while((N < (1 + Cnt)))
		{
			OptionID = weaponInfo.EnsoulOption[(i - 1)].OptionArray[(N - 1)];
			if((OptionID > 0))
			{
				ensoulSlotCount++;
				GetEnsoulOptionUIInfo(OptionID, optionInfo);
				addTooltipTexture(("L2UI_NewTex.Tooltip.TooltipICON_EnSoul0" $ string(ensoulSlotCount)), 26, 26, 0, 0, true, false, 2, 5);
				AddItemEnsoulStepNumImg(optionInfo.OptionStep);
			}
			N++;
		}
		i++;
	}
	return;
}

function AddSimpleSetitem(ItemInfo item)
{
	local int i;
	local string strTmp;
	local ItemID tmpItemID;
	local int setId, totalNum;
	local bool IsSigil;
	local ItemInfo tmpInfo;
	local bool bSetDrawTitle;

	if(IsValidItemID(item.Id))
	{
		i = 0;
		while((i < 3))
		{
			setId = 0;
			while((setId < Class'NWindow.UIDATA_ITEM'.static.GetSetItemNum(item.Id, i)))
			{
				tmpItemID.ClassID = Class'NWindow.UIDATA_ITEM'.static.GetSetItemFirstID(item.Id, i, setId);
				if((tmpItemID.ClassID > 0))
				{
					if((bSetDrawTitle == false))
					{
						if(IsAdenServer())
						{
							AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_Set_small", GetSystemString(3881));
						}
						else
						{
							AddTitleIconWithHeadLine("L2UI_NewTex.Tooltip.TooltipICON_Set_small", GetSystemString(2347));
						}
						bSetDrawTitle = true;
					}
					strTmp = Class'NWindow.UIDATA_ITEM'.static.GetItemName(tmpItemID);
					Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(tmpItemID, tmpInfo);
					addItemIconSmallType(tmpInfo, "");
					StartItem();
					m_Info.eType = DIT_TEXT;
					m_Info.nOffSetY = 0;
					m_Info.bLineBreak = false;
					m_Info.t_bDrawOneLine = false;
					SetTooltipTextColor(100, 100, 65, 255);
					if((i == 0))
					{
						m_Info.t_strText = (" " $ strTmp);
						ParamAdd(m_Info.Condition, "SetItemNum", string(i));
						ParamAdd(m_Info.Condition, "Type", "Equip");
						ParamAddItemID(m_Info.Condition, item.Id);
						ParamAdd(m_Info.Condition, "CurTypeID", string(setId));
						ParamAdd(m_Info.Condition, "NormalColor", "100,100,65");
						ParamAdd(m_Info.Condition, "EnableColor", "255,250,160");
						totalNum = setId;
					}
					else if((i == 1))
					{
						m_Info.t_strText = ("- (+) " $ strTmp);
						ParamAdd(m_Info.Condition, "SetItemNum", string(i));
						ParamAdd(m_Info.Condition, "Type", "Equip");
						ParamAddItemID(m_Info.Condition, item.Id);
						ParamAdd(m_Info.Condition, "CurTypeID", string(setId));
						ParamAdd(m_Info.Condition, "NormalColor", "100,70,0");
						ParamAdd(m_Info.Condition, "EnableColor", "255,180,0");
						IsSigil = IsSigilArmor(tmpItemID);
					}
					EndItem();
					AddTooltipItemBlank(1);
				}
				setId++;
			}
			i++;
		}
	}
	return;
}

function string GetQuestNameUtil(int qid)
{
	local NQuestUIData qUIData;

	if((getInstanceUIData().GetIsClassicServer() && !IsAdenServer()))
	{
		return Class'NWindow.UIDATA_QUEST'.static.GetQuestName(qid);
	}
	else if(GetNQuestData(qid, qUIData))
	{
		return qUIData.Name;
	}
	return "";
}

function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);
}

function bool API_GetNQuestDialogData(int a_QuestID, out NQuestDialogUIData o_data)
{
	return GetNQuestDialogData(a_QuestID, o_data);
}

function PledgeEnemyDeletePenaltyUIData API_GetPledgeEnemyDeletePenaltyData()
{
	return GetPledgeEnemyDeletePenaltyData();
}

function API_GetTranscendStageData(int a_Index, out CardSelectTranscendStage o_TranscendStage)
{
	Class'NWindow.UIDataManager'.static.GetTranscendStageData(a_Index, o_TranscendStage);
	return;
}

function API_GetCardSelectData(int BossID, out CardSelectData Data)
{
	Class'NWindow.UIDataManager'.static.GetCardSelectData(BossID, Data);
	return;
}

function API_GetRelicsPlayData(UIEventManager.ERelicsPlayDataType a_Type, int a_grade, out RelicsPlayUIData o_data)
{
	GetRelicsPlayData(a_Type, a_grade, o_data);
	return;
}
