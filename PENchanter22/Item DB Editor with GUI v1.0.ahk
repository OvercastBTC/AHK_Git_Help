#Requires AutoHotkey v1.1
;	*** environment configuration ***
#Persistent
#SingleInstance Force
#NoEnv
SetWorkingDir, %A_ScriptDir%
;	DetectHiddenWindows, On
;	SetTitleMatchMode, 2
;	SetBatchLines -1
;	#NoTrayIcon
;	#Warn All, OutputDebug

InitializeVariables()
; GUIshowX 	:= "Center", GUIshowY := "Center", GUIshowW := 500, GUIshowH := 500	; 1348, 141, 516, 544
; GUIshowX 	:= "1348", GUIshowY := "141", GUIshowW := 500, GUIshowH := 500	; 1348, 141, 516, 544
GUIshowX 	:= "1348", GUIshowY := "141", GUIshowW := 500	; 1348, 141, 516, 544
GroupBoxW 	:= GUIshowW - 20
GroupBoxH 	:= 203 + 30 + 10
GUIshowH 	:= GroupBoxH + 75

GuiConstructOne:
;	ComboBox field group
;	Variables: GameName, GroupBoxW, GroupBoxH, ComboItemChoice, DBArrayString, ComboItemChoicePOS[x, y, w, h]
;	'GO' label(s): ComboItemChoice
	Gui, % GUIName ":New", +AlwaysOnTop +Border +LastFound +MinimizeBox +Owner +SysMenu -MaximizeBox -Resize
	Gui, Color, 00008B								;  Background color : Dark Blue = 00008B
	Gui, Font, s14 Normal c00FFFF, Consolas				; Cyan = 00FFFF
	Gui, Add, GroupBox, x10 y10 w%GroupBoxW% h%GroupBoxH% Section, -=> %GameName% Item Database <=-
	Gui, Font, s14 Bold c000000, Consolas				; Black = 000000
	Gui, Add, ComboBox, xs+15 ys+33 vComboItemChoice gComboItemChoice, % DBArrayString
	GuiControlGet, ComboItemChoicePOS, Pos, ComboItemChoice	; ComboBoxPOSx, ComboBoxPOSy, ComboBoxPOSw, ComboBoxPOSh

;	text separator group
;	Variables: TextSeparator1, TextSeparator1POS[x, y, w, h]
	Gui, Font, s16 Bold C00FF00, Consolas				; Green = 00FF00
	Gui, Add, Text, x+m vTextSeparator1, /
	GuiControlGet, TextSeparator1POS, Pos, TextSeparator1	; x, y, w, h
;	GuiControl, Hide, TextDivider

;	First 'EDIT' field group
;	Variables: EditItemQuantity, TextItemQuantity
	Gui, Font, s14 Bold c000000, Consolas				; Black = 000000
	Gui, Add, Edit, x+m vEditItemQuantity w50 Number, % EditItemQuantity
	GuiControlGet, EditItemQuantityPOS, Pos, EditItemQuantity	; x, y, w, h
	Gui, Font, s14 Bold CFFA500, Consolas				; Orange = FFA500
	Gui, Add, Text, x+m vTextItemQuantity, Quantity			; can also use : ItemTypeAssociativeArray.Item

;	Second 'EDIT' field group
;	Variables: EditItemStarQuality, TextItemStarQuality
	Gui, Font, s14 Bold c000000, Consolas				; Black = 000000
	Gui, Add, Edit, x%EditItemQuantityPOSX% y+m vEditItemStarQuality w50 Number, % EditItemStarQuality
	GuiControlGet, EditItemStarQualityPOS, Pos, EditItemStarQuality	; x, y, w, h
	Gui, Font, s14 Bold CFFA500, Consolas				; Orange = FFA500
	Gui, Add, Text, x+m vTextItemStarQuality, Star Quality	; can also use : ItemTypeAssociativeArray.Item

;	Third 'EDIT' field group
;	Variables: EditSeedQuantity, TextSeedQuantity
	Gui, Font, s14 Bold c000000, Consolas				; Black = 000000
	Gui, Add, Edit, x%EditItemQuantityPOSX% y+m vEditSeedQuantity w50 Number, % EditSeedQuantity
	GuiControlGet, EditSeedQuantityPOS, Pos, EditSeedQuantity	; x, y, w, h
	Gui, Font, s14 Bold CFFFF00, Consolas				; Yellow = FFFF00
	Gui, Add, Text, x+m vTextSeedQuantity, Seeds			; can also use : ItemTypeAssociativeArray.Item

;	Fourth 'EDIT' field group
;	Variables: EditSeedStarQuality, TextSeedStarQuality
	Gui, Font, s14 Bold c000000, Consolas				; Black = 000000
	Gui, Add, Edit, x%EditSeedQuantityPOSX% y+m vEditSeedStarQuality w50 Number, % EditSeedStarQuality
	GuiControlGet, EditSeedStarQualityPOS, Pos, EditSeedStarQuality	; x, y, w, h
	Gui, Font, s14 Bold CFFFF00, Consolas				; Yellow = FFFF00
	Gui, Add, Text, x+m vTextSeedStarQuality, Star Quality	; can also use : ItemTypeAssociativeArray.Item

;	Fifth 'EDIT' field group
;	Variables: EditPreservesQuantity, TextPreservesQuantity
	Gui, Font, s14 Bold c000000, Consolas				; Black = 000000
	Gui, Add, Edit, x%EditSeedStarQualityPOSX% y+m vEditPreservesQuantity w50 Number, % EditPreservesQuantity
	GuiControlGet, EditPreservesQuantityPOS, Pos, EditPreservesQuantity	; x, y, w, h
	Gui, Font, s14 Bold CFF00FF, Consolas				; Magenta = FF00FF
	Gui, Add, Text, x+m vTextPreservesQuantity, Preserves	; can also use : ItemTypeAssociativeArray.Item

;	Sixth 'EDIT' field group
;	Variables: EditPreservesStarQuality, TextPreservesStarQuality
	Gui, Font, s14 Bold c000000, Consolas				; Black = 000000
	Gui, Add, Edit, x%EditPreservesQuantityPOSX% y+m vEditPreservesStarQuality w50 Number, % EditPreservesStarQuality
	GuiControlGet, EditPreservesStarQualityPOS, Pos, EditPreservesStarQuality	; x, y, w, h
;	Gui, Font, s14 Bold CFFFF00, Consolas				; Yellow = FFFF00
	Gui, Font, s14 Bold CFF00FF, Consolas				; Magenta = FF00FF
	Gui, Add, Text, x+m vTextPreservesStarQuality, Star Quality	; can also use : ItemTypeAssociativeArray.Item

	Gui, Font, s16 Bold CFFFF00;				; Yellow = FFFF00
	Gui, Add, Text, x%TextSeparator1POSX% y%TextSeparator1POSY% vTextControlSelect, <- select
	GuiControl, Hide, TextControlSelect

	Gui, Font, s14 Bold c000000, Consolas				; Black = 000000
	Gui, Add, Button, xs+15 w100 vButtonRestore gButtonClicked, Restore
	Gui, Add, Button, x+75 w100 vButtonQuit gButtonClicked, 	Quit
	Gui, Add, Button, x+75 w100 vButtonUpdate gButtonClicked, 	Update

	Gui, Show, x%GUIshowX% y%GUIshowY% w%GUIshowW% h%GUIshowH%, % GUITitle

Return

ComboItemChoice:
	Gui, Submit, NoHide
Return

ButtonClicked:
	GuiControlGet, ButtonName, Name, %A_GuiControl%
;	MsgBox, 262208, Status?, % ButtonName
	Switch True
		{
;			Case InStr(ButtonName, "Restore"):	; DOES NOT WORK AS EXPECTED !!
			Case RegExMatch(ButtonName, ".+Restore$"):
;				MsgBox, 262208, Status?, % "You pressed : Restore" 	; will display the variable name (without the preceding 'v')
				Reload
			Case RegExMatch(ButtonName, ".+Quit$"):
;				MsgBox, 262208, Status?, % "You pressed : Quit" 	; will display the variable name (without the preceding 'v')
				ExitApp
			Case RegExMatch(ButtonName, ".+Update$"):
;				MsgBox, 262208, Status?, % "You pressed : Update" 	; will display the variable name (without the preceding 'v')
;			Default:
;				MsgBox, 262208, Status?, % "You pressed : " A_GuiControl 	; will display the variable name (without the preceding 'v')
		}
Return

~Enter::
	Gui, Submit, NoHide
Return

F2::
	WinGetPos, xHor, yVer, wWid, hHei, % GUITitle
	Clipboard := xHor ", " yVer ", " wWid ", " hHei
	MsgBox, 262208, Status?, % Clipboard
Return

DBgui1GuiClose:
DBgui1GuiEscape:
	ExitApp
Return

F9::Reload
Escape::
F10::ExitApp
;	Escape::ExitApp

InitializeVariables()
	{
		Global _ := ""
			, Enabled					:= "yes"							; use for enabling / disabling hotkey usage
			, GameName					:= "Palia"
			, DatabaseINIversion		:= "v2.0"
			, DatabaseINIfile			:= A_ScriptDir . "\INI\" . GameName . " Item Database " . DatabaseINIversion . ".ini"
			, DatabaseSection			:= GameName . " - " . "Items"
			, GUIName					:= "DBgui1"							; must include this value in GuiClose & GuiEscape labels below: Gui_NameGuiClose / Gui_NameGuiEscape
			, GUITitle					:= "Database Editing GUI v2.0"
			, DatabaseArray 			:= []								; create an Array
			, DatabaseArrayString 		:= []								; create an Array
			, DatabaseAssociativeArray	:= {}								; create an 'Associative' Array
			, ItemTypeAssociativeArray := {Item: " ", StarQuality: "★", Crop: "🪴", Seed: "🛍", Mining: "🪨", Forageble: "🌹"}

;			, ItemType_				:= "🌱"
;			, ItemType_Star			:= "★"
	}
