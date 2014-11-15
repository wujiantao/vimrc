" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"if has("vms")
"  set nobackup		" do not keep a backup file, use versions instead
"else
"  set backup		" keep a backup file
"endif

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
"map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

"filetype on
" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  "filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"vundle configuration
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'SirVer/ultisnips'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'c9s/bufexplorer'
Bundle 'vim-scripts/DoxygenToolkit.vim'
Bundle 'vim-scripts/winmanager'
Bundle 'vim-scripts/taglist.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'BenBergman/TagHighlight'
filetype plugin indent on 

"set color scheme
colorscheme bandit

"show number
set number

"set ballon eval
set ballooneval

"set mapleader
let mapleader=","

"turn on wildmenu
set wildmenu

"set magic on
set magic

"set direction of split the window
set splitright

"smart way to move window
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
"just for NERDTree
nnoremap <C-u> <C-w>j
"just for NERDTree
nnoremap <C-i> <C-w>k
"just for clewn
nnoremap <C-y> <C-w>g

"map <C-S-j> <C-W>J
"map <C-S-k> <C-W>K
"map <C-S-h> <C-W>H
"map <C-S-l> <C-W>L

"tab configuration
map <leader>tn :tabnew %<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

"insert mode ,visual mode and select mode jump to normal mode
imap <C-l> <ESC>
vmap <C-l> <ESC>
smap <C-l> <ESC>

"change to a new blank line below this line in insert mode
nnoremap <leader>o <C-o>
nnoremap <leader>g <C-]>
nnoremap <leader>r <C-t>

"undo
imap <C-u> <ESC>ui

"delete the line that was edited
"imap <C-k> <ESC>ddO

"moving fast to front,back
nmap <leader>e $
nmap <leader>f ^
nmap <leader>de d$
nmap <leader>df d0

"jump the definition of function!, and return.
"nnoremap <leader>] <C-]>
"nnoremap <leader>o <C-o>

"set zoom
set foldmethod=syntax
set foldlevel=100

"text option
set shiftwidth=8
set tabstop=8

"auto indent
set autoindent

"smart indent
set smartindent

"compile c/c++ file
"%< the filename without extention
function! Compile()
	if &filetype=="c"
		set makeprg=gcc\ -o\ %<\ %
	elseif &filetype=="cpp"
		set makeprg=g++\ -o\ %<\ %
	endif
	execute "silent make"
	set makeprg=make
	execute "normal :"
	execute "leftabove copen"
endfunction

"debug c/c++ file
function! Debug()
	if &filetype=="c"
		exec "!gcc -g -o %< %"
	elseif &filetype=="cpp"
		exec "!g++ -g -o %< %"
	endif
endfunction

"run the executable file
function! Run()
	"exec '!./%<'
	let fullpath = expand("%:p")
	let command  = substitute(fullpath, ".".expand("%:e"), "", "")
	let fullpath = substitute(fullpath, "/".expand("%:t"), "", "")
	if getcwd()==fullpath
		exec "!./%<"
	else
		exec "!".command
	endif
endfunction
"set map
map <F8> :call Compile()<cr>
map <C-F8> :call Run()<cr>
map <F6> :call Debug()<cr>

"OmniCppComplete configuration
"set tags-=~/.vim/tags/cpp
"set tags+=~/download/openssl-1.0.1e/crypto/crypto
set tags+=~/program/lkh_ver2/local
set tags+=~/download/stl/stl
set tags+=~/download/nginx-1.7.6/src/nginx
"let OmniCpp_NamespaceSearc = 1
"let OmniCpp_GlobalScopeSearch = 1
"let OmniCpp_ShowAccess = 1
"let OmniCpp_ShowPrototypeInAbbr = 1 " show function! parameters
"let OmniCpp_MayCompleteDot = 1 " autocomplete after .
"let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
"let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
"let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
"au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest
"bulid the tags of your own project
function! AddTags()
	let cur = getcwd()
	let fullpath = expand("%:p")
	let filename = expand("%:t")
	"echo cur."|".fullpath."|".filename
	let fullpath = substitute(fullpath,"/".filename,"","") 
	if cur==fullpath
		exec "silent !ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ -f local ".getcwd()
		set tags+=local	"add the tags in current directory
		"echo cur
	endif
endfunction

"generate cscope database
function! Do_CsTag()
    if(executable("cscope") && has("cscope") )
        if(has('win32'))
            silent! execute "!dir /b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        else
            silent! execute "!find . -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.m" -o -name "*.mm" -o -name "*.java" -o -name "*.py" > cscope.files"
        endif
        silent! execute "!cscope -Rbq"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction

if has("cscope")
  set csprg=/usr/bin/cscope
  set csto=0
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("/home/wu/download/nginx-1.7.6/src/cscope.out")
      cs add cscope.out
  endif
  set csverb
endif
nmap <leader>c :cs find g <C-R>=expand("<cword>")<CR><CR>
"set map
"map <C-F12> :call AddTags()<cr>
"autocmd BufWritePost *.cpp,*.h call AddTags()


"bufExplorer configuration
"let g:bufExplorerMinHeight = 100;

"taglist configuration
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
"let Tlist_Use_Right_Window = 1
let Tlist_Show_Menu = 1
let Tlist_WinHeight = 100
"set hot key to toggle the taglist
"map <silent> <F9> :TlistToggle<cr>

"winmanager configuration
let g:winManagerWindowLayout = 'NERDTree|TagList,BufExplorer'
let g:winManagerWidth = 30
let g:AutoOpenWinManager = 0
nmap <silent> <F10> :WMToggle<cr>

"TagHighlight configuration
nnoremap <leader>tf :UpdateTypesFile<cr>

"Doxgentoolkit configuration
let g:DoxygenToolkit_briefTag_pre="@synopsis  "
let g:DoxygenToolkit_paramTag_pre="@param "
let g:DoxygenToolkit_returnTag="@returns   "
let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="wujiantao, wujiantaozhsh@gmail.com"
let s:licenseTag = "Copyright(C)\<enter>"
let s:licenseTag = s:licenseTag . "For free\<enter>"
let s:licenseTag = s:licenseTag . "All right reserved\<enter>"
let g:DoxygenToolkit_licenseTag = s:licenseTag
let g:DoxygenToolkit_briefTag_funcName="yes"
let g:doxygen_enhanced_color=1
nnoremap <leader>da :DoxAuthor<cr>
nnoremap <leader>dl :DoxLic<cr>
nnoremap <leader>dx :Dox<cr>

"YouCompleteMe configuration
let g:ycm_key_list_select_completion=['<Enter>', '<Down>']
let g:ycm_key_list_previous_completion=['<c-p>', '<Up>']
let g:ycm_global_ycm_extra_conf='/home/wu/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'
nnoremap <leader>yd :YcmDiags<cr>
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<cr>
nnoremap <leader>jc :YcmCompleter GoToDeclaration<cr>

"UltiSnips configuration
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"


function! Regular_expr()
	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"我们假设表达式之间是没有空格的，这个很好做到，直接拿正则表达式预先清除空格
	"匹配结束之后我们再对表达式中需要补充空格和调整间距的地方添加相应的空格
	call RemoveSpace()
	"首先是原始表达式的匹配,认为标示符或者常量如abc
	"9000（字符串作特殊考虑）00aa a000
	"let pat = '\<[A-Za-z]\w*\>\|\<\d\+\>'
	"let pat = '\('.pat.'\)'
	let pat = '\w\+'

	"表达式中可能有对数组的引用，如a[e][f][g] 下面式子的意思是pat = "pat([pat])*
	let pat = pat.'\(\['.pat.'\]\)*'
	let left = pat
	"exec 's/'.pat.'/++/g'

	"然后表达式之间可以进行运算和赋值.下面式子的意思是pat = pat(op pat)*
	"index[a][b][f]*c[e][f]-d[e][f]
	let pat = pat.'\([\*\/+-]'.pat.'\)*'

	"然后表达式可以有括号，应该实现的功能是 pat = pat | (pat),注意之前的括号都是带\(转义的。而这里是原生匹配
	let pat = '(\?'.pat.')\?' "写法有误。但正确的写法因为表达式括号过多,vim已经无法匹配
	"let pat = pat.'\|('.pat.')'  "正确的写法

	"带括号的表达式可以进行运算 要实现的是 pat = pat (op pat)*
	let pat = '\('.pat.'[\*\/+-]\?\)\+'
	"let pat = pat.'\([\*\/+-]'.pat.'\)*'  正确的写法

	"可以引入关系表达式, 但表达式左边不能有运算符。只能是一个变量。这也不准确。但vim已经无法解析表达式了。
	let relation = '\([<>=]\|[<>=]=\)'
	let pat = '\('.left.relation.'\)\?'.pat
	
	"引入字符串表达式
	let pat = pat.'\|\>\".*\"\>'

	"正则表达式书写完毕。不是很准确可能导致不合法的表达式, 但一般合法的表达式是能匹配到的
	let pat = '\('.pat.'\)'
	
	"删除表达式前后的空格
	exec 's/\s*'.pat.'\s*/\1/ge'

	"具体的功能可以自己添加。\1为最外层括号包围的字符串，也即整个匹配到的字符串。可添加和替换。
	exec ':s/'.pat.'/ \1 /ge'
	call InsertSpace()
endfunction

function! RemoveSpace()
	"匹配四则运算符和关系运算符前后的空格并删除
	let pat = '\s*\([\*\/+-<>=]\|[<>=]=\)\s*'
	exec ':s/'.pat.'/\1/ge'
endfunction

function! InsertSpace()
	"匹配四则运算符和关系运算符，并在前后添加空格
	"let pat = '\([\*\/+-<>=]\|[<>=]=\)'
	"为四则运算符添加空格
	let pat = '\([\*\/+-]\)'
	exec ':s/'.pat.'/ \1 /ge'
	"清除可能由Regular_expr在关系运算符之见匹配的空格
	let pat = '\s*\([<>=]\|[<>=]=\)\s*'
	exec ':s/'.pat.'/\1/ge'
	"为关系运算符添加空格
	let pat = '\([<>=]\|[<>=]=\)'
	exec ':s/'.pat.'/ \1 /ge'
endfunction

function! InsertBackslash()
	"用于 markdown 中匹配 _ ，并为 _ 前面加反斜线。
	"let pat = '^\(_\)'
	"exec ':s/'.pat.'/\\\1/ge'
	let pat = '\(^\|[^\\]\)\(_\|\*\)'
	exec ':s/'.pat.'/\1\\\2/ge'
	"用来处理有连续的下划线的情况，第一次匹配不能全部匹配完毕。
	let pat = '\([^\\]\)\(_\|\*\)'
	exec ':s/'.pat.'/\1\\\2/ge'
endfunction

" a + b + c = d + e + f 
nnoremap <leader>is :call Regular_expr()<cr>
nnoremap <leader>ib :call InsertBackslash()<cr>
