class UIEditor_Worksheet extends UICommonAPI;

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if((int(nKey) == 46))
	{
		DeleteWindow();
	}
	else if((int(nKey) == 27))
	{
		ClearAllTracker();
	}
	return false;
}

function ClearAllTracker()
{
	ClearTracker();
	return;
}

function DeleteWindow()
{
	DeleteAttachedWindow();
	return;
}

function OnDropWnd(WindowHandle hTarget, WindowHandle hDropWnd, int X, int Y)
{
	local UIEditor_ControlManager Script;
	local WindowHandle ContainerHandle, ParentHandle;

	if(((hTarget == none) || (hDropWnd == none)))
	{
		return;
	}
	ContainerHandle = hTarget;
	if(!ContainerHandle.IsControlContainer())
	{
		ParentHandle = ContainerHandle.GetParentWindowHandle();
		while((ParentHandle != none))
		{
			if(ParentHandle.IsControlContainer())
			{
				break;
			}
			ParentHandle = ParentHandle.GetParentWindowHandle();
		}
		ContainerHandle = ParentHandle;
	}
	if((ContainerHandle == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, (("Can't Move Control to " $ hTarget.GetWindowName()) $ "."));
		return;
	}
	if(hDropWnd.ChangeParentWindow(ContainerHandle))
	{
		Script = UIEditor_ControlManager(GetScript("UIEditor_ControlManager"));
		if((Script != none))
		{
			Script.RefreshControlList();
		}
	}
	return;
}

function OnDropItemWithHandle(WindowHandle hTarget, ItemInfo Info, int X, int Y)
{
	local UIEditor_ControlManager Script;
	local WindowHandle TargetWndHandle;

	Script = UIEditor_ControlManager(GetScript("UIEditor_ControlManager"));
	if((Script == none))
	{
		return;
	}
	if((Script.selectWnd != none))
	{
		TargetWndHandle = Script.selectWnd;
	}
	else
	{
		TargetWndHandle = hTarget;
	}
	Script.AddControl(TargetWndHandle, X, Y);
	return;
}
