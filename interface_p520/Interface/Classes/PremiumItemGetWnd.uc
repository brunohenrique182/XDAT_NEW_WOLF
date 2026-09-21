class PremiumItemGetWnd extends UICommonAPI;

const OFFSET_Y_1ST_LINE = 4;
const OFFSET_Y_SECONDLINE = -17;

var int m_iItemNameLength;
var int m_clickedID;
var int m_clickedItemNum;
var int m_maxCount;
var bool m_bDrawBg;
var WindowHandle Me;
var ButtonHandle btnRecieve;
var ButtonHandle btnCancle;
var TreeHandle PremiumItemListTree;
var EditBoxHandle GetnumEdit;

function OnRegisterEvent()
{
	RegisterEvent(3461);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	if((1 == 0))
	{
		Me = GetHandle("PremiumItemGetWnd");
		btnRecieve = ButtonHandle(GetHandle("PremiumItemGetWnd.btnRecieve"));
		btnCancle = ButtonHandle(GetHandle("PremiumItemGetWnd.btnCancle"));
		PremiumItemListTree = TreeHandle(GetHandle("PremiumItemGetWnd.PremiumItemListTree"));
		GetnumEdit = EditBoxHandle(GetHandle("PremiumItemGetWnd.GetNumEdit"));
	}
	else
	{
		Me = GetWindowHandle("PremiumItemGetWnd");
		btnRecieve = GetButtonHandle("PremiumItemGetWnd.btnRecieve");
		btnCancle = GetButtonHandle("PremiumItemGetWnd.btnCancle");
		PremiumItemListTree = GetTreeHandle("PremiumItemGetWnd.PremiumItemListTree");
		GetnumEdit = GetEditBoxHandle("PremiumItemGetWnd.GetNumEdit");
	}
	Clear();
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	return;
}

function Clear()
{
	m_bDrawBg = true;
	m_clickedID = -1;
	m_clickedItemNum = -1;
	btnRecieve.DisableWindow();
	GetnumEdit.Clear();
	return;
}

function createTreeRoot()
{
	local XMLTreeNodeInfo infNode;
	local string strTmp;

	infNode.strName = "PremiumItemListTreeRoot";
	infNode.nOffSetX = 0;
	infNode.nOffSetY = 0;
	strTmp = PremiumItemListTree.InsertNode("", infNode);
	if((Len(strTmp) < 1))
	{
		return;
	}
	return;
}

function OnClickButton(string strID)
{
	local int nowClickedID, nowClickedItemNum, nowEditBoxNum;
	local string removeRootStr;
	local int iLength, SplitCount;
	local array<string> arrSplit;

	iLength = (Len(strID) - Len("PremiumItemListTreeRoot."));
	removeRootStr = Right(strID, iLength);
	switch(strID)
	{
		case "btnRecieve":
			if((m_clickedID != -1))
			{
				nowEditBoxNum = int(GetnumEdit.GetString());
				RequestWithDrawPremiumItem(m_clickedID, INT64(nowEditBoxNum));
				if((m_maxCount == 1))
				{
					Me.HideWindow();
				}
				return;
			}
			break;
		case "btnCancle":
			Me.HideWindow();
			return;
			break;
		default:
			break;
	}
	SplitCount = Split(removeRootStr, ".", arrSplit);
	if(((SplitCount < 0) || (SplitCount > 2)))
	{
		return;
	}
	nowClickedID = int(arrSplit[0]);
	nowClickedItemNum = int(arrSplit[1]);
	if((m_clickedID == nowClickedID))
	{
		m_clickedID = -1;
		m_clickedItemNum = 1;
		btnRecieve.DisableWindow();
		GetnumEdit.Clear();
	}
	else
	{
		m_clickedID = nowClickedID;
		m_clickedItemNum = nowClickedItemNum;
		GetnumEdit.SetString(("" $ string(nowClickedItemNum)));
		btnRecieve.EnableWindow();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3461:
			clearInfo();
			PremiumItemListTree.Clear();
			if(!IsShowWindow("PremiumItemGetWnd"))
			{
				ShowWindowWithFocus("PremiumItemGetWnd");
			}
			HandlePremiumItemList(param);
			break;
		default:
			break;
	}
	return;
}

function HandlePremiumItemList(string param)
{
	local int i, iItemCount, iGift, iItemClassID;
	local INT64 iItemAmount;
	local string senderCharacter;

	Clear();
	createTreeRoot();
	iItemCount = 0;
	ParseInt(param, "ItemCount", iItemCount);
	m_maxCount = iItemCount;
	i = 0;
	while((i < iItemCount))
	{
		ParseInt(param, ("Gift_" $ string(i)), iGift);
		ParseInt(param, ("ItemClassID_" $ string(i)), iItemClassID);
		ParseINT64(param, ("ItemAmount_" $ string(i)), iItemAmount);
		ParseString(param, ("SenderCharacter_" $ string(i)), senderCharacter);
		AddPremiumListItem(iGift, iItemClassID, iItemAmount, senderCharacter, i);
		i++;
	}
	return;
}

function AddPremiumListItem(int iGift, int iItemClassID, INT64 iItemAmount, string senderCharacter, int iIndexID)
{
	local XMLTreeNodeInfo infNode;
	local XMLTreeNodeItemInfo infNodeItem;
	local XMLTreeNodeInfo infNodeClear;
	local XMLTreeNodeItemInfo infNodeItemClear;
	local string strRetName;
	local ItemID mItemID;
	local string strIconName, strName;
	local UserInfo myInfo;

	infNode = infNodeClear;
	infNode.strName = ((("" $ string(iIndexID)) $ ".") $ string(iItemAmount));
	infNode.bShowButton = 0;
	GetPlayerInfo(myInfo);
	mItemID.ClassID = iItemClassID;
	strIconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(mItemID);
	strName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(mItemID);
	infNode.nTexExpandedOffSetX = 0;
	infNode.nTexExpandedOffSetY = 0;
	infNode.nTexExpandedHeight = 38;
	infNode.nTexExpandedRightWidth = 0;
	infNode.nTexExpandedLeftUWidth = 30;
	infNode.nTexExpandedLeftUHeight = 38;
	infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	strRetName = PremiumItemListTree.InsertNode("PremiumItemListTreeRoot", infNode);
	if((Len(strRetName) < 1))
	{
		return;
	}
	if((m_bDrawBg == true))
	{
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureUHeight = 14;
		infNodeItem.u_nTextureWidth = 341;
		infNodeItem.u_nTextureHeight = 38;
		infNodeItem.u_strTexture = "L2UI_CH3.etc.textbackline";
		PremiumItemListTree.InsertNodeItem(strRetName, infNodeItem);
		m_bDrawBg = false;
	}
	else
	{
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 341;
		infNodeItem.u_nTextureHeight = 38;
		infNodeItem.u_strTexture = "L2UI_CT1.EmptyBtn";
		PremiumItemListTree.InsertNodeItem(strRetName, infNodeItem);
		m_bDrawBg = true;
	}
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = (-341 + 1);
	infNodeItem.nOffSetY = 2;
	infNodeItem.u_nTextureWidth = 36;
	infNodeItem.u_nTextureHeight = 36;
	infNodeItem.u_strTexture = "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2";
	PremiumItemListTree.InsertNodeItem(strRetName, infNodeItem);
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = (-36 + 2);
	infNodeItem.nOffSetY = 3;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	infNodeItem.u_strTexture = strIconName;
	PremiumItemListTree.InsertNodeItem(strRetName, infNodeItem);
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ((strName $ " X ") $ string(iItemAmount));
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 7;
	infNodeItem.nOffSetY = 5;
	PremiumItemListTree.InsertNodeItem(strRetName, infNodeItem);
	if((((iGift != 0) && (Len(senderCharacter) > 0)) && (InStr(senderCharacter, myInfo.Name) < 0)))
	{
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = (((("[" $ GetSystemString(1740)) $ " ") $ senderCharacter) $ "]");
		infNodeItem.bLineBreak = true;
		infNodeItem.t_bDrawOneLine = true;
		infNodeItem.nOffSetX = 43;
		infNodeItem.nOffSetY = (-38 + 21);
		infNodeItem.t_color.R = 163;
		infNodeItem.t_color.G = 163;
		infNodeItem.t_color.B = 163;
		infNodeItem.t_color.A = 255;
		PremiumItemListTree.InsertNodeItem(strRetName, infNodeItem);
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PremiumItemGetWnd");
	return;
}

function clearInfo()
{
	m_bDrawBg = true;
	return;
}
