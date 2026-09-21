class VirtualItemWndSlot extends UICommonAPI;

var VirtualItemWnd.VirtualSlotInfo _info;
var WindowHandle Me;
var ItemWindowHandle ItemWnd;
var TextureHandle enablePanelTex;
var TextureHandle emptyPanelTex;
var TextureHandle selectedTex;
var TextureHandle disableTex;
var TextBoxHandle pointTextBox;
var TextBoxHandle upgradeTextBox;
var bool _isSubSlot;
//var delegate<DelegateOnSlotClicked> __DelegateOnSlotClicked__Delegate;

delegate DelegateOnSlotClicked(INT64 SBT, int SlotIndex)
{
	return;
}

function Init(WindowHandle ownerWnd, bool isSubSlot)
{
	local string ownerFullPath;

	Me = ownerWnd;
	ownerFullPath = ownerWnd.m_WindowNameWithFullPath;
	ItemWnd = GetItemWindowHandle((ownerFullPath $ ".VirtualEquipItemWnd"));
	pointTextBox = GetTextBoxHandle((ownerFullPath $ ".PointFigure_txt"));
	upgradeTextBox = GetTextBoxHandle((ownerFullPath $ ".UpgradeFigure_txt"));
	emptyPanelTex = GetTextureHandle((ownerFullPath $ ".EnablePannel_tex"));
	enablePanelTex = GetTextureHandle((ownerFullPath $ ".MountedPannel_tex"));
	selectedTex = GetTextureHandle((ownerFullPath $ ".SlotSelect_tex"));
	_isSubSlot = isSubSlot;
	if(isSubSlot)
	{
		disableTex = GetTextureHandle((ownerFullPath $ ".JewelDisable_tex"));
		disableTex.HideWindow();
	}
	selectedTex.HideWindow();
	pointTextBox.HideWindow();
	upgradeTextBox.HideWindow();
	return;
}

function SetInfo(VirtualItemWnd.VirtualSlotInfo Info)
{
	local bool IsEmpty;

	_info = Info;
	emptyPanelTex.HideWindow();
	enablePanelTex.HideWindow();
	if((Info.ItemInfo.Id.ClassID == 0))
	{
		emptyPanelTex.ShowWindow();
	}
	else if((Info.IsVirtualItem == true))
	{
		enablePanelTex.ShowWindow();
	}
	if(Info.isDisabled)
	{
		Info.ItemInfo.bDisabled = 1;
	}
	if(!ItemWnd.SetItem(0, Info.ItemInfo))
	{
		ItemWnd.AddItem(Info.ItemInfo);
	}
	if(((_info.isBuffSlot == true) && (Info.ItemInfo.Id.ClassID > 0)))
	{
		upgradeTextBox.SetText(string(Class'Interface.VirtualItemWnd'.static.Inst().GetVirtualItemEnchantInfo(_info.vMainIndex, _info.vSubIndex).nEnchant));
		upgradeTextBox.ShowWindow();
	}
	else
	{
		upgradeTextBox.HideWindow();
	}
	SetSubSlotDisable(Info.isDisabled);
	return;
}

function VirtualItemWnd.VirtualSlotInfo getInfo()
{
	return _info;
}

function SetSelcted(bool Selected)
{
	if(Selected)
	{
		selectedTex.ShowWindow();
	}
	else
	{
		selectedTex.HideWindow();
	}
	return;
}

function SetSubSlotDisable(bool Disable)
{
	if(_isSubSlot)
	{
		if(Disable)
		{
			disableTex.ShowWindow();
		}
		else
		{
			disableTex.HideWindow();
		}
	}
	return;
}

event OnClickItem(string strID, int Index)
{
	DelegateOnSlotClicked(_info.SlotBitType, _info.SlotIndex);
	return;
}
