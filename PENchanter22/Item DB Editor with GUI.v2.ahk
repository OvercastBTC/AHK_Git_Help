#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir

#Include <Includes\ObjectTypeExtensions>

#HotIf WinActive(A_ScriptName)
~^s::Reload()
#HotIf

; class PaliaDatabase {
;     static GameName := "Palia"
;     static DatabaseINIversion := "v2.0"
;     static GUITitle := "Database Editing GUI v2.0"
    
;     static DB := {}
;     static DBArrayString := []
;     static TempItem := {}
	
; 	static __New() {
; 		this.InitializeVariables()
; 		this.CreateGUI()
; 	}
	
; 	static InitializeVariables() {
; 		this.DatabaseINIfile := A_ScriptDir "\INI\" PaliaDatabase.GameName " Item Database " PaliaDatabase.DatabaseINIversion ".ini"
; 		this.DatabaseSection := PaliaDatabase.GameName " - Items"
; 		this.GUIshowX := 1348
; 		this.GUIshowY := 141
; 		this.GUIshowW := 500
; 		this.GroupBoxW := this.GUIshowW - 20
; 		this.GroupBoxH := 203 + 30 + 10
; 		this.GUIshowH := this.GroupBoxH + 75
		
; 		this.ItemTypeAssociativeArray := Map("Item", " ", "StarQuality", "★", "Crop", "🪴", "Seed", "🛍", "Mining", "🪨", "Forageble", "🌹")
		
; 		; Load JSON data
; 		try {
; 			jsonText := FileRead(A_ScriptDir "\PaliaDB.json")
; 			jsonObj := JSON.Parse(jsonText)
; 			this.DB := this.ObjectToMap(jsonObj)
; 		} catch as err {
; 			MsgBox("Error loading JSON file: " err.Message)
; 			return
; 		}
		
; 		; Populate DBArrayString
; 		this.DBArrayString := []
; 		if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
; 			for item in this.DB["PaliaDB"]["items"] {
; 				if (item.Has("itemname")) {
; 					this.DBArrayString.SafePush(item["itemname"])
; 				}
; 			}
; 		} else {
; 			MsgBox("Error: JSON structure is not as expected. Please check the PaliaDB.json file.")
; 		}
; 	}
	
; 	static ObjectToMap(obj) {
; 		if (Type(obj) = "Object") {
; 			m := Map()
; 			for k, v in obj.OwnProps() {
; 				m[k] := this.ObjectToMap(v)
; 			}
; 			return m
; 		} else if (Type(obj) = "Array") {
; 			return obj.Map((v) => this.ObjectToMap(v))
; 		} else {
; 			return obj
; 		}
; 	}
	
;     static CreateGUI() {
;         this.gui := Gui("+AlwaysOnTop +Border +MinimizeBox +Owner +SysMenu -MaximizeBox -Resize", this.GUITitle)
;         this.gui.BackColor := "0x00008B"  ; Dark Blue

;         this.AddGroupBox()
;         this.AddComboBox()
;         this.AddTextSeparator()
;         this.AddEditFields()
;         this.AddControlSelectText()
;         this.AddButtons()

;         this.gui.OnEvent("Close", (*) => ExitApp())
;         this.gui.OnEvent("Escape", (*) => ExitApp())

;         this.gui.Show(Format("x{} y{} w{} h{}", this.GUIshowX, this.GUIshowY, this.GUIshowW, this.GUIshowH))

;         OnMessage(0x100, ObjBindMethod(this, "OnKeyPress"))

;         this.SetupHotkeys()
;     }
	
;     static AddGroupBox() {
;         this.gui.SetFont("s14", "Consolas")
;         this.groupBox := this.gui.AddGroupBox( Format("x10 y10 w{} h{} Section", this.GroupBoxW, this.GroupBoxH), 
;                     "-=> " this.GameName " Item Database <=-")
;     }
	
;     static AddComboBox() {
;         this.gui.SetFont("s14 Bold", "Consolas")
;         this.ComboItemChoice := this.gui.AddComboBox("xs+15 ys+33 vComboItemChoice", this.DBArrayString)
;         ; this.ComboItemChoice := this.gui.Add('Custom','ClassComboBoxEx32' ' ' "xs+15 ys+33 vComboItemChoice", this.DBArrayString)
;         this.ComboItemChoice.OnEvent("Change", (*) => this.OnComboChange())
        
;         ; Add event for auto-completion
;         this.ComboItemChoice.OnEvent("Change", (*) => this.AutoComplete(this.ComboItemChoice, this.DBArrayString, this.gui))
;     }

; 	static AutoComplete(CtlObj, ListObj, GuiObj?) {
;         static CB_GETEDITSEL := 320, CB_SETEDITSEL := 322, valueFound := false
;         local Start := 0, End := 0

;         cText := CtlObj.Text
;         currContent := CtlObj.Text

;         try CtlObj.Value := currContent

;         if (GetKeyState('Delete') || GetKeyState('Backspace')) {
;             return
;         }

;         valueFound := false

;         for index, value in ListObj {
;             if (value = currContent) {
;                 valueFound := true
;                 break
;             }
;         }

;         if (valueFound) {
;             return
;         }

;         this.MakeShort(0, &Start, &End)
;         try {
;             if (ControlChooseString(cText, CtlObj) > 0) {
;                 Start := StrLen(currContent)
;                 End := StrLen(CtlObj.Text)
;                 PostMessage(CB_SETEDITSEL, 0, this.MakeLong(Start, End),, CtlObj.Hwnd)
;             }
;         } catch as e {
;             ControlSetText(currContent, CtlObj)
;             ControlSetText(cText, CtlObj)
;             PostMessage(CB_SETEDITSEL, 0, this.MakeLong(StrLen(cText), StrLen(cText)),, CtlObj.Hwnd)
;         }
;     }

;     static MakeShort(Long, &LoWord, &HiWord) {
;         LoWord := Long & 0xffff
;         HiWord := Long >> 16
;     }

;     static MakeLong(LoWord, HiWord) {
;         return (HiWord << 16) | (LoWord & 0xffff)
;     }

;     static AddTextSeparator() {
;         this.gui.SetFont("s16 Bold c00FF00", "Consolas")
;         this.TextSeparator1 := this.gui.AddText( "x+m", "/")
;     }
	
;     static AddEditFields() {
;         this.ComboItemChoice.GetPos(&comboX, &comboY, &comboW)
;         startX := (comboX + comboW) + 50
;         startY := 'ym+' (comboY - 10)

;         this.AddEditField("ItemQuantity", "Quantity", "Red", startX, startY)
;         this.AddEditField("ItemStarQuality", "Star Quality", "Red", startX, "y+5")
;         this.AddEditField("SeedQuantity", "Seeds", "Yellow", startX, "y+5")
;         this.AddEditField("SeedStarQuality", "Star Quality", "Yellow", startX, "y+5")
;         this.AddEditField("PreservesQuantity", "Preserves", "Purple", startX, "y+5")
;         this.AddEditField("PreservesStarQuality", "Star Quality", "Purple", startX, "y+5")
        
;         ; Add Save Entry button
;         this.gui.AddButton("x" . startX . " y+10 w100", "Save Entry").OnEvent("Click", (*) => this.SaveEntry())
;     }

;     static AddEditField(name, label, color, x, y) {
;         this.gui.SetFont("s14 Bold c000000", "Consolas")
;         edit := this.gui.AddEdit(Format("x{} {} v{} w50 Number", x, y, name))
;         edit.OnEvent("Change", (*) => this.UpdateTempItem(name, edit.Value))
;         this.gui.SetFont("s14 Bold c" color, "Consolas")
;         this.gui.AddText("x+5", label)
;         return edit
;     }

;     static UpdateTempItem(key, value) {
;         this.TempItem[key] := value
;     }

;     static SaveEntry(*) {
;         if (!this.TempItem.Has("itemname") || this.GetValue(this.TempItem, "itemname") == "") {
;             MsgBox("Please select or enter an item name.")
;             return
;         }

;         this.UpdateItemData(this.TempItem)
;         this.SaveDatabase()
;         MsgBox("Entry saved successfully!")
;     }

;     static AddControlSelectText() {
;         this.TextSeparator1.GetPos(&x, &y)
;         this.TextControlSelect := this.gui.AddText( Format("x{} y{}", x, y), "<- select")
;         this.TextControlSelect.Opt("Hidden")
;     }
	
;     static AddButtons() {
; 		this.groupBox.GetPos(&posX,&posY, &posW, &posH)
;         buttonY := posY + posH + 10
;         this.gui.AddButton( Format("x15 y{} w100 vButtonRestore", buttonY), "Restore").OnEvent("Click", (*) => Reload())
;         this.gui.AddButton( "x+10 w100 vButtonQuit", "Quit").OnEvent("Click", (*) => ExitApp())
;         this.gui.AddButton( "x+10 w100 vButtonUpdate", "Update").OnEvent("Click", (*) => this.OnUpdate())
;         this.gui.AddButton( "x+10 w100 vButtonNewEntry", "New Entry").OnEvent("Click", (*) => this.OnNewEntry())
;     }
	
;     static OnComboChange(*) {
;         this.gui.Submit(false)
;         selectedItem := this.ComboItemChoice.Text
;         if (selectedItem != "" && this.DBArrayString.IndexOf(selectedItem) == 0) {
;             ; This is a new item
;             this.AddNewItem(selectedItem)
;         } else {
;             itemData := selectedItem != "" ? this.GetItemData(selectedItem) : this.GetDefaultItemData()
;             this.PopulateFields(itemData)
;             this.TempItem := this.CloneItem(itemData)
;         }
;     }

; 	static CloneItem(item) {
;         objType := this.GetObjectType(item)
;         if (objType == "Map") {
;             return Map(item*)
;         } else if (objType == "Array") {
;             return Array(item*)
;         }
;         return item
;     }

; 	static GetDefaultItemData() {
;         return {
;             itemname: "",
;             itemregular: "",
;             itemstar: "",
;             itemseed: "",
;             itemseedstar: "",
;             itempreserves: "",
;             itempreservesstar: "",
;             itemtype: ""
;         }
;     }
	
;     static PopulateFields(itemData) {
;         for key in ["itemname", "itemregular", "itemstar", "itemseed", "itemseedstar", "itempreserves", "itempreservesstar", "itemtype"] {
;             if (this.gui.HasProp(key)) {
;                 this.gui[key].Value := this.GetValue(itemData, key) != "" ? this.GetValue(itemData, key) : "0"
;             }
;         }
;     }

; 	static OnUpdate(*) {
; 		selectedItem := this.ComboItemChoice.Text
; 		updatedData := {
; 			itemname: selectedItem,
; 			itemregular: this.gui["ItemQuantity"].Value,
; 			itemstar: this.gui["ItemStarQuality"].Value,
; 			itemseed: this.gui["SeedQuantity"].Value,
; 			itemseedstar: this.gui["SeedStarQuality"].Value,
; 			itempreserves: this.gui["PreservesQuantity"].Value,
; 			itempreservesstar: this.gui["PreservesStarQuality"].Value,
; 			itemtype: this.GetItemType(selectedItem)
; 		}
		
; 		; Convert '0' to '' and keep 'x' as is
; 		for key, value in updatedData.OwnProps() {
; 			if (value = "0") {
; 				updatedData.%key% := ""
; 			}
; 		}
		
; 		this.UpdateItemData(updatedData)
; 		this.SaveDatabase()
; 		MsgBox("Item updated successfully!")
; 	}
	
;     static GetObjectType(obj) {
;         if (IsObject(obj)) {
;             return obj is Array ? "Array" : "Map"
;         }
;         return "Value"
;     }

; 	static GetValue(obj, key) {
		
;         ; objType := this.GetObjectType(obj)
;         if (Type(obj) == "Map") {
;             return obj.Has(key) ? obj[key] : ""
;         } else if (Type(obj) == "Array") {
;             return obj[key]
;         }
;         return obj
;     }

; 	static SetValue(obj, key, value) {
;         objType := this.GetObjectType(obj)
;         if (objType == "Map") {
;             obj[key] := value
;         } else if (objType == "Array") {
;             obj[key] := value
;         }
;         return obj
;     }

; 	static GetItemType(itemName) {
; 		if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
; 			for item in this.DB["PaliaDB"]["items"] {
; 				; if (item.Has("itemname") && item["itemname"] = itemName) {
; 				; 	return item.Has("itemtype") ? item["itemtype"] : ""
; 				; }
; 				return  item
; 			}
; 		}
; 		return ""
; 	}
	
;     static GetItemData(itemName) {
;         if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
;             for item in this.DB["PaliaDB"]["items"] {
;                 if (this.GetValue(item, "itemname") == itemName) {
;                     return item
;                 }
;             }
;         }
;         return this.GetDefaultItemData()
;     }

;     static UpdateItemData(updatedData) {
;         if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
;             items := this.DB["PaliaDB"]["items"]
;             itemIndex := -1
;             for index, item in items {
;                 if (this.GetValue(item, "itemname") == this.GetValue(updatedData, "itemname")) {
;                     itemIndex := index
;                     break
;                 }
;             }
            
;             if (itemIndex != -1) {
;                 items[itemIndex] := updatedData
;             } else {
;                 items.SafePush(updatedData)
;                 this.DBArrayString.SafePush(this.GetValue(updatedData, "itemname"))
;                 this.ComboItemChoice.Add([this.GetValue(updatedData, "itemname")])
;             }
;         }
;     }
	
; 	static SaveDatabase() {
; 		jsonObj := this.MapToObject(this.DB)
; 		jsonText := JSON.Stringify(jsonObj, 4)  ; 4 is for pretty-printing with indentation
; 		try {
; 			FileDelete(A_ScriptDir "\PaliaDB.json")
; 			FileAppend(jsonText, A_ScriptDir "\PaliaDB.json", "UTF-8")
; 		} catch as err {
; 			MsgBox("Error saving database: " err.Message)
; 		}
; 	}

; 	static MapToObject(m) {
; 		if (Type(m) = "Map") {
; 			obj := {}
; 			for k, v in m {
; 				obj.%k% := this.MapToObject(v)
; 			}
; 			return obj
; 		} else if (Type(m) = "Array") {
; 			return m.Map((v) => this.MapToObject(v))
; 		} else {
; 			return m
; 		}
; 	}
	
; 	static OnKeyPress(wParam, lParam, msg, hwnd) {
; 		if (GetKeyName(Format("vk{:x}", wParam)) = "Enter") {
; 			this.gui.Submit(false)
; 		}
; 	}
	
; 	static GetWindowPos(*) {
; 		WinGetPos(&x, &y, &w, &h, "A")
; 		A_Clipboard := Format("{}, {}, {}, {}", x, y, w, h)
; 		MsgBox(A_Clipboard, "Window Position")
; 	}
	
; 	static SetupHotkeys() {
; 		HotIfWinActive("ahk_id " this.gui.Hwnd)
; 		Hotkey("F2", (*) => this.GetWindowPos())
; 		Hotkey("F9", (*) => Reload())
; 		Hotkey("F10", (*) => ExitApp())
; 		Hotkey("^Escape", (*) => ExitApp())
; 	}

; 	static OnNewEntry(*) {
;         this.ComboItemChoice.Value := ""
;         this.ComboItemChoice.Focus()
;         this.TempItem := this.GetDefaultItemData()
;         this.PopulateFields(this.TempItem)
;     }

;     static AddNewItem(newItem) {
;         if (newItem == "") {
;             return
;         }

;         this.TempItem := this.GetDefaultItemData()
;         this.SetValue(this.TempItem, "itemname", newItem)
;         this.PopulateFields(this.TempItem)
;         this.ComboItemChoice.Value := newItem
;     }

; }
#Hotstring SE K-1

; class PaliaDatabase {
;     static GameName := "Palia"
;     static DatabaseINIversion := "v2.0"
;     static GUITitle := "Database Editing GUI v2.0"
    
;     static DB := Map()
;     static DBArrayString := []
;     static TempItem := Map()
;     static History := []
;     static MaxHistorySize := 50
	
;     static __New() {
;         this.InitializeVariables()
;         this.CreateGUI()
;     }
	
;     static InitializeVariables() {
;         this.DatabaseINIfile := A_ScriptDir "\INI\" this.GameName " Item Database " this.DatabaseINIversion ".ini"
;         this.DatabaseSection := this.GameName " - Items"
;         this.GUIshowX := 1348
;         this.GUIshowY := 141
;         this.GUIshowW := 500
;         this.GroupBoxW := this.GUIshowW - 20
;         this.GroupBoxH := 203 + 30 + 10
;         this.GUIshowH := this.GroupBoxH + 75
        
;         this.ItemTypeAssociativeArray := Map("Item", " ", "StarQuality", "★", "Crop", "🪴", "Seed", "🛍", "Mining", "🪨", "Forageble", "🌹")
        
;         this.LoadDatabase()
;     }
    
;     static LoadDatabase() {
; 		; Load JSON data
; 		jsonText := FileRead(A_ScriptDir "\PaliaDB.json", 'UTF-8')
; 		jsonObj := cJSON.Load(jsonText)
; 		Infos(
; 			jsonText '`n'
; 			jsonObj '`n'
; 		)
; 		this.DB := this.ConvertToMap(jsonObj)
; 		; try {
; 		; } catch as err {
; 		; 	MsgBox("Error loading JSON file: " err.Message)
; 		; 	return
; 		; }
;     }
; /**
;  * @example Converts a JSON string to a Map
;  * @param {String} jsonString The JSON string to convert
;  * @returns {Map} A Map containing the parsed JSON data
;  */
; static JSONStringToMap(jsonString) {
;     local jsonObj, resultMap

;     ; Parse the JSON string
;     jsonObj := cJSON.Load(jsonString)

;     ; Convert to Map
;     resultMap := Map()
;     this._ConvertJSONToMap(jsonObj, resultMap)

;     return resultMap
; }

; 	/**
; 	 * @example Recursively converts a JSON object to a Map
; 	 * @param {Object} jsonObj The JSON object to convert
; 	 * @param {Map} mapObj The Map to store the converted key-value pairs
; 	 */
; 	static _ConvertJSONToMap(jsonObj, mapObj) {
; 		local key, value

; 		for key, value in jsonObj.HasOwnProp() {
; 			if IsObject(value) {
; 				if value is Array {
; 					mapObj[key] := []
; 					for item in value {
; 						if IsObject(item) {
; 							nestedMap := Map()
; 							this._ConvertJSONToMap(item, nestedMap)
; 							mapObj[key].SafePush(nestedMap)
; 						} else {
; 							mapObj[key].SafePush(item)
; 						}
; 					}
; 				} else {
; 					mapObj[key] := Map()
; 					this._ConvertJSONToMap(value, mapObj[key])
; 				}
; 			} else {
; 				mapObj[key] := value
; 			}
; 		}
; 	}
;     static ConvertToMap(obj) {
;         if (Type(obj) == "Object") {
;             m := Map()
;             for k, v in obj.OwnProps() {
;                 m[k] := this.ConvertToMap(v)
;             }
;             return m
;         } else if (Type(obj) == "Array") {
;             return obj.Map((v) => this.ConvertToMap(v))
;         } else {
;             return obj
;         }
;     }
    
;     static PopulateDBArrayString(Obj) {
;         this.DBArrayString := []
;         if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
;             for item in this.DB["PaliaDB"]["items"] {
;                 if (item.Has("itemname")) {
;                     this.DBArrayString.SafePush(item["itemname"])
;                 }
;             }
;         }
;     }
	
;     static CreateGUI() {
;         this.gui := Gui("+AlwaysOnTop +Border +MinimizeBox +Owner +SysMenu -MaximizeBox -Resize", this.GUITitle)
;         this.gui.BackColor := "0x00008B"  ; Dark Blue

;         this.AddGroupBox()
;         this.AddComboBox()
;         this.AddEditFields()
;         this.AddButtons()

;         this.gui.OnEvent("Close", (*) => ExitApp())
;         this.gui.OnEvent("Escape", (*) => ExitApp())

;         this.gui.Show(Format("x{} y{} w{} h{}", this.GUIshowX, this.GUIshowY, this.GUIshowW, this.GUIshowH))

;         this.SetupHotkeys()
;     }
	
;     static AddGroupBox() {
;         this.gui.SetFont("s14", "Consolas")
;         this.groupBox := this.gui.AddGroupBox(Format("x10 y10 w{} h{} Section", this.GroupBoxW, this.GroupBoxH), 
;                     "-=> " this.GameName " Item Database <=-")
;     }
	
;     static AddComboBox() {
;         this.gui.SetFont("s14 Bold", "Consolas")
;         this.ComboItemChoice := this.gui.AddComboBox("xs+15 ys+33 vComboItemChoice", this.DBArrayString)
;         this.ComboItemChoice.OnEvent("Change", (*) => this.OnComboChange())
;     }

;     static AddEditFields() {
;         this.ComboItemChoice.GetPos(&comboX, &comboY, &comboW)
;         startX := (comboX + comboW) + 50
;         startY := 'ym+' (comboY - 10)

;         this.AddEditField("ItemQuantity", "Quantity", "Red", startX, startY)
;         this.AddEditField("ItemStarQuality", "Star Quality", "Red", startX, "y+5")
;         this.AddEditField("SeedQuantity", "Seeds", "Yellow", startX, "y+5")
;         this.AddEditField("SeedStarQuality", "Star Quality", "Yellow", startX, "y+5")
;         this.AddEditField("PreservesQuantity", "Preserves", "Purple", startX, "y+5")
;         this.AddEditField("PreservesStarQuality", "Star Quality", "Purple", startX, "y+5")
        
;         this.gui.AddButton("x" . startX . " y+10 w100", "Save Entry").OnEvent("Click", (*) => this.SaveEntry())
;     }

;     static AddEditField(name, label, color, x, y) {
;         this.gui.SetFont("s14 Bold c000000", "Consolas")
;         edit := this.gui.AddEdit(Format("x{} {} v{} w50 Number", x, y, name))
;         edit.OnEvent("Change", (*) => this.UpdateTempItem(name, edit.Value))
;         this.gui.SetFont("s14 Bold c" color, "Consolas")
;         this.gui.AddText("x+5", label)
;         return edit
;     }
	
;     static AddButtons() {
;         this.groupBox.GetPos(&posX,&posY, &posW, &posH)
;         buttonY := posY + posH + 10
;         this.gui.AddButton(Format("x15 y{} w100 vButtonRestore", buttonY), "Restore").OnEvent("Click", (*) => this.OnRestore())
;         this.gui.AddButton("x+10 w100 vButtonQuit", "Quit").OnEvent("Click", (*) => ExitApp())
;         this.gui.AddButton("x+10 w100 vButtonUpdate", "Update").OnEvent("Click", (*) => this.OnUpdate())
;         this.gui.AddButton("x+10 w100 vButtonNewEntry", "New Entry").OnEvent("Click", (*) => this.OnNewEntry())
;     }
	
;     static OnComboChange(*) {
;         this.gui.Submit(false)
;         selectedItem := this.ComboItemChoice.Text
;         if (selectedItem != "" && this.DBArrayString.IndexOf(selectedItem) == 0) {
;             this.AddNewItem(selectedItem)
;         } else {
;             itemData := selectedItem != "" ? this.GetItemData(selectedItem) : this.GetDefaultItemData()
;             this.PopulateFields(itemData)
;             this.TempItem := this.CloneItem(itemData)
;         }
;     }

;     static CloneItem(item) {
;         return (Type(item) == "Map") ? Map(item*) : (Type(item) == "Array") ? Array(item*) : item
;     }

;     static GetDefaultItemData() {
;         return Map("itemname", "", "itemregular", "", "itemstar", "", "itemseed", "", "itemseedstar", "", "itempreserves", "", "itempreservesstar", "", "itemtype", "")
;     }
	
;     static PopulateFields(itemData) {
;         for key in ["ItemQuantity", "ItemStarQuality", "SeedQuantity", "SeedStarQuality", "PreservesQuantity", "PreservesStarQuality"] {
;             if (this.gui.HasProp(key)) {
;                 this.gui[key].Value := itemData.Has(key) ? itemData[key] : "0"
;             }
;         }
;     }

;     static OnUpdate(*) {
;         selectedItem := this.ComboItemChoice.Text
;         updatedData := Map(
;             "itemname", selectedItem,
;             "itemregular", this.gui["ItemQuantity"].Value,
;             "itemstar", this.gui["ItemStarQuality"].Value,
;             "itemseed", this.gui["SeedQuantity"].Value,
;             "itemseedstar", this.gui["SeedStarQuality"].Value,
;             "itempreserves", this.gui["PreservesQuantity"].Value,
;             "itempreservesstar", this.gui["PreservesStarQuality"].Value,
;             "itemtype", this.GetItemType(selectedItem)
;         )
        
;         for key, value in updatedData {
;             if (value == "0") {
;                 updatedData[key] := ""
;             }
;         }
        
;         this.UpdateItemData(updatedData)
;         this.SaveDatabase()
;         this.AddToHistory(updatedData)
;         MsgBox("Item updated successfully!")
;     }

;     static GetItemType(itemName) {
;         if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
;             for item in this.DB["PaliaDB"]["items"] {
;                 if (item.Has("itemname") && item["itemname"] == itemName) {
;                     return item.Has("itemtype") ? item["itemtype"] : ""
;                 }
;             }
;         }
;         return ""
;     }
	
;     static GetItemData(itemName) {
;         if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
;             for item in this.DB["PaliaDB"]["items"] {
;                 if (item.Has("itemname") && item["itemname"] == itemName) {
;                     return item
;                 }
;             }
;         }
;         return this.GetDefaultItemData()
;     }

;     static UpdateItemData(updatedData) {
;         if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
;             items := this.DB["PaliaDB"]["items"]
;             itemIndex := -1
;             for index, item in items {
;                 if (item.Has("itemname") && item["itemname"] == updatedData["itemname"]) {
;                     itemIndex := index
;                     break
;                 }
;             }
            
;             if (itemIndex != -1) {
;                 items[itemIndex] := updatedData
;             } else {
;                 items.SafePush(updatedData)
;                 this.DBArrayString.SafePush(updatedData["itemname"])
;                 this.ComboItemChoice.Add([updatedData["itemname"]])
;             }
;         }
;     }
	
;     static SaveDatabase() {
;         jsonObj := this.ConvertToObject(this.DB)
;         jsonText := cjson.Dump(jsonObj, 4)  ; 4 is for pretty-printing with indentation
;         try {
;             FileDelete(A_ScriptDir "\PaliaDB.json")
;             FileAppend(jsonText, A_ScriptDir "\PaliaDB.json", "UTF-8")
;         } catch as err {
;             MsgBox("Error saving database: " err.Message)
;         }
;     }

;     static ConvertToObject(m) {
;         if (Type(m) == "Map") {
;             obj := {}
;             for k, v in m {
;                 obj.%k% := this.ConvertToObject(v)
;             }
;             return obj
;         } else if (Type(m) == "Array") {
;             return m.Map((v) => this.ConvertToObject(v))
;         } else {
;             return m
;         }
;     }

;     static SetupHotkeys() {
;         HotIfWinActive("ahk_id " this.gui.Hwnd)
;         Hotkey("F2", (*) => this.GetWindowPos())
;         Hotkey("F9", (*) => Reload())
;         Hotkey("F10", (*) => ExitApp())
;         Hotkey("^Escape", (*) => ExitApp())
;     }

;     static OnNewEntry(*) {
;         this.ComboItemChoice.Value := ""
;         this.ComboItemChoice.Focus()
;         this.TempItem := this.GetDefaultItemData()
;         this.PopulateFields(this.TempItem)
;     }

;     static AddNewItem(newItem) {
;         if (newItem == "") {
;             return
;         }

;         this.TempItem := this.GetDefaultItemData()
;         this.TempItem["itemname"] := newItem
;         this.PopulateFields(this.TempItem)
;         this.ComboItemChoice.Value := newItem
;     }

;     static AddToHistory(item) {
;         this.History.SafePush(item)
;         if (this.History.Length > this.MaxHistorySize) {
;             this.History.RemoveAt(1)
;         }
;     }

;     static OnRestore(*) {
;         if (this.History.Length > 0) {
;             restoredItem := this.History.Pop()
;             this.UpdateItemData(restoredItem)
;             this.PopulateFields(restoredItem)
;             this.ComboItemChoice.Value := restoredItem["itemname"]
;             this.SaveDatabase()
;             MsgBox("Item restored successfully!")
;         } else {
;             MsgBox("No history available to restore.")
;         }
;     }

;     static UpdateTempItem(key, value) {
;         this.TempItem[key] := value
;     }

;     static SaveEntry(*) {
;         if (!this.TempItem.Has("itemname") || this.TempItem["itemname"] == "") {
;             MsgBox("Please select or enter an item name.")
;             return
;         }

;         this.UpdateItemData(this.TempItem)
;         this.SaveDatabase()
;         this.AddToHistory(this.TempItem)
;         MsgBox("Entry saved successfully!")
;     }

;     static GetWindowPos(*) {
;         WinGetPos(&x, &y, &w, &h, "A")
;         A_Clipboard := Format("{}, {}, {}, {}", x, y, w, h)
;         MsgBox(A_Clipboard, "Window Position")
;     }
; }

; class PaliaDatabase {
; 	static GameName := "Palia"
; 	static DatabaseINIversion := "v2.0"
; 	static GUITitle := "Database Editing GUI v2.0"
	
; 	static DB := {}
; 	static DBArrayString := []
	
; 	static __New() {
; 		this.InitializeVariables()
; 		this.CreateGUI()
; 	}
	
; 	static InitializeVariables() {
; 		this.DatabaseINIfile := A_ScriptDir "\INI\" PaliaDatabase.GameName " Item Database " PaliaDatabase.DatabaseINIversion ".ini"
; 		this.DatabaseSection := PaliaDatabase.GameName " - Items"
; 		this.GUIshowX := 1348
; 		this.GUIshowY := 141
; 		this.GUIshowW := 500
; 		this.GroupBoxW := this.GUIshowW - 20
; 		this.GroupBoxH := 203 + 30 + 10
; 		this.GUIshowH := this.GroupBoxH + 75
		
; 		this.ItemTypeAssociativeArray := Map("Item", " ", "StarQuality", "★", "Crop", "🪴", "Seed", "🛍", "Mining", "🪨", "Forageble", "🌹")
		
; 		; Load JSON data
; 		try {
; 			jsonText := FileRead(A_ScriptDir "\PaliaDB.json")
; 			jsonObj := cJSON.Parse(jsonText)
; 			this.DB := this.ObjectToMap(jsonObj)
; 		} catch as err {
; 			MsgBox("Error loading JSON file: " err.Message)
; 			return
; 		}

; 		; Populate DBArrayString
; 		this.DBArrayString := []
; 		if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
; 			for item in this.DB["PaliaDB"]["items"] {
; 				if (item.Has("itemname")) {
; 					this.DBArrayString.SafePush(item["itemname"])
; 				}
; 			}
; 		} else {
; 			MsgBox("Error: JSON structure is not as expected. Please check the PaliaDB.json file.")
; 		}
; 	}
	
; 	static ObjectToMap(obj) {
; 		if (Type(obj) = "Object") {
; 			m := Map()
; 			for k, v in obj.OwnProps() {
; 				m[k] := this.ObjectToMap(v)
; 			}
; 			return m
; 		} else if (Type(obj) = "Array") {
; 			return obj.Map((v) => this.ObjectToMap(v))
; 		} else {
; 			return obj
; 		}
; 	}
	
;     static CreateGUI() {
;         this.gui := Gui("+AlwaysOnTop +Border +MinimizeBox +Owner +SysMenu -MaximizeBox -Resize", this.GUITitle)
;         this.gui.BackColor := "0x00008B"  ; Dark Blue

;         this.AddGroupBox()
;         this.AddComboBox()
;         this.AddTextSeparator()
;         this.AddEditFields()
;         this.AddControlSelectText()
;         this.AddButtons()

; 		; Add ItemTypeSymbol text
; 		this.gui.SetFont("s20 Bold cBlue", "Consolas")
; 		this.gui.AddText("x10 y+10 w30 h30 vItemTypeSymbol", " ")

;         this.gui.OnEvent("Close", (*) => ExitApp())
;         this.gui.OnEvent("Escape", (*) => ExitApp())

;         this.gui.Show(Format("x{} y{} w{} h{}", this.GUIshowX, this.GUIshowY, this.GUIshowW, this.GUIshowH))

;         OnMessage(0x100, ObjBindMethod(this, "OnKeyPress"))

;         this.SetupHotkeys()
;     }
	
;     static AddGroupBox() {
;         this.gui.SetFont("s14", "Consolas")
;         this.groupBox := this.gui.AddGroupBox(Format("x10 y10 w{} h{} Section", this.GroupBoxW, this.GroupBoxH), 
;                     "-=> " this.GameName " Item Database <=-")
;     }
	
;     static AddComboBox() {
;         this.gui.SetFont("s14 Bold", "Consolas")
;         this.ComboItemChoice := this.gui.AddComboBox("xs+15 ys+33 vComboItemChoice", this.DBArrayString)
;         this.ComboItemChoice.OnEvent("Change", (*) => this.OnComboChange())
;     }

;     static AddTextSeparator() {
;         this.gui.SetFont("s16 Bold c00FF00", "Consolas")
;         this.TextSeparator1 := this.gui.AddText("x+m", "/")
;     }
	
; 	static AddEditFields() {
; 		this.ComboItemChoice.GetPos(&comboX, &comboY, &comboW)
; 		this.TextSeparator1.GetPos(&sepX, &sepY, &sepH, &sepW)
; 		startX := (sepX + sepW) + 10
; 		startY := 'y' sepY
	
; 		this.AddEditField("ItemQuantity", "Quantity", "Red", startX, startY)
; 		this.AddEditField("ItemStarQuality", "Star Quality", "Red", startX, "y+5")
; 		this.AddEditField("SeedQuantity", "Seeds", "Yellow", startX, "y+5")
; 		this.AddEditField("SeedStarQuality", "Star Quality", "Yellow", startX, "y+5")
; 		this.AddEditField("PreservesQuantity", "Preserves", "Purple", startX, "y+5")
; 		this.AddEditField("PreservesStarQuality", "Star Quality", "Purple", startX, "y+5")
		
; 		; if Type(this.ItemTypeAssociativeArray) != 'Array' {
; 		; 	itemTypes := (this.ItemTypeAssociativeArray).ToArray()
; 		; }
; 		; else {
; 		; 	itemTypes := this.ItemTypeAssociativeArray
; 		; }
; 		itemTypes := ["Item", "StarQuality", "Crop", "Seed", "Mining", "Forageble"]

; 		; Add ItemType dropdown
; 		this.gui.SetFont("s14 Bold c000000", "Consolas")
		
; 		this.ItemTypeDropdown := this.gui.AddDropDownList("x" startX " y+10 w150 vItemType", itemTypes)
; 		this.gui.SetFont("s14 Bold cGreen", "Consolas")
; 		this.gui.AddText("x+5", "Item Type")
; 	}
	
;     static AddEditField(name, label, color, x, y) {
;         this.gui.SetFont("s14 Bold c000000", "Consolas")
;         edit := this.gui.AddEdit(Format("x{} {} v{} w50 Number", x, y, name))
;         this.gui.SetFont("s14 Bold c" color, "Consolas")
;         this.gui.AddText("x+5", label)
;         return edit
;     }
	
;     static AddControlSelectText() {
;         this.TextSeparator1.GetPos(&x, &y)
;         this.TextControlSelect := this.gui.AddText(Format("x{} y{}", x, y), "<- select")
;         this.TextControlSelect.Opt("Hidden")
;     }
	
;     static AddButtons() {
; 		this.groupBox.GetPos(&posX, &posY, &posW, &posH)
;         buttonY := posY + posH + 10
;         this.gui.AddButton(Format("xm+15 y{} w100 vButtonRestore", buttonY), "Restore").OnEvent("Click", (*) => Reload())
;         this.gui.AddButton("x+10 w100 vButtonQuit", "Quit").OnEvent("Click", (*) => ExitApp())
;         this.gui.AddButton("x+10 w100 vButtonUpdate", "Update").OnEvent("Click", (*) => this.OnUpdate())
;         this.gui.AddButton("x+10 w100 vButtonNewEntry", "New Entry").OnEvent("Click", (*) => this.OnNewEntry())
;     }
	
; 	static OnComboChange(*) {
; 		this.gui.Submit(false)
; 		selectedItem := this.ComboItemChoice.Text
; 		this.DebugPrint("Selected item: " selectedItem)
; 		itemData := this.GetItemData(selectedItem)
; 		this.DebugPrint("Item data: " cJSON.Stringify(itemData, 4))
; 		this.PopulateFields(itemData)
; 	}
	
; 	static GetItemData(itemName) {
; 		if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
; 			for item in this.DB["PaliaDB"]["items"] {
; 				if (!item.Has("itemname") && item["itemname"] = itemName) {
; 					return
; 				}
; 				else if (item.Has("itemname") && item["itemname"] = itemName) {
; 					return item
; 				}
; 			}
; 		}
; 		return Map()  ; Return an empty Map if item is not found
; 	}
	
; 	static PopulateFields(itemData) {
; 		if (itemData.Count = 0) {
; 			Infos("No data found for the selected item.")
; 			return
; 		}
	
; 		this.SetControlValue("ItemQuantity", itemData, "itemregular")
; 		this.SetControlValue("ItemStarQuality", itemData, "itemstar")
; 		this.SetControlValue("SeedQuantity", itemData, "itemseed")
; 		this.SetControlValue("SeedStarQuality", itemData, "itemseedstar")
; 		this.SetControlValue("PreservesQuantity", itemData, "itempreserves")
; 		this.SetControlValue("PreservesStarQuality", itemData, "itempreservesstar")
		
; 		itemType := itemData.Get("itemtype", "Item")
; 		this.SetItemType(itemType)
		
; 		this.UpdateItemTypeSymbol(itemType)
; 	}

; 	static SetControlValue(controlName, data, key, defaultValue := "0") {
; 		value := data.Get(key, defaultValue)
; 		try {
; 			this.gui[controlName].Value := value
; 		} catch {
; 			this.gui[controlName].Text := value
; 		}
; 	}
	
; 	;! Change this to some checkboxes!!! Then it will just display text!
; 	static SetItemType(itemType) {
; 		if (!this.ItemTypeDropdown.Has(itemType)) {
; 			if (!this.ItemTypeDropdown.Has("Other")) {
; 				this.ItemTypeDropdown.Add(["Other"])
; 			}
; 			this.ItemTypeDropdown.Choose("Other")
; 			this.ItemTypeAssociativeArray[itemType] := "?"  ; Add a placeholder symbol
; 		} else {
; 			this.ItemTypeDropdown.Choose(itemType)
; 		}
; 		this.UpdateItemTypeSymbol(itemType)
; 	}

; 	static UpdateItemTypeSymbol(itemType) {
; 		symbol := this.ItemTypeAssociativeArray.Get(itemType, "?")
; 		this.gui["ItemTypeSymbol"].Text := symbol
; 	}
	
; 	static OnUpdate(*) {
; 		selectedItem := this.ComboItemChoice.Text
; 		updatedData := Map(
; 			"itemname", selectedItem,
; 			"itemregular", this.gui["ItemQuantity"].Value,
; 			"itemstar", this.gui["ItemStarQuality"].Value,
; 			"itemseed", this.gui["SeedQuantity"].Value,
; 			"itemseedstar", this.gui["SeedStarQuality"].Value,
; 			"itempreserves", this.gui["PreservesQuantity"].Value,
; 			"itempreservesstar", this.gui["PreservesStarQuality"].Value,
; 			"itemtype", this.ItemTypeDropdown.Text
; 		)
		
; 		; Keep '0' and '' as is
; 		for key, value in updatedData {
; 			if (value = "") {
; 				updatedData[key] := "0"
; 			}
; 		}
		
; 		this.UpdateItemData(updatedData)
; 		this.SaveDatabase()
; 		this.UpdateItemTypeSymbol(updatedData["itemtype"])
; 		MsgBox("Item updated successfully!",,'T3')
; 	}
	
; 	static GetItemType(itemName) {
; 		if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
; 			for item in this.DB["PaliaDB"]["items"] {
; 				if (item.Has(itemname) && item["itemname"] = itemName) {
; 					return item.Has("itemtype") ? item["itemtype"] : ""
; 				}
; 			}
; 		}
; 		return ""
; 	}
; 	/**
; 	 * @example Converts a JSON string to a Map
; 	 * @param {String} jsonString The JSON string to convert
; 	 * @returns {Map} A Map containing the parsed JSON data
; 	 */
; 	static JSONStringToMap(jsonString) {
; 		local jsonObj, resultMap

; 		; Parse the JSON string
; 		jsonObj := cJSON.Load(jsonString)

; 		; Convert to Map
; 		resultMap := Map()
; 		this._ConvertJSONToMap(jsonObj, resultMap)

; 		return resultMap
; 	}

; 	/**
; 	 * @example Recursively converts a JSON object to a Map
; 	 * @param {Object} jsonObj The JSON object to convert
; 	 * @param {Map} mapObj The Map to store the converted key-value pairs
; 	 */
; 	static _ConvertJSONToMap(jsonObj, mapObj) {
; 		local key, value

; 		for key, value in jsonObj.HasOwnProp() {
; 			if IsObject(value) {
; 				if value is Array {
; 					mapObj[key] := []
; 					for item in value {
; 						if IsObject(item) {
; 							nestedMap := Map()
; 							this._ConvertJSONToMap(item, nestedMap)
; 							mapObj[key].SafePush(nestedMap)
; 						} else {
; 							mapObj[key].SafePush(item)
; 						}
; 					}
; 				} else {
; 					mapObj[key] := Map()
; 					this._ConvertJSONToMap(value, mapObj[key])
; 				}
; 			} else {
; 				mapObj[key] := value
; 			}
; 		}
; 	}
;     static ConvertToMap(obj) {
;         if (Type(obj) == "Object") {
;             m := Map()
;             for k, v in obj.OwnProps() {
;                 m[k] := this.ConvertToMap(v)
;             }
;             return m
;         } else if (Type(obj) == "Array") {
;             return obj.Map((v) => this.ConvertToMap(v))
;         } else {
;             return obj
;         }
;     }

; 	static UpdateItemData(updatedData) {
; 		if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
; 			items := this.DB["PaliaDB"]["items"]
; 			itemIndex := -1
; 			for index, item in items {
; 				if (item.Has("itemname") && item["itemname"] = updatedData["itemname"]) {
; 					itemIndex := index
; 					break
; 				}
; 			}
			
; 			if (itemIndex != -1) {
; 				items[itemIndex] := updatedData
; 			} else {
; 				items.SafePush(updatedData)
; 				this.DBArrayString.SafePush(updatedData["itemname"])
; 				this.ComboItemChoice.Add([updatedData["itemname"]])
; 			}
; 		}
; 	}
	
; 	static SaveDatabase() {
; 		jsonObj := this.MapToObject(this.DB)
; 		jsonText := cJSON.Stringify(jsonObj, 4)  ; 4 is for pretty-printing with indentation
; 		try {
; 			FileDelete(A_ScriptDir "\PaliaDB.json")
; 			FileAppend(jsonText, A_ScriptDir "\PaliaDB.json", "UTF-8")
; 		} catch as err {
; 			MsgBox("Error saving database: " err.Message)
; 		}
; 	}
	
; 	static MapToObject(m) {
; 		if (Type(m) = "Map") {
; 			obj := {}
; 			for k, v in m {
; 				obj.%k% := this.MapToObject(v)
; 			}
; 			return obj
; 		} else if (Type(m) = "Array") {
; 			return m.Map((v) => this.MapToObject(v))
; 		} else {
; 			return m
; 		}
; 	}
	
; 	static OnKeyPress(wParam, lParam, msg, hwnd) {
; 		if (GetKeyName(Format("vk{:x}", wParam)) = "Enter") {
; 			this.gui.Submit(false)
; 		}
; 	}
	
; 	static GetWindowPos(*) {
; 		WinGetPos(&x, &y, &w, &h, "A")
; 		A_Clipboard := Format("{}, {}, {}, {}", x, y, w, h)
; 		MsgBox(A_Clipboard, "Window Position")
; 	}
	
; 	static SetupHotkeys() {
; 		HotIfWinActive("ahk_id " this.gui.Hwnd)
; 		Hotkey("F2", (*) => this.GetWindowPos())
; 		Hotkey("F9", (*) => Reload())
; 		Hotkey("F10", (*) => ExitApp())
; 		Hotkey("Escape", (*) => ExitApp())
; 	}

; 	static OnNewEntry(*) {
;         if (newItem := InputBox("Enter new item name:", "New Item").Value) {
;             if (this.DBArrayString.IndexOf(newItem) > 0) {
;                 MsgBox("Item already exists!")
;                 return
;             }
            
;             this.DBArrayString.SafePush(newItem)
;             this.ComboItemChoice.Add([newItem])
            
;             newItemData := Map(
;                 "itemname", newItem,
;                 "itemregular", "",
;                 "itemstar", "",
;                 "itemseed", "",
;                 "itemseedstar", "",
;                 "itempreserves", "",
;                 "itempreservesstar", "",
;                 "itemtype", ""
;             )
            
;             this.DB["PaliaDB"]["items"].SafePush(newItemData)
;             this.SaveDatabase()
            
;             this.ComboItemChoice.Value := newItem
;             this.PopulateFields(newItemData)
            
;             MsgBox("New item added successfully!")
;         }
;     }

; 	static DebugPrint(message) {
; 		FileAppend(message "`n", "debug.log")
; 	}
; }

#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir

#Include <Includes\ObjectTypeExtensions>

class PaliaDatabase {
    static GameName := "Palia"
    static DatabaseINIversion := "v2.0"
    static GUITitle := "Database Editing GUI v2.0"
    
    static DB := Map()
    static DBArrayString := []
    static TempItem := Map()
    static History := []
    static MaxHistorySize := 50
    
    static __New() {
        this.InitializeVariables()
        this.CreateGUI()
    }
    
    ; Initialize variables and load database
    static InitializeVariables() {
        this.DatabaseINIfile := A_ScriptDir "\INI\" this.GameName " Item Database " this.DatabaseINIversion ".ini"
        this.DatabaseSection := this.GameName " - Items"
        this.GUIshowX := 1348
        this.GUIshowY := 141
        this.GUIshowW := 500
        this.GroupBoxW := this.GUIshowW - 20
        this.GroupBoxH := 203 + 30 + 10
        this.GUIshowH := this.GroupBoxH + 75
        
        this.ItemTypeAssociativeArray := Map("Item", " ", "StarQuality", "★", "Crop", "🪴", "Seed", "🛍", "Mining", "🪨", "Forageble", "🌹")
        
        this.LoadDatabase()
    }
    
    ; Load database from JSON file
    static LoadDatabase() {
        try {
            jsonText := FileRead(A_ScriptDir "\PaliaDB.json", "UTF-8")
            this.DB := cJSON.Load(jsonText).ToMap()
            this.PopulateDBArrayString()
        } catch as err {
            MsgBox("Error loading JSON file: " err.Message)
        }
    }
    
    ; Populate DBArrayString from loaded database
    static PopulateDBArrayString() {
        this.DBArrayString := []
        if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
            for item in this.DB["PaliaDB"]["items"] {
                if (item.Has("itemname")) {
                    this.DBArrayString.SafePush(item["itemname"])
                }
            }
        }
    }
    
    static CreateGUI() {
        ; Create GUI using Gui2 class
        this.gui := Gui("+Resize +MinSize320x240", this.GUITitle)
        this.gui.BackColor := "0x00008B"  ; Dark Blue

        ; Add GUI elements
        this.AddGroupBox()
        this.AddComboBox()
        this.AddItemTypeCheckboxes()
        this.AddEditFields()
        this.AddButtons()

        ; Add customization options
        this.gui.AddCustomizationOptions()

        ; Set up event handlers
        this.gui.OnEvent("Close", (*) => (this.gui.SaveSettings(), ExitApp()))
        this.gui.OnEvent("Escape", (*) => ExitApp())
        this.gui.OnEvent("Size", (*) => GuiResizer.Now(this))

        ; Show the GUI
        this.gui.Show(Format("x{} y{} w{} h{}", this.GUIshowX, this.GUIshowY, this.GUIshowW, this.GUIshowH))

        ; Load saved settings
        this.gui.LoadSettings()

        ; Set up hotkeys
        this.SetupHotkeys()
    }
    
    ; Add the main group box
    static AddGroupBox() {
        this.gui.SetFont("s14", "Consolas")
        this.groupBox := this.gui.AddGroupBox(Format("x10 y10 w{} h{} Section", this.GroupBoxW, this.GroupBoxH), 
                    "-=> " this.GameName " Item Database <=-")
    }
    
    ; Add the combo box for item selection
    static AddComboBox() {
        this.gui.SetFont("s14 Bold", "Consolas")
        this.ComboItemChoice := this.gui.AddComboBox("xs+15 ys+33 vComboItemChoice", this.DBArrayString)
        this.ComboItemChoice.OnEvent("Change", (*) => this.OnComboChange())
        
        ; Add AutoComplete to ComboItemChoice
        this.ComboItemChoice.OnEvent("Change", (*) => this.AutoComplete(this.ComboItemChoice, this.DBArrayString))
    }
    
    ; Add checkboxes for item types
    static AddItemTypeCheckboxes() {
        this.gui.SetFont("s12", "Consolas")
        this.itemTypeCheckboxes := Map()
        checkboxY := this.ComboItemChoice.Pos.Y + this.ComboItemChoice.Pos.H + 10
        for type, symbol in this.ItemTypeAssociativeArray {
            checkbox := this.gui.AddCheckbox(Format("x15 y{} vItemType{}", checkboxY, type), type)
            checkbox.OnEvent("Click", (*) => this.UpdateItemTypeText())
            this.itemTypeCheckboxes[type] := checkbox
            checkboxY += 25
        }
        
        this.itemTypeText := this.gui.AddEdit("x15 y" checkboxY " w150 vItemTypeText ReadOnly")
    }
    
    ; Add edit fields for item properties
    static AddEditFields() {
        startX := 180
        startY := this.ComboItemChoice.Pos.Y + this.ComboItemChoice.Pos.H + 10

        this.AddEditField("ItemQuantity", "Quantity", "Red", startX, startY)
        this.AddEditField("ItemStarQuality", "Star Quality", "Red", startX, "y+5")
        this.AddEditField("SeedQuantity", "Seeds", "Yellow", startX, "y+5")
        this.AddEditField("SeedStarQuality", "Star Quality", "Yellow", startX, "y+5")
        this.AddEditField("PreservesQuantity", "Preserves", "Purple", startX, "y+5")
        this.AddEditField("PreservesStarQuality", "Star Quality", "Purple", startX, "y+5")
    }
    
    ; Add a single edit field
    static AddEditField(name, label, color, x, y) {
        this.gui.SetFont("s14 Bold c000000", "Consolas")
        edit := this.gui.AddEdit(Format("x{} {} v{} w50 Number", x, y, name))
        edit.OnEvent("Change", (*) => this.UpdateTempItem(name, edit.Value))
        this.gui.SetFont("s14 Bold c" color, "Consolas")
        this.gui.AddText("x+5", label)
        return edit
    }
    
    ; Add buttons for various actions
    static AddButtons() {
        this.groupBox.GetPos(&posX,&posY, &posW, &posH)
        buttonY := posY + posH + 10
        this.gui.AddButton(Format("x15 y{} w100 vButtonRestore", buttonY), "Restore").OnEvent("Click", (*) => this.OnRestore())
        this.gui.AddButton("x+10 w100 vButtonQuit", "Quit").OnEvent("Click", (*) => ExitApp())
        this.gui.AddButton("x+10 w100 vButtonUpdate", "Update").OnEvent("Click", (*) => this.OnUpdate())
        this.gui.AddButton("x+10 w100 vButtonNewEntry", "New Entry").OnEvent("Click", (*) => this.OnNewEntry())
    }
    
    ; Handle combo box change event
    static OnComboChange(*) {
        this.gui.Submit(false)
        selectedItem := this.ComboItemChoice.Text
        itemData := this.GetItemData(selectedItem)
        this.PopulateFields(itemData)
        this.TempItem := itemData.Clone()
    }
    
    ; Get item data from the database
    static GetItemData(itemName) {
        if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
            for item in this.DB["PaliaDB"]["items"] {
                if (item.Has("itemname") && item["itemname"] == itemName) {
                    return item
                }
            }
        }
        return Map()
    }
    
    ; Populate fields with item data
    static PopulateFields(itemData) {
        if (itemData.Count == 0) {
            return
        }
    
        this.SetControlValue("ItemQuantity", itemData, "itemregular")
        this.SetControlValue("ItemStarQuality", itemData, "itemstar")
        this.SetControlValue("SeedQuantity", itemData, "itemseed")
        this.SetControlValue("SeedStarQuality", itemData, "itemseedstar")
        this.SetControlValue("PreservesQuantity", itemData, "itempreserves")
        this.SetControlValue("PreservesStarQuality", itemData, "itempreservesstar")
        
        this.SetItemType(itemData.Get("itemtype", ""))
    }
    
    ; Set control value
    static SetControlValue(controlName, data, key, defaultValue := "0") {
        value := data.Get(key, defaultValue)
        this.gui[controlName].Value := value
    }
    
    ; Set item type
    static SetItemType(itemTypes) {
        for type, checkbox in this.itemTypeCheckboxes {
            checkbox.Value := InStr(itemTypes, type) > 0
        }
        this.UpdateItemTypeText()
    }
    
    ; Update item type text based on checkboxes
    static UpdateItemTypeText() {
        selectedTypes := []
        for type, checkbox in this.itemTypeCheckboxes {
            if (checkbox.Value) {
                selectedTypes.SafePush(type)
            }
        }
        this.itemTypeText.Value := selectedTypes.Join(", ")
    }
    
    ; Handle update button click
    static OnUpdate(*) {
        selectedItem := this.ComboItemChoice.Text
        updatedData := Map(
            "itemname", selectedItem,
            "itemregular", this.gui["ItemQuantity"].Value,
            "itemstar", this.gui["ItemStarQuality"].Value,
            "itemseed", this.gui["SeedQuantity"].Value,
            "itemseedstar", this.gui["SeedStarQuality"].Value,
            "itempreserves", this.gui["PreservesQuantity"].Value,
            "itempreservesstar", this.gui["PreservesStarQuality"].Value,
            "itemtype", this.itemTypeText.Value
        )
        
        this.UpdateItemData(updatedData)
        this.SaveDatabase()
        this.AddToHistory(updatedData)
        MsgBox("Item updated successfully!")
    }
    
    ; Update item data in the database
    static UpdateItemData(updatedData) {
        if (this.DB.Has("PaliaDB") && this.DB["PaliaDB"].Has("items")) {
            items := this.DB["PaliaDB"]["items"]
            itemIndex := -1
            for index, item in items {
                if (item.Has("itemname") && item["itemname"] == updatedData["itemname"]) {
                    itemIndex := index
                    break
                }
            }
            
            if (itemIndex != -1) {
                items[itemIndex] := updatedData
            } else {
                items.SafePush(updatedData)
                this.DBArrayString.SafePush(updatedData["itemname"])
                this.ComboItemChoice.Add([updatedData["itemname"]])
            }
        }
    }
    
    ; Save database to JSON file
    static SaveDatabase() {
        jsonText := cJSON.Stringify(this.DB, 4)
        try {
            FileDelete(A_ScriptDir "\PaliaDB.json")
            FileAppend(jsonText, A_ScriptDir "\PaliaDB.json", "UTF-8")
        } catch as err {
            MsgBox("Error saving database: " err.Message)
        }
    }
    
    ; Set up hotkeys
    static SetupHotkeys() {
        HotIfWinActive("ahk_id " this.gui.Hwnd)
        Hotkey("F2", (*) => this.GetWindowPos())
        Hotkey("F9", (*) => Reload())
        Hotkey("F10", (*) => ExitApp())
        Hotkey("^Escape", (*) => ExitApp())
    }
    
    ; Handle new entry button click
    static OnNewEntry(*) {
        if (newItem := InputBox("Enter new item name:", "New Item").Value) {
            if (this.DBArrayString.IndexOf(newItem) > 0) {
                MsgBox("Item already exists!")
                return
            }
            
            this.DBArrayString.SafePush(newItem)
            this.ComboItemChoice.Add([newItem])
            
            newItemData := Map(
                "itemname", newItem,
                "itemregular", "",
                "itemstar", "",
                "itemseed", "",
                "itemseedstar", "",
                "itempreserves", "",
                "itempreservesstar", "",
                "itemtype", ""
            )
            
            this.DB["PaliaDB"]["items"].SafePush(newItemData)
            this.SaveDatabase()
            
            this.ComboItemChoice.Value := newItem
            this.PopulateFields(newItemData)
            
            MsgBox("New item added successfully!")
        }
    }
    
    ; Add item to history
    static AddToHistory(item) {
        this.History.SafePush(item)
        if (this.History.Length > this.MaxHistorySize) {
            this.History.RemoveAt(1)
        }
    }
    
    ; Handle restore button click
    static OnRestore(*) {
        if (this.History.Length > 0) {
            restoredItem := this.History.Pop()
            this.UpdateItemData(restoredItem)
            this.PopulateFields(restoredItem)
            this.ComboItemChoice.Value := restoredItem["itemname"]
            this.SaveDatabase()
            MsgBox("Item restored successfully!")
        } else {
            MsgBox("No history available to restore.")
        }
    }
    
    ; Update temporary item data
    static UpdateTempItem(key, value) {
        this.TempItem[key] := value
    }
    
    ; Get window position
    static GetWindowPos(*) {
        WinGetPos(&x, &y, &w, &h, "A")
        A_Clipboard := Format("{}, {}, {}, {}", x, y, w, h)
        MsgBox(A_Clipboard, "Window Position")
    }
    
; AutoComplete method (continued)
static AutoComplete(CtrlObj, ListObj) {
	static CB_GETEDITSEL := 320, CB_SETEDITSEL := 322
	
	cText := CtrlObj.Text
	if (GetKeyState("Delete", "P") || GetKeyState("Backspace", "P")) {
		return
	}

	; Use String2's FindBestMatch method for improved matching
	bestMatch := String2.FindBestMatch(cText, ListObj)
	if (bestMatch) {
		CtrlObj.Text := bestMatch
		SendMessage(CB_SETEDITSEL, 0, StrLen(cText) | (StrLen(bestMatch) << 16),, "ahk_id " CtrlObj.Hwnd)
	}
}

; Save GUI settings
static SaveGUISettings() {
	settings := Map(
		"GuiSize", {w: this.gui.Pos.W, h: this.gui.Pos.H},
		"ControlPositions", this.GetControlPositions()
	)
	FileDelete(A_ScriptDir "\GUISettings.json")
	FileAppend(cJSON.Stringify(settings), A_ScriptDir "\GUISettings.json")
}

; Load GUI settings
static LoadGUISettings() {
	if (FileExist(A_ScriptDir "\GUISettings.json")) {
		settings := cJSON.Load(FileRead(A_ScriptDir "\GUISettings.json"))
		this.ApplyGUISettings(settings)
	}
}

; Apply loaded GUI settings
static ApplyGUISettings(settings) {
	if (settings.Has("GuiSize")) {
		this.gui.Move(,, settings.GuiSize.w, settings.GuiSize.h)
	}
	if (settings.Has("ControlPositions")) {
		this.SetControlPositions(settings.ControlPositions)
	}
}

; Get current control positions
static GetControlPositions() {
	positions := Map()
	for ctrl in this.gui {
		positions[ctrl.Name] := {x: ctrl.X, y: ctrl.Y}
	}
	return positions
}

; Set control positions
static SetControlPositions(positions) {
	for ctrlName, pos in positions {
		if (this.gui.HasProp(ctrlName)) {
			this.gui[ctrlName].Move(pos.x, pos.y)
		}
	}
}
}

PaliaDatabase()
