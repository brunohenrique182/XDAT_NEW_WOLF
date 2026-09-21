class DualInventorySwapBtn extends UICommonAPI;

const commandName = "Swapset";
const GroupName = "GamingStateShortcut";

var int clickedX;
var int clickedY;

event OnLoad()
{
	_RefreshTooltip();
	OptionWnd(GetScript("OptionWnd")).DelegateOnChangeShortcut = _RefreshTooltip;
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	GetClientCursorPos(clickedX, clickedY);
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "SwapRetryBtn":
			HandleOnCLickSwapRetry();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	_RefreshTooltip();
	return;
}

function _RefreshTooltip()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SwapRetryBtn")).SetTooltipType("text");
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SwapRetryBtn")).SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(14281), getInstanceL2Util().White, "", true, GetSwapRetryShortcutString(), getInstanceL2Util().White, "", true, , , , ));
	return;
}

function string GetSwapRetryShortcutString()
{
	local ShortcutCommandItem commandItem;
	local OptionWnd optionWndScript;
	local string strShort;

	Class'NWindow.ShortcutAPI'.static.GetAssignedKeyFromCommand("GamingStateShortcut", "Swapset", commandItem);
	strShort = (((strShort $ "<") $ GetSystemString(1523)) $ ": ");
	optionWndScript = OptionWnd(GetScript("OptionWnd"));
	if((commandItem.subkey1 != ""))
	{
		strShort = ((strShort $ optionWndScript.GetUserReadableKeyName(commandItem.subkey1)) $ "+");
	}
	if((commandItem.subkey2 != ""))
	{
		strShort = ((strShort $ optionWndScript.GetUserReadableKeyName(commandItem.subkey2)) $ "+");
	}
	if((commandItem.Key != ""))
	{
		strShort = ((strShort $ optionWndScript.GetUserReadableKeyName(commandItem.Key)) $ ">");
	}
	return strShort;
}

function HandleOnCLickSwapRetry()
{
	local int _clickedX, _clickedY, gabX, gabY;

	GetClientCursorPos(_clickedX, _clickedY);
	gabX = (clickedX - _clickedX);
	gabY = (clickedY - _clickedY);
	if((Sqrt(float(((gabX * gabX) + (gabY * gabY)))) > 3.0000000))
	{
		return;
	}
	InventoryWnd(GetScript("InventoryWnd"))._RQ_C_EX_DUAL_INVENTORY_SWAP(-1);
	return;
}
