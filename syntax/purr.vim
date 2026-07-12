if exists("b:current_syntax")
  finish
endif

syn case match
syn sync minlines=150

" comments
syn keyword purrTodo contained TODO FIXME XXX NOTE HACK
syn match purrComment "//.*$" contains=purrTodo,@Spell
syn region purrComment start="/\*" end="\*/" contains=purrTodo,purrComment,@Spell

" keywords
syn keyword purrKeyword let const mut fn use impl as
syn keyword purrConditional if else match
syn keyword purrRepeat while for in
syn keyword purrStatement break continue return
syn keyword purrStructure enum struct trait
syn keyword purrBoolean true false
syn keyword purrConstant nil self
syn keyword purrConstant PI E TAU INF NAN

" optional type annotations
syn keyword purrType int float num number str string bool any
syn keyword purrType u8 u16 u32 u64 usize i8 i16 i32 i64 isize f32 f64
syn keyword purrType Result Option

" built-in functions
syn keyword purrBuiltin print println write eprintln input
syn keyword purrBuiltin str repr num int bool len type assert exit args meow
syn keyword purrBuiltin is_nil is_number is_string is_bool is_array is_map is_function
syn keyword purrBuiltin map filter reduce each find any all sort
syn keyword purrBuiltin push pop insert remove_at range slice reverse concat flatten unique sum index_of contains
syn keyword purrBuiltin keys values has remove
syn keyword purrBuiltin upper lower trim chars split join replace starts_with ends_with repeat pad_start pad_end
syn keyword purrBuiltin floor ceil round abs sign sqrt pow exp ln log10 sin cos tan min max random randint clock
syn keyword purrBuiltin read_file write_file
syn keyword purrConstructor Ok Err Some None

" strings with ${...} interpolation and escapes
syn match purrEscape contained "\\\([ntr0\\\"$]\|x\x\x\|u{\x\+}\)"
syn match purrInterpDelim contained "\${" nextgroup=purrInterpBody
syn region purrInterp contained matchgroup=purrInterpDelim start="\${" end="}" contains=purrNumber,purrBoolean,purrConstant,purrConstructor,purrBuiltin,purrString,purrOperator
syn region purrString start=+"+ skip=+\\.+ end=+"+ contains=purrEscape,purrInterp,@Spell

" numbers (decimal, hex, binary, octal, exponent, underscores)
syn match purrNumber "\<\d[0-9_]*\%(\.\d[0-9_]*\)\?\%([eE][+-]\?\d\+\)\?\>"
syn match purrNumber "\<0[xX][0-9a-fA-F_]\+\>"
syn match purrNumber "\<0[bB][01_]\+\>"
syn match purrNumber "\<0[oO][0-7_]\+\>"

" types / enum variants (PascalCase) and function calls
syn match purrTypeName "\<\u\w*\>"
syn match purrFunctionCall "\<\l\w*\ze\s*("
syn match purrField "\.\zs\l\w*"

" operators
syn match purrOperator "?\|->\|=>\|\.\.=\|\.\.\|::\|&&\|||\|==\|!=\|<=\|>=\|+=\|-=\|\*=\|/=\|%=\|\*\*"
syn match purrOperator "[-+*/%<>=!|&]"

hi def link purrComment Comment
hi def link purrTodo Todo
hi def link purrKeyword Keyword
hi def link purrConditional Conditional
hi def link purrRepeat Repeat
hi def link purrStatement Statement
hi def link purrStructure Structure
hi def link purrBoolean Boolean
hi def link purrConstant Constant
hi def link purrType Type
hi def link purrTypeName Type
hi def link purrBuiltin Function
hi def link purrConstructor Constant
hi def link purrFunctionCall Function
hi def link purrField Identifier
hi def link purrString String
hi def link purrEscape SpecialChar
hi def link purrInterp Special
hi def link purrInterpDelim SpecialChar
hi def link purrNumber Number
hi def link purrOperator Operator

let b:current_syntax = "purr"
