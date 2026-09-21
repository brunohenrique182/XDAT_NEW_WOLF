class UITreeUtil extends UIEventManager;

var TreeHandle m_UITree;
var string beforeClickedNode;
var UIMapStringObject MapStringReserved;

function _InitTree(TreeHandle tree)
{
	MapStringReserved = new Class'InterfaceClassic.UIMapStringObject';
	MapStringReserved.RemoveAll();
	m_UITree = tree;
	m_UITree.Clear();
	beforeClickedNode = "";
	return;
}

function string _makeNodeRoot(string MakeNodeName, optional int OffsetX, optional int OffsetY)
{
	local XMLTreeNodeInfo infNode;

	infNode.strName = MakeNodeName;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	return m_UITree.InsertNode("", infNode);
}

function string _makeEmptyNode(string parentname, string MakeNodeName, optional bool bFollowCursor, optional int OffsetX, optional int OffsetY, optional CustomTooltip pCustomTooltip)
{
	local XMLTreeNodeInfo infNode;

	infNode.strName = MakeNodeName;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.bFollowCursor = bFollowCursor;
	infNode.ToolTip = pCustomTooltip;
	return m_UITree.InsertNode(parentname, infNode);
}

function string _makeSelectNode(string parentname, string MakeNodeName, optional int OffsetX, optional int OffsetY, optional int nTexExpandedHeight, optional CustomTooltip pCustomTooltip, optional int nTexExpandedOffSetX, optional int nTexExpandedOffSetY, optional int nTexExpandedLeftUWidth, optional int nTexExpandedLeftUHeight, optional string strTexExpandedLeft)
{
	local XMLTreeNodeInfo infNode;

	infNode.ToolTip = pCustomTooltip;
	infNode.strName = MakeNodeName;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.bFollowCursor = true;
	infNode.bShowButton = 0;
	infNode.nTexExpandedOffSetX = nTexExpandedOffSetX;
	infNode.nTexExpandedOffSetY = nTexExpandedOffSetY;
	infNode.nTexExpandedHeight = nTexExpandedHeight;
	if((strTexExpandedLeft == ""))
	{
		strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
		infNode.nTexExpandedLeftUWidth = 32;
		infNode.nTexExpandedLeftUHeight = 38;
	}
	else
	{
		infNode.nTexExpandedLeftUWidth = nTexExpandedLeftUWidth;
		infNode.nTexExpandedLeftUHeight = nTexExpandedLeftUHeight;
	}
	infNode.strTexExpandedLeft = strTexExpandedLeft;
	return m_UITree.InsertNode(parentname, infNode);
}

function string _makeExpandBtnNode(string parentname, string MakeNodeName, optional int nTexBtnWidth, optional int nTexBtnHeight, optional string strTexBtnExpand, optional string strTexBtnExpand_Over, optional string strTexBtnCollapse, optional string strTexBtnCollapse_Over, optional int OffsetX, optional int OffsetY, optional CustomTooltip pCustomTooltip)
{
	local XMLTreeNodeInfo infNode;

	infNode.ToolTip = pCustomTooltip;
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
	infNode.strName = MakeNodeName;
	infNode.bShowButton = 1;
	infNode.nTexBtnWidth = nTexBtnWidth;
	infNode.nTexBtnHeight = nTexBtnHeight;
	infNode.nOffSetX = OffsetX;
	infNode.nOffSetY = OffsetY;
	infNode.strTexBtnExpand = strTexBtnExpand;
	infNode.strTexBtnExpand_Over = strTexBtnExpand_Over;
	infNode.strTexBtnCollapse = strTexBtnCollapse;
	infNode.strTexBtnCollapse_Over = strTexBtnCollapse_Over;
	return m_UITree.InsertNode(parentname, infNode);
}

function _makeTextItem(string NodeName, string strText, optional int OffsetX, optional int OffsetY, optional Color TextColor, optional bool oneline, optional bool bLineBreak, optional int nMaxHeight, optional int nMaxWidth, optional UIEventManager.ETextVAlign eAlign, optional int nReserved, optional int nReserved2)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strText;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = OffsetX;
	infNodeItem.nOffSetY = OffsetY;
	infNodeItem.t_nMaxHeight = nMaxHeight;
	infNodeItem.t_nMaxWidth = nMaxWidth;
	if((int(eAlign) != 0))
	{
		infNodeItem.t_vAlign = ETextVAlign(eAlign);
	}
	infNodeItem.t_color = TextColor;
	if((nReserved != 0))
	{
		infNodeItem.nReserved = nReserved;
	}
	if((nReserved2 != 0))
	{
		infNodeItem.nReserved2 = nReserved2;
	}
	m_UITree.InsertNodeItem(NodeName, infNodeItem);
	return;
}

function _makeBlankItem(string NodeName, int BlankHeight)
{
	_makeTextureItem(NodeName, "L2UI_CT1.EmptyBtn", 1, BlankHeight, 0, 0, true, true);
	_makeTextureItem(NodeName, "L2UI_CT1.EmptyBtn", 0, 0, 0, 0, true, true);
	return;
}

function _makeCrossLineItem(string NodeName, optional int upDownHeightGap, optional int LineWidth)
{
	if((LineWidth == 0))
	{
		LineWidth = m_UITree.GetRect().nWidth;
	}
	_makeBlankItem(NodeName, upDownHeightGap);
	_makeTextureItem(NodeName, "L2ui_ch3.tooltip_line", LineWidth, 1, 0, 0, true, true);
	_makeBlankItem(NodeName, upDownHeightGap);
	return;
}

function _makeTextureItem(string NodeName, string TextureName, int TextureWidth, int TextureHeight, optional int OffsetX, optional int OffsetY, optional bool oneline, optional bool bLineBreak, optional int nTextureUWidth, optional int TextureUHeight, optional string strTextureMouseOn, optional string strTextureExpanded, optional int t_nTextID, optional int nReserved, optional int nReserved2)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.bLineBreak = bLineBreak;
	infNodeItem.nOffSetX = OffsetX;
	infNodeItem.nOffSetY = OffsetY;
	infNodeItem.t_nTextID = t_nTextID;
	infNodeItem.u_nTextureUWidth = nTextureUWidth;
	infNodeItem.u_nTextureUHeight = TextureUHeight;
	infNodeItem.u_nTextureWidth = TextureWidth;
	infNodeItem.u_nTextureHeight = TextureHeight;
	if((TextureName == ""))
	{
		TextureName = "L2UI_CT1.EmptyBtn";
	}
	infNodeItem.u_strTexture = TextureName;
	infNodeItem.u_strTextureMouseOn = strTextureMouseOn;
	infNodeItem.u_strTextureExpanded = strTextureExpanded;
	if((nReserved != 0))
	{
		infNodeItem.nReserved = nReserved;
	}
	if((nReserved2 != 0))
	{
		infNodeItem.nReserved2 = nReserved2;
	}
	m_UITree.InsertNodeItem(NodeName, infNodeItem);
	return;
}

function _AllNodeExpanded(string NodeName, bool bOpen)
{
	local array<string> arrSplit;
	local string strChildList;
	local int i;

	strChildList = m_UITree.GetChildNode(NodeName);
	Class'InterfaceClassic.UICommonAPI'.static.Split(strChildList, "|", arrSplit);
	i = 0;
	while((i < arrSplit.Length))
	{
		m_UITree.SetExpandedNode(arrSplit[i], bOpen);
		i++;
	}
	return;
}

function _ClickSelectNode(string NodeName)
{
	if((NodeName != beforeClickedNode))
	{
		m_UITree.SetExpandedNode(beforeClickedNode, false);
	}
	beforeClickedNode = NodeName;
	return;
}

function string _InsertNode(string parentname, XMLTreeNodeInfo infNode)
{
	return m_UITree.InsertNode(parentname, infNode);
}

function _InsertNodeItem(string parentname, XMLTreeNodeItemInfo nodeItemInfo)
{
	m_UITree.InsertNodeItem(parentname, nodeItemInfo);
	return;
}

function _SetExpandedNode(string NodeName, bool bExpanded)
{
	m_UITree.SetExpandedNode(NodeName, bExpanded);
	return;
}

function _SetNodeItemText(string NodeName, int nTextID, string strText)
{
	m_UITree.SetNodeItemText(NodeName, nTextID, strText);
	return;
}

function _SetNodeItemTexture(string NodeName, int nTextureID, string strTexture, int nWidth, int nHeight, optional int nType)
{
	m_UITree.SetNodeItemTexture(NodeName, nTextureID, strTexture, nWidth, nHeight, nType);
	return;
}

function string _GetExpandedNode(string NodeName)
{
	return m_UITree.GetExpandedNode(NodeName);
}

function string _GetParentNode(string NodeName)
{
	return m_UITree.GetParentNode(NodeName);
}

function string getMapStringReserved(string keyStr)
{
	return MapStringReserved.Find(keyStr);
}

function setMapStringReserved(string keyStr, string dataStr)
{
	MapStringReserved.Add(keyStr, dataStr);
	return;
}

function _TreeClear()
{
	m_UITree.Clear();
	return;
}
