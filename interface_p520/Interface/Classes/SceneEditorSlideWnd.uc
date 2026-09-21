class SceneEditorSlideWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var WindowHandle ScreenWnd;
var WindowHandle Slide;
var WindowHandle BackSlide;
var WindowHandle CurSlide;
var WindowHandle NextSlide;
var TextureHandle SlideTexture;
var TextureHandle BackSlideTexture;
var TextureHandle CurSlideTexture;
var TextureHandle NextSlideTexture;

function OnRegisterEvent()
{
	RegisterEvent(4550);
	RegisterEvent(2900);
	return;
}

function OnLoad()
{
	Me = GetWindowHandle("SceneEditorSlideWnd");
	ScreenWnd = GetWindowHandle("SceneEditorSlideWnd.ScreenWnd");
	Slide = GetWindowHandle("SceneEditorSlideWnd.ScreenWnd.Slide");
	BackSlide = GetWindowHandle("SceneEditorSlideWnd.ScreenWnd.BackSlide");
	SlideTexture = GetTextureHandle("SceneEditorSlideWnd.ScreenWnd.Slide.SlideTexture");
	BackSlideTexture = GetTextureHandle("SceneEditorSlideWnd.ScreenWnd.BackSlide.BackSlideTexture");
	CurSlide = Slide;
	NextSlide = BackSlide;
	CurSlideTexture = SlideTexture;
	NextSlideTexture = BackSlideTexture;
	Me.SetCanBeShownDuringScene(true);
	ScreenWnd.SetCanBeShownDuringScene(true);
	Slide.SetCanBeShownDuringScene(true);
	BackSlide.SetCanBeShownDuringScene(true);
	CurSlide.SetCanBeShownDuringScene(true);
	NextSlide.SetCanBeShownDuringScene(true);
	if(!IsL2NetLoginState())
	{
		RegisterState("SceneEditorSlideWnd", "PawnViewerState");
	}
	CheckResolution();
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int Type, Time, Dir;
	local string TexName;
	local int USize, VSize, MoveRatio, WndRatio, ScreenWndWidth, ScreenWndHeight, MoveVal;
	local WindowHandle TempSlide;
	local TextureHandle TempSlideTexture;

	if((Event_ID == 4550))
	{
		ParseInt(param, "Type", Type);
		ParseInt(param, "Time", Time);
		ParseInt(param, "Dir", Dir);
		ParseString(param, "TexName", TexName);
		ParseInt(param, "USize", USize);
		ParseInt(param, "VSize", VSize);
		ParseInt(param, "MoveRatio", MoveRatio);
		ParseInt(param, "WndRatio", WndRatio);
		if(((USize == 1) && (VSize == 1)))
		{
			Debug("SceneEditorSlideWnd Message :Apply Slide TCT_Stretch ");
			SlideTexture.SetTextureCtrlType(TCT_Stretch);
			CurSlideTexture.SetTextureCtrlType(TCT_Stretch);
			BackSlideTexture.SetTextureCtrlType(TCT_Stretch);
			NextSlideTexture.SetTextureCtrlType(TCT_Stretch);
		}
		switch(Type)
		{
			case 3:
				SlideTexture.SetTexture("Default.BlackTexture");
				BackSlideTexture.SetTexture("Default.BlackTexture");
				Me.ShowWindow();
				break;
			case 4:
				if((Dir != 0))
				{
					break;
				}
				CurSlide.SetShowAndHideAnimType(false, Dir, 1.0000000);
				CurSlide.HideWindow();
				ScreenWnd.GetWindowSize(ScreenWndWidth, ScreenWndHeight);
				NextSlide.SetWindowSize(ScreenWndWidth, ScreenWndHeight);
				NextSlideTexture.SetWindowSize(ScreenWndWidth, ScreenWndHeight);
				NextSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "TopLeft", "TopLeft", 0, 0);
				NextSlideTexture.SetTextureSize(USize, VSize);
				NextSlideTexture.SetTexture(TexName);
				NextSlide.SetShowAndHideAnimType(true, Dir, (float(Time) / 1000.0000000));
				NextSlide.ShowWindow();
				TempSlide = CurSlide;
				CurSlide = NextSlide;
				NextSlide = TempSlide;
				TempSlideTexture = CurSlideTexture;
				CurSlideTexture = NextSlideTexture;
				NextSlideTexture = TempSlideTexture;
				break;
			case 5:
				ScreenWnd.GetWindowSize(ScreenWndWidth, ScreenWndHeight);
				switch(Dir)
				{
					case 0:
						return;
					case 1:
						CurSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "TopLeft", "TopLeft", 0, 0);
						CurSlide.SetWindowSize(((ScreenWndWidth * WndRatio) / 100), ScreenWndHeight);
						CurSlideTexture.SetWindowSize(((ScreenWndWidth * WndRatio) / 100), ScreenWndHeight);
						break;
					case 2:
						CurSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "TopRight", "TopRight", 0, 0);
						CurSlide.SetWindowSize(((ScreenWndWidth * WndRatio) / 100), ScreenWndHeight);
						CurSlideTexture.SetWindowSize(((ScreenWndWidth * WndRatio) / 100), ScreenWndHeight);
						break;
					case 3:
						CurSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "TopLeft", "TopLeft", 0, 0);
						CurSlide.SetWindowSize(ScreenWndWidth, ((ScreenWndHeight * WndRatio) / 100));
						CurSlideTexture.SetWindowSize(ScreenWndWidth, ((ScreenWndHeight * WndRatio) / 100));
						break;
					case 4:
						CurSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "BottomLeft", "BottomLeft", 0, 0);
						CurSlide.SetWindowSize(ScreenWndWidth, ((ScreenWndHeight * WndRatio) / 100));
						CurSlideTexture.SetWindowSize(ScreenWndWidth, ((ScreenWndHeight * WndRatio) / 100));
						break;
					default:
						return;
				}
				CurSlideTexture.SetTextureSize(USize, VSize);
				CurSlideTexture.SetTexture(TexName);
				CurSlide.ClearAnchor();
				switch(Dir)
				{
					case 0:
						return;
					case 1:
						MoveVal = (((ScreenWndWidth * MoveRatio) / 100) * -1);
						CurSlide.MoveExWithTime(MoveVal, 0, (float(Time) / 1000.0000000));
						break;
					case 2:
						MoveVal = ((ScreenWndWidth * MoveRatio) / 100);
						CurSlide.MoveExWithTime(MoveVal, 0, (float(Time) / 1000.0000000));
						break;
					case 3:
						MoveVal = (((ScreenWndHeight * MoveRatio) / 100) * -1);
						CurSlide.MoveExWithTime(0, MoveVal, (float(Time) / 1000.0000000));
						break;
					case 4:
						MoveVal = ((ScreenWndHeight * MoveRatio) / 100);
						CurSlide.MoveExWithTime(0, MoveVal, (float(Time) / 1000.0000000));
						break;
					default:
						return;
				}
				break;
			case 6:
				Me.HideWindow();
				break;
			default:
				break;
		}
	}
	else if((Event_ID == 2900))
	{
		CheckResolution();
	}
	return;
}

function CheckResolution()
{
	local int CurrentMaxWidth, CurrentMaxHeight;

	GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
	ScreenWnd.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	ScreenWnd.SetAnchor("SceneEditorSlideWnd", "CenterCenter", "CenterCenter", 0, 0);
	ScreenWnd.SetWindowSizeRel43(1.0000000, 1.0000000, 0, 0);
	ScreenWnd.GetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	Slide.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	SlideTexture.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	BackSlide.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	BackSlideTexture.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
	return;
}
