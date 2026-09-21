class TargetStatusBuff2Wnd extends UICommonAPI;

var WindowHandle Me;
var StatusIconHandle StatusIcons;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	if((1 == 0))
	{
		Initialize();
	}
	else
	{
		InitializeCOD();
	}
	Load();
	return;
}

function Initialize()
{
	Me = GetHandle("TargetStatusBuff2Wnd");
	StatusIcons = StatusIconHandle(GetHandle("TargetStatusBuff2Wnd.StatusIcons"));
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("TargetStatusBuff2Wnd");
	StatusIcons = GetStatusIconHandle("TargetStatusBuff2Wnd.StatusIcons");
	return;
}

function Load()
{
	return;
}

function showBuff(array<StatusIconInfo> Info)
{
	local int i, j, Line, Length, remainder, LineCount;

	Info = arrayReverse(Info);
	LineCount = 0;
	Length = Info.Length;
	Line = (((Length - 1) / 6) + 1);
	remainder = int((float(Length) % 6.0000000));
	ResetBuffIcon();
	reSizeWindow(Length);
	if((Line < 2))
	{
		StatusIcons.AddRow();
		i = 0;
		while((i < Length))
		{
			StatusIcons.AddCol(0, Info[i]);
			i++;
		}
	}
	else
	{
		if((remainder == 0))
		{
			remainder = 6;
		}
		j = (Line - 1);
		while((j >= 1))
		{
			StatusIcons.AddRow();
			i = (remainder + ((j - 1) * 6));
			while((i < (remainder + (j * 6))))
			{
				StatusIcons.AddCol(LineCount, Info[i]);
				i++;
			}
			LineCount++;
			j--;
		}
		StatusIcons.AddRow();
		i = 0;
		while((i < remainder))
		{
			StatusIcons.AddCol(LineCount, Info[i]);
			i++;
		}
		LineCount++;
	}
	return;
}

function reSizeWindow(int Count)
{
	local int W, h;

	if((Count > 5))
	{
		W = 168;
	}
	else
	{
		W = ((26 * Count) + 12);
	}
	h = ((26 * (((Count - 1) / 6) + 1)) + 12);
	Me.SetWindowSize(W, h);
	return;
}

function array<StatusIconInfo> arrayReverse(array<StatusIconInfo> Info)
{
	local int i;
	local array<StatusIconInfo> infoRe;

	i = (Info.Length - 1);
	while((i >= 0))
	{
		infoRe.Insert(infoRe.Length, 1);
		infoRe[(infoRe.Length - 1)] = Info[i];
		i--;
	}
	return infoRe;
}

function ResetBuffIcon()
{
	StatusIcons.Clear();
	return;
}
