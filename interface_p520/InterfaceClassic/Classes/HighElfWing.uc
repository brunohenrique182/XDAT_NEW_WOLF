class HighElfWing extends UICommonAPI;

const TRAILER_NUM = 6;

var WindowHandle Me;
var WindowHandle targetWnd;
var TextureHandle targetTex;
var TextureHandle BackTex;
var AnimTextureHandle changeAniTex;
var AnimTextureHandle ActiveAniTex;
var AnimTextureHandle VanishingAniTex;
var int changeWidth;
var int nMyCurrentLP;
var int nMyMaxLP;
var int nMyCurrentLL;
var int nMyCurrentLPBefore;
var int nMyCurrentLLBefore;
var bool bOnCurrentLL;

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(3410);
	RegisterEvent(11640);
	RegisterEvent(11641);
	RegisterEvent(11642);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("HighElfWing");
	targetWnd = GetWindowHandle("HighElfWing.targetWnd");
	targetTex = GetTextureHandle("HighElfWing.targetWnd.targetTex");
	BackTex = GetTextureHandle("HighElfWing.backTex");
	changeAniTex = GetAnimTextureHandle("HighElfWing.changeAniTex");
	ActiveAniTex = GetAnimTextureHandle("HighElfWing.ActiveAniTex");
	VanishingAniTex = GetAnimTextureHandle("HighElfWing.VanishingAniTex");
	Me.HideWindow();
	ActiveAniTex.HideWindow();
	VanishingAniTex.HideWindow();
	BackTex.HideWindow();
	targetTex.HideWindow();
	bOnCurrentLL = false;
	return;
}

event OnTextureAnimEnd(AnimTextureHandle animTexHandle)
{
	switch(animTexHandle)
	{
		case ActiveAniTex:
			ActiveAniTex.HideWindow();
			AnimTexturePlay(VanishingAniTex, true, 1);
			break;
		case VanishingAniTex:
			VanishingAniTex.HideWindow();
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int Id, string param)
{
	local float nWidth;

	if((Id == 40))
	{
		nMyCurrentLP = 0;
		nMyCurrentLL = 0;
		bOnCurrentLL = false;
		Me.HideWindow();
		BackTex.HideWindow();
		targetTex.HideWindow();
		ActiveAniTex.HideWindow();
		VanishingAniTex.HideWindow();
		ShowHideTrailer(false);
		targetWnd.SetWindowSize(0, 64);
		SetTrailerUV(0);
	}
	else if((Id == 3410))
	{
		HandleStateChanged();
	}
	else if((Id == 11640))
	{
		bOnCurrentLL = true;
		nMyCurrentLLBefore = nMyCurrentLL;
		ParseInt(param, "MyCurrentLL", nMyCurrentLL);
		Debug(("nMyCurrentLL" @ string(nMyCurrentLL)));
		BackTex.ShowWindow();
		targetTex.ShowWindow();
		BackTex.SetTexture(getBackSkinTexture(nMyCurrentLL));
		targetTex.SetTexture(getFrontSkinTexture(nMyCurrentLL));
		ActiveAniTex.SetTexture(getActiveAniTexture(nMyCurrentLL));
		VanishingAniTex.SetTexture(getVanishingAniTexture(nMyCurrentLL));
		SetTrailerTextureByLV(nMyCurrentLL);
		if(((nMyCurrentLL != nMyCurrentLLBefore) && (nMyCurrentLLBefore != 0)))
		{
			AnimTexturePlay(changeAniTex, true, 1);
		}
		if((GetGameStateName() == "GAMINGSTATE"))
		{
			if((nMyMaxLP > 0))
			{
				Me.ShowWindow();
			}
		}
	}
	else if((Id == 11641))
	{
		nMyCurrentLPBefore = nMyCurrentLP;
		ParseInt(param, "MyCurrentLP", nMyCurrentLP);
		Debug(("nMyCurrentLP" @ string(nMyCurrentLP)));
		nWidth = float(ConvertFloatToString((((float(nMyCurrentLP) / float(nMyMaxLP)) * 100.0000000) * 1.2000000), 1, true));
		targetWnd.SetWindowSize(int(ConvertFloatToString(nWidth, 1, true)), 64);
		BackTex.SetTooltipCustomType(getCustomToolTip(nMyMaxLP, nMyCurrentLP));
		SetTrailerUV(int(nWidth));
		if(((nMyCurrentLP <= 0) || (nMyCurrentLP <= 100)))
		{
			ShowHideTrailer(false);
		}
		else
		{
			ShowHideTrailer(true);
		}
		if(((nMyCurrentLP == 0) && (nMyCurrentLPBefore != 0)))
		{
			AnimTexturePlay(ActiveAniTex, true, 1);
		}
	}
	else if((Id == 11642))
	{
		ParseInt(param, "MyMaxLP", nMyMaxLP);
		Debug(("nMyMaxLP" @ string(nMyMaxLP)));
		if((GetGameStateName() == "GAMINGSTATE"))
		{
			if(bOnCurrentLL)
			{
				Me.ShowWindow();
			}
		}
	}
	return;
}

function SetTrailerUV(int nWidth)
{
	local int i, W, Y;
	local TextureHandle trailerTexture;

	trailerTexture.GetWindowSize(W, Y);
	i = 0;
	while((i < 6))
	{
		trailerTexture = GetMeTexture(("targetWnd.trailer0" $ string((i + 1))));
		trailerTexture.GetWindowSize(W, Y);
		trailerTexture.SetUV((((120 + nWidth) - W) + 6), 0);
		i++;
	}
	return;
}

function ShowHideTrailer(bool bShow)
{
	local TextureHandle trailerTexture;
	local int i;

	i = 0;
	while((i < 6))
	{
		trailerTexture = GetMeTexture(("targetWnd.trailer0" $ string((i + 1))));
		if(bShow)
		{
			trailerTexture.ShowWindow();
			i++;
			continue;
		}
		trailerTexture.HideWindow();
		i++;
	}
	return;
}

function SetTrailerTextureByLV(int lv)
{
	local int i;
	local TextureHandle trailerTexture;

	i = 0;
	while((i < 6))
	{
		trailerTexture = GetMeTexture(("targetWnd.trailer0" $ string((i + 1))));
		trailerTexture.SetTexture((("L2UI_NewTex.HighElfWing.SacredLight_Lv" $ string(lv)) $ "_Trailer"));
		i++;
	}
	return;
}

function string getFrontSkinTexture(int nLevel)
{
	local string texStr;

	switch(nLevel)
	{
		case 0:
			texStr = "L2UI_NewTex.HighElfWing.SacredLight_Lv1";
			break;
		case 1:
			texStr = "L2UI_NewTex.HighElfWing.SacredLight_Lv1";
			break;
		case 2:
			texStr = "L2UI_NewTex.HighElfWing.SacredLight_Lv2";
			break;
		case 3:
			texStr = "L2UI_NewTex.HighElfWing.SacredLight_Lv3";
			break;
		default:
			break;
	}
	return texStr;
}

function string getBackSkinTexture(int nLevel)
{
	local string texStr;

	switch(nLevel)
	{
		case 0:
			texStr = "L2UI_NewTex.HighElfWing.SacredLight_Lv1_Bg";
			break;
		case 1:
			texStr = "L2UI_NewTex.HighElfWing.SacredLight_Lv1_Bg";
			break;
		case 2:
			texStr = "L2UI_NewTex.HighElfWing.SacredLight_Lv2_Bg";
			break;
		case 3:
			texStr = "L2UI_NewTex.HighElfWing.SacredLight_Lv3_Bg";
			break;
		default:
			break;
	}
	return texStr;
}

function string getActiveAniTexture(int nLevel)
{
	local string texStr;

	switch(nLevel)
	{
		case 0:
			texStr = "L2UI_NewTex.HighElfWing.LightActiveLv1Effect001";
			break;
		case 1:
			texStr = "L2UI_NewTex.HighElfWing.LightActiveLv1Effect001";
			break;
		case 2:
			texStr = "L2UI_NewTex.HighElfWing.LightActiveLv2Effect001";
			break;
		case 3:
			texStr = "L2UI_NewTex.HighElfWing.LightActiveLv3Effect001";
			break;
		default:
			break;
	}
	return texStr;
}

function string getVanishingAniTexture(int nLevel)
{
	local string texStr;

	switch(nLevel)
	{
		case 0:
			texStr = "L2UI_NewTex.HighElfWing.LightVanishLv1Effect000";
			break;
		case 1:
			texStr = "L2UI_NewTex.HighElfWing.LightVanishLv1Effect000";
			break;
		case 2:
			texStr = "L2UI_NewTex.HighElfWing.LightVanishLv2Effect000";
			break;
		case 3:
			texStr = "L2UI_NewTex.HighElfWing.LightVanishLv3Effect000";
			break;
		default:
			break;
	}
	return texStr;
}

function CustomTooltip getCustomToolTip(int nMax, int nCurrent)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14696), getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip();
	drawListArr[drawListArr.Length] = addDrawItemText(((string(nCurrent) $ "/") $ string(nMax)), getInstanceL2Util().BrightWhite, "", true, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function HandleStateChanged()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	if((nMyMaxLP > 0))
	{
		if(bOnCurrentLL)
		{
			Me.ShowWindow();
		}
	}
	return;
}
