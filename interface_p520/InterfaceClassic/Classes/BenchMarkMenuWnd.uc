class BenchMarkMenuWnd extends UIScript;

function OnLoad()
{
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("BenchMarkMenuWnd.BenchMarkFunctionWnd");
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnPlay":
			BeginPlay();
			break;
		case "btnBenchMark":
			BeginBenchMark();
			break;
		case "btnOption":
			ShowOptionWnd();
			break;
		case "btnExit":
			ExecQuit();
			break;
		default:
			break;
	}
	return;
}

function ShowOptionWnd()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("OptionWnd"))
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("OptionWnd");
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("OptionWnd");
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("OptionWnd");
	}
	return;
}
