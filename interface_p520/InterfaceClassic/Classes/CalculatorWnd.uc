class CalculatorWnd extends UICommonAPI;

const MAX_NUMERIC_LENGTH = 17;

enum EOperator
{
	OP_None,                        // 0
	OP_PLUS,                        // 1
	OP_MINUS,                       // 2
	OP_MULTIPLY,                    // 3
	OP_DIVIDE                       // 4
};

var INT64 m_Operand1;
var EOperator m_Operator;
var EditBoxHandle m_ResultEditBox;

function OnRegisterEvent()
{
	RegisterEvent(1700);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	m_ResultEditBox = GetEditBoxHandle("CalculatorWnd.editBoxCalculate");
	m_ResultEditBox.DisableWindow();
	return;
}

function OnShow()
{
	InitCalculator();
	return;
}

function InitCalculator()
{
	m_Operand1 = INT64(0);
	SetOperator(OP_None);
	GotoState('Operand1');
	CE();
	return;
}

function CE()
{
	SetNumeric(INT64(0));
	return;
}

function SetOperand1(INT64 a_Operand)
{
	m_Operand1 = a_Operand;
	return;
}

function SetOperator(EOperator Op)
{
	m_Operator = Op;
	return;
}

function AddString(string Str)
{
	m_ResultEditBox.AddString(Str);
	return;
}

function SetString(string Str)
{
	m_ResultEditBox.SetString(Str);
	return;
}

function string GetString()
{
	return m_ResultEditBox.GetString();
}

function INT64 GetOperand()
{
	local string Str;

	Str = GetString();
	if((Len(Str) > 0))
	{
		return INT64(Str);
	}
	else
	{
		return INT64(0);
	}
}

function INT64 Calc(INT64 A, INT64 B, EOperator Op)
{
	local INT64 nResult;

	switch(Op)
	{
		case OP_PLUS:
			nResult = (A + B);
			break;
		case OP_MINUS:
			nResult = (A - B);
			break;
		case OP_MULTIPLY:
			nResult = (A * B);
			break;
		case OP_DIVIDE:
			if((B == INT64(0)))
			{
				nResult = INT64(0);
			}
			else
			{
				nResult = (A / B);
			}
			break;
		case OP_None:
			nResult = INT64(0);
			break;
		default:
			break;
	}
	return nResult;
}

function Backspace()
{
	local string strTemp, strResult;
	local int iLength;

	strTemp = GetString();
	iLength = (Len(strTemp) - 1);
	if((iLength > 0))
	{
		strResult = Left(strTemp, iLength);
		SetString(strResult);
	}
	else
	{
		CE();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 1700:
			ShowWindowWithFocus("CalculatorWnd");
			break;
		default:
			break;
	}
	return;
}

function AddNumeric(int a_Number)
{
	local string currentNumeric;

	currentNumeric = GetString();
	if((currentNumeric == "0"))
	{
		SetNumeric(INT64(a_Number));
	}
	else if((Len(currentNumeric) < 17))
	{
		AddString(string(a_Number));
	}
	return;
}

function SetNumeric(INT64 a_Number)
{
	local string newNumeric;

	newNumeric = string(a_Number);
	if((Len(newNumeric) <= 17))
	{
		SetString(newNumeric);
	}
	else
	{
		DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemMessage(3093));
		CE();
	}
	return;
}

function ProcessNumeric(int a_Number)
{
	return;
}

function ProcessOperator(EOperator a_Operator)
{
	return;
}

function ProcessEqual()
{
	return;
}

function ProcessBtn(Interactions.EInputKey ivalue)
{
	local int inputNumeric;
	local EOperator inputOperator;

	if((((48 <= int(ivalue)) && (int(ivalue) <= 57)) || ((96 <= int(ivalue)) && (int(ivalue) <= 105))))
	{
		if(((48 <= int(ivalue)) && (int(ivalue) <= 57)))
		{
			inputNumeric = (int(ivalue) - 48);
		}
		else
		{
			inputNumeric = (int(ivalue) - 96);
		}
		ProcessNumeric(inputNumeric);
	}
	else if((((((int(ivalue) == 106) || (int(ivalue) == 107)) || (int(ivalue) == 109)) || (int(ivalue) == 189)) || (int(ivalue) == 111)))
	{
		switch(ivalue)
		{
			case IK_GreyStar:
				inputOperator = OP_MULTIPLY;
				break;
			case IK_GreyPlus:
				inputOperator = OP_PLUS;
				break;
			case IK_GreyMinus:
			case IK_Minus:
				inputOperator = OP_MINUS;
				break;
			case IK_GreySlash:
				inputOperator = OP_DIVIDE;
				break;
			default:
				inputOperator = OP_None;
				break;
		}
		ProcessOperator(inputOperator);
	}
	else if(((int(ivalue) == 13) || (int(ivalue) == 187)))
	{
		ProcessEqual();
	}
	else if((int(ivalue) == 27))
	{
		InitCalculator();
	}
	else if((int(ivalue) == 8))
	{
		Backspace();
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btn0":
			ProcessBtn(IK_0);
			break;
		case "btn1":
			ProcessBtn(IK_1);
			break;
		case "btn2":
			ProcessBtn(IK_2);
			break;
		case "btn3":
			ProcessBtn(IK_3);
			break;
		case "btn4":
			ProcessBtn(IK_4);
			break;
		case "btn5":
			ProcessBtn(IK_5);
			break;
		case "btn6":
			ProcessBtn(IK_6);
			break;
		case "btn7":
			ProcessBtn(IK_7);
			break;
		case "btn8":
			ProcessBtn(IK_8);
			break;
		case "btn9":
			ProcessBtn(IK_9);
			break;
		case "btnAdd":
			ProcessBtn(IK_GreyPlus);
			break;
		case "btnCE":
			CE();
			break;
		case "btnSub":
			ProcessBtn(IK_GreyMinus);
			break;
		case "btnC":
			ProcessBtn(IK_Escape);
			break;
		case "btnMul":
			ProcessBtn(IK_GreyStar);
			break;
		case "btnBS":
			ProcessBtn(IK_Backspace);
			break;
		case "btn00":
			ProcessBtn(IK_0);
			ProcessBtn(IK_0);
			break;
		case "btnDiv":
			ProcessBtn(IK_GreySlash);
			break;
		case "btnEQ":
			ProcessBtn(IK_Enter);
			break;
		case "btnClose":
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("CalculatorWnd");
			break;
		default:
			break;
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{
	ProcessBtn(Key);
	return false;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("CalculatorWnd").HideWindow();
	return;
}

auto state Operand1
{
	function ProcessEqual()
	{
		return;
	}

	function ProcessNumeric(int a_Number)
	{
		AddNumeric(a_Number);
		return;
	}

	function ProcessOperator(EOperator a_Operator)
	{
		SetOperator(a_Operator);
		SetOperand1(GetOperand());
		GotoState('ReadyForOperand2');
		return;
	}
}

state ReadyForOperand2
{
	function ProcessNumeric(int a_Number)
	{
		SetNumeric(INT64(a_Number));
		GotoState('Operand2');
		return;
	}

	function ProcessOperator(EOperator a_Operator)
	{
		SetOperator(a_Operator);
		SetOperand1(GetOperand());
		return;
	}

	function ProcessEqual()
	{
		SetNumeric(Calc(m_Operand1, GetOperand(), m_Operator));
		return;
	}
}

state Operand2
{
	function ProcessNumeric(int a_Number)
	{
		AddNumeric(a_Number);
		return;
	}

	function ProcessOperator(EOperator a_Operator)
	{
		local INT64 Result;

		Result = Calc(m_Operand1, GetOperand(), m_Operator);
		SetNumeric(Result);
		SetOperand1(Result);
		SetOperator(a_Operator);
		GotoState('ReadyForOperand2');
		return;
	}

	function ProcessEqual()
	{
		local INT64 Operand2;

		Operand2 = GetOperand();
		SetNumeric(Calc(m_Operand1, Operand2, m_Operator));
		SetOperand1(Operand2);
		GotoState('ReadyForOperand1');
		return;
	}
}

state ReadyForOperand1
{
	function ProcessNumeric(int a_Number)
	{
		SetNumeric(INT64(a_Number));
		GotoState('Operand1');
		return;
	}

	function ProcessOperator(EOperator a_Operator)
	{
		SetOperand1(GetOperand());
		SetOperator(a_Operator);
		GotoState('ReadyForOperand2');
		return;
	}

	function ProcessEqual()
	{
		SetNumeric(Calc(GetOperand(), m_Operand1, m_Operator));
		return;
	}
}
