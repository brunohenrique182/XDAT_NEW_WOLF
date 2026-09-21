class UIDragImg extends UICommonAPI;

var WindowHandle Me;
var TextureHandle imgTexture;

function OnRegisterEvent()
{
	RegisterEvent(18);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("UIDragImg");
	imgTexture = GetTextureHandle("UIDragImg.imgTexture");
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int W, h;
	local string imgPath;

	switch(Event_ID)
	{
		case 18:
			ParseInt(param, "w", W);
			ParseInt(param, "h", h);
			ParseString(param, "t", imgPath);
			if((imgPath != ""))
			{
				Me.ShowWindow();
				Me.SetFocus();
				Me.SetWindowSize(W, h);
				imgTexture.SetWindowSize(W, h);
				imgTexture.SetTexture(imgPath);
			}
			break;
		default:
			break;
	}
	return;
}

function OnReceivedCloseUI()
{
	Me.HideWindow();
	return;
}
