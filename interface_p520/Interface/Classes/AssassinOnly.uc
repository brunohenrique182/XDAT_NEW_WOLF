class AssassinOnly extends UICommonAPI;

const skillBuffClassID = 87366;

var WindowHandle Me;
var TextBoxHandle AssassinPoint_txt;
var TextureHandle AssassinMain_tex;
var AnimTextureHandle AssassinPoint_ani;
var AnimTextureHandle AssassinMain_ani;
var AnimTextureHandle AssassinGauge_Trailer;
var int Count;
var int beforeCount;
var int MyMaxAP;
var int MYCurrentAP;
var int RemainTime;
var L2UITimerObject timeObject;
var SkillInfo skillBuffInfo;
var ProgressCtrlHandle AssassinGauge_progressbar;
var int posX;
var int posY;
var int startPosX;
var float timeSec;

function OnRegisterEvent()
{
	RegisterEvent(11600);
	RegisterEvent(11601);
	RegisterEvent(40);
	RegisterEvent(950);
	RegisterEvent(3410);
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("AssassinOnly");
	AssassinPoint_txt = GetTextBoxHandle("AssassinOnly.AssassinPoint_txt");
	AssassinMain_tex = GetTextureHandle("AssassinOnly.AssassinMain_tex");
	AssassinPoint_ani = GetAnimTextureHandle("AssassinOnly.AssassinPoint_ani");
	AssassinMain_ani = GetAnimTextureHandle("AssassinOnly.AssassinMain_ani");
	AssassinGauge_Trailer = GetAnimTextureHandle("AssassinOnly.AssassinGauge_Trailer");
	AssassinGauge_progressbar = GetProgressCtrlHandle("AssassinOnly.AssassinGauge_progressbar");
	AssassinPoint_txt.SetText("-");
	GetSkillInfo(87366, 1, 0, skillBuffInfo);
	AssassinGauge_Trailer.HideWindow();
	AssassinGauge_progressbar.SetPos(0);
	timeObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject();
	timeObject._DelegateOnTime = OnTime;
	timeObject._DelegateOnEnd = OnEndTime;
	return;
}

function OnShow()
{
	return;
}

function Load()
{
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 11601:
			ParseInt(a_Param, "MyMaxAP", MyMaxAP);
			if((GetGameStateName() == "GAMINGSTATE"))
			{
				if((timeSec <= 0.0000000))
				{
					AssassinGauge_Trailer.HideWindow();
				}
				Me.ShowWindow();
			}
			break;
		case 11600:
			ParseInt(a_Param, "MYCurrentAP", MYCurrentAP);
			beforeCount = Count;
			Count = (MYCurrentAP / 10000);
			AssassinPoint_txt.SetText(("x" $ string(Count)));
			if((Count > 0))
			{
				AssassinMain_tex.SetTexture("L2UI_NewTex.AssassinOnly.AssassinOnly_Active");
				if((beforeCount == 0))
				{
					AnimTexturePlay(AssassinMain_ani, true, 1);
				}
			}
			else
			{
				AssassinMain_tex.SetTexture("L2UI_NewTex.AssassinOnly.AssassinOnly_Disabled");
			}
			if((beforeCount != Count))
			{
				AnimTexturePlay(AssassinPoint_ani, true, 1);
			}
			break;
		case 950:
			if((MyMaxAP > 0))
			{
				ParseAbnormalStatusNormalItem(a_Param);
			}
			break;
		case 40:
			MyMaxAP = 0;
			Me.HideWindow();
			AssassinGauge_progressbar.SetPos(0);
			AssassinGauge_Trailer.HideWindow();
			timeKill();
			break;
		case 3410:
			HnadleStateChanged();
			break;
		default:
			break;
	}
	return;
}

function ParseAbnormalStatusNormalItem(string a_Param)
{
	local int i, Max, ClassID;
	local bool bHasSkill;

	ParseInt(a_Param, "Max", Max);
	if((Max == 0))
	{
		AssassinGauge_progressbar.SetPos(0);
		AssassinGauge_Trailer.HideWindow();
		timeKill();
		return;
	}
	i = 0;
	while((i < Max))
	{
		ParseInt(a_Param, ("ClassID_" $ string(i)), ClassID);
		if((ClassID == 87366))
		{
			ParseInt(a_Param, ("RemainTime_" $ string(i)), RemainTime);
			timeObject._Stop();
			timeObject._time = 100;
			timeObject._maxCount = (RemainTime * 10);
			timeObject._Play();
			AssassinGauge_progressbar.SetProgressTime((skillBuffInfo.AbnormalTime * 1000));
			AssassinGauge_progressbar.SetPos((RemainTime * 1000));
			AssassinGauge_progressbar.Start();
			posX = (Me.GetRect().nX + 52);
			posY = (Me.GetRect().nY + 40);
			startPosX = int((52.0000000 + (float((134 * float((RemainTime * 10)))) / float((skillBuffInfo.AbnormalTime * 10)))));
			timeSec = float(RemainTime);
			AnimTexturePlay(AssassinGauge_Trailer, true, 9999);
			AssassinGauge_Trailer.MoveTo(posX, posY);
			bHasSkill = true;
			break;
		}
		i++;
	}
	if(((bHasSkill == false) && AssassinGauge_Trailer.IsShowWindow()))
	{
		AssassinGauge_progressbar.SetPos(0);
		AssassinGauge_Trailer.HideWindow();
		timeKill();
	}
	return;
}

function OnTime(int Count)
{
	posX = (Me.GetRect().nX + startPosX);
	AssassinGauge_Trailer.MoveTo(int((float(posX) - (134.0000000 * (((float(RemainTime) - timeSec) * 10.0000000) / float((skillBuffInfo.AbnormalTime * 10)))))), AssassinGauge_Trailer.GetRect().nY);
	timeSec = (timeSec - 0.1000000);
	return;
}

function OnEndTime()
{
	AssassinGauge_progressbar.SetPos(0);
	AssassinGauge_Trailer.HideWindow();
	timeKill();
	return;
}

function timeKill()
{
	timeObject._Stop();
	return;
}

function HnadleStateChanged()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	if((MyMaxAP > 0))
	{
		AssassinGauge_progressbar.SetPos(int((timeSec * 1000.0000000)));
		Me.ShowWindow();
	}
	return;
}
