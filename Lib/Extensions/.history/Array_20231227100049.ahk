; No dependencies

_ArrayToString(this, char := ", ") {
	for index, value in this {
		if index = this.Length {
			str .= value
			break
		}
		str .= value char
	}
	return str
}
Array.Prototype.DefineProp("ToString", { Call: _ArrayToString })

_ArrayHasValue(this, valueToFind) {
	for index, value in this {
		if (value = valueToFind){
			return true
		}
	}
	return false
}
Array.Prototype.DefineProp("HasValue", { Call: _ArrayHasValue })

; TODO Convert from MAP to Array

/**
 * By default, you can set the same key to a map multiple times.
 * Naturally, you'll be able to reference only one of them, which is likely not the behavior you want.
 * This function will throw an error if you try to set a key that already exists in the map.
 * @param mapObj ***Map*** to set the key-value pair into
 * @param key ***String***
 * @param value ***Any***
 */
arraySafeSet(arrayObj, each, value) {
	if !arrayObj.Has(value) {
		arrayObj.Push(value)
		; return
	}
	; throw IndexError("Map already has key", -1, key)
}
Array.Prototype.DefineProp("SafeSet", {Call: arraySafeSet})

/**
 * A version of SafeSet that you can just pass another map object into to set everything in it.
 * Will still throw an error for every key that already exists in the map.
 * @param mapObj ***Map*** the initial map
 * @param mapToSet ***Map*** the map to set into the initial map
 */
SafeSetArray(arrayObj, arrayToPush) {
	for each, value in arrayToPush {
		SafeSet(arrayObj, each, value)
	}
}
Array.Prototype.DefineProp("SafeSetArray", {Call: SafeSetArray})

; TODO figure out how to reverse an array, or sort?
aReverse(arrayObj) {
	reversedArray := Array()
	for each, value in arrayObj {
		reversedArray.Push(value, each)
	}
	return reversedArray
}
Array.Prototype.DefineProp("Reverse", {Call: aReverse})

; Map___New_Call := Map.Prototype.GetOwnPropDesc("__New").Call
; Map.Prototype.DefineProp("__New", {Call: Map___New_Call_Custom})
; Map___New_Call_Custom(this, params*) {
;     if (params.Length = 1 && IsObject(params[1])) {
;         for key, value in params[1].OwnProps()
;             this[key] := value
;     }
;     else {
;         Map___New_Call(this, params*)
;     }
; }

_ChooseArray(this, keyName) {
	if this.Has(keyName){
		return this[keyName]
	}
	options := []
	for key, _ in this {
		if InStr(key, keyName){
			options.Push(key)
		}
	}
	chosen := Choose(options*)
	if chosen{
		return this[chosen]
	}
	return ""
}
Array.Prototype.DefineProp("Choose", {Call: _ChooseArray})