#Include <Paths>
#Include <Tools\Info>
#Include <Abstractions\Text>
#Include <Utils\Cmd>
#Include <Links>
#Include <System\Web>
; #Include <WINDOWS.v2>
#Include <Tools\Info>

class gitlibrary {
	__New() {
		ghLib := Gui().MakeFontNicer(11)
		ghLib.Opt('+Resize')
		ghLib.AddText('cWhite Section x+10','Paste Link: ')
		ghLib.AddEdit('vLink x+5','www.github.com...')
		ghLib.AddText('Section', 'Enter the folder to save to: ')
		ghLib.AddEdit('vFolder')
		ghLib.Submit()
		ghLib.Show()
	}
}
^+!t::testgui()
testgui() {
	static editW := (A_ScreenWidth/7)
	ghLib := Gui().DarkMode().MakeFontNicer(11)
	ghLib.Opt('+Resize')
	ghLib.AddText('Section x10','Paste Link: ')
	ghLib.AddEdit('vLink x10 y+20 w' editW,'www.github.com...')
	ghLib.AddText('Section x10 y+20', 'Enter the folder to save to: ')
	ghLib.AddEdit('vFolder x10 y+20 w' editW)
	ghLib.Submit()
	ghLib.Show()
}

git_InstallAHKLibrary(link, folder:=''){
	git_install := Map()
	static libFolder := Paths.Lib . '\' . folder
	link := StrReplace(link,'addlib ','')
	link := StrReplace(link, 'https://github.com','')
	link := StrReplace(link, 'blob/',,,, 1)
	link := StrReplace(link, 'tree/','',,, 1)
	file_html := GetHtml('https://raw.githubusercontent.com/' link)
	RegExMatch(link, '\/([^.\/]+\.\w+)$', &match)
	newFile := match[1]
	file_name := StrReplace(newFile, '.url', '.ahk')
	; try {
	; 	WriteFile(file_name, file_html)
	; }
	; Infos(
	; 	'libFolder: ' libFolder '`n'
	; 	'file_name: ' file_name '`n'
	; 	'file_text: ' file_html '`n'
	; )
	; Info(newFile ' library installed in: ' libFolder)
	git_install.Set(
		'libFolder', libFolder, 
		'file_name', file_name, 
		'file_text',file_html
	)
	git_file := libFolder '\' file_name
	If !FileExist(git_file) {
		WriteFile(git_file, 'git_app_link := ' '"' file_html '"')
		; FileAppend(file_html,git_file, 'UTF-8')
	}
	return git_install
}

class Git {

	__New(workingDir) {
		this.shell := Cmd(workingDir)
	}


	shell := unset
	commands := []


	Add(files*) {
		sFiles := this._GetFilesString(files)
		this.commands.Push("git add " sFiles)
		return this
	}

	Commit(message) {
		this.commands.Push('git commit -m "' message '"')
		return this
	}

	Push() {
		this.commands.Push("git push")
		return this
	}

	Execute() {
		this.shell.Execute(this.commands*)
		this.commands := []
		return this
	}


	_GetFilesString(files) {
		sFiles := ""
		if !files.Length {
			return "."
		}
		for index, filePath in files {
			sFiles .= '"' filePath '" '
		}
		return sFiles
	}


	/**
	* Specify a file path and get the github link for it
	* @param {String} path Path to the file / folder you want the link to. In Main/Folder/file.txt, Main is the name of the repo (so the path is relative to your gh profile, basically)
	* @returns {String} the github link
	*/
	static Link(path) {
		static github := Links['https://github.com/OverCastBTC/'] ;Specify you github link (https://github.com/yourNickname/)
		static fileBlob := "/blob/main/" ;The part between the name of the repo and the other file path is different depending on whether it's a file or a folder
		static folderBlob := "/tree/main/"

		if InStr(path, Paths.Prog "\")
			path := StrReplace(path, Paths.Prog "\")

		if InStr(path, Paths.Lib)
			path := StrReplace(path, Paths.Lib, "Lib")

		path := StrReplace(path, "\", "/") ;The link uses forward slashes, this replace is made so you can use whatever slashes you feel like

		if !InStr(path, "/") ;You can just specify the name of the repo to get a link for it
			return github path

		if !RegExMatch(path, "\/$") && RegExMatch(path, "\.\w+$") ;If the passed path ends with a /, it will be considered a path to a folder. If the passed path ends with a `.extension`, it will be considered a file
			currentBlob := fileBlob
		else
			currentBlob := folderBlob

		RegExMatch(path, "([^\/]+)\/(.*)", &match) ;Everything before the first / will be considered the name of the repo. Everything after - the relative path in this repo
		repo := match[1]
		relPath := match[2]

		github_link := StrReplace(github repo currentBlob relPath, " ", "%20")
		return github_link
	}

}