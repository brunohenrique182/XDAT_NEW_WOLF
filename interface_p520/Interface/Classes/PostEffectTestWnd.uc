class PostEffectTestWnd extends UICommonAPI;

const YCbCr_BAR_LENGTH = 100000.0f;
const YCbCr_YCBCR_LENGTH = 20000.0f;

var WindowHandle Me;
var SliderCtrlHandle YCOR1Ctrl;
var SliderCtrlHandle CbCOR1Ctrl;
var SliderCtrlHandle CrCOR1Ctrl;
var SliderCtrlHandle YCOR2Ctrl;
var SliderCtrlHandle CbCOR2Ctrl;
var SliderCtrlHandle CrCOR2Ctrl;
var SliderCtrlHandle HCOR1Ctrl;
var SliderCtrlHandle SCOR1Ctrl;
var SliderCtrlHandle VCOR1Ctrl;
var SliderCtrlHandle HCOR2Ctrl;
var SliderCtrlHandle SCOR2Ctrl;
var SliderCtrlHandle VCOR2Ctrl;
var SliderCtrlHandle RCOR1Ctrl;
var SliderCtrlHandle GCOR1Ctrl;
var SliderCtrlHandle BCOR1Ctrl;
var SliderCtrlHandle RCOR2Ctrl;
var SliderCtrlHandle GCOR2Ctrl;
var SliderCtrlHandle BCOR2Ctrl;
var TextBoxHandle txtYCOR1;
var TextBoxHandle txtCbCOR1;
var TextBoxHandle txtCrCOR1;
var TextBoxHandle txtYCOR2;
var TextBoxHandle txtCbCOR2;
var TextBoxHandle txtCrCOR2;
var TextBoxHandle txtHCOR1;
var TextBoxHandle txtSCOR1;
var TextBoxHandle txtVCOR1;
var TextBoxHandle txtHCOR2;
var TextBoxHandle txtSCOR2;
var TextBoxHandle txtVCOR2;
var TextBoxHandle txtRCOR1;
var TextBoxHandle txtGCOR1;
var TextBoxHandle txtBCOR1;
var TextBoxHandle txtRCOR2;
var TextBoxHandle txtGCOR2;
var TextBoxHandle txtBCOR2;
var CheckBoxHandle btnOnlyYChange;
var CheckBoxHandle btnOnlySVChange;
var CheckBoxHandle btnYCbCrShow;
var CheckBoxHandle btnHSVShow;
var CheckBoxHandle btnRGBShow;
var CheckBoxHandle btnColorGradingShow;
var ButtonHandle btnYCbCrCOR1DefaultSet;
var ButtonHandle btnHSVCOR1DefaultSet;
var ButtonHandle btnRGBCOR1DefaultSet;
var ButtonHandle btnYCbCrCOR2DefaultSet;
var ButtonHandle btnHSVCOR2DefaultSet;
var ButtonHandle btnRGBCOR2DefaultSet;
var CheckBoxHandle btnYcbCrRealtime;
var ButtonHandle btnYCbCrAdjust;
var EditBoxHandle editYCbCrTime;
var CheckBoxHandle btnHSVRealtime;
var ButtonHandle btnHSVAdjust;
var EditBoxHandle editHSVTime;
var CheckBoxHandle btnRGBRealtime;
var ButtonHandle btnRGBAdjust;
var EditBoxHandle editRGBTime;
var ButtonHandle btnColorGradingAdjust;
var EditBoxHandle editColorGradingTime;
var EditBoxHandle editColorGradingColor1;
var EditBoxHandle editColorGradingColor2;
var EditBoxHandle editEffectID;
var ButtonHandle btnEffectPlay;
var ComboBoxHandle YCbCrColorOptionComboBox;
var ComboBoxHandle HSVColorOptionComboBox;
var ComboBoxHandle RGBColorOptionComboBox;
var ComboBoxHandle ColorGradingOptionComboBox;
var int yCOR1;
var int cbCOR1;
var int crCOR1;
var int hCOR1;
var int sCOR1;
var int vCOR1;
var int rCOR1;
var int gCOR1;
var int bCOR1;
var int yCOR2;
var int cbCOR2;
var int crCOR2;
var int hCOR2;
var int sCOR2;
var int vCOR2;
var int rCOR2;
var int gCOR2;
var int bCOR2;
var float fyCOR1;
var float fcbCOR1;
var float fcrCOR1;
var float fhCOR1;
var float fsCOR1;
var float fvCOR1;
var float frCOR1;
var float fgCOR1;
var float fbCOR1;
var float fyCOR2;
var float fcbCOR2;
var float fcrCOR2;
var float fhCOR2;
var float fsCOR2;
var float fvCOR2;
var float frCOR2;
var float fgCOR2;
var float fbCOR2;
var float YCbCrConsumingTime;
var float HSVConsumingTime;
var float RGBConsumingTime;
var float ColorGradingConsumingTime;
var float OnlyY;
var float OnlySV;

function OnRegisterEvent()
{
	RegisterEvent(4950);
	return;
}

function Initialize()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	Me = GetWindowHandle("PostEffectTestWnd");
	setWindowTitleByString("PostEffectTest");
	CrCOR1Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.CrCOR1SliderCtrl");
	YCOR1Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.YCOR1SliderCtrl");
	CbCOR1Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.CbCOR1SliderCtrl");
	HCOR1Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.HCOR1SliderCtrl");
	SCOR1Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.SCOR1SliderCtrl");
	VCOR1Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.VCOR1SliderCtrl");
	RCOR1Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.RCOR1SliderCtrl");
	GCOR1Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.GCOR1SliderCtrl");
	BCOR1Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.BCOR1SliderCtrl");
	CrCOR2Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.CrCOR2SliderCtrl");
	YCOR2Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.YCOR2SliderCtrl");
	CbCOR2Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.CbCOR2SliderCtrl");
	HCOR2Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.HCOR2SliderCtrl");
	SCOR2Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.SCOR2SliderCtrl");
	VCOR2Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.VCOR2SliderCtrl");
	RCOR2Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.RCOR2SliderCtrl");
	GCOR2Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.GCOR2SliderCtrl");
	BCOR2Ctrl = GetSliderCtrlHandle("PostEffectTestWnd.BCOR2SliderCtrl");
	txtYCOR1 = GetTextBoxHandle("PostEffectTestWnd.YCOR1TextBox");
	txtCbCOR1 = GetTextBoxHandle("PostEffectTestWnd.CbCOR1TextBox");
	txtCrCOR1 = GetTextBoxHandle("PostEffectTestWnd.CrCOR1TextBox");
	txtHCOR1 = GetTextBoxHandle("PostEffectTestWnd.HCOR1TextBox");
	txtSCOR1 = GetTextBoxHandle("PostEffectTestWnd.SCOR1TextBox");
	txtVCOR1 = GetTextBoxHandle("PostEffectTestWnd.VCOR1TextBox");
	txtRCOR1 = GetTextBoxHandle("PostEffectTestWnd.RCOR1TextBox");
	txtGCOR1 = GetTextBoxHandle("PostEffectTestWnd.GCOR1TextBox");
	txtBCOR1 = GetTextBoxHandle("PostEffectTestWnd.BCOR1TextBox");
	txtYCOR2 = GetTextBoxHandle("PostEffectTestWnd.YCOR2TextBox");
	txtCbCOR2 = GetTextBoxHandle("PostEffectTestWnd.CbCOR2TextBox");
	txtCrCOR2 = GetTextBoxHandle("PostEffectTestWnd.CrCOR2TextBox");
	txtHCOR2 = GetTextBoxHandle("PostEffectTestWnd.HCOR2TextBox");
	txtSCOR2 = GetTextBoxHandle("PostEffectTestWnd.SCOR2TextBox");
	txtVCOR2 = GetTextBoxHandle("PostEffectTestWnd.VCOR2TextBox");
	txtRCOR2 = GetTextBoxHandle("PostEffectTestWnd.RCOR2TextBox");
	txtGCOR2 = GetTextBoxHandle("PostEffectTestWnd.GCOR2TextBox");
	txtBCOR2 = GetTextBoxHandle("PostEffectTestWnd.BCOR2TextBox");
	btnOnlyYChange = GetCheckBoxHandle("PostEffectTestWnd.OnlyYChangeCheckBox");
	btnOnlySVChange = GetCheckBoxHandle("PostEffectTestWnd.OnlySVChangeCheckBox");
	btnYCbCrShow = GetCheckBoxHandle("PostEffectTestWnd.YCbCrShowCheckBox");
	btnHSVShow = GetCheckBoxHandle("PostEffectTestWnd.HSVShowCheckBox");
	btnRGBShow = GetCheckBoxHandle("PostEffectTestWnd.RGBShowCheckBox");
	btnColorGradingShow = GetCheckBoxHandle("PostEffectTestWnd.ColorGradingShowCheckBox");
	btnYCbCrCOR1DefaultSet = GetButtonHandle("PostEffectTestWnd.YCbCrCOR1DefaultSetButton");
	btnHSVCOR1DefaultSet = GetButtonHandle("PostEffectTestWnd.HSVCOR1DefaultSetButton");
	btnRGBCOR1DefaultSet = GetButtonHandle("PostEffectTestWnd.RGBCOR1DefaultSetButton");
	btnYcbCrRealtime = GetCheckBoxHandle("PostEffectTestWnd.YCbCrAdjustCheckBox");
	btnYCbCrAdjust = GetButtonHandle("PostEffectTestWnd.YCbCrAdjustButton");
	editYCbCrTime = GetEditBoxHandle("PostEffectTestWnd.YCbCrTimeEditBox");
	btnHSVRealtime = GetCheckBoxHandle("PostEffectTestWnd.HSVAdjustCheckBox");
	btnHSVAdjust = GetButtonHandle("PostEffectTestWnd.HSVAdjustButton");
	editHSVTime = GetEditBoxHandle("PostEffectTestWnd.HSVTimeEditBox");
	btnRGBRealtime = GetCheckBoxHandle("PostEffectTestWnd.RGBAdjustCheckBox");
	btnRGBAdjust = GetButtonHandle("PostEffectTestWnd.RGBAdjustButton");
	editRGBTime = GetEditBoxHandle("PostEffectTestWnd.RGBTimeEditBox");
	btnColorGradingAdjust = GetButtonHandle("PostEffectTestWnd.ColorGradingAdjustButton");
	editColorGradingTime = GetEditBoxHandle("PostEffectTestWnd.ColorGradingTimeEditBox");
	editColorGradingColor1 = GetEditBoxHandle("PostEffectTestWnd.ColorGrading1EditBox");
	editColorGradingColor2 = GetEditBoxHandle("PostEffectTestWnd.ColorGrading2EditBox");
	editEffectID = GetEditBoxHandle("PostEffectTestWnd.EffectIDEditBox");
	btnEffectPlay = GetButtonHandle("PostEffectTestWnd.PostEffectPlayButton");
	YCbCrColorOptionComboBox = GetComboBoxHandle("PostEffectTestWnd.YCbCrColorOptionComboBox");
	HSVColorOptionComboBox = GetComboBoxHandle("PostEffectTestWnd.HSVColorOptionComboBox");
	RGBColorOptionComboBox = GetComboBoxHandle("PostEffectTestWnd.RGBColorOptionComboBox");
	ColorGradingOptionComboBox = GetComboBoxHandle("PostEffectTestWnd.ColorGradingOptionComboBox");
	YCbCrColorOptionComboBox.AddString("0: Cor1_to_Cor2");
	YCbCrColorOptionComboBox.AddString("1: Org_to_Cor2");
	YCbCrColorOptionComboBox.AddString("2: Cor1_to_Org");
	HSVColorOptionComboBox.AddString("1: Org_to_Cor2");
	HSVColorOptionComboBox.AddString("2: Cor1_to_Org");
	RGBColorOptionComboBox.AddString("0: Cor1_to_Cor2");
	RGBColorOptionComboBox.AddString("1: Org_to_Cor2");
	RGBColorOptionComboBox.AddString("2: Cor1_to_Org");
	ColorGradingOptionComboBox.AddString("0: Cor1_to_Cor2");
	ColorGradingOptionComboBox.AddString("1: Org_to_Cor2");
	ColorGradingOptionComboBox.AddString("2: Cor1_to_Org");
	yCOR1 = int(20000.0000000);
	yCOR2 = int(20000.0000000);
	cbCOR1 = int(20000.0000000);
	cbCOR2 = int(20000.0000000);
	crCOR1 = int(20000.0000000);
	crCOR2 = int(20000.0000000);
	hCOR1 = int(((100000.0000000 + 20000.0000000) / 2.0000000));
	hCOR2 = int(((100000.0000000 + 20000.0000000) / 2.0000000));
	sCOR1 = int(20000.0000000);
	sCOR2 = int(20000.0000000);
	vCOR1 = int(20000.0000000);
	vCOR2 = int(20000.0000000);
	rCOR1 = int(20000.0000000);
	rCOR2 = int(20000.0000000);
	gCOR1 = int(20000.0000000);
	gCOR2 = int(20000.0000000);
	bCOR1 = int(20000.0000000);
	bCOR2 = int(20000.0000000);
	fyCOR1 = 1.0000000;
	fyCOR2 = 1.0000000;
	fcbCOR1 = 1.0000000;
	fcbCOR2 = 1.0000000;
	fcrCOR1 = 1.0000000;
	fcrCOR2 = 1.0000000;
	fhCOR1 = 1.0000000;
	fhCOR2 = 1.0000000;
	fsCOR1 = 1.0000000;
	fsCOR2 = 1.0000000;
	fvCOR1 = 1.0000000;
	fvCOR2 = 1.0000000;
	frCOR1 = 1.0000000;
	frCOR2 = 1.0000000;
	fgCOR1 = 1.0000000;
	fgCOR2 = 1.0000000;
	fbCOR1 = 1.0000000;
	fbCOR2 = 1.0000000;
	YCbCrConsumingTime = 0.0000000;
	HSVConsumingTime = 0.0000000;
	RGBConsumingTime = 0.0000000;
	ColorGradingConsumingTime = 0.0000000;
	OnlyY = 0.0000000;
	OnlySV = 0.0000000;
	YCbCrCOR1DefaultSet();
	HSVCOR1DefaultSet();
	RGBCOR1DefaultSet();
	YCbCrCOR2DefaultSet();
	HSVCOR2DefaultSet();
	RGBCOR2DefaultSet();
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	Initialize();
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "YCbCrCOR1DefaultSetButton":
			YCbCrCOR1DefaultSet();
			break;
		case "HSVCOR1DefaultSetButton":
			HSVCOR1DefaultSet();
			break;
		case "RGBCOR1DefaultSetButton":
			RGBCOR1DefaultSet();
			break;
		case "YCbCrCOR2DefaultSetButton":
			YCbCrCOR2DefaultSet();
			break;
		case "HSVCOR2DefaultSetButton":
			HSVCOR2DefaultSet();
			break;
		case "RGBCOR2DefaultSetButton":
			RGBCOR2DefaultSet();
			break;
		case "YCbCrAdjustButton":
			YCbCrAdjust();
			break;
		case "HSVAdjustButton":
			HSVAdjust();
			break;
		case "RGBAdjustButton":
			RGBAdjust();
			break;
		case "ColorGradingAdjustButton":
			ColorGradingAdjust();
			break;
		case "PostEffectPlayButton":
			EffectPlay();
			break;
		case "AllDeleteButton":
			DeleteAllEffect();
			break;
		default:
			break;
	}
	return;
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "OnlyYChangeCheckBox":
			AdjustOnlyY();
			break;
		case "OnlySVChangeCheckBox":
			AdjustOnlySV();
			break;
		case "YCbCrShowCheckBox":
			YCbCrShow();
			break;
		case "HSVShowCheckBox":
			HSVShow();
			break;
		case "RGBShowCheckBox":
			RGBShow();
			break;
		case "ColorGradingShowCheckBox":
			ColorGradingShow();
			break;
		default:
			break;
	}
	return;
}

function AdjustOnlyY()
{
	if(btnOnlyYChange.IsChecked())
	{
		OnlyY = 1.0000000;
	}
	else
	{
		OnlyY = 0.0000000;
	}
	return;
}

function AdjustOnlySV()
{
	if(btnOnlySVChange.IsChecked())
	{
		OnlySV = 1.0000000;
	}
	else
	{
		OnlySV = 0.0000000;
	}
	return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	Debug(strID);
	switch(strID)
	{
		case "YCOR1SliderCtrl":
			YCbCrYCOR1Set();
			break;
		case "CbCOR1SliderCtrl":
			YCbCrCBCOR1Set();
			break;
		case "CrCOR1SliderCtrl":
			YCbCrCRCOR1Set();
			break;
		case "YCOR2SliderCtrl":
			YCbCrYCOR2Set();
			break;
		case "CbCOR2SliderCtrl":
			YCbCrCBCOR2Set();
			break;
		case "CrCOR2SliderCtrl":
			YCbCrCRCOR2Set();
			break;
		case "HCOR1SliderCtrl":
			HSVHCOR1Set();
			break;
		case "SCOR1SliderCtrl":
			HSVSCOR1Set();
			break;
		case "VCOR1SliderCtrl":
			HSVVCOR1Set();
			break;
		case "HCOR2SliderCtrl":
			HSVHCOR2Set();
			break;
		case "SCOR2SliderCtrl":
			HSVSCOR2Set();
			break;
		case "VCOR2SliderCtrl":
			HSVVCOR2Set();
			break;
		case "RCOR1SliderCtrl":
			RGBRCOR1Set();
			break;
		case "GCOR1SliderCtrl":
			RGBGCOR1Set();
			break;
		case "BCOR1SliderCtrl":
			RGBBCOR1Set();
			break;
		case "RCOR2SliderCtrl":
			RGBRCOR2Set();
			break;
		case "GCOR2SliderCtrl":
			RGBGCOR2Set();
			break;
		case "BCOR2SliderCtrl":
			RGBBCOR2Set();
			break;
		default:
			break;
	}
	return;
}

function YCbCrShow()
{
	RequestSetYCbCrConversionEffect(btnYCbCrShow.IsChecked());
	return;
}

function HSVShow()
{
	RequestSetHSVConversionEffect(btnHSVShow.IsChecked());
	return;
}

function RGBShow()
{
	RequestSetRGBConversionEffect(btnRGBShow.IsChecked());
	return;
}

function ColorGradingShow()
{
	RequestSetColorGradingEffect(btnColorGradingShow.IsChecked());
	return;
}

function YCbCrYCOR1Set()
{
	yCOR1 = YCOR1Ctrl.GetCurrentTick();
	fyCOR1 = (float(yCOR1) / 20000.0000000);
	txtYCOR1.SetText(string(fyCOR1));
	if(btnYcbCrRealtime.IsChecked())
	{
		RequestSetYCbCrVal(OnlyY, YCbCrColorOptionComboBox.GetSelectedNum(), fyCOR1, fcbCOR1, fcrCOR1, fyCOR2, fcbCOR2, fcrCOR2, 0.0000000);
	}
	return;
}

function YCbCrYCOR2Set()
{
	yCOR2 = YCOR2Ctrl.GetCurrentTick();
	fyCOR2 = (float(yCOR2) / 20000.0000000);
	txtYCOR2.SetText(string(fyCOR2));
	if(btnYcbCrRealtime.IsChecked())
	{
		RequestSetYCbCrVal(OnlyY, YCbCrColorOptionComboBox.GetSelectedNum(), fyCOR1, fcbCOR1, fcrCOR1, fyCOR2, fcbCOR2, fcrCOR2, 0.0000000);
	}
	return;
}

function HSVHCOR1Set()
{
	hCOR1 = HCOR1Ctrl.GetCurrentTick();
	fhCOR1 = (float(hCOR1) / 100000.0000000);
	txtHCOR1.SetText(string(fhCOR1));
	if(btnHSVRealtime.IsChecked())
	{
		RequestSetHSVVal(OnlySV, (HSVColorOptionComboBox.GetSelectedNum() + 1), fhCOR1, fsCOR1, fvCOR1, fhCOR2, fsCOR2, fvCOR2, 0.0000000);
	}
	return;
}

function HSVHCOR2Set()
{
	hCOR2 = HCOR2Ctrl.GetCurrentTick();
	fhCOR2 = (float(hCOR2) / 100000.0000000);
	txtHCOR2.SetText(string(fhCOR2));
	if(btnHSVRealtime.IsChecked())
	{
		RequestSetHSVVal(OnlySV, (HSVColorOptionComboBox.GetSelectedNum() + 1), fhCOR1, fsCOR1, fvCOR1, fhCOR2, fsCOR2, fvCOR2, 0.0000000);
	}
	return;
}

function RGBRCOR1Set()
{
	rCOR1 = RCOR1Ctrl.GetCurrentTick();
	frCOR1 = (float(rCOR1) / 20000.0000000);
	txtRCOR1.SetText(string(frCOR1));
	if(btnRGBRealtime.IsChecked())
	{
		RequestSetRGBVal(RGBColorOptionComboBox.GetSelectedNum(), frCOR1, fgCOR1, fbCOR1, frCOR2, fgCOR2, fbCOR2, 0.0000000);
	}
	return;
}

function RGBRCOR2Set()
{
	rCOR2 = RCOR2Ctrl.GetCurrentTick();
	frCOR2 = (float(rCOR2) / 20000.0000000);
	txtRCOR2.SetText(string(frCOR2));
	if(btnRGBRealtime.IsChecked())
	{
		RequestSetRGBVal(RGBColorOptionComboBox.GetSelectedNum(), frCOR1, fgCOR1, fbCOR1, frCOR2, fgCOR2, fbCOR2, 0.0000000);
	}
	return;
}

function YCbCrCBCOR1Set()
{
	cbCOR1 = CbCOR1Ctrl.GetCurrentTick();
	fcbCOR1 = ((float(cbCOR1) / 100000.0000000) - 0.5000000);
	txtCbCOR1.SetText(string(fcbCOR1));
	if(btnYcbCrRealtime.IsChecked())
	{
		RequestSetYCbCrVal(OnlyY, YCbCrColorOptionComboBox.GetSelectedNum(), fyCOR1, fcbCOR1, fcrCOR1, fyCOR2, fcbCOR2, fcrCOR2, 0.0000000);
	}
	return;
}

function YCbCrCBCOR2Set()
{
	cbCOR2 = CbCOR2Ctrl.GetCurrentTick();
	fcbCOR2 = ((float(cbCOR2) / 100000.0000000) - 0.5000000);
	txtCbCOR2.SetText(string(fcbCOR2));
	if(btnYcbCrRealtime.IsChecked())
	{
		RequestSetYCbCrVal(OnlyY, YCbCrColorOptionComboBox.GetSelectedNum(), fyCOR1, fcbCOR1, fcrCOR1, fyCOR2, fcbCOR2, fcrCOR2, 0.0000000);
	}
	return;
}

function HSVSCOR1Set()
{
	sCOR1 = SCOR1Ctrl.GetCurrentTick();
	fsCOR1 = (float(sCOR1) / 20000.0000000);
	txtSCOR1.SetText(string(fsCOR1));
	if(btnHSVRealtime.IsChecked())
	{
		RequestSetHSVVal(OnlySV, (HSVColorOptionComboBox.GetSelectedNum() + 1), fhCOR1, fsCOR1, fvCOR1, fhCOR2, fsCOR2, fvCOR2, 0.0000000);
	}
	return;
}

function HSVSCOR2Set()
{
	sCOR2 = SCOR2Ctrl.GetCurrentTick();
	fsCOR2 = (float(sCOR2) / 20000.0000000);
	txtSCOR2.SetText(string(fsCOR2));
	if(btnHSVRealtime.IsChecked())
	{
		RequestSetHSVVal(OnlySV, (HSVColorOptionComboBox.GetSelectedNum() + 1), fhCOR1, fsCOR1, fvCOR1, fhCOR2, fsCOR2, fvCOR2, 0.0000000);
	}
	return;
}

function RGBGCOR1Set()
{
	gCOR1 = GCOR1Ctrl.GetCurrentTick();
	fgCOR1 = (float(gCOR1) / 20000.0000000);
	txtGCOR1.SetText(string(fgCOR1));
	if(btnRGBRealtime.IsChecked())
	{
		RequestSetRGBVal(RGBColorOptionComboBox.GetSelectedNum(), frCOR1, fgCOR1, fbCOR1, frCOR2, fgCOR2, fbCOR2, 0.0000000);
	}
	return;
}

function RGBGCOR2Set()
{
	gCOR2 = GCOR2Ctrl.GetCurrentTick();
	fgCOR2 = (float(gCOR2) / 20000.0000000);
	txtGCOR2.SetText(string(fgCOR2));
	if(btnRGBRealtime.IsChecked())
	{
		RequestSetRGBVal(RGBColorOptionComboBox.GetSelectedNum(), frCOR1, fgCOR1, fbCOR1, frCOR2, fgCOR2, fbCOR2, 0.0000000);
	}
	return;
}

function YCbCrCRCOR1Set()
{
	crCOR1 = CrCOR1Ctrl.GetCurrentTick();
	fcrCOR1 = ((float(crCOR1) / 100000.0000000) - 0.5000000);
	txtCrCOR1.SetText(string(fcrCOR1));
	if(btnYcbCrRealtime.IsChecked())
	{
		RequestSetYCbCrVal(OnlyY, YCbCrColorOptionComboBox.GetSelectedNum(), fyCOR1, fcbCOR1, fcrCOR1, fyCOR2, fcbCOR2, fcrCOR2, 0.0000000);
	}
	return;
}

function YCbCrCRCOR2Set()
{
	crCOR2 = CrCOR2Ctrl.GetCurrentTick();
	fcrCOR2 = ((float(crCOR2) / 100000.0000000) - 0.5000000);
	txtCrCOR2.SetText(string(fcrCOR2));
	if(btnYcbCrRealtime.IsChecked())
	{
		RequestSetYCbCrVal(OnlyY, YCbCrColorOptionComboBox.GetSelectedNum(), fyCOR1, fcbCOR1, fcrCOR1, fyCOR2, fcbCOR2, fcrCOR2, 0.0000000);
	}
	return;
}

function HSVVCOR1Set()
{
	vCOR1 = VCOR1Ctrl.GetCurrentTick();
	fvCOR1 = (float(vCOR1) / 20000.0000000);
	txtVCOR1.SetText(string(fvCOR1));
	if(btnHSVRealtime.IsChecked())
	{
		RequestSetHSVVal(OnlySV, (HSVColorOptionComboBox.GetSelectedNum() + 1), fhCOR1, fsCOR1, fvCOR1, fhCOR2, fsCOR2, fvCOR2, 0.0000000);
	}
	return;
}

function HSVVCOR2Set()
{
	vCOR2 = VCOR2Ctrl.GetCurrentTick();
	fvCOR2 = (float(vCOR2) / 20000.0000000);
	txtVCOR2.SetText(string(fvCOR2));
	if(btnHSVRealtime.IsChecked())
	{
		RequestSetHSVVal(OnlySV, (HSVColorOptionComboBox.GetSelectedNum() + 1), fhCOR1, fsCOR1, fvCOR1, fhCOR2, fsCOR2, fvCOR2, 0.0000000);
	}
	return;
}

function RGBBCOR1Set()
{
	bCOR1 = BCOR1Ctrl.GetCurrentTick();
	fbCOR1 = (float(bCOR1) / 20000.0000000);
	txtBCOR1.SetText(string(fbCOR1));
	if(btnRGBRealtime.IsChecked())
	{
		RequestSetRGBVal(RGBColorOptionComboBox.GetSelectedNum(), frCOR1, fgCOR1, fbCOR1, frCOR2, fgCOR2, fbCOR2, 0.0000000);
	}
	return;
}

function RGBBCOR2Set()
{
	bCOR2 = BCOR2Ctrl.GetCurrentTick();
	fbCOR2 = (float(bCOR2) / 20000.0000000);
	txtBCOR2.SetText(string(fbCOR2));
	if(btnRGBRealtime.IsChecked())
	{
		RequestSetRGBVal(RGBColorOptionComboBox.GetSelectedNum(), frCOR1, fgCOR1, fbCOR1, frCOR2, fgCOR2, fbCOR2, 0.0000000);
	}
	return;
}

function YCbCrCOR1DefaultSet()
{
	fyCOR1 = 1.0000000;
	fcbCOR1 = 0.0000000;
	fcrCOR1 = 0.0000000;
	YCOR1Ctrl.SetCurrentTick(int(20000.0000000));
	CbCOR1Ctrl.SetCurrentTick(int((100000.0000000 / 2.0000000)));
	CrCOR1Ctrl.SetCurrentTick(int((100000.0000000 / 2.0000000)));
	YCbCrYCOR1Set();
	YCbCrCBCOR1Set();
	YCbCrCRCOR1Set();
	return;
}

function YCbCrCOR2DefaultSet()
{
	fyCOR2 = 1.0000000;
	fcbCOR2 = 0.0000000;
	fcrCOR2 = 0.0000000;
	YCOR2Ctrl.SetCurrentTick(int(20000.0000000));
	CbCOR2Ctrl.SetCurrentTick(int((100000.0000000 / 2.0000000)));
	CrCOR2Ctrl.SetCurrentTick(int((100000.0000000 / 2.0000000)));
	YCbCrYCOR2Set();
	YCbCrCBCOR2Set();
	YCbCrCRCOR2Set();
	return;
}

function HSVCOR1DefaultSet()
{
	fhCOR1 = 0.0000000;
	fsCOR1 = 1.0000000;
	fvCOR1 = 1.0000000;
	HCOR1Ctrl.SetCurrentTick(int(((100000.0000000 + 20000.0000000) / 2.0000000)));
	SCOR1Ctrl.SetCurrentTick(int(20000.0000000));
	VCOR1Ctrl.SetCurrentTick(int(20000.0000000));
	HSVHCOR1Set();
	HSVSCOR1Set();
	HSVVCOR1Set();
	return;
}

function HSVCOR2DefaultSet()
{
	fhCOR2 = 0.0000000;
	fsCOR2 = 1.0000000;
	fvCOR2 = 1.0000000;
	HCOR2Ctrl.SetCurrentTick(int(((100000.0000000 + 20000.0000000) / 2.0000000)));
	SCOR2Ctrl.SetCurrentTick(int(20000.0000000));
	VCOR2Ctrl.SetCurrentTick(int(20000.0000000));
	HSVHCOR2Set();
	HSVSCOR2Set();
	HSVVCOR2Set();
	return;
}

function RGBCOR1DefaultSet()
{
	frCOR1 = 1.0000000;
	fgCOR1 = 1.0000000;
	fbCOR1 = 1.0000000;
	RCOR1Ctrl.SetCurrentTick(int(20000.0000000));
	GCOR1Ctrl.SetCurrentTick(int(20000.0000000));
	BCOR1Ctrl.SetCurrentTick(int(20000.0000000));
	RGBRCOR1Set();
	RGBGCOR1Set();
	RGBBCOR1Set();
	return;
}

function RGBCOR2DefaultSet()
{
	frCOR2 = 1.0000000;
	fgCOR2 = 1.0000000;
	fbCOR2 = 1.0000000;
	RCOR2Ctrl.SetCurrentTick(int(20000.0000000));
	GCOR2Ctrl.SetCurrentTick(int(20000.0000000));
	BCOR2Ctrl.SetCurrentTick(int(20000.0000000));
	RGBRCOR2Set();
	RGBGCOR2Set();
	RGBBCOR2Set();
	return;
}

function YCbCrAdjust()
{
	YCbCrConsumingTime = float(editYCbCrTime.GetString());
	if(!btnYcbCrRealtime.IsChecked())
	{
		RequestSetYCbCrVal(OnlyY, YCbCrColorOptionComboBox.GetSelectedNum(), fyCOR1, fcbCOR1, fcrCOR1, fyCOR2, fcbCOR2, fcrCOR2, YCbCrConsumingTime);
		if(((YCbCrConsumingTime != 0.0000000) && (YCbCrColorOptionComboBox.GetSelectedNum() == 2)))
		{
			btnYCbCrShow.SetCheck(false);
		}
	}
	return;
}

function HSVAdjust()
{
	HSVConsumingTime = float(editHSVTime.GetString());
	if(!btnHSVRealtime.IsChecked())
	{
		RequestSetHSVVal(OnlySV, (HSVColorOptionComboBox.GetSelectedNum() + 1), fhCOR1, fsCOR1, fvCOR1, fhCOR2, fsCOR2, fvCOR2, HSVConsumingTime);
		if(((HSVConsumingTime != 0.0000000) && ((HSVColorOptionComboBox.GetSelectedNum() + 1) == 2)))
		{
			btnHSVShow.SetCheck(false);
		}
	}
	return;
}

function RGBAdjust()
{
	RGBConsumingTime = float(editRGBTime.GetString());
	if(!btnRGBRealtime.IsChecked())
	{
		RequestSetRGBVal(RGBColorOptionComboBox.GetSelectedNum(), frCOR1, fgCOR1, fbCOR1, frCOR2, fgCOR2, fbCOR2, RGBConsumingTime);
		if(((RGBConsumingTime != 0.0000000) && (RGBColorOptionComboBox.GetSelectedNum() == 2)))
		{
			btnRGBShow.SetCheck(false);
		}
	}
	return;
}

function ColorGradingAdjust()
{
	ColorGradingConsumingTime = float(editColorGradingTime.GetString());
	RequestSetColorGradingVal(ColorGradingOptionComboBox.GetSelectedNum(), editColorGradingColor1.GetString(), editColorGradingColor2.GetString(), ColorGradingConsumingTime);
	if(((ColorGradingConsumingTime != 0.0000000) && (ColorGradingOptionComboBox.GetSelectedNum() == 2)))
	{
		btnColorGradingShow.SetCheck(false);
	}
	return;
}

function EffectPlay()
{
	local int EffectID;

	EffectID = int(editEffectID.GetString());
	if((EffectID >= 0))
	{
		RequestSetPostEffect(true, EffectID);
	}
	return;
}

function DeleteAllEffect()
{
	btnYCbCrShow.SetCheck(false);
	btnHSVShow.SetCheck(false);
	btnRGBShow.SetCheck(false);
	btnColorGradingShow.SetCheck(false);
	RequestSetYCbCrConversionEffect(btnYCbCrShow.IsChecked());
	RequestSetHSVConversionEffect(btnHSVShow.IsChecked());
	RequestSetRGBConversionEffect(btnRGBShow.IsChecked());
	RequestSetColorGradingEffect(btnColorGradingShow.IsChecked());
	SetMotionBlurAlpha(byte(255.0000000));
	return;
}

function OnShow()
{
	return;
}

function OnHide()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 4950))
	{
		if(Me.IsShowWindow())
		{
			Me.HideWindow();
		}
		else
		{
			Me.ShowWindow();
		}
	}
	return;
}
