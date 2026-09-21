class HennaGaugeWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;

static function HennaGaugeWnd _InitScript(WindowHandle wnd)
{
	local HennaGaugeWnd scr;

	wnd.SetScript("HennaGaugeWnd");
	scr = HennaGaugeWnd(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	SetWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	return;
}

function SetWindow(string WindowName)
{
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	return;
}

function initPiece()
{
	local int i;

	i = 0;
	while((i < 30))
	{
		GetMeWindow((("GaugePiece" $ getInstanceL2Util().makeZeroString(2, INT64(i))) $ "_wnd")).HideWindow();
		GetAnimTextureHandle((((m_Windowname $ ".GaugePiece") $ getInstanceL2Util().makeZeroString(2, INT64(i))) $ "_wnd.GaugePieceAni_tex")).Stop();
		i++;
	}
	return;
}

function setFillPiece(int nPieceNum, bool bHiddenSkillSkin, bool bHiddenSkillEnable, bool bAnim)
{
	local int i;

	initPiece();
	i = 0;
	while((i < (nPieceNum + 1)))
	{
		if(bHiddenSkillSkin)
		{
			GetMeTexture((("GaugePiece" $ getInstanceL2Util().makeZeroString(2, INT64(i))) $ "_wnd.GaugePiece_tex")).SetTexture("L2UI_NewTex.HennaWnd.StatusBar02");
		}
		else
		{
			GetMeTexture((("GaugePiece" $ getInstanceL2Util().makeZeroString(2, INT64(i))) $ "_wnd.GaugePiece_tex")).SetTexture("L2UI_NewTex.HennaWnd.StatusBar01");
		}
		GetMeWindow((("GaugePiece" $ getInstanceL2Util().makeZeroString(2, INT64(i))) $ "_wnd")).ShowWindow();
		GetAnimTextureHandle((((m_Windowname $ ".GaugePiece") $ getInstanceL2Util().makeZeroString(2, INT64(i))) $ "_wnd.GaugePieceAni_tex")).Stop();
		i++;
	}
	if(bAnim)
	{
		GetAnimTextureHandle((((m_Windowname $ ".GaugePiece") $ getInstanceL2Util().makeZeroString(2, INT64((i - 1)))) $ "_wnd.GaugePieceAni_tex")).SetLoopCount(1);
		GetAnimTextureHandle((((m_Windowname $ ".GaugePiece") $ getInstanceL2Util().makeZeroString(2, INT64((i - 1)))) $ "_wnd.GaugePieceAni_tex")).Play();
	}
	return;
}

function setHiddenSkill(int nIndex, bool bShow, optional int SkillID, optional int SkillLevel, optional int nMovePieceNum)
{
	local Rect R;
	local int addLocY;
	local ItemInfo skillInfoItem;

	if((nIndex == 0))
	{
		addLocY = -40;
	}
	else if((nIndex == 1))
	{
		addLocY = 20;
	}
	else if((nIndex == 2))
	{
		addLocY = -40;
	}
	if(bShow)
	{
		R = GetMeTexture((("GaugePiece" $ getInstanceL2Util().makeZeroString(2, INT64(nMovePieceNum))) $ "_wnd.GaugePiece_tex")).GetRect();
		GetMeWindow((("GaugeHiddenSkillIcon0" $ string(nIndex)) $ "_wnd")).ShowWindow();
		GetMeWindow((("GaugeHiddenSkillIcon0" $ string(nIndex)) $ "_wnd")).MoveTo((R.nX - 6), (R.nY + addLocY));
	}
	else
	{
		GetMeWindow((("GaugeHiddenSkillIcon0" $ string(nIndex)) $ "_wnd")).HideWindow();
	}
	if((SkillID > 0))
	{
		skillInfoItem = getSkillToItemInfo(GetSkillInfoByValue(SkillID, SkillLevel, 0));
		GetMeItemWindow((((("GaugeHiddenSkillIcon0" $ string(nIndex)) $ "_wnd.GaugeHiddenSkillIcon0") $ string(nIndex)) $ "_itemwindow")).Clear();
		GetMeItemWindow((((("GaugeHiddenSkillIcon0" $ string(nIndex)) $ "_wnd.GaugeHiddenSkillIcon0") $ string(nIndex)) $ "_itemwindow")).AddItem(skillInfoItem);
	}
	return;
}
