#Requires Autohotkey v2.0.10+
#Include <Directives\__AE.v2>
; #Include <AutoComplete.v2>
; Create a COM object 
; comObj := ComObject("Shell.Application")

; CLSID of Shell AutoComplete Object
; CLSID_AutoComplete := "{00BB2763-6A77-11D0-A535-00C04FD7D062}"

; IID of iAutoComplete interface
; IID_iAutoComplete := "{00BB2764-6A77-11D0-A535-00C04FD7D062}"

; Get the iAutoComplete interface
; autoComplete := comObj.QueryInterface("{00bb2763-6a77-11d0-a535-00c04fd7d062}", "{00bb2764-6a77-11d0-a535-00c04fd7d062}")

; autoComoplete := comObj.
; autoComplete := comObj.QueryInterface(CLSID_AutoComplete, IID_iAutoComplete)

; Now you can use methods of iAutoComplete
; For example, to enable AutoComplete for a specific control (hwndEdit):

ToolTip()
CoordMode("Mouse", "Screen")
SetTimer(AutoComp,500)
autocomp(){
    hwndEdit := "" ; specify your control's hwnd here
    x := y := 0
    WinA := ''
    fCtl := 0
    try {
        ; fCtl := ControlGetFocus('A')
        CaretGetPos(&x, &y)
        cHwnd := dllcall('user32\WindowFromPoint', 'uint', x, 'uint', y)
        fCtl := ControlGetFocus(cHwnd)
        ClassNN := ControlGetClassNN(fCtl)
        ; MouseGetPos(&x, &y, &winA, &fCtl)
        ToolTip('x: ' x ' y: ' y '`n' 'Win: ' WinA '`n' 'Control: ' ClassNN '(' fCtl ')',0,0 )
        hwndEdit := fCtl
        hEdit := fCtl
        ; autocomplete := DllCall('shlwapi\SHAutoComplete', 'ptr', hwndEdit, 'int', 0)
        ; ; autoComplete.Init(hwndEdit, ComObjParameter(0, 0, 0))
        ; autoComplete.Init(hwndEdit, ComObjActive(CLSID_AutoComplete))
        SHAutoComplete(fCtl)
        SHAutoComplete(hEdit) {
            DllCall("ole32\CoInitialize", "Uint", 0)
            DllCall("shlwapi\SHAutoComplete", "Uint", hEdit, "Uint", 128)
            DllCall("ole32\CoUninitialize")
        }
    }
}
; Release the COM object when done
; autoComplete := ""

; ; Create an instance of the Shell AutoComplete Object
; if (DllCall("ole32\CoCreateInstance", "ptr", (StrSplit(CLSID_AutoComplete,'{}')), "ptr", 0, "uint", 1, "ptr", IID_iAutoComplete, "ptr*", &pAutoComplete) == 0) {
;     ; Now, pAutoComplete holds the iAutoComplete interface
;     ; Use it as needed

;     ; For example, release the interface when done
;     ; DllCall("ole32\CoTaskMemFree", "ptr", pAutoComplete)
; } else {
;     MsgBox("Failed to create AutoComplete instance.")
; }