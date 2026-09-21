class L2Util extends UICommonAPI;

const DIALOGID_GoWeb = 10;

enum ETreeItemTextType
{
	COLOR_DEFAULT,                  // 0
	COLOR_GRAY,                     // 1
	COLOR_GOLD,                     // 2
	COLOR_RED,                      // 3
	COLOR_YELLOW,                   // 4
	COLOR_DESC,                     // 5
	COLOR_BLUE,                     // 6
	COLOR_BRIGHT_BLUE,              // 7
	Token0,                         // 8
	Token1,                         // 9
	Token2,                         // 10
	Token3,                         // 11
	Yellow03                        // 12
};

enum ETooltipTextType
{
	COLOR_DEFAULT,                  // 0
	COLOR_GRAY,                     // 1
	COLOR_GOLD,                     // 2
	COLOR_YELLOW,                   // 3
	COLOR_YELLOW03,                 // 4
	COLOR_RED,                      // 5
	COLOR_BLUE,                     // 6
	COLOR_ARTIFACT                  // 7
};

enum EGfxScreenMsgType
{
	MSGType_Normal,                 // 0
	MSGType_AddItemEffect,          // 1
	MSGType_Chatting,               // 2
	MSGType_Matching                // 3
};

enum MapPinType
{
	PIN_YELLOW,                     // 0
	PIN_BLUE,                       // 1
	PIN_GREEN                       // 2
};

enum EItemLockedCheckType
{
	ANY,                            // 0
	Lock,                           // 1
	UNLOCK,                         // 2
	NOT_LOCK,                       // 3
	NOT_UNLOCK                      // 4
};

var Color White;
var Color Yellow;
var Color Blue;
var Color BrightWhite;
var Color Gold;
var Color Gray;
var Color Yellow03;
var Color ColorDesc;
var Color ColorYellow;
var Color ColorGray;
var Color ColorLightBrown;
var Color ColorGold;
var Color ColorMinimapFont;
var Color MintGreen;
var Color HotPink;
var Color PowderPink;
var Color Token0;
var Color Token1;
var Color Token2;
var Color Token3;
var Color DarkGray;
var Color BWhite;
var Color DRed;
var Color Red;
var Color Red1;
var Color Red2;
var Color Red3;
var Color VIOLET01;
var Color VIOLET02;
var Color PKNameColor;
var Color Green;
var Color BLUE01;
var Color CAPRI;
var CustomTooltip tooltipText;
var DrawItemInfo toolTipInfo;
var array<string> ItemRelationWindowArrayStr;
var string ItemRelationWindowString;
var PrivateShopWnd PrivateShopWndScript;
var RefineryWnd RefineryWndScript;
var UnrefineryWnd UnrefineryWndScript;
var AttributeRemoveWnd AttributeRemoveWndScript;
var AttributeEnchantWnd AttributeEnchantWndScript;
var CrystallizationWnd CrystallizationWndScript;
var ItemEnchantWnd ItemEnchantWndScript;
var ItemLookChangeWnd ItemLookChangeWndScript;
var MultiSellWnd MultiSellWndScript;
var WarehouseWnd WarehouseWndScript;
var TradeWnd TradeWndScript;
var DeliverWnd DeliverWndScript;
var ItemAttributeChangeWnd ItemAttributeChangeWndScript;
var string URL;
var string Text;
var string m_reservedInt2;
var bool bCheckUsePledgeV2;
var int nUsePledgeV2Classic;
var int nUsePledgeV2Live;
//var delegate<myDelegate> __myDelegate__Delegate;

delegate bool myDelegate(bool bFirst, string Str)
{

}

static function L2Util Inst()
{
	return L2Util(GetScript("L2Util"));
}

function OnRegisterEvent()
{
	RegisterEvent(4960);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(40);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 4960:
			linkWebPage(param);
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			break;
		case 40:
			bCheckUsePledgeV2 = false;
			nUsePledgeV2Classic = 0;
			nUsePledgeV2Live = 0;
			break;
		default:
			break;
	}
	return;
}

function bool isClanV2()
{
	local bool bValue;

	if(getInstanceUIData().GetIsClassicServer())
	{
		if((bCheckUsePledgeV2 == false))
		{
			bCheckUsePledgeV2 = true;
			GetINIBool("Localize", "UsePledgeV2Classic", nUsePledgeV2Classic, "L2.ini");
			Debug(("- GetINIBool UsePledgeV2Classic" @ string(nUsePledgeV2Classic)));
		}
		if((nUsePledgeV2Classic > 0))
		{
			bValue = true;
		}
	}
	else
	{
		if((bCheckUsePledgeV2 == false))
		{
			bCheckUsePledgeV2 = true;
			GetINIBool("Localize", "UsePledgeV2Live", nUsePledgeV2Live, "L2.ini");
		}
		if((nUsePledgeV2Live > 0))
		{
			bValue = true;
		}
	}
	return bValue;
}

function HandleDialogOK()
{
	if(!DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case 10:
			OpenGivenURL(URL);
			break;
		default:
			break;
	}
	return;
}

function linkWebPage(string param)
{
	local UIEventManager.ELanguageType Language;

	if(!ParseString(param, "Url", URL))
	{
		return;
	}
	if(!ParseString(param, "Text", Text))
	{
		Text = "";
	}
	DialogHide();
	DialogSetID(10);
	if((Text != ""))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), Text, ""));
	}
	else
	{
		Language = GetLanguage();
		if((int(Language) != 0))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(6172), "", ""));
			return;
		}
		if((URL == GetSystemString(2265)))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), GetSystemString(2259), ""));
		}
		else if((URL == GetSystemString(2266)))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), GetSystemString(2261), ""));
		}
		else if((URL == GetSystemString(2267)))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), GetSystemString(2263), ""));
		}
		else if((URL == GetSystemString(2762)))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), GetSystemString(2760), ""));
		}
		else if((URL == GetSystemString(2775)))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), GetSystemString(2773), ""));
		}
		else if((URL != ""))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3211), GetSystemString(901), ""));
		}
	}
	return;
}

function OnLoad()
{
	initColor();
	ItemRelationWindowString = (((((((("MultiSellWnd,WarehouseWnd,ShopWnd,TradeWnd,DeliverWnd,SellingAgencyWnd,PostBoxWnd,PostWriteWnd,PostDetailWnd_General,AttendCheckWnd," $ "PostDetailWnd_SafetyTrade,ProductInventoryWnd,PrivateShopWnd,PremiumItemGetWnd,ManorShopWnd,AttributeEnchantWnd,AttributeRemoveWnd,") $ "RefineryWnd,UnrefineryWnd,CrystallizationWnd,InventoryWnd,ItemAttributeChangeWnd,ItemLookChangeWnd,ProgressBox,RecipeShopWnd,") $ "TokenTradeWnd,AdenaDistributionWnd,ItemJewelEnchantWnd,AlchemyMixCubeWnd,AlchemyItemConversionWnd,EnsoulWnd,EnsoulExtractWnd,ItemJewelEnchantWnd,") $ "ItemUpgrade,ItemLockWnd,ElementalSpiritWnd,ArtifactEnchantWnd,ShopDailyLcoinWnd,AutoUseItemInventory,AutoPotionSubWnd,") $ "DetailStatusWndClassic.ConfirmWnd,RandomCraftChargingWnd,RandomCraftWnd,ShopLcoinWnd,ShopLcoinCraftWnd,ItemBlessWnd,PetExtractWnd,SuppressDrawWnd,BlackCouponWnd,ClanShopWndClassic,") $ "HennaEnchantWnd,HennaMenuWnd,HennaDyeEnchantWnd,ItemMultiEnchantWnd,ItemEnchantWnd,WorldExchangeBuyWnd,WorldExchangeRegiWnd,HeroBookCraftChargingWnd,GiftInventoryWnd,") $ "FestivalRankingWnd,FestivalRankingBonusWnd,UniqueGachaWarehouseWnd,VirtualItemWnd,") $ "MultiSellItemExchangeWnd,RelicSummonWnd,HennaEngraveWndLive,BreakEquipmentRepairWnd,CustomizingWnd");
	Split(ItemRelationWindowString, ",", ItemRelationWindowArrayStr);
	if(IsUseRenewalSkillWnd())
	{
		ItemRelationWindowArrayStr[ItemRelationWindowArrayStr.Length] = "SkillEnchantWnd";
	}
	PrivateShopWndScript = PrivateShopWnd(GetScript("PrivateShopWnd"));
	RefineryWndScript = RefineryWnd(GetScript("RefineryWnd"));
	UnrefineryWndScript = UnrefineryWnd(GetScript("UnrefineryWnd"));
	UnrefineryWndScript = UnrefineryWnd(GetScript("UnrefineryWnd"));
	AttributeRemoveWndScript = AttributeRemoveWnd(GetScript("AttributeRemoveWnd"));
	AttributeEnchantWndScript = AttributeEnchantWnd(GetScript("AttributeEnchantWnd"));
	CrystallizationWndScript = CrystallizationWnd(GetScript("CrystallizationWnd"));
	ItemEnchantWndScript = ItemEnchantWnd(GetScript("ItemEnchantWnd"));
	ItemLookChangeWndScript = ItemLookChangeWnd(GetScript("ItemLookChangeWnd"));
	MultiSellWndScript = MultiSellWnd(GetScript("MultiSellWnd"));
	WarehouseWndScript = WarehouseWnd(GetScript("WarehouseWnd"));
	TradeWndScript = TradeWnd(GetScript("TradeWnd"));
	DeliverWndScript = DeliverWnd(GetScript("DeliverWnd"));
	ItemAttributeChangeWndScript = ItemAttributeChangeWnd(GetScript("ItemAttributeChangeWnd"));
	return;
}

function initColor()
{
	BrightWhite.R = 230;
	BrightWhite.G = 230;
	BrightWhite.B = 230;
	BrightWhite.A = 255;
	White.R = 200;
	White.G = 200;
	White.B = 200;
	White.A = 255;
	Yellow.R = 235;
	Yellow.G = 205;
	Yellow.B = 0;
	Yellow.A = 255;
	Blue.R = 102;
	Blue.G = 150;
	Blue.B = 253;
	Blue.A = 255;
	Gold.R = 176;
	Gold.G = 153;
	Gold.B = 121;
	Gold.A = 255;
	Gray.R = 120;
	Gray.G = 120;
	Gray.B = 120;
	Gray.A = 255;
	HotPink.R = 195;
	HotPink.G = 46;
	HotPink.B = 97;
	HotPink.A = 255;
	PowderPink.R = 255;
	PowderPink.G = 192;
	PowderPink.B = 203;
	PowderPink.A = 255;
	Token0.R = 211;
	Token0.G = 192;
	Token0.B = 82;
	Token0.A = 255;
	Token1.R = 170;
	Token1.G = 152;
	Token1.B = 120;
	Token1.A = 255;
	Token2.R = 168;
	Token2.G = 103;
	Token2.B = 53;
	Token2.A = 255;
	Token3.R = 175;
	Token3.G = 42;
	Token3.B = 39;
	Token3.A = 255;
	Yellow03.R = 255;
	Yellow03.G = 204;
	Yellow03.B = 0;
	Yellow03.A = 255;
	ColorDesc.R = 175;
	ColorDesc.G = 185;
	ColorDesc.B = 205;
	ColorDesc.A = 255;
	ColorYellow.R = 255;
	ColorYellow.G = 221;
	ColorYellow.B = 102;
	ColorYellow.A = 255;
	ColorGray.R = 182;
	ColorGray.G = 182;
	ColorGray.B = 182;
	ColorGray.A = 255;
	ColorGold.R = 176;
	ColorGold.G = 153;
	ColorGold.B = 121;
	ColorGold.A = 255;
	ColorMinimapFont.R = 181;
	ColorMinimapFont.G = 181;
	ColorMinimapFont.B = 170;
	ColorMinimapFont.A = 255;
	ColorLightBrown.R = 238;
	ColorLightBrown.G = 170;
	ColorLightBrown.B = 34;
	ColorLightBrown.A = 255;
	DarkGray.R = 68;
	DarkGray.G = 68;
	DarkGray.B = 68;
	DarkGray.A = 255;
	BWhite.R = 211;
	BWhite.G = 211;
	BWhite.B = 211;
	BWhite.A = 255;
	DRed.R = 255;
	DRed.G = 102;
	DRed.B = 102;
	DRed.A = 255;
	Red.R = 255;
	Red.G = 50;
	Red.B = 0;
	Red.A = 255;
	Red1.R = 255;
	Red1.G = 0;
	Red1.B = 0;
	Red1.A = 255;
	Red2.R = 255;
	Red2.G = 102;
	Red2.B = 102;
	Red2.A = 255;
	Red3.R = 255;
	Red3.G = 153;
	Red3.B = 153;
	Red3.A = 255;
	VIOLET01.R = 238;
	VIOLET01.G = 170;
	VIOLET01.B = 255;
	VIOLET01.A = 255;
	VIOLET02.R = 136;
	VIOLET02.G = 136;
	VIOLET02.B = 255;
	VIOLET02.A = 255;
	PKNameColor.R = 230;
	PKNameColor.G = 100;
	PKNameColor.B = 255;
	PKNameColor.A = 255;
	BLUE01.R = 85;
	BLUE01.G = 153;
	BLUE01.B = 255;
	BLUE01.A = 255;
	Green.R = 119;
	Green.G = 255;
	Green.B = 153;
	Green.A = 255;
	CAPRI.R = 0;
	CAPRI.G = 170;
	CAPRI.B = 255;
	CAPRI.A = 255;
	MintGreen.R = 119;
	MintGreen.G = 255;
	MintGreen.B = 153;
	MintGreen.A = 255;
	return;
}

function TreeInsertRootNode(string treeName, string NodeName, string parentname, optional int OffsetX, optional int OffsetY)
{
	local XMLTreeNodeInfo infNode;

	infNode.strName = NodeName;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNode(treeName, parentname, infNode);
	return;
}

function TreeHandleInsertRootNode(TreeHandle m_UITree, string NodeName, string parentname, optional int OffsetX, optional int OffsetY)
{
	local XMLTreeNodeInfo infNode;

	infNode.strName = NodeName;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	m_UITree.InsertNode(parentname, infNode);
	return;
}

function TreeInsertExpandBtnNode(string treeName, string NodeName, string parentname, optional int nTexBtnWidth, optional int nTexBtnHeight, optional string strTexBtnExpand, optional string strTexBtnExpand_Over, optional string strTexBtnCollapse, optional string strTexBtnCollapse_Over, optional int OffsetX, optional int OffsetY, optional bool bUseStrTexExpandedLeft)
{
	local XMLTreeNodeInfo infNode;

	if((nTexBtnWidth == 0))
	{
		nTexBtnWidth = 15;
	}
	if((nTexBtnHeight == 0))
	{
		nTexBtnHeight = 15;
	}
	if((strTexBtnExpand == ""))
	{
		strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndPlusBtn";
	}
	if((strTexBtnExpand_Over == ""))
	{
		strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndPlusBtn_over";
	}
	if((strTexBtnCollapse == ""))
	{
		strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndMinusBtn";
	}
	if((strTexBtnCollapse_Over == ""))
	{
		strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndMinusBtn_over";
	}
	infNode.strName = NodeName;
	infNode.bShowButton = 1;
	infNode.nTexBtnWidth = nTexBtnWidth;
	infNode.nTexBtnHeight = nTexBtnHeight;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.strTexBtnExpand = strTexBtnExpand;
	infNode.strTexBtnExpand_Over = strTexBtnExpand_Over;
	infNode.strTexBtnCollapse = strTexBtnCollapse;
	infNode.strTexBtnCollapse_Over = strTexBtnCollapse_Over;
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNode(treeName, parentname, infNode);
	return;
}

function TreeHandleInsertExpandBtnNode(TreeHandle m_UITree, string NodeName, string parentname, optional int nTexBtnWidth, optional int nTexBtnHeight, optional string strTexBtnExpand, optional string strTexBtnExpand_Over, optional string strTexBtnCollapse, optional string strTexBtnCollapse_Over, optional int OffsetX, optional int OffsetY, optional bool bUseStrTexExpandedLeft)
{
	local XMLTreeNodeInfo infNode;

	if((nTexBtnWidth == 0))
	{
		nTexBtnWidth = 15;
	}
	if((nTexBtnHeight == 0))
	{
		nTexBtnHeight = 15;
	}
	if((strTexBtnExpand == ""))
	{
		strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndPlusBtn";
	}
	if((strTexBtnExpand_Over == ""))
	{
		strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndPlusBtn_over";
	}
	if((strTexBtnCollapse == ""))
	{
		strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndMinusBtn";
	}
	if((strTexBtnCollapse_Over == ""))
	{
		strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndMinusBtn_over";
	}
	infNode.strName = NodeName;
	infNode.bShowButton = 1;
	infNode.nTexBtnWidth = nTexBtnWidth;
	infNode.nTexBtnHeight = nTexBtnHeight;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.strTexBtnExpand = strTexBtnExpand;
	infNode.strTexBtnExpand_Over = strTexBtnExpand_Over;
	infNode.strTexBtnCollapse = strTexBtnCollapse;
	infNode.strTexBtnCollapse_Over = strTexBtnCollapse_Over;
	m_UITree.InsertNode(parentname, infNode);
	return;
}

function string TreeInsertItemTooltipSimpleNode(string treeName, string NodeName, string parentname, int nTexExpandedOffSetX, int nTexExpandedOffSetY, int nTexExpandedHeight, int nTexExpandedRightWidth, int nTexExpandedLeftUWidth, int nTexExpandedLeftUHeight, optional string TooltipSimpleText, optional string strTexExpandedLeft, optional int OffsetX, optional int OffsetY)
{
	local XMLTreeNodeInfo infNode;

	if((TooltipSimpleText != ""))
	{
		infNode.ToolTip = MakeTooltipSimpleText(TooltipSimpleText);
	}
	if((strTexExpandedLeft == ""))
	{
		strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	}
	infNode.strName = NodeName;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.bFollowCursor = true;
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;
	infNode.nTexExpandedHeight = nTexExpandedHeight;
	infNode.nTexExpandedRightWidth = nTexExpandedRightWidth;
	infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth;
	infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	infNode.strTexExpandedLeft = strTexExpandedLeft;
	return Class'NWindow.UIAPI_TREECTRL'.static.InsertNode(treeName, parentname, infNode);
}

function string TreeInsertItemTooltipNode(string treeName, string NodeName, string parentname, int nTexExpandedOffSetX, int nTexExpandedOffSetY, int nTexExpandedHeight, int nTexExpandedRightWidth, int nTexExpandedLeftUWidth, int nTexExpandedLeftUHeight, CustomTooltip tooltipText, optional string strTexExpandedLeft, optional int OffsetX, optional int OffsetY)
{
	local XMLTreeNodeInfo infNode;

	if((strTexExpandedLeft == ""))
	{
		strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	}
	infNode.strName = NodeName;
	infNode.ToolTip = tooltipText;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.bFollowCursor = true;
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;
	infNode.nTexExpandedHeight = nTexExpandedHeight;
	infNode.nTexExpandedRightWidth = nTexExpandedRightWidth;
	infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth;
	infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	infNode.strTexExpandedLeft = strTexExpandedLeft;
	return Class'NWindow.UIAPI_TREECTRL'.static.InsertNode(treeName, parentname, infNode);
}

function string TreeInsertItemNode(string treeName, string NodeName, string parentname, optional bool bFollowCursor, optional int OffsetX, optional int OffsetY)
{
	local XMLTreeNodeInfo infNode;

	infNode.strName = NodeName;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.bFollowCursor = bFollowCursor;
	return Class'NWindow.UIAPI_TREECTRL'.static.InsertNode(treeName, parentname, infNode);
}

function TreeInsertTextNodeItem(string treeName, string NodeName, string ItemName, optional int OffsetX, optional int OffsetY, optional ETreeItemTextType E, optional bool oneline, optional bool bLineBreak, optional int Reserved)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = OffsetX;
	infNodeItem.nOffSetY = OffsetY;
	infNodeItem = setTreeTextColor(E, infNodeItem);
	if((Reserved != 0))
	{
		infNodeItem.nReserved = Reserved;
	}
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem(treeName, NodeName, infNodeItem);
	return;
}

function TreeHandleInsertTextNodeItem(TreeHandle m_UITree, string NodeName, string ItemName, optional int OffsetX, optional int OffsetY, optional ETreeItemTextType E, optional bool oneline, optional bool bLineBreak, optional int Reserved)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = OffsetX;
	infNodeItem.nOffSetY = OffsetY;
	infNodeItem = setTreeTextColor(E, infNodeItem);
	if((Reserved != 0))
	{
		infNodeItem.nReserved = Reserved;
	}
	m_UITree.InsertNodeItem(NodeName, infNodeItem);
	return;
}

function TreeInsertTextMultiNodeItem(string treeName, string NodeName, string ItemName, optional int OffsetX, optional int OffsetY, optional int MaxHeight, optional ETreeItemTextType E, optional bool bLineBreak, optional int Reserved, optional int reserved2)
{
	local XMLTreeNodeItemInfo infNodeItem;

	if((MaxHeight == 0))
	{
		MaxHeight = 38;
	}
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.t_bDrawOneLine = false;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = OffsetX;
	infNodeItem.nOffSetY = OffsetY;
	infNodeItem.t_nMaxHeight = MaxHeight;
	infNodeItem.t_vAlign = TVA_Middle;
	infNodeItem = setTreeTextColor(E, infNodeItem);
	if((Reserved != 0))
	{
		infNodeItem.nReserved = Reserved;
	}
	infNodeItem.nReserved2 = 0;
	if((reserved2 > 0))
	{
		infNodeItem.nReserved2 = reserved2;
	}
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem(treeName, NodeName, infNodeItem);
	return;
}

function XMLTreeNodeItemInfo setTreeTextColor(ETreeItemTextType E, XMLTreeNodeItemInfo infNodeItem)
{
	switch(E)
	{
		case COLOR_DEFAULT:
			infNodeItem.t_color.R = 255;
			infNodeItem.t_color.G = 255;
			infNodeItem.t_color.B = 255;
			infNodeItem.t_color.A = 255;
			break;
		case COLOR_GRAY:
			infNodeItem.t_color.R = 163;
			infNodeItem.t_color.G = 163;
			infNodeItem.t_color.B = 163;
			infNodeItem.t_color.A = 255;
			break;
		case COLOR_GOLD:
			infNodeItem.t_color.R = 176;
			infNodeItem.t_color.G = 155;
			infNodeItem.t_color.B = 121;
			infNodeItem.t_color.A = 255;
			break;
		case COLOR_RED:
			infNodeItem.t_color.R = 250;
			infNodeItem.t_color.G = 50;
			infNodeItem.t_color.B = 0;
			infNodeItem.t_color.A = 255;
			break;
		case COLOR_YELLOW:
			infNodeItem.t_color.R = 240;
			infNodeItem.t_color.G = 214;
			infNodeItem.t_color.B = 54;
			infNodeItem.t_color.A = 255;
			break;
		case COLOR_DESC:
			infNodeItem.t_color.R = 175;
			infNodeItem.t_color.G = 185;
			infNodeItem.t_color.B = 205;
			infNodeItem.t_color.A = 255;
			break;
		case COLOR_BLUE:
			infNodeItem.t_color.R = 102;
			infNodeItem.t_color.G = 150;
			infNodeItem.t_color.B = 253;
			infNodeItem.t_color.A = 255;
			break;
		case COLOR_BRIGHT_BLUE:
			infNodeItem.t_color.R = 85;
			infNodeItem.t_color.G = 170;
			infNodeItem.t_color.B = 255;
			infNodeItem.t_color.A = 255;
			break;
		case Token0:
			infNodeItem.t_color.R = 211;
			infNodeItem.t_color.G = 192;
			infNodeItem.t_color.B = 82;
			infNodeItem.t_color.A = 255;
			break;
		case Token1:
			infNodeItem.t_color.R = 170;
			infNodeItem.t_color.G = 152;
			infNodeItem.t_color.B = 120;
			infNodeItem.t_color.A = 255;
			break;
		case Token2:
			infNodeItem.t_color.R = 168;
			infNodeItem.t_color.G = 103;
			infNodeItem.t_color.B = 53;
			infNodeItem.t_color.A = 255;
			break;
		case Token3:
			infNodeItem.t_color.R = 175;
			infNodeItem.t_color.G = 42;
			infNodeItem.t_color.B = 39;
			infNodeItem.t_color.A = 255;
			break;
		case Yellow03:
			infNodeItem.t_color.R = 255;
			infNodeItem.t_color.G = 204;
			infNodeItem.t_color.B = 0;
			infNodeItem.t_color.A = 255;
			break;
		default:
			break;
	}
	return infNodeItem;
}

function TreeInsertTextureNodeItem(string treeName, string NodeName, string TextureName, int TextureWidth, int TextureHeight, optional int OffsetX, optional int OffsetY, optional bool oneline, optional bool bLineBreak, optional int TextureUHeight)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = OffsetX;
	infNodeItem.nOffSetY = OffsetY;
	infNodeItem.u_nTextureUHeight = TextureUHeight;
	infNodeItem.u_nTextureWidth = TextureWidth;
	infNodeItem.u_nTextureHeight = TextureHeight;
	infNodeItem.u_strTexture = TextureName;
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem(treeName, NodeName, infNodeItem);
	return;
}

function TreeHandleInsertTextureNodeItem(TreeHandle m_UITree, string NodeName, string TextureName, int TextureWidth, int TextureHeight, optional int OffsetX, optional int OffsetY, optional bool oneline, optional bool bLineBreak, optional int TextureUHeight)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = OffsetX;
	infNodeItem.nOffSetY = OffsetY;
	infNodeItem.u_nTextureUHeight = TextureUHeight;
	infNodeItem.u_nTextureWidth = TextureWidth;
	infNodeItem.u_nTextureHeight = TextureHeight;
	infNodeItem.u_strTexture = TextureName;
	m_UITree.InsertNodeItem(NodeName, infNodeItem);
	return;
}

function TreeInsertBlankNodeItem(string treeName, string NodeName)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.bStopMouseFocus = true;
	infNodeItem.b_nHeight = 4;
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem(treeName, NodeName, infNodeItem);
	return;
}

function TreeClear(string Str)
{
	Class'NWindow.UIAPI_TREECTRL'.static.Clear(Str);
	return;
}

function setCustomTooltip(CustomTooltip t)
{
	tooltipText = t;
	return;
}

function CustomTooltip getCustomToolTip()
{
	return tooltipText;
}

function ToopTipMinWidth(int Width)
{
	tooltipText.MinimumWidth = Width;
	return;
}

function ToopTipInsertText(string Text, optional bool oneline, optional bool bLineBreak, optional ETooltipTextType E, optional int OffsetX, optional int OffsetY)
{
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	GetItemTextSectionInfos(Text, FullText, TextInfos);
	if((Len(Text) == 0))
	{
		return;
	}
	StartItem();
	if((TextInfos.Length > 0))
	{
		Text = FullText;
		toolTipInfo.t_SectionList = TextInfos;
	}
	toolTipInfo.eType = DIT_TEXT;
	toolTipInfo.t_bDrawOneLine = oneline;
	toolTipInfo.bLineBreak = bLineBreak;
	toolTipInfo.t_strText = Text;
	toolTipInfo.nOffSetX = OffsetX;
	toolTipInfo.nOffSetY = OffsetY;
	toolTipInfo = setToopTipTextColor(E, toolTipInfo);
	EndItem();
	return;
}

function ToopTipInsertColorText(string Text, optional bool oneline, optional bool bLineBreak, optional Color C, optional int OffsetX, optional int OffsetY)
{
	if((Len(Text) == 0))
	{
		return;
	}
	StartItem();
	toolTipInfo.eType = DIT_TEXT;
	toolTipInfo.t_bDrawOneLine = oneline;
	toolTipInfo.bLineBreak = bLineBreak;
	toolTipInfo.t_strText = Text;
	toolTipInfo.nOffSetX = OffsetX;
	toolTipInfo.nOffSetY = OffsetY;
	toolTipInfo.t_color = C;
	EndItem();
	return;
}

function ToopTipInsertTitleContents(string Title, string Text, int R, int G, int B, optional bool oneline, optional bool bLineBreak, optional bool iamFirst, optional int OffsetX, optional int OffsetY)
{
	if((Len(Text) == 0))
	{
		return;
	}
	if((Title != ""))
	{
		StartItem();
		toolTipInfo.eType = DIT_TEXT;
		toolTipInfo.t_bDrawOneLine = true;
		toolTipInfo.bLineBreak = true;
		toolTipInfo.t_color.R = 163;
		toolTipInfo.t_color.G = 163;
		toolTipInfo.t_color.B = 163;
		toolTipInfo.t_color.A = 255;
		if(!iamFirst)
		{
			toolTipInfo.nOffSetY = 6;
		}
		toolTipInfo.t_strText = Title;
		EndItem();
	}
	if((Text != ""))
	{
		if((Title != ""))
		{
			StartItem();
			toolTipInfo.eType = DIT_TEXT;
			toolTipInfo.t_bDrawOneLine = true;
			toolTipInfo.t_color.R = 163;
			toolTipInfo.t_color.G = 163;
			toolTipInfo.t_color.B = 163;
			toolTipInfo.t_color.A = 255;
			if(!iamFirst)
			{
				toolTipInfo.nOffSetY = 6;
			}
			toolTipInfo.t_strText = " : ";
			EndItem();
		}
		StartItem();
		toolTipInfo.eType = DIT_TEXT;
		toolTipInfo.t_bDrawOneLine = true;
		if((Title == ""))
		{
			toolTipInfo.bLineBreak = true;
		}
		toolTipInfo.t_color.R = byte(R);
		toolTipInfo.t_color.G = byte(G);
		toolTipInfo.t_color.B = byte(B);
		toolTipInfo.t_color.A = 255;
		toolTipInfo.t_strText = Text;
		if(!iamFirst)
		{
			toolTipInfo.nOffSetY = 6;
		}
		EndItem();
	}
	return;
}

function DrawItemInfo setToopTipTextColor(ETooltipTextType E, DrawItemInfo Info)
{
	switch(E)
	{
		case COLOR_DEFAULT:
			Info.t_color.R = 255;
			Info.t_color.G = 255;
			Info.t_color.B = 255;
			Info.t_color.A = 255;
			break;
		case COLOR_GRAY:
			Info.t_color.R = 163;
			Info.t_color.G = 163;
			Info.t_color.B = 163;
			Info.t_color.A = 255;
			break;
		case COLOR_GOLD:
			Info.t_color.R = 176;
			Info.t_color.G = 155;
			Info.t_color.B = 121;
			Info.t_color.A = 255;
			break;
		case COLOR_YELLOW:
			Info.t_color.R = 240;
			Info.t_color.G = 214;
			Info.t_color.B = 54;
			Info.t_color.A = 255;
			break;
		case COLOR_YELLOW03:
			Info.t_color.R = 255;
			Info.t_color.G = 204;
			Info.t_color.B = 0;
			Info.t_color.A = 255;
			break;
		case COLOR_RED:
			Info.t_color.R = 250;
			Info.t_color.G = 50;
			Info.t_color.B = 0;
			Info.t_color.A = 255;
			break;
		case COLOR_BLUE:
			Info.t_color.R = 100;
			Info.t_color.G = 100;
			Info.t_color.B = 250;
			Info.t_color.A = 255;
			break;
		case COLOR_ARTIFACT:
			Info.t_color.R = 130;
			Info.t_color.G = 200;
			Info.t_color.B = 240;
			Info.t_color.A = 255;
			break;
		default:
			break;
	}
	return Info;
}

function TwoWordCombineColon(string word1, string word2, optional ETooltipTextType E1, optional ETooltipTextType E2, optional bool bLineBreak, optional int OffsetX, optional int OffsetY)
{
	ToopTipInsertText(word1, false, bLineBreak, E1, OffsetX, OffsetY);
	ToopTipInsertText(" : ", false, false, COLOR_GRAY, OffsetX, OffsetY);
	ToopTipInsertText(word2, false, false, E2, OffsetX, OffsetY);
	return;
}

function ToopTipInsertTexture(string Texture, optional bool oneline, optional bool bLineBreak, optional int OffsetX, optional int OffsetY)
{
	StartItem();
	toolTipInfo.eType = DIT_TEXTURE;
	toolTipInfo.t_bDrawOneLine = oneline;
	toolTipInfo.bLineBreak = bLineBreak;
	toolTipInfo.u_nTextureWidth = 16;
	toolTipInfo.u_nTextureHeight = 16;
	toolTipInfo.nOffSetX = OffsetX;
	toolTipInfo.nOffSetY = OffsetY;
	toolTipInfo.u_nTextureUWidth = 32;
	toolTipInfo.u_nTextureUHeight = 32;
	toolTipInfo.u_strTexture = Texture;
	EndItem();
	return;
}

function TooltipInsertTextureDetail(string Texture, int Width, int Height, int UWidth, int UHeight, optional bool oneline, optional bool bLineBreak, optional int OffsetX, optional int OffsetY)
{
	StartItem();
	toolTipInfo.eType = DIT_TEXTURE;
	toolTipInfo.t_bDrawOneLine = oneline;
	toolTipInfo.bLineBreak = bLineBreak;
	toolTipInfo.u_nTextureWidth = Width;
	toolTipInfo.u_nTextureHeight = Height;
	toolTipInfo.nOffSetX = OffsetX;
	toolTipInfo.nOffSetY = OffsetY;
	toolTipInfo.u_nTextureUWidth = UWidth;
	toolTipInfo.u_nTextureUHeight = UHeight;
	toolTipInfo.u_strTexture = Texture;
	EndItem();
	return;
}

function TooltipInsertItemBlank(int Height)
{
	StartItem();
	toolTipInfo.eType = DIT_BLANK;
	toolTipInfo.b_nHeight = Height;
	EndItem();
	return;
}

function TooltipInsertItemLine()
{
	StartItem();
	toolTipInfo.eType = DIT_SPLITLINE;
	toolTipInfo.u_nTextureWidth = tooltipText.MinimumWidth;
	toolTipInfo.u_nTextureHeight = 1;
	toolTipInfo.u_strTexture = "L2ui_ch3.tooltip_line";
	EndItem();
	return;
}

function StartItem()
{
	local DrawItemInfo infoClear;

	toolTipInfo = infoClear;
	return;
}

function EndItem()
{
	tooltipText.DrawList.Length = (tooltipText.DrawList.Length + 1);
	tooltipText.DrawList[(tooltipText.DrawList.Length - 1)] = toolTipInfo;
	return;
}

function string TimeNumberToString(int Time)
{
	local int Min, Sec;
	local string strTime, SecString;

	Min = (Time / 60);
	Sec = int((float(Time) % 60.0000000));
	SecString = string(Sec);
	if((Sec < 10))
	{
		SecString = ("0" $ string(Sec));
	}
	if((Time > 60))
	{
		if((Time >= 600))
		{
			strTime = ((string(Min) $ ":") $ SecString);
		}
		else
		{
			strTime = ((("0" $ string(Min)) $ ":") $ SecString);
		}
	}
	else
	{
		strTime = ("00:" $ SecString);
	}
	return strTime;
}

function string TimeNumberToString2(int Time)
{
	local int Min, Sec, Hour;

	Min = (Time / 60);
	Hour = (Min / 60);
	Min = int((float(Min) % 60.0000000));
	Sec = int((float(Time) % 60.0000000));
	return ((((makeZeroString(2, INT64(Hour)) $ ":") $ makeZeroString(2, INT64(Min))) $ ":") $ makeZeroString(2, INT64(Sec)));
}

function string TimeNumberToHangulHourMin(int Time)
{
	local int Hour, Min, Sec;
	local string strMin;

	Min = (Time / 60);
	Hour = (Min / 60);
	Min = int((float(Min) % 60.0000000));
	Sec = int((float(Time) % 60.0000000));
	strMin = string(Min);
	if((Min < 10))
	{
		strMin = ("0" $ string(Min));
	}
	return MakeFullSystemMsg(GetSystemMessage(3304), string(Hour), strMin);
}

function string MakeTimeString(float Time1, optional float Time2)
{
	local int i;
	local float Time;
	local string strTime;
	local array<string> arrSplit;

	if((Time2 != 0.0000000))
	{
		Time = (Time1 + Time2);
	}
	else
	{
		Time = Time1;
	}
	strTime = string(Time);
	i = 0;
	while((i < Len(strTime)))
	{
		if((Right(strTime, 1) == "0"))
		{
			strTime = Left(strTime, (Len(strTime) - 1));
			i++;
			continue;
		}
		if((Right(strTime, 1) == "."))
		{
			break;
		}
		i++;
	}
	Split(strTime, ".", arrSplit);
	if((Len(arrSplit[1]) == 0))
	{
		return (arrSplit[0] $ GetSystemString(2001));
	}
	return (strTime $ GetSystemString(2001));
}

function string MakeTimeString1(float Time1, optional float Time2)
{
	local int i;
	local float Time;
	local string strTime;
	local array<string> arrSplit;

	if((Time2 != 0.0000000))
	{
		Time = (Time1 + Time2);
	}
	else
	{
		Time = Time1;
	}
	strTime = string(Time);
	i = 0;
	while((i < Len(strTime)))
	{
		if((Right(strTime, 1) == "0"))
		{
			strTime = Left(strTime, (Len(strTime) - 1));
			i++;
			continue;
		}
		if((Right(strTime, 1) == "."))
		{
			break;
		}
		i++;
	}
	Split(strTime, ".", arrSplit);
	if((Len(arrSplit[1]) == 0))
	{
		return arrSplit[0];
	}
	return strTime;
}

function string cutFloat(float Probability)
{
	local string probabilityStr;
	local array<string> arrSplit;

	Split(string(Probability), ".", arrSplit);
	if((Probability >= 100.0000000))
	{
		probabilityStr = "100%";
	}
	else if((arrSplit.Length == 2))
	{
		if((Len(arrSplit[1]) >= 2))
		{
			probabilityStr = (((arrSplit[0] $ ".") $ Mid(arrSplit[1], 0, 2)) $ "%");
		}
		else
		{
			probabilityStr = (string(Probability) $ "%");
		}
	}
	else
	{
		probabilityStr = (string(Probability) $ "%");
	}
	return probabilityStr;
}

function string cutFloat2(float Probability)
{
	local string probabilityStr;
	local array<string> arrSplit;

	Split(string(Probability), ".", arrSplit);
	if((Probability >= 100.0000000))
	{
		probabilityStr = "100%";
	}
	else if((arrSplit.Length == 2))
	{
		if((Len(arrSplit[1]) >= 2))
		{
			probabilityStr = (((arrSplit[0] $ ".") $ Mid(arrSplit[1], 0, 1)) $ "%");
		}
		else
		{
			probabilityStr = (string(Probability) $ "%");
		}
	}
	else
	{
		probabilityStr = (string(Probability) $ "%");
	}
	return probabilityStr;
}

function string cutFloat3(float Probability)
{
	local string probabilityStr;
	local array<string> arrSplit;

	Split(string(Probability), ".", arrSplit);
	if((arrSplit.Length == 2))
	{
		if((Len(arrSplit[1]) >= 2))
		{
			probabilityStr = (((arrSplit[0] $ ".") $ Mid(arrSplit[1], 0, 2)) $ "%");
		}
		else
		{
			probabilityStr = (string(Probability) $ "%");
		}
	}
	else
	{
		probabilityStr = (string(Probability) $ "%");
	}
	return probabilityStr;
}

function string CutFloatIntByString(string Probability)
{
	local int i;
	local array<string> arrSplit;

	if((float(int(Probability)) < float(Probability)))
	{
		Split(Probability, ".", arrSplit);
		i = Len(arrSplit[1]);
		while((i > 0))
		{
			if((Mid(arrSplit[1], (i - 1), 1) != "0"))
			{
				arrSplit[1] = Left(arrSplit[1], i);
				break;
			}
			i--;
		}
		return (((arrSplit[0] $ ".") $ arrSplit[1]) $ "%");
	}
	return (string(int(Probability)) $ "%");
}

function string CutFloatDecimalPlaces(float Probability, optional int decimalplaces, optional bool noPercentString)
{
	local string probabilityStr;
	local int i, StrLen, cutLine, decimalInt, probabilityInt;
	local float tmpProbability;
	local array<string> ints;
	local string percentStr;

	if(noPercentString)
	{
		percentStr = "";
	}
	else
	{
		percentStr = "%";
	}
	if((decimalplaces == 0))
	{
		decimalplaces = 3;
	}
	if((float(int(Probability)) < Probability))
	{
		decimalInt = ExpInt(10, decimalplaces);
		tmpProbability = (Probability * float(decimalInt));
		Split(string(tmpProbability), ".", ints);
		probabilityInt = (int(ints[0]) - (int(Probability) * decimalInt));
		probabilityStr = string(probabilityInt);
		StrLen = Len(probabilityStr);
		i = 0;
		while((i < (decimalplaces - StrLen)))
		{
			probabilityStr = ("0" $ probabilityStr);
			i++;
		}
		i = 0;
		while((i < decimalplaces))
		{
			cutLine = (decimalplaces - i);
			if((Mid(probabilityStr, (cutLine - 1), 1) != "0"))
			{
				return (((string(int(Probability)) $ ".") $ Left(probabilityStr, cutLine)) $ percentStr);
			}
			i++;
		}
		return (((string(int(Probability)) $ ".") $ probabilityStr) $ percentStr);
	}
	return (string(int(Probability)) $ percentStr);
}

function test(int A, int B, optional int X, optional string Str)
{
	if((X == 0))
	{
		Debug("영이래!");  // EN: it's zero!
	}
	if((Str == ""))
	{
		Debug("스트링 꽝!");  // EN: string bust!
	}
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	switch(functionName)
	{
		case "handleDialogBox":
			handleDialogBox(param);
			break;
		case "BrintToFront":
			Class'NWindow.UIAPI_WINDOW'.static.BringToFront(param);
			break;
		case "MoveTo":
			handleMoveTo(param);
			break;
		default:
			break;
	}
	return;
}

function handleMoveTo(string param)
{
	local string WindowName;
	local int X, Y, targetOffsetX, targetOffsetY, AnchorPoint;
	local Rect tempRect;

	ParseString(param, "windowName", WindowName);
	if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(WindowName))
	{
		return;
	}
	ParseInt(param, "x", X);
	ParseInt(param, "y", Y);
	ParseInt(param, "anchorPoint", AnchorPoint);
	tempRect = GetWindowHandle(WindowName).GetRect();
	targetOffsetX = 0;
	targetOffsetY = 0;
	switch(AnchorPoint)
	{
		case 0:
			break;
		case 1:
			break;
		case 2:
			targetOffsetX = (-tempRect.nWidth / 2);
			break;
		case 3:
			targetOffsetX = -tempRect.nWidth;
			break;
		case 4:
			targetOffsetY = (-tempRect.nHeight / 2);
			break;
		case 5:
			targetOffsetX = (-tempRect.nWidth / 2);
			targetOffsetY = (-tempRect.nHeight / 2);
			break;
		case 6:
			targetOffsetX = -tempRect.nWidth;
			targetOffsetY = (-tempRect.nHeight / 2);
			break;
		case 7:
			targetOffsetY = -tempRect.nHeight;
			break;
		case 8:
			targetOffsetX = (-tempRect.nWidth / 2);
			targetOffsetY = -tempRect.nHeight;
			break;
		case 9:
			targetOffsetX = -tempRect.nWidth;
			targetOffsetY = -tempRect.nHeight;
			break;
		default:
			break;
	}
	GetWindowHandle(WindowName).MoveTo((X + targetOffsetX), (Y + targetOffsetY));
	return;
}

function handleDialogBox(string param)
{
	local string functionName;

	ParseString(param, "functionName", functionName);
	switch(functionName)
	{
		case "DialogShow":
			HandleDialogShow(param);
			break;
		case "DialogSetButtonName":
			handleDialogSetButtonName(param);
			break;
		case "DialogSetButtonWidthSize":
			handleDialogSetButtonWidthSize(param);
			break;
		case "DialogShowWithResize":
			handleDialogShowWithResize(param);
			break;
		case "DialogHide":
			DialogHide();
			break;
		case "DialogSetDefaultOK":
			DialogSetDefaultOK();
			break;
		case "DialogSetDefaultCancle":
			DialogSetDefaultCancle();
			break;
		case "DialogSetID":
			handleDialogSetID(param);
			break;
		case "DialogSetEditType":
			handleDialogSetEditType(param);
			break;
		case "DialogSetString":
			handleDialogSetString(param);
			break;
		case "DialogGetReservedInt2":
			handleDialogGetReservedInt2();
			break;
		case "DialogSetParamInt64":
			handleDialogSetParamInt64(param);
			break;
		case "DialogSetReservedInt":
			handleDialogSetReservedInt(param);
			break;
		case "DialogSetReservedInt2":
			handleDialogSetReservedInt2(param);
			break;
		case "DialogSetReservedInt3":
			handleDialogSetReservedInt3(param);
			break;
		case "DialogSetEditBoxMaxLength":
			handleDialogSetEditBoxMaxLength(param);
			break;
		case "DialogSetIconTexture":
			handleDialogSetIconTexture(param);
			break;
		case "DialogSetCancelD":
			handleDialogSetCancelD(param);
			break;
		default:
			break;
	}
	return;
}

function handleDialogSetCancelD(string param)
{
	local int targetCancelDialogID;

	ParseInt(param, "targetCancelDialogID", targetCancelDialogID);
	DialogSetCancelD(targetCancelDialogID);
	return;
}

function handleDialogSetIconTexture(string param)
{
	local string iconTextureStr;

	ParseString(param, "iconTextureStr", iconTextureStr);
	DialogSetIconTexture(iconTextureStr);
	return;
}

function handleDialogSetEditBoxMaxLength(string param)
{
	local int MaxLength;

	ParseInt(param, "maxLength", MaxLength);
	DialogSetEditBoxMaxLength(MaxLength);
	return;
}

function handleDialogGetReservedInt2()
{
	m_reservedInt2 = string(DialogGetReservedInt2());
	return;
}

function handleDialogSetReservedInt3(string param)
{
	local int Value;

	ParseInt(param, "value", Value);
	DialogSetReservedInt3(Value);
	return;
}

function handleDialogSetReservedInt2(string param)
{
	local INT64 Value;

	ParseINT64(param, "value", Value);
	DialogSetReservedInt2(Value);
	return;
}

function handleDialogSetReservedInt(string param)
{
	local int Value;

	ParseInt(param, "value", Value);
	DialogSetReservedInt(Value);
	return;
}

function handleDialogSetParamInt64(string param)
{
	local INT64 Value;

	ParseINT64(param, "param", Value);
	DialogSetParamInt64(Value);
	return;
}

function handleDialogSetString(string param)
{
	local string strInput;

	ParseString(param, "strInput", strInput);
	DialogSetString(strInput);
	return;
}

function handleDialogSetEditType(string param)
{
	local string strType;

	ParseString(param, "strType", strType);
	DialogSetEditType(strType);
	return;
}

function handleDialogSetID(string param)
{
	local int Id;

	ParseInt(param, "id", Id);
	DialogSetID(Id);
	return;
}

function handleDialogSetButtonWidthSize(string param)
{
	local int indexOK, indexCancel;

	ParseInt(param, "indexOK", indexOK);
	ParseInt(param, "indexCancel", indexCancel);
	DialogSetButtonWidthSize(indexOK, indexCancel);
	return;
}

function handleDialogSetButtonName(string param)
{
	local int indexOK, indexCancel;

	ParseInt(param, "indexOK", indexOK);
	ParseInt(param, "indexCancel", indexCancel);
	DialogSetButtonName(indexOK, indexCancel);
	return;
}

function handleDialogShowWithResize(string param)
{
	local int modalType, dialogType;
	local string strMessage;
	local int changeWidth, changeHeight;
	local string strControlName;

	ParseInt(param, "modalType", modalType);
	ParseInt(param, "dialogType", dialogType);
	ParseString(param, "strMessage", strMessage);
	ParseInt(param, "changeWidth", changeWidth);
	ParseInt(param, "changeHeight", changeHeight);
	ParseString(param, "strControlName", strControlName);
	DialogShowWithTarget(EDialogModalType(modalType), EDialogType(dialogType), strMessage, strControlName);
	return;
}

function HandleDialogShow(string param)
{
	local int modalType, dialogType;
	local string strMessage, strControlName;
	local int dialogWeight, dialogHeight, UseHtml;
	local string customIconTexture;

	ParseInt(param, "modalType", modalType);
	ParseInt(param, "dialogType", dialogType);
	ParseString(param, "strMessage", strMessage);
	ParseString(param, "strControlName", strControlName);
	ParseInt(param, "dialogWeight", dialogWeight);
	ParseInt(param, "dialogHeight", dialogHeight);
	ParseInt(param, "bUseHtml", UseHtml);
	ParseString(param, "customIconTexture", customIconTexture);
	if(bool(UseHtml))
	{
		DialogShowHtmlWithTarget(EDialogModalType(modalType), EDialogType(dialogType), strMessage, strControlName);
	}
	else
	{
		DialogShowWithTarget(EDialogModalType(modalType), EDialogType(dialogType), strMessage, strControlName);
	}
	return;
}

function int ctrlListSearchByName(ListCtrlHandle ListCtrl, string Name)
{
	local LVDataRecord Record;
	local int i, nReturn;

	nReturn = -1;
	i = 0;
	while((i < ListCtrl.GetRecordCount()))
	{
		ListCtrl.GetRec(i, Record);
		if((Record.LVDataList[0].szData == Name))
		{
			nReturn = i;
			break;
		}
		i++;
	}
	return nReturn;
}

function LVDataRecord getListSelectedRecord(ListCtrlHandle List, int Index)
{
	local LVDataRecord Record;

	List.SetSelectedIndex(Index, true);
	List.GetRec(Index, Record);
	return Record;
}

function arrayShuffleInt(out array<int> tempArray)
{
	local int i, ran, tempArrayLen;
	local array<int> changeArray;

	changeArray = tempArray;
	tempArrayLen = tempArray.Length;
	tempArray.Remove(0, tempArray.Length);
	i = 0;
	while((i < tempArrayLen))
	{
		ran = Rand(changeArray.Length);
		tempArray[i] = changeArray[ran];
		changeArray.Remove(ran, 1);
		i++;
	}
	return;
}

function string getTimeStringBySec(int Sec, optional bool hourFlag, optional bool minFlag)
{
	local int timeTemp;
	local string returnStr;

	returnStr = "";
	timeTemp = ((Sec / 60) / 60);
	if((timeTemp > 0))
	{
		if((hourFlag && minFlag))
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp), string(int((float((Sec / 60)) % 60.0000000))));
		}
		else if((hourFlag && (minFlag == false)))
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeTemp));
		}
		else if(((hourFlag == false) && minFlag))
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp));
		}
	}
	else if((hourFlag && (minFlag == false)))
	{
		if((Sec <= 0))
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3407), "0");
		}
		else
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3407), "1");
		}
	}
	else
	{
		timeTemp = (Sec / 60);
		if((timeTemp <= 0))
		{
			timeTemp = 1;
		}
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp));
	}
	return returnStr;
}

function string getTimeStringBySec2(int Sec)
{
	local int timeTemp, timeTemp0, timeTemp1;
	local string returnStr;

	returnStr = "";
	timeTemp = (((Sec / 60) / 60) / 24);
	timeTemp0 = ((Sec / 60) / 60);
	timeTemp1 = (Sec / 60);
	if((timeTemp > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(4466), string(timeTemp), string(int((float(timeTemp0) % 24.0000000))), string(int((float(timeTemp1) % 60.0000000))));
	}
	else if((timeTemp0 > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(int((float(timeTemp1) % 60.0000000))));
	}
	else if((timeTemp1 > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
	}
	else
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(4360), string(1));
	}
	return returnStr;
}

function string getTimeStringBySec3(int Sec)
{
	local int timeTemp, timeTemp0, timeTemp1;
	local string returnStr;

	returnStr = "";
	timeTemp = (((Sec / 60) / 60) / 24);
	timeTemp0 = ((Sec / 60) / 60);
	timeTemp1 = (Sec / 60);
	if((timeTemp > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3503), string(timeTemp), string(int((float(((Sec / 60) / 60)) % 24.0000000))));
	}
	else if((timeTemp0 > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(int((float((Sec / 60)) % 60.0000000))));
	}
	else if((timeTemp1 > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
	}
	else
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(4360), string(1));
	}
	return returnStr;
}

function string GetTimeStringBySec4(int Sec)
{
	local int timeTemp, timeTemp0, timeTemp1, timeTemp2;
	local string returnStr;

	returnStr = "";
	timeTemp = (((Sec / 60) / 60) / 24);
	timeTemp0 = ((Sec / 60) / 60);
	timeTemp1 = (Sec / 60);
	timeTemp2 = (Sec - (timeTemp1 * 60));
	if((timeTemp > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3418), string(timeTemp));
	}
	else if((timeTemp0 > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeTemp0));
	}
	else if((timeTemp1 > 0))
	{
		if((timeTemp2 == 0))
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
		}
		else
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(13418), string(timeTemp1), string(timeTemp2));
		}
	}
	else
	{
		returnStr = MakeTimeString(float(Sec));
	}
	return returnStr;
}

function string GetTimeStringBySec5(float Sec)
{
	local int timeTemp, timeTemp0, timeTemp1, timeTemp2;
	local string returnStr;

	returnStr = "";
	timeTemp = ((int((Sec / 60.0000000)) / 60) / 24);
	timeTemp0 = (int((Sec / 60.0000000)) / 60);
	timeTemp1 = int((Sec / 60.0000000));
	timeTemp2 = int((Sec - float((timeTemp1 * 60))));
	if((timeTemp > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3418), string(timeTemp));
	}
	else if((timeTemp0 > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeTemp0));
	}
	else if((timeTemp1 > 0))
	{
		if((timeTemp2 == 0))
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
		}
		else
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(13418), string(timeTemp1), string(timeTemp2));
		}
	}
	else
	{
		returnStr = MakeTimeString(Sec);
	}
	return returnStr;
}

function string GetTimeStringBySec6(int Sec)
{
	local int timeTemp0, timeTemp1;
	local string returnStr;

	returnStr = "";
	timeTemp0 = ((Sec / 60) / 60);
	timeTemp1 = (Sec / 60);
	if((timeTemp0 > 0))
	{
		if(((float(timeTemp1) % 60.0000000) == 0.0000000))
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeTemp0));
		}
		else
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(int((float(timeTemp1) % 60.0000000))));
		}
	}
	else if((timeTemp1 > 0))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
	}
	else
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
	}
	return returnStr;
}

function string GetTimeStringBySec7(int Sec)
{
	local int timeTemp1, timeTemp2;
	local string returnStr;

	returnStr = "";
	timeTemp1 = (Sec / 60);
	timeTemp2 = (Sec - (timeTemp1 * 60));
	if((timeTemp1 > 0))
	{
		if((timeTemp2 == 0))
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));
		}
		else
		{
			returnStr = MakeFullSystemMsg(GetSystemMessage(13418), string(timeTemp1), string(timeTemp2));
		}
	}
	else
	{
		returnStr = MakeTimeString(float(Sec));
	}
	return returnStr;
}

function setSystemStringArrayByNumStr(string systemStringNum, out array<string> targetArray)
{
	local int i;
	local array<string> tempArray;

	Split(systemStringNum, ",", tempArray);
	targetArray.Remove(0, targetArray.Length);
	i = 0;
	while((i < tempArray.Length))
	{
		targetArray[i] = GetSystemString(int(tempArray[i]));
		i++;
	}
	return;
}

function setArrayByNumStr(string systemStringNum, out array<string> targetArray)
{
	local int i;
	local array<string> tempArray;

	Split(systemStringNum, ",", tempArray);
	targetArray.Remove(0, targetArray.Length);
	i = 0;
	while((i < tempArray.Length))
	{
		targetArray[i] = tempArray[i];
		i++;
	}
	return;
}

function string getItemGradeSystemString(int nCrystalType)
{
	local string returnStr;

	switch(nCrystalType)
	{
		case 0:
			returnStr = GetSystemString(2622);
			break;
		case 1:
			returnStr = GetSystemString(2613);
			break;
		case 2:
			returnStr = GetSystemString(2614);
			break;
		case 3:
			returnStr = GetSystemString(2615);
			break;
		case 4:
			returnStr = GetSystemString(2616);
			break;
		case 5:
			returnStr = GetSystemString(2617);
			break;
		case 6:
			returnStr = GetSystemString(2682);
			break;
		case 7:
			returnStr = GetSystemString(2683);
			break;
		case 8:
			returnStr = GetSystemString(2618);
			break;
		case 9:
			returnStr = GetSystemString(2619);
			break;
		case 10:
			returnStr = GetSystemString(2620);
			break;
		case 11:
			returnStr = GetSystemString(3919);
			break;
		case 12:
			returnStr = GetSystemString(14477);
			break;
		default:
			returnStr = "";
	}
	return returnStr;
}

function bool checkIsPrologueGrowType(string WindowName)
{
	if(getIsPrologueGrowType())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4533));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow(getCurrentWindowName(WindowName));
		return true;
	}
	return false;
}

function bool getIsPrologueGrowType(optional int CurrentSubjobClassID)
{
	local UserInfo myUserInfo;
	local bool IsPrologueGrowType;

	if((CurrentSubjobClassID > 0))
	{
		IsPrologueGrowType = Class'NWindow.UIDATA_USER'.static.IsPrologueGrowType(CurrentSubjobClassID);
	}
	else if(GetPlayerInfo(myUserInfo))
	{
		IsPrologueGrowType = Class'NWindow.UIDATA_USER'.static.IsPrologueGrowType(myUserInfo.nSubClass);
	}
	else
	{
		return false;
	}
	return (IsPrologueGrowType && getInstanceUIData().GetIsLiveServer());
}

function ItemRelationWindowHide(string currentWindowName, optional string exceptionWindowNameWithComma)
{
	local int i, Len;

	Len = ItemRelationWindowArrayStr.Length;
	i = 0;
	while((i < Len))
	{
		hideTargetWindow(currentWindowName, ItemRelationWindowArrayStr[i], exceptionWindowNameWithComma);
		i++;
	}
	return;
}

function hideTargetWindow(string currentWindowName, string WindowHandleString, optional string exceptionWindowNameWithComma)
{
	local int i;
	local array<string> exceptionArray;

	if((exceptionWindowNameWithComma != ""))
	{
		Split(exceptionWindowNameWithComma, ",", exceptionArray);
		if((exceptionArray.Length <= 1))
		{
			exceptionArray[0] = exceptionWindowNameWithComma;
		}
	}
	i = 0;
	while((i < exceptionArray.Length))
	{
		if((WindowHandleString == exceptionArray[i]))
		{
			return;
		}
		i++;
	}
	if((currentWindowName != WindowHandleString))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(WindowHandleString))
		{
			switch(WindowHandleString)
			{
				case "PrivateShopWnd":
					PrivateShopWndScript.OnClickButton("StopButton");
					break;
				case "UnrefineryWnd":
					UnrefineryWndScript.OnClickButton("btnClose");
					break;
				case "AttributeRemoveWnd":
					AttributeRemoveWndScript.OnbtnCancelClick();
					break;
				case "AttributeEnchantWnd":
					AttributeEnchantWndScript.OnReceivedCloseUI();
					break;
				case "CrystallizationWnd":
					CrystallizationWndScript.cancelCystallizeItem();
					break;
				case "ItemLookChangeWnd":
					ItemLookChangeWndScript.OnClickButton("ExitBtn");
					break;
				case "MultiSellWnd":
					MultiSellWndScript.OnClickButton("Close_Button");
					break;
				case "TradeWnd":
					TradeWndScript.OnClickButton("CancelButton");
					GetWindowHandle(WindowHandleString).HideWindow();
					RequestItemList();
					break;
				case "DeliverWnd":
					DeliverWndScript.OnClickButton("CancelButton");
					break;
				case "ItemAttributeChangeWnd":
					ItemAttributeChangeWndScript.OnClickButton("CancelBtn");
					break;
				case "AdenaDistributionWnd":
					CallGFxFunction(WindowHandleString, "RequestDivideAdenaCancel", "");
					break;
				case "MultiSellItemExchangeWnd":
					if(!MultiSellItemExchangeWnd(GetScript("MultiSellItemExchangeWnd")).bIsPreview)
					{
						Class'NWindow.UIAPI_WINDOW'.static.HideWindow(WindowHandleString);
					}
					break;
				default:
					Class'NWindow.UIAPI_WINDOW'.static.HideWindow(WindowHandleString);
			}
		}
	}
	return;
}

function ItemRelationWindowsShowChecker(string currentWindowName)
{
	PrivateShopWndScript = PrivateShopWnd(GetScript("PrivateShopWnd"));
	if(isItemRelationWindowsShow(currentWindowName))
	{
		if(GetWindowHandle(currentWindowName).IsShowWindow())
		{
			hideTargetWindow("", currentWindowName);
		}
	}
	return;
}

function bool isItemRelationWindowsShow(string currentWindowName)
{
	local bool checkFlag;
	local int i, Len;

	Len = ItemRelationWindowArrayStr.Length;
	checkFlag = false;
	i = 0;
	while((i < Len))
	{
		if((currentWindowName != ItemRelationWindowArrayStr[i]))
		{
			if(GetWindowHandle(ItemRelationWindowArrayStr[i]).IsShowWindow())
			{
				checkFlag = true;
				break;
			}
		}
		i++;
	}
	return checkFlag;
}

function string makeZeroString(int StrLen, INT64 Num)
{
	local int i;
	local string sum;

	sum = string(Num);
	i = 0;
	while((i < StrLen))
	{
		if((Len(sum) >= StrLen))
		{
			break;
			i++;
			continue;
		}
		sum = ("0" $ sum);
		i++;
	}
	return sum;
}

function string getSliceWindowName(string targetString)
{
	local array<string> ArrayStr;

	Split(targetString, ".", ArrayStr);
	return ArrayStr[1];
}

function array<ItemInfo> sortByName(array<ItemInfo> ItemList)
{
	local int Len;
	local ItemInfo temp;
	local int i, j;

	Len = ItemList.Length;
	i = 0;
	while((i < Len))
	{
		j = 0;
		while((j < (Len - i)))
		{
			if((j < (Len - 1)))
			{
				if((GetItemNameWithAdditional(ItemList[j]) > GetItemNameWithAdditional(ItemList[(j + 1)])))
				{
					temp = ItemList[j];
					ItemList[j] = ItemList[(j + 1)];
					ItemList[(j + 1)] = temp;
				}
			}
			++j;
		}
		++i;
	}
	return ItemList;
}

function array<ItemInfo> sortByItemType(array<ItemInfo> ItemList)
{
	local int Len;
	local ItemInfo temp;
	local int i, j, classID1, classID2, etcItemType1, etcItemType2, itemType1, itemType2;
	local INT64 slotbitType1, slotbitType2;

	Len = ItemList.Length;
	i = 0;
	while((i < Len))
	{
		j = 0;
		while((j < (Len - i)))
		{
			if((j < (Len - 1)))
			{
				classID1 = ItemList[j].Id.ClassID;
				classID2 = ItemList[(j + 1)].Id.ClassID;
				itemType1 = ItemList[j].ItemType;
				itemType2 = ItemList[(j + 1)].ItemType;
				etcItemType1 = ItemList[j].EtcItemType;
				etcItemType2 = ItemList[(j + 1)].EtcItemType;
				slotbitType1 = ItemList[j].SlotBitType;
				slotbitType2 = ItemList[(j + 1)].SlotBitType;
				if((GetSortOrderEquipFast(classID1, EItemType(itemType1), etcItemType1, slotbitType1) > GetSortOrderEquipFast(classID2, EItemType(itemType2), etcItemType2, slotbitType2)))
				{
					temp = ItemList[j];
					ItemList[j] = ItemList[(j + 1)];
					ItemList[(j + 1)] = temp;
				}
			}
			++j;
		}
		++i;
	}
	return ItemList;
}

function array<ItemInfo> sortByWeight(array<ItemInfo> ItemList)
{
	local int Len;
	local ItemInfo temp;
	local int i, j;

	Len = ItemList.Length;
	i = 0;
	while((i < Len))
	{
		j = 0;
		while((j < (Len - i)))
		{
			if((j < (Len - 1)))
			{
				if((ItemList[j].Weight < ItemList[(j + 1)].Weight))
				{
					temp = ItemList[j];
					ItemList[j] = ItemList[(j + 1)];
					ItemList[(j + 1)] = temp;
				}
			}
			++j;
		}
		++i;
	}
	return ItemList;
}

function array<int> sortByInt(array<int> ItemList)
{
	local int Len, temp, i, j;

	Len = ItemList.Length;
	i = 0;
	while((i < Len))
	{
		j = 0;
		while((j < (Len - i)))
		{
			if((j < (Len - 1)))
			{
				if((ItemList[j] < ItemList[(j + 1)]))
				{
					temp = ItemList[j];
					ItemList[j] = ItemList[(j + 1)];
					ItemList[(j + 1)] = temp;
				}
			}
			++j;
		}
		++i;
	}
	return ItemList;
}

function array<ItemInfo> sortByEnchanted(array<ItemInfo> ItemList)
{
	local int Len;
	local ItemInfo temp;
	local int i, j;

	Len = ItemList.Length;
	i = 0;
	while((i < Len))
	{
		j = 0;
		while((j < (Len - i)))
		{
			if((j < (Len - 1)))
			{
				if((ItemList[j].Enchanted > ItemList[(j + 1)].Enchanted))
				{
					temp = ItemList[j];
					ItemList[j] = ItemList[(j + 1)];
					ItemList[(j + 1)] = temp;
				}
			}
			++j;
		}
		++i;
	}
	return ItemList;
}

function array<ItemInfo> sortByDP(array<ItemInfo> ItemList)
{
	local int Len;
	local ItemInfo temp;
	local int i, j;

	Len = ItemList.Length;
	i = 0;
	while((i < Len))
	{
		j = 0;
		while((j < (Len - i)))
		{
			if((j < (Len - 1)))
			{
				if((ItemList[j].n64DefaultPriceFromScript < ItemList[(j + 1)].n64DefaultPriceFromScript))
				{
					temp = ItemList[j];
					ItemList[j] = ItemList[(j + 1)];
					ItemList[(j + 1)] = temp;
				}
			}
			++j;
		}
		++i;
	}
	return ItemList;
}

function bool HandleDelegateChkInventoryClassic(ItemInfo iInfoA, ItemInfo iInfoB)
{
	if(IsPeroidSortCheck(iInfoA, iInfoB))
	{
		return IsSwapByItemInfoPeroid(iInfoA, iInfoB);
	}
	if((iInfoA.SortOrder != iInfoB.SortOrder))
	{
		return (iInfoA.SortOrder < iInfoB.SortOrder);
	}
	if((GetSortOrderEquip(iInfoA) != GetSortOrderEquip(iInfoB)))
	{
		return (GetSortOrderEquip(iInfoA) > GetSortOrderEquip(iInfoB));
	}
	if((iInfoA.CrystalType != iInfoB.CrystalType))
	{
		return (iInfoA.CrystalType < iInfoB.CrystalType);
	}
	if((GetItemNameWithAdditional(iInfoA) != GetItemNameWithAdditional(iInfoB)))
	{
		return (GetItemNameWithAdditional(iInfoA) > GetItemNameWithAdditional(iInfoB));
	}
	if((iInfoA.Id.ClassID != iInfoB.Id.ClassID))
	{
		return (iInfoA.Id.ClassID < iInfoB.Id.ClassID);
	}
}

function bool IsPeroidSortCheck(ItemInfo iInfoA, ItemInfo iInfoB)
{
	local bool isPeroidicItemA, isPeroidicItemB;
	local INT64 maxA, maxB;

	isPeroidicItemA = Class'InterfaceClassic.L2UIInventory'.static.Inst()._IsPeroidicItem(iInfoA);
	isPeroidicItemB = Class'InterfaceClassic.L2UIInventory'.static.Inst()._IsPeroidicItem(iInfoB);
	if(((isPeroidicItemA == isPeroidicItemB) && (MAX64(iInfoA.nDBDeleteDate, INT64(iInfoA.CurrentPeriod)) == MAX64(iInfoB.nDBDeleteDate, INT64(iInfoB.CurrentPeriod)))))
	{
		return false;
	}
	return true;
	if((isPeroidicItemA == isPeroidicItemB))
	{
		maxA = MAX64(iInfoA.nDBDeleteDate, INT64(iInfoA.CurrentPeriod));
		maxB = MAX64(iInfoB.nDBDeleteDate, INT64(iInfoB.CurrentPeriod));
		if((maxA == maxB))
		{
			return false;
		}
	}
	if((isPeroidicItemA && !isPeroidicItemB))
	{
		return true;
	}
	return false;
}

function bool IsSwapByItemInfoPeroid(ItemInfo iInfoA, ItemInfo iInfoB)
{
	local bool isPeroidicItemA, isPeroidicItemB;
	local INT64 maxA, maxB;

	isPeroidicItemA = Class'InterfaceClassic.L2UIInventory'.static.Inst()._IsPeroidicItem(iInfoA);
	isPeroidicItemB = Class'InterfaceClassic.L2UIInventory'.static.Inst()._IsPeroidicItem(iInfoB);
	if((isPeroidicItemA == isPeroidicItemB))
	{
		maxA = MAX64(iInfoA.nDBDeleteDate, INT64(iInfoA.CurrentPeriod));
		maxB = MAX64(iInfoB.nDBDeleteDate, INT64(iInfoB.CurrentPeriod));
		if((maxA < maxB))
		{
			return true;
		}
	}
	if((isPeroidicItemA && !isPeroidicItemB))
	{
		return true;
	}
	return false;
}

function int GetSortOrderEquipFast(int ClassID, UIEventManager.EItemType ItemType, int nEtcItemType, INT64 SlotBitType)
{
	if((ClassID == 57))
	{
		return 0;
	}
	if((ClassID == 91663))
	{
		return 1;
	}
	switch(ItemType)
	{
		case ITEM_WEAPON:
			return 2;
			break;
		case ITEM_ETCITEM:
			switch(byte(nEtcItemType))
			{
				case 2:
					return 3;
					break;
				case 27:
					return 4;
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
	switch(SlotBitType)
	{
		case INT64(1024):
			return 5;
			break;
		case INT64(2048):
			return 6;
			break;
		case INT64(4096):
			return 7;
			break;
		case INT64(64):
			return 8;
			break;
		case INT64(512):
			return 9;
			break;
		case INT64(32768):
			return 10;
			break;
		case INT64(2):
		case INT64(4):
		case INT64(6):
			return 11;
			break;
		case INT64(16):
		case INT64(32):
		case INT64(48):
			return 12;
			break;
		case INT64(8):
			return 13;
			break;
		case INT64(1048576):
			return 14;
			break;
		case INT64(4194304):
			return 15;
			break;
		case INT64(2097152):
			return 16;
			break;
		case INT64(48):
			return 17;
			break;
		case INT64(536870912):
			return 18;
			break;
		case INT64(1073741824):
			return 19;
			break;
		case INT64(128):
		case INT64(256):
		case INT64(16384):
			if(((int(ItemType) == 1) || (int(ItemType) == 2)))
			{
				return 20;
			}
			if(IsSigilArmor(GetItemID(ClassID)))
			{
				return 21;
			}
			break;
		case INT64(1):
			return 22;
			break;
		case INT64(8192):
			return 23;
			break;
		case INT64(268435456):
			return 24;
			break;
		case INT64(65536):
		case INT64(262144):
		case INT64(524288):
			return 25;
			break;
		case INT64(131072):
			return 26;
			break;
		case INT64(12582912):
		case INT64(50331648):
		case INT64(201326592):
			return 100;
			break;
		case INT64(512):
			return 100;
			break;
		default:
			switch(byte(nEtcItemType))
			{
				case 34:
				case 35:
					return 27;
					break;
				case 7:
					return 28;
					break;
				default:
					break;
			}
			break;
	}
	return 100;
}

function int GetSortOrderEquip(ItemInfo iInfo)
{
	if((iInfo.Id.ClassID == 57))
	{
		return 0;
	}
	if((iInfo.Id.ClassID == 91663))
	{
		return 1;
	}
	switch(byte(iInfo.ItemType))
	{
		case 0:
			return 2;
			break;
		case 5:
			switch(byte(iInfo.EtcItemType))
			{
				case 2:
					return 3;
					break;
				case 27:
					return 4;
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
	switch(iInfo.SlotBitType)
	{
		case INT64(1024):
			return 5;
			break;
		case INT64(2048):
			return 6;
			break;
		case INT64(4096):
			return 7;
			break;
		case INT64(64):
			return 8;
			break;
		case INT64(512):
			return 9;
			break;
		case INT64(32768):
			return 10;
			break;
		case INT64(2):
		case INT64(4):
		case INT64(6):
			return 11;
			break;
		case INT64(16):
		case INT64(32):
		case INT64(48):
			return 12;
			break;
		case INT64(8):
			return 13;
			break;
		case INT64(1048576):
			return 14;
			break;
		case INT64(4194304):
			return 15;
			break;
		case INT64(2097152):
			return 16;
			break;
		case INT64(48):
			return 17;
			break;
		case INT64(536870912):
			return 18;
			break;
		case INT64(1073741824):
			return 19;
			break;
		case INT64(128):
		case INT64(256):
		case INT64(16384):
			if(((int(byte(iInfo.ItemType)) == 1) || (int(byte(iInfo.ItemType)) == 2)))
			{
				return 20;
			}
			if(IsSigilArmor(iInfo.Id))
			{
				return 21;
			}
			break;
		case INT64(1):
			return 22;
			break;
		case INT64(8192):
			return 23;
			break;
		case INT64(268435456):
			return 24;
			break;
		case INT64(65536):
		case INT64(262144):
		case INT64(524288):
			return 25;
			break;
		case INT64(131072):
			return 26;
			break;
		case INT64(12582912):
		case INT64(50331648):
		case INT64(201326592):
			return 100;
			break;
		case INT64(512):
			return 100;
			break;
		default:
			switch(byte(iInfo.EtcItemType))
			{
				case 34:
				case 35:
					return 27;
					break;
				case 7:
					return 28;
					break;
				default:
					break;
			}
			break;
	}
	return 100;
}

function array<ItemInfo> PushItemInfoArray(array<ItemInfo> ItemList, array<ItemInfo> pushList)
{
	local int i;

	i = 0;
	while((i < pushList.Length))
	{
		ItemList[ItemList.Length] = pushList[i];
		i++;
	}
	return ItemList;
}

function array<ItemInfo> SortItemArray(array<ItemInfo> ItemList)
{
	local int i, ItemNum;
	local ItemInfo item;
	local UIEventManager.EItemType EItemType;
	local array<ItemInfo> AssetList, WeaponList, ArmorList, AccesaryList, EtcItemList, AncientCrystalEnchantAmList, AncientCrystalEnchantWpList, CrystalEnchantAmList, CrystalEnchantWpList, BlessEnchantAmList, BlessEnchantWpList, EnchantAmList, EnchantWpList, IncEnchantPropAmList, IncEnchantPropWpList, PotionList, ElixirList, ArrowList, BoltList, RecipeList, ArtifactList;

	ItemNum = ItemList.Length;
	i = 0;
	while((i < ItemNum))
	{
		if(!IsValidItemID(ItemList[i].Id))
		{
			++i;
			continue;
		}
		item = ItemList[i];
		EItemType = EItemType(item.ItemType);
		switch(EItemType)
		{
			case ITEM_ASSET:
				AssetList[AssetList.Length] = item;
				break;
			case ITEM_WEAPON:
				WeaponList[WeaponList.Length] = item;
				break;
			case ITEM_ARMOR:
				ArmorList[ArmorList.Length] = item;
				break;
			case ITEM_ACCESSARY:
				if(IsArtifactRuneItem(item))
				{
					ArtifactList[ArtifactList.Length] = item;
				}
				else
				{
					AccesaryList[AccesaryList.Length] = item;
				}
				break;
			case ITEM_ETCITEM:
				switch(byte(item.EtcItemType))
				{
					case 32:
						AncientCrystalEnchantAmList[AncientCrystalEnchantAmList.Length] = item;
						break;
					case 33:
						AncientCrystalEnchantWpList[AncientCrystalEnchantWpList.Length] = item;
						break;
					case 30:
						CrystalEnchantAmList[CrystalEnchantAmList.Length] = item;
						break;
					case 31:
						CrystalEnchantWpList[CrystalEnchantWpList.Length] = item;
						break;
					case 22:
						BlessEnchantAmList[BlessEnchantAmList.Length] = item;
						break;
					case 21:
						BlessEnchantWpList[BlessEnchantWpList.Length] = item;
						break;
					case 20:
						EnchantAmList[EnchantAmList.Length] = item;
						break;
					case 19:
						EnchantWpList[EnchantWpList.Length] = item;
						break;
					case 29:
						IncEnchantPropAmList[IncEnchantPropAmList.Length] = item;
						break;
					case 28:
						IncEnchantPropWpList[IncEnchantPropWpList.Length] = item;
						break;
					case 3:
						PotionList[PotionList.Length] = item;
						break;
					case 24:
						ElixirList[ElixirList.Length] = item;
						break;
					case 2:
						ArrowList[ArrowList.Length] = item;
						break;
					case 27:
						BoltList[BoltList.Length] = item;
						break;
					case 5:
						RecipeList[RecipeList.Length] = item;
						break;
					default:
						EtcItemList[EtcItemList.Length] = item;
						break;
				}
				break;
			default:
				EtcItemList[EtcItemList.Length] = item;
				break;
		}
		++i;
	}
	AssetList = sortByName(AssetList);
	WeaponList = sortByName(WeaponList);
	ArmorList = sortByName(ArmorList);
	AccesaryList = sortByName(AccesaryList);
	AncientCrystalEnchantAmList = sortByName(AncientCrystalEnchantAmList);
	AncientCrystalEnchantWpList = sortByName(AncientCrystalEnchantWpList);
	CrystalEnchantAmList = sortByName(CrystalEnchantAmList);
	CrystalEnchantWpList = sortByName(CrystalEnchantWpList);
	BlessEnchantAmList = sortByName(BlessEnchantAmList);
	BlessEnchantWpList = sortByName(BlessEnchantWpList);
	EnchantAmList = sortByName(EnchantAmList);
	EnchantWpList = sortByName(EnchantWpList);
	IncEnchantPropAmList = sortByName(IncEnchantPropAmList);
	IncEnchantPropWpList = sortByName(IncEnchantPropWpList);
	PotionList = sortByName(PotionList);
	ElixirList = sortByName(ElixirList);
	ArrowList = sortByName(ArrowList);
	BoltList = sortByName(BoltList);
	RecipeList = sortByName(RecipeList);
	EtcItemList = sortByName(EtcItemList);
	ItemList.Remove(0, ItemList.Length);
	ItemList = PushItemInfoArray(ItemList, AssetList);
	ItemList = PushItemInfoArray(ItemList, WeaponList);
	ItemList = PushItemInfoArray(ItemList, ArmorList);
	ItemList = PushItemInfoArray(ItemList, AccesaryList);
	ItemList = PushItemInfoArray(ItemList, AncientCrystalEnchantAmList);
	ItemList = PushItemInfoArray(ItemList, AncientCrystalEnchantWpList);
	ItemList = PushItemInfoArray(ItemList, CrystalEnchantAmList);
	ItemList = PushItemInfoArray(ItemList, CrystalEnchantWpList);
	ItemList = PushItemInfoArray(ItemList, BlessEnchantAmList);
	ItemList = PushItemInfoArray(ItemList, BlessEnchantWpList);
	ItemList = PushItemInfoArray(ItemList, EnchantAmList);
	ItemList = PushItemInfoArray(ItemList, EnchantWpList);
	ItemList = PushItemInfoArray(ItemList, IncEnchantPropAmList);
	ItemList = PushItemInfoArray(ItemList, IncEnchantPropWpList);
	ItemList = PushItemInfoArray(ItemList, PotionList);
	ItemList = PushItemInfoArray(ItemList, ElixirList);
	ItemList = PushItemInfoArray(ItemList, ArrowList);
	ItemList = PushItemInfoArray(ItemList, BoltList);
	ItemList = PushItemInfoArray(ItemList, RecipeList);
	ItemList = PushItemInfoArray(ItemList, EtcItemList);
	ItemList = PushItemInfoArray(ItemList, ArtifactList);
	return ItemList;
}

function SortItemLive(ItemWindowHandle m_topList)
{
	local int i, InvenLimit;
	local ItemInfo item;
	local UIEventManager.EItemType EItemType;
	local int nextSlot;
	local array<ItemInfo> AssetList, WeaponList, ArmorList, AccesaryList, EtcItemList, AncientCrystalEnchantAmList, AncientCrystalEnchantWpList, CrystalEnchantAmList, CrystalEnchantWpList, BlessEnchantAmList, BlessEnchantWpList, EnchantAmList, EnchantWpList, IncEnchantPropAmList, IncEnchantPropWpList, PotionList, ElixirList, ArrowList, BoltList, RecipeList;

	InvenLimit = m_topList.GetItemNum();
	i = 0;
	while((i < InvenLimit))
	{
		m_topList.GetItem(i, item);
		if(!IsValidItemID(item.Id))
		{
			++i;
			continue;
		}
		EItemType = EItemType(item.ItemType);
		switch(EItemType)
		{
			case ITEM_ASSET:
				AssetList[AssetList.Length] = item;
				break;
			case ITEM_WEAPON:
				WeaponList[WeaponList.Length] = item;
				break;
			case ITEM_ARMOR:
				ArmorList[ArmorList.Length] = item;
				break;
			case ITEM_ACCESSARY:
				AccesaryList[AccesaryList.Length] = item;
				break;
			case ITEM_ETCITEM:
				switch(byte(item.EtcItemType))
				{
					case 32:
						AncientCrystalEnchantAmList[AncientCrystalEnchantAmList.Length] = item;
						break;
					case 33:
						AncientCrystalEnchantWpList[AncientCrystalEnchantWpList.Length] = item;
						break;
					case 30:
						CrystalEnchantAmList[CrystalEnchantAmList.Length] = item;
						break;
					case 31:
						CrystalEnchantWpList[CrystalEnchantWpList.Length] = item;
						break;
					case 22:
						BlessEnchantAmList[BlessEnchantAmList.Length] = item;
						break;
					case 21:
						BlessEnchantWpList[BlessEnchantWpList.Length] = item;
						break;
					case 20:
						EnchantAmList[EnchantAmList.Length] = item;
						break;
					case 19:
						EnchantWpList[EnchantWpList.Length] = item;
						break;
					case 29:
						IncEnchantPropAmList[IncEnchantPropAmList.Length] = item;
						break;
					case 28:
						IncEnchantPropWpList[IncEnchantPropWpList.Length] = item;
						break;
					case 3:
						PotionList[PotionList.Length] = item;
						break;
					case 24:
						ElixirList[ElixirList.Length] = item;
						break;
					case 2:
						ArrowList[ArrowList.Length] = item;
						break;
					case 27:
						BoltList[BoltList.Length] = item;
						break;
					case 5:
						RecipeList[RecipeList.Length] = item;
						break;
					default:
						EtcItemList[EtcItemList.Length] = item;
						break;
				}
				break;
			default:
				EtcItemList[EtcItemList.Length] = item;
				break;
		}
		++i;
	}
	AssetList = sortByName(AssetList);
	WeaponList = sortByName(WeaponList);
	ArmorList = sortByName(ArmorList);
	AccesaryList = sortByName(AccesaryList);
	AncientCrystalEnchantAmList = sortByName(AncientCrystalEnchantAmList);
	AncientCrystalEnchantWpList = sortByName(AncientCrystalEnchantWpList);
	CrystalEnchantAmList = sortByName(CrystalEnchantAmList);
	CrystalEnchantWpList = sortByName(CrystalEnchantWpList);
	BlessEnchantAmList = sortByName(BlessEnchantAmList);
	BlessEnchantWpList = sortByName(BlessEnchantWpList);
	EnchantAmList = sortByName(EnchantAmList);
	EnchantWpList = sortByName(EnchantWpList);
	IncEnchantPropAmList = sortByName(IncEnchantPropAmList);
	IncEnchantPropWpList = sortByName(IncEnchantPropWpList);
	PotionList = sortByName(PotionList);
	ElixirList = sortByName(ElixirList);
	ArrowList = sortByName(ArrowList);
	BoltList = sortByName(BoltList);
	RecipeList = sortByName(RecipeList);
	EtcItemList = sortByName(EtcItemList);
	m_topList.Clear();
	ItemboxUpdate(m_topList, InvenLimit);
	i = 0;
	while((i < AssetList.Length))
	{
		m_topList.SetItem((nextSlot + i), AssetList[i]);
		++i;
	}
	nextSlot = (nextSlot + AssetList.Length);
	i = 0;
	while((i < WeaponList.Length))
	{
		m_topList.SetItem((nextSlot + i), WeaponList[i]);
		++i;
	}
	nextSlot = (nextSlot + WeaponList.Length);
	i = 0;
	while((i < ArmorList.Length))
	{
		m_topList.SetItem((nextSlot + i), ArmorList[i]);
		++i;
	}
	nextSlot = (nextSlot + ArmorList.Length);
	i = 0;
	while((i < AccesaryList.Length))
	{
		m_topList.SetItem((nextSlot + i), AccesaryList[i]);
		++i;
	}
	nextSlot = (nextSlot + AccesaryList.Length);
	i = 0;
	while((i < AncientCrystalEnchantAmList.Length))
	{
		m_topList.SetItem((nextSlot + i), AncientCrystalEnchantAmList[i]);
		++i;
	}
	nextSlot = (nextSlot + AncientCrystalEnchantAmList.Length);
	i = 0;
	while((i < AncientCrystalEnchantWpList.Length))
	{
		m_topList.SetItem((nextSlot + i), AncientCrystalEnchantWpList[i]);
		++i;
	}
	nextSlot = (nextSlot + AncientCrystalEnchantWpList.Length);
	i = 0;
	while((i < CrystalEnchantAmList.Length))
	{
		m_topList.SetItem((nextSlot + i), CrystalEnchantAmList[i]);
		++i;
	}
	nextSlot = (nextSlot + CrystalEnchantAmList.Length);
	i = 0;
	while((i < CrystalEnchantWpList.Length))
	{
		m_topList.SetItem((nextSlot + i), CrystalEnchantWpList[i]);
		++i;
	}
	nextSlot = (nextSlot + CrystalEnchantWpList.Length);
	i = 0;
	while((i < BlessEnchantAmList.Length))
	{
		m_topList.SetItem((nextSlot + i), BlessEnchantAmList[i]);
		++i;
	}
	nextSlot = (nextSlot + BlessEnchantAmList.Length);
	i = 0;
	while((i < BlessEnchantWpList.Length))
	{
		m_topList.SetItem((nextSlot + i), BlessEnchantWpList[i]);
		++i;
	}
	nextSlot = (nextSlot + BlessEnchantWpList.Length);
	i = 0;
	while((i < EnchantAmList.Length))
	{
		m_topList.SetItem((nextSlot + i), EnchantAmList[i]);
		++i;
	}
	nextSlot = (nextSlot + EnchantAmList.Length);
	i = 0;
	while((i < EnchantWpList.Length))
	{
		m_topList.SetItem((nextSlot + i), EnchantWpList[i]);
		++i;
	}
	nextSlot = (nextSlot + EnchantWpList.Length);
	i = 0;
	while((i < IncEnchantPropAmList.Length))
	{
		m_topList.SetItem((nextSlot + i), IncEnchantPropAmList[i]);
		++i;
	}
	nextSlot = (nextSlot + IncEnchantPropAmList.Length);
	i = 0;
	while((i < IncEnchantPropWpList.Length))
	{
		m_topList.SetItem((nextSlot + i), IncEnchantPropWpList[i]);
		++i;
	}
	nextSlot = (nextSlot + IncEnchantPropWpList.Length);
	i = 0;
	while((i < PotionList.Length))
	{
		m_topList.SetItem((nextSlot + i), PotionList[i]);
		++i;
	}
	nextSlot = (nextSlot + PotionList.Length);
	i = 0;
	while((i < ElixirList.Length))
	{
		m_topList.SetItem((nextSlot + i), ElixirList[i]);
		++i;
	}
	nextSlot = (nextSlot + ElixirList.Length);
	i = 0;
	while((i < ArrowList.Length))
	{
		m_topList.SetItem((nextSlot + i), ArrowList[i]);
		++i;
	}
	nextSlot = (nextSlot + ArrowList.Length);
	i = 0;
	while((i < BoltList.Length))
	{
		m_topList.SetItem((nextSlot + i), BoltList[i]);
		++i;
	}
	nextSlot = (nextSlot + BoltList.Length);
	i = 0;
	while((i < RecipeList.Length))
	{
		m_topList.SetItem((nextSlot + i), RecipeList[i]);
		++i;
	}
	nextSlot = (nextSlot + RecipeList.Length);
	i = 0;
	while((i < EtcItemList.Length))
	{
		m_topList.SetItem((nextSlot + i), EtcItemList[i]);
		++i;
	}
	return;
}

function SortItemSimple(ItemWindowHandle m_topList)
{
	local int i, InvenLimit;
	local ItemInfo item;
	local array<ItemInfo> ItemListAll;
	local float timeSec;

	timeSec = GetAppSeconds();
	InvenLimit = m_topList.GetItemNum();
	i = 0;
	while((i < InvenLimit))
	{
		m_topList.GetItem(i, item);
		if(!IsValidItemID(item.Id))
		{
			++i;
			continue;
		}
		ItemListAll[ItemListAll.Length] = item;
		++i;
	}
	if((ItemListAll.Length > 0))
	{
		sortShellSortByItemType(ItemListAll);
		sortShellSortByName(ItemListAll);
	}
	m_topList.Clear();
	ItemboxUpdate(m_topList, InvenLimit);
	i = 0;
	while((i < ItemListAll.Length))
	{
		m_topList.SetItem(i, ItemListAll[i]);
		++i;
	}
	Debug((" timeSec-> " @ string((GetAppSeconds() - timeSec))));
	return;
}

function sortShellSortByItemType(out array<ItemInfo> arr)
{
	local int h, i, j;
	local ItemInfo tmp;

	h = (arr.Length / 2);
	while((h > 0))
	{
		i = h;
		while((i < arr.Length))
		{
			tmp = arr[i];
			j = (i - h);
			while(((j >= 0) && (GetSortOrderEquip(arr[j]) > GetSortOrderEquip(tmp))))
			{
				arr[(j + h)] = arr[j];
				(j -= h);
			}
			arr[(j + h)] = tmp;
			i++;
		}
		(h /= 2.0000000);
	}
	return;
}

function sortShellSortByName(out array<ItemInfo> arr)
{
	local int h, i, j;
	local ItemInfo tmp;

	h = (arr.Length / 2);
	while((h > 0))
	{
		i = h;
		while((i < arr.Length))
		{
			tmp = arr[i];
			j = (i - h);
			while(((j >= 0) && (GetItemNameWithAdditional(arr[j]) > GetItemNameWithAdditional(tmp))))
			{
				arr[(j + h)] = arr[j];
				(j -= h);
			}
			arr[(j + h)] = tmp;
			i++;
		}
		(h /= 2.0000000);
	}
	return;
}

function SortItemClassic(ItemWindowHandle m_topList)
{
	local int i, InvenLimit;
	local ItemInfo item;
	local array<ItemInfo> ItemListAll;
	local L2UISortObject sortObject;

	InvenLimit = m_topList.GetItemNum();
	i = 0;
	while((i < InvenLimit))
	{
		m_topList.GetItem(i, item);
		if((IsValidItemID(item.Id) == false))
		{
			++i;
			continue;
		}
		ItemListAll[ItemListAll.Length] = item;
		++i;
	}
	if((ItemListAll.Length > 0))
	{
		sortObject = new Class'InterfaceClassic.L2UISortObject';
		sortObject._DelegateCheckByItemInfo = HandleDelegateChkInventoryClassic;
		sortObject._SortItemInfo(ItemListAll);
	}
	m_topList.Clear();
	ItemboxUpdate(m_topList, InvenLimit);
	i = 0;
	while((i < ItemListAll.Length))
	{
		m_topList.SetItem(i, ItemListAll[i]);
		++i;
	}
	return;
}

function SortItem(ItemWindowHandle m_topList)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		SortItemClassic(m_topList);
	}
	else
	{
		SortItemLive(m_topList);
	}
	return;
}

function int FindItemByClassIDWithFilter(int ClassID, out array<ItemInfo> itemInfoArray, optional EItemLockedCheckType LockType, optional bool bUseExceptionEnsoul, optional int filterNum)
{
	local int i, ItemCount;
	local array<ItemInfo> tmpItemArray, invenItemArray;

	Class'NWindow.UIDATA_INVENTORY'.static.GetItemByScriptFilter(filterNum, invenItemArray);
	ItemCount = 0;
	i = 0;
	while((i < invenItemArray.Length))
	{
		if((invenItemArray[i].Id.ClassID == ClassID))
		{
			ItemCount++;
			tmpItemArray[tmpItemArray.Length] = invenItemArray[i];
		}
		i++;
	}
	if((int(LockType) == 0))
	{
		return ItemCount;
	}
	i = 0;
	while((i < tmpItemArray.Length))
	{
		if((((int(LockType) == 1) && tmpItemArray[i].bSecurityLock) || ((int(LockType) == 2) && !tmpItemArray[i].bSecurityLock)))
		{
			if(bUseExceptionEnsoul)
			{
				if(hasEnsoulOption(tmpItemArray[i]))
				{
					i++;
					continue;
				}
			}
			itemInfoArray.Length = (itemInfoArray.Length + 1);
			itemInfoArray[(itemInfoArray.Length - 1)] = tmpItemArray[i];
		}
		i++;
	}
	return itemInfoArray.Length;
}

function int GetNonStackableInvenItemNum(int ClassID, int Enchanted, bool isBlessed, bool isKeepOption)
{
	if(isKeepOption)
	{
		return Class'NWindow.UIDATA_INVENTORY'.static.GetSpecificItemNumByScriptFilter(3, ClassID, Enchanted, isBlessed);
	}
	else
	{
		return Class'NWindow.UIDATA_INVENTORY'.static.GetSpecificItemNumByScriptFilter(5, ClassID, Enchanted, isBlessed);
	}
}

function INT64 GetCraftInventoryHaveNum(int ClassID, int Enchanted, bool isBlessed)
{
	local INT64 haveItemNum;
	local ItemInfo tempItemInfo;

	tempItemInfo = GetItemInfoByClassID(ClassID);
	if((ClassID == -800))
	{
		return getInstanceUIData().GetCurrentVitalityPoint();
	}
	if(!IsStackableItem(tempItemInfo.ConsumeType))
	{
		haveItemNum = INT64(GetNonStackableInvenItemNum(ClassID, Enchanted, isBlessed, false));
	}
	else
	{
		haveItemNum = GetInventoryItemCount(tempItemInfo.Id);
	}
	return haveItemNum;
}

function int FindItemByClassID(int ClassID, out array<ItemInfo> itemInfoArray, optional EItemLockedCheckType LockType, optional bool bUseExceptionEnsoul)
{
	local int i, ItemCount;
	local array<ItemInfo> tmpItemArray;

	ItemCount = Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(ClassID, tmpItemArray);
	if((int(LockType) == 0))
	{
		return ItemCount;
	}
	i = 0;
	while((i < ItemCount))
	{
		if((((int(LockType) == 1) && tmpItemArray[i].bSecurityLock) || ((int(LockType) == 2) && !tmpItemArray[i].bSecurityLock)))
		{
			if(bUseExceptionEnsoul)
			{
				if(hasEnsoulOption(tmpItemArray[i]))
				{
					i++;
					continue;
				}
			}
			itemInfoArray.Length = (itemInfoArray.Length + 1);
			itemInfoArray[(itemInfoArray.Length - 1)] = tmpItemArray[i];
		}
		i++;
	}
	return itemInfoArray.Length;
}

function bool FindItemByServerID(int ServerID, out ItemInfo ServeritemInfo, optional EItemLockedCheckType LockType)
{
	local ItemInfo tmpItem;

	Class'NWindow.UIDATA_INVENTORY'.static.FindItem(ServerID, tmpItem);
	if((((int(LockType) == 0) || ((int(LockType) == 1) && tmpItem.bSecurityLock)) || ((int(LockType) == 2) && !tmpItem.bSecurityLock)))
	{
		ServeritemInfo = tmpItem;
	}
	if((ServeritemInfo.ItemNum < INT64(1)))
	{
		return false;
	}
	return true;
}

function ItemboxUpdate(ItemWindowHandle hItemWnd, int iInvenLimit)
{
	local int iCount, iItemCount, iAddedCount, iDeletedCount;
	local ItemInfo kClearItem, kCurItem;

	kClearItem.IconName = "L2ui_ct1.emptyBtn";
	ClearItemID(kClearItem.Id);
	iItemCount = hItemWnd.GetItemNum();
	if((iItemCount < iInvenLimit))
	{
		iAddedCount = (iInvenLimit - iItemCount);
		iCount = 0;
		while((iCount < iAddedCount))
		{
			hItemWnd.AddItem(kClearItem);
			iCount++;
		}
	}
	else if((iItemCount > iInvenLimit))
	{
		iDeletedCount = (iItemCount - iInvenLimit);
		iCount = (hItemWnd.GetItemNum() - 1);
		while((iCount >= 0))
		{
			if((iDeletedCount > 0))
			{
				hItemWnd.GetItem(iCount, kCurItem);
				if(!IsValidItemID(kCurItem.Id))
				{
					hItemWnd.DeleteItem(iCount);
					iDeletedCount--;
				}
				if((iDeletedCount <= 0))
				{
					break;
				}
			}
			iCount--;
		}
	}
	return;
}

function windowAnchorToSide(WindowHandle mainWindow, WindowHandle subWindow, optional int addX, optional int addY)
{
	local Rect pRect, cRect;
	local int currentWidth, currentHeight, setX, setY;

	GetCurrentResolution(currentWidth, currentHeight);
	pRect = mainWindow.GetRect();
	cRect = subWindow.GetRect();
	if((currentWidth > cRect.nWidth))
	{
		setX = ((pRect.nX + pRect.nWidth) + 5);
		setY = pRect.nY;
		if((setX > (currentWidth - cRect.nWidth)))
		{
			subWindow.SetAnchor(mainWindow.GetWindowName(), "TopLeft", "TopLeft", -(cRect.nWidth + addX), addY);
		}
		else
		{
			subWindow.SetAnchor(mainWindow.GetWindowName(), "TopLeft", "TopLeft", (pRect.nWidth + addX), addY);
		}
	}
	return;
}

function fixWindowLocOverResolution(string currentWindowName, optional int addX, optional int addY)
{
	local Rect pRect;
	local int currentWidth, currentHeight, setX, setY;

	GetCurrentResolution(currentWidth, currentHeight);
	pRect = GetWindowHandle(currentWindowName).GetRect();
	setX = pRect.nX;
	setY = pRect.nY;
	if((currentWidth > pRect.nWidth))
	{
		if(((pRect.nX + pRect.nWidth) > currentWidth))
		{
			setX = ((currentWidth - pRect.nWidth) - addX);
		}
		else if((pRect.nX < 0))
		{
			setX = addX;
		}
	}
	if((currentHeight > pRect.nHeight))
	{
		if(((pRect.nY + pRect.nHeight) > currentHeight))
		{
			setY = ((currentHeight - pRect.nHeight) - addY);
		}
		else if((pRect.nY < 0))
		{
			setY = (0 - addY);
		}
	}
	GetWindowHandle(currentWindowName).MoveTo(setX, setY);
	return;
}

function syncWindowLoc(string currentWindowName, string windowNamesStr, optional int addX, optional int addY)
{
	local array<string> windowNameArray;
	local Rect tempRect;
	local int i;

	Split(windowNamesStr, ",", windowNameArray);
	if((windowNameArray.Length <= 1))
	{
		windowNameArray[0] = windowNamesStr;
	}
	tempRect = GetWindowHandle(currentWindowName).GetRect();
	i = 0;
	while((i < windowNameArray.Length))
	{
		if((currentWindowName != windowNameArray[i]))
		{
			GetWindowHandle(windowNameArray[i]).MoveTo((tempRect.nX + addX), (tempRect.nY + addY));
		}
		i++;
	}
	return;
}

function syncWindowLocAuto(string windowNamesStr)
{
	local array<string> windowNameArray;
	local Rect tempRect;
	local int i;
	local bool bFindWindow;

	Split(windowNamesStr, ",", windowNameArray);
	if((windowNameArray.Length <= 1))
	{
		windowNameArray[0] = windowNamesStr;
	}
	i = 0;
	while((i < windowNameArray.Length))
	{
		if(GetWindowHandle(windowNameArray[i]).IsShowWindow())
		{
			tempRect = GetWindowHandle(windowNameArray[i]).GetRect();
			bFindWindow = true;
			break;
		}
		i++;
	}
	if(bFindWindow)
	{
		i = 0;
		while((i < windowNameArray.Length))
		{
			GetWindowHandle(windowNameArray[i]).MoveTo(tempRect.nX, tempRect.nY);
			i++;
		}
	}
	return;
}

function hideGroupWindow(string currentWindowName, string windowNamesStr)
{
	local array<string> windowNameArray;
	local int i;

	Split(windowNamesStr, ",", windowNameArray);
	if((windowNameArray.Length <= 1))
	{
		windowNameArray[0] = windowNamesStr;
	}
	i = 0;
	while((i < windowNameArray.Length))
	{
		if((currentWindowName != windowNameArray[i]))
		{
			GetWindowHandle(windowNameArray[i]).HideWindow();
		}
		i++;
	}
	return;
}

function string getLootingString(int Id)
{
	switch(Id)
	{
		case 0:
			return GetSystemString(487);
			break;
		case 1:
			return GetSystemString(488);
			break;
		case 2:
			return GetSystemString(798);
			break;
		case 3:
			return GetSystemString(799);
			break;
		case 4:
			return GetSystemString(800);
			break;
		default:
			break;
	}
}

function ItemWIndow_ItemMoveByIndex(ItemWindowHandle itemWnd1, ItemWindowHandle itemWnd2, int itemWnd1_Index, optional bool useAddStackableItem)
{
	local ItemInfo tempInfo, tmItem;
	local int ItemCount, i;
	local bool HasItem;

	itemWnd1.GetItem(itemWnd1_Index, tempInfo);
	if((tempInfo.Id.ClassID > 0))
	{
		if((IsStackableItem(tempInfo.ConsumeType) && useAddStackableItem))
		{
			ItemCount = itemWnd2.GetItemNum();
			i = 0;
			while((i < ItemCount))
			{
				if(itemWnd2.GetItem(i, tmItem))
				{
					if((tempInfo.Id.ClassID == tmItem.Id.ClassID))
					{
						tmItem.ItemNum = (tempInfo.ItemNum + tmItem.ItemNum);
						itemWnd2.SetItem(i, tmItem);
						HasItem = true;
						break;
					}
				}
				i++;
			}
			if((HasItem == false))
			{
				itemWnd2.AddItem(tempInfo);
			}
		}
		else
		{
			itemWnd2.AddItem(tempInfo);
		}
		itemWnd1.DeleteItem(itemWnd1_Index);
	}
	else
	{
		Debug("Error: L2Util ItemWIndow_ItemMoveByIndex -> Wrong Index ");
	}
	return;
}

function int ItemWIndow_ItemMoveByItemID(ItemWindowHandle itemWnd1, ItemWindowHandle itemWnd2, ItemID IdInfo)
{
	local ItemInfo tempInfo;
	local int Index;

	Index = ItemWIndow_searchItemByItemID(itemWnd1, IdInfo);
	if((Index > -1))
	{
		itemWnd1.GetItem(Index, tempInfo);
		itemWnd2.AddItem(tempInfo);
		itemWnd1.DeleteItem(Index);
	}
	return Index;
}

function int ItemWIndow_searchItemByItemID(ItemWindowHandle ItemWnd, ItemID IdInfo)
{
	local int i, returnN;
	local ItemInfo tempInfo;

	returnN = -1;
	i = 0;
	while((i < ItemWnd.GetItemNum()))
	{
		ItemWnd.GetItem(i, tempInfo);
		if((IdInfo == tempInfo.Id))
		{
			returnN = i;
			break;
		}
		i++;
	}
	return returnN;
}

function textBox_setToolTipWithShortString(TextBoxHandle textBox, string Context, optional int wTextField)
{
	local int textWidth, textHeight, wTextWidth, hTextHeight;

	textBox.GetWindowSize(wTextWidth, hTextHeight);
	GetTextSize(Context, "GameDefault", textWidth, textHeight);
	if((textWidth > wTextWidth))
	{
		textBox.SetTooltipType("text");
		textBox.SetTooltipText(Context);
		Context = makeShortStringByPixel(Context, ((wTextWidth - 8) + wTextField), "..");
	}
	textBox.SetText(Context);
	return;
}

function setWindowMoveToCenter(WindowHandle mainWindow)
{
	local Rect pRect;
	local int currentWidth, currentHeight, setX, setY;

	GetCurrentResolution(currentWidth, currentHeight);
	pRect = mainWindow.GetRect();
	currentWidth = (currentWidth / 2);
	currentHeight = (currentHeight / 2);
	setX = (currentWidth - (pRect.nWidth / 2));
	setY = (currentHeight - (pRect.nHeight / 2));
	mainWindow.MoveTo(setX, setY);
	return;
}

function childWindowMoveToCenter(WindowHandle mainWindow, WindowHandle subWindow)
{
	local Rect pRect, cRect;
	local int currentWidth, currentHeight, setX, setY;

	GetCurrentResolution(currentWidth, currentHeight);
	pRect = mainWindow.GetRect();
	cRect = subWindow.GetRect();
	setX = ((pRect.nX + (pRect.nWidth / 2)) - (cRect.nWidth / 2));
	setY = ((pRect.nY + (pRect.nHeight / 2)) - (cRect.nHeight / 2));
	if((setX > (currentWidth - cRect.nWidth)))
	{
		setX = (currentWidth - cRect.nWidth);
	}
	else if((setX < 0))
	{
		setX = 0;
	}
	if((setY > (currentHeight - cRect.nHeight)))
	{
		setY = (currentHeight - cRect.nHeight);
	}
	subWindow.ClearAnchor();
	subWindow.Move(0, 0);
	subWindow.MoveTo(setX, setY);
	return;
}

function windowMoveToSide(WindowHandle mainWindow, WindowHandle subWindow, optional int OffsetX, optional int OffsetY)
{
	local Rect pRect, cRect;
	local int currentWidth, currentHeight, setX, setY;

	GetCurrentResolution(currentWidth, currentHeight);
	pRect = mainWindow.GetRect();
	cRect = subWindow.GetRect();
	if((currentWidth > cRect.nWidth))
	{
		setX = (((pRect.nX + pRect.nWidth) + 5) + OffsetX);
		setY = pRect.nY;
		if((setX > (currentWidth - cRect.nWidth)))
		{
			setX = ((pRect.nX - (cRect.nWidth + 5)) - OffsetX);
		}
		else if((setX < 0))
		{
			setX = 0;
		}
		subWindow.ClearAnchor();
		subWindow.Move(0, 0);
		subWindow.MoveTo(setX, (setY + OffsetY));
	}
	return;
}

function int GetQuestLevelForID(int QuestID)
{
	local int i;
	local QuestTreeWnd scQuestTree;

	scQuestTree = QuestTreeWnd(GetScript("QuestTreeWnd"));
	i = (scQuestTree.ArrQuest.Length - 1);
	while((i >= 0))
	{
		if((QuestID == scQuestTree.ArrQuest[i].QuestID))
		{
			return scQuestTree.ArrQuest[i].Level;
		}
		i--;
	}
	return 0;
}

function string GetCastleIconName(int castleID)
{
	switch(castleID)
	{
		case 1:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Gludio";
		case 2:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Dion";
		case 3:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Giran";
		case 4:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Oren";
		case 5:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Aden";
		case 6:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Innadril";
		case 7:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Godard";
		case 8:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Rune";
		case 9:
			return "L2UI_CT1.ChatWindow.ChatCastleMark_Shuttegart";
		default:
			return "";
	}
}

function string GetCastleMinIconName(int castleID)
{
	switch(castleID)
	{
		case 3:
			return "L2UI_CT1.SiegeMercenaryWnd_CastleMark_Giran";
		case 7:
			return "L2UI_CT1.SiegeMercenaryWnd_CastleMark_Godard";
		default:
			return "";
	}
}

function string GetClastleButtonIconName(int castleID, optional bool bEntry)
{
	switch(castleID)
	{
		case 1:
			if(!bEntry)
			{
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Gludio";
			}
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Gludio";
		case 2:
			if(!bEntry)
			{
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Dion";
			}
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Dion";
		case 3:
			if(!bEntry)
			{
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Giran";
			}
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Giran";
		case 4:
			if(!bEntry)
			{
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Oren";
			}
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Oren";
		case 5:
			if(!bEntry)
			{
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Aden";
			}
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Aden";
		case 6:
			if(!bEntry)
			{
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Innadril";
			}
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Innadril";
		case 7:
			if(!bEntry)
			{
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Godard";
			}
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Godard";
		case 8:
			if(!bEntry)
			{
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Rune";
			}
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Rune";
		case 9:
			if(!bEntry)
			{
				return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Shuttegart";
			}
			return "L2UI_ct1.SiegeWnd.SiegeWnd_CastleMark_Entry_Shuttegart";
		default:
			return "";
	}
}

function showGfxScreenMessage(string Msg, optional int Type, optional bool bUseAddsystemMessageString, optional string TextColor)
{
	local string strParam;

	ParamAdd(strParam, "Msg", Msg);
	ParamAdd(strParam, "type", string(Type));
	if((TextColor != ""))
	{
		ParamAdd(strParam, "textColor", TextColor);
	}
	CallGFxFunction("GfxScreenMessage", "showMessage", strParam);
	if(bUseAddsystemMessageString)
	{
		AddSystemMessageString(Msg);
	}
	return;
}

function ShowGFxMiniMapSelectedPin(MapPinType Type, Vector XYZ, string tooltip0, optional string tooltip1)
{
	local string param;

	if((((XYZ.X == 0.0000000) && (XYZ.Y == 0.0000000)) && (XYZ.Z == 0.0000000)))
	{
		return;
	}
	param = "";
	ParamAdd(param, "type", string(Type));
	ParamAdd(param, "X", string(XYZ.X));
	ParamAdd(param, "Y", string(XYZ.Y));
	ParamAdd(param, "Z", string(XYZ.Z));
	ParamAdd(param, "tooltip0", tooltip0);
	ParamAdd(param, "tooltip1", tooltip1);
	CallGFxFunction("MiniMapGFxWnd", "ShowGFxMiniMapSelectedPin", param);
	return;
}

function HideGFxMiniMapSelectedPin(MapPinType Type)
{
	CallGFxFunction("MiniMapGFxWnd", "HideGFxMiniMapSelectedPin", string(Type));
	return;
}

function AddGFxMiniMapArea(string WindowName, Vector XYZ, Color rgb, optional int CircleType, optional int Id)
{
	local string param;

	if((((XYZ.X == 0.0000000) && (XYZ.Y == 0.0000000)) && (XYZ.Z == 0.0000000)))
	{
		return;
	}
	param = "";
	ParamAdd(param, "windowName", WindowName);
	ParamAdd(param, "X", string(XYZ.X));
	ParamAdd(param, "Y", string(XYZ.Y));
	ParamAdd(param, "Z", string(XYZ.Z));
	ParamAdd(param, "CircleType", string(CircleType));
	ParamAdd(param, "id", string(Id));
	ParamAdd(param, "color", string(ColorToInt(rgb)));
	ParamAdd(param, "alpha", string(rgb.A));
	CallGFxFunction("MiniMapGFxWnd", "AddMiniMapArea", param);
	return;
}

function DelGFxMiniMapArea(string WindowName, optional int Id)
{
	local string param;

	param = "";
	ParamAdd(param, "windowName", WindowName);
	ParamAdd(param, "id", string(Id));
	CallGFxFunction("MiniMapGFxWnd", "DelMiniMapArea", param);
	return;
}

function ShowHighLightMapIcon(Vector XYZ, int OffsetX, int OffsetY, optional bool notToTown)
{
	local string param;

	if((((XYZ.X == 0.0000000) && (XYZ.Y == 0.0000000)) && (XYZ.Z == 0.0000000)))
	{
		return;
	}
	param = "";
	ParamAdd(param, "x", string(XYZ.X));
	ParamAdd(param, "y", string(XYZ.Y));
	ParamAdd(param, "z", string(XYZ.Z));
	ParamAdd(param, "offsetX", string(OffsetX));
	ParamAdd(param, "offsetY", string(OffsetY));
	ParamAdd(param, "notToTown", string(int(notToTown)));
	CallGFxFunction("MiniMapGFxWnd", "ShowHighLightMapIcon", param);
	return;
}

function int ColorToInt(Color rgb)
{
	local int colorInt;

	colorInt = int(rgb.R);
	colorInt = ((colorInt << 8) + int(rgb.G));
	return ((colorInt << 8) + int(rgb.B));
}

function Color IntToColor(int colorValue)
{
	local int R, G, B;

	B = ((colorValue >> 16) & 255);
	G = ((colorValue >> 8) & 255);
	R = (colorValue & 255);
	Debug(("r" @ string(R)));
	Debug(("g" @ string(G)));
	Debug(("b" @ string(B)));
	return GetColor(R, G, B, 255);
}

function INT64 Get9999Percent(INT64 pntCnt, INT64 pntMax)
{
	local INT64 ninenienienie;

	ninenienienie = (pntMax * 0.9999000);
	if(((pntCnt > ninenienienie) && (pntCnt < pntMax)))
	{
		return ninenienienie;
	}
	return pntCnt;
}

function string GetPlayerType(int playerClassID, int nRace)
{
	local int nOriginalClassID;

	nOriginalClassID = Class'NWindow.UIDataManager'.static.GetRootClassID(playerClassID);
	if(((nRace == 4) && !IsShineMakerClass(nOriginalClassID)))
	{
		return "soldier";
	}
	if((nRace == 5))
	{
		return "soldier";
	}
	if((nRace == 30))
	{
		return "fighter";
	}
	if(IsDeathKnightClass(nOriginalClassID))
	{
		return "deathKnight";
	}
	if(IsDeathFighterClass(nOriginalClassID))
	{
		return "Live_deathKnight";
	}
	if(IsOrcRiderClass(nOriginalClassID))
	{
		return "vanguard";
	}
	if(IsAssassinClass(nOriginalClassID))
	{
		return "assassin";
	}
	if(IsShineMakerClass(nOriginalClassID))
	{
		return "magician";
	}
	if(IsWereWolfClass(nOriginalClassID))
	{
		return "werewolf";
	}
	if(IsRoseVainClass(nOriginalClassID))
	{
		return "rosevain";
	}
	if(IsWakerClass(nOriginalClassID))
	{
		return "waker";
	}
	switch(nOriginalClassID)
	{
		case 10:
		case 25:
		case 38:
		case 49:
		case 183:
		case 231:
		case 236:
			return "magician";
		default:
			return "soldier";
	}
}

static function string GetFullPath(WindowHandle currentHandle)
{
	local string WindowName, parentname;

	if((currentHandle == none))
	{
		return "";
	}
	WindowName = currentHandle.GetWindowName();
	if(((WindowName == "Console") || (WindowName == "Worksheet")))
	{
		return "";
	}
	parentname = GetFullPath(currentHandle.GetParentWindowHandle());
	if((parentname == ""))
	{
		return WindowName;
	}
	return ((parentname $ ".") $ WindowName);
}

static function GetSkill2ItemInfo(SkillInfo sInfo, out ItemInfo iInfo)
{
	iInfo.Id.ClassID = sInfo.SkillID;
	iInfo.Level = sInfo.SkillLevel;
	iInfo.SubLevel = sInfo.SkillSubLevel;
	iInfo.Name = sInfo.SkillName;
	if((sInfo.EnchantName != "none"))
	{
		iInfo.AdditionalName = sInfo.EnchantName;
	}
	iInfo.IconName = sInfo.TexName;
	iInfo.IconPanel = sInfo.IconPanel;
	iInfo.IconPanel2 = sInfo.IconPanel2;
	iInfo.Description = sInfo.SkillDesc;
	iInfo.Grade = byte(sInfo.Grade);
	iInfo.ShortcutType = 2;
	iInfo.ItemType = 1;
	return;
}

static function bool GetEllipsisString(out string Str, int textWidth)
{
	local string fixedString;
	local int nWidth, nHeight;
	local L2Util l2utilScr;

	l2utilScr = getInstanceL2Util();
	l2utilScr.GetTextSizeDefault(Str, nWidth, nHeight);
	if((nWidth <= textWidth))
	{
		return false;
	}
	l2utilScr.GetTextSizeDefault("...", nWidth, nHeight);
	fixedString = l2utilScr.DivideStringWithWidth(Str, (textWidth - nWidth));
	if((fixedString != Str))
	{
		Str = (fixedString $ "...");
		return true;
	}
	return false;
}

static function bool GetEllipsisStringWithAdd(out string Str, out string addtional, int textWidth)
{
	local string fixedString;
	local int nWidth, nHeight, nNameWidth, nNameHeight, nAddWidth, nAddHeight, nFullWidth;
	local L2Util l2utilScr;

	l2utilScr = getInstanceL2Util();
	l2utilScr.GetTextSizeDefault(Str, nNameWidth, nNameHeight);
	l2utilScr.GetTextSizeDefault(addtional, nAddWidth, nAddHeight);
	l2utilScr.GetTextSizeDefault("...", nWidth, nHeight);
	nFullWidth = (nNameWidth + nAddWidth);
	if((nFullWidth <= textWidth))
	{
		return false;
	}
	if((nFullWidth > textWidth))
	{
		if((Len(addtional) < 1))
		{
			Str = l2utilScr.DivideStringWithWidth(Str, (textWidth - nWidth));
			Str = (Str $ "...");
		}
		else if((nNameWidth > textWidth))
		{
			addtional = "";
			Str = l2utilScr.DivideStringWithWidth(Str, (textWidth - nWidth));
			Str = (Str $ "...");
		}
		else
		{
			addtional = l2utilScr.DivideStringWithWidth(addtional, ((textWidth - nWidth) - nNameWidth));
			addtional = (addtional $ "...");
		}
	}
	return false;
}

static function bool SetEllipsisTextBox(TextBoxHandle tbh, optional int MaxW)
{
	local string Str;
	local Rect rectWnd;

	if((MaxW == 0))
	{
		rectWnd = tbh.GetRect();
		MaxW = rectWnd.nWidth;
	}
	Str = tbh.GetText();
	if(Class'InterfaceClassic.L2Util'.static.GetEllipsisString(Str, MaxW))
	{
		tbh.SetTooltipType("text");
		tbh.SetTooltipCustomType(getInstanceL2Util().MakeTooltipSimpleText(tbh.GetText()));
		tbh.SetText(Str);
		return true;
	}
	tbh.SetTooltipCustomType(getInstanceL2Util().MakeTooltipSimpleText(""));
	return false;
}

function bool isRefinery(out ItemInfo item)
{
	if((((item.RefineryOp1 != 0) || (item.RefineryOp2 != 0)) || (item.RefineryOp3 != 0)))
	{
		return true;
	}
	return false;
}

function Color GetRelicTextColor(UIConstants.ERelicGrade Grade)
{
	local Color relicColor;

	if(getInstanceUIData().GetIsLiveServer())
	{
		switch(Grade)
		{
			case RG_A:
				relicColor = GetColor(182, 93, 255, 255);
				break;
			case RG_B:
				relicColor = GetColor(244, 116, 116, 255);
				break;
			case RG_C:
				relicColor = GetColor(142, 166, 255, 255);
				break;
			case RG_D:
				relicColor = GetColor(146, 209, 124, 255);
				break;
			case RG_N:
				relicColor = GetColor(182, 162, 142, 255);
				break;
			default:
				break;
		}
	}
	else
	{
		switch(Grade)
		{
			case RG_R:
				relicColor = GetColor(255, 212, 64, 255);
				break;
			case RG_S:
				relicColor = GetColor(182, 93, 255, 255);
				break;
			case RG_A:
				relicColor = GetColor(244, 116, 116, 255);
				break;
			case RG_B:
				relicColor = GetColor(142, 166, 255, 255);
				break;
			case RG_C:
				relicColor = GetColor(227, 139, 53, 255);
				break;
			case RG_D:
				relicColor = GetColor(146, 209, 124, 255);
				break;
			case RG_N:
				relicColor = GetColor(180, 180, 180, 255);
				break;
			default:
				break;
		}
	}
	return relicColor;
}

function int GetDollGradeStringId(UIConstants.ERelicGrade Grade)
{
	local int StringID;

	switch(Grade)
	{
		case RG_R:
			StringID = 14694;
			break;
		case RG_S:
			StringID = 14693;
			break;
		case RG_A:
			StringID = 14692;
			break;
		case RG_B:
			StringID = 14691;
			break;
		case RG_C:
			StringID = 14690;
			break;
		case RG_D:
			StringID = 14689;
			break;
		case RG_N:
			StringID = 14688;
			break;
		default:
			break;
	}
	return StringID;
}

function int GetRelicGradeStringId(UIConstants.ERelicGrade Grade)
{
	local int StringID;

	switch(Grade)
	{
		case RG_A:
			StringID = 14868;
			break;
		case RG_B:
			StringID = 14869;
			break;
		case RG_C:
			StringID = 14870;
			break;
		case RG_D:
			StringID = 14871;
			break;
		case RG_N:
			StringID = 2622;
			break;
		default:
			break;
	}
	return StringID;
}

function Color GetItemScoreGradeColor(int Grade)
{
	local Color itemScoreColor;

	switch(Grade)
	{
		case 6:
			itemScoreColor = GetColor(182, 93, 255, 255);
			break;
		case 5:
			itemScoreColor = GetColor(244, 116, 116, 255);
			break;
		case 4:
			itemScoreColor = GetColor(142, 166, 255, 255);
			break;
		case 3:
			itemScoreColor = GetColor(227, 139, 53, 255);
			break;
		case 2:
			itemScoreColor = GetColor(146, 209, 124, 255);
			break;
		case 1:
			itemScoreColor = GetColor(180, 180, 180, 255);
			break;
		default:
			itemScoreColor = GetColor(180, 180, 180, 255);
			break;
	}
	return itemScoreColor;
}

function string GetDollNameWithGrade(string dollName, UIConstants.ERelicGrade Grade)
{
	local string resultName;
	local int gradeStrId;

	resultName = dollName;
	gradeStrId = GetDollGradeStringId(Grade);
	if((gradeStrId > 0))
	{
		resultName = (GetSystemString(gradeStrId) @ resultName);
	}
	return resultName;
}

function Color GetItemTextColor(int NameClass)
{
	local Color itemColor;

	switch(NameClass)
	{
		case 0:
			itemColor = GetColor(137, 137, 137, 255);
			break;
		case 1:
			itemColor = GetColor(230, 230, 230, 255);
			break;
		case 2:
			itemColor = GetColor(255, 251, 4, 255);
			break;
		case 3:
			itemColor = GetColor(240, 68, 68, 255);
			break;
		case 4:
			itemColor = GetColor(33, 164, 255, 255);
			break;
		case 5:
			itemColor = GetColor(255, 0, 255, 255);
			break;
		default:
			break;
	}
	return itemColor;
}

function int GetPetEvolveStepStringId(UIEventManager.EPetType PetType, int EvolveStep)
{
	local int StringID;

	if((int(PetType) == 0))
	{
		switch(EvolveStep)
		{
			case 0:
				StringID = 14811;
				break;
			case 1:
				StringID = 14812;
				break;
			case 2:
				StringID = 14813;
				break;
			default:
				break;
		}
	}
	else if((int(PetType) == 1))
	{
		switch(EvolveStep)
		{
			case 0:
				StringID = 14814;
				break;
			case 1:
				StringID = 14815;
				break;
			case 2:
				StringID = 14816;
				break;
			default:
				break;
		}
	}
	return StringID;
}

function string MakeDecimalPointString(string numStr, int decimal, optional bool useCutZero, optional bool addPercentStr)
{
	local string resultStr;
	local int i, StrLen;

	resultStr = numStr;
	StrLen = Len(resultStr);
	if((StrLen <= decimal))
	{
		i = 0;
		while((i <= (decimal - StrLen)))
		{
			resultStr = ("0" $ resultStr);
			i++;
		}
	}
	resultStr = ((Left(resultStr, (Len(resultStr) - decimal)) $ ".") $ Right(resultStr, decimal));
	if(useCutZero)
	{
		resultStr = cutZeroDecimalStr(resultStr);
	}
	if(addPercentStr)
	{
		resultStr = (resultStr $ "%");
	}
	return resultStr;
}

function int _GetItemDisplayType(int ItemClassID)
{
	switch(ItemClassID)
	{
		case 57:
			return 0;
		case 15623:
		case 15624:
		case 82500:
		case 15625:
		case 15627:
		case 15628:
		case 15629:
		case 15630:
		case 15631:
		case 15632:
		case 15633:
		case 47130:
			return 1;
		case 95641:
		case 82940:
			return 2;
		case 45638:
		case 34983:
		case 15626:
			return 9;
		default:
			return -1;
	}
}

function string _GetItemDisplayStringByClassID(int ClassID, INT64 Amount)
{
	local int DisplayType;

	DisplayType = _GetItemDisplayType(ClassID);
	_GetItemDisplayString(DisplayType, Amount);
}

function string _GetItemDisplayString(int DisplayType, INT64 Amount)
{
	switch(DisplayType)
	{
		case 0:
			return MakeFullSystemMsg(GetSystemMessage(2932), MakeCostString(string(Amount)));
			break;
		case 1:
			return MakeCostString(string(Amount));
			break;
		case 2:
			return MakeFullSystemMsg(GetSystemMessage(13405), MakeCostString(string(Amount)));
			break;
		case 9:
			return "";
			break;
		default:
			break;
	}
	return MakeFullSystemMsg(GetSystemMessage(1983), MakeCostString(string(Amount)));
}

function int _GetTextBoxHeight(TextBoxHandle txtWnd, string Text)
{
	local int nWidth, nHeight, DEFAULTHEIGHT, i, descHeight, j;
	local string sNextStringWithWidth;
	local array<string> stringTextes;

	GetTextSizeDefault(Text, nWidth, DEFAULTHEIGHT);
	txtWnd.GetWindowSize(nWidth, nHeight);
	Split(Text, "\\n", stringTextes);
	Debug((string(stringTextes.Length) @ Text));
	i = 1;
	j = 0;
	while((j < stringTextes.Length))
	{
		Text = stringTextes[j];
		if((Text == ""))
		{
			j++;
			continue;
		}
		sNextStringWithWidth = DivideStringWithWidth(Text, nWidth);
		while((sNextStringWithWidth != ""))
		{
			sNextStringWithWidth = NextStringWithWidth(nWidth);
			i++;
		}
		j++;
	}
	descHeight = (i * (DEFAULTHEIGHT + 1));
	return descHeight;
}
