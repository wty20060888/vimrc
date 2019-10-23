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
"vim-plug插件设置
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
  elsleif &filetype == 'sh'
    :!time bash %
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

func! RunBuild(args)
  exec "w"
    if a:args == 'uno'
      exec "!arduino-cli compile --fqbn arduino:avr:uno ../%<"
      exec "!arduino-cli upload -p $(find /dev//cu.usbmodem*) --fqbn arduino:avr:uno ../%<"
    elseif a:args == 'nodemcu'
      exec "!arduino-cli compile --fqbn esp8266:esp8266:nodemcuv2 ../%<"
      exec "!arduino-cli upload -p $(find /dev//cu.wchusbserial*) --fqbn esp8266:esp8266:nodemcuv2 ../%<"
    endif
endfunc
" 自定义Run函数
command! -nargs=1 Run :call RunBuild(<f-args>)

call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'connorholyday/vim-snazzy'
Plug 'scrooloose/nerdtree'
" Plug 'ycm-core/YouCompleteMe'
" assuming you're using vim-plug: https://github.com/junegunn/vim-plug
" Plug 'ncm2/ncm2'
" Plug 'roxma/nvim-yarp'
Plug 'python-mode/python-mode',{'for': 'python','branch': 'develop'}
" enable ncm2 for all buffers
" autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
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
Plug 'tclem/vim-arduino'
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

call vundle#end()            " required
filetype plugin indent on    " required




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
" au User Ncm2Plugin call ncm2#register_source({
"     \ 'name' : 'css',
"    \ 'priority': 9,
"    \ 'subscope_enable': 1,
"    \ 'scope': ['css','scss'],
"    \ 'mark': 'css',
"    \ 'word_pattern': '[\w\-]+',
"    \ 'complete_pattern': ':\s*',
"    \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
"    \ })
"python-mode conf
let g:pymode_python = 'python3'
let g:pymode_trim_whitespaces = 1
let g:pymode_doc = 1
let g:pymode_doc_bind = 'K'
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

" ===
" === VIM-Arduino
" ===
" let g:vim_arduino_map_keys = 0
"Default:/Applications/Arduino.app/Contents/Resources/Java
let g:vim_arduino_library_path ="/Applications/Arduino.app/Contents/Resources/Java"
"Default: result of `$(ls/dev/tty.* | grep usb)`
let g:vim_arduino_serial_port ="/dev/tty.usbmodem14701"
