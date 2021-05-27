" A simple light colorscheme.
" Maintainer: Michael Campagnaro <mikecampo@gmail.com>
" Version: 1.0
"
" Adapted from https://github.com/tek256/simple-dark

if has('termguicolors')
  " Supports 24-bit color range
  set termguicolors
  let g:campo_theme_use_rainbow_parens = 1
else
  echoerr "This theme requires 'termguicolors' support!"
endif

set background=light
hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "campo-light-simple"

if has("gui_running") || &t_Co == 256
    hi NonText cterm=NONE ctermfg=black ctermbg=black gui=NONE guifg=#263238 guibg=#fbfbfb
    hi Normal cterm=NONE ctermfg=250 ctermbg=black gui=NONE guifg=#263238 guibg=#fbfbfb
    hi Keyword cterm=NONE ctermfg=255 ctermbg=black gui=NONE guifg=#263238 guibg=#fbfbfb
    hi Constant cterm=NONE ctermfg=252 ctermbg=black gui=NONE guifg=#263238 guibg=#fbfbfb
    hi String cterm=NONE ctermfg=245 ctermbg=black gui=NONE guifg=#263238 guibg=#fbfbfb
    hi Comment cterm=NONE ctermfg=240 ctermbg=black gui=NONE guifg=#7c7c7c guibg=#fbfbfb
    hi Number cterm=NONE ctermfg=255  ctermbg=black gui=NONE guifg=#0000ff guibg=#fbfbfb
    hi Error cterm=NONE ctermfg=255 ctermbg=DarkGray gui=NONE guifg=#263238 guibg=#fbfbfb " Should match the text colors
    hi ErrorMsg cterm=bold ctermfg=255 ctermbg=DarkGray gui=NONE guifg=#ff0000 guibg=#fbfbfb
    hi Search cterm=NONE ctermfg=255 ctermbg=245 gui=reverse guifg=#263238 guibg=#cccccc
    hi IncSearch cterm=reverse ctermfg=255 ctermbg=245 gui=reverse guifg=#263238 guibg=#fbfbfb
    hi DiffChange cterm=NONE ctermfg=240 ctermbg=255 gui=NONE guifg=#8a8a8a guibg=#fbfbfb
    hi DiffText cterm=bold ctermfg=255 ctermbg=DarkGray gui=bold guifg=#263238 guibg=#fbfbfb
    hi SignColumn cterm=NONE ctermfg=240 ctermbg=black gui=NONE guifg=#8a8a8a guibg=#fbfbfb
    hi SpellBad cterm=undercurl ctermfg=255 ctermbg=245 gui=undercurl guifg=#ff0000 guibg=#fbfbfb
    hi SpellCap cterm=NONE ctermfg=255 ctermbg=124 gui=NONE guifg=#ff0000 guibg=#fbfbfb
    hi SpellRare cterm=NONE ctermfg=240 ctermbg=16 gui=NONE guifg=#ff0000 guibg=#fbfbfb
    hi WildMenu cterm=NONE ctermfg=240 ctermbg=255 gui=NONE guifg=#585858 guibg=#fbfbfb
    hi Pmenu cterm=NONE ctermfg=255 ctermbg=240 gui=NONE guifg=#eeeeee guibg=#333333    " autocomplete menu
    hi PmenuSel cterm=bold ctermfg=255 ctermbg=240 gui=NONE guifg=#eeeeee guibg=#454545 " autocomplete menu selection
    hi PmenuThumb cterm=NONE ctermfg=232 ctermbg=240 gui=NONE guifg=NONE guibg=#cccccc  " autocomplete scroller bar
    hi PmenuSbar cterm=NONE ctermfg=232 ctermbg=240 gui=NONE guifg=NONE guibg=#454545   " autocomplete scroller background
    hi SpecialKey cterm=NONE ctermfg=16 ctermbg=255 gui=NONE guifg=#ff00ff guibg=#fbfbfb
    hi MatchParen cterm=bold ctermfg=white ctermbg=black gui=NONE guifg=#000000 guibg=#dddddd
    hi CursorLine cterm=NONE ctermfg=NONE ctermbg=233 gui=NONE guifg=NONE guibg=#dddddd
    hi CursorColumn cterm=NONE ctermfg=NONE ctermbg=233 gui=NONE guifg=NONE guibg=#dddddd
    hi ColorColumn cterm=NONE ctermfg=NONE ctermbg=255 gui=NONE guifg=NONE guibg=#dddddd
    hi StatusLine cterm=bold,reverse ctermfg=245 ctermbg=black gui=bold,reverse guifg=#8a8a8a guibg=#fbfbfb
    hi StatusLineNC cterm=reverse ctermfg=236 ctermbg=black gui=reverse guifg=#303030 guibg=#fbfbfb
    hi Visual cterm=reverse ctermfg=250 ctermbg=black gui=reverse guifg=#263238 guibg=#fbfbfb
    hi VertSplit cterm=NONE ctermfg=Gray ctermbg=black gui=NONE guifg=#aaaaaa guibg=#dddddd
    hi TermCursor cterm=reverse ctermfg=NONE ctermbg=NONE gui=reverse guifg=NONE guibg=NONE
    hi TabLineSel cterm=bold ctermfg=250 ctermbg=black gui=NONE guifg=#263238 guibg=#fbfbfb " Active tab label
    hi TabLine cterm=NONE ctermfg=250 ctermbg=black gui=NONE guifg=#4a4a4a guibg=#aaaaaa    " Inactive tab label
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
highlight! link CursorLineNr String
highlight! link Character Number
highlight! link Float Number
highlight! link Tag Number
highlight! link Folded Number
highlight! link WarningMsg Number
highlight! link iCursor SpecialKey
highlight! link SpellLocal SpellCap
highlight! link LineNr Comment
highlight! link NonText NonText
highlight! link DiffDelete Comment
highlight! link diffRemoved Comment
highlight! link VisualNOS Visual
highlight! link VertSplit VertSplit
highlight! link Cursor StatusLine
highlight! link Underlined SpellRare
highlight! link rstEmphasis SpellRare
highlight! link diffChanged DiffChange
