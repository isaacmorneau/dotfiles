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
"4 spaces is only spaces
set tabstop=4
"go back like a normal person
set backspace=indent,eol,start
"duh
set autoindent
set copyindent
"see line 23
set shiftwidth=4
"which you would only see with this on
set number
"tabs are bad
set expandtab
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
set clipboard+=unnamed
"ex mode is BS disable it
nnoremap Q <nop>
"this is why we have airline
set noshowmode
"delete comment character when joining commented lines
set formatoptions+=j



"to avoid the mistake of uppercasing these
command! W :w
command! Q :q

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

"work around for mouse selection to clipboard
"if term supports mouse then the selection will be visual anyway
vnoremap <LeftRelease> "*ygv
"i dont actually want visual mode mouse control
"but i still do want scroll and cursor clicking
set mouse=ni

call plug#begin('~/.local/share/nvim/plugged')
Plug 'chrisbra/Colorizer' "highlight hex codes with the color they are
Plug 'ctrlpvim/ctrlp.vim' "match files with fuzzy finding with ^p
Plug 'FelikZ/ctrlp-py-matcher' "the normal one doesnt prioritize exact matches so we need the py addition
Plug 'isaacmorneau/vim-update-daily' "update vim plugins once a day
Plug 'joshdick/onedark.vim' "main theme
Plug 'junegunn/vim-easy-align' "alow mappings for lots of aligning
Plug 'keith/swift.vim' "swift support
Plug 'luochen1990/rainbow' "rainbow highlight brackets
Plug 'mtth/scratch.vim' "notes file that saves daily
Plug 'neomake/neomake' "do full syntax checking for most languages
Plug 'ntpeters/vim-better-whitespace' "show when there is gross trailing whitespace
Plug 'scrooloose/nerdtree' "file browser
Plug 'StanAngeloff/php.vim'
"looks good but one of these slows down scrolling (probably both)
"Plug 'Xuyuanp/nerdtree-git-plugin' "filebrowser git status
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight' "file type icons
Plug 'tpope/vim-surround' "change things surounding like ()->[]
Plug 'vim-airline/vim-airline' "a statusbar
Plug 'vim-airline/vim-airline-themes' "themes for the statusbar
"requires neovim pip package
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "the main autocomple engine
Plug 'zchee/deoplete-clang' "better clang support
Plug 'sebastianmarkow/deoplete-rust' "better rust support
Plug 'Shougo/neoinclude.vim' "also check completion in includes

"dont add discord if its not installed(like on servers)
let s:has_discord = 0
silent !which discord || which discord-canary
if(!v:shell_error)
    Plug 'aurieh/discord.nvim', { 'do': ':UpdateRemotePlugins'}
endif
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
set encoding=utf-8
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

"[c.vim]
let g:C_UseTool_cmake = 'yes'

"[ctrlp.vim]
let g:ctrlp_working_path_mode = 'ra'
"ignore whats in git ignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_path_sort = 1
"this is to prioritize matches sanely such as exact first
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

"[rainbow]
let g:rainbow_active = 1
let g:rainbow_conf = {
            \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
            \   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
            \   'operators': '_,_',
            \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
            \   'separately': {
            \       '*': {},
            \       'tex': {
            \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
            \       },
            \       'lisp': {
            \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
            \       },
            \       'vim': {
            \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
            \       },
            \       'html': {
            \           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
            \       },
            \       'css': 0,
            \   }
            \}

"i dont know what adds this bullshit but its annoying as hell
let g:omni_sql_no_default_maps = 1
