/************************************************************************
 * function ......: Auto Execution (AE)
 * @description ..: A work in progress (WIP) of standard AE setup(s)
 * @file AE.v2.ahk
 * @author OvercastBTC
 * @date 2023.09.18
 * @version 1.0.0
 * @ahkversion v2+
 ***********************************************************************/
; --------------------------------------------------------------------------------
/************************************************************************
 * function ...........: Resource includes for .exe standalone
 * @author OvercastBTC
 * @date 2023.08.15
 * @version 3.0.2
 ***********************************************************************/
;@Ahk2Exe-IgnoreBegin
#Include <CheckUpdate\ScriptVersionMap>
version :=  ScriptVersion.ScriptVersionMap['main'] 
;@Ahk2Exe-IgnoreEnd
SetVersion := "3.0.0" ; If quoted literal not empty, do 'SetVersion'
;@Ahk2Exe-Nop
;@Ahk2Exe-Obey U_V, = "%A_PriorLine~U)^(.+")(.*)".*$~$2%" ? "SetVersion" : "Nop"
;@Ahk2Exe-%U_V% %A_PriorLine~U)^(.+")(.*)".*$~$2%
; --------------------------------------------------------------------------------
#Requires AutoHotkey v2+
#Warn All, OutputDebug
#SingleInstance Force
#WinActivateForce
; --------------------------------------------------------------------------------
#MaxThreads 255 ; Allows a maximum of 255 instead of default threads.
#MaxThreadsBuffer true
A_MaxHotkeysPerInterval := 1000
; --------------------------------------------------------------------------------
SendMode("Input")
SetWorkingDir(A_ScriptDir)
SetTitleMatchMode(2)
; --------------------------------------------------------------------------------
_AE_DetectHidden(true)
_AE_SetDelays(-1)
_AE_PerMonitor_DPIAwareness()

; --------------------------------------------------------------------------------
/**
 * Function: Includes
 */
#Include <App\Autohotkey>
#Include <Includes\Includes_Extensions>
#Include <Includes\Includes_DPI>
#Include <Tools\InternetSearch>
; #Include <Includes\Includes_Runner>
#Include <Tools\Info>
; ---------------------------------------------------------------------------
/**
 * Function ..: Create a shellhook to monitor for changes in Monitor DPI based on the Window location (hopefully).
 */
ShellHook(A_DPI_GetInfo)
; ---------------------------------------------------------------------------
toggleCapsLock(){
	SetCapsLockState(!GetKeyState('CapsLock', 'T'))
}
; ---------------------------------------------------------------------------
/**
 * function ...: Combine BlockInput() && SendLevel()
 * @example n 			 => default: n := 1
 * @example SendLevel()  => default: SendLevel(1)
 * @example BlockInput() => default: BlockInput(1) (1 = true)
 */
; ---------------------------------------------------------------------------
_AE_bInpt_sLvl(n := 1) => (SendLevel(n), BlockInput(n))
; _AE_bInpt_sLvl(n := 1) {
; 	SendLevel(n)
; 	BlockInput(n)
; }
; ---------------------------------------------------------------------------
_AE_DetectHidden(bool := true) {
	DetectHiddenText(bool)
	DetectHiddenWindows(bool)
}
; --------------------------------------------------------------------------------
_AE_SetDelays(n := -1) {
	SetControlDelay(n)
	SetMouseDelay(n)
	SetWinDelay(n)
}
; --------------------------------------------------------------------------------
_AE_PerMonitor_DPIAwareness() => AE._DPIAwareness()
; _AE_PerMonitor_DPIAwareness() {
; 	MaximumPerMonitorDpiAwarenessContext := VerCompare(A_OSVersion, ">=10.0.15063") ? -4 : -3
; 	Global 	DefaultDpiAwarenessContext := MaximumPerMonitorDpiAwarenessContext, 
; 			A_DPIAwareness := DefaultDpiAwarenessContext
; 	try {
; 		DllCall("SetThreadDpiAwarenessContext", "ptr", MaximumPerMonitorDpiAwarenessContext, "ptr")
; 	}
; 	catch{ 
; 		DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")
; 	}
; 	else {
; 		DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
; 	}
; 	return A_DPIAwareness
; }
__AE_CopyLib() {
	local Lib := A_MyDocuments '\AutoHotkey\Lib'
	If !(DirExist(Lib)) {
		DirCreate(Lib)
	}
	FileCopy(A_ScriptName, Lib A_ScriptName, 1)
}
; ---------------------------------------------------------------------------
; $^c:: clip_it() ; Clip hotkey
; $^b:: clip_it(1) ; Paste last clip hotkey
clip_sleep(n:=50){
	; ---------------------------------------------------------------------------
	; @step If clipboard still in use (long paste), sleep for a bit
	; @param n ...: default value = 50 ms
	; ---------------------------------------------------------------------------
	While !DllCall('GetOpenClipboardWindow') {
		Sleep(n)
	}
}
_AE_BU_Clr_Clip(){
	; ---------------------------------------------------------------------------
	; @i ...: Backup current clipboard
	; ---------------------------------------------------------------------------
	cBak := ClipboardAll()
	; ---------------------------------------------------------------------------
	; @i ...: Clear current clipboard
	; ---------------------------------------------------------------------------
	Static i_max := 5
	i := 0
	Loop i_max {
		A_Clipboard := ''
		i++
		Sleep(50)
	} Until (A_Clipboard == '')
	i := 0
	Loop i_max {
		Sleep(50)
	} Until !DllCall("GetOpenClipboardWindow", 'ptr')
	return cBak
}
; _AE_RestoreClip(cBak, delay := 50){
; 	; Sleep(500)
; 	Sleep(delay * 20) ;? 1 second
; 	_AE_bInpt_sLvl(0)
; 	A_Clipboard := cBak
; }
_AE_RestoreClip(cBak, delay := 50){
	Static i_max := 5
	i := 0
	Loop i_max {
		A_Clipboard := cBak
		i++
		Sleep(50)
	} Until (A_Clipboard == cBak)
	i := 0
	Loop i_max {
		Sleep(50)
	} Until DllCall("GetOpenClipboardWindow", 'ptr')
	_AE_bInpt_sLvl(0)
}
SClip(t){
	Static i_max := 2
	i := 0
	Loop i_max {
		A_Clipboard := t
		i++
		Sleep(50)
	} Until (A_Clipboard == t)
	i := 0
	Loop i_max {
		Sleep(50)
	} Until DllCall("GetOpenClipboardWindow", 'ptr')
	Send('^{sc2F}')
}
clip_it(send_clip := 0) {
	Static last_clip := "" ; Track last clipboard
	If send_clip ; If send_clip is true
	{
		bak := ClipboardAll() ; Backup current clipboard
		A_Clipboard := last_clip ; Put last_clip onto clipboard
		Send('^v') ; Paste
		clip_sleep()
		A_Clipboard := bak ; Restore original clipboard
	}
	Else ; Else if send_clip false
	{
		last_clip := A_Clipboard ; Update last_clip with current clipboard
		clip_sleep()
		Send('^c') ; And then copy new contents to active clipboard
	}
}

AE_SelectAll(hCtl := ControlGetFocus('A'),*) {
	Static Msg := EM_SETSEL := 177, wParam := 0, lParam := -1
	return DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
}
AE_Select_End(*) {
	Static Msg := EM_SETSEL := 177, wParam := -1, lParam := -1
	hCtl := ControlGetFocus('A')
	DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg, 'UInt', wParam, 'UInt', lParam)
	; return
}
AE_Select_Beginning(*) {
	Static Msg := EM_SETSEL := 177, wParam := 0, lParam := 0
	hCtl := ControlGetFocus('A')
	DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg, 'UInt', wParam, 'UInt', lParam)
	; return
}
AE_GetScrollPos() { ; Obtains the current scroll position
	; Returns on object with keys 'X' and 'Y' containing the scroll position.
	; EM_GETSCROLLPOS = 0x04DD
	PT := Buffer(8, 0)
	SendMessage(0x04DD, 0, PT.Ptr, ControlGetFocus('A'))
	Return {X: NumGet(PT, 0, "Int"), Y: NumGet(PT, 4, "Int")}
}
; ------------------------------------------------------------------------------------------------------------------
AE_SetScrollPos(X, Y) { ; Scrolls the contents of a rich edit control to the specified point
	; X : x-position to scroll to.
	; Y : y-position to scroll to.
	; EM_SETSCROLLPOS = 0x04DE
	PT := Buffer(8, 0)
	NumPut("Int", X, "Int", Y, PT)
	Return SendMessage(0x04DE, 0, PT.Ptr, ControlGetFocus('A'))
}
; --------------------------------------------------------------------------------
AE_ScrollCaret() { ; Scrolls the caret into view
	EM_SCROLLCARET := 0x00B7
	SendMessage(EM_SCROLLCARET, 0, 0, ControlGetFocus('A'))
	Return True
}
AE_MoveCaret() { ; Scrolls the caret into view
	EM_LINESCROLL := 0x00B6
	SendMessage(EM_LINESCROLL, 0, 1, ControlGetFocus('A'))
	Return True
}

; ---------------------------------------------------------------------------
; @function Set_Sel() ...: Set, or highlight, the text to be selected
; @params ...: wParam := 0, lParam := 0, fCtl := 0, hWnd := tryHwnd()
; @params ...: wParam = Starting Char, lParam = Ending Char
; ---------------------------------------------------------------------------
AE_Set_Sel(wParam := 0, lParam := 0, fCtl := 0, hWnd := 0) {
	Static Msg := EM_SETSEL := 177
	; if (hWnd = 0) {
	; 	hWnd := tryHwnd()
	; }
	; if fCtl {
	; 	DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
	; }
	; if !fCtl {
	; 	; DllCall('SendMessage', 'UInt', hWnd, 'UInt', Msg, 'UInt', Start, 'UInt', End)
	; 	DllCall('SendMessage', 'UInt', hWnd, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
	; 	; SendMessage(Msg, wParam, lParam,, hWnd)
	; }
	; return SendMessage(Msg, wParam, lParam, fCtl, 'A')
	return DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', wParam, 'UInt', lParam)
}
AE_Get_TEXTLIMIT(*) {
	Static Msg := WM_GETTEXT := 0x000D
	afont := []
	buff_size := 64000
	wParam := &buff_size, lParam := &buff
	VarSetStrCapacity(&buff, buff_size)
	; Static Msg := EM_GETLIMITTEXT := 1061, wParam := 0, lParam := 0
	; Static Msg := EM_GETTEXTLENGTH := 0x000E, wParam := 0, lParam := 0
	; Static Msg := WM_GETFONT := 0x0031, wParam := 0, lParam := 0
	; text := StrPtr('hznRTE ')
	; Static Msg := WM_SETTEXT := 0x000C, wParam := 0, lParam := text
	try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl))
	hWnd := tryHwnd()
	hCtl := ControlGetFocus('A')
	; Limit := DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg, 'UInt', wParam, 'UInt', lParam)
	; Limit := SendMessage(Msg,wParam, lParam, hCtl, hCtl)
	Text := SendMessage(Msg,wParam, lParam, hCtl, hCtl)
	afont := GuiCtrlTextSize(hCtl,text)
	for each, value in afont {
		font := ''
		font .= value . '`n'
	}
	Infos(font)
	GuiCtrlTextSize(GuiCtrlObj, Text)
	{
		Static WM_GETFONT := 0x0031, DT_CALCRECT := 0x400
		hDC := DllCall('GetDC', 'Ptr', GuiCtrlObj.Hwnd, 'Ptr')
		hPrevObj := DllCall('SelectObject', 'Ptr', hDC, 'Ptr', SendMessage(WM_GETFONT, , , GuiCtrlObj), 'Ptr')
		height := DllCall('DrawText', 'Ptr', hDC, 'Str', Text, 'Int', -1, 'Ptr', buf := Buffer(16), 'UInt', DT_CALCRECT)
		width := NumGet(buf, 8, 'Int') - NumGet(buf, 'Int')
		DllCall('SelectObject', 'Ptr', hDC, 'Ptr', hPrevObj, 'Ptr')
		DllCall('ReleaseDC', 'Ptr', GuiCtrlObj.Hwnd, 'Ptr', hDC)
		Return { Width: Round(width * 96 / A_ScreenDPI), Height: Round(height * 96 / A_ScreenDPI) }
	}
	; Return Limit
}
; ---------------------------------------------------------------------------
; @function GetSelText() ...: Retrieves the currently selected text as plain text
; @i ...: Returns selected text.
; ---------------------------------------------------------------------------
AE_GetSelText(fCtl := 0, hWnd := tryHwnd()) { 
	static EM_GETSELTEXT := 0x043E, EM_EXGETSEL := 0x0434
	Txt := ''
	Try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl))
	CR := AE_GetSel()
	TxtL := CR.E - CR.S + 1
	If (TxtL > 1) {
		VarSetStrCapacity(&Txt, TxtL)
		if (fCtl = 0) {
			SendMessage(EM_GETSELTEXT, 0, StrPtr(Txt), hWnd, hWnd)
			; SendMessage(0x043E, 0, StrPtr(Txt), , hWnd)
		} else {
			SendMessage(EM_GETSELTEXT, 0, StrPtr(Txt), fCtl, hWnd)
		}
		VarSetStrCapacity(&Txt, -1)
	}
	Return Txt
}
; ---------------------------------------------------------------------------
; @function GetSel() ...: Retrieves the starting and ending character positions of the selection in a rich edit control
; ---------------------------------------------------------------------------
AE_GetSel(fCtl := ControlGetFocus('A'), hWnd := tryHwnd()) { 
	; Returns an object containing the keys S (start of selection) and E (end of selection)).
	Static Msg := EM_GETSEL := 176
	wParam := 0, lParam := 0
	try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl))
	wParam := Buffer(8, 0) ; LOWORD => start
	lParam := Buffer(8, 0) ; HIWORD => end
	; CR := Buffer(8, 0) ; LOWORD => start
	; CE := Buffer(8, 0) ; HIWORD => end
	
	;! ---------------------------------------------------------------------------
	; @i ... Working Calls
	; ---------------------------------------------------------------------------
	; DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', wParam.Ptr, 'UInt', 0)
	; DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', 0, 'UInt', lParam.Ptr)
	; ---------------------------------------------------------------------------
	DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', wParam.Ptr, 'UInt', lParam.Ptr)
	; DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'ptr', wParam.Ptr, 'ptr', lParam.Ptr) ;? (AJB - 2024.01.19) this also works
	; ---------------------------------------------------------------------------
	; SendMessage(Msg, wParam.Ptr, lParam.Ptr, fCtl)
	;! ---------------------------------------------------------------------------
	Return {S: NumGet(wParam,0,'uint'), E: NumGet(lParam,0, 'uint')}
	; Return {S: NumGet(CR, 0, "Int"), E: NumGet(CE, 0, "Int")}
}
; --------------------------------------------------------------------------------
; @function GetText() ...: Gets the whole content of the control as plain text
; --------------------------------------------------------------------------------
AE_GetText(fCtl := 0, hWnd := tryHwnd()) {  
	; EM_GETTEXTEX = 0x045E
	Txt := '', TxtL := 0
	try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl))
	; GETTEXTEX structure
	GTX := Buffer(12 + (A_PtrSize * 2), 0) 
	NumPut("UInt", TxtL * 2, GTX) ; cb
	NumPut("UInt", 1200, GTX, 8)  ; codepage = Unicode
	If (TxtL := AE_GetTextLen() + 1) {
		; If (TxtL := AE_GetTextLen(fCtl, hWnd) + 1) {
		VarSetStrCapacity(&Txt, TxtL)
		if (fCtl = 0) {
			SendMessage(0x045E, GTX.Ptr, StrPtr(Txt), hWnd, hWnd)
			; SendMessage(0x045E, GTX.Ptr, StrPtr(Txt), , hWnd)
		} else {
			SendMessage(0x045E, GTX.Ptr, StrPtr(Txt), fCtl, hWnd)
		}
		VarSetStrCapacity(&Txt, -1)
	}
	Return Txt
}
; ---------------------------------------------------------------------------
; @function GetTextLen() ...: Calculates text length in various ways
; ---------------------------------------------------------------------------
AE_GetTextLen(fCtl := 0, hWnd := tryHwnd()) { 
	static EM_GETTEXTLENGTHEX := 0x045F
	try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl))
	; ---------------------------------------------------------------------------
	; @GETTEXTLENGTHEX GETTEXTLENGTHEX Structure
	; ---------------------------------------------------------------------------
	GTL := Buffer(8, 0)
	; codepage = Unicode
	NumPut("UInt", 1200, GTL.Ptr, 4)  
	if (fCtl = 0) {
		txtL := SendMessage(EM_GETTEXTLENGTHEX, GTL.Ptr, 0, hWnd,hWnd)
		; SendMessage(EM_GETTEXTLENGTHEX, GTL.Ptr, 0, ,hWnd)
	} else (
		txtL := SendMessage(EM_GETTEXTLENGTHEX, GTL.Ptr, 0, fCtl,hWnd)
	)
	Return txtL
}
; ---------------------------------------------------------------------------
; @GETTEXTLENGTHEX GETTEXTLENGTHEX Structure
; ---------------------------------------------------------------------------
struct_GTL(fCtl := 0, hWnd := tryHwnd()) => struct_GETTEXTLENGTHEX(fCtl := 0, hWnd := tryHwnd())
struct_GETTEXTLENGTHEX(fCtl := 0, hWnd := tryHwnd()) {
	; codepage = Unicode
	GTL := Buffer(8, 0)
	return NumPut("UInt", 1200, GTL.Ptr, 4)  
}
; ---------------------------------------------------------------------------
; @function ReplaceSel() ...: Replaces the selected text with the specified text
; ---------------------------------------------------------------------------
_AE_ReplaceSel(Text := "") { ; Replaces the selected text with the specified text
	Msg := EM_REPLACESEL := 0x00C2
	; WM_SETTEXT := 0x000C
	Return SendMessage(Msg, 1, StrPtr(Text), ControlGetFocus('A'))
}
EM_REPLACESEL := 0x00C2
AE_ReplaceSel(Text := "", fCtl := 0, hWnd := tryHwnd()) { 
	static EM_REPLACESEL := 194 ; 0xC2
	; try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl))
	; If (fCtl = 0) {
	; 	try text := SendMessage(EM_REPLACESEL, 1, StrPtr(Text), fCtl, hWnd)
	; }else if (text = '') {
	; 	try text := SendMessage(EM_REPLACESEL, 1, StrPtr(Text), , hWnd)
	; } else {
	; 	; SndMsgPaste()
	; }
	; Return SendMessage(EM_REPLACESEL, 1, StrPtr(Text), fCtl, hWnd)
	Return SendMessage(EM_REPLACESEL, 1, StrPtr(Text), fCtl)
	; Return text
}
; ---------------------------------------------------------------------------
tryHwnd() {
	hWnd := ''
	try hWnd := ControlGetFocus('A')
	if !hWnd {
		try hWnd := WinActive('A')
	}
	if !hWnd {
		try hWnd := WinGetID('A')
	}
	return hWnd
}
; --------------------------------------------------------------------------------
; Line handling
; --------------------------------------------------------------------------------
; @function GetCaretLine() ...: Get the line containing the caret
; ---------------------------------------------------------------------------
AE_GetCaretLine(line := -1, fCtl := ControlGetFocus('A'), hWnd := tryHwnd()) {
	static EM_LINEINDEX := 187, EM_EXLINEFROMCHAR := 1078, EM_LINEFROMCHAR:= 201
	CL := 0
	; try ClassNN := ControlGetClassNN(fCtl)
	; If (fCtl = 0) {
		;! original Result := (SendMessage(EM_LINEINDEX, -1, 0, ,hWnd)-1) ;? starting character number
		;! original CL :=     (SendMessage(EM_LINEFROMCHAR, line, 0,     , hWnd) + 1)
		Result := (SendMessage(EM_LINEINDEX,    line, 0, hWnd, hWnd)) ;? starting character number
		CL :=     (SendMessage(EM_LINEFROMCHAR, line, 0, hWnd, hWnd) + 1)
		; Result := (SendMessage(EM_LINEINDEX,    line, 0, , hWnd) - 1) ;? starting character number
		; CL :=     (SendMessage(EM_LINEFROMCHAR, line, 0, , hWnd) + 1)
	; } else {
		Result := (SendMessage(EM_LINEINDEX,    line, 0, fCtl, hWnd)) ;? starting character number
		CL := 	  (SendMessage(EM_LINEFROMCHAR, line, 0, fCtl, hWnd) + 1)
	; }
	; Result := SendMessage(EM_LINEINDEX, line, 0, ClassNN,hWnd)
	; CL := (SendMessage(EM_EXLINEFROMCHAR,0, 100, ClassNN, hWnd) + 1)
	Return CL
	; Result := SendMessage(EM_LINEINDEX, line, 0, fCtl)
	; Return SendMessage(EM_LINEFROMCHAR, 0, Result, fCtl) + 1
}
; --------------------------------------------------------------------------------
; Get the total number of lines
; ---------------------------------------------------------------------------
AE_GetLineCount(fCtl := ControlGetFocus('A'), hWnd := tryHwnd()) {
	static EM_GETLINECOUNT := 186
	LC := 0
	; LC := SendMessage(EM_GETLINECOUNT,,,,'ahk_id ' hWnd)
	try ClassNN := ControlGetClassNN(fCtl)
	If (fCtl = 0) {
		; LC := SendMessage(0xBA,,,hWnd,hwnd)
		LC := SendMessage(0xBA,,,,hwnd)
	} else {
		LC := SendMessage(0xBA,,,fCtl,hwnd)
	}
	; Infos('LC: ' LC)
	Return LC 
}
Edit_GetLineCount(hEdit, hWnd){
    Static EM_GETLINECOUNT:=0xBA
    Return SendMessage(EM_GETLINECOUNT,0,0,hEdit, hWnd)
}
; --------------------------------------------------------------------------------
; Get the index of the first character of the specified line.
; ---------------------------------------------------------------------------
AE_GetLineIndex(LineNumber := -1, fCtl := 0, hWnd := tryHwnd()) { 
	Static EM_LINEINDEX := 187 ;, LI := 0
	; LineNumber   -  zero-based line number
	; if !fCtl => ControlGetFocus('A')
	LI := SendMessage(EM_LINEINDEX, LineNumber, , fCtl, hWnd)
	Return LI 
}
AE_GetLinePos(fCtl:=0){
	LI := AE_GetLineIndex(, fCtl)
	LP 	 := Buffer(A_PtrSize, 0)
	LinePos := (NumGet(LP, "Ptr") - (LI + 1))
}
; --------------------------------------------------------------------------------
; Statistics
; Get some statistic values
; Get the line containing the caret, it's position in this line, the total amount of lines, the absulute caret
; position and the total amount of characters.
; EM_GETSEL = 0xB0, EM_LINEFROMCHAR = 0xC9, EM_LINEINDEX = 0xBB, EM_GETLINECOUNT = 0xBA
; --------------------------------------------------------------------------------
AE_GetStats(fCtl := ControlGetFocus('A'), hWnd := tryHwnd()) {
	static EM_LINEINDEX := 187, EM_EXLINEFROMCHAR := 1078
	static EM_GETSEL := 176, EM_LINEFROMCHAR:= 201, EM_GETLINE := 196
	; fCtl := 0
	SB := 0, LI := 0
	LinePos := 0,Line := 0,LineCount := 0,CharCount := 0, 
	CurrentCol :=  Result := Result1 := LinePos1 := num_of_chars := GetCaretLine := LI1 := LineCount1 := MaxLinePos := L := 0, 
	sel := '', getline := 0, selected := '', ClassNN := ''
	getsel := [], getsel1 := [], ctrls := [], ctrl := []
	; Stats := {}
	; Stats := [LinePos,Line,LineCount,CharCount]
	Stats := []
	SB 	 := Buffer(A_PtrSize, 0)
	SBgl := Buffer(A_PtrSize, 0)
	; try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl)) ;, Infos(ClassNN)
	(fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl)) ;, Infos(ClassNN)
	; If ClassNN = 0 {
	; 	ClassNN := unset
	; }
	; egcl := EditGetLineCount(ClassNN)
	try getSel := AE_GetSel(fCtl, hWnd)
	try Selected := EditGetSelectedText(fCtl, hWnd)
	try MaxLinePos := SendMessage(EM_GETSEL, SB.Ptr, 0,fCtl,hWnd) ;? total characters in edit control
	try LineCount := EditGetLineCount(fCtl,'A')
	try LineCount1 := AE_GetLineCount(fCtl, hWnd)
	;try  LineCount1 := Edit_GetLineCount(fCtl, hWnd)
	; try  getline := SendMessage(EM_GETLINE,1, SBgl.Ptr, fCtl, hWnd)
	try  getline := SendMessage(EM_GETLINE,1, SBgl.Ptr, fCtl)
	try Line := (SendMessage(EM_LINEFROMCHAR, -1, 0, fCtl,hWnd) + 1)
		
	try GetCaretLine := AE_GetCaretLine(-1,fCtl, hWnd)
	try CurrentCol := EditGetCurrentCol(fCtl, hWnd)
	; ---------------------------------------------------------------------------
	; @grouped -1 = current line => @param ...: this_line := -1
	; ---------------------------------------------------------------------------
	this_line := -1
	try Result := (SendMessage(EM_LINEINDEX, this_line, 0, fCtl,hWnd)) ;? starting character number
	try LI := AE_GetLineIndex(this_line, fCtl, hWnd) ;
	try LinePos := (NumGet(SB, "Ptr") - (LI + 1))
	; ---------------------------------------------------------------------------
	; @group 1 => +1 line to try and get the difference between the two
	; ---------------------------------------------------------------------------
	try n_line := 1
	try Result1 := (SendMessage(EM_LINEINDEX, this_line, 0, fCtl,hWnd)) ;? starting character number
	try LI1 := AE_GetLineIndex(this_line, fCtl, hWnd) ;
	try LinePos1 := (NumGet(SB, "Ptr") - (LI + 1))
	; num_of_chars := LI1 - LI
	try num_of_chars := SendMessage(WM_GETTEXTLENGTH := 0x000E, 0, 0, fCtl, hWnd)
	; LI = 0 ? LinePos++ : false
	; ---------------------------------------------------------------------------
	try CharCount := AE_GetTextLen(fCtl, hWnd)
	
	Try {
		start := 0, end := 0
		Infos(
			; 'fCtl: ' fCtl
			; '`n'
			; 'ClassNN: ' ClassNN
			; '`n'
			'getsel.s (start): ' getsel.S '`n' 
			'getsel.e   (end): ' getsel.E '`n' 
			'Total Chars: ' MaxLinePos '`n' 
			'LineCount: ' LineCount '`n' 
			'LineCount1: ' LineCount1 '`n' 
			'getline: ' getline '`n'
			'Line: ' Line '`n'
			; '`n'
			'-----------------------------------`n'
			'Selected: "' Selected '"`n'
			'Chars: ' Selected.Length '`n'
			'Spaces: ' RegExMatch(Selected.Length, '[ ]+$') '`n'
			'-----------------------------------`n'
			'CurrentCol: ' CurrentCol '`n'
			'-----------------------------------`n'
			'Result: ' Result '`n'
			'LineIndex (charpos @ BOL): ' LI '`n'
			'LinePos(chars in line = LinePos+1): ' LinePos '`n'
			'-----------------------------------`n'
			'Result1: ' Result1 '`n'
			'LineIndex1 (charpos @ BOL): ' LI1 '`n'
			'LinePos1(chars in line = LinePos+1): ' LinePos1 '`n'
			'-----------------------------------`n'
			'num_of_chars: ' num_of_chars '`n'
			'-----------------------------------`n'
			'GetCaretLine: ' GetCaretLine '`n'
			'CharCount: ' CharCount
		; )
		, 3000)
	}
	selS := getsel.S
	selE := getsel.E
	selL := Selected.Length
	sel  := Selected
	; Stats.SafePush(getsel.S)
	; Stats.SafePush(getsel.E)
	Stats.SafePush('LinePos: ' LinePos)
	Stats.SafePush('Line: ' Line)
	Stats.SafePush('LineCount: ' LineCount)
	Stats.SafePush('CharCount: ' CharCount)
	Return Stats := {
		LinePos:LinePos,
		selS:selS,
		selE:selE,
		selL:selL,
		sel:sel

	}
}
; ---------------------------------------------------------------------------
; Hides or shows the selection ;! still doesn't work
; ---------------------------------------------------------------------------
; AE_HideSelection(Mode, ClassNN := ControlGetClassNN(ControlGetFocus('A')), hWnd := tryHwnd()) { 
; 	; Mode : True to hide or False to show the selection.
; 	EM_HIDESELECTION := 0x043F ; (WM_USER + 63)
; 	; SendMessage(EM_HIDESELECTION, !!Mode, 0, hWnd)
; 	SendMessage(EM_HIDESELECTION, !!Mode, 0, ClassNN, hWnd)
; 	Return True
; }
AE_HideSelection(Mode := true, fCtl := 0, hWnd := tryHwnd()) { 
	; Mode : True to hide or False to show the selection.
	EM_HIDESELECTION := 0x043F ; (WM_USER + 63)
	try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl)) ;, Infos(ClassNN)
	If (fCtl = 0) {
		Return SendMessage(EM_HIDESELECTION, Mode, 0, hWnd, hWnd)
		; Return SendMessage(EM_HIDESELECTION, Mode, 0, , hWnd)
	} else {
		Return SendMessage(EM_HIDESELECTION, Mode, 0, fCtl, hWnd)
	}
	; SendMessage(EM_HIDESELECTION, !!Mode, 0, hWnd)
	; SendMessage(EM_HIDESELECTION, !!Mode, 0, ClassNN, hWnd)
	; SendMessage(EM_HIDESELECTION, Mode, 0, ClassNN, hWnd)
	; Return True
	
}
Class AE {
	; --------------------------------------------------------------------------------
	static _AE_DetectHidden(bool := true){
		DetectHiddenText(bool)
		DetectHiddenWindows(bool)
	}
	static _DetectHidden(bool := true){
		DetectHiddenText(bool)
		DetectHiddenWindows(bool)
	}
	; --------------------------------------------------------------------------------
	static _AE_SetDelays(n := -1) {
		SetControlDelay(n)
		SetMouseDelay(n)
		SetWinDelay(n)
	}
	static _SetDelays(n := -1) {
		SetControlDelay(n)
		SetMouseDelay(n)
		SetWinDelay(n)
	}
	; --------------------------------------------------------------------------------
	static _AE_PerMonitor_DPIAwareness() {
		global A_DPIAwareness
		MaximumPerMonitorDpiAwarenessContext := VerCompare(A_OSVersion, ">=10.0.15063") ? -4 : -3
		Global DefaultDpiAwarenessContext := MaximumPerMonitorDpiAwarenessContext, A_DPIAwareness := DefaultDpiAwarenessContext
		try {
			DllCall("SetThreadDpiAwarenessContext", "ptr", MaximumPerMonitorDpiAwarenessContext, "ptr")
		} catch {
			DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")
		} else{
			DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
		}
		return A_DPIAwareness
	}
	static _DPIAwareness() {
		global A_DPIAwareness
		A_DPIAwareness := DPI().WinGetDpi('A')
		; tooltip(A_DPIAwareness)
		return A_DPIAwareness
	}
}

; --------------------------------------------------------------------------------
;              Ctrl+s Reload AutoHotKey Scripts (to test/load changes)
; --------------------------------------------------------------------------------
#HotIf WinActive(" - Visual Studio Code")
	; ~^s::ReloadAllAhkScripts()
	~^s::Reload()
#HotIf
; --------------------------------------------------------------------------------
/**
 * function ...: Reload AutoHotKey Script (to load changes)
 * @example Ctrl+Shift+Alt+r
 * Note: I think the 654*** is for v2 => avoid the 653***'s
	[x] Reload:		65400
	[x] Help: 		65411 ; 65401 doesn't really work or do anything that I can tell
	[x] Spy: 			65402
	[x] Pause: 		65403
	[x] Suspend: 		65404
	[x] Exit: 		65405
	[x] Variables:	65406
	[x] Lines Exec:	65407 & 65410
	[x] HotKeys:		65408
	[x] Key History:	65409
	[x] AHK Website:	65412 ; Opens https://www.autohotkey.com/ in default browser; and 65413
	[x] Save?:		65414
	! Don't use these => static a := { Open: 65300, Help:    65301, Spy: 65302, XXX (nonononono) Reload: 65303 [bad reload like Reload()], Edit: 65304, Suspend: 65305, Pause: 65306, Exit:   65307 }
	scripts .=  (scripts ? "`r`n" : "") . RegExReplace(title, " - AutoHotkey v[\.0-9]+$")
 * @example
	Refactored:
		- Changed DetectHiddenWindows(true) to AE._DetectHidden(true)
		- Declared vars: oList := [], aList := [], i := '', v := '', scripts := "", excludeTitle := '', excludeText := ''
		- Added a RegExMatch => via ~= => to see if the Title or Text exists
 *	//; TODO Change exList's to Arrays, and create for-loops
 */
; --------------------------------------------------------------------------------
^+!r::ReloadAllAhkScripts()
; ^+!r::ReloadList()
ReloadAllAhkScripts() {
	AE._DetectHidden(true)
	aList := [], title := '', WinTitle := '', scripts := ''
	aList := ReloadList()
	Infos(_ArrayToString(aList, ',`n'))
	static  WM_COMMAND := 273, ; 0x111 or 0x00000111
			; menucmdid := cmdidOLEObjectMenuButton := 65400,
			menucmdid := cmdidOLEObjectMenuButton := 65303,
			Msg := WM_COMMAND, wParam := menucmdid, lParam := 0
	; Loop aList.Length {
	for each, WinTitle in aList {
			; WinTitle := 'ahk_id ' aList[A_Index]
		WinTitle := 'ahk_id ' WinTitle
		title := WinGetTitle(WinTitle)
			; PostMessage(WM_COMMAND,65400,0,,"ahk_id " aList[A_Index])
			; PostMessage(Msg,wParam,lParam,,title)
			; SendMessage(Msg,wParam,lParam,,title)
		Run(title)
		WinKill(title)
		; Exit()
		scripts .=  (scripts ? "`r`n" : "") . RegExReplace(title, " - AutoHotkey v[\.0-9]+$")
	}
		Infos(scripts)
}
ReloadList() {
	AE._DetectHidden(true)
	static oList := [], aList := [], exListTitleArr := [], exclTitleArr := [], exListTextArr := [], exclTextArr := [], sList := [], noList := []
	static  i := '', v := '', scripts := '', excludeTitle := '', excludeText := '',
			aTitleExcl := '', aTextExcl := '', WinT := '', WinE := 0
	static  WM_COMMAND := 273, ; 0x111 or 0x00000111
			menucmdid := cmdidOLEObjectMenuButton := 65400
	static exListTitleArr := ['RichEdit'], exListTextArr := ['Horizon']
	for each, aTitleExcl in exListTitleArr {
		try {
			WinE := WinExist(aTitleExcl)
			WinT := WinGetTitle(WinE)
		}
		try {
			if WinT ~= aTitleExcl {
				excludeTitle := WinT
				noList.SafePush(excludeTitle)
			}
		}
	}
	static oList := WinGetList("ahk_class AutoHotkey",,excludeTitle)
	List := oList.Length
	for i, v in oList {
		aList.SafePush(v)
	}
	for each, WinTitle in aList {
		; WinTitle := 'ahk_id ' aList[A_Index]
	WinTitle := 'ahk_id ' WinTitle
	title := WinGetTitle(WinTitle)
	sList.SafePush(title)
}
	; Loop aList.Length {
	; 	local WinTitle := 'ahk_id ' aList[A_Index]
	; 	title := WinGetTitle(WinTitle)
	; 	sList.SafePush(title)
	; }
	return aList
}
; ---------------------------------------------------------------------------
ShellHook(callback := '') {
	; HSHELL_RUDEAPPACTIVATED := 32772
	; hWnd := WinActive('A')
	rVal := ''
	hWnd := ControlGetFocus('A')
	DllCall("RegisterShellHookWindow", "UInt", A_ScriptHwnd)
	OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), rval := callback)
	; OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), MyFunc)
	return rVal
}
; ---------------------------------------------------------------------------
A_DPI_GetInfo(event := HSHELL_WINDOWCREATED := 1, hWnd := WinActive('A'),info*) {
	CoordMode('ToolTip', 'Client')
	_AE_DetectHidden()
	_AE_bInpt_sLvl()
	; --------------------------------------------------------------------------------
	; hook := SetWinEventHook(HandleWinEvent)
	; --------------------------------------------------------------------------------
	static HSHELL_WINDOWCREATED := 1, HSHELL_WINDOWDESTROYED := 2, HSHELL_ACTIVATESHELLWINDOW := 3, HSHELL_WINDOWACTIVATED := 4, HSHELL_WINDOWACTIVATED := 32772, HSHELL_GETMINRECT := 5, HSHELL_REDRAW := 6, HSHELL_TASKMAN := 7, HSHELL_LANGUAGE := 8, HSHELL_SYSMENU := 9, HSHELL_ENDTASK := 10, HSHELL_ACCESSIBILITYSTATE := 11, HSHELL_APPCOMMAND := 12, HSHELL_WINDOWREPLACED := 13, HSHELL_WINDOWREPLACING := 14, HSHELL_HIGHBIT := 32768, HSHELL_RUDEAPPACTIVATED := 32772, HSHELL_FLASH := 32774
	; ---------------------------------------------------------------------------
	static hznHwnd := 0, match := '', A_Process := '', A_DPI := 0, mName := '', name := ''
	matches := [], ProcessInfo := []
	processInfoMap := Map()
	; ---------------------------------------------------------------------------
	nEvent := (event = 1) ? 'HSHELL_WINDOWCREATED' : (event = 2) ? 'HSHELL_WINDOWDESTROYED' : (event = 3) ? 'HSHELL_ACTIVATESHELLWINDOW' : (event = 4) ? 'HSHELL_WINDOWACTIVATED' : (event = 32772) ? 'HSHELL_RUDEAPPACTIVATED' : (event = 5) ? 'HSHELL_GETMINRECT' : (event = 6) ? 'HSHELL_REDRAW' : (event = 7) ? 'HSHELL_TASKMAN' : (event = 8) ? 'HSHELL_LANGUAGE' : (event = 9) ? 'HSHELL_SYSMENU' : (event = 10) ? 'HSHELL_ENDTASK' : (event = 11) ? 'HSHELL_ACCESSIBILITYSTATE' : (event = 12) ? 'HSHELL_APPCOMMAND' : (event = 13) ? 'HSHELL_WINDOWREPLACED' : (event = 14) ? 'HSHELL_WINDOWREPLACING' : (event = 32768) ? 'HSHELL_HIGHBIT' : (event = 32774) ? 'HSHELL_FLASH' : 'No Event'
	if ((event = 1) || (event = 4) || (event = 32772)) {
		; hWnd := WinActive('A')
		DllCall("GetWindowThreadProcessId", "Int", hwnd, "Int*", &tpID := 0)
		try name := WinGetProcessName(hwnd)
		if name = '' {
			return
		}
		A_Process := name
		Monitor := DPI.GetMonitorInfo(hWnd)
		; hMon_Win := DPI.MonitorFromWindow(hwnd)
		hMon  := Monitor.Handle
		mName := Monitor.Name
		wDPI  := Monitor.winDPI
		A_DPI := Monitor.DPI
		; mName := RegExReplace(mName, '\\\\\.\\', '')
		; mDPI := DPI.GetForMonitor(hMon_Win)
		; ToolTip(hMon_Win ': ' mDPI  ' : ' A_DPIAwareness, 0,0, 2)
		; wDPI := DPI.WinGetDPI(A_Process)
		; Infos(wDPI)
		; A_DPI := [mDPI, Monitor.x, Monitor.y]
		; A_DPI := A_DPI.ToString(' ')
		; A_DPI := wDPI
		ProcessInfo.SafePush(A_Process)
		processInfoMap.SafeSet('Process', A_Process)
		processInfoMap.SafeSet('Monitor', mName)
		processInfoMap.SafeSet('hMon', hMon)
		processInfoMap.SafeSet('A_DPI', A_DPI)
	}
	; --------------------------------------------------------------------------------
	; --------------------------------------------------------------------------------
	_AE_bInpt_sLvl(0)
	; match := processInfoMap.ToString('`n')
	; ToolTip(A_Process ': ' A_DPI ' : ' A_DPIAwareness, 0, 100, 1)
	; ToolTip(match, 0, 0, 1)
	; ToolTip(A_DPI, 0, 0, 1)
	; ToolTip(A_DPI, 0, 0)
	; Infos(match)
	; return processInfoMap
	return A_DPI
}
Edit_Copy(fCtl := ControlGetFocus('A'), hEdit := tryHwnd()) {
	Static WM_COPY:=0x301
	; SendMessage(WM_COPY, 0, 0, , "ahk_id " hEdit)
	if WinActive('ahk_exe hznHorizon.exe') {
		SendMessage(WM_COPY, 0, 0, fCtl,hEdit)
	} else {
		; SendMessage(WM_COPY, 0, 0, hEdit, hEdit)
		SendMessage(WM_COPY, 0, 0, , 'A')
	}
	Infos(A_Clipboard)
}
SndMsgCopy(fCtl := 0) {
	; @link ...: https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-copy
	; @info ...: wParam & lParam MUST be 0
	; @struct .: COPYDATASTRUCT ...: 
	; @link ...: https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-copydata
	; @func ...: StringLen := NumGet(lParam + A_PtrSize, "int")    StringAddress := NumGet(lParam + 2*A_PtrSize)    Data := StrGet(StringAddress, StringLen, Encoding)
	static WM_COPY := 0x0301, wParam := 0, lParam := 0
	try fCtl := ControlGetFocus('A')
	(fCtl = 0) ? SendEvent('^{sc2E}') : SendMessage(WM_COPY,wParam,lParam,fCtl,'A')
}
; ---------------------------------------------------------------------------
SndMsgCut(fCtl := 0) {
	; @link : https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-cut
	; @info : wParam & lParam MUST be 0
	static WM_CUT := 0x0300, wParam := 0, lParam := 0
	try fCtl := ControlGetFocus('A')
	(fCtl = 0) ? SendEvent('^{sc2D}') : SendMessage(WM_CUT,lParam,lParam,fCtl,'A')
}
; ---------------------------------------------------------------------------
SndMsgPaste(fCtl := 0) {
	; @link : https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-paste
	; @info : wParam & lParam MUST be 0
	static WM_PASTE := 0x0302, wParam := 0, lParam := 0
	try fCtl := ControlGetFocus('A')
	(fCtl = 0) ? SendEvent('^{sc2F}') : SendMessage(WM_PASTE,wParam,lParam,fCtl,'A')
}

trayNotify(title, message, options := 0) {
    TrayTip(title, message, options)
}
#HotIf WinActive(' Visual Studio Code')
^+m::
{
	text := ''
	cBak := ClipboardAll()
	Infos(EmptyClipboard(), 3000)
	Sleep(100)
	SndMsgCopy()
	text :=  A_Clipboard
	loop {
		Sleep(20)
	} until (text.length > 0)
	InternetSearch.TriggerSearch('msdn win32 ' text)
	EmptyClipboard()
	Sleep(1000)
	A_Clipboard := cBak
}
#HotIf
EmptyClipboard() => DllCall('User32\EmptyClipboard', 'int')
; ---------------------------------------------------------------------------
; ;===================================================================================================
; ;AUTHOR   : https://www.autohotkey.com/boards/viewtopic.php?p=509863#p509863
; ;Function : XYplorer Get Selection
; ;Created  : 2023-02-28
; ;Modified : 2023-06-13
; ;Version  : v1.3
; ;===================================================================================================
; #Requires AutoHotkey v2.0.2



; ; Get our own HWND (we have no visible window)
; G_OwnHWND := A_ScriptHwnd + 0


; ; Get messages back from XYplorer
; OnMessage(0x4a, Receive_WM_COPYDATA)


; dataReceived := ""


; F1::
; {
;     path := XYGetPath()
;     all  := XYGetAll()
;     sel  := XYGetSelected()
;     MsgBox path
;     MsgBox all
;     MsgBox sel
; 	Send_WM_COPYDATA('::echo "Hello!"')
; return
; }


; XYGetPath()
; {
;    return XY_Get()
; }


; XYGetAll()
; {
;    return XY_Get(true)
; }


; XYGetSelected()
; {
;    return XY_Get(, true)
; }


; XY_Get(bAll:=false, bSelection:=false)
; {
;     xyQueryScript := '::if (!' bAll ' && !' bSelection ') {$return = "<curpath>"`;} elseif (' bAll ') {$return = listpane(, , , "<crlf>")`;} elseif (' bSelection ') {$return = get("SelectedItemsPathNames", "<crlf>")`;} copydata ' G_OwnHWND ', "$return", 2`;'

;     Send_WM_COPYDATA(xyQueryScript)

;     return dataReceived
; }


; GetXYHWND() {
; static xyClass := 'ahk_class ThunderRT6FormDC'

; if hwnd := WinActive(xyClass) || WinExist(xyClass) {
; 	for xyid in WinGetList(xyClass)
; 		for ctrl in WinGetControls(xyid)
; 			if ctrl = "ThunderRT6PictureBoxDC70"
; 				return xyid
; 	if hwnd
; 		return hwnd
; 	else
; 		return WinGetList(xyClass)[1]
; }
; }


; Send_WM_COPYDATA(message) {
; xyHwnd := GetXYHWND()

; if !(xyHwnd)
; 	return

; size := StrLen(message)

; COPYDATA := Buffer(A_PtrSize * 3)
; NumPut("Ptr", 4194305, COPYDATA, 0)
; NumPut("UInt", size * 2, COPYDATA, A_PtrSize)
; NumPut("Ptr", StrPtr(message), COPYDATA, A_PtrSize * 2)

; return DllCall("User32.dll\SendMessageW", "Ptr", xyHwnd, "UInt", 74, "Ptr", 0, "Ptr", COPYDATA, "Ptr")
; }


; Receive_WM_COPYDATA(wParam, lParam, *) {
; global dataReceived := StrGet(
; 	NumGet(lParam + 2 * A_PtrSize, 'Ptr'),   ; COPYDATASTRUCT.lpData, ptr to a str presumably
; 	NumGet(lParam + A_PtrSize, 'UInt') / 2   ; COPYDATASTRUCT.cbData, count bytes of lpData, /2 to get count chars in unicode str
; )
; }

; ;===================================================================================================
; ;AUTHOR   : https://www.autohotkey.com/boards/viewtopic.php?p=509863#p509863
; ;Function : XYplorer Get Selection
; ;Created  : 2023-02-28
; ;Modified : 2023-06-13
; ;Version  : v1.1
; ;===================================================================================================
; #Requires AutoHotkey v2.0.2



; ; Get our own HWND (we have no visible window)
; DetectHiddenWindows(true)
; G_OwnHWND := WinExist("Ahk_PID " DllCall("GetCurrentProcessId"))
; G_OwnHWND += 0


; ; Get messages back from XYplorer
; OnMessage(0x4a, Receive_WM_COPYDATA)

; global dataReceived := ""

; F1::
; {
;     path := XYGetPath()
;     all  := XYGetAll()
;     sel  := XYGetSelected()
;     MsgBox path
;     MsgBox all
;     MsgBox sel
; return
; }


; XYGetPath()
; {
;     return XY_Get()
; }


; XYGetAll()
; {
;    return XY_Get(true)
; }


; XYGetSelected()
; {
;    return XY_Get(, true)
; }


; XY_Get(bAll:=false, bSelection:=false)
; {
;     xyQueryScript := '::if (!' bAll ' && !' bSelection ') {$return = "<curpath>"`;} elseif (' bAll ') {$return = listpane(, , , "<crlf>")`;} elseif (' bSelection ') {$return = get("SelectedItemsPathNames", "<crlf>")`;} copydata ' G_OwnHWND ', "$return", 2`;'

;     Send_WM_COPYDATA(xyQueryScript)

;     return dataReceived
; }


; GetXYHWND() {
; 	static xyClass := 'ahk_class ThunderRT6FormDC'

;     if hwnd := WinActive(xyClass) || WinExist(xyClass) {
;         for xyid in WinGetList(xyClass)
;             for ctrl in WinGetControls(xyid)
;                 if ctrl = "ThunderRT6PictureBoxDC70"
;                    return xyid
;         if hwnd
;            return hwnd
;         else
;            return WinGetList(xyClass)[1]
;     }
; }


; Send_WM_COPYDATA(message) {
;    xyHwnd := GetXYHWND()

;    if !(xyHwnd)
;        return

;    size := StrLen(message)
;    if !(StrLen(Chr(0xFFFF))) {
;       data := Buffer(size * 2, 0)
;       StrPut(message, &data, size, "UTF-16")
;    } else {
;       data := message
;    }

;    COPYDATA := Buffer(A_PtrSize * 3)
;    NumPut("Ptr", 4194305, COPYDATA, 0)
;    NumPut("UInt", size * 2, COPYDATA, A_PtrSize)
;    NumPut("Ptr", StrPtr(data), COPYDATA, A_PtrSize * 2)

;    return DllCall("User32.dll\SendMessageW", "Ptr", xyHwnd, "UInt", 74, "Ptr", 0, "Ptr", COPYDATA, "Ptr")
; }


; Receive_WM_COPYDATA(wParam, lParam, *) {
; 	global dataReceived := StrGet(
; 		NumGet(lParam + 2 * A_PtrSize, 'Ptr'), ; COPYDATASTRUCT.lpData, ptr to a str presumably
; 		NumGet(lParam + A_PtrSize, 'UInt') / 2 ; COPYDATASTRUCT.cbData, count bytes of lpData, /2 to get count chars in unicode str
; 	)
; }


/************************************************************************
 * function ...: Update_Receiver_Map()
 * @author OvercastBTC
 * @example :
;! Note: while the fName is the file name, the fOpen likel needs to be opened beforehand (prior to refactoring, this was how it worked before in Horizon)

Inputs:
; ---------------------------------------------------------------------------
; @i ...: Inputs: fName (file name)
; @i ...: Inputs: fOpen (that file name opened)
; @i ...: Inputs: [Optional - RegExMatch &/or InStr(?) Object]
; ---------------------------------------------------------------------------

ClassMap:
; ---------------------------------------------------------------------------
class receiver {
	static rMap := Map(
		'width', width := 2012,
		'height', height := 0,
		'x', x := 42,
		'y', y := 666,
		'top', top := 0,
		'bottom', bottom := 0,
		'hCtl', hCtl := 134162,
		'nCtl', nCtl := '',
		'fPath', fPath := '',
		'fName', fName := '',
	)
}

RegEx:
; ---------------------------------------------------------------------------
; @i ...: Group 1 ($1) = key of Map (MatchObj) (e.g., 'width' of the key-value pair 'width', width := 0)
; @i ...: kNeedle := '([\`'\`"]\w+[\`'\`"])'
; @i ...: We need to match the key, in the identically named key-value pair (e.g., 'width', width := 0).
; @i ...: If there is a match, we will use the following two groups to remove the value (of the value)
; @i ...: E.g., Array.RemoveAt(A_Index) and then Array.InsertAt(A_Index, aLine)
; ---------------------------------------------------------------------------
; @i ...: Group 2 ($2) = value of the value of Map (MatchObj) (e.g., 12345 of the value of the key-value pair 'height', height := 12345)
; @i ...: vNeedle := ':= (\d+,)'
; ---------------------------------------------------------------------------
; @i ...: Group 3 ($3) = blank value of the value of Map (MatchObj) (e.g., '' || "" of the value of the key-value pair 'fPath', fPath := '')
; @i ...: bNeedle := '([\`'\`"]{2})'
; ---------------------------------------------------------------------------
; @i ...: This needle matches ALL three groups, but in an or state
; Needle := '([\`'\`"]\w+[\`'\`"])|:= (\d+,)|([\`'\`"]{2})'
; Needle := '([\`'\`"]\w+[\`'\`"][,\s])|:= (\d+,)|(:= [\`'\`"]{2})'
Needle := '(?:([\`'\`"]\w+[\`'\`"][,\s])|(\d+,)|([\`'\`"]{2}))' ;? includes a ?: or 'match all' but as a non-capturing group
; ---------------------------------------------------------------------------
 * @param {string} fName 
 * @param {string} fOpen 
 * @param MatchObj 
 * @returns {number} 
 ***********************************************************************/

Update_Receiver_Map(fName:='', fOpen := '', MatchObj?){
	rMap := Map()
	arrFile := [], arrMap := [], fArrObj:=[]
	fLine := '', vLine := '', mV := '', rMatch := '', rect_match := '', new_str := '', mTest := '', fString := ''
	; kNeedle := '([\`'\`"]\w+[\`'\`"])' ;? I'm thinking this is the better one so I'm not capturing the 'comma-space' after the key, but I dunno yet
	kNeedle := '([\`'\`"]\w+[\`'\`"][,\s])'
	kReplace := '$1' ;? not necessarily needed, but included for reference
	; vNeedle := ':= (\d+,)'
	vNeedle := '(\d+,)'
	vReplace := '$2' ;? not necessarily needed, but included for reference
	bNeedle := '([\`'\`"]{2})'
	bReplace := '$3' ;? not necessarily needed, but included for reference
	; ---------------------------------------------------------------------------
	; @i ...: Loop through each line of the file (fName)
	; ---------------------------------------------------------------------------
	loop read fName {
		fArrObj.SafePush(A_LoopReadLine)
		fLine .= A_LoopReadLine '`n'
	}
	; ---------------------------------------------------------------------------
	for each, vLine in arrFile {
		; ---------------------------------------------------------------------------
		aLine.RegExMatch(kNeedle | vNeedle, &MatchObj)
		for each, mV in MatchObj {
			if ((aLine ~= mV)) {
				str_match := StrSplit(mV,')','i ) "')
				rMatch := str_match[2]
				; Infos(rMatch)
				rect_match := rMap[rMatch]
				; rect_match := dpiRect.%str_match[2]%
				aLine.RegExReplace(vNeedle, '$1' rect_match ',')
				; new_str := RegExReplace(aLine, ':= ([0-9].*)', ':= ' rect_match . ',' )
				aLine := new_str
				fName.RemoveAt(A_Index)
				fName.InsertAt(A_Index, aLine)
			}
		}
		; ---------------------------------------------------------------------------
		; @i ...: Write each value in the array to @param fString (the new file's string variable)
		; ---------------------------------------------------------------------------
		fString .= aLine . '`n'
		; ---------------------------------------------------------------------------
	}
	; ---------------------------------------------------------------------------
	fOpen.Write(fString)
	fOpen := ''
	return 0
}
