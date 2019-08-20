"
" ██╗███████╗ █████╗  █████╗  ██████╗███████╗    ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
" ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝    ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
" ██║███████╗███████║███████║██║     ███████╗    ██║   ██║██║██╔████╔██║██████╔╝██║
" ██║╚════██║██╔══██║██╔══██║██║     ╚════██║    ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
" ██║███████║██║  ██║██║  ██║╚██████╗███████║     ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
" ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝      ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"

"==>base vim setup<==

" Jump to last open
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"Indentation rules for language
filetype plugin indent on
"lets be real, i only use the terminal.
if has("gui_running")
    set guifont=Hack\ 10
endif
"why not use ed otherwise?
syntax on
"what am i typing
set showcmd
"what did i pick
set showmatch
"follow case like a normal person
set ignorecase
set smartcase
"i only have so much screen space
set wrap
"go back like a normal person
set backspace=indent,eol,start
"duh
set autoindent
set copyindent

"line numbers
set number
"setting both gives you 'hybrid' line numbers
"this ensures that i only have it when im not in insert
augroup numbertoggle
    autocmd!
    autocmd bufenter,insertleave * set relativenumber
    autocmd bufleave,insertenter * set norelativenumber
augroup END

"whats open?
set title
"dont care if its not valid,dont tell me
set noerrorbells
"PLEASE SAVE ALL MY MISTAKES
"(when i didnt have this before i wiped my hosts file)
set undofile
set undolevels=1000
set undoreload=10000
"reload when i change it with say git
set autoread
"manage buffers nicely
"if i open another file over an existing one, keep the other in the background
set hidden
"give it a little bigger of a bump when i go off the edge
set scrolloff=3
set sidescrolloff=5
"i dont want to press enter when a command is done
set shortmess=atI
"the extension likely isnt lying
filetype plugin on
"visualize whitepsace
set listchars=tab:→→,trail:●,nbsp:○
set list
"share vim and system clipboard
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
else
    set clipboard=unnamed
endif
"ex mode is BS disable it
nnoremap Q <nop>
"this is why we have airline
set noshowmode
"delete comment character when joining commented lines
set formatoptions+=j
"this enables true color support but will break how everything looks if you
"use a terminal that doesnt support it such as urxvt
set tgc
"set the encodings to be sane
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set binary
"tabs are bad, also set this after encoding or weird things happen
set expandtab
"4 spaces is only spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
"tell me whats going on
"only enable when stuff breaks and you dont know why
"let &verbose = 1
if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/bash
endif
"\ is annoying move it to comma
let g:mapleader = ','
"for full code pastes may as well use pastemode
set pastetoggle=<leader>v

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

"to avoid the mistake of uppercasing these
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qa! qa!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qa qa
"i never want the help page! i allways wanted ESC
nnoremap <F1> <ESC>
inoremap <F1> <ESC>

"been around for ages yet isnt default for % to match if else etc
runtime macros/matchit.vim

"extra keybinds
"to quickly clear highlight press ^/
nmap <C-_> :nohlsearch<CR>

"better regex magic
set magic
"how dare you not use regex by default
nnoremap / /\v
vnoremap / /\v

"split nav with control dir
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
"scroll with alt directions
nnoremap <A-j> <C-e>
nnoremap <A-k> <C-y>

"tab nav with alt
nnoremap <A-h> gT
nnoremap <A-l> gt
"tab management with t leader
nnoremap tn :tabnew<CR>
nnoremap tq :tabclose<CR>
"so that line wraps are per terminal line not per global line
nnoremap j gj
nnoremap k gk
"and also for arrow keys
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>
"work around for mouse selection to clipboard
"if term supports mouse then the selection will be visual anyway
vnoremap <LeftRelease> "*ygv
"i dont actually want visual mode mouse control
"but i still do want scroll and cursor clicking
set mouse=ni
"keep visual selection after shift
vnoremap < <gv
vnoremap > >gv

"when the window gets resized reset the splits
autocmd VimResized * wincmd =

"==>environment auto setup<==
"make sure i can actually save my stuff somewhere
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views':  'viewdir',
                \ 'swap':   'directory',
                \ 'undo':   'undodir' }

    let common_dir = parent . '/.' . prefix
    "these are seperate as they are not settings
    let g:scratch_dir = common_dir . 'scratch/'

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor

    if exists("*mkdir")
        if !isdirectory(g:scratch_dir)
            call mkdir(g:scratch_dir)
        endif
    endif
    if !isdirectory(g:scratch_dir)
        echo "Warning: Unable to create scratch directory: " . g:scratch_dir
        echo "Try: mkdir -p " . g:scratch_dir
    endif
endfunction
call InitializeDirectories()

"==>all fancy plugin/magic stuff<==

"ensure we actually have vim plug
let s:vim_plug = '~/.local/share/nvim/site/autoload/plug.vim'
"if we dont have vimplug yet use this to disable erring first run sections
let s:first_run = 0
if empty(glob(s:vim_plug, 1))
    let s:first_run = 1
    silent !which curl
    if (!v:shell_error)
        execute 'silent !curl -fLo' s:vim_plug '--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    else
        "damn it cloud, now i support /not/ having curl
        echo "unabled to curl vimplug! either install curl and rerun or manually download it to " . g:vim_plug
        exit 1
    endif
endif

"some of these require the neovim pip package
call plug#begin('~/.local/share/nvim/plugged')
"Plug 'isaacmorneau/vim-fibo-indent' "for maximal indentation viewing pleasure
Plug 'airblade/vim-gitgutter' " The git gutter being the extra column tracking git changes by numbering
Plug 'isaacmorneau/vim-update-daily' "update vim plugins once a day (yea i made this one)
Plug 'joshdick/onedark.vim' "main color theme
Plug 'junegunn/vim-easy-align' "allow mappings for lots of aligning
Plug 'luochen1990/rainbow' "rainbow highlight brackets
Plug 'mtth/scratch.vim' "notes file that saves daily
Plug 'neomake/neomake' "do full syntax checking for most languages
Plug 'ntpeters/vim-better-whitespace' "show when there is gross trailing whitespace
Plug 'sbdchd/neoformat' "allows the formatting of code sanely
Plug 'scrooloose/nerdtree' "file browser
Plug 'sheerun/vim-polyglot' "a super language pack for a ton of stuff
Plug 'tpope/vim-surround' "change things surounding like ()->[]
Plug 'vim-airline/vim-airline' "a statusbar
Plug 'vim-airline/vim-airline-themes' "themes for the statusbar
"Plug 'Valloric/YouCompleteMe', {'do': 'python3 install.py --clang-completer'} "oh god here we go, compiled completion
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

Plug 'junegunn/fzf' "fuzzy jumping arround
Plug 'junegunn/fzf.vim' "fuzzy jumping arround

"horribly slow dont use neoinclude its several orders of magnitude higher
"Plug 'Shougo/neoinclude.vim' "also check completion in includes
"looks good but one of these slows down scrolling (probably both)
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight' "file type icons < this is the slow one
"this one also causes vim scratch and nerd tree to go into a forever loop.
"Plug 'Xuyuanp/nerdtree-git-plugin' "filebrowser git status
"
"this needs to go after other syntax plugins so it can override their rules
Plug 'dodie/vim-disapprove-deep-indentation'
"this is to highlight the fileicons in nerdtree
"if nerdtree is slow vist the github page as it has info on how to fix it
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
"putting this farther down so the nested call happens more smoothly on loading
Plug 'isaacmorneau/vim-simple-sessions' "easily manage sessions
"this should always be the last plugin
Plug 'ryanoasis/vim-devicons'
call plug#end()

"i put this here so it doesnt look dumb when doing an update and the colors
"are not appllied
if s:first_run == 0
    colorscheme onedark
endif
set background=dark

"check if we need an upgrade or an update
command! PU PlugUpgrade | PlugUpdate | UpdateRemotePlugins

let s:need_install = keys(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
let s:need_clean = len(s:need_install) + len(globpath(g:plug_home, '*', 0, 1)) > len(filter(values(g:plugs), 'stridx(v:val.dir, g:plug_home) == 0'))
let s:need_install = join(s:need_install, ' ')

"when entering a terminal enter in insert mode
autocmd BufWinEnter,WinEnter term://* startinsert

"first install stuff
if s:first_run
    echom '==>Initial Setup<=='
    echom 'Several packages require the python3 neovim package. Please install this to have full functionality.'
    echom 'After neovim is installed restart nvim to complete the install.'
endif
if has('vim_starting')
    if s:need_clean
        autocmd VimEnter * PlugClean!
    endif
    if len(s:need_install)
        if s:first_run
            execute 'autocmd VimEnter * PlugInstall --sync' s:need_install '| source $MYVIMRC | only! | term'
        else
            execute 'autocmd VimEnter * PlugInstall --sync' s:need_install ' | source $MYVIMRC'
        endif
        finish
    endif
else
    if s:need_clean
        PlugClean!
    endif
    if len(s:need_install)
        if s:first_run
            execute 'PlugInstall --sync' s:need_install | source $MYVIMRC | only! | term
        else
            execute 'PlugInstall --sync' s:need_install | source $MYVIMRC
        endif
        finish
    endif
endif

"[update-daily]
"custom command to also update remote plugins
let g:update_daily = 'PU'

"[one]
"it was the first run so now we need to enable it again
if s:first_run == 1
    colorscheme onedark
endif
"nice transparent background
"(actually looks really bad with one, i just leave it here so i dont make the
"same mistake again)
"hi Normal ctermbg=NONE

"[php.vim]
let g:php_html_load = 0

"[NerdTree]
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDTreeDirArrows=0
let g:NERDTreeShowHidden=1
let g:NERDTreeSortHiddenFirst=1
"^n to open the file browser
nnoremap <C-n> :NERDTreeFocus<CR>
"close if its the last thing open
autocmd bufenter * nested if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"[fzf]
nnoremap <C-m> :FZF<CR>
"binding it to leader enter so that its similar to my normal flow
nnoremap <silent> <leader><CR> :call Fzf_preview()<CR>
nnoremap <silent> <leader>, :call Fzf_all()<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__

"rg>ag>find but fall back through each
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
    set grepprg=rg\ --vimgrep
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

"fzf with a fancy preview
function! Fzf_preview()
    call fzf#run(fzf#wrap(
        \ {'options': '--preview "bat --pager never --theme OneHalfDark --style numbers,changes --color=always -r :'.float2nr(floor(&lines*0.4)-1).' {}"'}))
endfunction
"fzf but everything
function! Fzf_all()
    call fzf#run(fzf#wrap(
        \ {'source': "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null",
        \ 'options': '--preview "bat --pager never --theme OneHalfDark --style numbers,changes --color=always -r :'.float2nr(floor(&lines*0.4)-1).' {}"'}))
endfunction

"hide status line for fzf
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

"match current color scheme
let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }


"[Easy Align]
"Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
"Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


"[Airline]
set laststatus=2
let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
"airline symbols
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline#extensions#tabline#enabled = 1

"to show buffer numbers for navigation
function! WindowNumber(...)
    let builder = a:1
    let context = a:2
    call builder.add_section('airline_b', '%{tabpagewinnr(tabpagenr())}')
    return 0
endfunction

call airline#add_statusline_func('WindowNumber')
call airline#add_inactive_statusline_func('WindowNumber')

"[YouCompleteMe]
"let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
"its so horrible with python
let g:ycm_filetype_blacklist = { 'python': 1 }


"[NeoMake]
" When reading a buffer (after 1s), and when writing (no delay).
call neomake#configure#automake('rw', 1000)

let g:neomake_javascript_jshint_maker = {
            \ 'args': ['--verbose'],
            \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
            \ }
let g:neomake_javascript_enabled_makers = ['jshint']
let g:neomake_rust_enabled_makers = ['cargo']
let g:neomake_cargo_args = ['check']


"[Scratch]
let g:scratch_persistence_file = g:scratch_dir . strftime("scratch_%Y-%m-%d")
let g:scratch_no_mappings = 1
nmap <silent> gs <plug>(scratch-insert-reuse)
xmap <silent> gs <plug>(scratch-selection-reuse)
nnoremap gZzZz gs

"[rainbow]
let g:rainbow_active = 0
"honestly the default config is fine

"[neoformat]
"good for debugging broken formatters
"let g:neoformat_verbose = 1
let g:neoformat_basic_format_align = 1
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1
let g:neoformat_c_clang_format = {
            \ 'exe': 'clang-format',
            \ 'args': ['-style=~/.clang-format'],
            \ }
let g:neoformat_cpp_clang_format = {
            \ 'exe': 'clang-format',
            \ 'args': ['-style=~/.clang-format'],
            \ }

let g:neoformat_enabled_c = ['clangformat']
let g:neoformat_enabled_cpp = ['clangformat']
nmap <C-f> :Neoformat<CR>

"[LookOfDisaproval]
let g:LookOfDisapprovalTabThreshold=5
let g:LookOfDisapprovalSpaceThreshold=(&tabstop*4)

"i dont know what adds this bullshit but its annoying as hell
let g:omni_sql_no_default_maps = 1

"[gitgutter]
"these are so that gitgutter gives more snappy updates when doing lots of
"editing by rechecking on anything to do with insert
autocmd insertleave * nested call gitgutter#process_buffer(bufnr(''), 0)
autocmd insertenter * nested call gitgutter#process_buffer(bufnr(''), 0)
