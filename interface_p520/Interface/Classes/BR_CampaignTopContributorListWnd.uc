class BR_CampaignTopContributorListWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle CampaignTitle;
var ListCtrlHandle CampaignTopContributorList;

function OnRegisterEvent()
{
	RegisterEvent(9530);
	return;
}

function OnLoad()
{
	OnRegisterEvent();
	Me = GetWindowHandle("BR_CampaignTopContributorListWnd");
	CampaignTitle = GetTextBoxHandle("BR_CampaignTopContributorListWnd.CampaignTitle");
	CampaignTopContributorList = GetListCtrlHandle("BR_CampaignTopContributorListWnd.CampaignTopContributorList");
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9530:
			CampaignResult(param);
			break;
		default:
			break;
	}
	return;
}

function CampaignResult(string param)
{
	local LVDataRecord Record;
	local int i, Id, Step, GoalGroupID, ListCnt;
	local string Name;
	local EventContentInfo Info;
	local Color C;

	C.R = 222;
	C.G = 196;
	C.B = 126;
	CampaignTopContributorList.DeleteAllItem();
	Record.LVDataList.Length = 1;
	ParseInt(param, "ID", Id);
	ParseInt(param, "STEP", Step);
	ParseInt(param, "GOALGROUPID", GoalGroupID);
	ParseInt(param, "ListCnt", ListCnt);
	GetEventContentInfo(Id, Step, GoalGroupID, Info);
	CampaignTitle.SetText(Info.Title);
	CampaignTitle.SetTextColor(C);
	i = 0;
	while((i < ListCnt))
	{
		ParseString(param, ("Name_" $ string(i)), Name);
		Record.LVDataList[0].szData = Name;
		CampaignTopContributorList.InsertRecord(Record);
		i++;
	}
	Me.ShowWindow();
	return;
}

function OnClickButton(string strID)
{
	if((strID == "btnExit"))
	{
		Me.HideWindow();
	}
	return;
}
