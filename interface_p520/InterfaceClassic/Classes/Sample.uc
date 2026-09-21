class Sample extends GFxUIScript;

var string testMember;
var Sample sampleWnd;

function OnRegisterEvent()
{
	RegisterGFxEvent(77777);
	return;
}

function OnLoad()
{
	testMember = "testMember uc 데이타";  // EN: testMember uc data
	SetClosingOnESC();
	RegisterState("Sample", "GamingState");
	SetContainer("ContainerWindow");
	SetStateChangeNotification();
	sampleWnd = Sample(GetScript("Sample"));
	return;
}

function OnCallUCFunction(string functionName, string param)
{
	Debug((("sampe's onCallUCFunction" @ functionName) @ param));
	switch(functionName)
	{
		case "ouputCheck":
			ouputCheck(param);
			break;
		default:
			break;
	}
	return;
}

function ouputCheck(string param)
{
	local GFxValue Obj;
	local string test1;
	local int test2;
	local float test3;
	local bool test4;
	local string data1, data2, data3, data4;

	PlayConsoleSound(IFST_MAPWND_OPEN);
	AllocGFxValue(Obj);
	ParseString(param, "d1", data1);
	ParseString(param, "d2", data2);
	ParseString(param, "d3", data3);
	ParseString(param, "d4", data4);
	Debug(("sample.GetVariable" @ string(sampleWnd.GetVariable(Obj, "getValTest1"))));
	test1 = Obj.GetString();
	Debug(("sample.GetVariable" @ string(sampleWnd.GetVariable(Obj, "getValTest2"))));
	test2 = Obj.GetInt();
	Debug(("sample.GetVariable" @ string(sampleWnd.GetVariable(Obj, "getValTest3"))));
	test3 = Obj.GetFloat();
	Debug(("sample.GetVariable" @ string(sampleWnd.GetVariable(Obj, "getValTest4"))));
	test4 = Obj.GetBool();
	Debug((((((((("ouputCheck" @ data1) @ test1) @ data2) @ string(test2)) @ data3) @ string(test3)) @ data4) @ string(test4)));
	DeallocGFxValue(Obj);
	return;
}
