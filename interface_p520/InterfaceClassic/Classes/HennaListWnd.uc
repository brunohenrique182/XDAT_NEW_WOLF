class HennaListWnd extends UICommonAPI;

const HENNA_EQUIP = 1;

var int m_iState;
var int m_iRootNameLength;
var bool m_bDrawBg;

function OnRegisterEvent()
{
	RegisterEvent(1640);
	RegisterEvent(1650);
	RegisterEvent(1671);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	m_bDrawBg = true;
	return;
}

function OnShow()
{
	GetTextBoxHandle("HennaListWnd.NonItem_txt").ShowWindow();
	return;
}

function OnHide()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "HennaInfoWnd");
	return;
}

function OnClickButton(string strID)
{
	local string strHennaID;

	switch(strID)
	{
		case "EXIT_Btn":
			OnReceivedCloseUI();
			break;
		default:
			strHennaID = Mid(strID, (m_iRootNameLength + 1));
			if((m_iState == 1))
			{
				RequestHennaItemInfo(int(strHennaID));
				Debug(("RequestHennaItemInfo " @ strHennaID));
			}
			break;
	}
	return;
}

function Clear()
{
	Class'NWindow.UIAPI_TREECTRL'.static.Clear("HennaListWnd.HennaListTree");
	return;
}

function OnEvent(int Event_ID, string param)
{
	local INT64 iAdena;
	local string strName, strIconName, strDescription;
	local int iHennaID, iClassID;
	local INT64 iNum, iNeedCount;

	if(!getInstanceUIData().GetIsClassicServer())
	{
		return;
	}
	switch(Event_ID)
	{
		case 1640:
			m_iState = 1;
			Clear();
			ParseINT64(param, "Adena", iAdena);
			ShowHennaListWnd(iAdena);
			break;
		case 1650:
			Debug(("EV_HennaListWndAddHenna : " @ param));
			ParseString(param, "Name", strName);
			ParseString(param, "Description", strDescription);
			ParseString(param, "IconName", strIconName);
			ParseInt(param, "HennaID", iHennaID);
			ParseInt(param, "ClassID", iClassID);
			ParseINT64(param, "NumberOfItem", iNum);
			ParseINT64(param, "NeedCount", iNeedCount);
			AddHennaListItem(strName, strIconName, strDescription, iHennaID, iNum, iNeedCount);
			GetTextBoxHandle("HennaListWnd.NonItem_txt").HideWindow();
			break;
		case 1671:
			OnReceivedCloseUI();
			break;
		default:
			break;
	}
	return;
}

function ShowHennaListWnd(INT64 iAdena)
{
	local XMLTreeNodeInfo infNode;
	local string strTmp;

	if((m_iState == 1))
	{
		setWindowTitleByString(GetSystemString(651));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaListWnd.txtList", GetSystemString(659));
	}
	infNode.strName = "HennaListRoot";
	infNode.nOffSetX = 0;
	infNode.nOffSetY = -3;
	strTmp = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("HennaListWnd.HennaListTree", "", infNode);
	if((Len(strTmp) < 1))
	{
		return;
	}
	m_iRootNameLength = Len(infNode.strName);
	ShowWindow("HennaListWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("HennaListWnd");
	return;
}

function AddHennaListItem(string strName, string strIconName, string strDescription, int iHennaID, INT64 iNum, INT64 iNeedCount)
{
	local XMLTreeNodeInfo infNode;
	local XMLTreeNodeItemInfo infNodeItem;
	local XMLTreeNodeInfo infNodeClear;
	local XMLTreeNodeItemInfo infNodeItemClear;
	local string strRetName;
	local int dyeItemlevel;

	Class'NWindow.UIDATA_HENNA'.static.GetHennaDyeItemLevel(iHennaID, dyeItemlevel);
	infNode = infNodeClear;
	infNode.strName = ("" $ string(iHennaID));
	infNode.bShowButton = 0;
	infNode.nTexExpandedOffSetX = -7;
	infNode.nTexExpandedOffSetY = 8;
	infNode.nTexExpandedHeight = 46;
	infNode.nTexExpandedRightWidth = 0;
	infNode.nTexExpandedLeftUWidth = 32;
	infNode.nTexExpandedLeftUHeight = 40;
	infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	strRetName = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("HennaListWnd.HennaListTree", "HennaListRoot", infNode);
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
		infNodeItem.u_nTextureWidth = 355;
		infNodeItem.u_nTextureHeight = 53;
		infNodeItem.u_strTexture = "L2UI_CH3.etc.textbackline";
		Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
		m_bDrawBg = false;
	}
	else
	{
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 355;
		infNodeItem.u_nTextureHeight = 53;
		infNodeItem.u_strTexture = "L2UI_CT1.EmptyBtn";
		Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
		m_bDrawBg = true;
	}
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -355;
	infNodeItem.nOffSetY = 10;
	infNodeItem.u_nTextureWidth = 36;
	infNodeItem.u_nTextureHeight = 36;
	infNodeItem.u_strTexture = "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2";
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -34;
	infNodeItem.nOffSetY = 11;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	infNodeItem.u_strTexture = strIconName;
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strName;
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 13;
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = MakeFullSystemMsg(GetSystemMessage(5203), string(dyeItemlevel));
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.t_color.R = 222;
	infNodeItem.t_color.G = 147;
	infNodeItem.t_color.B = 3;
	infNodeItem.t_color.A = 255;
	infNodeItem.nOffSetY = 13;
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = (" x" $ string(iNeedCount));
	infNodeItem.bLineBreak = true;
	infNodeItem.nOffSetX = 35;
	infNodeItem.nOffSetY = -24;
	if((iNeedCount <= iNum))
	{
		infNodeItem.t_color = GTColor().White;
	}
	else
	{
		infNodeItem.t_color = GTColor().Red;
	}
	Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("HennaListWnd").HideWindow();
	ShowWindowWithFocus("HennaMenuWnd");
	return;
}
