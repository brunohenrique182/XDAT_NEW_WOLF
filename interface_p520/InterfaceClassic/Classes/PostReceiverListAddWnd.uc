class PostReceiverListAddWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle BtnAdd;
var ButtonHandle btnCancel;
var EditBoxHandle eName;
var TextBoxHandle Description;
var TextureHandle GroupBox;
var bool bOpenPostReceiverListAddWnd;

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
	Me = GetWindowHandle("PostReceiverListAddWnd");
	BtnAdd = GetButtonHandle("PostReceiverListAddWnd.BtnAdd");
	btnCancel = GetButtonHandle("PostReceiverListAddWnd.BtnCancel");
	eName = GetEditBoxHandle("PostReceiverListAddWnd.Name");
	Description = GetTextBoxHandle("PostReceiverListAddWnd.Description");
	GroupBox = GetTextureHandle("PostReceiverListAddWnd.GroupBox");
	return;
}

function Load()
{
	return;
}

function OnHide()
{
	local PostReceiverListWnd Script;

	Script = PostReceiverListWnd(GetScript("PostReceiverListWnd"));
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
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3221));
		}
		else
		{
			if(SearchPostFriend(AddName))
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(3216));
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

	AddList = GetListCtrlHandle("PostReceiverListWnd.PostReceiverListWnd_Add.AddList");
	Count = Class'NWindow.UIAPI_LISTCTRL'.static.GetRecordCount("PostReceiverListWnd.AddList");
	i = 0;
	while((i < Count))
	{
		AddList.GetRec(i, Record);
		if((Caps(S) == Caps(Record.LVDataList[0].szData)))
		{
			return true;
		}
		i++;
	}
	return false;
}

function OnbtnCancelClick()
{
	local PostReceiverListWnd Script;

	Script = PostReceiverListWnd(GetScript("PostReceiverListWnd"));
	Script.selectedInit();
	Script.EnableTab();
	Me.HideWindow();
	eName.SetString("");
	return;
}
