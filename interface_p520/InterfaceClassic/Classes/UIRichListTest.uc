class UIRichListTest extends UICommonAPI;

var WindowHandle Me;
var RichListCtrlHandle testRichListCtrl;
var ButtonHandle test1Button;
var ButtonHandle test2Button;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("UIRichListTest");
	testRichListCtrl = GetRichListCtrlHandle("UIRichListTest.testRichListCtrl");
	test1Button = GetButtonHandle("UIRichListTest.test1Button");
	test2Button = GetButtonHandle("UIRichListTest.test2Button");
	return;
}

function OnShow()
{
	testRichListCtrl.DeleteAllItem();
	InsertList("오징어");  // EN?: Squid
	InsertList("문어");  // EN?: Written language
	InsertList("고등어", true);  // EN?: Mackerel
	InsertList("오징어");  // EN?: Squid
	InsertList("문어");  // EN?: Written language
	InsertList("고등어");  // EN?: Mackerel
	InsertList("오징어", true);  // EN?: Squid
	InsertList("문어");  // EN?: Written language
	InsertList("고등어");  // EN?: Mackerel
	InsertList("오징어");  // EN?: Squid
	InsertList("문어");  // EN?: Written language
	InsertList("고등어");  // EN?: Mackerel
	InsertList("오징어", true);  // EN?: Squid
	InsertList("문어");  // EN?: Written language
	InsertList("고등어");  // EN?: Mackerel
	return;
}

function InsertList(string Title, optional bool AddFile)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 2;
	if(AddFile)
	{
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.POSTWND.PostWnd_DF_Icon_Accompany_confirmed", 18, 12, 5, 5);
		rowData.nReserved2 = INT64(1);
	}
	else
	{
		AddRichListCtrlButton(rowData.cellDataList[0].drawitems, "SelectedCheckBtn", 4, 12, "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", 16, 16, 16, 16);
		rowData.nReserved2 = INT64(0);
	}
	rowData.cellDataList[0].drawitems[(rowData.cellDataList[0].drawitems.Length - 1)].TooltipDesc = GetSystemString(7529);
	rowData.nReserved1 = INT64(0);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Title, GTColor().White, false, 5, 2);
	testRichListCtrl.InsertRecord(rowData);
	return;
}

function OnClickCheckBox(string strID)
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < testRichListCtrl.GetRecordCount()))
	{
		testRichListCtrl.GetRec(i, rowData);
		if((GetMeCheckBox("allSelectCheckBox").IsChecked() && (rowData.nReserved2 == INT64(0))))
		{
			modifyRichListCtrlButton(rowData.cellDataList[0].drawitems, 0, "SelectedCheckBtn", 4, 12, "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox_checked", 16, 16, 16, 16);
			rowData.nReserved1 = INT64(1);
		}
		else if((!GetMeCheckBox("allSelectCheckBox").IsChecked() && (rowData.nReserved2 == INT64(0))))
		{
			modifyRichListCtrlButton(rowData.cellDataList[0].drawitems, 0, "SelectedCheckBtn", 4, 12, "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", 16, 16, 16, 16);
			rowData.nReserved1 = INT64(0);
		}
		testRichListCtrl.ModifyRecord(i, rowData);
		i++;
	}
	return;
}

function checkBoxSelectCheck()
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < testRichListCtrl.GetRecordCount()))
	{
		testRichListCtrl.GetRec(i, rowData);
		if((rowData.nReserved1 == INT64(0)))
		{
			GetMeCheckBox("allSelectCheckBox").SetCheck(false);
			break;
		}
		i++;
	}
	return;
}

function onSelectedCheckBtnClick()
{
	local RichListCtrlRowData rowData;

	Debug(("rewardBtn --> " @ string(testRichListCtrl.GetSelectedIndex())));
	testRichListCtrl.GetRec(testRichListCtrl.GetSelectedIndex(), rowData);
	Debug(("RowData.nReserved1" @ string(rowData.nReserved1)));
	if((rowData.nReserved1 == INT64(0)))
	{
		modifyRichListCtrlButton(rowData.cellDataList[0].drawitems, 0, "SelectedCheckBtn", 4, 12, "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox_checked", "L2UI.Control.CheckBox_checked", 16, 16, 16, 16);
		rowData.nReserved1 = INT64(1);
	}
	else
	{
		modifyRichListCtrlButton(rowData.cellDataList[0].drawitems, 0, "SelectedCheckBtn", 4, 12, "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", "L2UI.Control.CheckBox", 16, 16, 16, 16);
		rowData.nReserved1 = INT64(0);
	}
	testRichListCtrl.ModifyRecord(testRichListCtrl.GetSelectedIndex(), rowData);
	checkBoxSelectCheck();
	return;
}

function OnClickButton(string Name)
{
	Debug(("Name" @ Name));
	switch(Name)
	{
		case "test1Button":
			Ontest1ButtonClick();
			break;
		case "test2Button":
			Ontest2ButtonClick();
			break;
		case "SelectedCheckBtn":
			onSelectedCheckBtnClick();
			break;
		default:
			break;
	}
	return;
}

function Ontest1ButtonClick()
{
	local int i, sum;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < testRichListCtrl.GetRecordCount()))
	{
		testRichListCtrl.GetRec(i, rowData);
		if((rowData.nReserved1 > INT64(0)))
		{
			sum++;
		}
		i++;
	}
	Debug(("checkbox Sum" $ string(sum)));
	return;
}

function Ontest2ButtonClick()
{
	return;
}
