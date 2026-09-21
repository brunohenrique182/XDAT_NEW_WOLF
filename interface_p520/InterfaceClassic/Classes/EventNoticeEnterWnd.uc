class EventNoticeEnterWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle eventImageTex;
var TextBoxHandle TitleTextBox;
var TextBoxHandle descTextBox;
var UIControlDialogAssets teleportDialog;
var int _eventId;
var int _teleportId;

static function EventNoticeEnterWnd Inst()
{
	return EventNoticeEnterWnd(GetScript("EventNoticeEnterWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	TitleTextBox = GetTextBoxHandle((ownerFullPath $ ".TitleName_text"));
	descTextBox = GetTextBoxHandle((ownerFullPath $ ".StandbyStatus_text"));
	eventImageTex = GetTextureHandle((ownerFullPath $ ".Mainimg_texture"));
	teleportDialog = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(GetWindowHandle((ownerFullPath $ ".EventNoticeEnterPopupWnd")));
	return;
}

function ShowNoticeEnterWnd(int EventID)
{
	local PopupEventData EventData;

	Class'NWindow.UIDataManager'.static.GetPopupEventData(EventID, EventData);
	_eventId = EventID;
	_teleportId = EventData.TeleportID;
	Me.SetWindowTitle(GetNpcString(EventData.TitleStringID));
	TitleTextBox.SetText(GetNpcString(EventData.FieldStringID));
	descTextBox.SetText(GetNpcString(EventData.DescStringID));
	eventImageTex.SetTexture(EventData.PopupTexture);
	Me.ShowWindow();
	teleportDialog.Hide();
	return;
}

function ToggleShowNoticeEnterWnd(int EventID)
{
	if(Me.IsShowWindow())
	{
		HideNoticeEnterWnd();
	}
	else
	{
		ShowNoticeEnterWnd(EventID);
	}
	return;
}

function HideNoticeEnterWnd()
{
	if(Me.IsShowWindow())
	{
		Me.HideWindow();
	}
	return;
}

function ShowTeleportDialog()
{
	local string Desc, teleportName;
	local TeleportListAPI.TeleportListData targetTeleport;
	local INT64 teleportCost;

	targetTeleport = GetTeleportListData(_teleportId);
	if((targetTeleport.Id == 0))
	{
		Debug("ShowTeleportDialog() invalid teleportId");
		return;
	}
	if((targetTeleport.Level > 0))
	{
		teleportName = (((("(" $ targetTeleport.Name) $ " Lv ") $ string(targetTeleport.Level)) $ ")");
	}
	else
	{
		teleportName = (("(" $ targetTeleport.Name) $ ")");
	}
	Debug((("ShowTeleportDialog()" @ teleportName) @ string(_teleportId)));
	Desc = ((GetSystemMessage(5239) $ "\\n\\n") $ teleportName);
	teleportDialog.SetDialogDesc(Desc, , , , 38);
	teleportDialog.SetUseNeedItem(true);
	teleportDialog.StartNeedItemList(1);
	teleportCost = Class'InterfaceClassic.TeleportWnd'.static.Inst().GetTeleportCost(targetTeleport.Price[0].Amount, targetTeleport.UsableLevel, targetTeleport.UsableTransferDegree);
	if((targetTeleport.Price.Length > 0))
	{
		teleportDialog.AddNeedItemClassID(targetTeleport.Price[0].Id, teleportCost);
	}
	teleportDialog.SetItemNum(1);
	teleportDialog.Show();
	teleportDialog.DelegateOnClickBuy = OnTeleportDialogConfirm;
	teleportDialog.DelegateOnCancel = OnTeleportDialogCancel;
	return;
}

function TeleportListAPI.TeleportListData GetTeleportListData(int tID)
{
	local TeleportListAPI.TeleportListData tInfo;

	tInfo = Class'NWindow.TeleportListAPI'.static.GetFirstTeleportListData();
	while(("" != tInfo.Name))
	{
		if((tInfo.Id == tID))
		{
			return tInfo;
		}
		tInfo = Class'NWindow.TeleportListAPI'.static.GetNextTeleportListData();
	}
	return tInfo;
}

event OnTeleportDialogCancel()
{
	teleportDialog.Hide();
	return;
}

event OnTeleportDialogConfirm()
{
	local UserInfo UserInfo;

	if((GetPlayerInfo(UserInfo) == false))
	{
		return;
	}
	if((UserInfo.nCurHP == INT64(0)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5243));
		teleportDialog.Hide();
		return;
	}
	Class'NWindow.TeleportListAPI'.static.RequestTeleport(_teleportId);
	teleportDialog.Hide();
	Me.HideWindow();
	return;
}

function OnShow()
{
	Class'InterfaceClassic.TeleportWnd'.static.Inst().RQ_C_EX_Teleport_UI();
	return;
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

function OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "Teleport_Btn":
			ShowTeleportDialog();
			break;
		default:
			break;
	}
	return;
}

function SetTeleportInfo()
{
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
