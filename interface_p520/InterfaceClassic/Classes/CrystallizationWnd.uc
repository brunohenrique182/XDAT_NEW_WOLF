class CrystallizationWnd extends UICommonAPI;

const LINE_MAX = 6;

var string m_Windowname;
var WindowHandle Me;
var ItemWindowHandle CrystallizationItem;
var TextBoxHandle CrystallizationItemName;
var WindowHandle CrystallizationGetItemWnd;
var ButtonHandle OKButton;
var ButtonHandle CancelButton;
var ItemInfo tryItemInfo;
var int cHeight;
var int LineCount;
var bool isCrystallizeItem;

function OnRegisterEvent()
{
	RegisterEvent(5140);
	RegisterEvent(5141);
	RegisterEvent(5142);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function OnShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
	isCrystallizeItem = false;
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd");
	return;
}

function OnHide()
{
	if(isCrystallizeItem)
	{
		RequestCrystallizeItem(tryItemInfo.Id, INT64(1));
	}
	else
	{
		RequestCrystallizeItemCancel();
	}
	return;
}

function Initialize()
{
	Me = GetWindowHandle("CrystallizationWnd");
	CrystallizationItem = GetItemWindowHandle("CrystallizationWnd.CrystallizationItem");
	CrystallizationItemName = GetTextBoxHandle("CrystallizationWnd.CrystallizationItemName");
	CrystallizationGetItemWnd = GetWindowHandle("CrystallizationWnd.CrystallizationGetItemWnd");
	OKButton = GetButtonHandle("CrystallizationWnd.OKButton");
	CancelButton = GetButtonHandle("CrystallizationWnd.CancelButton");
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 5140:
			getCrystalizingEstimation(param);
			break;
		case 5141:
			showCrystalizingEstimationList();
			break;
		case 5142:
			cancelCystallizeItem();
			break;
		default:
			break;
	}
	return;
}

function SetItemInfo(ItemInfo cItemInfo)
{
	local int lineNum;

	RequestCrystallizeItemCancel();
	tryItemInfo = cItemInfo;
	cHeight = 0;
	LineCount = 0;
	CrystallizationItem.Clear();
	CrystallizationItemName.SetText("");
	lineNum = 1;
	while((lineNum <= 6))
	{
		GetItemWindowHandle(("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItem0" $ string(lineNum))).Clear();
		GetTextBoxHandle(("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemName0" $ string(lineNum))).SetText("");
		GetTextBoxHandle(("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemCount0" $ string(lineNum))).SetText("");
		GetTextBoxHandle(("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationItemProbability0" $ string(lineNum))).SetText("");
		lineNum++;
	}
	return;
}

function getCrystalizingEstimation(string param)
{
	local int nItemID, crystalCnt, nProbability;
	local ItemID cItemID;
	local ItemInfo cItemInfo;

	Debug(("getCrystalizingEstimation" @ param));
	LineCount++;
	CrystallizationItem.AddItem(tryItemInfo);
	getInstanceL2Util().textBox_setToolTipWithShortString(CrystallizationItemName, tryItemInfo.Name, -4);
	CrystallizationItem.SetSelectedNum(0);
	ParseInt(param, "ItemID", nItemID);
	ParseInt(param, "CrystalCnt", crystalCnt);
	ParseInt(param, "Probability", nProbability);
	cItemID = GetItemID(nItemID);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cItemID, cItemInfo);
	cItemInfo.ItemNum = INT64(crystalCnt);
	setItemLine(LineCount, cItemInfo, crystalCnt, nProbability);
	return;
}

function showCrystalizingEstimationList()
{
	cHeight = (cHeight + (38 * (5 - LineCount)));
	CrystallizationGetItemWnd.SetWindowSize(286, (194 - cHeight));
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function setItemLine(int lineNum, ItemInfo cItemInfo, int crystalCnt, int nProbability)
{
	local string probabilityStr;
	local TextBoxHandle tX;

	probabilityStr = getInstanceL2Util().MakeDecimalPointString(string(nProbability), 3, true, true);
	GetItemWindowHandle(("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItem0" $ string(lineNum))).AddItem(cItemInfo);
	tX = GetTextBoxHandle(("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemName0" $ string(lineNum)));
	getInstanceL2Util().textBox_setToolTipWithShortString(tX, cItemInfo.Name, -7);
	GetTextBoxHandle(("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemCount0" $ string(lineNum))).SetText((string(crystalCnt) $ GetSystemString(932)));
	GetTextBoxHandle(("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationItemProbability0" $ string(lineNum))).SetText(probabilityStr);
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "OKButton":
			OnOKButtonClick();
			break;
		case "CancelButton":
			cancelCystallizeItem();
			break;
		default:
			break;
	}
	return;
}

function OnOKButtonClick()
{
	isCrystallizeItem = true;
	Me.HideWindow();
	return;
}

function cancelCystallizeItem()
{
	Me.HideWindow();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	cancelCystallizeItem();
	return;
}

defaultproperties
{
	m_Windowname="CrystallizationWnd"
}
