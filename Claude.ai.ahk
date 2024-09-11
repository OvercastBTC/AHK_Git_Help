#Requires AutoHotkey v2.0

; VSCode Claude Integration Extension

; Global variables
global API_KEY := "YOUR_API_KEY_HERE"
global API_URL := "https://api.anthropic.com/v1/messages"

; Main hotkey to trigger Claude interaction
^!c:: ; Ctrl+Alt+C
{
    if (WinActive("ahk_exe Code.exe"))
    {
        selected_text := GetSelectedText()
        if (selected_text != "")
        {
            response := QueryClaude(selected_text)
            InsertTextInVSCode(response)
        }
        else
        {
            MsgBox("Please select some text in VSCode before triggering Claude.")
        }
    }
}

GetSelectedText()
{
    A_Clipboard := "" ; Clear clipboard
    Send("^c") ; Copy selected text
    ClipWait(2)
    return A_Clipboard
}

QueryClaude(prompt)
{
    headers := "Content-Type: application/json`nX-API-Key: " . API_KEY

    payload := '
    (
    {
        "messages": [
            {
                "role": "user",
                "content": "' . prompt . '"
            }
        ],
        "model": "claude-3-opus-20240229",
        "max_tokens": 1000
    }
    )'

    response := ""
    try
    {
        whr := ComObject("WinHttp.WinHttpRequest.5.1")
        whr.Open("POST", API_URL, true)
        whr.SetRequestHeader("Content-Type", "application/json")
        whr.SetRequestHeader("X-API-Key", API_KEY)
        whr.Send(payload)
        whr.WaitForResponse()
        response := whr.ResponseText
    }
    catch as err
    {
        MsgBox("Error querying Claude API: " . err.Message)
        return ""
    }

    ; Parse JSON response and extract content
    parsed := JSON.Parse(response)
    return parsed.content[1].text
}

InsertTextInVSCode(text)
{
    A_Clipboard := text
    Send("^v") ; Paste the response
}

; JSON parsing library (simplified for this example)
class JSON {
    static Parse(text) {
        try {
            return JSON.Loads(&text)
        }
    }

    static Loads(&text) {
        ; This is a placeholder for actual JSON parsing
        ; In a real implementation, you'd need a full JSON parser here
        return {content: [{text: text}]}
    }
}