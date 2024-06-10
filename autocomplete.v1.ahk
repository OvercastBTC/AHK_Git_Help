#Requires AutoHotkey v1.1.37 
; Create a COM object 
comObj := ComObjCreate("Shell.Application")

; CLSID of Shell AutoComplete Object
CLSID_AutoComplete := "{00BB2763-6A77-11D0-A535-00C04FD7D062}"

; IID of iAutoComplete interface
IID_iAutoComplete := "{00BB2764-6A77-11D0-A535-00C04FD7D062}"

; Get the iAutoComplete interface
; autoComplete := comObj.QueryInterface("{00bb2763-6a77-11d0-a535-00c04fd7d062}", "{00bb2764-6a77-11d0-a535-00c04fd7d062}")
autoComplete := comObj.QueryInterface(CLSID_AutoComplete, IID_iAutoComplete)

; Now you can use methods of iAutoComplete
; For example, to enable AutoComplete for a specific control (hwndEdit):
hwndEdit := ; specify your control's hwnd here
autoComplete.Init(hwndEdit, ComObjParameter(0, 0, 0))

; Release the COM object when done
autoComplete := ""


; Create an instance of the Shell AutoComplete Object
if (DllCall("ole32\CoCreateInstance", "ptr", &CLSID_AutoComplete, "ptr", 0, "uint", 1, "ptr", &IID_iAutoComplete, "ptr*", pAutoComplete) == 0) {
    ; Now, pAutoComplete holds the iAutoComplete interface
    ; Use it as needed

    ; For example, release the interface when done
    ; DllCall("ole32\CoTaskMemFree", "ptr", pAutoComplete)
} else {
    MsgBox, Failed to create AutoComplete instance.
}