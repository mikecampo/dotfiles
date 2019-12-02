" A simple dark vim colorscheme.
" Maintainer: Michael Campagnaro <mikecampo@gmail.com>
" Version: 1.0
"
" The theme file original copied from the Tomorrow theme.
" See https://github.com/chriskempson/vim-tomorrow-theme.git for it.
" Hex color conversion functions borrowed from the theme "Desert256".

if has('termguicolors')
  " Supports 24-bit color range
  set termguicolors
  let g:campo_theme_use_rainbow_parens = 0

  let s:blue = "3699cc"
  let s:purple = "ce93d8"
  let s:grey = "b0bec5"
  let s:orange = "ffb74d"
  let s:yellow = "fff176"
  let s:green = "88b888"
  let s:red = "ef2929"

  let s:text = "e9e9e9"

  let s:foreground = s:text
  let s:background = "08363c"
  let s:selection = "546e7a"
  let s:window = "37474f"
  let s:line = "034a4a"
  let s:active_tab_bg = s:background
  let s:active_tab_fg = s:text
  let s:inactive_tab_bg = s:line
  let s:inactive_tab_fg = "dddddd"
  let s:tab_line_bg = s:inactive_tab_bg
  let s:bad_spelling = "ee877d"
  let s:todo = "b8fbb0"
  let s:bugs = "b8fbb0"
  let s:error_msg_background = s:background
  let s:error_msg_foreground = "e40e0e"

  let s:function_name = "0effdb"
  let s:pre_processor = "a6f0e9"
  let s:define = "a5bce4"
  let s:struct = "de90ea"
  " things like 'return'
  let s:statement = "ffffff"
  let s:number = "ffffff"
  " this like 'inline'
  let s:type = "ffffff"
  " #include
  let s:include = s:text
  let s:string = s:text
  let s:comment = "6df97e"
  let s:constant = "90f0f7"

  let s:c_type = s:pre_processor
  let s:c_storage_class = s:text
  let s:c_conditional = "ffffff"
  let s:c_loops = "ffffff"

  let s:vim_command = "ffffff"

else
  echoerr "This theme requires 'termguicolors' support!"
endif

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "campo-dark-blue"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
    " Returns an approximate grey index for the given grey level
    fun <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " Returns the actual grey level represented by the grey index
    fun <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " Returns the palette index for the given grey index
    fun <SID>grey_colour(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " Returns an approximate colour index for the given colour level
    fun <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " Returns the actual colour level for the given colour index
    fun <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " Returns the palette index for the given R/G/B colour indices
    fun <SID>rgb_colour(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " Returns the palette index to approximate the given R/G/B colour levels
    fun <SID>colour(r, g, b)
        " Get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " Get the closest colour
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " There are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " Use the grey
                return <SID>grey_colour(l:gx)
            else
                " Use the colour
                return <SID>rgb_colour(l:x, l:y, l:z)
            endif
        else
            " Only one possibility
            return <SID>rgb_colour(l:x, l:y, l:z)
        endif
    endfun

    " Returns the palette index to approximate the 'rrggbb' hex string
    fun <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>colour(l:r, l:g, l:b)
    endfun

    " Sets the highlighting for the given group
    fun <SID>X(group, fg, bg, attr)
        if a:fg != ""
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
    endfun

    " Vim Highlighting
    call <SID>X("Normal", s:foreground, s:background, "")
    call <SID>X("LineNr", s:grey, "", "")
    call <SID>X("NonText", s:foreground, "", "")
    call <SID>X("SpecialKey", s:blue, "", "")
    call <SID>X("Search", s:foreground, s:selection, "")
    call <SID>X("TabLineSel", s:active_tab_fg, s:active_tab_bg, "bold")
    call <SID>X("TabLine", s:inactive_tab_fg, s:inactive_tab_bg, "none")
    call <SID>X("TabLineFill", "", s:tab_line_bg, "none")
    call <SID>X("StatusLine", s:window, s:foreground, "reverse")
    call <SID>X("StatusLineNC", s:window, s:comment, "reverse")
    call <SID>X("VertSplit", s:window, s:window, "none")
    call <SID>X("Visual", "", s:selection, "")
    call <SID>X("Directory", s:blue, "", "")
    call <SID>X("ModeMsg", s:green, "", "")
    call <SID>X("MoreMsg", s:green, "", "")
    call <SID>X("Question", s:green, "", "")
    call <SID>X("WarningMsg", s:red, "", "")
    call <SID>X("MatchParen", "", s:selection, "")
    call <SID>X("Folded", s:comment, s:background, "")
    call <SID>X("FoldColumn", s:comment, s:background, "")
    if version >= 700
        call <SID>X("CursorLine", "", s:line, "none")
        call <SID>X("CursorColumn", "", s:line, "none")
        call <SID>X("PMenu", s:foreground, s:selection, "none")
        call <SID>X("PMenuSel", s:foreground, s:selection, "reverse")
        call <SID>X("SignColumn", "", s:background, "none")
    end
    if version >= 703
        call <SID>X("ColorColumn", "", s:line, "none")
    end

    " Standard Highlighting
    call <SID>X("Comment", s:comment, "", "")
    call <SID>X("Title", s:comment, "", "")
    call <SID>X("Cursor", "", s:foreground, "")
    call <SID>X("Identifier", s:grey, "", "none")
    call <SID>X("Statement", s:statement, "", "")
    call <SID>X("Conditional", s:foreground, "", "")
    call <SID>X("Repeat", s:yellow, "", "")
    call <SID>X("Structure", s:struct, "", "")
    call <SID>X("Function", s:function_name, "", "")
    call <SID>X("Constant", s:constant, "", "")
    call <SID>X("String", s:string, "", "")
    call <SID>X("Special", s:foreground, "", "")
    call <SID>X("PreProc", s:pre_processor, "", "")
    call <SID>X("Operator", s:foreground, "", "none")
    call <SID>X("Type", s:type, "", "")
    call <SID>X("Define", s:define, "", "none")
    call <SID>X("Include", s:include, "", "")
    call <SID>X("Number", s:number, "", "")
    call <SID>X("SpellBad", s:bad_spelling, s:background, "underline,bold")

    " Custom TODO/NOTE colors
    call <SID>X("Todo", s:todo, s:background, "underline")
    call <SID>X("Bugs", s:bugs, s:background, "standout")
    call <SID>X("Notes","ffffff",s:background,"standout")
    call <SID>X("Notices","dcd53e",s:background,"bold")
    call <SID>X("ErrorMsg", s:error_msg_foreground, s:error_msg_background, "bold")

    "call <SID>X("Ignore", "666666", "", "")

    " Vim Highlighting
    call <SID>X("vimCommand", s:vim_command, "", "")

    " C Highlighting
    call <SID>X("cType", s:c_type, "", "")
    call <SID>X("cStorageClass", s:c_storage_class, "", "")
    call <SID>X("cConditional", s:c_conditional, "", "")
    call <SID>X("cRepeat", s:c_loops, "", "")

    " PHP Highlighting
    call <SID>X("phpVarSelector", s:red, "", "")
    call <SID>X("phpIdentifier", s:red, "", "")
    call <SID>X("phpFCKeyword", s:purple, "", "")
    call <SID>X("phpSCKeyword", s:purple, "", "")
    call <SID>X("phpKeyword", s:purple, "", "")
    call <SID>X("phpType", s:purple, "", "")
    call <SID>X("phpRepeat", s:red, "", "")
    call <SID>X("phpDefine", s:purple, "", "")
    call <SID>X("phpDocTags", s:function_name, "", "")
    call <SID>X("phpDocParam", s:green, "", "")
    call <SID>X("phpFunction", s:blue, "", "")
    call <SID>X("phpFunctions", s:blue, "", "")
    call <SID>X("phpClass", s:blue, "", "")
    call <SID>X("phpClasses", s:orange, "", "")
    call <SID>X("phpMagicConstants", s:yellow, "", "")
    call <SID>X("phpMemberSelector", s:grey, "", "")

    " Ruby Highlighting
    call <SID>X("rubySymbol", s:green, "", "")
    call <SID>X("rubyConstant", s:foreground, "", "")
    call <SID>X("rubyAttribute", s:blue, "", "")
    call <SID>X("rubyInclude", s:blue, "", "")
    call <SID>X("rubyLocalVariableOrMethod", s:orange, "", "")
    call <SID>X("rubyCurlyBlock", s:orange, "", "")
    call <SID>X("rubyStringDelimiter", s:green, "", "")
    call <SID>X("rubyInterpolationDelimiter", s:orange, "", "")
    call <SID>X("rubyConditional", s:purple, "", "")
    call <SID>X("rubyRepeat", s:purple, "", "")

    " Python Highlighting
    call <SID>X("pythonInclude", s:red, "", "")
    call <SID>X("pythonStatement", s:blue, "", "")
    call <SID>X("pythonConditional", s:purple, "", "")
    call <SID>X("pythonRepeat", s:purple, "", "")
    call <SID>X("pythonException", s:purple, "", "")
    call <SID>X("pythonFunction", s:function_name, "", "")
    call <SID>X("pythonSelf", s:grey, "", "")
    call <SID>X("pythonOperator", s:purple, "", "")
    call <SID>X("pythonExtraOperator", s:purple, "", "")
    call <SID>X("pythonClass", s:function_name, "", "")
    call <SID>X("pythonDecorator", s:orange, "", "")
    call <SID>X("pythonDocstring", s:comment, "", "")
    call <SID>X("pythonBuiltinObj", s:yellow, "", "")
    call <SID>X("pythonBuiltinType", s:orange, "", "")
    call <SID>X("pythonNumber", s:orange, "", "")

    " Go Highlighting
    call <SID>X("goStatement", s:purple, "", "")
    call <SID>X("goConditional", s:purple, "", "")
    call <SID>X("goRepeat", s:purple, "", "")
    call <SID>X("goException", s:purple, "", "")
    call <SID>X("goDeclaration", s:blue, "", "")
    call <SID>X("goConstants", s:yellow, "", "")
    call <SID>X("goBuiltins", s:orange, "", "")

    " CoffeeScript Highlighting
    call <SID>X("coffeeKeyword", s:purple, "", "")
    call <SID>X("coffeeConditional", s:purple, "", "")
    call <SID>X("coffeeSpecialVar", s:orange, "", "")
    call <SID>X("coffeeSpecialIdent", s:red, "", "")
    call <SID>X("coffeeObject", s:orange, "", "")
    call <SID>X("coffeeObjAssign", s:blue, "", "")
    call <SID>X("coffeeArrow", s:purple, "", "")
    call <SID>X("coffeeBoolean", s:foreground, "", "")
    call <SID>X("coffeeGlobal", s:foreground, "", "")
    call <SID>X("coffeeModuleKeyword", s:function_name, "", "")
    call <SID>X("coffeeFuncCall", s:blue, "", "")

    " JavaScript Highlighting
    call <SID>X("javaScriptBraces", s:foreground, "", "")
    call <SID>X("javaScriptFunction", s:purple, "", "")
    call <SID>X("javaScriptConditional", s:purple, "", "")
    call <SID>X("javaScriptRepeat", s:purple, "", "")
    call <SID>X("javaScriptNumber", s:orange, "", "")
    call <SID>X("javaScriptMember", s:orange, "", "")

    " HTML Highlighting
    call <SID>X("htmlTag", s:foreground, "", "")
    call <SID>X("htmlTagName", s:foreground, "", "")
    call <SID>X("htmlArg", s:foreground, "", "")
    call <SID>X("htmlScriptTag", s:blue, "", "")

    " Blade Tempalte Highlight
    call <SID>X("bladeDelimiter", s:orange, "", "")
    call <SID>X("bladeKeyword", s:blue, "", "")

    " Diff Highlighting
    call <SID>X("diffAdded", "", s:green, "none")
    call <SID>X("diffRemoved", "", s:red, "none")
    call <SID>X("diffChanged", "", s:yellow, "none")
    call <SID>X("DiffAdd", s:window, s:green, "none")
    call <SID>X("DiffDelete", s:window, s:red, "none")
    call <SID>X("DiffChange", s:window, s:yellow, "none")
    call <SID>X("DiffText", s:background, s:yellow, "none")

    call <SID>X("GitGutterAdd", s:green, "", "")
    call <SID>X("GitGutterDelete", s:red, "", "")
    call <SID>X("GitGutterChange", s:yellow, "", "")
    call <SID>X("GitGutterChangeDelete", s:orange, "", "")

    call <SID>X("VimwikiHeader1", s:red, "", "")
    call <SID>X("VimwikiHeader2", s:green, "", "")
    call <SID>X("VimwikiHeader3", s:blue, "", "")
    call <SID>X("VimwikiHeader4", s:function_name, "", "")
    call <SID>X("VimwikiHeader5", s:orange, "", "")
    call <SID>X("VimwikiHeader6", s:yellow, "", "")

    " YAML
    call <SID>X("yamlBlockMappingKey", s:blue, "", "")

    " Delete Functions
    delf <SID>X
    delf <SID>rgb
    delf <SID>colour
    delf <SID>rgb_colour
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_colour
    delf <SID>grey_level
    delf <SID>grey_number
endif
