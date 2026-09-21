class UIConstants extends UIScript;

const DEBUG_SPLIT_STR = "|::::|";
const ARTIFACTTYE_NORMAL = 4398046511104;
const ARTIFACTTYE_TYPE1 = 18014398509481984;
const ARTIFACTTYE_TYPE2 = 144115188075855872;
const ARTIFACTTYE_TYPE3 = 1152921504606846976;
const USE_XML_TELEPORT_UI = true;
const USE_XML_BOTTOM_BAR_UI = true;
const USE_AUTO_CRAFT_MINIMIZE = true;

enum MULTISELLSHOWTYPE
{
	Normal,                         // 0
	MaterialType,                   // 1
	GOODSEXCHANGE,                  // 2
	ENCHANTSCROLL,                  // 3
	ITEMEXCHANGE                    // 4
};

enum CrystalType
{
	CRT_NONE,                       // 0
	CRT_D,                          // 1
	CRT_C,                          // 2
	CRT_B,                          // 3
	CRT_A,                          // 4
	CRT_S,                          // 5
	CRT_S80,                        // 6
	CRT_S84,                        // 7
	CRT_R,                          // 8
	CRT_R95,                        // 9
	CRT_R99,                        // 10
	CRT_R110,                       // 11
	CRT_EVENT                       // 12
};

enum ERelicGrade
{
	RG_NONE,                        // 0
	RG_N,                           // 1
	RG_D,                           // 2
	RG_C,                           // 3
	RG_B,                           // 4
	RG_A,                           // 5
	RG_S,                           // 6
	RG_R,                           // 7
	Max                             // 8
};

enum HuntingZoneType
{
	DOMINION,                       // 0
	FIELD_HUNTING_ZONE_SOLO,        // 1
	FIELD_HUNTING_ZONE_PARTY,       // 2
	INSTANCE_ZONE_SOLO,             // 3
	INSTANCE_ZONE_PARTY,            // 4
	Agit,                           // 5
	VILLAGE,                        // 6
	etc,                            // 7
	CASTLE,                         // 8
	FORTRESS,                       // 9
	FIELD_HUNTING_ZONE_PARTYWITH_SOLO,// 10
	FIELD_HUNTING_ZONE_OUT_OF_USE,  // 11
	INSTANCE_ZONE_UNION,            // 12
	Max                             // 13
};

enum MapServerInfoType
{
	SIEGEWARFARE,                   // 0
	SIEGEWARFARE_DIMENSION,         // 1
	RAID_DIMENSION,                 // 2
	CURSEDWEAPON_MAGICAL,           // 3
	CURSEDWEAPON_BLOOD,             // 4
	AUCTION,                        // 5
	DEFENSEWARFARE,                 // 6
	CURSEDWEAPON_MAGICAL_TreasureBox,// 7
	CURSEDWEAPON_BLOOD_TreasureBox, // 8
	Max                             // 9
};

struct MenuButtonSlotStruct
{
	var int CategoryIndex;
	var int buttonIndex;
	var string tooltipKey;
	var string SpecialParam;
	var string MenuName;
	var string buttonText;
	var Color buttonTextColor;
	var int nSequence;
	var int nBGTextureIndex;
};

struct MultiSellInfo
{
	var int MultiSellInfoID;
	var int MultiSellType;
	var INT64 NeededItemNum;
	var ItemInfo ResultItemInfo;
	var array<ItemInfo> OutputItemInfoList;
	var array<ItemInfo> InputItemInfoList;
};

struct MapServerInfo
{
	var bool bUse;
	var string normalTex;
	var string pushedTex;
	var string highlightTex;
	var int nServerInfoType;
	var string ToolTipString;
	var string descString;
	var string szReserved;
	var string buttonName;
	var int nRegionID;
	var int nData;
	var array<Vector> clickedLocArray;
	var int clickedLocClickCount;
};

struct RaidUIData
{
	var string raidMonsterName;
	var string raidDesc;
	var int nRaidMonsterID;
	var int nRaidMonsterLevel;
	var int nRaidMonsterZone;
	var string RaidMonsterZoneName;
	var string sortingKey;
	var int nMinLevel;
	var int nMaxLevel;
	var int Id;
	var Vector nWorldLoc;
};

struct SkillTrainInfo
{
	var string strIconName;
	var string strName;
	var string strEnchantName;
	var int Id;
	var int Level;
	var int SubLevel;
	var int requiredLevel;
	var INT64 spConsume;
};

struct EnsoulStoneUIInfo
{
	var int slotType;
	var int ExtractionItemID;
	var array<int> OptionId_Array;
};

struct EnsoulOptionUIInfo
{
	var int OptionID;
	var int OptionStep;
	var int OptionType;
	var string Name;
	var string Desc;
	var string Icontex;
	var string IconPanelTex;
	var int ExtractionItemID;
};

struct EnsoulFeeUIInfo
{
	var int nID;
	var INT64 ItemCount;
};

struct TextureStruct
{
	var string AnchorWindowName;
	var string texturePath;
	var string RelativePoint;
	var string AnchorPoint;
	var int textureOffsetX;
	var int textureOffsetY;
	var int textureW;
	var int textureH;
};

static function TextureStruct getTextureInfo(string texturePath, string AnchorWindowName, string RelativePoint, string AnchorPoint, int textureOffsetX, int textureOffsetY, int textureW, int textureH)
{
	local TextureStruct TS;

	TS.texturePath = texturePath;
	TS.AnchorWindowName = AnchorWindowName;
	TS.RelativePoint = RelativePoint;
	TS.AnchorPoint = AnchorPoint;
	TS.textureOffsetX = textureOffsetX;
	TS.textureOffsetY = textureOffsetY;
	TS.textureW = textureW;
	TS.textureH = textureH;
	return TS;
}

function GetEnsoulStoneUIInfo(ItemInfo eItemInfo, ItemID IdInfo, out EnsoulStoneUIInfo eStoneInfo)
{
	local string EnsoulStoneUIInfoParam;
	local int numOfOption, OptionID, i;
	local string parseStr;

	Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulStoneInfo(IdInfo, EnsoulStoneUIInfoParam);
	ParseInt(EnsoulStoneUIInfoParam, "SlotType", eStoneInfo.slotType);
	ParseInt(EnsoulStoneUIInfoParam, "ExtractionItemID", eStoneInfo.ExtractionItemID);
	Debug(("eItemInfo.SlotBitType" @ string(eItemInfo.SlotBitType)));
	if((eItemInfo.ItemType == 0))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfWeaponOption", numOfOption);
		parseStr = "WeaponOptionId_";
	}
	else if((eItemInfo.SlotBitType == INT64(2048)))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfLegsOption", numOfOption);
		parseStr = "LegsOptionId_";
	}
	else if((eItemInfo.SlotBitType == INT64(4096)))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfFeetOption", numOfOption);
		parseStr = "FeetOptionId_";
	}
	else if((eItemInfo.SlotBitType == INT64(64)))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfHeadOption", numOfOption);
		parseStr = "HeadOptionId_";
	}
	else if((eItemInfo.SlotBitType == INT64(512)))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfGlovesOption", numOfOption);
		parseStr = "GlovesOptionId_";
	}
	else if((eItemInfo.SlotBitType == INT64(32768)))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfOnepieceOption", numOfOption);
		parseStr = "OnepieceOptionId_";
	}
	else if((eItemInfo.SlotBitType == INT64(1024)))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfChestOption", numOfOption);
		parseStr = "ChestOptionId_";
	}
	else if((((eItemInfo.SlotBitType == INT64(16)) || (eItemInfo.SlotBitType == INT64(32))) || (eItemInfo.SlotBitType == INT64(48))))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfFingerOption", numOfOption);
		parseStr = "FingerOptionId_";
	}
	else if((((eItemInfo.SlotBitType == INT64(2)) || (eItemInfo.SlotBitType == INT64(4))) || (eItemInfo.SlotBitType == INT64(6))))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfEarOption", numOfOption);
		parseStr = "EarOptionId_";
	}
	else if((eItemInfo.SlotBitType == INT64(8)))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfNeckOption", numOfOption);
		parseStr = "NeckOptionId_";
	}
	else if(((eItemInfo.SlotBitType == INT64(256)) && (IsSigilArmor(eItemInfo.Id) == false)))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfShieldOption", numOfOption);
		parseStr = "ShieldOptionId_";
	}
	else if(((eItemInfo.SlotBitType == INT64(256)) && IsSigilArmor(eItemInfo.Id)))
	{
		ParseInt(EnsoulStoneUIInfoParam, "NumOfSigilOption", numOfOption);
		parseStr = "SigilOptionId_";
	}
	Debug(("numOfOption" @ string(numOfOption)));
	i = 0;
	while((i < numOfOption))
	{
		ParseInt(EnsoulStoneUIInfoParam, (parseStr $ string(i)), OptionID);
		Debug((("parseStr" @ parseStr) $ string(i)));
		Debug(("optionId" @ string(OptionID)));
		eStoneInfo.OptionId_Array.Length = (eStoneInfo.OptionId_Array.Length + 1);
		eStoneInfo.OptionId_Array[(eStoneInfo.OptionId_Array.Length - 1)] = OptionID;
		i++;
	}
	return;
}

function GetEnsoulOptionUIInfo(int nEnsoulOptionID, out EnsoulOptionUIInfo eOptionInfo)
{
	local string ensoulOptioEachParam;

	if((nEnsoulOptionID > 0))
	{
		Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulOptionInfo(nEnsoulOptionID, ensoulOptioEachParam);
		ParseInt(ensoulOptioEachParam, "OptionType", eOptionInfo.OptionType);
		ParseInt(ensoulOptioEachParam, "OptionStep", eOptionInfo.OptionStep);
		ParseString(ensoulOptioEachParam, "OptionName", eOptionInfo.Name);
		ParseString(ensoulOptioEachParam, "OptionDesc", eOptionInfo.Desc);
		ParseString(ensoulOptioEachParam, "IconTex", eOptionInfo.Icontex);
		ParseString(ensoulOptioEachParam, "IconPanelTex", eOptionInfo.IconPanelTex);
		ParseInt(ensoulOptioEachParam, "ExtractionItemID", eOptionInfo.ExtractionItemID);
		eOptionInfo.OptionID = nEnsoulOptionID;
	}
	else
	{
		Debug("Error : GetEnsoulOptionUIInfo  ->  ensoulID is wrong");
	}
	return;
}

function GetEnsoulFeeUIInfo(ItemInfo eInfo, ItemInfo stoneItemInfo, bool bIsRefee, int slotType, int SlotIndex, out EnsoulFeeUIInfo feeInfo)
{
	local string ensoulFeeInfoParam;

	Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulFeeInfoByItemId(stoneItemInfo.Id.ClassID, bIsRefee, SlotIndex, ensoulFeeInfoParam);
	ParseInt(ensoulFeeInfoParam, "ItemID", feeInfo.nID);
	ParseINT64(ensoulFeeInfoParam, "ItemCount", feeInfo.ItemCount);
	return;
}

function bool IsUseRenewalSkillWnd()
{
	return IsAdenServer();
}

function bool IsUseSkillCastingSpeedStat()
{
	return IsAdenServer();
}

function bool IsUseRelicSystem()
{
	return UIData(GetScript("UIData")).GetIsLiveServer();
}

function bool IsUseDollSystem()
{
	return IsAdenServer();
}

function bool IsShowItemScore()
{
	return IsAdenServer();
}
