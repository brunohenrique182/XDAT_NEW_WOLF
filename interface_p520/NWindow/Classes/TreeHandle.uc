class TreeHandle extends WindowHandle;

native final function string InsertNode(string strParentName, UIEventManager.XMLTreeNodeInfo infNode);

native final function InsertNodeItem(string NodeName, UIEventManager.XMLTreeNodeItemInfo infNodeItem);

native final function Clear();

native final function SetExpandedNode(string NodeName, bool bExpanded);

native final function string GetExpandedNode(string NodeName);

native final function bool DeleteNode(string NodeName);

native final function bool IsNodeNameExist(string NodeName);

native final function bool IsExpandedNode(string NodeName);

native final function string GetChildNode(string NodeName);

native final function string GetParentNode(string NodeName);

native final function ShowScrollBar(bool bShow);

native final function SetNodeItemText(string NodeName, int nTextID, string strText);

native final function SetNodeItemTexture(string NodeName, int nTextID, string strTexture, int nWidth, int nHeight, int nType);
