class RecipeTreeWnd extends UICommonAPI;

const CRYSTAL_TYPE_WIDTH = 14;
const CRYSTAL_TYPE_HEIGHT = 14;

var TreeHandle MainTree;
var array<INT64> itemNeedCount;
var bool m_MultipleProduct;

function OnRegisterEvent()
{
	RegisterEvent(810);
	RegisterEvent(2600);
	RegisterEvent(2610);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	MainTree = GetTreeHandle("RecipeTreeWnd.MainTree");
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 810))
	{
		StartRecipeTreeWnd(param);
	}
	else if(((Event_ID == 2600) || (Event_ID == 2610)))
	{
		HandleInventoryItem(param);
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnClose":
			CloseWindow();
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	return;
}

function CloseWindow()
{
	Clear();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

function Clear()
{
	Class'NWindow.UIAPI_TREECTRL'.static.Clear("RecipeTreeWnd.MainTree");
	return;
}

function StartRecipeTreeWnd(string param)
{
	local int RecipeID, m_AddSuccRate, m_CreateCritical;

	ParseInt(param, "RecipeID", RecipeID);
	ParseInt(param, "AddSuccRate", m_AddSuccRate);
	ParseInt(param, "CreateCritical", m_CreateCritical);
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RecipeTreeWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("RecipeTreeWnd");
	Clear();
	SetRecipeInfo(RecipeID, m_AddSuccRate, m_CreateCritical);
	return;
}

function SetRecipeInfo(int RecipeID, int m_AddSuccRate, int m_CreateCritical)
{
	local string strTmp, strTmp2;
	local int nTmp;
	local XMLTreeNodeInfo infNode;
	local int ProductID;
	local Rect txtNameRect;
	local ItemInfo NewItem;

	ProductID = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ProductID), NewItem);
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("RecipeTreeWnd.texItem");
	Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("RecipeTreeWnd.texItem", NewItem);
	strTmp = MakeFullItemName(ProductID);
	nTmp = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
	strTmp2 = GetItemGradeTextureName(nTmp);
	Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("RecipeTreeWnd.texGrade", strTmp2);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtName", strTmp);
	txtNameRect = GetTextBoxHandle("RecipeTreeWnd.txtName").GetRect();
	if((txtNameRect.nWidth > 150))
	{
		GetTextBoxHandle("RecipeTreeWnd.txtName").SetWindowSize(141, txtNameRect.nHeight);
		GetTextBoxHandle("RecipeTreeWnd.txtName").SetTextEllipsisWidth(141);
	}
	else
	{
		GetTextBoxHandle("RecipeTreeWnd.txtName").SetTextEllipsisWidth(-1);
	}
	GetTextBoxHandle("RecipeTreeWnd.txtName").SetTooltipType("Text");
	GetTextBoxHandle("RecipeTreeWnd.txtName").SetTooltipText(strTmp);
	if(((((((nTmp == 6) || (nTmp == 7)) || (nTmp == 9)) || (nTmp == 10)) || (nTmp == 11)) || (nTmp == 12)))
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("RecipeTreeWnd.texGrade", (14 * 2), 14);
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("RecipeTreeWnd.texGrade", 14, 14);
	}
	nTmp = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtMPConsume", ("" $ string(nTmp)));
	nTmp = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtSuccessRate", (string(nTmp) $ "%"));
	m_MultipleProduct = bool(Class'NWindow.UIDATA_RECIPE'.static.GetRecipeIsMultipleProduct(RecipeID));
	handleAddSuccessNCritical(nTmp, m_AddSuccRate, m_CreateCritical);
	nTmp = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.TxtForgeLevelValue", string(nTmp));
	if(m_MultipleProduct)
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtOption", GetSystemMessage(2320));
	}
	else
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtOption", "");
	}
	infNode.strName = "root";
	infNode.nOffSetX = 1;
	infNode.nOffSetY = 5;
	strTmp = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("RecipeTreeWnd.MainTree", "", infNode);
	if((Len(strTmp) < 1))
	{
		return;
	}
	itemNeedCount.Remove(0, itemNeedCount.Length);
	AddRecipeItem(RecipeID, ProductID, INT64(0), "root");
	return;
}

function setWindowForm(bool bUseCritical)
{
	if(m_MultipleProduct)
	{
		GetTextBoxHandle(("RecipeTreeWnd" $ ".txtCreateCritical")).HideWindow();
		GetTextBoxHandle(("RecipeTreeWnd" $ ".txtCreateCriticalMid")).HideWindow();
		GetTextBoxHandle(("RecipeTreeWnd" $ ".txtCreateCriticalValue")).HideWindow();
		GetWindowHandle("RecipeTreeWnd").SetWindowSize(254, 422);
		GetTextureHandle(("RecipeTreeWnd" $ ".RecipeBg")).SetWindowSize(241, 92);
	}
	else if(bUseCritical)
	{
		GetTextBoxHandle(("RecipeTreeWnd" $ ".txtCreateCritical")).ShowWindow();
		GetTextBoxHandle(("RecipeTreeWnd" $ ".txtCreateCriticalMid")).ShowWindow();
		GetTextBoxHandle(("RecipeTreeWnd" $ ".txtCreateCriticalValue")).ShowWindow();
		GetWindowHandle("RecipeTreeWnd").SetWindowSize(254, 422);
		GetTextureHandle(("RecipeTreeWnd" $ ".RecipeBg")).SetWindowSize(241, 92);
	}
	else
	{
		GetTextBoxHandle(("RecipeTreeWnd" $ ".txtCreateCritical")).HideWindow();
		GetTextBoxHandle(("RecipeTreeWnd" $ ".txtCreateCriticalMid")).HideWindow();
		GetTextBoxHandle(("RecipeTreeWnd" $ ".txtCreateCriticalValue")).HideWindow();
		GetWindowHandle("RecipeTreeWnd").SetWindowSize(254, 407);
		GetTextureHandle(("RecipeTreeWnd" $ ".RecipeBg")).SetWindowSize(241, 77);
	}
	return;
}

function handleAddSuccessNCritical(int m_SuccessRate, int m_AddSuccRate, int m_CreateCritical)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		if((m_SuccessRate == 100))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtAddSuccessRate", "");
		}
		else if(((m_SuccessRate + m_AddSuccRate) <= 100))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtAddSuccessRate", (("+" $ string(m_AddSuccRate)) $ "%"));
		}
		else
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtAddSuccessRate", (("+" $ string((100 - m_SuccessRate))) $ "%"));
		}
		if((m_CreateCritical == 0))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtCreateCriticalValue", GetSystemString(27));
		}
		else
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtCreateCriticalValue", (string(m_CreateCritical) $ "%"));
		}
	}
	setWindowForm(((m_CreateCritical != -1) && getInstanceUIData().GetIsClassicServer()));
	return;
}

function HandleInventoryItem(string param)
{
	local ItemID cID;

	if(!GetWindowHandle("RecipeTreeWnd").IsShowWindow())
	{
		return;
	}
	if(ParseItemID(param, cID))
	{
		findNFixItem(cID.ClassID, "root", -1);
	}
	return;
}

function int findNFixItem(int cID, string strNodeName, int Index)
{
	local string strChildList;
	local array<string> ChildList, ItemList;
	local string TextureName;
	local int i;
	local INT64 nTmp;

	strChildList = MainTree.GetChildNode(strNodeName);
	Split(strChildList, "|", ChildList);
	if((cID <= 0))
	{
		return -1;
	}
	i = 0;
	while((i < ChildList.Length))
	{
		if((ChildList[i] != ""))
		{
			Index++;
			if((strNodeName != "root"))
			{
				Split(ChildList[i], ".", ItemList);
				if((int(ItemList[(ItemList.Length - 1)]) == cID))
				{
					nTmp = GetInventoryItemCount(GetItemID(cID));
					MainTree.SetNodeItemText(ChildList[i], 1, (((("(" $ string(nTmp)) $ "/") $ string(itemNeedCount[Index])) $ ")"));
					if((nTmp < itemNeedCount[Index]))
					{
						TextureName = "Default.ChatBack";
					}
					MainTree.SetNodeItemTexture(ChildList[i], 2, TextureName, 0, 0, 0);
					Class'NWindow.UIAPI_TREECTRL'.static.SetNodeItemTexture("RecipeTreeWnd.MainTree", ChildList[i], 2, TextureName, 0, 0, 0);
				}
			}
			Index = findNFixItem(cID, ChildList[i], Index);
		}
		i++;
	}
	return Index;
}

static function int Split(string strInput, string delim, out array<string> arrToken)
{
	local int arrSize;

	while((InStr(strInput, delim) > 0))
	{
		arrToken.Insert(arrToken.Length, 1);
		arrToken[(arrToken.Length - 1)] = Left(strInput, InStr(strInput, delim));
		strInput = Mid(strInput, (InStr(strInput, delim) + 1));
		arrSize = (arrSize + 1);
	}
	arrToken.Insert(arrToken.Length, 1);
	arrToken[(arrToken.Length - 1)] = strInput;
	arrSize = (arrSize + 1);
	return arrSize;
}

function AddRecipeItem(int RecipeID, int ProductID, INT64 needCount, string NodeName)
{
	local int i, nMax;
	local INT64 nTmp;
	local bool bIamRoot;
	local string strTmp, strTmp2, param, strRetName;
	local array<int> arrMatID;
	local array<INT64> arrMatNeedCount;
	local array<int> arrMatRecipeID;
	local XMLTreeNodeInfo infNode;
	local XMLTreeNodeItemInfo infNodeItem;
	local XMLTreeNodeInfo infNodeClear;
	local XMLTreeNodeItemInfo infNodeItemClear;
	local L2Util util;
	local ItemInfo NewItem;

	util = L2Util(GetScript("L2Util"));
	strTmp = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(ProductID));
	param = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeMaterialItem(RecipeID);
	ParseInt(param, "Count", nMax);
	arrMatID.Length = nMax;
	arrMatNeedCount.Length = nMax;
	arrMatRecipeID.Length = nMax;
	i = 0;
	while((i < nMax))
	{
		ParseInt(param, ("ID_" $ string(i)), arrMatID[i]);
		ParseINT64(param, ("NeededNum_" $ string(i)), arrMatNeedCount[i]);
		ParseInt(param, ("RecipeID_" $ string(i)), arrMatRecipeID[i]);
		i++;
	}
	if((NodeName == "root"))
	{
		bIamRoot = true;
	}
	else
	{
		bIamRoot = false;
	}
	infNode = infNodeClear;
	infNode.strName = ("" $ string(ProductID));
	infNode.ToolTip = MakeTooltipSimpleText(strTmp);
	infNode.bFollowCursor = true;
	if((nMax > 0))
	{
		infNode.bShowButton = 1;
		if(!bIamRoot)
		{
			infNode.nOffSetX = 13;
		}
		infNode.nTexBtnOffSetY = 8;
		infNode.nTexBtnWidth = 15;
		infNode.nTexBtnHeight = 15;
		infNode.strTexBtnExpand = "l2ui_ch3.QuestWnd.QuestWndPlusBtn";
		infNode.strTexBtnCollapse = "l2ui_ch3.QuestWnd.QuestWndMinusBtn";
	}
	else
	{
		infNode.bShowButton = 0;
		infNode.nOffSetX = 30;
	}
	strRetName = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("RecipeTreeWnd.MainTree", NodeName, infNode);
	if((Len(strRetName) < 1))
	{
		Log(("ERROR: Can't insert node. Name: " $ infNode.strName));
		return;
	}
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ProductID), NewItem);
	strTmp2 = NewItem.IconName;
	if((Len(strTmp2) < 1))
	{
		strTmp2 = "Default.BlackTexture";
	}
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	if((nMax > 0))
	{
		util.TreeInsertTextureNodeItem("RecipeTreeWnd.MainTree", strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, -2);
		infNodeItem.nOffSetX = -34;
	}
	else
	{
		util.TreeInsertTextureNodeItem("RecipeTreeWnd.MainTree", strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -2, -2);
		infNodeItem.nOffSetX = -34;
	}
	infNodeItem.nOffSetY = 0;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	infNodeItem.u_strTexture = strTmp2;
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
	util.TreeInsertTextureNodeItem("RecipeTreeWnd.MainTree", strRetName, NewItem.IconPanel, 32, 32, -32);
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -32;
	infNodeItem.nOffSetY = 0;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	if((nMax > 0))
	{
		infNodeItem.u_strTexture = "L2UI.RecipeWnd.RecipeTreeIconBack";
		infNodeItem.u_strTextureExpanded = "L2UI.RecipeWnd.RecipeTreeIconBack_click";
	}
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
	if(!bIamRoot)
	{
		nTmp = GetInventoryItemCount(GetItemID(ProductID));
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = -32;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 32;
		infNodeItem.u_nTextureHeight = 32;
		infNodeItem.t_nTextID = 2;
		if((nTmp < needCount))
		{
			infNodeItem.u_strTexture = "Default.ChatBack";
		}
		Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
	}
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strTmp;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 3;
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
	if(!bIamRoot)
	{
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_nTextID = 1;
		infNodeItem.t_strText = (((("(" $ string(nTmp)) $ "/") $ string(needCount)) $ ")");
		infNodeItem.bLineBreak = true;
		if((nMax > 0))
		{
			infNodeItem.nOffSetX = 51;
		}
		else
		{
			infNodeItem.nOffSetX = 37;
		}
		infNodeItem.nOffSetY = -14;
		Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
	}
	itemNeedCount.Length = (itemNeedCount.Length + 1);
	itemNeedCount[(itemNeedCount.Length - 1)] = needCount;
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.bStopMouseFocus = true;
	if((nMax > 0))
	{
		infNodeItem.b_nHeight = 6;
	}
	else
	{
		infNodeItem.b_nHeight = 4;
	}
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
	i = 0;
	while((i < nMax))
	{
		AddRecipeItem(arrMatRecipeID[i], arrMatID[i], arrMatNeedCount[i], strRetName);
		i++;
	}
	return;
}

function OnReceivedCloseUI()
{
	CloseWindow();
	return;
}
