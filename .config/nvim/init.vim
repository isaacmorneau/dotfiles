"
" ██╗███████╗ █████╗  █████╗  ██████╗███████╗    ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
" ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝    ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
" ██║███████╗███████║███████║██║     ███████╗    ██║   ██║██║██╔████╔██║██████╔╝██║
" ██║╚════██║██╔══██║██╔══██║██║     ╚════██║    ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
" ██║███████║██║  ██║██║  ██║╚██████╗███████║     ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
" ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝      ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"

"Base vim setup
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
    let g:scratch_dir = common_dir . 'scratch'. '/'
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
    execute 'silent !curl -fLo' s:vim_plug '--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

"been around for ages yet isnt default for % to match if else etc
runtime macros/matchit.vim

"extra keybinds
"to quickly clear highlight press ^/
nmap <C-_> :nohlsearch<CR>
"split nav with control dir
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
"scroll with alt directions
nnoremap <A-j> <C-e>
nnoremap <A-k> <C-y>

"tab nav with shift
nnoremap H gT
nnoremap L gt
"tab management with t leader
nnoremap tn :tabnew<CR>
nnoremap tq :tabclose<CR>
"so that line wraps are per terminal line not per global line
nnoremap j gj
nnoremap k gk
"work around for mouse selection to clipboard
"if term supports mouse then the selection will be visual anyway
vnoremap <LeftRelease> "*ygv
"i dont actually want visual mode mouse control
"but i still do want scroll and cursor clicking
set mouse=ni

"some of these require the neovim pip package
call plug#begin('~/.local/share/nvim/plugged')
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "the main autocomple engine
Plug 'SirVer/ultisnips' "who knew? turns out snippets are a thing and they are dope!
Plug 'StanAngeloff/php.vim', {'for': 'php'} "sigh its for work
Plug 'airblade/vim-gitgutter' " The git gutter being the extra column tracking git changes by numbering
Plug 'chrisbra/Colorizer' "highlight hex codes with the color they are
Plug 'honza/vim-snippets' "we do actually need the snippets as they are not in the engine
Plug 'isaacmorneau/vim-update-daily' "update vim plugins once a day (yea i made this one)
Plug 'joshdick/onedark.vim' "main color theme
Plug 'junegunn/fzf' "fuzzy jumping arround
Plug 'junegunn/vim-easy-align' "allow mappings for lots of aligning
Plug 'keith/swift.vim' "swift support
Plug 'luochen1990/rainbow' "rainbow highlight brackets
Plug 'mhinz/vim-startify' "A nice start menu
Plug 'mtth/scratch.vim' "notes file that saves daily
Plug 'neomake/neomake' "do full syntax checking for most languages
Plug 'ntpeters/vim-better-whitespace' "show when there is gross trailing whitespace
Plug 'sbdchd/neoformat' "allows the formatting of code sanely
Plug 'scrooloose/nerdtree' "file browser
Plug 'sebastianmarkow/deoplete-rust' "better rust support
Plug 'sheerun/vim-polyglot' "a super language pack for a ton of stuff
Plug 'tpope/vim-surround' "change things surounding like ()->[]
Plug 'vim-airline/vim-airline' "a statusbar
Plug 'vim-airline/vim-airline-themes' "themes for the statusbar
Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }  "this maddness is of my own design
Plug 'zchee/deoplete-clang' "better clang support

"horribly slow dont use neoinclude its several orders of magnitude higher
"Plug 'Shougo/neoinclude.vim' "also check completion in includes
"looks good but one of these slows down scrolling (probably both)
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight' "file type icons < this is the slow one
"this one also causes vim scratch and nerd tree to go into a forever loop.
"Plug 'Xuyuanp/nerdtree-git-plugin' "filebrowser git status
"
"dont add discord if its not installed(like on servers)
silent !which discord || which discord-canary
if(!v:shell_error)
    Plug 'aurieh/discord.nvim', { 'do': ':UpdateRemotePlugins'}
endif
"this should always be the last plugin
Plug 'ryanoasis/vim-devicons'

"[startify]
"this needs to before plug end or it wont take
let g:startify_custom_header = ['   ███╗███╗   ██╗███╗██╗   ██╗██╗███╗   ███╗',
            \'   ██╔╝████╗  ██║╚██║██║   ██║██║████╗ ████║',
            \'   ██║ ██╔██╗ ██║ ██║██║   ██║██║██╔████╔██║',
            \'   ██║ ██║╚██╗██║ ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
            \'   ███╗██║ ╚████║███║ ╚████╔╝ ██║██║ ╚═╝ ██║',
            \'   ╚══╝╚═╝  ╚═══╝╚══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝']

let g:startify_lists = [
            \ { 'type': 'files',    'header': [ 'MRU']      },
            \ { 'type': 'commands', 'header': [ 'Commands'] },
            \ ]
"i dont want to be moved to a dir if chose a file there
let g:startify_change_to_dir = 0
"tried to be clever and make this the winheight - padding so it filled the
"screen but turns out that winheight isnt correct at this point in the config
"and it needs to be here to be respected
let g:startify_files_number = 25
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
"custom command to also update remote plugins for stuff like deoplete
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
map <C-n> :NERDTreeFocus<CR>
"close if its the last thing open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"[fzf]
map <C-m> :FZF<CR>
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" The Silver Searcher
if executable('ag')
    let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
    set grepprg=ag\ --nogroup\ --nocolor
endif

" ripgrep
if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
    set grepprg=rg\ --vimgrep
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif



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

"[Deoplete]
let g:deoplete#enable_at_startup = 1
"dont require the same file type
let g:deoplete#buffer#require_same_filetype = 0
"<TAB> completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"dont litter your windows
autocmd CompleteDone * pclose

"[ultisnips]
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"
let g:UltiSnipsSnippetDirectories=["~/.local/snippets"]

"[rainbow]
let g:rainbow_active = 1
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


"i dont know what adds this bullshit but its annoying as hell
let g:omni_sql_no_default_maps = 1
