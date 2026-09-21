class BR_CashShopReceiverListAddWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle BtnAdd;
var ButtonHandle btnCancel;
var EditBoxHandle eName;
var TextBoxHandle Description;
var TextureHandle GroupBox;
var bool bOpenCashShopReceiverListAddWnd;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("BR_CashShopReceiverListAddWnd");
	BtnAdd = GetButtonHandle("BR_CashShopReceiverListAddWnd.BtnAdd");
	btnCancel = GetButtonHandle("BR_CashShopReceiverListAddWnd.BtnCancel");
	eName = GetEditBoxHandle("BR_CashShopReceiverListAddWnd.Name");
	Description = GetTextBoxHandle("BR_CashShopReceiverListAddWnd.Description");
	GroupBox = GetTextureHandle("BR_CashShopReceiverListAddWnd.GroupBox");
	return;
}

function Load()
{
	return;
}

function OnHide()
{
	local BR_NewCashShopReceiverListWnd Script;

	Script = BR_NewCashShopReceiverListWnd(GetScript("BR_NewCashShopReceiverListWnd"));
	Script.selectedInit();
	Script.EnableTab();
	eName.SetString("");
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "BtnAdd":
			OnBtnAddClick();
			break;
		case "BtnCancel":
			OnbtnCancelClick();
			break;
		default:
			break;
	}
	return;
}

function OnBtnAddClick()
{
	local UserInfo UserInfo;
	local string UserName, AddName;

	AddName = eName.GetString();
	if(GetPlayerInfo(UserInfo))
	{
		UserName = UserInfo.Name;
	}
	if((eName.GetString() != ""))
	{
		if((UserName == AddName))
		{
			DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3221));
		}
		else
		{
			if(SearchPostFriend(AddName))
			{
				DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3216));
			}
			else
			{
				Class'NWindow.PostWndAPI'.static.RequestAddingPostFriend(AddName);
				Me.HideWindow();
			}
			eName.SetString("");
		}
	}
	return;
}

function bool SearchPostFriend(string S)
{
	local int i, Count;
	local LVDataRecord Record;
	local ListCtrlHandle AddList;

	AddList = GetListCtrlHandle("BR_NewCashShopReceiverListWnd.BR_NewCashShopReceiverListWnd_Add.AddList");
	Count = Class'NWindow.UIAPI_LISTCTRL'.static.GetRecordCount("BR_NewCashShopReceiverListWnd.AddList");
	i = 0;
	while((i < Count))
	{
		AddList.GetRec(i, Record);
		if((S == Record.LVDataList[0].szData))
		{
			return true;
		}
		i++;
	}
	return false;
}

function OnbtnCancelClick()
{
	local BR_NewCashShopReceiverListWnd Script;

	Script = BR_NewCashShopReceiverListWnd(GetScript("BR_NewCashShopReceiverListWnd"));
	Script.selectedInit();
	Script.EnableTab();
	Me.HideWindow();
	eName.SetString("");
	return;
}
