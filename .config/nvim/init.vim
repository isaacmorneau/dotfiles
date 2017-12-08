"
" ██╗███████╗ █████╗  █████╗  ██████╗███████╗    ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
" ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔════╝    ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
" ██║███████╗███████║███████║██║     ███████╗    ██║   ██║██║██╔████╔██║██████╔╝██║
" ██║╚════██║██╔══██║██╔══██║██║     ╚════██║    ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
" ██║███████║██║  ██║██║  ██║╚██████╗███████║     ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
" ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝      ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"

"Base vim setup
if has("autocmd")
    " Jump to last open
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    "Indentation rules for language
    filetype plugin indent on
endif
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
"i dont want to press enter when a command is done
set shortmess=atI
"the extension likely isnt lying
filetype plugin on

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
        echo "Warning: Unable to create backup directory: " . directory
        echo "Try: mkdir -p " . directory
    endif
endfunction
call InitializeDirectories()

"work specific
command! Sync :!~/up.sh
command! AltSync :!~/up2.sh


"==>all fancy plugin/magic stuff<==

"ensure we actually have vim plug
let s:vim_plug = '~/.local/share/nvim/site/autoload/plug.vim'
if empty(glob(s:vim_plug, 1))
  execute 'silent !curl -fLo' s:vim_plug '--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
"been around for ages yet isnt default for % to match if else etc
runtime macros/matchit.vim

"work around for mouse selection to clipboard
"if term supports mouse then the selection will be visual anyway
vnoremap <LeftRelease> "*ygv
vmap C "*y
vmap V "*p
set mouse=a

call plug#begin('~/.local/share/nvim/plugged')
"github pluugins
Plug 'isaacmorneau/vim-update-daily'
"requires neovim pip package
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/vim-easy-align'
Plug 'neomake/neomake'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'joshdick/onedark.vim'
"probably dont need this but meh /shrug
Plug 'itchyny/vim-gitbranch'
Plug 'mtth/scratch.vim'
Plug 'keith/swift.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'vim-scripts/c.vim'
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

"i put this here so it doesnt look dumb when doing an update and the colors
"are not appllied
colorscheme onedark
set background=dark

"check if we need an upgrade or an update
command! PU PlugUpgrade | PlugUpdate | UpdateRemotePlugins


let s:need_install = keys(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
let s:need_clean = len(s:need_install) + len(globpath(g:plug_home, '*', 0, 1)) > len(filter(values(g:plugs), 'stridx(v:val.dir, g:plug_home) == 0'))
let s:need_install = join(s:need_install, ' ')
if has('vim_starting')
  if s:need_clean
    autocmd VimEnter * PlugClean!
  endif
  if len(s:need_install)
    execute 'autocmd VimEnter * PlugInstall --sync' s:need_install '| source $MYVIMRC'
    finish
  endif
else
  if s:need_clean
    PlugClean!
  endif
  if len(s:need_install)
    execute 'PlugInstall --sync' s:need_install | source $MYVIMRC
    finish
  endif
endif

"[update-daily]
" custom command to also update remote plugins for stuff like deoplete
let g:update_daily = 'PU'

"[one]
colorscheme onedark
set background=dark
"nice transparent background
"(actually looks really bad with one, i just leave it here so i dont make the
"same mistake again)
"hi Normal ctermbg=NONE

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
map <C-n> :NERDTreeFocus<CR>
"close if its the last thing open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"[Easy Align]
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


"[Airline]
set laststatus=2
let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
" airline symbols
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" to show buffer numbers for navigation
function! WindowNumber(...)
    let builder = a:1
    let context = a:2
    call builder.add_section('airline_b', '%{tabpagewinnr(tabpagenr())}')
    return 0
endfunction

call airline#add_statusline_func('WindowNumber')
call airline#add_inactive_statusline_func('WindowNumber')


"[NeoMake]
autocmd! BufWritePost * Neomake

let g:neomake_javascript_jshint_maker = {
    \ 'args': ['--verbose'],
    \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
    \ }
let g:neomake_javascript_enabled_makers = ['jshint']

"[Scratch]
let g:scratch_persistence_file = g:scratch_dir . strftime("scratch_%Y-%m-%d")
let g:scratch_no_mappings = 1
nmap <silent> gs <plug>(scratch-insert-reuse)
xmap <silent> gs <plug>(scratch-selection-reuse)
nnoremap gZzZz gs

"[Deoplete]
let g:deoplete#enable_at_startup = 1
"<TAB> completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

"[c.vim]
let g:C_UseTool_cmake = 'yes'
