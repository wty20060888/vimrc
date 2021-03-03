" __  __               _                    
"|  \/  |_   _  __   _(_)_ __ ___  _ __ ___ 
"| |\/| | | | | \ \ / / | '_ ` _ \| '__/ __|
"| |  | | |_| |  \ V /| | | | | | | | | (__ 
"|_|  |_|\__, |   \_/ |_|_| |_| |_|_|  \___|
"        |___/                              
"
"  ____          _          _   _           
" / ___|___   __| | ___  __| | | |__  _   _ 
"| |   / _ \ / _` |/ _ \/ _` | | '_ \| | | |
"| |__| (_) | (_| |  __/ (_| | | |_) | |_| |
" \____\___/ \__,_|\___|\__,_| |_.__/ \__, |
"                                     |___/ 
"
"__        __                  _____ _                         
"\ \      / /_ _ _ __   __ _  |_   _(_) __ _ _ __  _   _ _   _ 
" \ \ /\ / / _` | '_ \ / _` |   | | | |/ _` | '_ \| | | | | | |
"  \ V  V / (_| | | | | (_| |   | | | | (_| | | | | |_| | |_| |
"   \_/\_/ \__,_|_| |_|\__, |   |_| |_|\__,_|_| |_|\__, |\__,_|
"                      |___/                       |___/       
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
"智能识别大小写
set smartcase
"设置显示命令提示
set showcmd
"设置普通模式下：命令 可以tab补全
set wildmenu

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
autocmd CompleteDone * pclose

noremap J 5j
noremap K 5k
noremap H 0
noremap L $
map sl :set splitright<CR>:vsplit<CR>
map sh :set nosplitright<CR>:vsplit<CR>
map sk :set nosplitbelow<CR>:split<CR>
map sj :set splitbelow<CR>:split<CR>
"切换窗口
map <LEADER>h <C-w>h
map <LEADER>j <C-w>j
map <LEADER>l <C-w>l
map <LEADER>k <C-w>k
"Lint快捷键设置
map <LEADER>p : PymodeLintAuto<CR>
" Compile function
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
  exec "w"
  if &filetype == 'c'
    exec "!g++ -g *.c -o %<"
    exec "!time ./%<"
  elseif &filetype == 'cpp'
    exec "!g++ % -o %<"
    exec "!time ./%<"
  elseif &filetype == 'java'
    exec "!javac %"
    exec "!time java %<"
  elseif &filetype == 'sh'
    exec ":!time bash %"
  elseif &filetype == 'python'
    silent! exec "!clear"
    exec "!time python3 %"
  elseif &filetype == 'html'
    exec "!open %"
  elseif &filetype == 'markdown'
    exec "MarkdownPreview"
  elseif &filetype == 'vimwiki'
    exec "MarkdownPreview"
  elseif &filetype == 'arduino'
    if(search("ESP8266WiFi.h"))
      exec "!arduino-cli compile --fqbn esp8266:esp8266:nodemcuv2 ../%<"
      exec "!arduino-cli upload -p $(find /dev//cu.wchusbserial*) --fqbn esp8266:esp8266:nodemcuv2 ../%<"
    else
      exec "!arduino-cli compile --fqbn arduino:avr:uno ../%<"
      exec "!arduino-cli upload -p $(find /dev//cu.usbmodem*) --fqbn arduino:avr:uno ../%<"
    endif
  endif
endfunc

map R :call CompileBuildrrr()<CR>
func! CompileBuildrrr()
  exec "w"
  if &filetype == 'vim'
    exec "source %"
  elseif &filetype == 'markdown'
    exec "echo"
  endif
endfunc

autocmd Filetype arduino set cindent shiftwidth=2

"保存时自动调用ctags
autocmd BufWritePost * call system("ctags -R")

" 自定义Run函数
command! -nargs=? Run :call RunBuild(<f-args>)
command! IPython :call TerIPython()
command! Jupyter :call NvimTerIPython()

function! TerIPython()
    exec "set splitright"
    exec "vsplit"
    exec "ter++curwin ipython3"
endfunction

function! NvimTerIPython()
    exec "tabe term://jupyter qtconsole"
    exec "q"
    exec ":JupyterConnect"
endfunction


nnoremap <leader>te V:call SendToTerminal()<CR>$
vnoremap <leader>te <Esc>:call SendToTerminal()<CR>
function! SendToTerminal()
    let buff_n = term_list()
    if len(buff_n) > 0
        let buff_n = buff_n[0] " sends to most recently opened terminal
        let lines = getline(getpos("'<")[1], getpos("'>")[1])
        let indent = match(lines[0], '[^ \t]') " check for removing unnecessary indent
        for l in lines
            let new_indent = match(l, '[^ \t]')
            if new_indent == 0
                call term_sendkeys(buff_n, l. "\<CR>")
            else
                call term_sendkeys(buff_n, l[indent:]. "\<CR>")
            endif
            sleep 10m
        endfor
    endif
endfunction

func! RunBuild(...)
  exec "w"
    if a:000 == ['uno']
      exec "!arduino-cli compile --fqbn arduino:avr:uno ../%<"
      exec "!arduino-cli upload -p $(find /dev//cu.usbmodem*) --fqbn arduino:avr:uno ../%<"
    elseif a:000 == ['nodemcu']
      exec "!arduino-cli compile --fqbn esp8266:esp8266:nodemcuv2 ../%<"
      exec "!arduino-cli upload -p $(find /dev//cu.wchusbserial*) --fqbn esp8266:esp8266:nodemcuv2 ../%<"
    else
      if &filetype == 'c'
        exec "!g++ -g *.c -o %<"
        exec "!time ./%<"
      elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%<"
      elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %<"
      elseif &filetype == 'sh'
        exec ":!time bash %"
      elseif &filetype == 'python'
        silent! exec "!clear"
        exec "ter python3 %"
      elseif &filetype == 'html'
        exec "!open %"
      elseif &filetype == 'markdown'
        exec "MarkdownPreview"
      elseif &filetype == 'vimwiki'
        exec "MarkdownPreview"
      endif
    endif
endfunc

"vim-plug插件设置
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'connorholyday/vim-snazzy'
Plug 'scrooloose/nerdtree'
" Plug 'ncm2/ncm2'
" Plug 'roxma/nvim-yarp'
" Plug 'python-mode/python-mode',{'for': 'python','branch': 'develop'}
" set completeopt=noinsert,menuone,noselect
" Plug 'ncm2/ncm2-bufword'
" Plug 'ncm2/ncm2-path'
" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync() }, 'for' :['markdown', 'vim-plug'] }
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Or latest tag
" Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
" Or build from source code by use yarn: https://yarnpkg.com
" Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'majutsushi/tagbar'
Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
call plug#end()



set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'ycm-core/YouCompleteMe'
" Track the engine.
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
Plugin 'jupyter-vim/jupyter-vim'
" Plugin 'ivanov/vim-ipython'
call vundle#end()            " required
filetype plugin indent on    " required

"===
"===snazzy
"===


color snazzy
let g:SnazzyTransparent = 1
let g:python3_host_prog="/Users/wangtianyu/anaconda3/bin/python3"

"===
"===NerdTree映射
"===
map <LEADER>n :NERDTreeToggle<CR>
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

"===
"===python-mode conf
"===
let g:pymode_python = 'python3'
let g:pymode_trim_whitespaces = 1
let g:pymode_doc = 1
let g:pymode_doc_bind = '<C-d>'
let g:pymode_rope_goto_definition_bind = "<C-]>"
let g:pymode_lint = 1
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe', 'pylint']
let g:pymode_options_max_line_length = 120

" ===
" === MarkdownPreview
" ===
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip = ''
let g:mkdp_browser = ''
let g:mkdp_echo_preview_url = 0
let g:mkdp_browserfunc = ''
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1
    \ }
let g:mkdp_markdown_css = ''
let g:mkdp_highlight_css = ''
let g:mkdp_port = ''
let g:mkdp_page_title = '「${name}」'
let g:EclimCompletionMethod = 'omnifunc'


" ===
" === YCM
" ===
let g:ycm_server_python_interpreter='/usr/local/bin/python3'
let g:ycm_global_ycm_extra_conf='~/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 1                  "关闭语法提示

let g:ycm_complete_in_comments=1                   " 补全功能在注释中同样有效
let g:ycm_confirm_extra_conf=1                     " 允许 vim 加载 .ycm_extra_conf.py 文件，不再提示
let g:ycm_collect_identifiers_from_tags_files=1    " 开启 YCM 标签补全引擎
let g:ycm_min_num_of_chars_for_completion=1        " 从第一个键入字符就开始罗列匹配项
let g:ycm_cache_omnifunc=0                         " 禁止缓存匹配项，每次都重新生成匹配项
let g:ycm_seed_identifiers_with_syntax=1           " 语法关键字补全
let g:ycm_goto_buffer_command = 'horizontal-split' " 跳转打开上下分屏


"===
"=== ultisnips
"===
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/UltiSnips/', 'UltiSnips']
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"===
"=== tagbar 
"===

nmap <LEADER>t :TagbarToggle<CR>

"===
"=== vim-jupyter 
"===

" Run current file
nnoremap <buffer> <silent> <localleader>R :JupyterRunFile<CR>
nnoremap <buffer> <silent> <localleader>I :PythonImportThisFile<CR>

" Change to directory of current file
nnoremap <buffer> <silent> <localleader>d :JupyterCd %:p:h<CR>

" Send a selection of lines
nnoremap <buffer> <silent> <leader>X :JupyterSendCell<CR>
nnoremap <buffer> <silent> <leader>s :JupyterSendRange<CR>
vmap     <buffer> <silent> <leader>s <Plug>JupyterRunVisual

nnoremap <buffer> <silent> <leader>c :JupyterConnect<CR>
nnoremap <buffer> <silent> <localleader>U :JupyterUpdateShell<CR>

" Debugging maps
nnoremap <buffer> <silent> <localleader>b :PythonSetBreak<CR>
