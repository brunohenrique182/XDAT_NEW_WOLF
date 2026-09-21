class UIButtonTestWnd extends UICommonAPI;

const DICETWEEN0 = 1000;
const DICETWEEN1 = 1001;
const TWEENDURATION = 100;
const DICEHEIGHT = 120;
const DICE_INIT_LOCY = 0;

var float Angle;
var DrawPanelHandle drawPanel1;
var DrawPanelHandle drawPanel2;
var L2UITweenObject diceTweenObj0;
var L2UITweenObject diceTweenObj1;
var int diceRollCount;
var int diceNumber;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	drawPanel1 = GetDrawPanelHandle("UIButtonTestWnd.drawPanel1");
	drawPanel2 = GetDrawPanelHandle("UIButtonTestWnd.ScrollArea.itemRenderer.drawPanel2");
	DiceInit();
	return;
}

function DiceInit()
{
	diceTweenObj0 = new Class'Interface.L2UITweenObject';
	diceTweenObj0.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	diceTweenObj0.Target = GetMeTexture("DiceAni.DiceSwap00");
	diceTweenObj0.Duration = 100.0000000;
	diceTweenObj0.Id = 1000;
	diceTweenObj0.MoveY = 120.0000000;
	diceTweenObj0.ease = EASENONE;
	diceTweenObj0._DelegateOnStart = OnDelegateOnStartHide;
	diceTweenObj0._DelegateOnEnd = OnDelegateOnEndHide;
	diceTweenObj1 = new Class'Interface.L2UITweenObject';
	diceTweenObj1.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	diceTweenObj1.Target = GetMeTexture("DiceAni.DiceSwap01");
	diceTweenObj1.Duration = 100.0000000;
	diceTweenObj1.Id = 1001;
	diceTweenObj1.MoveY = 120.0000000;
	diceTweenObj1.ease = EASENONE;
	diceTweenObj1._DelegateOnStart = OnDelegateOnStartShow;
	diceTweenObj1._DelegateOnEnd = OnDelegateOnEndShow;
	return;
}

function OnDelegateOnStartShow(L2UITweenObject tObject)
{
	if((diceRollCount == 2))
	{
		TextureHandle(tObject.Target).SetTexture(("L2UI_CH3.Br_Score" $ string(diceNumber)));
	}
	else
	{
		TextureHandle(tObject.Target).SetTexture(("L2UI_CH3.Br_Score" $ string((Rand(9) + 1))));
	}
	Debug((("dice0 tex" @ string(diceRollCount)) @ TextureHandle(tObject.Target).GetTextureName()));
	tObject.Target.MoveC(0, -120);
	return;
}

function OnDelegateOnStartHide(L2UITweenObject tObject)
{
	tObject.Target.MoveC(0, 0);
	return;
}

function OnDelegateOnEndShow(L2UITweenObject tObject)
{
	tObject._DelegateOnStart = OnDelegateOnStartHide;
	tObject._DelegateOnEnd = OnDelegateOnEndHide;
	NextDiceRoll(tObject);
	return;
}

function OnDelegateOnEndHide(L2UITweenObject tObject)
{
	tObject._DelegateOnStart = OnDelegateOnStartShow;
	tObject._DelegateOnEnd = OnDelegateOnEndShow;
	NextDiceRoll(tObject);
	return;
}

function NextDiceRoll(L2UITweenObject tObject)
{
	if((diceRollCount > 0))
	{
		if((diceRollCount < 11))
		{
			tObject.Duration = (tObject.Duration + 50.0000000);
		}
		tObject._Reset();
	}
	diceRollCount--;
	return;
}

function Ontest30ButtonClick()
{
	GetMeTexture("DiceAni.DiceSwap00").MoveC(0, 0);
	GetMeTexture("DiceAni.DiceSwap01").MoveC(0, -120);
	diceRollCount = 50;
	diceNumber = 8;
	diceTweenObj0.Duration = 100.0000000;
	diceTweenObj1.Duration = 100.0000000;
	diceTweenObj0._Reset();
	diceTweenObj1._Reset();
	return;
}

event OnShow()
{
	local int i;

	i = 1;
	while((i < 11))
	{
		GetButtonHandle((("UIButtonTestWnd.test" $ string(i)) $ "Button")).MoveC(((i - 1) * 105), 30);
		i++;
	}
	i = 11;
	while((i < 21))
	{
		GetButtonHandle((("UIButtonTestWnd.test" $ string(i)) $ "Button")).MoveC(((i - 11) * 105), 80);
		i++;
	}
	i = 21;
	while((i < 31))
	{
		GetButtonHandle((("UIButtonTestWnd.test" $ string(i)) $ "Button")).MoveC(((i - 21) * 105), 130);
		i++;
	}
	initControl();
	drawPanel();
	setScrollDrawPanel2();
	return;
}

function drawPanel()
{
	local int nX, nY;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemTextureCustom("L2UI_NewTex.BottomBar.SuppressHotTime", false, false, 0, 0, 10, 11, 10, 11);
	drawListArr[drawListArr.Length] = addDrawItemText("우주의 기운을 받아서 출력을 해라! 이야야야야", getInstanceL2Util().Yellow, "", false, true, 10);  // EN?: Take the energy of the universe and print it out! It's okay.
	drawListArr[drawListArr.Length] = addDrawItemText("red! 빨강", getInstanceL2Util().Red, "", false, true, 10);  // EN?: red! red
	drawListArr[drawListArr.Length] = addDrawItemText("blue! 파랑", getInstanceL2Util().Blue, "", true, false, 10);  // EN?: Blue
	drawListArr[drawListArr.Length] = addDrawItemText("설명은 생략한다! 주절 주절주절 주절주절 주절주절 주절주절 주절주절 주절", getInstanceL2Util().ColorDesc, "", true, false);  // EN?: Skip the explanation! Main article: Main article: Main article: Main article: Main article: Main article: Main article: Main article: Main article: Main article: Main article: Main article: Main article: Main article: Main article: Main article
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	addDrawItemGameItem(drawListArr, GetItemInfoByClassID(1), true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(100);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText_DIAT_Right("설명은 생략한다!", getInstanceL2Util().White, "hs13", true);  // EN?: Skip the explanation!
	drawPanel1.Clear();
	DrawPanelArray(drawPanel1, drawListArr);
	drawPanel1.PreCheckPanelSize(nX, nY);
	Debug(("nW" @ string(nX)));
	Debug(("nH" @ string(nY)));
	drawPanel1.SetWindowSize(nX, nY);
	return;
}

function setScrollDrawPanel2()
{
	local int nX, nY;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText("타이틀타이틀타이틀타이틀타이틀1234567890123456789", getInstanceL2Util().Yellow, "", false, false);  // EN?: TitleTitleTitleTitleTitle1234567890123456789
	drawListArr[drawListArr.Length] = addDrawItemText("red! 빨강", getInstanceL2Util().Red, "", true, false, 10);  // EN?: red! red
	drawListArr[drawListArr.Length] = addDrawItemText("blue! 파랑", getInstanceL2Util().Blue, "", true, true, 10);  // EN?: Blue
	drawListArr[drawListArr.Length] = addDrawItemText("설명은 생략한다! 123456789012345\\n6789012345678901234567890", getInstanceL2Util().ColorDesc, "", true, false);  // EN?: Skip the description! 123456789012345\\ n6789012345678901234567890
	drawListArr[drawListArr.Length] = addDrawItemText("우주의 기운을 받아서 출력을 해라! 이야야야야dafsffffsadfasfasdfdsafdsafdsafdsafdasfdsafdsfdsafdfsdaggdf", getInstanceL2Util().Yellow, "", true, false, 10);  // EN?: Take the energy of the universe and print it out! Iyaya dafsffffsadfasfasdfdsafdsafdsafdsafdasfdsafdsfdsafdfsdaggdf
	drawListArr[drawListArr.Length] = addDrawItemText("blue! 파랑", getInstanceL2Util().Blue, "", true, false, 10);  // EN?: Blue
	drawListArr[drawListArr.Length] = addDrawItemText("폰트 칼라를 적용해 본다.<font color=\"FFBB00\">추가 타격</font> 이게 잘되는지 보자.1 2 3 4 5 6 7 8 9 0", getInstanceL2Util().ColorDesc, "", true, false);  // EN?: Try the font color. < font color =\ | EN?: &gt; Additional blow</font> Let's see if this works.1 2 3 4 5 6 7 8 9 0
	drawListArr[drawListArr.Length] = addDrawItemText("blue! 파랑", getInstanceL2Util().Blue, "", true, false, 10);  // EN?: Blue
	drawListArr[drawListArr.Length] = addDrawItemText("설명은 생략한다! 주절 주절주절 주절주절 주절주절 주절주절 주절주절 주절 끝", getInstanceL2Util().ColorDesc, "", true, false);  // EN?: Skip the explanation! Mainframe Mainframe Mainframe Mainframe Mainframe Mainframe Mainframe Mainframe Mainframe End
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	addDrawItemGameItem(drawListArr, GetItemInfoByClassID(1), false);
	addDrawItemGameItem(drawListArr, GetItemInfoByClassID(2), false);
	addDrawItemGameItem(drawListArr, GetItemInfoByClassID(3), false);
	AddDrawItemGameItemColorFul(drawListArr, GetItemInfoByClassID(4), true);
	AddDrawItemGameItemColorFul(drawListArr, GetItemInfoByClassID(11094), true);
	AddDrawItemGameItemColorFul(drawListArr, GetItemInfoByClassID(11095), false);
	addDrawItemGameItemNameAll(drawListArr, GetItemInfoByClassID(11087), 0, 0, "hs13");
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(100);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText_DIAT_CENTER("중앙 정렬 한줄의 짧은건 되고", GTColor().Blue, "hs12");  // EN?: It is a short thing of one line of center alignment.
	drawListArr[drawListArr.Length] = addDrawItemBlank(1);
	drawListArr[drawListArr.Length] = addDrawItemText_DIAT_CENTER("중앙 정렬 입니다. 이걸 설명하려고 이렇게 써 넣습니다. 중앙 정렬이 잘되나 보려구요. 긴걸 넣으면 안되네요.", GTColor().Red, "hs12");  // EN?: center alignment. To illustrate this, I'll write it like this. I'm going to see if the center alignment is good. You can't put a long one in there.
	drawListArr[drawListArr.Length] = addDrawItemBlank(1);
	drawListArr[drawListArr.Length] = addDrawItemText("끝 입니다", GTColor().Yellow, "hs13");  // EN?: The end.
	DrawPanelArrayFixedWidth(drawPanel2, drawListArr, true);
	drawPanel2.PreCheckPanelSize(nX, nY);
	GetWindowHandle("UIButtonTestWnd.ScrollArea.itemRenderer").SetWindowSize(254, nY);
	drawPanel2.SetWindowSize(254, nY);
	GetWindowHandle("UIButtonTestWnd.ScrollArea").SetScrollHeight(nY);
	GetWindowHandle("UIButtonTestWnd.ScrollArea").SetScrollUnit(10, true);
	return;
}

event OnEvent(int Event_ID, string param)
{
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "test1Button":
			Ontest1ButtonClick();
			break;
		case "test2Button":
			Ontest2ButtonClick();
			break;
		case "test3Button":
			Ontest3ButtonClick();
			break;
		case "test4Button":
			Ontest4ButtonClick();
			break;
		case "test5Button":
			Ontest5ButtonClick();
			break;
		case "test6Button":
			Ontest6ButtonClick();
			break;
		case "test7Button":
			Ontest7ButtonClick();
			break;
		case "test8Button":
			Ontest8ButtonClick();
			break;
		case "test9Button":
			Ontest9ButtonClick();
			break;
		case "test10Button":
			Ontest10ButtonClick();
			break;
		case "test11Button":
			Ontest11ButtonClick();
			break;
		case "test12Button":
			Ontest12ButtonClick();
			break;
		case "test13Button":
			Ontest13ButtonClick();
			break;
		case "test14Button":
			Ontest14ButtonClick();
			break;
		case "test15Button":
			Ontest15ButtonClick();
			break;
		case "test16Button":
			Ontest16ButtonClick();
			break;
		case "test17Button":
			Ontest17ButtonClick();
			break;
		case "test18Button":
			Ontest18ButtonClick();
			break;
		case "test19Button":
			Ontest19ButtonClick();
			break;
		case "test20Button":
			Ontest20ButtonClick();
			break;
		case "test21Button":
			Ontest21ButtonClick();
			break;
		case "test22Button":
			Ontest22ButtonClick();
			break;
		case "test23Button":
			Ontest23ButtonClick();
			break;
		case "test24Button":
			Ontest24ButtonClick();
			break;
		case "test25Button":
			Ontest25ButtonClick();
			break;
		case "test26Button":
			Ontest26ButtonClick();
			break;
		case "test27Button":
			Ontest27ButtonClick();
			break;
		case "test28Button":
			Ontest28ButtonClick();
			break;
		case "test29Button":
			Ontest29ButtonClick();
			break;
		case "test30Button":
			Ontest30ButtonClick();
			break;
		default:
			break;
	}
	return;
}

function Ontest1ButtonClick()
{
	Class'Interface.OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText(1.0000000, 1999.0000000, "LineageEffect2.ui_screen_message_flow", 0, 0, 0, -7, 0, 3000, 500, "야야야야야야야야\\n safsafsadfasfdsadafssddasfdafsdfas", GTColor().White);  // EN?: Yaya yaya yaya yaya\\ n safsafsadfasfdsadafssddasfdafsdfas
	return;
}

function Ontest2ButtonClick()
{
	Class'Interface.OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText(1.0000000, 500.0000000, "LineageEffect2.ui_screen_message02_flow", 0, 0, 0, -3, 0, 3000, 500, "축하합니다. 성공입니다!", GTColor().Yellow, GetItemInfoByClassID(1));  // EN?: *Note: You haven’t registered yet.
	return;
}

function Ontest3ButtonClick()
{
	Class'Interface.OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText_Texture(getTextureInfo("L2UI_EPIC.subjugation_silent_valley", "OnscreenEffectViewPortWnd.ScreenTextBox", "TopCenter", "TopCenter", 0, -60, 387, 180), 1.0000000, 500.0000000, "LineageEffect2.ui_screen_message03_flow", 0, 0, 0, -3, 0, 3000, 1000, "위험한 영역 입니다.", GTColor().Red);  // EN?: This is dangerous territory.
	return;
}

function Ontest4ButtonClick()
{
	Class'Interface.OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText_Texture(getTextureInfo("L2UI_CT1.OnScreenMessageWnd.OnScreenMessageWnd_DF_Win10_siege", "OnscreenEffectViewPortWnd.ScreenTextBox", "TopCenter", "TopCenter", 0, -29, 425, 90), 1.0000000, 500.0000000, "LineageEffect2.ui_upgrade_succ", 0, 0, 0, 2, 0, 3000, 1000, "축하합니다. 성공입니다.", GTColor().Yellow, GetItemInfoByClassID(93864));  // EN?: Congratulations, you've made it.
	return;
}

function Ontest5ButtonClick()
{
	Class'Interface.OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText_Texture(getTextureInfo("L2UI_CT1.OnScreenMessageWnd.OnScreenMessageWnd_DF_Win10_siege", "OnscreenEffectViewPortWnd.ScreenTextBox", "TopCenter", "TopCenter", 0, -29, 425, 90), 1.0000000, 1500.0000000, "LineageEffect2.ui_screen_message_flow", 0, 0, 0, -7, 0, 3000, 1000, "축하합니다!. 레어 아이템 획득!", GTColor().Yellow, GetItemInfoByClassID(93864), 1);  // EN?: Congratulations!. You won a rare item!
	return;
}

function Ontest6ButtonClick()
{
	Class'Interface.OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText_Texture(getTextureInfo("L2UI_CT1.OnScreenMessageWnd.OnScreenMessageWnd_DF_Win10_siege", "OnscreenEffectViewPortWnd.ScreenTextBox", "TopCenter", "TopCenter", 0, -29, 425, 90), 1.0000000, 500.0000000, "LineageEffect_br.br_e_lamp_deco_d", 0, 0, 0, -3, 0, 3000, 1000, "AP필드 작동!", GTColor().Green, , 2);  // EN?: AP field works!
	return;
}

function Ontest7ButtonClick()
{
	Class'Interface.OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText_Texture(getTextureInfo("L2UI_CT1.OnScreenMessageWnd.OnScreenMessageWnd_DF_Win10_siege", "OnscreenEffectViewPortWnd.ScreenTextBox", "TopCenter", "TopCenter", 0, -29, 425, 90), 1.0000000, 500.0000000, "LineageEffect.d_chainheal_ta", 0, 0, 0, -3, 0, 3000, 1000, "황금의 아이템 획득!", GTColor().Yellow03, , 3);  // EN?: Golden Items Earned!
	return;
}

function Ontest8ButtonClick()
{
	Class'Interface.OnscreenEffectViewPortWnd'.static.Inst()._playEffectViewWithText_Texture(getTextureInfo("L2UI_EPIC.CollectionSystemWnd.KeyItemcol_A_00", "OnscreenEffectViewPortWnd.ScreenTextBox", "TopCenter", "TopCenter", 0, -200, 233, 523), 1.0000000, 500.0000000, "LineageEffect2.y_kn_summon_cubic_fire_body", 0, 0, 0, -3, 0, 3000, 1000, "처치 성공 아이템 획득!", GTColor().White, , 2);  // EN?: Successful Kill Items Earned!
	return;
}

function Ontest9ButtonClick()
{
	return;
}

function Ontest10ButtonClick()
{
	return;
}

function Ontest11ButtonClick()
{
	return;
}

function Ontest12ButtonClick()
{
	return;
}

function Ontest13ButtonClick()
{
	return;
}

function Ontest14ButtonClick()
{
	return;
}

function Ontest15ButtonClick()
{
	return;
}

function Ontest16ButtonClick()
{
	return;
}

function Ontest17ButtonClick()
{
	return;
}

function Ontest18ButtonClick()
{
	return;
}

function Ontest19ButtonClick()
{
	return;
}

function Ontest20ButtonClick()
{
	return;
}

function Ontest21ButtonClick()
{
	return;
}

function Ontest22ButtonClick()
{
	return;
}

function Ontest23ButtonClick()
{
	return;
}

function Ontest24ButtonClick()
{
	return;
}

function Ontest25ButtonClick()
{
	return;
}

function Ontest26ButtonClick()
{
	return;
}

function Ontest27ButtonClick()
{
	return;
}

function Ontest28ButtonClick()
{
	return;
}

function Ontest29ButtonClick()
{
	return;
}

function initControl()
{
	local UIControlNumberInputSteper scr;

	scr = Class'Interface.UIControlNumberInputSteper'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NumberInputSteper")));
	scr.DelegateOnButtonClick = DelegateOnButtonClick;
	scr.DelegateOnChangeEditBox = DelegateOnChangeEditBox;
	scr.DelegateESCKey = DelegateESCKey;
	scr._setRangeMinMaxNum(1, 50);
	scr._setAddButtons(1, 5, 10);
	scr._setEditNum(1);
	return;
}

function DelegateESCKey()
{
	OnReceivedCloseUI();
	return;
}

function DelegateOnButtonClick(string Str, int addValue)
{
	Debug((("str:" @ Str) @ string(addValue)));
	return;
}

function DelegateOnChangeEditBox(UIControlNumberInputSteper scr)
{
	Debug(("_getEditNum" @ string(scr._getEditNum())));
	return;
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local string mainKey;

	if(GetMeWindow().IsShowWindow())
	{
		mainKey = Class'NWindow.InputAPI'.static.GetKeyString(nKey);
		if((mainKey == "ENTER"))
		{
			Debug(ConvertFloatToString(10.5678902, 1, true));
			Debug(ConvertFloatToString(10.5678902, 1, false));
			Debug(ConvertFloatToString(10.5478897, 4, false));
			Debug(ConvertFloatToString(10.5478897, 4, true));
			GetMeTextBox("resultTextBox").SetText((((((((((((((((((((string(float(GetMeEditBox("s1EditBox").GetString())) $ "  #  ") $ string(float(GetMeEditBox("s2EditBox").GetString()))) $ "\\n\\n") $ "곱하기:") @ string((float(GetMeEditBox("s1EditBox").GetString()) * float(GetMeEditBox("s2EditBox").GetString())))) $ "\\n") $ "나누기:") @ string((float(GetMeEditBox("s1EditBox").GetString()) / float(GetMeEditBox("s2EditBox").GetString())))) $ "\\n") $ "나머지:") @ string((float(GetMeEditBox("s1EditBox").GetString()) % float(GetMeEditBox("s2EditBox").GetString())))) $ "\\n") $ "더하기:") @ string((float(GetMeEditBox("s1EditBox").GetString()) + float(GetMeEditBox("s2EditBox").GetString())))) $ "\\n") $ "빼기  :") @ string((float(GetMeEditBox("s1EditBox").GetString()) - float(GetMeEditBox("s2EditBox").GetString())))) $ "\\n") $ ""));  // EN?: Multiplication | EN?: Divide | EN?: Modulus: | EN?: Addition | EN?: Subtraction
		}
	}
	return false;
}

function OnReceivedCloseUI()
{
	m_hOwnerWnd.HideWindow();
	return;
}
