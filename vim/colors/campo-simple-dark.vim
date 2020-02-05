" A simple dark colorscheme.
" Maintainer: Michael Campagnaro <mikecampo@gmail.com>
" Version: 1.0
"
" Adapted from https://github.com/tek256/simple-dark

if has('termguicolors')
  " Supports 24-bit color range
  set termguicolors
  let g:campo_theme_use_rainbow_parens = 0
else
  echoerr "This theme requires 'termguicolors' support!"
endif

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "campo-simple-dark"

if has("gui_running") || &t_Co == 256
    hi NonText cterm=NONE ctermfg=black ctermbg=black gui=NONE guifg=bg guibg=#0a0a0a
    hi Normal cterm=NONE ctermfg=250 ctermbg=black gui=NONE guifg=#ffffff guibg=#0a0a0a
    hi Keyword cterm=NONE ctermfg=255 ctermbg=black gui=NONE guifg=#ffffff guibg=#0a0a0a
    hi Constant cterm=NONE ctermfg=252 ctermbg=black gui=NONE guifg=#d0d0d0 guibg=#0a0a0a
    hi String cterm=NONE ctermfg=245 ctermbg=black gui=NONE guifg=#aaaaaa guibg=#0a0a0a
    hi Comment cterm=NONE ctermfg=240 ctermbg=black gui=NONE guifg=#777777 guibg=#0a0a0a
    hi Number cterm=NONE ctermfg=255  ctermbg=black gui=NONE guifg=#ff0000 guibg=#0a0a0a
    hi LineNr cterm=NONE ctermfg=255  ctermbg=black gui=NONE guifg=#454545 guibg=#0a0a0a
    hi Error cterm=NONE ctermfg=255 ctermbg=DarkGray gui=NONE guifg=#eeeeee guibg=#0a0a0a " Should match the text colors
    hi ErrorMsg cterm=bold ctermfg=255 ctermbg=DarkGray gui=NONE guifg=#ff0000 guibg=#0a0a0a
    hi Search cterm=NONE ctermfg=245 ctermbg=Gray gui=NONE guifg=#fff229 guibg=#0a0a0a
    hi IncSearch cterm=reverse ctermfg=255 ctermbg=245 gui=reverse guifg=#ffffff guibg=#0a0a0a
    hi DiffChange cterm=NONE ctermfg=240 ctermbg=255 gui=NONE guifg=#8a8a8a guibg=#0a0a0a
    hi DiffText cterm=bold ctermfg=255 ctermbg=DarkGray gui=bold guifg=#bcbcbc guibg=#0a0a0a
    hi SignColumn cterm=NONE ctermfg=240 ctermbg=black gui=NONE guifg=#8a8a8a guibg=#0a0a0a
    hi SpellBad cterm=underline ctermfg=255 ctermbg=245 gui=undercurl guifg=#ff0000 guibg=#0a0a0a
    hi SpellCap cterm=NONE ctermfg=255 ctermbg=124 gui=NONE guifg=#eeeeee guibg=#0a0a0a
    hi SpellRare cterm=NONE ctermfg=240 ctermbg=16 gui=NONE guifg=#8a8a8a guibg=#0a0a0a
    hi WildMenu cterm=NONE ctermfg=240 ctermbg=255 gui=NONE guifg=#585858 guibg=#0a0a0a
    hi Pmenu cterm=NONE ctermfg=255 ctermbg=240 gui=NONE guifg=#eeeeee guibg=#333333
    hi PmenuThumb cterm=NONE ctermfg=232 ctermbg=240 gui=NONE guifg=#eeeeee guibg=#444444
    hi PmenuSel cterm=bold,reverse ctermfg=250 ctermbg=black gui=reverse guifg=#bcbcbc guibg=#0a0a0a
    hi SpecialKey cterm=NONE ctermfg=16 ctermbg=255 gui=NONE guifg=#eeeeee guibg=#0a0a0a
    hi MatchParen cterm=bold ctermfg=white ctermbg=black gui=NONE guifg=#bcbcbc guibg=#454545
    hi CursorLine cterm=NONE ctermfg=NONE ctermbg=233 gui=NONE guifg=NONE guibg=#222222
    hi CursorColumn cterm=NONE ctermfg=NONE ctermbg=233 gui=NONE guifg=NONE guibg=#222222
    hi ColorColumn cterm=NONE ctermfg=NONE ctermbg=255 gui=NONE guifg=NONE guibg=#444444
    hi StatusLine cterm=bold,reverse ctermfg=245 ctermbg=black gui=bold,reverse guifg=#8a8a8a guibg=#0a0a0a
    hi StatusLineNC cterm=reverse ctermfg=236 ctermbg=black gui=reverse guifg=#303030 guibg=#0a0a0a
    hi Visual cterm=reverse ctermfg=250 ctermbg=black gui=reverse guifg=#bcbcbc guibg=#0a0a0a
    hi VertSplit cterm=NONE ctermfg=Gray ctermbg=black gui=NONE guifg=#0a0a0a guibg=#454545
    hi TermCursor cterm=reverse ctermfg=NONE ctermbg=NONE gui=reverse guifg=NONE guibg=NONE
    hi TabLineSel cterm=bold ctermfg=250 ctermbg=black gui=NONE guifg=#cccccc guibg=#0a0a0a " Active tab label
    hi TabLine cterm=NONE ctermfg=250 ctermbg=black gui=NONE guifg=#888888 guibg=#1d1d1d    " Inactive tab label
endif

highlight! link Boolean Normal
highlight! link Delimiter Normal
highlight! link Identifier Normal
highlight! link Title Normal
highlight! link TabLineFill TabLine  " Tabline background
highlight! link Debug Normal
highlight! link Exception Normal
highlight! link FoldColumn Normal
highlight! link Macro Normal
highlight! link ModeMsg Normal
highlight! link MoreMsg Normal
highlight! link Question Normal
highlight! link Conditional Keyword
highlight! link Statement Keyword
highlight! link Operator Keyword
highlight! link Structure Keyword
highlight! link Function Keyword
highlight! link Include Keyword
highlight! link Type Keyword
highlight! link Typedef Keyword
highlight! link Todo Keyword
highlight! link Label Keyword
highlight! link Define Keyword
highlight! link DiffAdd Keyword
highlight! link diffAdded Keyword
highlight! link diffCommon Keyword
highlight! link Directory Keyword
highlight! link PreCondit Keyword
highlight! link PreProc Keyword
highlight! link Repeat Keyword
highlight! link Special Keyword
highlight! link SpecialChar Keyword
highlight! link StorageClass Keyword
highlight! link SpecialComment String
highlight! link CursorLineNr Keyword
highlight! link Character Number
highlight! link Float Number
highlight! link Tag Number
highlight! link Folded Number
highlight! link WarningMsg Number
highlight! link iCursor SpecialKey
highlight! link SpellLocal SpellCap
highlight! link NonText NonText
highlight! link DiffDelete Comment
highlight! link diffRemoved Comment
highlight! link PmenuSbar Visual
highlight! link VisualNOS Visual
highlight! link VertSplit VertSplit
highlight! link Cursor StatusLine
highlight! link Underlined SpellRare
highlight! link rstEmphasis SpellRare
highlight! link diffChanged DiffChange
