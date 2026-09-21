class UITreeTest extends UICommonAPI;

var string ROOTNAME;
var string nodePath;
var WindowHandle Me;
var UITreeUtil treeInstance1;
var UITreeUtil treeInstance2;
var UITreeUtil treeInstance3;
var UITreeUtil treeInstance4;
var UITreeUtil treeInstance5;
var UITreeUtil treeInstance6;

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
	Me = GetWindowHandle("UITreeTest");
	ROOTNAME = "root";
	treeInstance1 = new Class'Interface.UITreeUtil';
	treeInstance2 = new Class'Interface.UITreeUtil';
	treeInstance3 = new Class'Interface.UITreeUtil';
	treeInstance4 = new Class'Interface.UITreeUtil';
	treeInstance5 = new Class'Interface.UITreeUtil';
	treeInstance6 = new Class'Interface.UITreeUtil';
	return;
}

function OnShow()
{
	test1();
	test2();
	test3();
	test4();
	test5();
	test6();
	return;
}

function test1()
{
	local int i;

	treeInstance1._InitTree(GetTreeHandle("UITreeTest.NTreeCtrl"));
	treeInstance1._makeNodeRoot(ROOTNAME);
	i = 1;
	while((i < 10))
	{
		nodePath = treeInstance1._makeExpandBtnNode(ROOTNAME, ("list" $ string(i)));
		treeInstance1._makeTextItem(nodePath, ("리스트" $ string(i)), 7, 0, GTColor().White);  // EN?: List
		nodePath = treeInstance1._makeSelectNode(((ROOTNAME $ ".list") $ string(i)), (("list" $ string(i)) $ "_1"), 0, 0, 18);
		treeInstance1._makeTextureItem(nodePath, "L2UI_CH3.BloodHoodWnd.BloodHood_Logon", 31, 11, 10, 3);
		treeInstance1._makeTextItem(nodePath, "test1", 7, 0, GTColor().Green, false, false);
		nodePath = treeInstance1._makeSelectNode(((ROOTNAME $ ".list") $ string(i)), (("list" $ string(i)) $ "_2"), 0, 0, 18, , , , 32, 38, "L2UI_CH3.etc.IconSelect1");
		treeInstance1._makeTextureItem(nodePath, "L2UI_CH3.BloodHoodWnd.BloodHood_Logon", 31, 11, 10, 3);
		treeInstance1._makeTextItem(nodePath, "test2", 7, 0, GTColor().Green, false, false);
		i++;
	}
	return;
}

function test2()
{
	local int i;

	treeInstance2._InitTree(GetTreeHandle("UITreeTest.NTreeCtrl1"));
	treeInstance2._makeNodeRoot(ROOTNAME);
	i = 1;
	while((i < 20))
	{
		nodePath = treeInstance2._makeEmptyNode(ROOTNAME, ("list" $ string(i)), , , , MakeTooltipSimpleText("냠냠 짭짭"));  // EN?: Yum, yum, salty salts.
		treeInstance2._makeTextureItem(nodePath, Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID((1070 + i))), 32, 32, 10, 3);
		treeInstance2._makeTextItem(nodePath, Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID((1070 + i))), 7, 0, GTColor().Yellow);
		treeInstance2._makeTextItem(nodePath, Class'NWindow.UIDATA_ITEM'.static.GetItemDescription(GetItemID((1070 + i))), 7, 0, GTColor().White, false, true);
		treeInstance2._makeTextureItem(nodePath, "", 0, 10, 0, 0, false, true);
		i++;
	}
	return;
}

function test3()
{
	local int i;

	treeInstance3._InitTree(GetTreeHandle("UITreeTest.NTreeCtrl2"));
	treeInstance3._makeNodeRoot(ROOTNAME);
	nodePath = treeInstance3._makeEmptyNode(ROOTNAME, "list1");
	treeInstance3._makeTextItem(nodePath, "장비 목록", 7, 0, GTColor().Green);  // EN?: Refresh device list
	treeInstance3._makeTextItem(nodePath, "(수치)", , 0, GTColor().Blue);  // EN?: Numerical Equivalent
	treeInstance3._makeBlankItem(nodePath, 2);
	treeInstance3._makeCrossLineItem(nodePath);
	treeInstance3._makeBlankItem(nodePath, 2);
	treeInstance3._makeTextItem(nodePath, "목록 시작!", , 0, GTColor().Yellow);  // EN?: Start list
	treeInstance3._makeCrossLineItem(nodePath, 10);
	i = 0;
	while((i < 30))
	{
		treeInstance3._makeTextItem(nodePath, ("장비" $ string(i)), 0, 0, GTColor().White, false, true);  // EN?: equipment.
		treeInstance3._makeTextItem(nodePath, "(+300)", , 0, GTColor().Yellow);
		treeInstance3._makeTextureItem(nodePath, "L2UI_CT1.RankingWnd.RankingWnd_ArrowUp", 8, 8, 0, 0);
		i++;
	}
	return;
}

function test4()
{
	local int i;

	treeInstance4._InitTree(GetTreeHandle("UITreeTest.NTreeCtrl3"));
	treeInstance4._makeNodeRoot(ROOTNAME);
	i = 1;
	while((i < 10))
	{
		nodePath = treeInstance4._makeSelectNode(ROOTNAME, ("r" $ string(i)), 0, 0, 18);
		treeInstance4._makeTextureItem(nodePath, "L2UI_CT1.ProductInventory.ProductInventory_GiftIcon", 16, 16, 10, 3);
		treeInstance4._makeTextItem(nodePath, ("메뉴" $ string(i)), 7, 0, GTColor().White);  // EN?: Menu
		i++;
	}
	return;
}

function test5()
{
	treeInstance5._InitTree(GetTreeHandle("UITreeTest.NTreeCtrl4"));
	treeInstance5._makeNodeRoot(ROOTNAME);
	return;
}

function test6()
{
	local int i, ItemClassID;
	local Rect R;
	local ItemInfo Info;

	treeInstance6._InitTree(GetTreeHandle("UITreeTest.NTreeCtrl5"));
	treeInstance6._makeNodeRoot(ROOTNAME);
	R = GetTreeHandle("UITreeTest.NTreeCtrl5").GetRect();
	if(getInstanceUIData().GetIsLiveServer())
	{
		ItemClassID = 82888;
	}
	else
	{
		ItemClassID = 49709;
	}
	i = ItemClassID;
	while((i < (ItemClassID + 10)))
	{
		Info = GetItemInfoByClassID(i);
		nodePath = treeInstance6._makeEmptyNode(ROOTNAME, ("list" $ string(i)));
		treeInstance6._makeTextureItem(nodePath, "L2UI_CT1.EmptyBtn", R.nWidth, 32, 0, 0, , , , , , , , i);
		treeInstance6._makeTextureItem(nodePath, Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(i)), 32, 32, -R.nWidth, 0, , , , , , , , , i);
		treeInstance6._makeTextureItem(nodePath, Info.ForeTexture, 32, 32, -32, 0, , , , , , , , , i);
		treeInstance6._makeTextureItem(nodePath, Info.IconPanel, 32, 32, -32, 0, , , , , , , , , i);
		treeInstance6._makeTextureItem(nodePath, Info.IconPanel2, 32, 32, -32, 0, , , , , , , , , i);
		treeInstance6._makeTextItem(nodePath, makeShortStringByPixel(Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(i)), ((R.nWidth - 32) - 38), ".."), 5, 0, GTColor().White, , , , , , i);
		treeInstance6._makeBlankItem(nodePath, 1);
		treeInstance6._makeTextItem(nodePath, Info.AdditionalName, (32 + 5), -16, GTColor().Yellow, , , , , , i);
		treeInstance6._makeBlankItem(nodePath, 4);
		i++;
	}
	return;
}

function OnClickButton(string Name)
{
	Debug(("Name" @ Name));
	if((Name == "root.list1"))
	{
		if((treeInstance3.getMapStringReserved(Name) == "on"))
		{
			treeInstance3._SetNodeItemTexture((ROOTNAME $ ".list1"), 111, "L2UI_CT1.RankingWnd.RankingWnd_ArrowDown", 8, 8);
			treeInstance3.setMapStringReserved((ROOTNAME $ ".list1"), "off");
		}
		else
		{
			treeInstance3._SetNodeItemTexture((ROOTNAME $ ".list1"), 111, "L2UI_CT1.RankingWnd.RankingWnd_ArrowUp", 8, 8);
			treeInstance3.setMapStringReserved((ROOTNAME $ ".list1"), "on");
		}
	}
	switch(Right(Name, 2))
	{
		case "r1":
		case "r2":
			treeInstance1._ClickSelectNode(Name);
			Debug(("tree Name" @ Name));
			break;
		default:
			break;
	}
	return;
}
