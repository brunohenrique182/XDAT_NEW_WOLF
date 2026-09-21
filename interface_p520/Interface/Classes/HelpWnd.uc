class HelpWnd extends UICommonAPI;

const ERRORMESSAGEID = 99;
const HELPID_COLLECTION = 62;
const HELPID_POTENTIAL = 69;

var WindowHandle Me;
var TreeHandle MainTree;
var HtmlHandle HtmlViewer;
var string ROOTNAME;
var string treeName;
var int bodyCount;
var int CurrentID;
var int bodyCountCurrent;
var string expenedNode;
var ButtonHandle BtnNext;
var ButtonHandle btnPrev;
var TextBoxHandle txtNumber;
var bool indexLoaded;
//var delegate<OnSortCompareOrder> __OnSortCompareOrder__Delegate;

function Initialize()
{
	Me = GetWindowHandle("HelpWnd");
	MainTree = GetTreeHandle("HelpWnd.MainTree");
	HtmlViewer = GetHtmlHandle("HelpWnd.HtmlViewer");
	BtnNext = GetButtonHandle("HelpWnd.btnNext");
	btnPrev = GetButtonHandle("HelpWnd.btnPrev");
	txtNumber = GetTextBoxHandle("HelpWnd.txtNumber");
	ROOTNAME = "root";
	treeName = "HelpWnd.MainTree";
	bodyCountCurrent = 1;
	bodyCount = 1;
	SetButtonState();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(1210);
	RegisterEvent(10700);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	RegisterState(getCurrentWindowName(string(self)), "GamingState");
	RegisterState(getCurrentWindowName(string(self)), "LoginState");
	Initialize();
	return;
}

event OnEvent(int EventID, string param)
{
	if((GetGameStateName() == "SERVERLISTSTATE"))
	{
		return;
	}
	switch(EventID)
	{
		case 1210:
			OpenHelp(param);
			break;
		case 10700:
			HandleTutorialShow(param);
			break;
		case 40:
			indexLoaded = false;
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	PlayConsoleSound(IFST_WINDOW_OPEN);
	return;
}

event OnHide()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnNext":
			bodyCountCurrent++;
			SetButtonState();
			LoadHtml();
			break;
		case "btnPrev":
			bodyCountCurrent--;
			SetButtonState();
			LoadHtml();
			break;
		default:
			ClickTreeNode(Name);
			SetButtonState();
			LoadHtml();
			MainTree.SetFocus();
			break;
	}
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

function ClickTreeNode(string Name)
{
	local array<string> Result, bodyInfo;

	if((expenedNode == Name))
	{
		MainTree.SetExpandedNode(expenedNode, true);
		return;
	}
	Split(Name, ".", Result);
	if((Result.Length < 3))
	{
		return;
	}
	if((expenedNode != ""))
	{
		MainTree.SetExpandedNode(expenedNode, false);
	}
	expenedNode = Name;
	Split(Result[2], ",", bodyInfo);
	CurrentID = int(bodyInfo[0]);
	bodyCount = int(bodyInfo[1]);
	bodyCountCurrent = 1;
	return;
}

function SetButtonState()
{
	txtNumber.SetText(((string(bodyCountCurrent) $ "/") $ string(bodyCount)));
	if((bodyCountCurrent == 1))
	{
		btnPrev.DisableWindow();
	}
	else
	{
		btnPrev.EnableWindow();
	}
	if((bodyCountCurrent == bodyCount))
	{
		BtnNext.DisableWindow();
	}
	else
	{
		BtnNext.EnableWindow();
	}
	return;
}

function HandleTutorialShow(string param)
{
	local int Id, Level;

	ParseInt(param, "ID", Id);
	ParseInt(param, "Level", Level);
	if((Id > 0))
	{
		Class'Interface.HelpWnd'.static.ShowHelp(Id, Level);
	}
	return;
}

function OpenHelp(string param)
{
	local string strPath;

	ParseString(param, "FilePath", strPath);
	if(((int(param) <= 0) && (strPath != "")))
	{
		if(Me.IsShowWindow())
		{
			Me.HideWindow();
		}
		return;
	}
	Class'Interface.HelpWnd'.static.ShowHelp(int(param));
	return;
}

delegate int OnSortCompareOrder(TutorialIndex A, TutorialIndex B)
{
	if((A.ORDER > B.ORDER))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function HelpIndexLoad()
{
	local array<TutorialIndex> TutorialIndexs;

	if(indexLoaded)
	{
		return;
	}
	GetTutorialIndices(TutorialIndexs);
	// TutorialIndexs.Sort(OnSortCompareOrder);   // array.Sort() unsupported by this compiler
	SetHelpCategroyTreeNode(TutorialIndexs);
	indexLoaded = true;
	return;
}

function SetExpandedNodeByID(int Id, optional int bodyCount)
{
	local int i;
	local array<TutorialIndex> TutorialIndexs;
	local string NodeName, categoryNodeName;

	HelpIndexLoad();
	GetTutorialIndices(TutorialIndexs);
	i = 0;
	while((i < TutorialIndexs.Length))
	{
		if((TutorialIndexs[i].Id == Id))
		{
			categoryNodeName = ((ROOTNAME $ ".") $ string(TutorialIndexs[i].Category));
			NodeName = ((((categoryNodeName $ ".") $ string(TutorialIndexs[i].Id)) $ ",") $ string(TutorialIndexs[i].LevelCount));
			MainTree.SetExpandedNode(categoryNodeName, true);
			MainTree.SetExpandedNode(NodeName, true);
			ClickTreeNode(NodeName);
			bodyCountCurrent = Max(1, bodyCount);
			SetButtonState();
			LoadHtml();
			return;
		}
		i++;
	}
	return;
}

function SetHelpCategroyTreeNode(array<TutorialIndex> TutorialIndexs)
{
	local int i, CategoryIndex, backLineNum;
	local string strRetName, subTreeName;

	MainTree.Clear();
	getInstanceL2Util().TreeInsertRootNode(treeName, ROOTNAME, "", 0, 0);
	CategoryIndex = -1;
	i = 0;
	while((i < TutorialIndexs.Length))
	{
		if((CategoryIndex != TutorialIndexs[i].Category))
		{
			CategoryIndex = TutorialIndexs[i].Category;
			strRetName = InsertExpandNode(string(CategoryIndex), ROOTNAME);
			getInstanceL2Util().TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 190, 30, 0, -5);
			getInstanceL2Util().TreeInsertTextNodeItem(treeName, strRetName, GetSystemString(CategoryIndex), -188, 9, COLOR_DEFAULT);
		}
		if(!IsShowHelpID(TutorialIndexs[i].Id))
		{
			i++;
			continue;
		}
		subTreeName = InsertNode(MakeNodeName(TutorialIndexs[i]), strRetName);
		backLineNum++;
		if(((float(backLineNum) % 2.0000000) == 0.0000000))
		{
			getInstanceL2Util().TreeInsertTextureNodeItem(treeName, subTreeName, "L2UI_CT1.EmptyBtn", 192, 20);
		}
		else
		{
			getInstanceL2Util().TreeInsertTextureNodeItem(treeName, subTreeName, "L2UI_CH3.etc.textbackline", 192, 20, , , , , 14);
		}
		getInstanceL2Util().TreeInsertTextureNodeItem(treeName, subTreeName, "L2UI_CT1.BTN_Icon_Normal", 16, 16, (9 - 192), 2);
		getInstanceL2Util().TreeInsertTextNodeItem(treeName, subTreeName, TutorialIndexs[i].Name, 3, 4, COLOR_GOLD);
		i++;
	}
	return;
}

function string MakeNodeName(TutorialIndex TutorialIndex)
{
	return ((string(TutorialIndex.Id) $ ",") $ string(TutorialIndex.LevelCount));
}

function string InsertNode(string NodeName, string parentname)
{
	local XMLTreeNodeInfo infNode, infNodeClear;

	infNode = infNodeClear;
	infNode.bShowButton = 0;
	infNode.strName = NodeName;
	infNode.bFollowCursor = true;
	infNode.nOffSetX = 2;
	infNode.nTexExpandedOffSetX = 0;
	infNode.nTexExpandedOffSetY = 0;
	infNode.nTexExpandedHeight = 20;
	infNode.nTexExpandedRightWidth = 0;
	infNode.nTexExpandedLeftUWidth = 1;
	infNode.nTexExpandedLeftUHeight = 15;
	infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	return Class'NWindow.UIAPI_TREECTRL'.static.InsertNode(treeName, parentname, infNode);
}

function string InsertExpandNode(string NodeName, string parentname)
{
	local XMLTreeNodeInfo infNode, infNodeClear;

	infNode = infNodeClear;
	infNode.strName = NodeName;
	infNode.bFollowCursor = true;
	infNode.bShowButton = 1;
	infNode.nTexBtnOffSetY = 8;
	infNode.nTexBtnWidth = 15;
	infNode.nTexBtnHeight = 15;
	infNode.strTexBtnExpand = "l2ui_ch3.QuestWnd.QuestWndPlusBtn";
	infNode.strTexBtnCollapse = "l2ui_ch3.QuestWnd.QuestWndMinusBtn";
	return Class'NWindow.UIAPI_TREECTRL'.static.InsertNode(treeName, parentname, infNode);
}

function bool IsShowHelpID(int helpID)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		switch(helpID)
		{
			case 62:
				return IsCollectionServer();
			case 69:
				return IsPotentialServer();
			default:
				break;
		}
	}
	else
	{
		return true;
	}
	return true;
}

function LoadHtml()
{
	local TutorialBody body;

	GetTutorialBody(CurrentID, bodyCountCurrent, body);
	HtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(body.Description));
	return;
}

function LoadHtmlTest(string param)
{
	HtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(param));
	return;
}

static function ShowHelp(optional int Id, optional int bodyCount)
{
	local HelpWnd helpWndScr;

	helpWndScr = HelpWnd(GetScript("HelpWnd"));
	if(helpWndScr.Me.IsShowWindow())
	{
		helpWndScr.Me.HideWindow();
		return;
	}
	helpWndScr.SetExpandedNodeByID(Id, bodyCount);
	helpWndScr.Me.ShowWindow();
	helpWndScr.HtmlViewer.SetFocus();
	return;
}
