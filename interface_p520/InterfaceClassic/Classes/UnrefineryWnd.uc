class UnrefineryWnd extends UICommonAPI;

var WindowHandle m_UnRefineryWnd_Main;
var WindowHandle m_ItemtoUnRefineWnd;
var WindowHandle m_ItemtoUnRefineAnim;
var WindowHandle m_hSelectedItemHighlight;
var WindowHandle m_ResultAnimation1;
var bool isResult;
var TextBoxHandle m_InstructionText;
var TextBoxHandle m_AdenaText;
var ButtonHandle m_hUnrefineButton;
var ButtonHandle m_OkBtn;
var ItemWindowHandle m_ItemDragBox;
var ProgressCtrlHandle m_UnRefineryProgress;
var ItemInfo CurrentItem;
var INT64 m_Adena;
var ProgressCtrlHandle m_hUnrefineryWndUnRefineryProgress;

function OnRegisterEvent()
{
	RegisterEvent(2810);
	RegisterEvent(2820);
	RegisterEvent(2830);
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
		m_ResultAnimation1 = GetHandle("UnrefineryWnd.RefineResultAnimation01");
		m_UnRefineryWnd_Main = GetHandle("UnrefineryWnd");
		m_UnRefineryProgress = ProgressCtrlHandle(GetHandle("UnRefineryProgress"));
		m_ItemtoUnRefineWnd = GetHandle("Itemtounrefine");
		m_ItemtoUnRefineAnim = GetHandle("ItemtounrefineAnim");
		m_hSelectedItemHighlight = GetHandle("SelectedItemHighlight");
		m_ItemDragBox = ItemWindowHandle(GetHandle("UnRefineryWnd.Itemtounrefine.ItemUnrefine"));
		m_InstructionText = TextBoxHandle(GetHandle("UnrefineryWnd.txtInstruction"));
		m_AdenaText = TextBoxHandle(GetHandle("UnrefineryWnd.txtAdenaInstruction"));
		m_hUnrefineButton = ButtonHandle(GetHandle("btnUnRefine"));
		m_OkBtn = ButtonHandle(GetHandle("btnClose"));
	}
	else
	{
		m_ResultAnimation1 = GetWindowHandle("UnrefineryWnd.RefineResultAnimation01");
		m_UnRefineryWnd_Main = GetWindowHandle("UnrefineryWnd");
		m_UnRefineryProgress = GetProgressCtrlHandle("UnRefineryProgress");
		m_ItemtoUnRefineWnd = GetWindowHandle("Itemtounrefine");
		m_ItemtoUnRefineAnim = GetWindowHandle("ItemtounrefineAnim");
		m_hSelectedItemHighlight = GetWindowHandle("SelectedItemHighlight");
		m_ItemDragBox = GetItemWindowHandle("UnRefineryWnd.Itemtounrefine.ItemUnrefine");
		m_InstructionText = GetTextBoxHandle("UnrefineryWnd.txtInstruction");
		m_AdenaText = GetTextBoxHandle("UnrefineryWnd.txtAdenaInstruction");
		m_hUnrefineButton = GetButtonHandle("btnUnRefine");
		m_OkBtn = GetButtonHandle("btnClose");
		m_hUnrefineryWndUnRefineryProgress = GetProgressCtrlHandle("UnrefineryWnd.UnRefineryProgress");
	}
	return;
}

function OnShow()
{
	ResetReady();
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd,RefineryWnd");
	if(!IsShowWindow("InventoryWnd"))
	{
		ShowWindow("InventoryWnd");
	}
	GetWindowHandle("UnrefineryWnd").SetFocus();
	return;
}

function ResetReady()
{
	isResult = false;
	m_UnRefineryWnd_Main.ShowWindow();
	m_ItemtoUnRefineWnd.ShowWindow();
	m_ItemtoUnRefineAnim.ShowWindow();
	m_hSelectedItemHighlight.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_UnRefineryProgress.SetProgressTime(2000);
	m_UnRefineryProgress.Reset();
	m_hUnrefineButton.DisableWindow();
	m_ItemDragBox.Clear();
	m_InstructionText.SetText(GetSystemMessage(1963));
	SetAdenaText("0");
	m_AdenaText.SetTooltipString("");
	PlaySound("ItemSound2.smelting.Smelting_dragin");
	m_OkBtn.EnableWindow();
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 2810:
			PlaySound("ItemSound2.smelting.Smelting_dragin");
			ResetReady();
			break;
		case 2820:
			PlaySound("ItemSound2.smelting.Smelting_dragin");
			OnTargetItemValidationResult(a_Param);
			break;
		case 2830:
			PlaySound("ItemSound2.smelting.smelting_finalA");
			OnUnRefineDoneResult(a_Param);
			break;
		default:
			break;
	}
	return;
}

function OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	switch(a_WindowID)
	{
		case "ItemUnrefine":
			ValidateItem(a_itemInfo);
			break;
		default:
			break;
	}
	return;
}

function ValidateItem(ItemInfo a_itemInfo)
{
	if(isDamagedItem(a_itemInfo))
	{
		return;
	}
	CurrentItem = a_itemInfo;
	Class'NWindow.RefineryAPI'.static.ConfirmCancelItem(a_itemInfo.Id);
	return;
}

function OnTargetItemValidationResult(string a_Param)
{
	local int itemServerID, ItemClassID, ItemValidationResult;
	local string AdenaText;

	ParseInt(a_Param, "CancelItemServerID", itemServerID);
	ParseInt(a_Param, "CancelItemClassID", ItemClassID);
	ParseINT64(a_Param, "Adena", m_Adena);
	ParseInt(a_Param, "Result", ItemValidationResult);
	switch(ItemValidationResult)
	{
		case 1:
			m_hUnrefineButton.EnableWindow();
			if(!m_ItemDragBox.SetItem(0, CurrentItem))
			{
				m_ItemDragBox.AddItem(CurrentItem);
			}
			AdenaText = MakeCostStringINT64(m_Adena);
			SetAdenaText(AdenaText);
			m_ItemtoUnRefineAnim.HideWindow();
			m_hSelectedItemHighlight.ShowWindow();
			m_InstructionText.SetText("");
			if((CheckAdena() == false))
			{
				m_hUnrefineButton.DisableWindow();
				m_InstructionText.SetText(GetSystemMessage(279));
			}
			break;
		case 0:
			ResetReady();
			break;
		default:
			break;
	}
	return;
}

function SetAdenaText(string a_AdenaText)
{
	local string AdenaText;

	AdenaText = ConvertNumToText(a_AdenaText);
	m_AdenaText.SetText((a_AdenaText @ GetSystemString(469)));
	m_AdenaText.SetTextColor(GetNumericColor(a_AdenaText));
	if((int(a_AdenaText) == 0))
	{
		m_AdenaText.SetTooltipString("");
	}
	else
	{
		m_AdenaText.SetTooltipString(AdenaText);
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnUnRefine":
			if(isResult)
			{
				m_hUnrefineButton.SetNameText(GetSystemString(1479));
				ResetReady();
			}
			else
			{
				OnClickUnRefineButton();
			}
			break;
		case "btnClose":
			m_UnRefineryProgress.Reset();
			PlaySound("Itemsound2.smelting.smelting_dragout");
			m_UnRefineryWnd_Main.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnClickUnRefineButton()
{
	local INT64 diff, CurAdena;

	CurAdena = GetAdena();
	diff = (CurAdena - m_Adena);
	if((diff >= INT64(0)))
	{
		m_hUnrefineButton.DisableWindow();
		m_UnRefineryProgress.Start();
		m_ResultAnimation1.ShowWindow();
		PlaySound("ItemSound2.smelting.smelting_loding");
		m_OkBtn.DisableWindow();
	}
	else
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemMessage(279));
	}
	return;
}

function bool CheckAdena()
{
	local INT64 diff, CurAdena;

	CurAdena = GetAdena();
	diff = (CurAdena - m_Adena);
	if((diff >= INT64(0)))
	{
		return true;
	}
	else
	{
		return false;
	}
}

function PlayProgressiveBar()
{
	m_hUnrefineryWndUnRefineryProgress.Start();
	return;
}

function OnUnRefineRequest()
{
	Class'NWindow.RefineryAPI'.static.RequestRefineCancel(CurrentItem.Id);
	return;
}

function OnUnRefineDoneResult(string a_Param)
{
	local int UnRefineResult;

	isResult = true;
	ParseInt(a_Param, "Result", UnRefineResult);
	m_OkBtn.EnableWindow();
	m_hUnrefineryWndUnRefineryProgress.SetPos(0);
	Debug(("UnRefineResult" @ string(UnRefineResult)));
	switch(UnRefineResult)
	{
		case 1:
			CurrentItem.RefineryOp1 = 0;
			CurrentItem.RefineryOp2 = 0;
			CurrentItem.RefineryOp3 = 0;
			if(!m_ItemDragBox.SetItem(0, CurrentItem))
			{
				m_ItemDragBox.AddItem(CurrentItem);
			}
			m_InstructionText.SetText(MakeFullSystemMsg(GetSystemMessage(1965), CurrentItem.Name, ""));
			m_hUnrefineButton.SetNameText(GetSystemString(1731));
			m_hUnrefineButton.EnableWindow();
			break;
		case 0:
			m_hUnrefineButton.EnableWindow();
			m_UnRefineryWnd_Main.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnProgressTimeUp(string strID)
{
	if((strID == "UnRefineryProgress"))
	{
		OnUnRefineRequest();
	}
	return;
}

function OnReceivedCloseUI()
{
	OnClickButton("btnClose");
	return;
}
