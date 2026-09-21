class HairshopWnd extends UICommonAPI;

const NUMCOLORSPACE = 2;

var WindowHandle Me;
var SliderCtrlHandle RHColorCtrl[2];
var SliderCtrlHandle GSColorCtrl[2];
var SliderCtrlHandle BVColorCtrl[2];
var int colorspaceIndex;
var ComboBoxHandle ColorspaceBox;
var ComboBoxHandle hairTypeBox;
var CheckBoxHandle NewHairUseBox;
var CheckBoxHandle HairColorUseBox;
var ButtonHandle btnClose;
var EditBoxHandle RHColorBox;
var EditBoxHandle GSColorBox;
var EditBoxHandle BVColorBox;
var bool bUseNewHair;
var bool bUseHairColor;
var int gHairtype;
var int nColorRH[2];
var int nColorGS[2];
var int nColorBV[2];
var int savedHairtype;

function OnRegisterEvent()
{
	RegisterEvent(9410);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	return;
}

function Initialize()
{
	local int i;

	Me = GetWindowHandle("HairshopWnd");
	RHColorCtrl[0] = GetSliderCtrlHandle("HairshopWnd.RColorCtrl");
	GSColorCtrl[0] = GetSliderCtrlHandle("HairshopWnd.GColorCtrl");
	BVColorCtrl[0] = GetSliderCtrlHandle("HairshopWnd.BColorCtrl");
	RHColorCtrl[1] = GetSliderCtrlHandle("HairshopWnd.HColorCtrl");
	GSColorCtrl[1] = GetSliderCtrlHandle("HairshopWnd.SColorCtrl");
	BVColorCtrl[1] = GetSliderCtrlHandle("HairshopWnd.VColorCtrl");
	ColorspaceBox = GetComboBoxHandle("HairshopWnd.ColorspaceBox");
	hairTypeBox = GetComboBoxHandle("HairshopWnd.hairTypeBox");
	NewHairUseBox = GetCheckBoxHandle("HairshopWnd.NewHairUseBox");
	HairColorUseBox = GetCheckBoxHandle("HairshopWnd.HairColorUseBox");
	btnClose = GetButtonHandle("HairshopWnd.btnClose");
	RHColorBox = GetEditBoxHandle("HairshopWnd.RColorBox");
	GSColorBox = GetEditBoxHandle("HairshopWnd.GColorBox");
	BVColorBox = GetEditBoxHandle("HairshopWnd.BColorBox");
	colorspaceIndex = 0;
	gHairtype = 0;
	updateHairColorData();
	i = 0;
	while((i < 2))
	{
		hideAllSliderBar(i);
		i++;
	}
	i = 0;
	while((i < gHairtype))
	{
		hairTypeBox.AddString(ConvertNumToTextNoAdena(string(i)));
		i++;
	}
	showAllSliderBar(colorspaceIndex);
	setRGBTextBox(nColorRH[colorspaceIndex], nColorGS[colorspaceIndex], nColorBV[colorspaceIndex]);
	savedHairtype = 0;
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9410:
			handleHairColorData(param);
			break;
		default:
			break;
	}
	return;
}

function OnClickCheckBox(string strID)
{
	applyData();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnClose":
			OnBtnCloseClick();
			break;
		default:
			break;
	}
	return;
}

function OnComboBoxItemSelected(string strID, int Index)
{
	local int i;

	if((strID == "ColorspaceBox"))
	{
		colorspaceIndex = Index;
		i = 0;
		while((i < 2))
		{
			if((i == Index))
			{
				showAllSliderBar(i);
				i++;
				continue;
			}
			hideAllSliderBar(i);
			i++;
		}
		setRGBTextBox(nColorRH[colorspaceIndex], nColorGS[colorspaceIndex], nColorBV[colorspaceIndex]);
	}
	else if((strID == "hairTypeBox"))
	{
		Class'NWindow.HairshopAPI'.static.ApplyHairType(Index);
		savedHairtype = Index;
	}
	return;
}

function showAllSliderBar(int idx)
{
	RHColorCtrl[idx].ShowWindow();
	GSColorCtrl[idx].ShowWindow();
	BVColorCtrl[idx].ShowWindow();
	return;
}

function hideAllSliderBar(int idx)
{
	RHColorCtrl[idx].HideWindow();
	GSColorCtrl[idx].HideWindow();
	BVColorCtrl[idx].HideWindow();
	return;
}

function OnBtnCloseClick()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	switch(strID)
	{
		case "RColorCtrl":
		case "GColorCtrl":
		case "BColorCtrl":
		case "HColorCtrl":
		case "SColorCtrl":
		case "VColorCtrl":
			applyData();
			setRGBTextBox(nColorRH[colorspaceIndex], nColorGS[colorspaceIndex], nColorBV[colorspaceIndex]);
			break;
		default:
			break;
	}
	return;
}

function applyData()
{
	nColorRH[colorspaceIndex] = RHColorCtrl[colorspaceIndex].GetCurrentTick();
	nColorGS[colorspaceIndex] = GSColorCtrl[colorspaceIndex].GetCurrentTick();
	nColorBV[colorspaceIndex] = BVColorCtrl[colorspaceIndex].GetCurrentTick();
	if((colorspaceIndex == 0))
	{
		RGBtoHSV(nColorRH[0], nColorGS[0], nColorBV[0]);
	}
	else if((colorspaceIndex == 1))
	{
		HSVtoRGB(float(nColorRH[1]), float(nColorGS[1]), float(nColorBV[1]));
	}
	bUseNewHair = NewHairUseBox.IsChecked();
	bUseHairColor = HairColorUseBox.IsChecked();
	Class'NWindow.HairshopAPI'.static.ApplyCharHairInfo(bUseNewHair, savedHairtype, bUseHairColor, nColorRH[0], nColorGS[0], nColorBV[0]);
	return;
}

function updateHairColorData()
{
	Class'NWindow.HairshopAPI'.static.UpdateCharHairInfo();
	return;
}

function handleHairColorData(string param)
{
	local int i, tempUseHairCol;

	ParseInt(param, "bUseCustomHair", tempUseHairCol);
	ParseInt(param, "maxHairNum", gHairtype);
	ParseInt(param, "colorR", nColorRH[0]);
	ParseInt(param, "colorG", nColorGS[0]);
	ParseInt(param, "colorB", nColorBV[0]);
	bUseNewHair = bool(tempUseHairCol);
	RGBtoHSV(nColorRH[0], nColorGS[0], nColorBV[0]);
	i = 0;
	while((i < 2))
	{
		RHColorCtrl[i].SetCurrentTick(nColorRH[i]);
		GSColorCtrl[i].SetCurrentTick(nColorGS[i]);
		BVColorCtrl[i].SetCurrentTick(nColorBV[i]);
		i++;
	}
	setRGBTextBox(nColorRH[colorspaceIndex], nColorGS[colorspaceIndex], nColorBV[colorspaceIndex]);
	return;
}

function setRGBTextBox(int rh, int gs, int bv)
{
	RHColorBox.SetString(string(rh));
	GSColorBox.SetString(string(gs));
	BVColorBox.SetString(string(bv));
	return;
}

function float __min_channel(float R, float G, float B)
{
	local float t;

	if((R < G))
	{
		t = R;
	}
	else
	{
		t = G;
	}
	if((t > B))
	{
		t = B;
	}
	return t;
}

function float __max_channel(float R, float G, float B)
{
	local float t;

	if((R > G))
	{
		t = R;
	}
	else
	{
		t = G;
	}
	if((t < B))
	{
		t = B;
	}
	return t;
}

function RGBtoHSV(int inr, int ing, int inb)
{
	local float R, G, B, minVal, maxVal, deltaVal;

	R = (float(inr) / 255.0000000);
	G = (float(ing) / 255.0000000);
	B = (float(inb) / 255.0000000);
	minVal = __min_channel(R, G, B);
	maxVal = __max_channel(R, G, B);
	nColorBV[1] = int((maxVal * 100.0000000));
	deltaVal = (maxVal - minVal);
	if((maxVal != 0.0000000))
	{
		nColorGS[1] = int(((deltaVal / maxVal) * 100.0000000));
	}
	else
	{
		nColorGS[1] = -1;
		return;
	}
	if((R == maxVal))
	{
		nColorRH[1] = int(((G - B) / deltaVal));
	}
	else if((G == maxVal))
	{
		nColorRH[1] = int((2.0000000 + ((B - R) / deltaVal)));
	}
	else
	{
		nColorRH[1] = int((4.0000000 + ((R - G) / deltaVal)));
	}
	nColorRH[1] = 60;
	if((nColorRH[1] < 0))
	{
		nColorRH[1] = 360;
	}
	return;
}

function HSVtoRGB(float h, float S, float V)
{
	local int i;
	local float f, q, P, t, floatR, floatG, floatB;

	if((S == 0.0000000))
	{
		nColorRH[0] = int(((V / 100.0000000) * 255.0000000));
		nColorGS[0] = nColorRH[0];
		nColorBV[0] = nColorRH[0];
		return;
	}
	(h /= 60.0000000);
	i = int((h + 0.5000000));
	f = (h - float(i));
	P = ((V / 100.0000000) * (1.0000000 - (S / 100.0000000)));
	q = ((V / 100.0000000) * (1.0000000 - ((S / 100.0000000) * f)));
	t = ((V / 100.0000000) * (1.0000000 - ((S / 100.0000000) * (1.0000000 - f))));
	switch(i)
	{
		case 0:
			floatR = (V / 100.0000000);
			floatG = t;
			floatB = P;
			break;
		case 1:
			floatR = q;
			floatG = (V / 100.0000000);
			floatB = P;
			break;
		case 2:
			floatR = P;
			floatG = (V / 100.0000000);
			floatB = t;
			break;
		case 3:
			floatR = P;
			floatG = q;
			floatB = (V / 100.0000000);
			break;
		case 4:
			floatR = t;
			floatG = P;
			floatB = (V / 100.0000000);
			break;
		default:
			floatR = (V / 100.0000000);
			floatG = P;
			floatB = q;
			break;
	}
	nColorRH[0] = int((floatR * 255.0000000));
	nColorGS[0] = int((floatG * 255.0000000));
	nColorBV[0] = int((floatB * 255.0000000));
	return;
}
