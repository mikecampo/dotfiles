" @incomplete Move all leader definitions to the bottom, so that it's easier to see them.
" @incomplete Add setup steps (plugins, cache setup, search tool, etc).

"###################################################################################################
"
" The config is chopped up into sections. These are the headings, which you
" can use to quickly jump to a particular section:

" #0 GLOBALS
" #1 PLUGINS
" #2 BASE CONFIG
" #3 PLUGIN CONFIGS
" #4 VISUALS
" #5 CUSTOM FUNCTIONS / COMMANDS
" #6 PERSONAL
"
"###################################################################################################

scriptencoding utf-8
set encoding=utf-8 fileencoding=utf-8 fileencodings=ucs-bom,utf8,prc
set nocompatible
filetype off

" Store the current system name so that we can conditionally set configs for
" different platforms
let s:uname = system("echo -n \"$(uname)\"")
let s:vim_dir = $HOME . "/.vim"
let mapleader=","

function! IsWindows()
    if s:uname =~ "mingw" || s:uname =~ "msys"
        return 1
    endif
    return 0
endfunction

"--------------------------------------------
" Colors
"--------------------------------------------
if has('termguicolors')
    set termguicolors
    " Set Vim-specific sequences for RGB colors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

let g:campo_dark_theme = 'campo-dark-simple'
"let g:campo_dark_theme = 'campo-dark-blue'
"let g:campo_dark_theme = 'campo-dark-grey-blue'
"let g:campo_dark_theme = 'campo-dark-greyscale'

let g:campo_light_theme = 'campo-light-simple'
"let g:campo_light_theme = 'campo-light-greyscale'
"let g:campo_light_theme = 'campo-light'

let g:campo_theme_use_rainbow_parens = 1
"--------------------------------------------

" You can further customize things in a private vimrc. I use this
" for things that I don't want included in my public dotfiles repo
" such as temp file settings.
source ~/.vimrc.private

"################################################################
"################################################################
"################################################################
"#0 GLOBALS
"################################################################
"################################################################
"################################################################

let s:max_line_length = 100
let g:quickfix_window_height  = 16 " in rows
" Start vim with the dark theme. Set to 'light' for the light theme.
" To change the themes see `g:campo_dark_theme` and `g:campo_light_theme`.
let s:default_bg = 'dark'
let s:rainbow_theme = s:default_bg

" ---------------------------------------------------------------------------
" @note The following globals can be used to customize various functions in
" this file. The easiest way to set them is in an .lvimrc file in the root
" folder that you want it applied to.
"
" Set this to 0 if you want to stop the removal of trailing whitespaces.
let g:campo_strip_trailing_whitespace = 1

" If g:campo_strip_trailing_whitespace is 1 then you can stop this from
" happening in specific files by setting this to a list of filenames.
" e.g. let g:campo_files_to_ignore_when_stripping_trailing_whitespace = ['app.h', 'config.h']
let g:campo_files_to_ignore_when_stripping_trailing_whitespace = []

" This is included in the ripgrep args. You can use this to do things like
" ignore folders in your project or limit the search to specific file types.
" For example, if you want to ignore the 3rd_party dir and only search C files
" (remove the backslash from the first quote as that's just here to escape it
" in this comment string)
" let g:campo_custom_search_args = \"-g \"!3rd_party/*\" -tc"
let g:campo_custom_search_args = ""

" This is included in the ctags autocmd args. You can use this to customize
" how ctags are built. For example, if you want to ignore the 3rd_party dir
" (remove the backslash from the first quote as that's just here to escape it
" in this comment string)
" let g:campo_custom_ctags_args = \"--exclude=3rd_party"
let g:campo_custom_ctags_args = ""
" ---------------------------------------------------------------------------

"################################################################
"################################################################
"################################################################
"#1 PLUGINS
"################################################################
"################################################################
"################################################################

call plug#begin('~/.vim/plugged')

"////////////////////////////////////////////////////////////////
" MISC
"////////////////////////////////////////////////////////////////

Plug 'bling/vim-airline'              " Enhanced status/tabline.
Plug 'embear/vim-localvimrc'          " Add a .lvimrc to a folder to override .vimrc config.
Plug 'tpope/vim-obsession'            " Continuously updated session files (tracks window positions, open folds, etc).
Plug 'tpope/vim-fugitive'             " Git wrapper (I particularly like :Gblame, which I've wrapped as :Blame)
Plug 'junegunn/goyo.vim'              " Distraction-free mode with centered buffer.
Plug 'sir-pinecone/vim-ripgrep'       " Fast grep-like search. Requires ripgrep; install Rust package: `cargo install ripgrep`.
Plug 'itchyny/vim-cursorword'         " Underlines all instances of the symbol under the cursor.
Plug 'airblade/vim-gitgutter'         " Displays a git diff in the vim gutter and allows staging/unstaging of hunks.
Plug 'ctrlpvim/ctrlp.vim'             " Fuzzy file, buffer, mru, tag, etc finder.
Plug 'majutsushi/tagbar'              " Display ctags in a window, ordered by scope.
Plug 'tommcdo/vim-lion'               " For text alignment, use gl= and gL=
Plug 'tpope/tpope-vim-abolish'        " Easily search for, substitute, and abbreviate multiple variants of a word. Add them to `vim/after/plugin/abolish.vim`
Plug 'vim-scripts/AnsiEsc.vim'        " Ansi escape sequences concealed, but highlighted as specified.
Plug 'tommcdo/vim-kangaroo'           " Maintain a manually-defined jump stack. Set with zp or <leader>a and pop with zP or <leader>aa.
Plug 'mh21/errormarker.vim'           " Build error highlighting (requires skywind3000/asyncrun.vim).
Plug 'skywind3000/asyncrun.vim'       " Async commands.
Plug 'nelstrom/vim-qargs'             " For the GlobalReplaceIt function (i.e. search and replace).

if IsWindows()
    Plug 'suxpert/vimcaps'            " Disable capslock (useful if the OS isn't configured to do so).
endif

"///////////////////
" MAYBE SOME DAY
"///////////////////
"Plug 'shougo/unite.vim'              " Create user interfaces. Not currently needed.
"Plug 'itchyny/vim-winfix'            " Fix the focus and the size of windows in Vim.
"Plug 'scrooloose/nerdcommenter'      " Better commenting.

"////////////////////////////////////////////////////////////////
" COLORS
"////////////////////////////////////////////////////////////////

Plug 'luochen1990/rainbow', { 'commit': '1c45e0f' } " Rainbow parens. Locked to an older commit that still works fine on my PC.
"Plug 'flazz/vim-colorschemes'        " @warning: Has a lot of themes, but they break the other themes listed below
Plug 'elixir-lang/vim-elixir'
Plug 'vim-airline/vim-airline-themes'

if IsWindows()
    Plug 'godlygeek/csapprox'         " Try to make gvim themes look decent on Windows.
endif

" Light Themes
Plug 'raggi/vim-color-raggi'          " @note No Windows support, unless using gvim.
Plug 'LanFly/vim-colors'              " @note No Windows support, unless using gvim.

" Dark Themes
Plug 'rhysd/vim-color-spring-night'   " @note No Windows support, unless using gvim.
Plug 'nanotech/jellybeans.vim'
Plug 'zcodes/vim-colors-basic'

" Hybrid Themes
Plug 'sickill/vim-monokai'
Plug 'chmllr/elrodeo-vim-colorscheme' " A little dark on Windows.
Plug 'reedes/vim-colors-pencil'       " High-contrast.
" Seabird themes
  " High contrast: seagull  (light),  petrel      (dark)
  " Low contrast:  greygull (light),  stormpetrel (dark)
Plug 'nightsense/seabird'             " @note No Windows support, unless using gvim.

"//////////////////////////////
" SYNTAX HIGHLIGHTING
"//////////////////////////////

Plug 'tpope/vim-markdown'               " Markdown
Plug 'octol/vim-cpp-enhanced-highlight' " C/C++
Plug 'vim-ruby/vim-ruby'                " Ruby
Plug 'fatih/vim-go'                     " Go
Plug 'rust-lang/rust.vim'               " Rust
Plug 'jdonaldson/vaxe'                  " Haxe
Plug 'pprovost/vim-ps1'                 " PowerShell
Plug 'fedorenchik/fasm.vim'             " Flat Assembler

" Clojure -- Disabled since I'm not doing any Clojure work atm.
"Plug 'tpope/vim-classpath' " For Java
"Plug 'guns/vim-clojure-highlight'
"Plug 'guns/vim-clojure-static'
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

"//////////////////////////////

call plug#end()
filetype plugin indent on

"---------------------------------------------------------------------------------------------------


"################################################################
"################################################################
"################################################################
"#2 BASE CONFIG
"################################################################
"################################################################
"################################################################

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hidden
set history=10000
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set laststatus=2
set showcmd                       " Display incomplete commands.
set showmatch
set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.
set dictionary+=/usr/share/dict/words
"set clipboard=unnamed            " Yank and paste with the system clipboard.
set number
set ignorecase smartcase          " Make searches case-sensitive only if they contain upper-case characters.
set visualbell                    " No bell sounds.
set ttyfast
set cmdheight=2
set switchbuf=useopen,split
set numberwidth=5
set showtabline=2
set winwidth=79

" Remove gvim Menubar and Toolbar
"set guioptions -=m
"set guioptions -=T

" @warning: This must come AFTER `set ignorecase smartcase` otherwise vim spews out a ton of errors. No idea why!
if IsWindows()
  " Just assume we don't have a zsh shell
  set shell=bash
else
  "set shell=zsh
  set shell=bash
endif

set t_ti= t_te=                   " Prevent Vim from clobbering the scrollback buffer. See http://www.shallowsky.com/linux/noaltscreen.html
set scrolloff=3                   " keep more context when scrolling off the end of a buffer
set cursorline
set cursorcolumn

" Store swap, backup and undo files in a central spot. I have my settings in
" a `vimrc.private` file that is sourced near the top of this file so
" that my drive paths aren't in this config. If you want to set them
" here then add:
"
" set directory=<dir path for swap files>
" set backupdir=<dir path for backup files>
" if has('persistent_undo')
"    set undodir=<dir path for undo files>
" endif
"
" And make sure those directories exist before opening vim.
set backup
set backupcopy=yes
augroup backupCmds
    autocmd!
    autocmd BufWritePre * let &bex = '.' . strftime("%Y-%m-%d-%T") . '.bak'
augroup END
set writebackup                   " Make buckup before overwriting the current buffer.

" Keep undo history across sessions by storing it in a file.  The undo save
" location is set in the vimrc.private file that is sourced near the top of
" this file. Alternatively, you can set it here with `set undodir=<path>`
set undolevels=1000               " Allow undo when going back into a closed file
set undoreload=10000
if has('persistent_undo')
    set undofile
endif

set backspace=indent,eol,start    " Allow backspacing over everything in insert mode.

set complete+=kspell              " Spell checking autocomplete.
set complete-=i                   " Don't scan all included files since it's really slow.

set termguicolors
syntax on                         " Enable highlighting for syntax

set wildmenu
set wildmode=longest,list,full
set wildignore+=*/log/*,*.so,*.swp,*.zip,*/rdoc/*
let &colorcolumn=s:max_line_length

set grepprg=rg\ --vimgrep         " Requires ripgrep to be installed.

set list listchars=tab:»·,trail:· " Show trailing whitespace.

set timeoutlen=300 ttimeoutlen=0  " Adding this since the esc remap on the 'i' key had a long delay when pressed.

" @fixme might be broken if lowered to 100 from original value of 4000. Will
" first try 500 and tweak from there.
" UPDATE: I lowered this to 250 and eventually started seeing some plugin
" errors related to paren formatting. I think 800 might be the sweet spot.
set updatetime=800                " I lowered this to make git-gutter updates faster.

" Fix vim's background colour erase - http://snk.tuxfamily.org/log/vim-256color-bce.html
if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif

" Disable arrow keys.
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" C/C++ template.
function! s:CFileTemplate()
    let s:env = {
        \ 'filename': expand('%:t'),
        \ 'creation_date': strftime('%Y-%m-%d'),
        \ 'year': strftime('%Y'),
        \ 'copyright_owner': 'Jelly Pixel, Inc. All Rights Reserved.'
        \}

     let l:template =<< trim EOS
        /*==================================================================================================
        File: ${filename}
        Creation Date: ${creation_date}
        Creator: Michael Campagnaro
        Notice!: (C) Copyright ${year} by ${copyright_owner}
        ================================================================================================*/

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        // # Defines
        ////////////////////////////////////////////////////////////////////////////////////////////////////

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        // # Globals
        ////////////////////////////////////////////////////////////////////////////////////////////////////

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        // # Structs
        ////////////////////////////////////////////////////////////////////////////////////////////////////

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        // # Macros
        ////////////////////////////////////////////////////////////////////////////////////////////////////

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        // # Private API
        ////////////////////////////////////////////////////////////////////////////////////////////////////

        ////////////////////////////////////////////////////////////////////////////////////////////////////
        // # Public API
        ////////////////////////////////////////////////////////////////////////////////////////////////////

EOS
    return map(l:template, { _, line -> substitute(line, '${\(.\{-}\)}', '\=get(s:env, submatch(1), submatch(1))', 'g') } )
endfunction

function! s:InsertCHeaderGates()
    let l:gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
    call append(0, '#ifndef '. l:gatename)
    call append(line('$'), '#define '. l:gatename)
    call append(line('$'), '#endif')
endfunction

" sh template
function! s:ShellScriptTemplate()
     let l:template =<< trim EOS
        #!/usr/bin/env bash

        if which tput >/dev/null 2>&1; then
          ncolors=$(tput colors)
        fi
        if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
            RED="$(tput setaf 1)"
            GREEN="$(tput setaf 2)"
            YELLOW="$(tput setaf 3)"
            BLUE="$(tput setaf 4)"
            MAGENTA="$(tput setaf 5)"
            CYAN="$(tput setaf 6)"
            BOLD="$(tput bold)"
            DIM="\e[2m"
            NORMAL="$(tput sgr0)"
        else
            RED=""
            GREEN=""
            YELLOW=""
            BLUE=""
            MAGENTA=""
            CYAN=""
            BOLD=""
            NORMAL=""
        fi

        error() {
            printf "${BOLD}${RED}$1${NORMAL}\n"
        }

        abort() {
            error "\nAborting..."
            exit 1
        }

        set -e

        cwd=$PWD

        uname_s="$(uname -s)"
        case "${uname_s}" in
            Linux*)   machine=Linux;;
            Darwin*)  machine=MacOS;;
            CYGWIN*)  machine=Cygwin;;
            MINGW*)   machine=MinGw;;
            *)        machine="UNKNOWN:${uname_s}"
        esac

        printf "${YELLOW}Platform: $machine${NORMAL}\n"
EOS
    return l:template
endfunction

augroup campoCmds
    " Clear all autocmds in the group.
    autocmd!

    " Automatically wrap at N characters.
    autocmd FileType gitcommit setlocal colorcolumn=72
    autocmd BufRead,BufNewFile *.{md,txt,plan} execute "setlocal textwidth=" .s:max_line_length

    " Spell checking.
    autocmd FileType gitcommit,markdown,text setlocal spell

    " Jump to last cursor position unless it's invalid or in an event handler.
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    " Indent HTML <p> tags.
    autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

    " Properly indent schemes (scheme, racket, etc).
    autocmd BufRead,BufNewFile *.{lisp,scm,rkt} setlocal equalprg=scmindent.rkt

    " Fasm indent; uses the fedorenchik/fasm.vim plugin.
    autocmd BufReadPre *.asm let g:asmsyntax = "fasm"

    " Auto reload VIM when settings changed.
    autocmd BufWritePost .vimrc so $MYVIMRC
    autocmd BufWritePost *.vim so $MYVIMRC
    autocmd BufWritePost ~/.vimrc.private so $MYVIMRC

    function! s:RunCtags()
        " The ampersand at the end is to make this run in the background. I had to
        " group the commands in parens to make the chained commands run in the
        " background.
        " @improve: don't run a bunch of ctags for the same project when mass
        " saving files. They all try to write and move newtags which tends to
        " lock up vim and/or spew errors.
        let l:ctags_cmd = "!(ctags --c-types=+l --c++-types=+l --exclude=*.md --exclude=*.txt --exclude=*.config --exclude=*.css --exclude=*.js --exclude=*.html --exclude=*.htm --exclude=*.json --exclude=node_modules --exclude=.git --exclude=.cache " . g:campo_custom_ctags_args . " --recurse=yes -o newtags; mv newtags tags) &"
        exec l:ctags_cmd | redraw!
    endfun

    " Generate ctags on save.
    " Also Include local variables for C-like languages.
    autocmd BufWritePost *.cs,*.js,*.py,*.c,*.cpp,*.h,*.asm silent! call s:RunCtags()

    " Remove trailing whitespace when saving any file.
    function! s:StripTrailingWhitespaces()
        if g:campo_strip_trailing_whitespace != 1
            return
        endif
        if len(g:campo_files_to_ignore_when_stripping_trailing_whitespace)
            let filename = expand('%:t')
            for ignore in g:campo_files_to_ignore_when_stripping_trailing_whitespace
                if filename == ignore
                    return
                endif
            endfor
        endif

        let l = line(".")
        let c = col(".")
        %s/\s\+$//e
        call cursor(l, c)
    endfun
    autocmd BufWritePre * call s:StripTrailingWhitespaces()

    "////////////////////////////////////////////////////////////////
    " FILE TEMPLATES
    "////////////////////////////////////////////////////////////////

    " Shell script template.
    autocmd BufNewFile *.sh call append(0, s:ShellScriptTemplate())

    " C/C++ file.
    autocmd BufNewFile *.{c,cc,cpp,h,hpp} call append(0, s:CFileTemplate())
    autocmd BufNewFile *.{h,hpp} call s:InsertCHeaderGates()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mapping ESC in insert mode and command mode to double i.
imap jj <Esc>
"cmap ii <Esc>

" Suspend vim process and return to the shell. Can return to vim with `fg`.
nmap <leader>z <c-z>

" Open the vimrc file for editing / reload vimrc file.
nmap <silent> <leader>ev :vsp $MYVIMRC<cr>
nmap <silent> <leader>pv :vsp ~/.vimrc.private<cr>
nmap <silent> <leader>rv :so $MYVIMRC<cr>

" Type %/ in the command bar to have it replaced with the current buffer's
" path if the file is on disk. One thing I noticed is that you have to type
" the full %/ quickly otherwise it won't replace it.
:cmap %/ %:p:h/

" Remap saving and quiting.
nmap <leader>w :w!<cr>
nmap <leader>q :q<cr>
nmap <leader>qq :q!<cr>
nmap <leader>x :x<cr>
:ca Wa wa!
:ca WA wa!
:ca WQ wq
:ca Wq wq
:ca W w!
:ca Q q

" Lowercase the e (have a habit of making it uppercase).
:ca E e

command! Q q " Bind :Q to :q
command! Qall qall
command! Qa qall
" Disable Ex mode.
map Q <Nop>

" Open a terminal within vim. Use `exit` to close it.
if exists(':terminal')
    map <leader>t :terminal<cr>
    tnoremap <leader>e <C-\><C-n>
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l
endif

" Jump to other buffers.
map <c-k> <c-w><Up>
map <c-j> <c-w><Down>
map <c-l> <c-w><Right>
map <c-h> <c-w><Left>

" Make it easier to jump around the command line. The default behaviour is
" using the arrow keys with or without shift.
:cnoremap <C-J> <S-Left>
:cnoremap <C-K> <S-Right>

" Window splitting - couldn't figure out how to remap <c-w>v & <c-w>n to <c-m>
" & <c-n>
map <leader>m :vsplit<cr>
map <leader>mm :split<cr>

" Forward delete and replace a word.
map <leader>d ciw

" Allow fast pasting by accessing the system clipboard register.
map <leader>p "+p
" Likely won't need to use this if pasting with <leader>p, but just in case
" here ya go.
map <leader>pp :set paste! paste?<cr>

map <leader>o :set number! number?<cr>

" Show spell checking.
" @note: you can add new entries to the dict by moving the cursor over the
" word and pressing `zg`.
map <leader>j :exec &spell==&spell? "se spell! spelllang=en_us" : "se spell!"<cr>
map <leader>= z=

" Clear the search buffer (highlighting) when hitting return.
function! MapCR()
    nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()
nnoremap <leader><leader> <c-^>

" Replace currently selected text with default register without yanking it.
vnoremap p "_dP

" Switch between C++ source and header files.
map <leader>v :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
"map <leader>vv :e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>
"map <leader>vvv :e %:p:s,.h$,.X123X,:s,.cc$,.h,:s,.X123X$,.cc,<CR>

" Replace all instances of the highlighted text with whatever you enter.
nnoremap <c-g> :%s///g<left><left>

"////////////////////////////////////////////////////////////////
" QUICKLY OPEN C++ SOURCE OR HEADER FILE
"////////////////////////////////////////////////////////////////

function! s:CompleteFilenameWithoutExtension(ArgLead, CmdLine, CursorPos)
    " Returns a matching filename without the period that separates the name
    " from the extension.
    let l:file = substitute(glob(a:ArgLead.'*', 0, 0), "[\.].*", "", "*")
    return l:file
endfunction

" Custom command to open cpp and h files without typing an extension
"command! -nargs=+ -complete=custom,s:CompleteFilenameWithoutExtension OpenCppSource execute ':e <args>.cpp'
":ca c OpenCppSource
":ca C OpenCppSource

"command! -nargs=+ -complete=custom,s:CompleteFilenameWithoutExtension OpenCppHeader execute ':e <args>.h'
":ca h OpenCppHeader
":ca H OpenCppHeader

"command! -nargs=+ -complete=custom,s:CompleteFilenameWithoutExtension OpenCppSourceAndHeader execute ':vsp | :e <args>.h | :sp <args>.cpp'
":ca b OpenCppSourceAndHeader
":ca B OpenCppSourceAndHeader

"////////////////////////////////////////////////////////////////
" MULTIPURPOSE TAB KEY
"////////////////////////////////////////////////////////////////
function! InsertTabWrapper()
    let l:col = col('.') - 1
    if !l:col || getline('.')[l:col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>


"---------------------------------------------------------------------------------------------------


"################################################################
"################################################################
"################################################################
"#3 PLUGIN CONFIGS
"################################################################
"################################################################
"################################################################


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LOCAL VIMRC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TAGBAR
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <F12> :TagbarToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KANGAROO
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>a zp
nmap <leader>aa zP

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GITGUTTER
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled = 1
let g:gitgutter_highlight_lines = 0
nmap <leader>ha <Plug>GitGutterStageHunk
nmap <leader>hh :GitGutterToggle<cr>
nmap [h <Plug>GitGutterNextHunk
nmap ]h <Plug>GitGutterPrevHunk

augroup gitGutterPluginCmds
    autocmd!
    " Update marks on save
    autocmd BufWritePost * GitGutter
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SYNTASTIC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: there is a status line config in the status line section
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" Customize Rust
" https://github.com/rust-lang/rust.vim/issues/130
" Can remove once this Syntastic PR is merged https://github.com/rust-lang/rust.vim/pull/132
"let g:syntastic_rust_rustc_exe = 'cargo check'
"let g:syntastic_rust_rustc_fname = ''
"let g:syntastic_rust_checkers = ['rustc']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RIPGREP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rg_highlight = 1
let g:rg_window_height = g:quickfix_window_height

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTRL-P
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" keybindings:
"
" leader-f         = open CtrlP in tag searching mode.
" leader-g         = open CtrlP in file searching mode.
" ctrl-f           = toggle search mode
" enter            = open result in a current buffer or in an already open buffer for that file.
" ctrl-v           = open result in a vertically-split buffer.
" ctrl-h           = open result in a horizontally-split buffer.
" ctrl-t           = open result in a new tab.
" ctrl-j | ctrl-k  = move up and down the search results.
" ctrl-y           = create file and open it.
" ctrl-z           = mark multiple file search results to open (I think you can only use ctrl-v or ctrl-x and not enter).
" ctrl-o           = ask how to open a file search result.
" ctrl-o           = ask how to open a file search result.
" ctrl-p | ctrl-n  = traverse search history.

map <leader>g :CtrlP<cr>
let g:ctrlp_map = '<leader>f'
let g:ctrlp_cmd = 'CtrlPTag' " Search tags by default.
let g:ctrlp_by_filename = 1  " File search by filename as opposed to full path.
let g:ctrlp_match_window = 'bottom,order:ttb,min:10,max:20,results:20' " Keep results synced with max height.
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files'] " If a git repo, use checked in files; fallback to globpath()
let g:ctrlp_clear_cache_on_exit = 1 " No need to keep cache for now since I mostly work in git repos. Press F5 inside CtrlP to rebuild the cache.

" @fixme Not sure why I can't get these new mappings (c-m, c-cr) to register...
"let g:ctrlp_prompt_mappings = {
"  \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>'],
"  \ 'AcceptSelection("v")': ['<c-v>', '<c-m>'],
"  \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GIT
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <leader>gb :Gblame -w<cr>
" Ignore whitespace changes; follow renames and copies.
command! -bar -bang -nargs=* Blame :Gblame<bang> -wCM <args>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GIST VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_show_privates = 1
let g:gist_post_private = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM-CLOJURE-STATIC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Default
let g:clojure_fuzzy_indent = 1
let g:clojure_align_multiline_strings = 1
let g:clojure_fuzzy_indent_patterns = ['^match', '^with', '^def', '^let']
let g:clojure_fuzzy_indent_blacklist = ['-fn$', '\v^with-%(meta|out-str|loading-context)$']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUST.VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:rustfmt_autosave = 1 " auto run rust formatter when saving

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RAINBOW
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 1 " Always on
let s:light_rainbow = ['red', 'green', 'magenta', 'cyan', 'yellow', 'white', 'gray', 'blue']
let s:dark_rainbow = ['darkblue', 'red', 'black', 'darkgreen', 'darkyellow', 'darkred', 'darkgray']

function! UpdateRainbowConf()
    let g:rainbow_conf = {
        \   'ctermfgs': (s:rainbow_theme == "light"? s:dark_rainbow : s:light_rainbow)
     \}
"\   'separately': {
"\       '*': 0, " Disable all
"\       'c++': {} " Only enable c++
"\   }
endfunction

call UpdateRainbowConf()

function! ReloadRainbow()
    if g:campo_theme_use_rainbow_parens
        if exists(':RainbowToggle')
            call UpdateRainbowConf()
            call rainbow#clear() | call rainbow#hook()
        endif
    else
        let g:rainbow_active = 0
        if exists(':RainbowToggle')
            call UpdateRainbowConf()
            call rainbow#clear()
        endif
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C-TAGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tags+=tags;$HOME

"---------------------------------------------------------------------------------------------------

"################################################################
"################################################################
"################################################################
"#4 VISUALS
"################################################################
"################################################################
"################################################################


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LAYOUT
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"////////////////////////////////////////////////////////////////
" CENTER THE BUFFER
"////////////////////////////////////////////////////////////////

function! CenterPane()
    " centers the current pane as the middle 2 of 4 imaginary columns
    " should be called in a window with a single pane
    " Taken from https://dev.to/vinneycavallo/easily-center-content-in-vim
    lefta vnew
    wincmd w
    exec 'vertical resize '. string(&columns * 0.75)
endfunction
nnoremap <leader>c :call CenterPane()<cr>

function! RemoveCenterPane()
    wincmd w
    close
endfunction
nnoremap <leader>cw :call RemoveCenterPane()<cr>


"////////////////////////////////////////////////////////////////
" TEXT ALIGNMENT PLUGIN
"////////////////////////////////////////////////////////////////
let b:lion_squeeze_spaces = 1


"////////////////////////////////////////////////////////////////
" STATUS LINE
"////////////////////////////////////////////////////////////////
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLORS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

execute "autocmd ColorScheme " . g:campo_dark_theme . " call ReloadRainbow()"
execute "autocmd ColorScheme " . g:campo_light_theme . " call ReloadRainbow()"

" Switch between light and dark themes.
map <leader>l :call ChangeBgTheme('light', 0)<cr>
map <leader>ll :call ChangeBgTheme('dark', 0)<cr>

function! ChangeBgTheme(bg, onlySetTheme)
    if a:bg =~ 'light'
        let s:rainbow_theme = 'light'
        let s:theme = g:campo_light_theme
        exe 'colorscheme ' . s:theme
        set background=light
    else
        let s:rainbow_theme = 'dark'
        let s:theme = g:campo_dark_theme
        " We have to set the theme twice in order to get its correct dark-theme colors.
        " Weird stuff.
        exe 'colorscheme ' . s:theme
        set background=dark
        exe 'colorscheme ' . s:theme
    endif

    if !a:onlySetTheme
        exec ':AirlineTheme ' . a:bg
    endif
endfunction

if s:default_bg =~ 'light'
  call ChangeBgTheme('light', 1)
else
  call ChangeBgTheme('dark', 1)
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HIGHLIGHTS - TODO, NOTE, FIXME, etc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" NOTE: These depend on custom color names (Bugs, Notes and Notices) defined
" in the campo color themes. Since most themes won't define these, you can
" use WildMenu as substitution.
"
" FIXME: the custom Bugs, Notes and Notices highlighting for campo-light isn't
" working...

augroup vimrc_bugs
    autocmd!
    autocmd Syntax * syn match MyBugs /\v<(FIXME|BUG|DEPRECATED):/
          \ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyBugs Bugs

augroup vimrc_notes
    autocmd!
    autocmd Syntax * syn match MyNotes /\v<(IDEA|NOTE|QUESTION|WARNING|IMPORTANT):/
          \ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyNotes Notes

augroup vimrc_notices
    au!
    autocmd Syntax * syn match MyNotices /\v<(WARNING|IMPORTANT):/
          \ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyNotices Notices

augroup vimrc_annotated_todo
    autocmd!
    " This was a major pain in the ass to get working...
    autocmd Syntax * syn match cTodo /@\S\+/
          \ containedin=.*Comment,vimCommentTitle
augroup END

augroup vimrc_annotated_notes
    autocmd!
    autocmd Syntax * syn match cTodo /#\+ .\+$/
          \ containedin=.*Comment,vimCommentTitle
augroup END

"---------------------------------------------------------------------------------------------------

"################################################################
"################################################################
"################################################################
"#5 CUSTOM FUNCTIONS / COMMANDS
"################################################################
"################################################################
"################################################################

function! PrintError(msg) abort
    execute 'normal! \<Esc>'
    echohl ErrorMsg
    echomsg a:msg
    echohl None
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BUILD COMMANDS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" AsyncRun status line
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])

" Display error highlighting in source after running GCC with AsyncRun
" NOTE: error results can be cleared with <leader>cr or by hiding the build
" result window.
let g:asyncrun_auto = "make"
let errormarker_errortext = "E"
let errormarker_warningtext = "W"

" Thanks to https://forums.handmadehero.org/index.php/forum?view=topic&catid=4&id=704#3982
" for the error message formats
"
" Microsoft MSBuild errors
set errorformat+=\\\ %#%f(%l\\\,%c):\ %m
" Microsoft compiler: cl.exe
set errorformat+=\\\ %#%f(%l)\ :\ %#%t%[A-z]%#\ %m
" Microsoft HLSL compiler: fxc.exe
set errorformat+=\\\ %#%f(%l\\\,%c-%*[0-9]):\ %#%t%[A-z]%#\ %m

function! HideBuildResultsAndClearErrors()
    RemoveErrorMarkers
    call asyncrun#quickfix_toggle(g:quickfix_window_height, 0)
endfunction

function! HideAsyncResults()
    call asyncrun#quickfix_toggle(g:quickfix_window_height, 0)
endfunction

function! ToggleBuildResults()
    call asyncrun#quickfix_toggle(g:quickfix_window_height)
endfunction

function! StopRunTask()
    AsyncStop
    call HideAsyncResults()
endfunction

function! ExecuteRunScript()
    exec "AsyncRun! -post=call\\ StopRunTask() ./run %"
endfunction

function! SilentBuild()
    AsyncStop
    exec "AsyncRun! -save=2 -post=call\\ HideAsyncResults() ./build* %"
endfunction

" Show results window the moment the async job starts
augroup asyncPluginCmds
    autocmd!
    autocmd User AsyncRunStart call asyncrun#quickfix_toggle(g:quickfix_window_height, 1)
augroup END

" Toggle build results
noremap <F11> :call ToggleBuildResults()<cr>
nnoremap <leader>bc :call ToggleBuildResults()<cr>

" Hide build results and clear errors
noremap <F10> :call HideBuildResultsAndClearErrors()<cr>

" Execute build script
nnoremap <leader>b :AsyncRun! -save=2 ./build* %<cr>
nnoremap <F8> :call SilentBuild()<cr>

" Execute run script
nnoremap <leader>br :call ExecuteRunScript()<cr>
nnoremap <F9> :call ExecuteRunScript()<cr>

nnoremap <leader>bs :AsyncStop<cr>

"Go to next build error
nnoremap <F7> :cn<CR>
nnoremap <C-n> :cn<CR>

"Go to previous build error
nnoremap <F6> :cp<CR>
nnoremap <C-p> :cp<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SEARCH
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Search using ripgrep (first install with Rust: cargo install ripgrep).
function! Search(case_sensitive)
    let l:helper = "[" . (a:case_sensitive ? "case-sensitive" : "case-insensitive") . "] search: "
    let l:term = input(l:helper)
    if empty(l:term)
        return
    endif

    "@note --pretty (i.e. colors) is not enabled in vim-ripgrep because the
    "quickfix window doesn't seem to parse the ansi color codes.
    let l:rg_args = "--column --line-number --no-heading --fixed-strings --no-ignore --hidden --follow --trim -g \"!tags\" " . g:campo_custom_search_args

    if !a:case_sensitive
        let l:rg_args .= " --ignore-case"
    endif

    exec 'Rg ' . l:rg_args . ' "' . l:term . '"'
endfunction
map <leader>s :call Search(0)<cr>
map <leader>ss :call Search(1)<cr>

" Navigation for the vim-ripgrep search results.
" Hit o on a result line to open the file at that line.
" Hit p on a result line to open the file at that line and return to the results pane.
nnoremap <expr> o (&buftype is# "quickfix" ? "<CR>\|:lopen<CR>" : "o")
nnoremap <expr> p (&buftype is# "quickfix" ? "<CR>\|:copen<CR>" : "p")

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SEARCH & REPLACE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Replace the selected text in all files within the repo.
function! GlobalReplaceIt(confirm_replacement)
    if exists(':Ggrep')
        call inputsave()

        if a:confirm_replacement
            let l:term = input('Enter search term (w/ confirmation): ')
        else
            let l:term = input('Enter search term (no confirmation): ')
        endif

        call inputrestore()
        if empty(l:term)
            return
        endif

        call inputsave()
        let l:replacement = input('Enter replacement: ')
        call inputrestore()
        if empty(l:replacement)
            return
        endif

        if a:confirm_replacement
            let l:confirm_opt = 'c'
        else
            let l:confirm_opt = 'e'
        endif

        execute 'Ggrep '.l:term
        execute 'Qargs | argdo %s/'.l:term.'/'.l:replacement.'/g'.l:confirm_opt
    else
        PrintError "Unable to search since you're not in a git repo!"
    endif
endfunction
map <leader>r :call GlobalReplaceIt(0)<cr>
map <leader>rr :call GlobalReplaceIt(1)<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let l:old_name = expand('%')
    let l:new_name = input('New file name: ', expand('%'), 'file')
    if l:new_name != '' && l:new_name != l:old_name
        exec ':saveas ' . l:new_name
        exec ':silent !rm ' . l:old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>


"---------------------------------------------------------------------------------------------------


"################################################################
"################################################################
"################################################################
"#6 PERSONAL
"################################################################
"################################################################
"################################################################

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FILE MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Notes and other helpers
map <leader>pn :sp ~/.dev-scratchpad.md<cr>

"let g:autotagStopAt = "$HOME"

