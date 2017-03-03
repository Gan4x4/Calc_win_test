; Gan Calc test

;======================== Utils ===========================================
Func Assert($Result, $Message)
	if False == $Result Then
		MsgBox(0, "Test Failed", $Message)
	EndIf
EndFunc

Func AssertEq($Result, $Expect, $Message)
	if $Expect <> $Result Then
		MsgBox(0, "Test Failed", "Expected: " & $Expect & " get: " & $Result & " " & $Message)
	EndIf
EndFunc
;================First level adapters ==========================================
; interface interaction

Global Const $PLUS_KEY = "[CLASS:Button; INSTANCE:20]";
Global Const $MINUS_KEY = "[CLASS:Button; INSTANCE:19]";
Global Const $MULT_KEY = "[CLASS:Button; INSTANCE:18]";
Global Const $DIV_KEY = "[CLASS:Button; INSTANCE:17]";
Global Const $CLEAR_KEY = "[CLASS:Button; INSTANCE:24]";
Global Const $COMPUTE_KEY = "[CLASS:Button; INSTANCE:21]";
Global Const $RESULT_FIELD = "[CLASS:Edit; INSTANCE:1]";
Global $calcHwnd = 0;
;Global keys[] = [$PLUS_KEY,$MINUS_KEY,$MULT_KEY,$DIV_KEY]


Func calcEnterNumber($number)
	Send($number)
EndFunc


Func calcPressKey($Control)
	ControlClick($calcHwnd,"",$Control)
EndFunc


Func calcClear()
	calcPressKey($CLEAR_KEY)
EndFunc

Func calcGetResult()
	ControlClick($calcHwnd,"",$RESULT_FIELD)
	Send("^{INSERT}")
	return StringReplace(ClipGet(), ",", ".")
EndFunc

Func calcGetResultNoKeys()
	$allText= WinGetText($calcHwnd)
	;ConsoleWrite($allText)
	$lines =  StringSplit(StringReplace($allText,@CRLF,"&"),"&");
	;ConsoleWrite("FFF1 : " & $lines[0])
	;ConsoleWrite("FFF2 : " & $lines[1])

	return $lines[1];

EndFunc

;=================Second level adapters =======================================
;Bussines logic

Func calcAdd($a,$b)
	calcClear()
	calcEnterNumber($a)
	calcPressKey($PLUS_KEY)
	calcEnterNumber($b)
	calcPressKey($COMPUTE_KEY)
	Return calcGetResultNoKeys()
EndFunc

;================ Tests ==================================================
AutoItSetOption("SendKeyDelay", 50)

Run("calc.exe")
$calcHwnd = WinWaitActive("Калькулятор Плюс") ;

;$res = WinGetText($calcHwnd)
;$arr = StringSplit($res,"\n")
;ConsoleWrite($arr[0])
AssertEq(calcAdd(2,5),7,"Add test fail");

#cs
TestOperations()
#ce

MsgBox(0, "Test Finished", "Test is finished")
