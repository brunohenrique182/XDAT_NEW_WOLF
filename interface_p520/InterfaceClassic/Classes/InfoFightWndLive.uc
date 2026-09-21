class InfoFightWndLive extends InfoFightWndClassic;

event OnShow()
{
	local WindowHandle parentWnd;

	UpdateUIControls();
	parentWnd = GetWindowHandle("DetailStatusWnd");
	getInstanceL2Util().windowMoveToSide(parentWnd, Me);
	return;
}
