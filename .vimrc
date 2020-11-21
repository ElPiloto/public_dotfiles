" Used on WSL2/OSX/Linux. Will not work in Windows.
" Enable modern Vim features not compatible with Vi spec.
set nocompatible

" This let's us change our vim config by setting $VIM_DIR environment variable
let g:vim_dir = $VIM_DIR
if empty(g:vim_dir)
	let g:vim_dir = $HOME
endif
let g:vimrc = g:vim_dir . "/.vimrc"

" Install plugged path relative to our vim_dir
let s:plug_path = g:vim_dir . "/autoload/plug.vim"
let s:plugged_path = g:vim_dir . "plugged"
if empty(glob(s:plug_path))
   execute 'silent !curl -fLo ' . s:plug_path . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
   autocmd VimEnter * PlugInstall
endif

" *****************************************
" Install Plugins
" *****************************************
call plug#begin(s:plugged_path)
Plug 'ervandew/supertab'

" This takes care of installing fzf binary for us, too.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" Vim + tmux navigation
Plug 'christoomey/vim-tmux-navigator'

" LSP for auto-completion.
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'

Plug 'google/vim-codefmt'
" ^ Requires maktaba (and glaive for config)
Plug 'google/vim-maktaba'
Plug 'google/vim-glaive'

" Snippet plugin
Plug 'SirVer/ultisnips'

" Snippets and skeletons.
Plug 'honza/vim-snippets'
Plug 'pgilad/vim-skeletons'
Plug 'majutsushi/tagbar' 		" sudo apt-get install ctags
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-surround'
Plug 'dense-analysis/ale'

" Helpful for debugging lua plugins
" :Bufferize any_vim_cmd
Plug 'AndrewRadev/bufferize.vim'

" Context around lines
Plug 'wellle/context.vim'

" Startup and sessions
Plug 'mhinz/vim-startify'

" Colorschemes and utils
Plug 'ElPiloto/vim-colorstepper'

" True color color schemes.
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ayu-theme/ayu-vim' 		" ayucolor='light'|'mirage'|'dark'
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'rakr/vim-one'
Plug 'lifepillar/vim-solarized8'
Plug 'relastle/bluewery.vim'
" In-progress color scheme forked from 'mhartington/oceanic-next'
Plug 'ElPiloto/oceanic-next'
Plug 'bluz71/vim-nightfly-guicolors'

" Other colorscheme
Plug 'j-tom/vim-old-hope'

" Cool icons (requires Nerd Font patched fonts)
" I use Caskaydia Cove Nerd Font
" https://github.com/ryanoasis/nerd-fonts/releases
Plug 'ryanoasis/vim-devicons'

" Status bar
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'mkalinski/vim-lightline_tagbar'

" Trying out project templates
Plug 'tomtom/templator_vim'



Plug 'maximbaz/lightline-ale'

if has('nvim')
	" Sidekick plugin, direct dependencies, and helpful debug utils.
	" WARNING: sidekick plugin not yet ready for development.
	"Plug 'ElPiloto/sidekick.nvim'
	"Plug 'nvim-treesitter/nvim-treesitter'
	"Plug 'tree-sitter/tree-sitter-python'
	"Plug 'nvim-treesitter/tree-sitter-lua'
	"Plug 'nvim-treesitter/playground'

	" Helpful neovim plugins and dependency.
	Plug 'nvim-lua/telescope.nvim'
	Plug 'nvim-lua/popup.nvim'
	Plug 'nvim-lua/plenary.nvim'
endif
call plug#end()

" Needs to be turned on after installing plugins
filetype plugin indent on

" Allows using Glaive commands in vimrc
call glaive#Install()

" *****************************************
" General VIM Settings
" *****************************************
set clipboard=unnamedplus
set tabstop=4
set shiftwidth=4
set backspace=indent,eol,start
set history=50      " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch       " do incremental searching
set hlsearch
set laststatus=2
set number         " Show numbers on side.

" scroll when we get close to the edges
set scrolloff=4 sidescrolloff=10
set foldlevelstart=9999
" Visual bell
set noerrorbells visualbell t_vb=
" Enable fast scrolling.
set ttyfast
" Status bar
set laststatus=2
set enc=utf-8
set cursorline

" Tell vim terminal supports the mouse.
if !has('nvim')
	if has("mouse_sgr")
	  " only this tty can support more than 223 columns wide.
	  set ttymouse=sgr
	else
	  set ttymouse=xterm2
	end
end
" If we want to use mouse outside of vim, go into command mode.
" Otherwise, mouse will be available for most things in vim.
" See discussion here: https://github.com/vim/vim/issues/2841
set mouse=nvr
" Visualize tabs and trailing spaces.
set list
set listchars=tab:>\ ,trail:>

" Make vim split complete.
set fillchars+=vert:\│
" Stop stupid trailing chars on closed folds.
set fillchars+=fold:\ 

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal! g`\"" |
	\ endif

" Clear matching patterns when leaving the buffer. It supposes to avoid
" memory leaks.
autocmd BufWinLeave * call clearmatches()
" Disable any match when opening a file.
au BufReadPost,BufNewFile * call clearmatches()

" *****************************************
" Colorscheme
" *****************************************
" Useful for detecting highlight group under the cursor.
" :call SynGroup() will tell you about the highlight group under the cursor.
" You can subsequently look up info using :hi and :syn
function! g:SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
" Fancy vim colors - only works with tmux true colors
if &t_Co > 16
     " Do something.
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
    set background=dark
    " Actually my own forked colorscheme that is nothing like OceanicNext.
	colorscheme OceanicNext  
endif

" *****************************************
" Statusline settings
" *****************************************

" SideKick config
" WARNING: sidekick plugin not yet ready for development.
"let g:sidekick_printable_def_types = ['function', 'class', 'type', 'module', 'parameter',]
"let g:sidekick_def_type_icons = {
"\    'class': "\uf0e8",
"\    'type': "\uf0e8",
"\    'function': "\uf794",
"\    'module': "\uf7fe",
"\    'arc_component': "\uf6fe",
"\    'sweep': "\uf7fd",
"\    'parameter': "•",
"\    'var': "v",
"\ }
"let g:sidekick_inner_node_icon = "\u251c\u2500\u25B8"
"let g:sidekick_outer_node_icon = "\u2570\u2500\u25B8"
"let g:sidekick_left_bracket = "\u27ea" " ❲
"let g:sidekick_right_bracket = "\u27eb"


let g:lightline_tagbar#flags = 'f'
let s:lightline_tag_fn = 'lightline_tagbar#component'
let g:tagbar_iconchars = ['ﰲ', '']
let g:tagbar_visibility_symbols = {
	\ 'protected'    : "\ufc0a" . " ",
	\ 'private' : "\uf997" . " ",
	\ 'public' : "\ufc73" . " ",
	\ }
" Values based on using patched nerd fonts.
let g:tagbar_scopestrs = {
	\    'class': "\uf0e8",
	\    'const': "\uf8ff",
	\    'constant': "\uf8ff",
	\    'enum': "\uf702",
	\    'field': "\uf30b",
	\    'func': "\uf794",
	\    'function': "\uf794",
	\    'getter': "\ufab6",
	\    'implementation': "\uf776",
	\    'interface': "\uf7fe",
	\    'map': "\ufb44",
	\    'member': "\uf02b",
	\    'method': "\uf6a6",
	\    'setter': "\uf7a9",
	\    'variable': "\uf71b",
	\ }

" Adding devicons for lightline
function! LightlineTabname(n) abort
  " Appends file type devicon to tab
  let bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
  let fname = expand('#' . bufnr . ':t')
  return fname . ' [' .  WebDevIconsGetFileTypeSymbol(fname) . ']'
  return winwidth(0) > 70 ? (strlen(fname) ? fname . ' [' .  WebDevIconsGetFileTypeSymbol(fname) . ']' : 'no ft') : ''
  return fname =~ '__Tagbar__' ? 'Tagbar' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ ('' != fname ? fname : '[No Name]')
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

let g:lightline = {
\ 'colorscheme': 'OldHope',
\ 'active': {
\   'left': [ [ 'mode' ],
\             ['readonly', 'filename_and_icon', 'modified' ] ],
\   'right': [ [ 'position' ],
\              [ 'tag', ],
\              [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
\ ],
\ },
\ 'tab_component_function': {
\    'filename': 'LightlineTabname',
\ },
\ 'component': {
\   'position': '%l:%c',
\ },
\   'component_function': {
\       'tag': s:lightline_tag_fn,
\       'parent_and_filename': 'ParentAndFilename',
\       'filename_and_icon': 'FilenameAndIcon',
\       'filetype': 'MyFiletype',
\       'fileformat': 'MyFileformat',
\	},
\    'component_expand': {
\       'linter_checking': 'lightline#ale#checking',
\       'linter_infos': 'lightline#ale#infos',
\       'linter_warnings': 'lightline#ale#warnings',
\       'linter_errors': 'lightline#ale#errors',
\       'linter_ok': 'lightline#ale#ok',
\ },
\ 'component_type': {
\     'linter_checking': 'right',
\     'linter_infos': 'right',
\     'linter_warnings': 'warning',
\     'linter_errors': 'error',
\     'linter_ok': 'right',
\ },
\ 'mode_map': {
	\ 'n' : 'N',
	\ 'i' : 'I',
	\ 'R' : 'R',
	\ 'v' : 'V',
	\ 'V' : 'VL',
	\ "\<C-v>": 'VB',
	\ 'c' : 'C',
	\ 's' : 'S',
	\ 'S' : 'SL',
	\ "\<C-s>": 'SB',
	\ 't': 'T',
	\ },
\ }
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '|', 'right': '|' }
let g:lightline.separator = { 'left': "", 'right': "" }
let g:lightline.subseparator = { 'left': "", 'right': "" }
let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0ba" }
let g:lightline.tabline_subseparator = { 'left': "\ue0bb", 'right': "\ue0bb" }
let g:lightline.tabline_separator = { 'left': "", 'right': "" }
let g:lightline.tabline_subseparator = { 'left': "", 'right': "" }
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_infos = "\uf129"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"
let g:visa_executive_for = {
			\ 'python': 'coc.nvim',
			\ }
" Display a/b/c/foo as c/foo
function! ParentAndFilename() abort
    return expand('%:p:h:t') . '-' . expand('%t')
endfunction

function! FilenameAndIcon() abort
    return winwidth(0) > 70 ? (strlen(&filetype) ? expand('%t') . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

" *****************************************
" Commands and KeyBindings
" *****************************************
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

" Edit our "real" vimrc
if !exists(":Vimrc")
  command Vimrc execute ':edit ' . g:vimrc
  nnoremap <leader>ve :execute ':edit ' . g:vimrc<CR>
endif

" Edit our "real" vimrc in vert split
if !exists(":Vvimrc")
  command Vvimrc execute ':vsp ' . g:vimrc
  nnoremap <leader>vv :execute ':vsp ' . g:vimrc<CR>
endif

" Source our "real" vimrc
if !exists(":Svimrc")
  command Svimrc execute ':source ' . g:vimrc
  nnoremap <leader>vs :execute ':source ' . g:vimrc<CR>
endif

" _____________
" General
" _____________
:imap jj <Esc>
" Switch between windows with C-W prefix.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Toggle Quickfix
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

nnoremap <silent> <Leader>q :call ToggleQuickFix()<cr>

" Toggle List
function! ToggleLocationList()
    if get(getloclist(0, {'winid':0}), 'winid', 0)
        lclose
    else
        lopen
    endif
endfunction

nnoremap <silent> <Leader>l :call ToggleLocationList()<cr>
" Source current file.
nnoremap <leader>sop :source %<cr>
" cd to current file
nnoremap <leader>cd :cd %:p:h<CR>

" _____________
" Keybindings For Plugins
" _____________
" Quick access to NERD tree and Tagbar toggles (F for files)
map <C-F> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>
" WARNING: sidekick plugin not yet ready for development.
" nmap <F8> :call SideKickNoReload()<CR>


" Scroll through colorschemes
nmap <F6> <Plug>ColorstepPrev
nmap <F7> <Plug>ColorstepNext

" Commands to make it easier to run Lua scripts and see their outputs when
" writing lua-based neovim plugins. Allows to put print(...) in your lua file
" and then run the lua file via <leader>bl to see the print statements in a
" buffer instead of just temporarily in the statusline.
let g:lua_file_to_bufferize = ""
nnoremap <leader>bs :let g:lua_file_to_bufferize=expand("%")<CR>
nnoremap <leader>bl :execute ':Bufferize vertical luafile ' . g:lua_file_to_bufferize<CR>

let g:UltiSnipsExpandTrigger = "<C-J>"
let g:UltiSnipsJumpForwardTrigger = "<C-J>"
let g:UltiSnipsJumpBackwardTrigger = "<C-K>"

if has('nvim')
	nnoremap <Leader>tp <cmd>lua require'telescope.builtin'.find_files{}<CR>
	nnoremap <Leader>tq <cmd>lua require'telescope.builtin'.quickfix{}<CR>
	nnoremap <Leader>tl <cmd>lua require'telescope.builtin'.loclist{}<CR>
	nnoremap <Leader>tt <cmd>lua require'telescope.builtin'.treesitter{}<CR>
	nnoremap <Leader>tm <cmd>lua require'telescope.builtin'.marks{}<CR>
	nnoremap <Leader>tg <cmd>lua require'telescope.builtin'.live_grep{}<CR>
endif


" *****************************************
" Language / FileType
" *****************************************

" Python
autocmd Filetype python setlocal tabstop=2 shiftwidth=2 expandtab smarttab textwidth=80
" Auto-format python files on save.
augroup autoformat_settings
  " Add ~/.config/yapf/style to enable google (2 spaces) style.
  " Requires pip install yapf and add pip-installed path to $PATH (e.g. ~/.local/bin/yapf)
  autocmd FileType python AutoFormatBuffer yapf
augroup END

" Lua
autocmd Filetype lua setlocal tabstop=2 shiftwidth=2 expandtab smarttab textwidth=80

" Snips
let g:ultisnips_python_style = "google"
let g:snips_author = $USER  " let ultisnips know who we are (e.g. for todo)

" Git
autocmd Filetype gitcommit setlocal spell textwidth=72 colorcolumn=72

" *****************************************
" Plugin Settings
" *****************************************
"
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1

if has('nvim')

	" This is due to some bug with neovim <--> context.vim, where the screen
	" will flicker on scroll. Dumb, but does the job.
	let g:context_nvim_no_redraw = 1

"EOF

endif

" *****************************************
" LSP
" *****************************************
function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal signcolumn=yes
	nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> gr <plug>(lsp-references)
	nmap <buffer> <f2> <plug>(lsp-rename)
	nmap <buffer> K <plug>(lsp-hover)
endfunction

augroup lsp_install
	au!
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_enabled = 1         " disable diagnostics support
" Enable echo under cursor when in normal mode
let g:lsp_diagnostics_echo_cursor = 1
" Pops up window under cursor when hovering over a diagnostic that shows
" things. (Neeed to set diagnostics obviously)
let g:lsp_diagnostics_float_cursor = 0

" Might want to enable this later, but right now it's messing me up.
let g:lsp_virtual_text_enabled = 0
" This will highlight the word that caused lsp diagnostic to trigger.
let g:lsp_diagnostics_enabled = 1


" Send async completion requests.
" WARNING: Might interfere with other completion plugins.
let g:lsp_async_completion = 0
" Requires additional configuration.
let g:lsp_semantic_enabled = 0

" NOTE: I think we should be able to do our linting through vim-lsp,
" but currently our dev LSP doesn't support "Document Diagnostics" or "Hover"
" for that matter. Will leave this just in case. But we'll rely on ALE for
" linting for now.
" Enable diagnostics signs in the gutter
let g:lsp_signs_enabled = 0
let g:lsp_signs_error = {'text': 'x'}
let g:lsp_signs_warning = {'text': '!!'}
let g:lsp_signs_information = {'text': 'i'}
let g:lsp_signs_hint = {'text': 'h'}

" If having issues with vim-lsp, uncomment this.
"let g:asyncomplete_log_file = expand('~/.vim8-asyncomplete.log')
"let g:lsp_log_verbose = 1
"let g:lsp_log_file = expand('~/.vim8-lsp.log')

" Disable showing the completion options automatically.
" Use TAB instead.
"let g:asyncomplete_auto_popup = 0

if executable('pyls')
	" pip install python-language-server
	au User lsp_setup call lsp#register_server({
		\ 'name': 'pyls',
		\ 'cmd': {server_info->['pyls']},
		\ 'allowlist': ['python'],
		\ })
	augroup lsp_folding_py
		autocmd!
		autocmd FileType python setlocal
			\ foldmethod=expr
			\ foldexpr=lsp#ui#vim#folding#foldexpr()
			"\ foldtext=lsp#ui#vim#folding#foldtext()
	augroup end
endif
if executable('lua-lsp')
	au User lsp_setup call lsp#register_server({
				\ 'name': 'lua-lsp',
				\ 'cmd': {server_info->[&shell, &shellcmdflag, 'lua-lsp']},
				\ 'whitelist': ['lua'],
				\ })
	augroup lsp_folding_lua
		autocmd!
		autocmd FileType lua setlocal
			\ foldmethod=expr
			\ foldexpr=lsp#ui#vim#folding#foldexpr()
			" Disabled line below because ugly.
			"\ foldtext=lsp#ui#vim#folding#foldtext()
	augroup end
endif


" Autocomplete settings

set completeopt=menuone,longest,preview

" Popup a menu in the command line in vim.
set wildmenu
set wildmode=list:longest

call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
		\ 'name': 'ultisnips',
		\ 'whitelist': ['*'],
		\ 'completor': function('asyncomplete#sources#ultisnips#completor'),
		\ }))

" *****************************************
" ALE (asynchronous linting)
" *****************************************
let g:ale_sign_error = '◉'
let g:ale_sign_warning = '▲'
let g:ale_sign_warning = '└'
let g:ale_sign_warning = '─'
let g:ale_sign_error = ''
let g:ale_sign_warning = "\ue0b0\ue0b1"
let g:ale_sign_error = "\ue0b0\ue0b1"

let g:ale_linters = {
\   'python': ['pylint'],
\   'markdown': [],
\}
let g:ale_python_pylint_options = '--indent-string="  "'
