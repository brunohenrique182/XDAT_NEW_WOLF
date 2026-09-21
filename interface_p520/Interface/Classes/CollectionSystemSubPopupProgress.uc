class CollectionSystemSubPopupProgress extends UICommonAPI;

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var CollectionSystem collectionSystemScript;
var RichListCtrlHandle List_ListCtrl;
var TextBoxHandle ANum00_txt;
var TextBoxHandle ANum01_txt;
var TextBoxHandle ANum02_txt;
var TextBoxHandle BNum00_txt;
var TextBoxHandle BNum01_txt;
var CollectionSystemProgressComponent ProgressCollectionComplete_wndScript;
var CollectionSystemProgressComponent ProgressItemComplete_wndScript;
var array<CollectionSystemProgressComponent> collectionSystemProgressComponents;
var ButtonHandle CloseBtn;

function InitProgressComponents()
{
	local string _progressWindowName;

	_progressWindowName = (m_Windowname $ ".ProgressCollectionComplete_wnd");
	GetWindowHandle(_progressWindowName).SetScript("CollectionSystemProgressComponent");
	ProgressCollectionComplete_wndScript = CollectionSystemProgressComponent(GetWindowHandle(_progressWindowName).GetScript());
	ProgressCollectionComplete_wndScript.Init(_progressWindowName);
	_progressWindowName = (m_Windowname $ ".ProgressItemComplete_wnd");
	GetWindowHandle(_progressWindowName).SetScript("CollectionSystemProgressComponent");
	ProgressItemComplete_wndScript = CollectionSystemProgressComponent(GetWindowHandle(_progressWindowName).GetScript());
	ProgressItemComplete_wndScript.Init(_progressWindowName);
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	util = L2Util(GetScript("L2Util"));
	collectionSystemScript = CollectionSystem(GetScript("CollectionSystem"));
	List_ListCtrl = GetRichListCtrlHandle((m_Windowname $ ".List_ListCtrl"));
	List_ListCtrl.SetTooltipType("CollectionSystemOptionListTooltip");
	ANum00_txt = GetTextBoxHandle((m_Windowname $ ".PopupProgressContents.ANum00_txt"));
	ANum01_txt = GetTextBoxHandle((m_Windowname $ ".PopupProgressContents.ANum01_txt"));
	ANum02_txt = GetTextBoxHandle((m_Windowname $ ".PopupProgressContents.ANum02_txt"));
	BNum00_txt = GetTextBoxHandle((m_Windowname $ ".PopupProgressContents.BNum00_txt"));
	BNum01_txt = GetTextBoxHandle((m_Windowname $ ".PopupProgressContents.BNum01_txt"));
	InitProgressComponents();
	ProgressCollectionComplete_wndScript.SetPoint(100, 100);
	ProgressItemComplete_wndScript.SetPoint(100, 100);
	SetProgressCollection(100, 100, 0);
	SetProgressItem(100, 100);
	List_ListCtrl.SetSelectable(false);
	List_ListCtrl.SetSelectedSelTooltip(false);
	List_ListCtrl.SetUseStripeBackTexture(false);
	List_ListCtrl.SetAppearTooltipAtMouseX(true);
	CloseBtn = GetButtonHandle((m_Windowname $ ".PopupProgressContents.Close_Btn"));
	CloseBtn.SetNameText("");
	return;
}

function SetProgressCollection(int numTotal, int numCompleted, int numProgress)
{
	local int numNotGo;

	Debug(((("SetProgressCollection 최대, 완료, 진행 : " @ string(numTotal)) @ string(numCompleted)) @ string(numProgress)));  // EN?: SetProgressCollection Max, Complete, Progress:
	numNotGo = ((numTotal - numProgress) - numCompleted);
	ANum00_txt.SetText((((string(numNotGo) @ "(") $ string(int(((float(numNotGo) / float(numTotal)) * 100.0000000)))) $ "%)"));
	ANum01_txt.SetText((((string(numProgress) @ "(") $ string(int(((float(numProgress) / float(numTotal)) * 100.0000000)))) $ "%)"));
	ANum02_txt.SetText((((string(numCompleted) @ "(") $ string(int(((float(numCompleted) / float(numTotal)) * 100.0000000)))) $ "%)"));
	ProgressCollectionComplete_wndScript.SetPoint(numCompleted, numTotal);
	return;
}

function SetProgressItem(int numTotal, int numCompleted)
{
	local int numNotGo;

	numNotGo = (numTotal - numCompleted);
	BNum00_txt.SetText((((string(numNotGo) @ "(") $ string(int(((float(numNotGo) / float(numTotal)) * 100.0000000)))) $ "%)"));
	BNum01_txt.SetText((((string(numCompleted) @ "(") $ string(int(((float(numCompleted) / float(numTotal)) * 100.0000000)))) $ "%)"));
	ProgressItemComplete_wndScript.SetPoint(numCompleted, numTotal);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(150);
	RegisterEvent(40);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 150:
			if(ChkSerVer())
			{
				HandleGameInit();
			}
			break;
		case 40:
			if(ChkSerVer())
			{
			}
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "Close_Btn":
			switch(collectionSystemScript.CurrentState)
			{
				case subProgress:
					collectionSystemScript.SetState(Sub);
					break;
				case mainProgress:
					collectionSystemScript.SetState(stand);
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	collectionSystemScript.C_EX_COLLECTION_SUMMARY();
	return;
}

function HandleGameInit()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	return;
}

function SetCollectionOptions()
{
	local int i, j;
	local array<CollectionOption> Options;
	local array<int> collectionIds;
	local CollectionData cData;

	List_ListCtrl.DeleteAllItem();
	collectionSystemScript.API_GetCollectionOption(Options);
	i = 0;
	while((i < Options.Length))
	{
		InsertList(Options[i], 0);
		i++;
	}
	collectionSystemScript.API_GetCompletePeriodCollection(collectionIds);
	i = 0;
	while((i < collectionIds.Length))
	{
		collectionSystemScript.API_GetCollectionData(collectionIds[i], cData);
		j = 0;
		while((j < cData.Option_filter.Length))
		{
			InsertList(cData.Option_filter[j], collectionIds[i], cData.Period);
			j++;
		}
		i++;
	}
	return;
}

function InsertList(CollectionOption Option, int CollectionID, optional int Period)
{
	local RichListCtrlRowData Record;

	Record = makeRecord(Option, CollectionID, Period);
	List_ListCtrl.InsertRecord(Record);
	return;
}

function RichListCtrlRowData makeRecord(CollectionOption Option, int CollectionID, int Period)
{
	local RichListCtrlRowData Record;

	Record.nReserved1 = INT64(CollectionID);
	Record.cellDataList.Length = 2;
	Record.cellDataList[0].szData = Option.Name;
	if((Period > 0))
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 11, 11);
		Record.nReserved2 = INT64(Period);
	}
	AddRichListCtrlString(Record.cellDataList[0].drawitems, Record.cellDataList[0].szData, util.White);
	if(Option.diff)
	{
		if((Option.Value > 0.0000000))
		{
			Record.cellDataList[1].szData = ("+" $ string(int(Option.Value)));
		}
		else
		{
			Record.cellDataList[1].szData = string(int(Option.Value));
		}
	}
	else if((Option.Value > 0.0000000))
	{
		Record.cellDataList[1].szData = ("+" $ getInstanceL2Util().CutFloatDecimalPlaces(Option.Value, 1));
	}
	else if((Option.Value < 0.0000000))
	{
		Record.cellDataList[1].szData = ("-" $ getInstanceL2Util().CutFloatDecimalPlaces(-Option.Value, 1));
	}
	AddRichListCtrlString(Record.cellDataList[1].drawitems, Record.cellDataList[1].szData, util.Yellow, false);
	return Record;
}

function bool ChkSerVer()
{
	return getInstanceUIData().GetIsLiveServer();
}
