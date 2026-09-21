class UIControlPageNavi extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var TextBoxHandle currPageText;
var TextBoxHandle nextPageText;
var TextBoxHandle dividPageText;
var ButtonHandle nextBtn;
var ButtonHandle prevBtn;
var ButtonHandle nextMaxBtn;
var ButtonHandle prevMaxBtn;
var ButtonHandle emptyBtn;
var int TotalPage;
var int currPage;
var bool bDisabled;
var bool bUseMax;
var bool bNoUseGo;
//var delegate<DelegeOnChangePage> __DelegeOnChangePage__Delegate;
//var delegate<DelegateOnClickButton> __DelegateOnClickButton__Delegate;

delegate DelegeOnChangePage(int Page)
{
	return;
}

delegate DelegateOnClickButton(string strName)
{
	return;
}

static function UIControlPageNavi InitScript(WindowHandle wnd)
{
	local UIControlPageNavi scr;

	wnd.SetScript("UIControlPageNavi");
	scr = UIControlPageNavi(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	Init(m_hOwnerWnd.m_WindowNameWithFullPath);
	return;
}

function Init(string WindowName)
{
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	currPageText = GetTextBoxHandle((m_Windowname $ ".ControlNavi_currPageText"));
	nextPageText = GetTextBoxHandle((m_Windowname $ ".ControlNavi_nextPageText"));
	dividPageText = GetTextBoxHandle((m_Windowname $ ".ControlNavi_dividPageText"));
	nextBtn = GetButtonHandle((m_Windowname $ ".ControlNavi_nextBtn"));
	prevBtn = GetButtonHandle((m_Windowname $ ".ControlNavi_prevBtn"));
	if(bUseMax)
	{
		nextMaxBtn = GetButtonHandle((m_Windowname $ ".ControlNavi_nextMaxBtn"));
		prevMaxBtn = GetButtonHandle((m_Windowname $ ".ControlNavi_prevMaxBtn"));
	}
	currPage = -1;
	SetDisable(false);
	return;
}

function OnClickButton(string Name)
{
	DelegateOnClickButton(Name);
	switch(Name)
	{
		case "ControlNavi_nextBtn":
			if((bNoUseGo == false))
			{
				Go((currPage + 1));
			}
			break;
		case "ControlNavi_prevBtn":
			if((bNoUseGo == false))
			{
				Go((currPage - 1));
			}
			break;
		case "ControlNavi_nextMaxBtn":
			Go(TotalPage);
			break;
		case "ControlNavi_prevMaxBtn":
			Go(1);
			break;
		default:
			break;
	}
	return;
}

function SetDisable(bool bDisable)
{
	local Color tmpColor, currTmpColor;

	bDisabled = bDisable;
	if(bDisabled)
	{
		tmpColor = GetColor(153, 153, 153, 255);
		currTmpColor = tmpColor;
	}
	else
	{
		tmpColor = GetColor(189, 189, 189, 255);
		currTmpColor = getInstanceL2Util().Yellow;
	}
	BtnCheck();
	currPageText.SetTextColor(currTmpColor);
	nextPageText.SetTextColor(tmpColor);
	dividPageText.SetTextColor(tmpColor);
	return;
}

function SetNoUseGo(bool bNoUseGoP)
{
	bNoUseGo = bNoUseGoP;
	return;
}

function Go(int Page)
{
	if((Page <= 1))
	{
		Page = 1;
	}
	if((Page > TotalPage))
	{
		Page = TotalPage;
	}
	if((Page == currPage))
	{
		return;
	}
	currPage = Page;
	BtnCheck();
	currPageText.SetText(string(currPage));
	if((currPage != -1))
	{
		DelegeOnChangePage(currPage);
	}
	return;
}

function setPageText(int Page)
{
	if((Page <= 1))
	{
		Page = 1;
	}
	if((Page > TotalPage))
	{
		Page = TotalPage;
	}
	currPage = Page;
	BtnCheck();
	currPageText.SetText(string(currPage));
	return;
}

function SetTotalPage(int Page)
{
	TotalPage = Page;
	if((Page > TotalPage))
	{
		Page = TotalPage;
		Go(Page);
	}
	nextPageText.SetText(string(Page));
	return;
}

function int GetPage()
{
	return currPage;
}

function int GetTotalPage()
{
	return TotalPage;
}

function bool IsDisalbed()
{
	return bDisabled;
}

function BtnCheck()
{
	if(bDisabled)
	{
		prevBtn.DisableWindow();
		nextBtn.DisableWindow();
		if(bUseMax)
		{
			nextMaxBtn.DisableWindow();
			prevMaxBtn.DisableWindow();
		}
	}
	else
	{
		if((currPage == 1))
		{
			prevBtn.DisableWindow();
			if(bUseMax)
			{
				prevMaxBtn.DisableWindow();
			}
		}
		else
		{
			prevBtn.EnableWindow();
			if(bUseMax)
			{
				prevMaxBtn.EnableWindow();
			}
		}
		if((currPage == TotalPage))
		{
			nextBtn.DisableWindow();
			if(bUseMax)
			{
				nextMaxBtn.DisableWindow();
			}
		}
		else
		{
			nextBtn.EnableWindow();
			if(bUseMax)
			{
				nextMaxBtn.EnableWindow();
			}
		}
	}
	return;
}

function string Int2Str2(int i)
{
	if((i < 10))
	{
		return ("0" $ string(i));
	}
	return string(i);
}
