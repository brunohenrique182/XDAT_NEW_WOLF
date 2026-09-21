class PlayerAgeWnd extends UIScript;

function OnLoad()
{
	SetClosingOnESC();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("PlayerAgeWnd").HideWindow();
	return;
}
