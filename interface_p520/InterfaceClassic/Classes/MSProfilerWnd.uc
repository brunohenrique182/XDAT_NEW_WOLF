class MSProfilerWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var MSViewerWnd m_scriptMSViewerWnd;
var TextBoxHandle m_hTxtFrameRate;
var TextBoxHandle m_hTxtMaxEmitterNum;
var TextBoxHandle m_hTxtMaxEmitterParticleNum;
var ListCtrlHandle m_hListEmitterCycle;
var Color Gold;
var Color Red;
var Color Orange;
var Color Green;
var Color White;

function OnLoad()
{
	Me = GetWindowHandle(m_Windowname);
	m_scriptMSViewerWnd = MSViewerWnd(GetScript("MSViewerWnd"));
	m_hTxtFrameRate = GetTextBoxHandle((m_Windowname $ ".txtFrameRate"));
	m_hTxtMaxEmitterNum = GetTextBoxHandle((m_Windowname $ ".txtMaxEmitterNum"));
	m_hTxtMaxEmitterParticleNum = GetTextBoxHandle((m_Windowname $ ".txtMaxEmitterParticleNum"));
	m_hListEmitterCycle = GetListCtrlHandle((m_Windowname $ ".listEmitterCycle"));
	Gold.R = 176;
	Gold.G = 153;
	Gold.B = 121;
	Red.R = 255;
	Red.G = 0;
	Red.B = 0;
	Orange.R = 255;
	Orange.G = 127;
	Orange.B = 39;
	Green.R = 0;
	Green.G = 255;
	Green.B = 0;
	White.R = 255;
	White.G = 255;
	White.B = 255;
	m_hOwnerWnd.EnableTick();
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(4430);
	RegisterEvent(4431);
	return;
}

function ComputeFrameRateOverload(float frameRate, int targetNum)
{
	local float overload, stableload;

	overload = (0.2000000 + (0.1000000 * float(targetNum)));
	stableload = (0.1000000 + (0.0500000 * float(targetNum)));
	if((frameRate > overload))
	{
		m_hTxtFrameRate.SetTextColor(Red);
	}
	else if((frameRate > stableload))
	{
		m_hTxtFrameRate.SetTextColor(Orange);
	}
	else
	{
		m_hTxtFrameRate.SetTextColor(Green);
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local float frameRate;
	local int maxEmitterNum, maxEmitterParticleNum, targetNum, emitterNum, i;
	local string emitterName;
	local int emitterParticleNum;
	local float emitterAvgFrameRate, emitterMaxFrameRate;
	local LVDataRecord Record;

	Record.LVDataList.Length = 4;
	if((Event_ID == 4430))
	{
		ParseFloat(param, "FrameRate", frameRate);
		ParseInt(param, "TargetNum", targetNum);
		m_hTxtFrameRate.SetText(string(frameRate));
		ComputeFrameRateOverload(frameRate, targetNum);
		ParseInt(param, "MaxEmitterNum", maxEmitterNum);
		m_hTxtMaxEmitterNum.SetText(string(maxEmitterNum));
		ParseInt(param, "MaxEmitterParticleNum", maxEmitterParticleNum);
		m_hTxtMaxEmitterParticleNum.SetText(string(maxEmitterParticleNum));
		ParseInt(param, "EmitterNum", emitterNum);
		i = 0;
		while((i < emitterNum))
		{
			ParseString(param, ("EmitterName_" $ string(i)), emitterName);
			ParseInt(param, ("EmitterParticleNum_" $ string(i)), emitterParticleNum);
			ParseFloat(param, ("AvgEmitterFrameRate_" $ string(i)), emitterAvgFrameRate);
			ParseFloat(param, ("MaxEmitterFrameRate_" $ string(i)), emitterMaxFrameRate);
			Record.LVDataList[0].bUseTextColor = true;
			Record.LVDataList[0].szData = emitterName;
			Record.LVDataList[0].TextColor = Gold;
			Record.LVDataList[1].szData = string(emitterParticleNum);
			Record.LVDataList[1].TextColor = Gold;
			if((frameRate > 0.0000000))
			{
				Record.LVDataList[2].szData = (((string(emitterAvgFrameRate) $ "(") $ string(int(((emitterAvgFrameRate / frameRate) * 100.0000000)))) $ "%)");
			}
			else
			{
				Record.LVDataList[2].szData = (string(emitterAvgFrameRate) $ "(##%)");
			}
			Record.LVDataList[2].TextColor = Gold;
			Record.LVDataList[3].szData = string(emitterMaxFrameRate);
			Record.LVDataList[3].TextColor = Gold;
			m_hListEmitterCycle.InsertRecord(Record);
			++i;
		}
	}
	if((Event_ID == 4431))
	{
		ClearProfilingData();
	}
	return;
}

function ClearProfilingData()
{
	m_hTxtFrameRate.SetText("분석중");  // EN: analyzing
	m_hTxtFrameRate.SetTextColor(White);
	m_hTxtMaxEmitterNum.SetText("분석중");  // EN: analyzing
	m_hTxtMaxEmitterNum.SetTextColor(White);
	m_hTxtMaxEmitterParticleNum.SetText("분석중");  // EN: analyzing
	m_hTxtMaxEmitterParticleNum.SetTextColor(White);
	m_hListEmitterCycle.DeleteAllItem();
	return;
}

function OnShow()
{
	ClearProfilingData();
	return;
}

function OnTick()
{
	if(Me.IsShowWindow())
	{
		Class'NWindow.UIDATA_PAWNVIEWER'.static.UpdateEmitterProfiling();
	}
	return;
}

defaultproperties
{
	m_Windowname="MSProfilerWnd"
}
