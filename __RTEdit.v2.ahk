;--------------------------------------------------------------------------------------------------------------------
; @Section ....:  						Rich Text Editor - Customized for Horizon
;--------------------------------------------------------------------------------------------------------------------

#Requires AutoHotkey v2+
#Include *i <Directives\__AE.v2>
; #Include <__AE.v2>
#Include <RichEdit>
#Include <RichEditDlgs>
; #Include *i <Includes\Includes_Standard>
; #Include *i <Includes\Includes_Runner>
; TraySetIcon('HICON:' Create_HznHorizon_ico())

;--------------------------------------------------------------------------------------------------------------------
; @Section ...: 						Create a Gui with RichEdit controls
;--------------------------------------------------------------------------------------------------------------------

^+t::{
	hzn := RTEdit()
	hzn.Show()

}

;--------------------------------------------------------------------------------------------------------------------
; @Class ...: 								Rich Text Editor Class
;--------------------------------------------------------------------------------------------------------------------
Class RTEdit {
	; ---------------------------------------------------------------------------
	; @i ...: Initial values
	; ---------------------------------------------------------------------------
	static  GuiTitle := 'Horizon Rich Text Editor - hznRTE -- A Rich Text Editor for Horizon',
			FontCharSet := 1,
			FontName := 'Times New Roman',
			FontSize := 11,
			FontStyle := "Norm",
			BackColor := "cYellow",
			TextColor := "cBlack",
			TextBkColor := "Auto",
			WordWrap := True,
			AutoURL := False,
			; this.ShowWysiwyg := False, this.HasFocus := False, 
			ShowWysiwyg := true,
			HasFocus := true ,
			Zoom := "100 %",
			CurrentLine := 0,
			CurrentLineCount := 0,
			hMult := 5,
			wMult := 2,
			gHmult := 2,
			div := 5,
			MarginX := 10,
			MarginY := 10,
			EditW := (A_ScreenHeight / 2),
			EditH := 1000,
			; REW := w := this.EditW,
			; REH := h := this.EditH,
			GuiW := Round(A_ScreenWidth * (1/4)),
			GuiH := Round(A_ScreenHeight * (1/4))

	
		
      Settings := {
         GuiTitle: 'Horizon Rich Text Editor - hznRTE -- A Rich Text Editor for Horizon',
         FontCharSet : 1,
         FontName : 'Times New Roman',
         FontSize : 11,
         FontStyle : "Norm",
         BackColor : "cYellow",
         TextColor : "cBlack",
         TextBkColor : "Auto",
         WordWrap : True,
         AutoURL : False,
         ; this.ShowWysiwyg : False, this.HasFocus : False, 
         ShowWysiwyg : true,
         HasFocus : true ,
         Zoom : "100 %",
         CurrentLine : 0,
         CurrentLineCount : 0,
         hMult : 5,
         wMult : 2,
         gHmult : 2,
         div : 5,
         MarginX : 10,
         MarginY : 10,
         EditW : (A_ScreenHeight / 2),
         EditH : 1000,
         ; REW : w := this.EditW,
         ; REH : h := this.EditH,
         GuiW : Round(A_ScreenWidth * (1/4)),
         GuiH : Round(A_ScreenHeight * (1/4))
      }
      static Settings := {
         
         GuiTitle: 'Horizon Rich Text Editor - hznRTE -- A Rich Text Editor for Horizon',
         FontCharSet : 1,
         FontName : 'Times New Roman',
         FontSize : 11,
         FontStyle : "Norm",
         BackColor : "cYellow",
         TextColor : "cBlack",
         TextBkColor : "Auto",
         WordWrap : True,
         AutoURL : False,
         ; this.ShowWysiwyg : False, this.HasFocus : False, 
         ShowWysiwyg : true,
         HasFocus : true ,
         Zoom : "100 %",
         CurrentLine : 0,
         CurrentLineCount : 0,
         hMult : 5,
         wMult : 2,
         gHmult : 2,
         div : 5,
         MarginX : 10,
         MarginY : 10,
         EditW : (A_ScreenHeight / 2),
         EditH : 1000,
         ; REW : w := this.EditW,
         ; REH : h := this.EditH,
         GuiW : Round(A_ScreenWidth * (1/4)),
         GuiH : Round(A_ScreenHeight * (1/4))
      }
	
	; Focus() => This.RE.Focus()
	; GetPos(&X?, &Y?, &W?, &H?) => This.RE.GetPos(&X?, &Y?, &W?, &H?)
	; Move(X?, Y?, W?, H?) => This.RE.Move(X?, Y?, W?, H?)
	; OnCommand(Code, Callback, AddRemove?) => This.RE.OnCommand(Code, Callback, AddRemove?)
	; OnNotify(Code, Callback, AddRemove?) => This.RE.OnNotify(Code, Callback, AddRemove?)
	; Opt(Options) => This.RE.Opt(Options)
	; Redraw() => This.RE.Redraw()
	; ---------------------------------------------------------------------------
	; @Section ...:			Create a New Gui
	; @i ...:	When a new instance of the RTEdit Class is called, a new Gui is made
	; ---------------------------------------------------------------------------
	__New() {
      ; for key, value in this.Settings.OwnProps() {
      ;    while (this.Settings.HasOwnProp(&key, &value)) {
      ;       Infos(key ' ' value)
      ;    }
      ; }
      FileMenu := Menu()
      FileMenu.Add("&Open", this.FileLoadFN.Bind(this,"Open"))
      FileMenu.Add("&Append", this.FileLoadFN.Bind(this,"Append"))
      FileMenu.Add("&Insert", this.FileLoadFN.Bind(this,"Insert"))
      FileMenu.Add("&Close", this.FileCloseFN.Bind(this, 'Close'))
      FileMenu.Add("&Save", this.FileSaveFN.Bind(this, 'Save'))
      FileMenu.Add("Save &as", this.FileSaveAsFN.Bind(this, 'SaveAs'))
      FileMenu.Add()
      FileMenu.Add("Page &Margins", this.PageSetupFN.Bind(this))
      FileMenu.Add("&Print", this.PrintFN.Bind(this))
      FileMenu.Add()
      FileMenu.Add("&Exit", this.MainGuiClose.Bind(this))
      ; EditMenu--------------------------------------------------------------------------------------------------------------
      EditMenu := Menu()
      EditMenu.Add("&Undo`tCtrl+Z", this.UndoFN.Bind(this, 'Undo'))
      EditMenu.Add("&Redo`tCtrl+Y", this.RedoFN.Bind(this, 'Redo'))
      EditMenu.Add()
      EditMenu.Add("C&ut`tCtrl+X", this.CutFN.Bind(this, 'Cut'))
      EditMenu.Add("&Copy`tCtrl+C", this.CopyFN.Bind(this, 'Copy'))
      EditMenu.Add("&Paste`tCtrl+V", this.PasteFN.Bind(this, 'Paste'))
      EditMenu.Add("C&lear`tDel", this.ClearFN.Bind(this, 'Clear'))
      EditMenu.Add()
      EditMenu.Add("Select &all `tCtrl+A", this.SelAllFN.Bind(this, 'SelectAll'))
      EditMenu.Add("&Deselect all", this.DeselectFN.Bind(this, 'DeSelect'))
      ; SearchMenu------------------------------------------------------------------------------------------------------------
      SearchMenu := Menu()
      SearchMenu.Add("&Find", this.FindFN.Bind(this, 'Find'))
      SearchMenu.Add("&Replace", this.ReplaceFN.Bind(this, 'Repalce'))
      ; FormatMenu------------------------------------------------------------------------------------------------------------
      ; Paragraph
      AlignMenu := Menu()
      AlignMenu.Add("Align &left`tCtrl+L", this.AlignFN.Bind(this,"Left"))
      AlignMenu.Add("Align &center`tCtrl+E", this.AlignFN.Bind(this,"Center"))
      AlignMenu.Add("Align &right`tCtrl+R", this.AlignFN.Bind(this,"Right"))
      AlignMenu.Add("Align &justified", this.AlignFN.Bind(this,"Justify"))
      IndentMenu := Menu()
      IndentMenu.Add("&Set", this.IndentationFN.Bind(this,"Set"))
      IndentMenu.Add("&Reset", this.IndentationFN.Bind(this,"Reset"))
      LineSpacingMenu := Menu()
      LineSpacingMenu.Add("1 line`tCtrl+1", this.SpacingFN.Bind(this,1.0))
      LineSpacingMenu.Add("1.5 lines`tCtrl+5", this.SpacingFN.Bind(this,1.5))
      LineSpacingMenu.Add("2 lines`tCtrl+2", this.SpacingFN.Bind(this,2.0))
      NumberingMenu := Menu()
      NumberingMenu.Add("&Set", this.NumberingFN.Bind(this,"Set"))
      NumberingMenu.Add("&Reset", this.NumberingFN.Bind(this,"Reset"))
      TabstopsMenu := Menu()
      TabstopsMenu.Add("&Set Tabstops", this.SetTabstopsFN.Bind(this,"Set"))
      TabstopsMenu.Add("&Reset to Default", this.SetTabstopsFN.Bind(this,"Reset"))
      TabstopsMenu.Add()
      TabstopsMenu.Add("Set &Default Tabs", this.SetTabstopsFN.Bind(this,"Default"))
      ParaSpacingMenu := Menu()
      ParaSpacingMenu.Add("&Set", this.ParaSpacingFN.Bind(this,"Set"))
      ParaSpacingMenu.Add("&Reset", this.ParaSpacingFN.Bind(this,"Reset"))
      ParagraphMenu := Menu()
      ParagraphMenu.Add("&Alignment", (*) => this.AlignMenu)
      ParagraphMenu.Add("&Indentation", (*) => this.IndentMenu)
      ParagraphMenu.Add("&Numbering", (*) => this.NumberingMenu)
      ParagraphMenu.Add("&Linespacing", (*) => this.LineSpacingMenu)
      ParagraphMenu.Add("&Space before/after", (*) => this.ParaSpacingMenu)
      ParagraphMenu.Add("&Tabstops", (*) => this.TabstopsMenu)
      ; Character
      TxColorMenu := Menu()
      TxColorMenu.Add("&Choose", this.TextColorFN.Bind(this,"Choose"))
      TxColorMenu.Add("&Auto", this.TextColorFN.Bind(this,"Auto"))
      BkColorMenu := Menu()
      BkColorMenu.Add("&Choose", this.TextBkColorFN.Bind(this,"Choose"))
      BkColorMenu.Add("&Auto", this.TextBkColorFN.Bind(this,"Auto"))
      CharacterMenu := Menu()
      CharacterMenu.Add("&Font", (*) => this.ChooseFontFN)
      CharacterMenu.Add("&Text color", (*) => this.TxColorMenu)
      CharacterMenu.Add("Text &Backcolor", (*) => this.BkColorMenu)
      ; Format
      FormatMenu := Menu()
      FormatMenu.Add("&Character", (*) => this.CharacterMenu)
      FormatMenu.Add("&Paragraph", (*) => this.ParagraphMenu)
      ; ViewMenu--------------------------------------------------------------------------------------------------------------
      ; Background
      BackgroundMenu := Menu()
      BackgroundMenu.Add("&Choose", this.BackGroundColorFN.Bind(this,"Choose"))
      BackgroundMenu.Add("&Auto", this.BackgroundColorFN.Bind(this,"Auto"))
      ; Zoom
      ZoomMenu := Menu()
      ZoomMenu.Add("200 %", this.ZoomFN.Bind(this,200))
      ZoomMenu.Add("150 %", this.ZoomFN.Bind(this,150))
      ZoomMenu.Add("125 %", this.ZoomFN.Bind(this,125))
      ZoomMenu.Add("100 %", (*) => this.Zoom100FN)
      ZoomMenu.Check("100 %")
      ZoomMenu.Add("75 %", this.ZoomFN.Bind(this,75))
      ZoomMenu.Add("50 %", this.ZoomFN.Bind(this,50))
      ; View
      ViewMenu := Menu()
      MenuWordWrap := "&Word-wrap"
      ViewMenu.Add(MenuWordWrap, this.WordWrapFN)
      MenuWysiwyg := "Wrap as &printed"
      ViewMenu.Add(MenuWysiwyg, this.WysiWygFN)
      ViewMenu.Add("&Zoom", ZoomMenu)
      ViewMenu.Add()
      ViewMenu.Add("&Background Color", BackgroundMenu)
      ViewMenu.Add("&URL Detection", this.AutoURLDetectionFN)
      ; ContextMenu ----------------------------------------------------------------------------------------------------------
      ContextMenu := Menu()
      ContextMenu.Add("&File", FileMenu)
      ContextMenu.Add("&Edit", EditMenu)
      ContextMenu.Add("&Search", SearchMenu)
      ContextMenu.Add("F&ormat", FormatMenu)
      ContextMenu.Add("&View", ViewMenu)
      ; MainMenuBar ----------------------------------------------------------------------------------------------------------
      MainMenuBar := MenuBar()
      MainMenuBar.Add("&File", FileMenu)
      MainMenuBar.Add("&Edit", EditMenu)
      MainMenuBar.Add("&Search", SearchMenu)
      MainMenuBar.Add("F&ormat", FormatMenu)
      MainMenuBar.Add("&View", ViewMenu)
      ; Main Gui =============================================================================================================
      GuiNum := 1
      MainGui := Gui("+ReSize +MinSize", this.GuiTitle)
      MainGui.OnEvent("Size", this.MainGuiSize)
      MainGui.OnEvent("Close", this.MainGuiClose)
      MainGui.OnEvent("ContextMenu", this.MainContextMenu)
      MainGui.MenuBar := MainMenuBar
      MainGui.MarginX := this.MarginX
      MainGui.MarginY := this.MarginY
      ; Style buttons --------------------------------------------------------------------------------------------------------
      MainGui.SetFont("Bold", "Arial")
      MainBNSB := MainGui.AddButton("xm y3 w20 h20", "&B")
      MainBNSB.OnEvent("Click", this.SetFontStyleFN.Bind(this,"B"))
      this.GuiCtrlSetTip(MainBNSB, "Bold (Alt+B)")
      MainGui.SetFont("Norm Italic")
      MainBNSI := MainGui.AddButton("x+0 yp wp hp", "&I")
      MainBNSI.OnEvent("Click", this.SetFontStyleFN.Bind(this,"I"))
      this.GuiCtrlSetTip(MainBNSI, "Italic (Alt+I)")
      MainGui.SetFont("Norm Underline")
      MainBNSU := MainGui.AddButton("x+0 yp wp hp", "&U")
      MainBNSU.OnEvent("Click", this.SetFontStyleFN.Bind(this,"U"))
      this.GuiCtrlSetTip(MainBNSU, "Underline (Alt+U)")
      MainGui.SetFont("Norm Strike")
      MainBNSS := MainGui.AddButton("x+0 yp wp hp", "&S")
      MainBNSS.OnEvent("Click", this.SetFontStyleFN.Bind(this,"S"))
      this.GuiCtrlSetTip(MainBNSS, "Strikeout (Alt+S)")
      MainGui.SetFont("Norm", "Arial")
      MainBNSH := MainGui.AddButton("x+0 yp wp hp", "¯")
      MainBNSH.OnEvent("Click", this.SetFontStyleFN.Bind(this,"H"))
      this.GuiCtrlSetTip(MainBNSH, "Superscript (Ctrl+Shift+'+')")
      MainBNSL := MainGui.AddButton("x+0 yp wp hp", "_")
      MainBNSL.OnEvent("Click", this.SetFontStyleFN.Bind(this,"L"))
      this.GuiCtrlSetTip(MainBNSL, "Subscript (Ctrl+'+')")
      MainBNSN := MainGui.AddButton("x+0 yp wp hp", "&N")
      MainBNSN.OnEvent("Click", this.SetFontStyleFN.Bind(this,"N"))
      this.GuiCtrlSetTip(MainBNSN, "Normal (Alt+N)")
      MainBNTC := MainGui.AddButton("x+10 yp wp hp", "&T")
      MainBNTC.OnEvent("Click", this.TextColorFN.Bind(this,"Choose"))
      this.GuiCtrlSetTip(MainBNTC, "Text color (Alt+T)")
      MainColors := MainGui.AddProgress("x+0 yp wp hp BackgroundYellow cNavy Border", 50)
      MainBNBC := MainGui.AddButton("x+0 yp wp hp", "B")
      MainBNBC.OnEvent("Click", this.TextBkColorFN.Bind(this,"Choose"))
      this.GuiCtrlSetTip(this.MainBNBC, "Text backcolor")
      MainFNAME := MainGui.AddEdit("x+10 yp w150 hp ReadOnly", "")
      MainBNCF := MainGui.AddButton("x+0 yp w20 hp", "...")
      MainBNCF.OnEvent("Click", this.ChooseFontFN)
      this.GuiCtrlSetTip(this.MainBNCF, "Choose font")
      MainBNFP := MainGui.AddButton("x+5 yp wp hp", "&+")
      MainBNFP.OnEvent("Click", this.ChangeSize.Bind(1))
      this.GuiCtrlSetTip(this.MainBNFP, "Increase size (Alt+'+')")
      MainFSIZE := MainGui.AddEdit("x+0 yp w30 hp ReadOnly", "")
      MainBNFM := MainGui.AddButton("x+5 yp wp hp", "&-")
      MainBNFM.OnEvent("Click", this.ChangeSize.Bind(this,-1))
      this.GuiCtrlSetTip(this.MainBNFM, "Decrease size (Alt+'-')")
      ; RichEdit #1 ----------------------------------------------------------------------------------------------------------
      MainGui.SetFont("Bold Italic", "Arial")
      MainT1 := MainGui.AddText("x+10 yp hp", "WWWWWWWW")
      MainT1.GetPos(&TX := 0, &TY := 0, &TW := 0, &TH := 0)
      TX := this.EditW - TW + this.MarginX
      MainT1.Move(TX)
      MainGui.SetFont("Norm", "Arial")
      Options := "x" . TX . " y" . TY . " w" . TW . " h" . TH
      If !IsObject(RE1 := RichEdit(MainGui, Options, False))
         Throw("Could not create the RE1 RichEdit control!", -1)
      RE1.ReplaceSel("AaBbYyZz")
      RE1.AlignText("CENTER")
      RE1.SetOptions(["READONLY"], "SET")
      RE1.SetParaSpacing({Before: 2})
      ; Alignment & line spacing ---------------------------------------------------------------------------------------------
      MainGui.SetFont("Norm", "Arial")
      MainGui.AddText("0x1000 xm y+2 h2 w" this.EditW)
      MainBNAL := MainGui.AddButton("x10 y+1 w30 h20",  "|<")
      MainBNAL.OnEvent("Click", this.AlignFN.Bind(this,"Left"))
      this.GuiCtrlSetTip(this.MainBNAL, "Align left (Ctrl+L)")
      MainBNAC := MainGui.AddButton("x+0 yp wp hp", "><")
      MainBNAC.OnEvent("Click", this.AlignFN.Bind(this,"Center"))
      this.GuiCtrlSetTip(this.MainBNAC, "Align center (Ctrl+E)")
      MainBNAR := MainGui.AddButton("x+0 yp wp hp", ">|")
      MainBNAR.OnEvent("Click", this.AlignFN.Bind(this,"Right"))
      this.GuiCtrlSetTip(this.MainBNAR, "Align right (Ctrl+R)")
      MainBNAJ := MainGui.AddButton("x+0 yp wp hp", "|<>|")
      MainBNAJ.OnEvent("Click", this.AlignFN.Bind(this,"Justify"))
      this.GuiCtrlSetTip(this.MainBNAJ, "Align justified")
      MainBN10 := MainGui.AddButton("x+10 yp wp hp", "1")
      MainBN10.OnEvent("Click", this.SpacingFN.Bind(this,1.0))
      this.GuiCtrlSetTip(this.MainBN10, "Linespacing 1 line (Ctrl+1)")
      MainBN15 := MainGui.AddButton("x+0 yp wp hp", "1½")
      MainBN15.OnEvent("Click", this.SpacingFN.Bind(this,1.5))
      this.GuiCtrlSetTip(this.MainBN15, "Linespacing 1,5 lines (Ctrl+5)")
      MainBN20 := MainGui.AddButton("x+0 yp wp hp", "2")
      MainBN20.OnEvent("Click", this.SpacingFN.Bind(this,2.0))
      this.GuiCtrlSetTip(this.MainBN20, "Linespacing 2 lines (Ctrl+2)")
      ; RichEdit #2 ----------------------------------------------------------------------------------------------------------
      MainFNAME.Text := "Arial"
      MainFSIZE.Text := "10"
      this.MainGui.SetFont("s10", "Arial")
      Options := "xm y+5 w" this.EditW " r20"
      If !IsObject(RE2 := RichEdit(this.MainGui, Options))
         Throw("Could not create the RE2 RichEdit control!", -1)
      ; RE2.SetOptions(["SELECTIONBAR"])
      RE2.AutoURL(True)
      RE2.SetEventMask(["SELCHANGE", "LINK"])
      RE2.OnNotify(0x0702, this.RE2_SelChange)
      RE2.OnNotify(0x070B, this.RE2_Link)
      RE2.GetPos( , , &REW, &REH)
      this.MainGui.SetFont()
      ; The rest
      MainSB := this.MainGui.AddStatusbar()
      MainSB.SetParts(10, 200)
      this.MainGui.Show()
      RE2.Focus()
      this.UpdateGui()
      Return
   }

RE2_SelChange(RE, L) {
   SetTimer(this.UpdateGui, -10)
}
RE2_Link(RE, L) {
   If (NumGet(L, A_PtrSize * 3, "Int") = 0x0202) { ; WM_LBUTTONUP
      wParam  := NumGet(L, (A_PtrSize * 3) + 4, "UPtr")
      lParam  := NumGet(L, (A_PtrSize * 4) + 4, "UPtr")
      cpMin   := NumGet(L, (A_PtrSize * 5) + 4, "Int")
      cpMax   := NumGet(L, (A_PtrSize * 5) + 8, "Int")
      URLtoOpen := RE2.GetTextRange(cpMin, cpMax)
      ToolTip( "0x0202 - " wParam " - " lParam " - " cpMin " - " cpMax " - " URLtoOpen)
      Run( '"' URLtoOpen '"')
   }
}
; ----------------------------------------------------------------------------------------------------------------------
; UpdateGui:
UpdateGui() {
   Static FontName := "", FontCharset := 0, FontStyle := 0, FontSize := 0, TextColor := 0, TxBkColor := 0
   Local Font := RE2.GetFont()
   If (FontName != Font.Name || FontCharset != Font.CharSet || FontStyle != Font.Style || FontSize != Font.Size ||
      TextColor != Font.Color || TxBkColor != Font.BkColor) {
      FontStyle := Font.Style
      TextColor := Font.Color
      TxBkColor := Font.BkColor
      FontCharSet := Font.CharSet
      If (FontName != Font.Name) {
         FontName := Font.Name
         this.MainFNAME.Text := this.FontName
      }
      If (FontSize != Font.Size) {
         FontSize := Round(Font.Size)
         this.MainFSIZE.Text := FontSize
      }
      Font.Size := 8
      RE1.SetSel(0, -1) ; select all
      RE1.SetFont(Font)
      RE1.SetSel(0, 0)  ; deselect all
   }
   Local Stats := RE2.GetStatistics()
   this.MainSB.SetText(Stats.Line . " : " . Stats.LinePos . " (" . Stats.LineCount . ")  [" . Stats.CharCount . "]", 2)
}
; ======================================================================================================================
; Gui related
; ======================================================================================================================
; GuiClose:
MainGuiClose() {
   Global RE1, RE2
   If IsObject(RE1)
      RE1 := ""
   If IsObject(RE2)
      RE2 := ""
   this.MainGui.Destroy()
   ExitApp()
}
; ----------------------------------------------------------------------------------------------------------------------
; GuiSize:
MainGuiSize(GuiObj, MinMax, Width, Height) {
   Global GuiW, GuiH, REW, REH
   Critical()
   If (MinMax = 1)
      Return
   If (GuiW = 0) {
      GuiW := Width
      GuiH := Height
      Return
   }
   If (Width != GuiW || Height != GuiH) {
      REW += Width - GuiW
      REH += Height - GuiH
      RE2.Move( , , REW, REH)
      GuiW := Width
      GuiH := Height
   }
}
; ----------------------------------------------------------------------------------------------------------------------
; GuiContextMenu
MainContextMenu(GuiObj, GuiCtrlObj, *) {
   If (GuiCtrlObj = RE2)
      this.ContextMenu.Show()
}
; ======================================================================================================================
; Text operations
; ======================================================================================================================
; SetFontStyle
SetFontStyleFN(Style, GuiCtrl, *) {
   RE2.ToggleFontStyle(Style)
   this.UpdateGui()
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; ChangeSize
ChangeSize(IncDec, GuiCtrl, *) {
   Global FontSize := RE2.ChangeFontSize(IncDec)
   this.MainFSIZE.Text := Round(FontSize)
   RE2.Focus()
}
; ======================================================================================================================
; Menu File
; ======================================================================================================================
; FileAppend
; FileOpen
; FileInsert
FileLoadFN(Mode, *) {
   Global Open_File
   If (File := RichEditDlgs.FileDlg(RE2, "O")) {
      RE2.LoadFile(File, Mode)
      If (Mode = "O") {
         this.MainGui.Opt("+LastFound")
         Title := WinGetTitle()
         Title := StrSplit(Title, "-", " ")
         WinSetTitle(Title[1] . " - " . File)
         Open_File := File
      }
      this.UpdateGui()
   }
   RE2.SetModified()
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; FileClose
FileCloseFN() {
   Global Open_File
   If (Open_File) {
      If RE2.IsModified() {
         this.MainGui.Opt("+OwnDialogs")
         Switch MsgBox(35, "Close File", "Content has been modified!`nDo you want to save changes?") {
            Case "Cancel":
               RE2.Focus()
               Return
            Case "Yes":
               this.FileSaveFN()
         }
      }
      If RE2.SetText() {
         this.MainGui.Opt("+LastFound")
         Title := WinGetTitle()
         Title := StrSplit(Title, "-", " ")
         WinSetTitle(Title[1])
         Open_File := ""
      }
      this.UpdateGui()
   }
   RE2.SetModified()
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; FileSave
FileSaveFN() {
   If !(Open_File)
      Return this.FileSaveAsFN()
   RE2.SaveFile(Open_File)
   RE2.SetModified()
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; FileSaveAs:
FileSaveAsFN() {
   If (File := RichEditDlgs.FileDlg(RE2, "S")) {
      RE2.SaveFile(File)
      this.MainGui.Opt("+LastFound")
      Title := WinGetTitle()
      Title := StrSplit(Title, "-", " ")
      WinSetTitle(Title[1] . " - " . File)
      Global Open_File := File
   }
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; PageSetup
PageSetupFN() {
   RichEditDlgs.PageSetup(RE2)
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; Print
PrintFN() {
   RE2.Print()
   RE2.Focus()
}
; ======================================================================================================================
; Menu Edit
; ======================================================================================================================
; Undo
UndoFN() {
   RE2.Undo()
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; Redo
RedoFN() {
   RE2.Redo()
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; Cut
CutFN() {
   RE2.Cut()
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; Copy
CopyFN() {
   RE2.Copy()
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; Paste:
PasteFN() {
   RE2.Paste()
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; Clear
ClearFN() {
   RE2.Clear()
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; SelAll
SelAllFN() {
   RE2.SelAll()
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; Deselect
DeselectFN() {
   RE2.Deselect()
   RE2.Focus()
}
; ======================================================================================================================
; Menu View
; ======================================================================================================================
; WordWrap
WordWrapFN(Item, *) {
   Global WordWrap ^= True
   RE2.WordWrap(WordWrap)
   this.ViewMenu.ToggleCheck(Item)
   If (WordWrap)
      this.ViewMenu.Disable(this.MenuWysiwyg)
   Else
      this.ViewMenu.Enable(this.MenuWysiwyg)
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; Zoom
Zoom100FN() => this.ZoomFN(100, "100 %")
ZoomFN(Ratio, Item, *) {
   Global Zoom
   this.ZoomMenu.UnCheck(Zoom)
   Zoom := Item
   this.ZoomMenu.Check(Zoom)
   RE2.SetZoom(Ratio)
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; WYSIWYG
WYSIWYGFN(Item, *) {
   Global ShowWysiwyg ^= True
   If (ShowWysiwyg)
      this.Zoom100FN()
   RE2.WYSIWYG(ShowWysiwyg)
   this.ViewMenu.ToggleCheck(Item)
   If (ShowWysiwyg)
      this.ViewMenu.Disable(this.MenuWordWrap)
   Else
      this.ViewMenu.Enable(this.MenuWordWrap)
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; BackgroundColor
BackgroundColorFN(Mode, *) {
   BackColor := this.BackColor
   Switch Mode {
      Case "Auto":
         RE2.SetBkgndColor("Auto")
         RE2.BackColor := "Auto"
      Case "Choose":
         If RE2.BackColor != "Auto"
            Color := RE2.BackColor
         Else
            Color := RE2.GetRGB(DllCall("GetSysColor", "Int", 5, "UInt")) ; COLOR_WINDOW
         NC := RichEditDlgs.ChooseColor(RE2, Color)
         If (NC != "") {
            RE2.SetBkgndColor(NC)
            RE2.BackColor := NC
         }
   }
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; AutoURLDetection
AutoURLDetectionFN(ItemName, ItemPos, MenuObj) {
   RE2.AutoURL(AutoURL ^= True)
   MenuObj.ToggleCheck(ItemName)
   RE2.Focus()
}
; ======================================================================================================================
; Menu Character
; ======================================================================================================================
; ChooseFont
ChooseFontFN() {
   Global FontName, FontSize
   RichEditDlgs.ChooseFont(RE2)
   Font := RE2.GetFont()
   FontName := Font.Name
   FontSize := Font.Size
   this.MainFNAME.Text := this.FontName
   this.MainFSIZE.Text := Round(this.FontSize)
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; MTextColor    ; menu label
; BTextColor    ; button label
TextColorFN(Mode, *) {
   TextColor := this.TextColor
   Switch Mode {
      Case "Auto":
         RE2.SetFont({Color: "Auto"})
         RE2.TextColor := "Auto"
      Case "Choose":
         If RE2.TextColor != "Auto"
            Color := RE2.TextColor
         Else
            Color := RE2.GetRGB(DllCall("GetSysColor", "Int", 8, "UInt")) ; COLOR_WINDOWTEXT
         NC := RichEditDlgs.ChooseColor(RE2, Color)
         If (NC != "") {
            RE2.SetFont({Color: NC})
            RE2.TextColor := NC
         }
   }
   this.UpdateGui()
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; MTextBkColor  ; menu label
; BTextBkColor  ; button label
TextBkColorFN(Mode, *) {
   TextBkColor := this.TextBkColor
   Switch Mode {
      Case "Auto":
         RE2.SetFont({BkColor: "Auto"})
      Case "Choose":
         If RE2.TxBkColor != "Auto"
            Color := RE2.TxBkColor
         Else
            Color := RE2.GetRGB(DllCall("GetSysColor", "Int", 5, "UInt")) ; COLOR_WINDOW
         NC := RichEditDlgs.ChooseColor(RE2, Color)
         If (NC != "") {
            RE2.SetFont({BkColor: NC})
            RE2.TxBkColor := NC
         }
   }
   this.UpdateGui()
   RE2.Focus()
}
; ======================================================================================================================
; Menu Paragraph
; ======================================================================================================================
; AlignLeft
; AlignCenter
; AlignRight:
; AlignJustify
AlignFN(Alignment, *) {
   Static Align := {Left: 1, Right: 2, Center: 3, Justify: 4}
   If Align.HasProp(Alignment)
      RE2.AlignText(Align.%Alignment%)
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
IndentationFN(Mode, *) {
   Switch Mode {
      Case "Set": this.ParaIndentGui(RE2)
      Case "Reset": RE2.SetParaIndent()
   }
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; Numbering
NumberingFN(Mode, *) {
   Switch Mode {
      Case "Set": this.ParaNumberingGui(RE2)
      Case "Reset": RE2.SetParaNumbering()
   }
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; ParaSpacing
; ResetParaSpacing
ParaSpacingFN(Mode, *) {
   Switch Mode {
      Case "Set": this.ParaSpacingGui(RE2)
      Case "Reset": RE2.SetParaSpacing()
   }
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; Spacing10
; Spacing15
; Spacing20
SpacingFN(Val, *) {
   RE2.SetLineSpacing(Val)
   RE2.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
; SetTabStops
; ResetTabStops
; SetDefTabs
SetTabStopsFN(Mode, *) {
   Switch Mode {
      Case "Set": this.SetTabStopsGui(RE2)
      Case "Reset": RE2.SetTabStops()
      Case "Default": RE2.SetDefaultTabs(1)
   }
   RE2.Focus()
}
; ======================================================================================================================
; Menu Search
; ======================================================================================================================
FindFN() {
   RichEditDlgs.FindText(RE2)
}
; ----------------------------------------------------------------------------------------------------------------------
ReplaceFN() {
   RichEditDlgs.ReplaceText(RE2)
}
; ======================================================================================================================
; ParaIndentation GUI
; ======================================================================================================================
ParaIndentGui(RE) {
   Static Owner := "",
          Success := False
   Metrics := RE.GetMeasurement()
   PF2 := RE.GetParaFormat()
   Owner := RE.Gui.Hwnd
   ParaIndentGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Paragraph Indentation")
   ParaIndentGui.OnEvent("Close", ParaIndentGuiClose)
   ParaIndentGui.MarginX := 20
   ParaIndentGui.MarginY := 10
   ParaIndentGui.AddText("Section h20 0x200", "First line left indent (absolute):")
   ParaIndentGui.AddText("xs hp 0x200", "Other lines left indent (relative):")
   ParaIndentGui.AddText("xs hp 0x200", "All lines right indent (absolute):")
   EDLeft1 := ParaIndentGui.AddEdit("ys hp Limit5")
   EDLeft2 := ParaIndentGui.AddEdit("hp Limit6")
   EDRight := ParaIndentGui.AddEdit("hp Limit5")
   CBStart := ParaIndentGui.AddCheckBox("ys x+5 hp", "Apply")
   CBOffset := ParaIndentGui.AddCheckBox("hp", "Apply")
   CBRight := ParaIndentGui.AddCheckBox("hp", "Apply")
   Left1 := Round((PF2.StartIndent / 1440) * Metrics, 2)
   If (Metrics = 2.54)
      Left1 := RegExReplace(Left1, "\.", ",")
   EDLeft1.Text := Left1
   Left2 := Round((PF2.Offset / 1440) * Metrics, 2)
   If (Metrics = 2.54)
      Left2 := RegExReplace(Left2, "\.", ",")
   EDLeft2.Text := Left2
   Right := Round((PF2.RightIndent / 1440) * Metrics, 2)
   If (Metrics = 2.54)
      Right := RegExReplace(Right, "\.", ",")
   EDRight.Text := Right
   BN1 := ParaIndentGui.AddButton("xs", "Apply")
   BN1.OnEvent("Click", ParaIndentGuiApply)
   BN2 := ParaIndentGui.AddButton("x+10 yp", "Cancel")
   BN2.OnEvent("Click", ParaIndentGuiClose)
   BN2.GetPos( , , &BW := 0)
   BN1.Move( , , BW)
   CBRight.GetPos(&CX := 0, , &CW := 0)
   BN2.Move(CX + CW - BW)
   RE.Gui.Opt("+Disabled")
   ParaIndentGui.Show()
   WinWaitActive()
   WinWaitClose()
   Return Success
   ; -------------------------------------------------------------------------------------------------------------------
   ParaIndentGuiClose() {
      Success := False
      RE.Gui.Opt("-Disabled")
      ParaIndentGui.Destroy()
   }
   ; -------------------------------------------------------------------------------------------------------------------
   ParaIndentGuiApply() {
      ApplyStart := CBStart.Value
      ApplyOffset := CBOffset.Value
      ApplyRight := CBRight.Value
      Indent := {}
      If ApplyStart {
         Start := EDLeft1.Text
         If (Start = "")
            Start := 0
         If !RegExMatch(Start, "^\d{1,2}((\.|,)\d{1,2})?$") {
            EDLeft1.Text := ""
            EDLeft1.Focus()
            Return
         }
         Indent.Start := StrReplace(Start, ",", ".")
      }
      If (ApplyOffset) {
         Offset := EDLeft2.Text
         If (Offset = "")
            Offset := 0
         If !RegExMatch(Offset, "^(-)?\d{1,2}((\.|,)\d{1,2})?$") {
            EDLeft2.Text := ""
            EDLeft2.Focus()
            Return
         }
         Indent.Offset := StrReplace(Offset, ",", ".")
      }
      If (ApplyRight) {
         Right := EDRight.Text
         If (Right = "")
            Right := 0
         If !RegExMatch(Right, "^\d{1,2}((\.|,)\d{1,2})?$") {
            EDRight.Text := ""
            EDRight.Focus()
            Return
         }
         Indent.Right := StrReplace(Right, ",", ".")
      }
      Success := RE.SetParaIndent(Indent)
      RE.Gui.Opt("-Disabled")
      ParaIndentGui.Destroy()
   }
}
; ======================================================================================================================
; ParaNumbering GUI
; ======================================================================================================================
ParaNumberingGui(RE) {
   Static Owner := "",
          Bullet := "•",
          StyleArr := ["1)", "(1)", "1.", "1", "w/o"],
          TypeArr := [Bullet, "0, 1, 2", "a, b, c", "A, B, C", "i, ii, iii", "I, I, III"],
          PFN := ["Bullet", "Arabic", "LCLetter", "UCLetter", "LCRoman", "UCRoman"],
          PFNS := ["Paren", "Parens", "Period", "Plain", "None"],
          Success := False
   Metrics := RE.GetMeasurement()
   PF2 := RE.GetParaFormat()
   Owner := RE.Gui.Hwnd
   ParaNumberingGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Paragraph Numbering")
   ParaNumberingGui.OnEvent("Close", ParaNumberingGuiClose)
   ParaNumberingGui.MarginX := 20
   ParaNumberingGui.MarginY := 10
   ParaNumberingGui.AddText("Section h20 w100 0x200", "Type:")
   DDLType := ParaNumberingGui.AddDDL("xp y+0 wp AltSubmit", TypeArr)
   If (PF2.Numbering)
      DDLType.Choose(PF2.Numbering)
   ParaNumberingGui.AddText("xs h20 w100 0x200", "Start with:")
   EDStart := ParaNumberingGui.AddEdit("y+0 wp hp Limit5", PF2.NumberingStart)
   ParaNumberingGui.AddText("ys h20 w100 0x200", "Style:")
   DDLStyle := ParaNumberingGui.AddDDL("y+0 wp AltSubmit Choose1", StyleArr)
   If (PF2.NumberingStyle)
      DDLStyle.Choose((PF2.NumberingStyle // 0x0100) + 1)
   ParaNumberingGui.AddText("h20 w100 0x200", "Distance:  (" . (Metrics = 1.00 ? "in." : "cm") . ")")
   EDDist := ParaNumberingGui.AddEdit("y+0 wp hp Limit5")
   Tab := Round((PF2.NumberingTab / 1440) * Metrics, 2)
   If (Metrics = 2.54)
      Tab := RegExReplace(Tab, "\.", ",")
   EDDist.Text := Tab
   BN1 := ParaNumberingGui.AddButton("xs", "Apply") ; gParaNumberingGuiApply hwndhBtn1, Apply
   BN1.OnEvent("Click", ParaNumberingGuiApply)
   BN2 := ParaNumberingGui.AddButton("x+10 yp", "Cancel") ;  gParaNumberingGuiClose hwndhBtn2, Cancel
   BN2.OnEvent("Click", ParaNumberingGuiClose)
   BN2.GetPos( , , &BW := 0)
   BN1.Move( , , BW)
   DDLStyle.GetPos(&DX := 0, , &DW := 0)
   BN2.Move(DX + DW - BW)
   RE.Gui.Opt("+Disabled")
   ParaNumberingGui.Show()
   WinWaitActive()
   WinWaitClose()
   Return Success
   ; -------------------------------------------------------------------------------------------------------------------
   ParaNumberingGuiClose() {
      Success := False
      RE.Gui.Opt("-Disabled")
      ParaNumberingGui.Destroy()
   }
   ; -------------------------------------------------------------------------------------------------------------------
   ParaNumberingGuiApply() {
      Type := DDLType.Value
      Style := DDLStyle.Value
      Start := EDStart.Text
      Tab := EDDist.Text
      If !RegExMatch(Tab, "^\d{1,2}((\.|,)\d{1,2})?$") {
         EDDist.Text := ""
         EDDist.Focus()
         Return
      }
      Numbering := {Type: PFN[Type], Style: PFNS[Style]}
      Numbering.Tab := RegExReplace(Tab, ",", ".")
      Numbering.Start := Start
      Success := RE.SetParaNumbering(Numbering)
      RE.Gui.Opt("-Disabled")
      ParaNumberingGui.Destroy()
   }
}
; ======================================================================================================================
; ParaSpacing GUI
; ======================================================================================================================
ParaSpacingGui(RE) {
   Static Owner := "",
          Success := False
   PF2 := RE.GetParaFormat()
   Owner := RE.Gui.Hwnd
   ParaSpacingGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Paragraph Spacing") ; +LabelParaSpacingGui
   ParaSpacingGui.OnEvent("Close", ParaSpacingGuiClose)
   ParaSpacingGui.MarginX := 20
   ParaSpacingGui.MarginY := 10
   ParaSpacingGui.AddText("Section h20 0x200", "Space before in points:")
   ParaSpacingGui.AddText("xs y+10 hp 0x200", "Space after in points:")
   EDBefore := ParaSpacingGui.AddEdit("ys hp Number Limit2 Right", "00")
   EDBefore.Text := PF2.SpaceBefore // 20
   EDAfter := ParaSpacingGui.AddEdit("xp y+10 hp Number Limit2 Right", "00")
   EDAfter.Text := PF2.SpaceAfter // 20
   BN1 := ParaSpacingGui.AddButton("xs", "Apply")
   BN1.OnEvent("Click", ParaSpacingGuiApply)
   BN2 := ParaSpacingGui.AddButton("x+10 yp", "Cancel")
   BN2.OnEvent("Click", ParaSpacingGuiClose)
   BN2.GetPos( , ,&BW := 0)
   BN1.Move( , ,BW)
   EDAfter.GetPos(&EX := 0, , &EW := 0)
   X := EX + EW - BW
   BN2.Move(X)
   RE.Gui.Opt("+Disabled")
   ParaSpacingGui.Show()
   WinWaitActive()
   WinWaitClose()
   Return Success
   ; -------------------------------------------------------------------------------------------------------------------
   ParaSpacingGuiClose() {
      Success := False
      RE.Gui.Opt("-Disabled")
      ParaSpacingGui.Destroy()
   }
   ; -------------------------------------------------------------------------------------------------------------------
   ParaSpacingGuiApply() {
      Before := EDBefore.Text
      After := EDAfter.Text
      Success := RE.SetParaSpacing({Before: Before, After: After})
      RE.Gui.Opt("-Disabled")
      ParaSpacingGui.Destroy()
   }
}
; ======================================================================================================================
; SetTabStops GUI
; ======================================================================================================================
SetTabStopsGui(RE) {
   ; Set paragraph's tabstobs
   ; Call with parameter mode = "Reset" to reset to default tabs
   ; EM_GETPARAFORMAT = 0x43D, EM_SETPARAFORMAT = 0x447
   ; PFM_TABSTOPS = 0x10
   Static Owner   := "",
          Metrics := 0,
          MinTab  := 0.30,     ; minimal tabstop in inches
          MaxTab  := 8.30,     ; maximal tabstop in inches
          AL := 0x00000000,    ; left aligned (default)
          AC := 0x01000000,    ; centered
          AR := 0x02000000,    ; right aligned
          AD := 0x03000000,    ; decimal tabstop
          Align := {0x00000000: "L", 0x01000000: "C", 0x02000000: "R", 0x03000000: "D"},
          TabCount := 0,       ; tab count
          MAX_TAB_STOPS := 32,
          Success := False     ; return value
   Metrics := RE.GetMeasurement()
   PF2 := RE.GetParaFormat()
   TabCount := PF2.TabCount
   Tabs := []
   Tabs.Length := PF2.Tabs.Length
   For I, V In PF2.Tabs
      Tabs[I] := [Format("{:.2f}", Round(((V & 0x00FFFFFF) * Metrics) / 1440, 2)), V & 0xFF000000]
   Owner := RE.Gui.Hwnd
   SetTabStopsGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Set Tabstops")
   SetTabStopsGui.OnEvent("Close", SetTabStopsGuiClose)
   SetTabStopsGui.MarginX := 10
   SetTabStopsGui.MarginY := 10
   SetTabStopsGui.AddText("Section", "Position: (" . (Metrics = 1.00 ? "in." : "cm") . ")")
   CBBTabs := SetTabStopsGui.AddComboBox("xs y+2 w120 r6 Simple +0x800 AltSubmit")
   CBBTabs.OnEvent("Change", SetTabStopsGuiSelChanged)
   If (TabCount) {
      For T In Tabs {
         I := SendMessage(0x0143, 0, StrPtr(T[1]), CBBTabs.Hwnd)  ; CB_ADDSTRING
         SendMessage(0x0151, I, T[2], CBBTabs.Hwnd)               ; CB_SETITEMDATA
      }
   }
   SetTabStopsGui.AddText("ys Section", "Alignment:")
   RBL := SetTabStopsGui.AddRadio("xs w60 Section y+2 Checked Group", "Left")
   RBC := SetTabStopsGui.AddRadio("wp", "Center")
   RBR := SetTabStopsGui.AddRadio("ys wp", "Right")
   RBD := SetTabStopsGui.AddRadio("wp", "Decimal")
   BNAdd := SetTabStopsGui.AddButton("xs Section w60 Disabled", "&Add")
   BNAdd.OnEvent("Click", SetTabStopsGuiAdd)
   BNRem := SetTabStopsGui.AddButton("ys w60 Disabled", "&Remove")
   BNRem.OnEvent("Click", SetTabStopsGuiRemove)
   BNAdd.GetPos(&X1 := 0)
   BNRem.GetPos(&X2 := 0, , &W2 := 0)
   W := X2 + W2 - X1
   BNClr := SetTabStopsGui.AddButton("xs w" . W, "&Clear all")
   BNClr.OnEvent("Click", SetTabStopsGuiRemoveAll)
   SetTabStopsGui.AddText("xm h5")
   BNApply := SetTabStopsGui.AddButton("xm y+0 w60", "&Apply")
   BNApply.OnEvent("Click", SetTabStopsGuiApply)
   X := X2 + W2 - 60
   BNCancel := SetTabStopsGui.AddButton("x" . X . " yp wp", "&Cancel")
   BNCancel.OnEvent("Click", SetTabStopsGuiClose)
   RE.Gui.Opt("+Disabled")
   SetTabStopsGui.Show()
   WinWaitActive()
   WinWaitClose()
   Return Success
   ; -------------------------------------------------------------------------------------------------------------------
   SetTabStopsGuiClose() {
      Success := False
      RE.Gui.Opt("-Disabled")
      SetTabStopsGui.Destroy()
   }
   ; -------------------------------------------------------------------------------------------------------------------
   SetTabStopsGuiSelChanged() {
      If (TabCount < MAX_TAB_STOPS)
         BNAdd.Enabled := !!RegExMatch(CBBTabs.Text, "^\d*[.,]?\d+$")
      If !(I := CBBTabs.Value) {
         BNRem.Enabled := False
         Return
      }
      BNRem.Enabled := True
      A := SendMessage(0x0150, I - 1, 0, CBBTabs.Hwnd) ; CB_GETITEMDATA
      C := A = AC ? RBC : A = AR ? RBR : A = AD ? RBD : RBl
      C.Value := 1
   }
   ; -------------------------------------------------------------------------------------------------------------------
   SetTabStopsGuiAdd() {
      T := CBBTabs.Text
      If !RegExMatch(T, "^\d*[.,]?\d+$") {
         CBBTabs.Focus()
         Return
      }
      T := Round(StrReplace(T, ",", "."), 2)
      RT := Round(T / Metrics, 2)
      If (RT < MinTab) || (RT > MaxTab){
         CBBTabs.Focus()
         Return
      }
      A := RBC.Value ? AC : RBR.Value ? AR : RBD.Value ? AD : AL
      TabArr := ControlGetItems(CBBTabs.Hwnd)
      P := -1
      T := Format("{:.2f}", T)
      For I, V In TabArr {
         If (T < V) {
            P := I - 1
            Break
         }
         IF (T = V) {
            P := I - 1
            CBBTabs.Delete(I)
            Break
         }
      }
      I := SendMessage(0x014A, P, StrPtr(T), CBBTabs.Hwnd)  ; CB_INSERTSTRING
      SendMessage(0x0151, I, A, CBBTabs.Hwnd)               ; CB_SETITEMDATA
      TabCount++
      If !(TabCount < MAX_TAB_STOPS)
         BNAdd.Enabled := False
      CBBTabs.Text := ""
      CBBTabs.Focus()
   }
   ; -------------------------------------------------------------------------------------------------------------------
   SetTabStopsGuiRemove() {
      If (I := CBBTabs.Value) {
         CBBTabs.Delete(I)
         CBBTabs.Text := ""
         TabCount--
         RBL.Value := 1
      }
      CBBTabs.Focus()
   }
   ; -------------------------------------------------------------------------------------------------------------------
   SetTabStopsGuiRemoveAll() {
      CBBTabs.Text := ""
      CBBTabs.Delete()
      RBL.Value := 1
      CBBTabs.Focus()
   }
   ; -------------------------------------------------------------------------------------------------------------------
   SetTabStopsGuiApply() {
      TabCount := SendMessage(0x0146, 0, 0, CBBTabs.Hwnd) << 32 >> 32 ; CB_GETCOUNT
      If (TabCount < 1)
         Return
      TabArr := ControlGetItems(CBBTabs.HWND)
      TabStops := {}
      For I, T In TabArr {
         Alignment := Format("0x{:08X}", SendMessage(0x0150, I - 1, 0, CBBTabs.HWND)) ; CB_GETITEMDATA
         TabPos := Format("{:i}", T * 100)
         TabStops.%TabPos% := Align.%Alignment%
      }
      Success := RE.SetTabStops(TabStops)
      RE.Gui.Opt("-Disabled")
      SetTabStopsGui.Destroy()
   }
}
; ======================================================================================================================
; Sets multi-line tooltips for any Gui control.
; Parameters:
;     GuiCtrl     -  A Gui.Control object
;     TipText     -  The text for the tooltip. If you pass an empty string for a formerly added control,
;                    its tooltip will be removed.
;     UseAhkStyle -  If set to true, the tooltips will be shown using the visual styles of AHK ToolTips.
;                    Otherwise, the current theme settings will be used.
;                    Default: True
;     CenterTip   -  If set to true, the tooltip will be shown centered below/above the control.
;                    Default: False
;  Return values:
;     True on success, otherwise False.
; Remarks:
;     Text and Picture controls require the SS_NOTIFY (+0x0100) style.
; MSDN:
;     https://learn.microsoft.com/en-us/windows/win32/controls/tooltip-control-reference
; ======================================================================================================================
GuiCtrlSetTip(GuiCtrl, TipText, UseAhkStyle := True, CenterTip := False) {
   Static SizeOfTI := 24 + (A_PtrSize * 6)
   Static Tooltips := Map()
   Local Flags, HGUI, HCTL, HTT, TI
   ; Check the passed GuiCtrl
   If !(GuiCtrl Is Gui.Control)
      Return False
   HGUI := GuiCtrl.Gui.Hwnd
   ; Create the TOOLINFO structure -> msdn.microsoft.com/en-us/library/bb760256(v=vs.85).aspx
   Flags := 0x11 | (CenterTip ? 0x02 : 0x00) ; TTF_SUBCLASS | TTF_IDISHWND [| TTF_CENTERTIP]
   TI := Buffer(SizeOfTI, 0)
   NumPut("UInt", SizeOfTI, "UInt", Flags, "UPtr", HGUI, "UPtr", HGUI, TI) ; cbSize, uFlags, hwnd, uID
   ; Create a tooltip control for this Gui, if needed
   If !ToolTips.Has(HGUI) {
      If !(HTT := DllCall("CreateWindowEx", "UInt", 0, "Str", "tooltips_class32", "Ptr", 0, "UInt", 0x80000003
                                          , "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000
                                          , "Ptr", HGUI, "Ptr", 0, "Ptr", 0, "Ptr", 0, "UPtr"))
         Return False
      If (UseAhkStyle)
         DllCall("Uxtheme.dll\SetWindowTheme", "Ptr", HTT, "Ptr", 0, "Ptr", 0)
      SendMessage(0x0432, 0, TI.Ptr, HTT) ; TTM_ADDTOOLW
      Tooltips[HGUI] := {HTT: HTT, Ctrls: Map()}
   }
   HTT := Tooltips[HGUI].HTT
   HCTL := GuiCtrl.HWND
   ; Add / remove a tool for this control
   NumPut("UPtr", HCTL, TI, 8 + A_PtrSize) ; uID
   NumPut("UPtr", HCTL, TI, 24 + (A_PtrSize * 4)) ; uID
   If !Tooltips[HGUI].Ctrls.Has(HCTL) { ; add the control
      If (TipText = "")
         Return False
      SendMessage(0x0432, 0, TI.Ptr, HTT) ; TTM_ADDTOOLW
      SendMessage(0x0418, 0, -1, HTT) ; TTM_SETMAXTIPWIDTH
      Tooltips[HGUI].Ctrls[HCTL] := True
   }
   Else If (TipText = "") { ; remove the control
      SendMessage(0x0433, 0, TI.Ptr, HTT) ; TTM_DELTOOLW
      Tooltips[HGUI].Ctrls.Delete(HCTL)
      Return True
   }
   ; Set / Update the tool's text.
   NumPut("UPtr", StrPtr(TipText), TI, 24 + (A_PtrSize * 3))  ; lpszText
	SendMessage(0x0439, 0, TI.Ptr, HTT) ; TTM_UPDATETIPTEXTW
	Return True
}
}
; ======================================================================================================================
; End of auto-execute section
; ======================================================================================================================
; Testing >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
^+1:: {
   RC := Buffer(16, 0)
   DllCall("SendMessage", "Ptr", RE2.HWND, "UInt", 0x00B2, "Ptr", 0, "Ptr", RC.Ptr) ; EM_GETRECT
   CharIndex := DllCall("SendMessage", "Ptr", RE2.HWND, "UInt", 0x00D7, "Ptr", 0, "Ptr", RC.Ptr, "Ptr") ; EM_CHARFROMPOS
   LineIndex := DllCall("SendMessage", "Ptr", RE2.HWND, "UInt", 0x0436, "Ptr", 0, "Ptr", Charindex, "Ptr") ; EM_EXLINEFROMCHAR
   MsgBox("First visible line = " . LineIndex)
}
^+f:: {
   CS := RE2.GetSel()
   SP := RE2.GetScrollPos()
   RE2.Opt("-Redraw")
   CF2 := RichEdit.CHARFORMAT2()
;    CF2 := RE2.GetCharFormat()                   ; retrieve a CHARFORMAT2 object for the current selection
   CF2.Mask := 0x40000001                       ; CFM_COLOR = 0x40000000, CFM_BOLD = 0x00000001
   CF2.TextColor := 0xFF0000                    ; colors are BGR
   CF2.Effects := 0x01                          ; CFE_BOLD := 0x00000001
   RE2.SetSel(0, 0)                             ; start searching at the begin of the text
   While (RE2.FindText("Lorem", ["Down"]) != 0) ; find the specific phrase
      RE2.SetCharFormat(CF2)                    ; apply the new settings
   CF2 := ""
   RE2.SetScrollPos(SP.X, SP.Y)
   RE2.SetSel(CS.X, CS.Y)
   RE2.Opt("+Redraw")
}
^+l:: {
   Sel := DllCall("SendMessage", "Ptr", RE2.HWND, "UInt", 0x00BB, "Ptr", 18, "Ptr", 0, "Ptr")
   RE2.SetSel(Sel, Sel)
   RE2.ScrollCaret()
}
^+b:: {
   RE2.SetBorder([10], [2])
}
; ----------------------------------------------------------------------------------------------------------------------
#HotIf RE2.Focused
; FontStyles
^!b::  ; bold
^!h::  ; superscript
^!i::  ; italic
^!l::  ; subscript
^!n::  ; normal
^!p::  ; protected
^!s::  ; strikeout
^!u::  ; underline
{
   RE2.ToggleFontStyle(SubStr(A_ThisHotkey, 3))
   RTEdit.UpdateGui()
}
#HotIf
; ======================================================================================================================
; Testing <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; ----------------------------------------------------------------------------------------------------------------------