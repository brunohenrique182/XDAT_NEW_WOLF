class UIItemWindowSizeTest extends UICommonAPI;

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "SetButton":
			SetItem();
			break;
		case "RebuildButton":
			ExecuteCommand("///rebuildui");
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ExtraNum")).SetString("1");
	GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemClassID")).SetString("374");
	return;
}

event OnCompleteEditBox(string strID)
{
	SetItem();
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	switch(nKey)
	{
		case IK_Enter:
		case IK_Tab:
			if(Class'NWindow.InputAPI'.static.IsAltPressed())
			{
				return false;
			}
			if(Class'NWindow.InputAPI'.static.IsCtrlPressed())
			{
				return false;
			}
			if(Class'NWindow.InputAPI'.static.IsShiftPressed())
			{
				return false;
			}
			if((GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ExtraNum")).IsFocused() == true))
			{
				GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemClassID")).AllSelect();
				GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemClassID")).SetFocus();
			}
			else
			{
				GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ExtraNum")).AllSelect();
				GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ExtraNum")).SetFocus();
			}
			return true;
		default:
	}
}

function SetItem()
{
	local ItemInfo iInfo;

	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(int(GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemClassID")).GetString())), iInfo);
	iInfo.bShowCount = IsStackableItem(iInfo.ConsumeType);
	if((iInfo.bShowCount == false))
	{
		iInfo.Enchanted = int(GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ExtraNum")).GetString());
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.Enchanted = (iInfo.Enchanted + 1);
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.Enchanted = (iInfo.Enchanted + 1);
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.Enchanted = (iInfo.Enchanted + 1);
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.Enchanted = (iInfo.Enchanted + 1);
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.Enchanted = (iInfo.Enchanted + 1);
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.Enchanted = (iInfo.Enchanted + 1);
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.Enchanted = (iInfo.Enchanted + 1);
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.Enchanted = (iInfo.Enchanted + 1);
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.Enchanted = (iInfo.Enchanted + 1);
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
	}
	else
	{
		iInfo.ItemNum = INT64(GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ExtraNum")).GetString());
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.ItemNum = (iInfo.ItemNum + INT64(1));
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.ItemNum = (iInfo.ItemNum + INT64(1));
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.ItemNum = (iInfo.ItemNum + INT64(1));
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.ItemNum = (iInfo.ItemNum + INT64(1));
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.ItemNum = (iInfo.ItemNum + INT64(1));
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.ItemNum = (iInfo.ItemNum + INT64(1));
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.ItemNum = (iInfo.ItemNum + INT64(1));
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.ItemNum = (iInfo.ItemNum + INT64(1));
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
		iInfo.ItemNum = (iInfo.ItemNum + INT64(1));
		addItems("TextureFreeSizeItemWnd", iInfo, 10);
		addItems("TextureFreeSizeItemWnd2", iInfo, 10);
	}
	addItems("Texture64ItemWnd", iInfo);
	addItems("Texture48ItemWnd", iInfo);
	addItems("Texture32ItemWnd", iInfo);
	addItems("Texture24ItemWnd", iInfo);
	addItems("Texture16ItemWnd", iInfo);
	return;
}

function addItems(string TextureName, ItemInfo iInfo, optional int maxNum)
{
	local ItemWindowHandle iWIndow;

	iWIndow = GetItemWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ TextureName));
	if((maxNum == 0))
	{
		maxNum = 1;
	}
	if((iWIndow.GetItemNum() >= maxNum))
	{
		iWIndow.Clear();
	}
	iWIndow.AddItem(iInfo);
	return;
}
