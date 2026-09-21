class ArtifactItemListWnd extends UICommonAPI;

const ROOTNAME = "root";

struct ArtifactSkillInfoStruct
{
	var ItemID Id;
	var int SkillID;
	var int Level;
	var string Name;
	var string IconName;
	var string IconPanel;
	var string Description;
	var int ArtifactType;
	var int ArtifactPage;
	var INT64 SlotBitType;
	var int MaxSkillLevel;
	var INT64 ItemNum;
};

var WindowHandle Me;
var string m_Windowname;
var WindowHandle ArtifactItemListDisable_Wnd;
var ButtonHandle m_CloseButton;
var TreeHandle MainTree;
var bool bListLoaded;
var TreeHandle subTree;
var string expenedNode;
var TextBoxHandle ArtifactNameText;
var TextureHandle ArtifactItemListWnd_InfoItem;
var bool isLoaded;

function OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	InitHandleCOD();
	SetClosingOnESC();
	return;
}

function OnShow()
{
	StartTreeWnd();
	isLoaded = true;
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		default:
			ClickTreeNode(strID);
			break;
	}
	return;
}

function InitHandleCOD()
{
	Me = GetWindowHandle(m_Windowname);
	MainTree = GetTreeHandle((m_Windowname $ ".MainTree"));
	subTree = GetTreeHandle((m_Windowname $ ".subTree"));
	ArtifactNameText = GetTextBoxHandle((m_Windowname $ ".ArtifactNameText"));
	ArtifactItemListWnd_InfoItem = GetTextureHandle((m_Windowname $ ".ArtifactItemListWnd_InfoItem"));
	ArtifactItemListDisable_Wnd = GetWindowHandle((m_Windowname $ ".ArtifactItemListDisable_Wnd"));
	return;
}

function Clear()
{
	ArtifactItemListDisable_Wnd.ShowWindow();
	MainTree.Clear();
	subTree.Clear();
	ArtifactItemListWnd_InfoItem.SetTexture("");
	ArtifactNameText.SetText("");
	return;
}

function StartTreeWnd()
{
	Clear();
	MakeItemList();
	return;
}

function MakeItemList()
{
	local array<ArtifactUIData> ArtifactUIDataList;
	local array<ArtifactSkillInfoStruct> artifactSkillInfoList;
	local ArtifactSkillInfoStruct artifactSkillInfo;
	local int i;

	MakeRootNodes();
	Class'NWindow.UIDATA_ARTIFACT'.static.GetAllArtifactData(ArtifactUIDataList);
	i = 0;
	while((i < ArtifactUIDataList.Length))
	{
		artifactSkillInfo = ArtifactUIDataToArtifactSkillInfoStruct(ArtifactUIDataList[i]);
		artifactSkillInfoList[artifactSkillInfoList.Length] = artifactSkillInfo;
		i++;
	}
	artifactSkillInfoList = SortByItemHad(artifactSkillInfoList);
	MakeNodes(artifactSkillInfoList);
	return;
}

function array<ArtifactSkillInfoStruct> SortByItemHad(array<ArtifactSkillInfoStruct> ArtifactUIDataList)
{
	local int i;
	local array<ArtifactSkillInfoStruct> tmpArtifactUIDataList;

	i = 0;
	while((i < ArtifactUIDataList.Length))
	{
		if((ArtifactUIDataList[i].ItemNum > INT64(0)))
		{
			tmpArtifactUIDataList[tmpArtifactUIDataList.Length] = ArtifactUIDataList[i];
		}
		i++;
	}
	i = 0;
	while((i < ArtifactUIDataList.Length))
	{
		if((ArtifactUIDataList[i].ItemNum == INT64(0)))
		{
			tmpArtifactUIDataList[tmpArtifactUIDataList.Length] = ArtifactUIDataList[i];
		}
		i++;
	}
	return tmpArtifactUIDataList;
}

function ArtifactSkillInfoStruct ArtifactUIDataToArtifactSkillInfoStruct(ArtifactUIData ArtifactData)
{
	local ArtifactSkillInfoStruct artifactSkillInfo;
	local SkillInfo SkillInfo;
	local ItemInfo Info;
	local InventoryWnd inventoryWndScript;

	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	Info = GetItemInfoByClassID(ArtifactData.ArtifactItemID);
	GetSkillInfo(ArtifactData.EnchantSkillID, (Info.Enchanted + 1), 0, SkillInfo);
	artifactSkillInfo.Name = SkillInfo.SkillName;
	artifactSkillInfo.Level = SkillInfo.SkillLevel;
	artifactSkillInfo.IconName = SkillInfo.TexName;
	artifactSkillInfo.IconPanel = SkillInfo.IconPanel;
	artifactSkillInfo.Description = SkillInfo.SkillDesc;
	artifactSkillInfo.SkillID = SkillInfo.SkillID;
	artifactSkillInfo.Id = Info.Id;
	artifactSkillInfo.SlotBitType = Info.SlotBitType;
	artifactSkillInfo.MaxSkillLevel = ArtifactData.MaxSkillLevel;
	artifactSkillInfo.ItemNum = inventoryWndScript.getItemCountByClassID(Info.Id.ClassID);
	return artifactSkillInfo;
}

function MakeRootNodes()
{
	local XMLTreeNodeInfo infNode;

	infNode.strName = "root";
	MainTree.InsertNode("root", infNode);
	InsertExpandNode(GetSystemString(3891), string(INT64(4194304)));
	InsertExpandNode(GetSystemString(3892), string(INT64(33554432)));
	InsertExpandNode(GetSystemString(3893), string(INT64(268435456)));
	InsertExpandNode(GetSystemString(3894), string(INT64(1024)));
	return;
}

function string InsertExpandNode(string Title, string SlotBitType)
{
	local string NodeName;
	local Color NameColor;

	NameColor.R = 220;
	NameColor.G = 220;
	NameColor.B = 220;
	NameColor.A = 255;
	NodeName = (("root" $ ".") $ SlotBitType);
	getInstanceL2Util().TreeHandleInsertExpandBtnNode(MainTree, SlotBitType, "root", , , , , , , , 7);
	TreeHandleInsertTextNodeItem(MainTree, NodeName, Title, 2, 1, NameColor, true);
	return NodeName;
}

function MakeNodes(array<ArtifactSkillInfoStruct> artifactSkillInfos)
{
	local int i, nameOffsetY, enchantOffsetX;
	local string strNodeName, ellipsedString;
	local int ArtifactType;
	local Color enchantedColor, NameColor, cantEnchantColor, numColor, nameColorDisabled;
	local array<int> nodeNums;
	local bool isFirstNode, CanEnchant, haveItem;

	enchantedColor.R = 170;
	enchantedColor.G = 108;
	enchantedColor.B = 231;
	enchantedColor.A = 255;
	NameColor.R = 221;
	NameColor.G = 221;
	NameColor.B = 221;
	NameColor.A = 255;
	nameColorDisabled.R = 182;
	nameColorDisabled.G = 182;
	nameColorDisabled.B = 182;
	nameColorDisabled.A = 255;
	cantEnchantColor.R = 166;
	cantEnchantColor.G = 47;
	cantEnchantColor.B = 49;
	cantEnchantColor.A = 255;
	numColor.R = 255;
	numColor.G = 221;
	numColor.B = 102;
	numColor.A = 255;
	nodeNums.Length = 4;
	i = 0;
	while((i < artifactSkillInfos.Length))
	{
		ArtifactType = ArtifactTypeBySlotBitType(artifactSkillInfos[i].SlotBitType);
		if((ArtifactType == -1))
		{
			i++;
			continue;
		}
		isFirstNode = (nodeNums[ArtifactType] == 0);
		ellipsedString = GetEllipsisString(artifactSkillInfos[i].Name, 285);
		if((ellipsedString != artifactSkillInfos[i].Name))
		{
			strNodeName = makeNode(string(artifactSkillInfos[i].Id.ClassID), (("root" $ ".") $ string(artifactSkillInfos[i].SlotBitType)), isFirstNode, artifactSkillInfos[i].Name);
		}
		else
		{
			strNodeName = makeNode(string(artifactSkillInfos[i].Id.ClassID), (("root" $ ".") $ string(artifactSkillInfos[i].SlotBitType)), isFirstNode, "");
		}
		if(isFirstNode)
		{
			TreeInsertBlankNodeItem(MainTree, strNodeName, 5);
		}
		if(((float(nodeNums[ArtifactType]) % 2.0000000) == 0.0000000))
		{
			getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, "L2UI_CT1.EmptyBtn", 333, 38);
		}
		else
		{
			getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, "L2UI_CH3.etc.textbackline", 333, 38, , , , , 14);
		}
		getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, "L2UI_CT1.ItemWindow.ItemWindow_DF_SlotBox_Default", 36, 36, -333, 1);
		getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, artifactSkillInfos[i].IconName, 32, 32, -34, 2);
		getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, artifactSkillInfos[i].IconPanel, 32, 32, -32, 2);
		CanEnchant = (artifactSkillInfos[i].MaxSkillLevel > 1);
		haveItem = (artifactSkillInfos[i].ItemNum > INT64(0));
		if(!haveItem)
		{
			getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, "L2UI_CT1.ItemWindow.ItemWindow_IconDisable", 32, 32, -32, 2);
			NameColor = nameColorDisabled;
			enchantOffsetX = 37;
		}
		else
		{
			enchantOffsetX = 4;
		}
		if((CanEnchant && !haveItem))
		{
			nameOffsetY = 13;
		}
		else
		{
			nameOffsetY = 4;
		}
		TreeHandleInsertTextNodeItem(MainTree, strNodeName, ellipsedString, 4, nameOffsetY, NameColor, false);
		if(haveItem)
		{
			TreeHandleInsertTextNodeItem(MainTree, strNodeName, ("x" $ string(artifactSkillInfos[i].ItemNum)), 38, -17, numColor, true, true);
		}
		if(!CanEnchant)
		{
			TreeHandleInsertTextNodeItem(MainTree, strNodeName, (("(" $ GetSystemString(3896)) $ ")"), enchantOffsetX, -17, cantEnchantColor, true, !haveItem);
		}
		nodeNums[ArtifactType]++;
		if(MainTree.IsExpandedNode(strNodeName))
		{
			SetSubDetailInfo(artifactSkillInfos[i].Id.ClassID);
			MakeSubTree(artifactSkillInfos[i].Id.ClassID);
		}
		i++;
	}
	if(!isLoaded)
	{
		ExpandNodes();
	}
	return;
}

function string makeNode(string NodeName, string parentname, bool isFirstNode, optional string ToolTipString)
{
	local XMLTreeNodeInfo infNode, infNodeClear;

	infNode = infNodeClear;
	infNode.bShowButton = 0;
	infNode.strName = NodeName;
	infNode.bFollowCursor = true;
	infNode.nOffSetX = 2;
	infNode.nTexExpandedOffSetX = 0;
	if(isFirstNode)
	{
		infNode.nTexExpandedOffSetY = 5;
	}
	else
	{
		infNode.nTexExpandedOffSetY = 0;
	}
	infNode.nTexExpandedHeight = 36;
	infNode.nTexExpandedRightWidth = 0;
	infNode.nTexExpandedLeftUWidth = 1;
	infNode.nTexExpandedLeftUHeight = 36;
	infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	infNode.ToolTip = MakeTooltipSimpleText(ToolTipString);
	return MainTree.InsertNode(parentname, infNode);
}

function ExpandNodes()
{
	MainTree.SetExpandedNode((("root" $ ".") $ string(INT64(1024))), true);
	MainTree.SetExpandedNode((("root" $ ".") $ string(INT64(4194304))), true);
	MainTree.SetExpandedNode((("root" $ ".") $ string(INT64(33554432))), true);
	MainTree.SetExpandedNode((("root" $ ".") $ string(INT64(268435456))), true);
	return;
}

function TreeInsertBlankNodeItem(TreeHandle tree, string NodeName, int gabY)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.b_nHeight = gabY;
	tree.InsertNodeItem(NodeName, infNodeItem);
	return;
}

function TreeHandleInsertTextNodeItem(TreeHandle tree, string NodeName, string ItemName, int OffsetX, int OffsetY, Color C, bool oneline, optional bool bLineBreak)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.nOffSetX = OffsetX;
	infNodeItem.nOffSetY = OffsetY;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.t_color.R = C.R;
	infNodeItem.t_color.G = C.G;
	infNodeItem.t_color.B = C.B;
	infNodeItem.t_color.A = C.A;
	tree.InsertNodeItem(NodeName, infNodeItem);
	return;
}

function ClickTreeNode(string Name)
{
	local array<string> Result;

	if((expenedNode == Name))
	{
		MainTree.SetExpandedNode(expenedNode, true);
		return;
	}
	Split(Name, ".", Result);
	if((Result.Length < 3))
	{
		return;
	}
	MainTree.SetFocus();
	if((expenedNode != ""))
	{
		MainTree.SetExpandedNode(expenedNode, false);
	}
	expenedNode = Name;
	SetSubDetailInfo(int(Result[2]));
	MakeSubTree(int(Result[2]));
	return;
}

function SetSubDetailInfo(int cID)
{
	local ItemInfo Info;

	Info = GetItemInfoByClassID(cID);
	ArtifactNameText.SetText(Info.Name);
	ArtifactItemListWnd_InfoItem.SetTexture(Info.IconName);
	ArtifactItemListDisable_Wnd.HideWindow();
	return;
}

function MakeSubTree(int cID)
{
	local ArtifactUIData ArtifactData;
	local int i, j, ItemNum;
	local SkillInfo SkillInfo;
	local string strNodeName;
	local Color NameColor, enchantedColor, numColor;
	local array<ItemInfo> artifactItemArray, artifactItemArraySameClassID;
	local InventoryWnd inventoryWndScript;

	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	NameColor.R = 220;
	NameColor.G = 220;
	NameColor.B = 220;
	NameColor.A = 255;
	enchantedColor.R = 170;
	enchantedColor.G = 108;
	enchantedColor.B = 231;
	enchantedColor.A = 255;
	numColor.R = 255;
	numColor.G = 221;
	numColor.B = 102;
	numColor.A = 255;
	subTree.Clear();
	makeSubRootNode();
	Class'NWindow.UIDATA_ARTIFACT'.static.FindArtifactData(cID, ArtifactData);
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllArtifactItem(artifactItemArray);
	i = 0;
	while((i < artifactItemArray.Length))
	{
		if((artifactItemArray[i].Id.ClassID == cID))
		{
			artifactItemArraySameClassID[artifactItemArraySameClassID.Length] = artifactItemArray[i];
		}
		i++;
	}
	artifactItemArray = inventoryWndScript.GetArtifactEquipedList(0);
	i = 0;
	while((i < artifactItemArray.Length))
	{
		if((artifactItemArray[i].Id.ClassID == cID))
		{
			artifactItemArraySameClassID[artifactItemArraySameClassID.Length] = artifactItemArray[i];
		}
		i++;
	}
	artifactItemArray = inventoryWndScript.GetArtifactEquipedList(1);
	i = 0;
	while((i < artifactItemArray.Length))
	{
		if((artifactItemArray[i].Id.ClassID == cID))
		{
			artifactItemArraySameClassID[artifactItemArraySameClassID.Length] = artifactItemArray[i];
		}
		i++;
	}
	artifactItemArray = inventoryWndScript.GetArtifactEquipedList(2);
	i = 0;
	while((i < artifactItemArray.Length))
	{
		if((artifactItemArray[i].Id.ClassID == cID))
		{
			artifactItemArraySameClassID[artifactItemArraySameClassID.Length] = artifactItemArray[i];
		}
		i++;
	}
	i = 0;
	while((i < ArtifactData.MaxSkillLevel))
	{
		ItemNum = 0;
		GetSkillInfo(ArtifactData.EnchantSkillID, (i + 1), 0, SkillInfo);
		strNodeName = MakeSubNode(string(cID), "root");
		if((i != 0))
		{
			TreeInsertBlankNodeItem(subTree, strNodeName, 16);
		}
		TreeHandleInsertTextNodeItem(subTree, strNodeName, ("+" $ string(i)), 0, 0, enchantedColor, true);
		j = 0;
		while((j < artifactItemArraySameClassID.Length))
		{
			if((artifactItemArraySameClassID[j].Enchanted == i))
			{
				ItemNum++;
			}
			j++;
		}
		if((ItemNum > 0))
		{
			TreeHandleInsertTextNodeItem(subTree, strNodeName, GetEllipsisString(SkillInfo.SkillName, 235), 4, 0, NameColor, true);
			TreeHandleInsertTextNodeItem(subTree, strNodeName, ("x" $ string(ItemNum)), 4, 0, numColor, true);
		}
		else
		{
			TreeHandleInsertTextNodeItem(subTree, strNodeName, GetEllipsisString(SkillInfo.SkillName, 250), 4, 0, NameColor, true);
		}
		getInstanceL2Util().TreeHandleInsertTextNodeItem(subTree, strNodeName, GetEllipsisString(SkillInfo.SkillDesc, 250), 22, 0, COLOR_GOLD, true, true);
		i++;
	}
	return;
}

function makeSubRootNode()
{
	local XMLTreeNodeInfo infNode;

	infNode.strName = "root";
	subTree.InsertNode("root", infNode);
	return;
}

function string MakeSubNode(string NodeName, string parentname)
{
	local XMLTreeNodeInfo infNode;

	infNode.strName = NodeName;
	infNode.bShowButton = 0;
	subTree.InsertNode(parentname, infNode);
	return (("root" $ ".") $ NodeName);
}

function int ArtifactTypeBySlotBitType(INT64 SlotBitType)
{
	switch(SlotBitType)
	{
		case INT64(4194304):
			return 0;
		case INT64(33554432):
			return 1;
		case INT64(268435456):
			return 2;
		case INT64(1024):
			return 3;
		default:
			return -1;
	}
}

function INT64 ArtifactSlotBitTypeByType(int Type)
{
	switch(Type)
	{
		case 0:
			return INT64(4194304);
		case 1:
			return INT64(33554432);
		case 2:
			return INT64(268435456);
		case 3:
			return INT64(1024);
		default:
			return INT64(-1);
	}
}

function string GetEllipsisString(string Str, int MaxWidth)
{
	local string fixedString;
	local int nWidth, nHeight, textWidth;

	textWidth = MaxWidth;
	GetTextSizeDefault((Str $ "..."), nWidth, nHeight);
	if((nWidth < textWidth))
	{
		return Str;
	}
	fixedString = DivideStringWithWidth(Str, textWidth);
	if((fixedString != Str))
	{
		fixedString = (fixedString $ "...");
	}
	return fixedString;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
