class ArtifactEnchantSubWnd extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle SubWnd_Item1;
var WindowHandle DescriptionMsgWnd;
var TextBoxHandle Inventory_Title_TextBox;
var TextBoxHandle descTextBox;
var InventoryWnd inventoryWndScript;
var ArtifactEnchantWnd ArtifactEnchantWndScript;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	ArtifactEnchantWndScript = ArtifactEnchantWnd(GetScript("ArtifactEnchantWnd"));
	Me = GetWindowHandle("ArtifactEnchantSubWnd");
	Inventory_Title_TextBox = GetTextBoxHandle("ArtifactEnchantSubWnd.Inventory_Title_TextBox");
	SubWnd_Item1 = GetItemWindowHandle("ArtifactEnchantSubWnd.SubWnd_Item1");
	DescriptionMsgWnd = GetWindowHandle("ArtifactEnchantSubWnd.DescriptionMsgWnd");
	descTextBox = GetTextBoxHandle("ArtifactEnchantSubWnd.DescriptionMsgWnd.descTextBox");
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	return;
}

function OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

function OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;

	SubWnd_Item1.GetItem(Index, Info);
	if((Info.Id.ClassID > 0))
	{
		ArtifactEnchantWndScript.dropProcess(Info);
	}
	return;
}

function SetEnable(bool bFlag)
{
	if(bFlag)
	{
		DescriptionMsgWnd.HideWindow();
	}
	else
	{
		DescriptionMsgWnd.ShowWindow();
	}
	return;
}

function bool isInArtifactGroup(out array<int> materialIDArray, int targetClassID)
{
	local int i;

	i = 0;
	while((i < materialIDArray.Length))
	{
		if((materialIDArray[i] == targetClassID))
		{
			return true;
		}
		i++;
	}
	return false;
}

function syncInventory(int ArtifactGroupID, int reqMinEnchantedNum)
{
	local array<ItemInfo> itemarray;
	local array<int> materialIDArray;
	local array<ItemInfo> artifactItemArray;
	local int i;
	local bool bDoNotNeedGroupID;
	local int tmGroupID, MaterialCount, ResultProb;

	SubWnd_Item1.Clear();
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllArtifactItem(itemarray);
	if((ArtifactGroupID == -1))
	{
		bDoNotNeedGroupID = true;
	}
	Class'NWindow.UIDATA_ARTIFACT'.static.GetArtifactMaterialGroupList(ArtifactGroupID, materialIDArray);
	Debug(("bDoNotNeedGroupID:" @ string(bDoNotNeedGroupID)));
	Debug(("reqMinEnchantedNum" @ string(reqMinEnchantedNum)));
	i = 0;
	while((i < itemarray.Length))
	{
		MaterialCount = 0;
		if((((!ArtifactEnchantWndScript.externalCheckUsingItem(itemarray[i]) && !itemarray[i].bSecurityLock) && (isInArtifactGroup(materialIDArray, itemarray[i].Id.ClassID) || bDoNotNeedGroupID)) && ((itemarray[i].Enchanted == reqMinEnchantedNum) || (-1 == reqMinEnchantedNum))))
		{
			if((ArtifactEnchantWndScript.getSlot(0).GetItemNum() == 0))
			{
				Class'NWindow.UIDATA_ARTIFACT'.static.GetArtifactEnchantCondition(itemarray[i].Id.ClassID, itemarray[i].Enchanted, tmGroupID, MaterialCount, ResultProb);
				if((MaterialCount <= 0))
				{
					i++;
					continue;
				}
			}
			artifactItemArray[artifactItemArray.Length] = itemarray[i];
		}
		i++;
	}
	if((artifactItemArray.Length > 0))
	{
		SortAttifactItemAndAddITem(artifactItemArray);
		descTextBox.SetText("");
	}
	else
	{
		descTextBox.SetText(GetSystemMessage(4222));
	}
	if((SubWnd_Item1.GetItemNum() > 0))
	{
		SetEnable(true);
	}
	else
	{
		SetEnable(false);
	}
	return;
}

function SortAttifactItemAndAddITem(array<ItemInfo> ArtifactList)
{
	local int i;
	local array<ItemInfo> ArtifactListNormal, ArtifactListType1, ArtifactListType2, ArtifactListType3;

	ArtifactList = getInstanceL2Util().sortByEnchanted(ArtifactList);
	ArtifactList = getInstanceL2Util().sortByName(ArtifactList);
	i = 0;
	while((i < ArtifactList.Length))
	{
		switch(ArtifactList[i].SlotBitType)
		{
			case INT64(4194304):
				ArtifactListType1[ArtifactListType1.Length] = ArtifactList[i];
				break;
			case INT64(33554432):
				ArtifactListType2[ArtifactListType2.Length] = ArtifactList[i];
				break;
			case INT64(268435456):
				ArtifactListType3[ArtifactListType3.Length] = ArtifactList[i];
				break;
			case INT64(1024):
				ArtifactListNormal[ArtifactListNormal.Length] = ArtifactList[i];
				break;
			default:
				break;
		}
		i++;
	}
	SubWnd_Item1.Clear();
	i = 0;
	while((i < ArtifactListType1.Length))
	{
		SubWnd_Item1.AddItem(ArtifactListType1[i]);
		i++;
	}
	i = 0;
	while((i < ArtifactListType2.Length))
	{
		SubWnd_Item1.AddItem(ArtifactListType2[i]);
		i++;
	}
	i = 0;
	while((i < ArtifactListType3.Length))
	{
		SubWnd_Item1.AddItem(ArtifactListType3[i]);
		i++;
	}
	i = 0;
	while((i < ArtifactListNormal.Length))
	{
		SubWnd_Item1.AddItem(ArtifactListNormal[i]);
		i++;
	}
	return;
}
