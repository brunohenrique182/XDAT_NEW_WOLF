class YebisCmdWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var ComboBoxHandle hdrComboBox;
var ComboBoxHandle shaComboBox;
var SliderCtrlHandle mgSliderCtrl;
var SliderCtrlHandle adtSliderCtrl;
var SliderCtrlHandle coef1SliderCtrl;
var SliderCtrlHandle coef2SliderCtrl;
var SliderCtrlHandle expSliderCtrl;
var SliderCtrlHandle mFactorSliderCtrl;
var SliderCtrlHandle lumSliderCtrl;
var SliderCtrlHandle thrSliderCtrl;
var SliderCtrlHandle quaSliderCtrl;
var SliderCtrlHandle bluSliderCtrl;
var SliderCtrlHandle remSliderCtrl;
var SliderCtrlHandle hueSliderCtrl;
var SliderCtrlHandle satSliderCtrl;
var SliderCtrlHandle conSliderCtrl;
var SliderCtrlHandle briSliderCtrl;
var SliderCtrlHandle temSliderCtrl;
var SliderCtrlHandle whiSliderCtrl;
var SliderCtrlHandle sepSliderCtrl;
var SliderCtrlHandle gamSliderCtrl;
var SliderCtrlHandle apeSliderCtrl;
var SliderCtrlHandle dofqSliderCtrl;
var SliderCtrlHandle focSliderCtrl;
var SliderCtrlHandle shSliderCtrl;
var SliderCtrlHandle smpSliderCtrl;
var SliderCtrlHandle rdsSliderCtrl;
var SliderCtrlHandle sclSliderCtrl;
var TextBoxHandle mFactorValueBox;
var TextBoxHandle mgValueBox;
var TextBoxHandle adtValueBox;
var TextBoxHandle coef1ValueBox;
var TextBoxHandle coef2ValueBox;
var TextBoxHandle expValueBox;
var TextBoxHandle lumValueBox;
var TextBoxHandle thrValueBox;
var TextBoxHandle quaValueBox;
var TextBoxHandle bluValueBox;
var TextBoxHandle remValueBox;
var TextBoxHandle hueValueBox;
var TextBoxHandle satValueBox;
var TextBoxHandle conValueBox;
var TextBoxHandle briValueBox;
var TextBoxHandle temValueBox;
var TextBoxHandle whiValueBox;
var TextBoxHandle sepValueBox;
var TextBoxHandle gamValueBox;
var TextBoxHandle apeValueBox;
var TextBoxHandle dofqValueBox;
var TextBoxHandle focValueBox;
var TextBoxHandle shValueBox;
var TextBoxHandle smpValueBox;
var TextBoxHandle rdsValueBox;
var TextBoxHandle sclValueBox;
var CheckBoxHandle yebisCheckBox;
var CheckBoxHandle tonemapCheckBox;
var CheckBoxHandle dofCheckBox;
var CheckBoxHandle showRangeCheckBox;
var CheckBoxHandle anaCheckBox;
var CheckBoxHandle aaCheckBox;
var CheckBoxHandle aoCheckBox;
var EditBoxHandle dofWidthEditBox;
var EditBoxHandle dofLvlEditBox;
var EditBoxHandle dofEdgeEditBox;
var EditBoxHandle dofShapeEditBox;
var EditBoxHandle lvCombiEditBox;
var EditBoxHandle blurWidthEditBox;
var EditBoxHandle blurScaleEditBox;
var EditBoxHandle bladesEditBox;
var EditBoxHandle apeCircularEditBox;

event OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("YebisCmdWnd");
	Me.SetWindowTitle("Yebis Parameters");
	yebisCheckBox = GetCheckBoxHandle((m_Windowname $ ".yebisCheckBox"));
	tonemapCheckBox = GetCheckBoxHandle((m_Windowname $ ".tonemapCheckBox"));
	dofCheckBox = GetCheckBoxHandle((m_Windowname $ ".dofCheckBox"));
	showRangeCheckBox = GetCheckBoxHandle((m_Windowname $ ".showRangeCheckBox"));
	anaCheckBox = GetCheckBoxHandle((m_Windowname $ ".anaCheckBox"));
	aaCheckBox = GetCheckBoxHandle((m_Windowname $ ".aaCheckBox"));
	aoCheckBox = GetCheckBoxHandle((m_Windowname $ ".aoCheckBox"));
	hdrComboBox = GetComboBoxHandle((m_Windowname $ ".hdrComboBox"));
	hdrComboBox.AddString("Disable");
	hdrComboBox.AddString("True HDR");
	hdrComboBox.AddString("Sim HDR");
	hdrComboBox.AddString("Sim HDR Glare");
	hdrComboBox.AddString("Quasi HDR");
	hdrComboBox.AddString("Quasi HDR Glare");
	hdrComboBox.SetSelectedNum(3);
	shaComboBox = GetComboBoxHandle((m_Windowname $ ".shaComboBox"));
	shaComboBox.AddString("Disable");
	shaComboBox.AddString("Bloom");
	shaComboBox.AddString("Lensflare");
	shaComboBox.AddString("Standard");
	shaComboBox.AddString("Cheap Lens");
	shaComboBox.AddString("After Image");
	shaComboBox.AddString("Cross Screen");
	shaComboBox.AddString("Cross Screen 2");
	shaComboBox.AddString("Snow Cross");
	shaComboBox.AddString("Snow Cross 2");
	shaComboBox.AddString("Sunny Cross");
	shaComboBox.AddString("Sunny Cross 2");
	shaComboBox.AddString("Horizontal Streak");
	shaComboBox.AddString("Vertical Streak");
	shaComboBox.SetSelectedNum(8);
	mFactorSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".mFactorSliderCtrl"));
	mFactorValueBox = GetTextBoxHandle((m_Windowname $ ".mFactorValueBox"));
	mgSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".mgSliderCtrl"));
	mgValueBox = GetTextBoxHandle((m_Windowname $ ".mgValueBox"));
	adtSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".adtSliderCtrl"));
	adtValueBox = GetTextBoxHandle((m_Windowname $ ".adtValueBox"));
	coef1SliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".coef1SliderCtrl"));
	coef1ValueBox = GetTextBoxHandle((m_Windowname $ ".coef1ValueBox"));
	coef2SliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".coef2SliderCtrl"));
	coef2ValueBox = GetTextBoxHandle((m_Windowname $ ".coef2ValueBox"));
	expSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".expSliderCtrl"));
	expValueBox = GetTextBoxHandle((m_Windowname $ ".expValueBox"));
	lumSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".lumSliderCtrl"));
	lumValueBox = GetTextBoxHandle((m_Windowname $ ".lumValueBox"));
	thrSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".thrSliderCtrl"));
	thrValueBox = GetTextBoxHandle((m_Windowname $ ".thrValueBox"));
	quaSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".quaSliderCtrl"));
	quaValueBox = GetTextBoxHandle((m_Windowname $ ".quaValueBox"));
	bluSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".bluSliderCtrl"));
	bluValueBox = GetTextBoxHandle((m_Windowname $ ".bluValueBox"));
	remSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".remSliderCtrl"));
	remValueBox = GetTextBoxHandle((m_Windowname $ ".remValueBox"));
	apeSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".apeSliderCtrl"));
	apeValueBox = GetTextBoxHandle((m_Windowname $ ".apeValueBox"));
	dofqSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".dofqSliderCtrl"));
	dofqValueBox = GetTextBoxHandle((m_Windowname $ ".dofqValueBox"));
	focSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".focSliderCtrl"));
	focValueBox = GetTextBoxHandle((m_Windowname $ ".focValueBox"));
	shSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".shSliderCtrl"));
	shValueBox = GetTextBoxHandle((m_Windowname $ ".shValueBox"));
	hueSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".hueSliderCtrl"));
	hueValueBox = GetTextBoxHandle((m_Windowname $ ".hueValueBox"));
	satSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".satSliderCtrl"));
	satValueBox = GetTextBoxHandle((m_Windowname $ ".satValueBox"));
	briSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".briSliderCtrl"));
	briValueBox = GetTextBoxHandle((m_Windowname $ ".briValueBox"));
	conSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".conSliderCtrl"));
	conValueBox = GetTextBoxHandle((m_Windowname $ ".conValueBox"));
	gamSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".gamSliderCtrl"));
	gamValueBox = GetTextBoxHandle((m_Windowname $ ".gamValueBox"));
	temSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".temSliderCtrl"));
	temValueBox = GetTextBoxHandle((m_Windowname $ ".temValueBox"));
	whiSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".whiSliderCtrl"));
	whiValueBox = GetTextBoxHandle((m_Windowname $ ".whiValueBox"));
	sepSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".sepSliderCtrl"));
	sepValueBox = GetTextBoxHandle((m_Windowname $ ".sepValueBox"));
	smpSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".smpSliderCtrl"));
	smpValueBox = GetTextBoxHandle((m_Windowname $ ".smpValueBox"));
	rdsSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".rdsSliderCtrl"));
	rdsValueBox = GetTextBoxHandle((m_Windowname $ ".rdsValueBox"));
	sclSliderCtrl = GetSliderCtrlHandle((m_Windowname $ ".sclSliderCtrl"));
	sclValueBox = GetTextBoxHandle((m_Windowname $ ".sclValueBox"));
	dofWidthEditBox = GetEditBoxHandle((m_Windowname $ ".dofWidthEditBox"));
	dofLvlEditBox = GetEditBoxHandle((m_Windowname $ ".dofLvlEditBox"));
	dofEdgeEditBox = GetEditBoxHandle((m_Windowname $ ".dofEdgeEditBox"));
	dofShapeEditBox = GetEditBoxHandle((m_Windowname $ ".dofShapeEditBox"));
	lvCombiEditBox = GetEditBoxHandle((m_Windowname $ ".lvCombiEditBox"));
	blurWidthEditBox = GetEditBoxHandle((m_Windowname $ ".blurWidthEditBox"));
	blurScaleEditBox = GetEditBoxHandle((m_Windowname $ ".blurScaleEditBox"));
	bladesEditBox = GetEditBoxHandle((m_Windowname $ ".bladesEditBox"));
	apeCircularEditBox = GetEditBoxHandle((m_Windowname $ ".apeCircularEditBox"));
	return;
}

event OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local float fvalue;
	local int ivalue;

	switch(strID)
	{
		case "mFactorSliderCtrl":
			fvalue = (float(mFactorSliderCtrl.GetCurrentTick()) + 1.0000000);
			ExecuteCommand(("///yebis fMappingFactor=" $ string((fvalue - 1.0000000))));
			mFactorValueBox.SetText(string((fvalue - 1.0000000)));
			break;
		case "mgSliderCtrl":
			fvalue = (float(mgSliderCtrl.GetCurrentTick()) / 100.0000000);
			ExecuteCommand(("///yebis fMiddleGray=" $ string(fvalue)));
			mgValueBox.SetText(string(fvalue));
			break;
		case "adtSliderCtrl":
			fvalue = (float(adtSliderCtrl.GetCurrentTick()) / 100.0000000);
			ExecuteCommand(("///yebis fAdaptationSensitivity=" $ string(fvalue)));
			adtValueBox.SetText(string(fvalue));
			break;
		case "coef1SliderCtrl":
			fvalue = (float(coef1SliderCtrl.GetCurrentTick()) / 100.0000000);
			ExecuteCommand(("///yebis bToneCoef1=" $ string(fvalue)));
			coef1ValueBox.SetText(string(fvalue));
			break;
		case "coef2SliderCtrl":
			fvalue = ((float(coef2SliderCtrl.GetCurrentTick()) / 100.0000000) - 0.5000000);
			ExecuteCommand(("///yebis bToneCoef2=" $ string(fvalue)));
			coef2ValueBox.SetText(string(fvalue));
			break;
		case "expSliderCtrl":
			fvalue = (float(expSliderCtrl.GetCurrentTick()) / 100.0000000);
			ExecuteCommand(("///yebis exp=" $ string(fvalue)));
			if((fvalue == 0.0000000))
			{
				expValueBox.SetText("Auto");
			}
			else
			{
				expValueBox.SetText(string(fvalue));
			}
			break;
		case "lumSliderCtrl":
			fvalue = (float(lumSliderCtrl.GetCurrentTick()) / 10.0000000);
			ExecuteCommand(("///yebis lum=" $ string(fvalue)));
			lumValueBox.SetText(string(fvalue));
			break;
		case "thrSliderCtrl":
			fvalue = (float(thrSliderCtrl.GetCurrentTick()) / 100.0000000);
			ExecuteCommand(("///yebis thr=" $ string(fvalue)));
			thrValueBox.SetText(string(fvalue));
			break;
		case "quaSliderCtrl":
			ivalue = int(float(quaSliderCtrl.GetCurrentTick()));
			ExecuteCommand(("///yebis qua=" $ string(ivalue)));
			quaValueBox.SetText(string(ivalue));
			break;
		case "bluSliderCtrl":
			fvalue = (float(bluSliderCtrl.GetCurrentTick()) / 10.0000000);
			ExecuteCommand(("///yebis blu=" $ string(fvalue)));
			bluValueBox.SetText(string(fvalue));
			break;
		case "remSliderCtrl":
			fvalue = float(remSliderCtrl.GetCurrentTick());
			ExecuteCommand(("///yebis rem=" $ string(fvalue)));
			remValueBox.SetText(string(int(fvalue)));
			break;
		case "apeSliderCtrl":
			fvalue = (float(apeSliderCtrl.GetCurrentTick()) / 10.0000000);
			ExecuteCommand(("///yebis fApertureFnumber=" $ string(fvalue)));
			apeValueBox.SetText(string(fvalue));
			break;
		case "dofqSliderCtrl":
			ivalue = dofqSliderCtrl.GetCurrentTick();
			ExecuteCommand(("///yebis nDepthOfFieldQuality=" $ string(ivalue)));
			dofqValueBox.SetText(string(ivalue));
			break;
		case "focSliderCtrl":
			fvalue = float(focSliderCtrl.GetCurrentTick());
			ExecuteCommand(("///yebis foc=" $ string(fvalue)));
			if((fvalue == 0.0000000))
			{
				focValueBox.SetText("Auto");
			}
			else
			{
				focValueBox.SetText(string(int(fvalue)));
			}
			break;
		case "shSliderCtrl":
			fvalue = (float(shSliderCtrl.GetCurrentTick()) / 10.0000000);
			ExecuteCommand(("///yebis fImageSensorHeight=" $ string(fvalue)));
			shValueBox.SetText(string(fvalue));
			break;
		case "hueSliderCtrl":
			fvalue = (float(hueSliderCtrl.GetCurrentTick()) - 179.0000000);
			ExecuteCommand(("///yebis hue=" $ string(fvalue)));
			hueValueBox.SetText(string(int(fvalue)));
			break;
		case "satSliderCtrl":
			fvalue = (float(satSliderCtrl.GetCurrentTick()) / 100.0000000);
			ExecuteCommand(("///yebis sat=" $ string(fvalue)));
			satValueBox.SetText(string(fvalue));
			break;
		case "briSliderCtrl":
			fvalue = (float(briSliderCtrl.GetCurrentTick()) / 100.0000000);
			ExecuteCommand(("///yebis bri=" $ string(fvalue)));
			briValueBox.SetText(string(fvalue));
			break;
		case "conSliderCtrl":
			fvalue = (float(conSliderCtrl.GetCurrentTick()) / 100.0000000);
			ExecuteCommand(("///yebis con=" $ string(fvalue)));
			conValueBox.SetText(string(fvalue));
			break;
		case "gamSliderCtrl":
			fvalue = (float(gamSliderCtrl.GetCurrentTick()) / 100.0000000);
			ExecuteCommand(("///yebis gam=" $ string(fvalue)));
			gamValueBox.SetText(string(fvalue));
			break;
		case "temSliderCtrl":
			fvalue = (float(temSliderCtrl.GetCurrentTick()) * 10.0000000);
			ExecuteCommand(("///yebis tem=" $ string(fvalue)));
			temValueBox.SetText(string(int(fvalue)));
			break;
		case "whiSliderCtrl":
			fvalue = (float(whiSliderCtrl.GetCurrentTick()) * 10.0000000);
			ExecuteCommand(("///yebis whi=" $ string(fvalue)));
			whiValueBox.SetText(string(int(fvalue)));
			break;
		case "sepSliderCtrl":
			fvalue = (float(sepSliderCtrl.GetCurrentTick()) / 100.0000000);
			ExecuteCommand(("///yebis sep=" $ string(fvalue)));
			sepValueBox.SetText(string(fvalue));
			break;
		case "smpSliderCtrl":
			ivalue = (smpSliderCtrl.GetCurrentTick() + 1);
			ExecuteCommand(("///yebis sSmp=" $ string(ivalue)));
			smpValueBox.SetText(string(ivalue));
			break;
		case "rdsSliderCtrl":
			ivalue = (rdsSliderCtrl.GetCurrentTick() + 10);
			ExecuteCommand(("///yebis sRds=" $ string(ivalue)));
			rdsValueBox.SetText(string(ivalue));
			break;
		case "sclSliderCtrl":
			fvalue = ((float(sclSliderCtrl.GetCurrentTick()) / 10.0000000) + 0.1000000);
			ExecuteCommand(("///yebis sScl=" $ string(fvalue)));
			sclValueBox.SetText(string(fvalue));
			break;
		default:
			break;
	}
	return;
}

event OnCompleteEditBox(string strID)
{
	switch(strID)
	{
		case "dofWidthEditBox":
			ExecuteCommand(("///yebis fDepthOfFieldWidthScale=" $ dofWidthEditBox.GetString()));
			break;
		case "dofLvlEditBox":
			ExecuteCommand(("///yebis uiDepthOfFieldApertureLevels=" $ dofLvlEditBox.GetString()));
			break;
		case "dofEdgeEditBox":
			ExecuteCommand(("///yebis eDepthOfFieldEdgeQuality=" $ dofEdgeEditBox.GetString()));
			break;
		case "dofShapeEditBox":
			ExecuteCommand(("///yebis eApertureShape=" $ dofShapeEditBox.GetString()));
			break;
		case "lvCombiEditBox":
			ExecuteCommand(("///yebis iApertureLevelCombination=" $ lvCombiEditBox.GetString()));
			break;
		case "blurWidthEditBox":
			ExecuteCommand(("///yebis uiApertureResultBlurWidth=" $ blurWidthEditBox.GetString()));
			break;
		case "blurScaleEditBox":
			ExecuteCommand(("///yebis fApertureResultBlurScale=" $ blurScaleEditBox.GetString()));
			break;
		case "bladesEditBox":
			ExecuteCommand(("///yebis nDiaphragmBlades=" $ bladesEditBox.GetString()));
			break;
		case "apeCircularEditBox":
			ExecuteCommand(("///yebis fApertureCirculariry=" $ apeCircularEditBox.GetString()));
			break;
		default:
			break;
	}
	return;
}

event OnComboBoxItemSelected(string strID, int IndexID)
{
	switch(strID)
	{
		case "hdrComboBox":
			switch(IndexID)
			{
				case 0:
					ExecuteCommand("///yebis hdr=-1");
					break;
				case 1:
					ExecuteCommand("///yebis hdr=0");
					break;
				case 2:
					ExecuteCommand("///yebis hdr=1");
					break;
				case 3:
					ExecuteCommand("///yebis hdr=2");
					break;
				case 4:
					ExecuteCommand("///yebis hdr=3");
					break;
				case 5:
					ExecuteCommand("///yebis hdr=4");
					break;
				default:
					break;
			}
			break;
		case "shaComboBox":
			switch(IndexID)
			{
				case 0:
					ExecuteCommand("///yebis sha=0");
					break;
				case 1:
					ExecuteCommand("///yebis sha=1");
					break;
				case 2:
					ExecuteCommand("///yebis sha=2");
					break;
				case 3:
					ExecuteCommand("///yebis sha=3");
					break;
				case 4:
					ExecuteCommand("///yebis sha=4");
					break;
				case 5:
					ExecuteCommand("///yebis sha=5");
					break;
				case 6:
					ExecuteCommand("///yebis sha=6");
					break;
				case 7:
					ExecuteCommand("///yebis sha=7");
					break;
				case 8:
					ExecuteCommand("///yebis sha=8");
					break;
				case 9:
					ExecuteCommand("///yebis sha=9");
					break;
				case 10:
					ExecuteCommand("///yebis sha=10");
					break;
				case 11:
					ExecuteCommand("///yebis sha=11");
					break;
				case 12:
					ExecuteCommand("///yebis sha=12");
					break;
				case 13:
					ExecuteCommand("///yebis sha=13");
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
	return;
}

event OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "yebisCheckBox":
			if(yebisCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis on");
			}
			else
			{
				ExecuteCommand("///yebis off");
			}
			break;
		case "tonemapCheckBox":
			if(tonemapCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis bToneMapCvs=1");
			}
			else
			{
				ExecuteCommand("///yebis bToneMapCvs=0");
			}
			break;
		case "dofCheckBox":
			if(dofCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis dof=1");
			}
			else
			{
				ExecuteCommand("///yebis dof=0");
			}
			break;
		case "showRangeCheckBox":
			if(showRangeCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis bok=1");
			}
			else
			{
				ExecuteCommand("///yebis bok=0");
			}
			break;
		case "anaCheckBox":
			if(anaCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis ana=1");
			}
			else
			{
				ExecuteCommand("///yebis ana=0");
			}
			break;
		case "aaCheckBox":
			if(aaCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis aa=1");
			}
			else
			{
				ExecuteCommand("///yebis aa=0");
			}
			break;
		case "aoCheckBox":
			if(aoCheckBox.IsChecked())
			{
				ExecuteCommand("///yebis ssao=1");
			}
			else
			{
				ExecuteCommand("///yebis ssao=0");
			}
			break;
		default:
			break;
	}
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

event OnShow()
{
	expSliderCtrl.SetCurrentTick(50);
	mFactorSliderCtrl.SetCurrentTick(22);
	mgSliderCtrl.SetCurrentTick(18);
	adtSliderCtrl.SetCurrentTick(30);
	tonemapCheckBox.SetCheck(false);
	ExecuteCommand("///yebis bToneMapCvs=0");
	coef1SliderCtrl.SetCurrentTick(95);
	coef2SliderCtrl.SetCurrentTick(30);
	lumSliderCtrl.SetCurrentTick(6);
	thrSliderCtrl.SetCurrentTick(40);
	quaSliderCtrl.SetCurrentTick(5);
	bluSliderCtrl.SetCurrentTick(75);
	remSliderCtrl.SetCurrentTick(32);
	shaComboBox.SetSelectedNum(6);
	ExecuteCommand("///yebis sha=6");
	showRangeCheckBox.SetCheck(false);
	focSliderCtrl.SetCurrentTick(0);
	apeSliderCtrl.SetCurrentTick(24);
	dofqSliderCtrl.SetCurrentTick(11);
	shSliderCtrl.SetCurrentTick(80);
	hueSliderCtrl.SetCurrentTick(179);
	satSliderCtrl.SetCurrentTick(95);
	briSliderCtrl.SetCurrentTick(100);
	conSliderCtrl.SetCurrentTick(100);
	gamSliderCtrl.SetCurrentTick(150);
	temSliderCtrl.SetCurrentTick(650);
	whiSliderCtrl.SetCurrentTick(650);
	sepSliderCtrl.SetCurrentTick(0);
	aoCheckBox.SetCheck(true);
	ExecuteCommand("///yebis ssao=1");
	smpSliderCtrl.SetCurrentTick(31);
	rdsSliderCtrl.SetCurrentTick(70);
	sclSliderCtrl.SetCurrentTick(14);
	return;
}

defaultproperties
{
	m_Windowname="YebisCmdWnd"
}
