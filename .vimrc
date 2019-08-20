"常用设置


"设置LEADER键为空格键
let mapleader=" "
"设置行号
set number
"设置相对行号
set relativenumber
"设置当前行的下行线
set cursorline
"设置语法
syntax on
"高亮搜索
set hlsearch
"设置边写边高亮
set incsearch
"设置光标下5行始终显示
set scrolloff=5
"按下：执行不现实高亮
exec "nohlsearch"
"按下\加回车，取消高亮显示  注意vim中默认的LEADER键是反斜杠'\'
noremap <LEADER><CR> :nohlsearch<CR>
"设置忽略大小写
set ignorecase
set smartcase
"设置显示命令提示
set showcmd
"设置普通模式下：命令 可以tab补全
set wildmenu

"分屏快捷键映射
map sl :set splitright<CR>:vsplit<CR>
map sh :set nosplitright<CR>:vsplit<CR>
map sk :set nosplitbelow<CR>:split<CR>
map sj :set splitbelow<CR>:split<CR>
"切换窗口
map <LEADER>h <C-w>h
map <LEADER>l <C-w>l
map <LEADER>k <C-w>k
map <LEADER>j <C-w>j
"Lint快捷键设置
map <LEADER>p : PymodeLintAuto<CR>
"vim-plug插件设置

call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'connorholyday/vim-snazzy'
Plug 'scrooloose/nerdtree'
" assuming you're using vim-plug: https://github.com/junegunn/vim-plug
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'python-mode/python-mode',{'for': 'python','branch': 'develop'}
" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
call plug#end()

color snazzy
let g:SnazzyTransparent = 1
let g:python3_host_prog="/Users/wangtianyu/anaconda3/bin/python3"
"NerdTree映射
map <LEADER>t :NERDTreeToggle<CR>
" suppress the annoying 'match x of y', 'The only match' and 'Pattern not
" found' messages
set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" wrap existing omnifunc
" Note that omnifunc does not run in background and may probably block the
" editor. If you don't want to be blocked by omnifunc too often, you could
" add 180ms delay before the omni wrapper:
"  'on_complete': ['ncm2#on_complete#delay', 180,
"               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
au User Ncm2Plugin call ncm2#register_source({
    \ 'name' : 'css',
    \ 'priority': 9,
    \ 'subscope_enable': 1,
    \ 'scope': ['css','scss'],
    \ 'mark': 'css',
    \ 'word_pattern': '[\w\-]+',
    \ 'complete_pattern': ':\s*',
    \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
    \ })
"python-mode conf
let g:pymode_python = 'python3'
let g:pymode_trim_whitespaces = 1
let g:pymode_doc = 1
let g:pymode_doc_bind = 'K'
let g:pymode_rope_goto_definition_bind = "<C-]>"
let g:pymode_lint = 1
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe', 'pylint']
let g:pymode_options_max_line_length = 120
"edit by raspberry Pi for testing git remote
