if exists("b:current_syntax")
  finish
endif

syn case match
syn sync minlines=200

syn keyword hytaleuiTodo contained TODO FIXME XXX NOTE HACK
syn match hytaleuiComment "//.*$" contains=hytaleuiTodo,@Spell
syn region hytaleuiComment start="/\*" end="\*/" contains=hytaleuiTodo,@Spell

syn match hytaleuiEscape contained "\\."
syn region hytaleuiString start=+"+ skip=+\\"+ end=+"+ contains=hytaleuiEscape,@Spell

syn match hytaleuiId "#[A-Za-z_]\w*"
syn match hytaleuiColor "#\x\{3\}\>"
syn match hytaleuiColor "#\x\{4\}\>"
syn match hytaleuiColor "#\x\{6\}\>"
syn match hytaleuiColor "#\x\{8\}\>"

syn match hytaleuiVariable "\$[A-Za-z_]\w*"
syn match hytaleuiTemplate "@[A-Za-z_]\w*"
syn match hytaleuiOperator "\.\.\."

syn match hytaleuiNumber "\<-\?\d\+\%(\.\d\+\)\?\>"

syn keyword hytaleuiBoolean true false
syn keyword hytaleuiConstant None Center Left Right Top Bottom Start End Middle Stretch Fill Auto Horizontal Vertical

syn match hytaleuiProperty "\<[A-Za-z_]\w*\ze\s*:"
syn match hytaleuiType "\<[A-Z]\w*\ze\s*[#({]"

syn keyword hytaleuiWidget Group Label TextButton SecondaryTextButton CancelTextButton PrimaryBtn SuccessBtn CloseBtn BackButton MenuBtn Button TextField NumberField ItemGrid ItemSlot ItemTile DropdownBox CheckBox ProgressBarTrack NavigationBar NavBar TabBar PageOverlay DecoratedContainer GameFrame

syn match hytaleuiDelimiter "[{}()]"

hi def link hytaleuiComment Comment
hi def link hytaleuiTodo Todo
hi def link hytaleuiString String
hi def link hytaleuiEscape SpecialChar
hi def link hytaleuiColor Constant
hi def link hytaleuiId Identifier
hi def link hytaleuiVariable Define
hi def link hytaleuiTemplate PreProc
hi def link hytaleuiOperator Operator
hi def link hytaleuiNumber Number
hi def link hytaleuiBoolean Boolean
hi def link hytaleuiConstant Constant
hi def link hytaleuiProperty Keyword
hi def link hytaleuiType Type
hi def link hytaleuiWidget Structure
hi def link hytaleuiDelimiter Delimiter

let b:current_syntax = "hytaleui"
