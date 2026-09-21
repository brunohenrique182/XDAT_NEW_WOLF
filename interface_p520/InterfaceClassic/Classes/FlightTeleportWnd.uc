class FlightTeleportWnd extends UIScript;

const ICON_FLAG = "L2ui_CT1.MiniMap.Minimap_df_flagicon_yellow";
const ICON_LOC = "L2ui_CT1.MiniMap.Minimap_df_icn_Shield";
const ICON_LOC_DISABLE = "L2ui_CT1.MiniMap.Minimap_df_icn_Shield_disable";
const FLAG_ID = 10001;

var WindowHandle Me;
var WindowHandle FlightShipCtrlWnd;
var MinimapCtrlHandle FlightMap;
var ButtonHandle btnMyPos;
var ButtonHandle btnGo;
var ButtonHandle btnCancle;
var TextBoxHandle TargetTxt;
var TextBoxHandle CostTxt;
var int i;
var int selectID;
var int m_airportID;
var array<int> m_arrTelID;
var array<int> m_arrAirportID;
var array<int> m_arrFuel;
var array<int> m_arrX;
var array<int> m_arrY;
var array<int> m_arrZ;

function int FindSystemStrByID(int Id, int AirportID)
{
	switch(AirportID)
	{
		case 100:
			switch(Id)
			{
				case -1:
					return 1973;
				case 0:
					return 1974;
				case 1:
					return 1975;
				case 2:
					return 2242;
				default:
					break;
			}
			break;
		case 101:
			switch(Id)
			{
				case -1:
					return 1974;
				case 0:
					return 1973;
				default:
					break;
			}
			break;
		case 102:
			switch(Id)
			{
				case -1:
					return 1975;
				case 0:
					return 1973;
				default:
					break;
			}
			break;
		case 103:
			switch(Id)
			{
				case -1:
					return 2242;
				case 0:
					return 1973;
				default:
					break;
			}
			break;
		default:
			break;
	}
}

function OnRegisterEvent()
{
	RegisterEvent(3542);
	RegisterEvent(3543);
	RegisterEvent(2990);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		Initialize();
		OnRegisterEvent();
	}
	else
	{
		InitializeCOD();
	}
	FlightMap.SetContinent(1);
	Clear();
	return;
}

function Initialize()
{
	Me = GetHandle("FlightTeleportWnd");
	FlightShipCtrlWnd = GetHandle("FlightShipCtrlWnd");
	FlightMap = MinimapCtrlHandle(GetHandle("FlightTeleportWnd.FlightMap"));
	btnMyPos = ButtonHandle(GetHandle("FlightTeleportWnd.btnMyPos"));
	btnGo = ButtonHandle(GetHandle("FlightTeleportWnd.btnGo"));
	btnCancle = ButtonHandle(GetHandle("FlightTeleportWnd.btnCancle"));
	TargetTxt = TextBoxHandle(GetHandle("FlightTeleportWnd.TargetTxt"));
	CostTxt = TextBoxHandle(GetHandle("FlightTeleportWnd.CostTxt"));
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("FlightTeleportWnd");
	FlightShipCtrlWnd = GetWindowHandle("FlightShipCtrlWnd");
	FlightMap = GetMinimapCtrlHandle("FlightTeleportWnd.FlightMap");
	btnMyPos = GetButtonHandle("FlightTeleportWnd.btnMyPos");
	btnGo = GetButtonHandle("FlightTeleportWnd.btnGo");
	btnCancle = GetButtonHandle("FlightTeleportWnd.btnCancle");
	TargetTxt = GetTextBoxHandle("FlightTeleportWnd.TargetTxt");
	CostTxt = GetTextBoxHandle("FlightTeleportWnd.CostTxt");
	return;
}

function Clear()
{
	FlightMap.EraseAllRegionInfo();
	m_arrTelID.Remove(0, m_arrTelID.Length);
	m_arrFuel.Remove(0, m_arrFuel.Length);
	m_arrX.Remove(0, m_arrX.Length);
	m_arrY.Remove(0, m_arrY.Length);
	m_arrZ.Remove(0, m_arrZ.Length);
	selectID = -72;
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 3542:
			OnAirShipTeleportListStart(a_Param);
			break;
		case 3543:
			OnAirShipTeleportList(a_Param);
			break;
		case 2990:
			OnMinimapRegionInfoBtnClick(a_Param);
			break;
		default:
			break;
	}
	return;
}

function OnAirShipTeleportListStart(string a_Param)
{
	ParseInt(a_Param, "AirportID", m_airportID);
	Clear();
	SetMeCenter();
	if(FlightShipCtrlWnd.IsShowWindow())
	{
		if(!Me.IsShowWindow())
		{
			Me.ShowWindow();
			Me.SetFocus();
		}
	}
	else
	{
		AddSystemMessage(2786);
	}
	return;
}

function OnAirShipTeleportList(string a_Param)
{
	local int Id, FuelConsume, X, Y, Z;

	ParseInt(a_Param, "ID", Id);
	ParseInt(a_Param, "FuelConsume", FuelConsume);
	ParseInt(a_Param, "X", X);
	ParseInt(a_Param, "Y", Y);
	ParseInt(a_Param, "Z", Z);
	m_arrTelID.Insert(0, 1);
	m_arrTelID[0] = Id;
	m_arrAirportID.Insert(0, 1);
	m_arrAirportID[0] = m_airportID;
	m_arrFuel.Insert(0, 1);
	m_arrFuel[0] = FuelConsume;
	m_arrX.Insert(0, 1);
	m_arrX[0] = X;
	m_arrY.Insert(0, 1);
	m_arrY[0] = Y;
	m_arrZ.Insert(0, 1);
	m_arrZ[0] = Z;
	SetLoc(Id);
	SelectLoc(Id, false);
	if((Id == -1))
	{
		selectID = -1;
		SelectLoc(-1, true);
	}
	return;
}

function OnMinimapRegionInfoBtnClick(string a_Param)
{
	local int Id;

	ParseInt(a_Param, "Index", Id);
	i = 0;
	while((i < m_arrTelID.Length))
	{
		UnSelectLoc(m_arrTelID[i]);
		i++;
	}
	if((Id < 9800))
	{
		SelectLoc(Id, true);
	}
	else
	{
		SelectLoc((Id - 10001), true);
	}
	selectID = Id;
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnMyPos":
			OnBtnMyPos();
			break;
		case "btnGo":
			OnBtnGo();
			break;
		case "btnCancle":
			if(Me.IsShowWindow())
			{
				Me.HideWindow();
			}
			Clear();
			SetMeCenter();
			break;
		default:
			break;
	}
	return;
}

function OnBtnMyPos()
{
	SetMeCenter();
	return;
}

function OnBtnGo()
{
	if((selectID != -72))
	{
		if((selectID >= 9000))
		{
			selectID = (selectID - 10000);
		}
		Class'NWindow.VehicleAPI'.static.RequestExAirShipTeleport(selectID);
		if(Me.IsShowWindow())
		{
			Me.HideWindow();
		}
		Clear();
		SetMeCenter();
	}
	return;
}

function SetMeCenter()
{
	local Vector Loc;

	Loc = GetPlayerPosition();
	FlightMap.AdjustMapView(Loc);
	return;
}

function SelectLoc(int Id, bool isUpdate)
{
	local int arrIdx, AirportID, FuelConsume, X, Y, Z, AirPortNameID;
	local string DataforMap;

	arrIdx = FindArrIdxByID(Id);
	if((arrIdx == -1))
	{
		return;
	}
	AirportID = m_arrAirportID[arrIdx];
	FuelConsume = m_arrFuel[arrIdx];
	X = m_arrX[arrIdx];
	Y = m_arrY[arrIdx];
	Z = m_arrZ[arrIdx];
	AirPortNameID = FindSystemStrByID(Id, AirportID);
	ParamAdd(DataforMap, "Index", string((Id + 10001)));
	ParamAdd(DataforMap, "WorldX", string(X));
	ParamAdd(DataforMap, "WorldY", string((Y - 4500)));
	ParamAdd(DataforMap, "BtnWidth", string(32));
	ParamAdd(DataforMap, "BtnHeight", string(32));
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "0");
	ParamAdd(DataforMap, "Tooltip", "");
	if((isUpdate == true))
	{
		ParamAdd(DataforMap, "BtnTexNormal", "L2ui_CT1.MiniMap.Minimap_df_flagicon_yellow");
		ParamAdd(DataforMap, "BtnTexPushed", "L2ui_CT1.MiniMap.Minimap_df_flagicon_yellow");
		ParamAdd(DataforMap, "BtnTexOver", "L2ui_CT1.MiniMap.Minimap_df_flagicon_yellow");
		FlightMap.UpdateRegionInfo((Id + 10001), DataforMap);
		TargetTxt.SetText(("" $ GetSystemString(AirPortNameID)));
		CostTxt.SetText((string(FuelConsume) $ " EP"));
	}
	else
	{
		ParamAdd(DataforMap, "BtnTexNormal", "");
		ParamAdd(DataforMap, "BtnTexPushed", "");
		ParamAdd(DataforMap, "BtnTexOver", "");
		FlightMap.AddRegionInfo(DataforMap);
	}
	return;
}

function UnSelectLoc(int Id)
{
	local int arrIdx, X, Y, Z;
	local string DataforMap;

	if((Id > (10001 - 100)))
	{
		arrIdx = FindArrIdxByID((Id - 10001));
	}
	if((arrIdx == -1))
	{
		return;
	}
	X = m_arrX[arrIdx];
	Y = m_arrY[arrIdx];
	Z = m_arrZ[arrIdx];
	ParamAdd(DataforMap, "Index", string((Id + 10001)));
	ParamAdd(DataforMap, "WorldX", string(X));
	ParamAdd(DataforMap, "WorldY", string((Y - 4500)));
	ParamAdd(DataforMap, "BtnWidth", string(32));
	ParamAdd(DataforMap, "BtnHeight", string(32));
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "0");
	ParamAdd(DataforMap, "BtnTexNormal", "L2UI_CT1.EmptyBtn");
	ParamAdd(DataforMap, "BtnTexPushed", "L2UI_CT1.EmptyBtn");
	ParamAdd(DataforMap, "BtnTexOver", "L2UI_CT1.EmptyBtn");
	ParamAdd(DataforMap, "Tooltip", "");
	FlightMap.UpdateRegionInfo((Id + 10001), DataforMap);
	return;
}

function SetLoc(int Id)
{
	local int arrIdx, AirportID, FuelConsume, X, Y, Z;
	local string DataforMap;

	arrIdx = FindArrIdxByID(Id);
	if((arrIdx == -1))
	{
		return;
	}
	AirportID = m_arrAirportID[arrIdx];
	FuelConsume = m_arrFuel[arrIdx];
	X = m_arrX[arrIdx];
	Y = m_arrY[arrIdx];
	Z = m_arrZ[arrIdx];
	ParamAdd(DataforMap, "Index", string(Id));
	ParamAdd(DataforMap, "WorldX", string(X));
	ParamAdd(DataforMap, "WorldY", string(Y));
	ParamAdd(DataforMap, "BtnTexNormal", "L2ui_CT1.MiniMap.Minimap_df_icn_Shield");
	ParamAdd(DataforMap, "BtnTexPushed", "L2ui_CT1.MiniMap.Minimap_df_icn_Shield");
	ParamAdd(DataforMap, "BtnTexOver", "L2ui_CT1.MiniMap.Minimap_df_icn_Shield");
	ParamAdd(DataforMap, "BtnWidth", string(32));
	ParamAdd(DataforMap, "BtnHeight", string(32));
	ParamAdd(DataforMap, "Description", "");
	ParamAdd(DataforMap, "DescOffsetX", "0");
	ParamAdd(DataforMap, "DescOffsetY", "0");
	ParamAdd(DataforMap, "Tooltip", "");
	FlightMap.AddRegionInfo(DataforMap);
	return;
}

function int FindArrIdxByID(int Id)
{
	local int Value;

	Value = -1;
	i = 0;
	while((i < m_arrTelID.Length))
	{
		if((m_arrTelID[i] == Id))
		{
			return i;
		}
		i++;
	}
	return Value;
}
