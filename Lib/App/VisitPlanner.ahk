#Requires AutoHotkey v2.0

#Include <Includes\Includes_Runner>

; static visitplanner(search := '') {
visitplanner() {
	static WaitElement_timeDelay := 30000
	static link := 'https://app.fmglobal.com/polaris/assignments/'
	WinEa := 0, WinEs := 0, WinE := 0, WinA := 0, hCtl := 0, fCtl := 0
	WinT := '',  pA := 'Polaris - Assignments', pS  := 'Sign In'
	static aPolaris := []
	static mPolaris := Map('a', pA := 'Polaris - Assignments', 's', pS  := 'Sign In -')
	tryActivate()
	static tryActivate(){
		try {
			for key, value in mPolaris {
				WinActivate(value)
				WinA := WinActive('A')
				WinT := WinGetTitle(WinA)
				(WinT ~= value) ? aPolaris.SafePush(value) : false
			}
		}
		; if (aPolaris.HasValue(mPolaris['a']) = true) {
		if (aPolaris.HasValue(mPolaris['a'])) {
			load()
		}
		; else if (aPolaris.HasValue(mPolaris['s']) = true) {
		else if (aPolaris.HasValue(mPolaris['s'])) {
			login()
		}
		else {
			Run(link)
			WinWaitActive(mPolaris['s'])
			login()
		}
	}
	static login(){
		mBox := vL := vpN := vpC := vp := fvL := '', fvLT := false
		WinEa := WinEa := 0
		vp := UIA.ElementFromChromium('A',false,WaitElement_timeDelay)
		vp.WaitElement({AutomationId: 'signInName'},WaitElement_timeDelay).Value := 'adam.bacon@fmglobal.com'
		vpC := UIA.ElementFromChromium('A',false,WaitElement_timeDelay)
		; vpC.WaitElement({Name:'Continue', AutomationId:'next'},WaitElement_timeDelay).Invoke()
		vpC.WaitElement({Name:'Continue', AutomationId:'next'},WaitElement_timeDelay).Click(,,,,true)
		tryActivate()
	}
	static load(){
		try_LoadMore()
		; ---------------------------------------------------------------------------
		static try_LoadMore() {
			fVl := '', fvLT := false
			try {
				vL := UIA.ElementFromChromium('A',false,WaitElement_timeDelay)
				vL.FindElement({Type: '50000 (Button)', Name: "All Loaded", LocalizedType: "button", AutomationId: "rds-button-8"})
			}
			
			if (fvl = '') {
				Loop 10 {
					try {
						vpN := UIA.ElementFromChromium('A',false,WaitElement_timeDelay)
						vpN.WaitElement({Type:'button', Name:'Load More'},WaitElement_timeDelay).ControlClick(,,)(,,,,true)
					}
				}
			}
		}
		filter := UIA.ElementFromChromium('A',false,WaitElement_timeDelay)
		filter.FIndElement({Type: '50004 (Edit)', Name: "Search", LocalizedType: "edit"}).ControlClick()
	}
}

exitvp(){
	ehW := WinExist('Polaris ')
	WaitElement_timeDelay := 30000
	WinActivate(ehW)
	exitV := UIA.ElementFromChromium('A',false,WaitElement_timeDelay).WaitElement({Type:'MenuItem', Name: 'Profile'}, WaitElement_timeDelay).ControlClick()
	UIA.ElementFromChromium('A',false,WaitElement_timeDelay).WaitElement({Type:'MenuItem', Name: 'Log Out'}, WaitElement_timeDelay).ControlCLick()
	wE := WinExist('FM Global - Google Chrome')
	WinActivate(wE)
	wWwE := WinWaitActive(wE)
	wA := WinActive()
	Infos(wWwE '`n' WinGetTitle(Wa))
	Sleep(1000)
	ControlSend('{Ctrl down}{F4}{Ctrl up}',,WinGetTitle(winactive('A')))
	ControlSend('F4',,WinGetTitle(winactive('A')))
	ControlSend('{Ctrl up}',,WinGetTitle(winactive('A')))
	ControlSend('{Ctrl down}{F4}{Ctrl up}',,wA)
	ControlSend('F4',,wA)
	ControlSend('{Ctrl up}',,wA)
}