" Preamble --------------------------------------------------------------- {{{

set nocompatible
let g:pathogen_disabled = []
call pathogen#infect()

" }}}


" Vimscript file settings ------------------------------------------------ {{{

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" }}}


" Basic settings --------------------------------------------------------- {{{

set hidden
set encoding=utf-8
set history=1000
set laststatus=2
set modelines=0

" highlight current line
set cursorline
set cmdheight=1
set switchbuf=useopen
set showtabline=2
set winwidth=79
set display+=lastline

set shell=bash

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" display incomplete commands
set showcmd

" Enable highlighting for syntax
syntax on
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100

" Error bells are displayed visually.
set visualbell
set ttyfast
" Show line number, cursor position.
set ruler
" Show editing mode
set showmode
set lazyredraw

set relativenumber

set splitbelow
set splitright
set autowrite
set autoread
set nrformats-=octal
set shiftround
set title
set diffopt=filler,vertical,iwhite
set fillchars=stl:-,stlnc:-,vert:.,fold:\ ,diff:-
set linebreak showbreak=+
set listchars=eol:.,tab:\|-

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview

let mapleader = ","
let maplocalleader = "\\"

" Windows
set winheight=40
set winminheight=5

" Undo {{{
if exists("&undodir")
    set undofile          "Persistent undo! Pure money.
    let &undodir=&directory
    set undolevels=500
    set undoreload=500
endif
" }}}
" Cursorline {{{
" Only show cursorline in the current window and in normal mode.

augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END

" }}}
" Trailing whitespace {{{
" Only shown when not in insert mode so I don't go insane.

augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:.
augroup END

" }}}
" Wildmenu completion {{{

" make tab completion for files/buffers act like bash
set wildmenu
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list


" }}}
" Line Return {{{

" Make sure Vim returns to the same line when you reopen a file.
" Thanks, Amit
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" }}}
" Tabs, spaces, wrapping {{{

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set wrap
set textwidth=80
set formatoptions=qrn1
set colorcolumn=+1
set autoindent

" Automatically indent when adding a curly bracket, etc.
set smartindent

" }}}
" Color scheme {{{

let g:solarized_termcolors=256
set t_Co=256                          " force vim to use 256 colors
let g:solarized_termtrans=1
let g:solarized_contrast="normal"
let g:solarized_visibility="normal"
set background=dark
colorscheme solarized

" }}}
" Backups {{{

set backup                        " enable backups
set noswapfile                    " it's 2013, Vim.

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" }}}

" }}}


" Mappings --------------------------------------------------------------- {{{

" Edit .vimrc

nnoremap <leader>evrc :vsplit $MYVIMRC<cr>
nnoremap <leader>svrc :source $MYVIMRC<cr>

" Other

inoremap jk <esc>
inoremap <esc> <nop>

nnoremap <leader>- ddp
nnoremap <leader>_ ddkP

inoremap <c-u> <esc>gUiwea

" use C-p / C-n as Up / Down in command mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Source
vnoremap <leader>S y:execute @@<cr>:echo 'Sourced selection.'<cr>
nnoremap <leader>S ^vg_y:execute @@<cr>:echo 'Sourced line.'<cr>

" Toggle paste
" For some reason pastetoggle doesn't redraw the screen (thus the status bar
" doesn't change) while :set paste! does, so I use that instead.
" set pastetoggle=<F6>
nnoremap <F6> :set paste!<cr>

" Keep the cursor in place while joining lines
nnoremap J mzJ`z

" Split line (sister to [J]oin lines)
" The normal use of S is covered by cc, so don't worry about shadowing it.
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" Select (charwise) the contents of the current line, excluding indentation.
" Great for pasting Python lines into REPLs.
nnoremap vv ^vg_

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" Formatting, TextMate-style
nnoremap Q gqip
vnoremap Q gq

" Reformat line.
" I never use l as a macro register anyway.
nnoremap ql gqq

" Easier linewise reselection of what you just pasted.
nnoremap <leader>V V`]

" Indent/dedent/autoindent what you just pasted.
nnoremap <lt>> V`]<
nnoremap ><lt> V`]>
nnoremap =- V`]=

map <leader>y "+y

" Insert a hash rocket with <c-l>
inoremap <c-l> <space>=><space>

noremap <C-x> <C-w>c

" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" Arrow keys are unacceptable
map <left> <nop>
map <right> <nop>
map <up> <nop>
map <down> <nop>

" Rename current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" Stay in visual mode when indenting. You will never have to run gv after
" performing an indentation.
vnoremap < <gv
vnoremap > >gv

" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yy).
noremap Y y$

" Make Ctrl-e jump to the end of the current line in the insert mode. This is
" handy when you are in the middle of a line and would like to go to its end
" without switching to the normal mode.
inoremap <C-e> <C-o>$

" Allows you to easily replace the current word and all its occurrences.
nnoremap <Leader>rc :%s/\<<C-r><C-w>\>/
vnoremap <Leader>rc y:%s/<C-r>"/

" Allows you to easily change the current word and all occurrences to something
" else. The difference between this and the previous mapping is that the mapping
" below pre-fills the current word for you to change.
nnoremap <Leader>cc :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>cc y:%s/<C-r>"/<C-r>"


" Insert Mode Completion {{{

inoremap <c-f> <c-x><c-f>
inoremap <c-]> <c-x><c-]>

" }}}

" Insert mode aditional commands {{{

" Fix meta keys
imap h <M-h>
imap j <M-j>
imap k <M-k>
imap l <M-l>
imap b <M-b>
imap w <M-w>
imap e <M-e>
imap y <M-y>
imap d <M-d>

" provide hjkl movements in Insert mode via the <Alt> modifier key
inoremap <M-h> <C-o>h
inoremap <M-j> <C-o>j
inoremap <M-k> <C-o>k
inoremap <M-l> <C-o>l

inoremap <M-b> <C-o>b
inoremap <M-w> <C-o>w

" Insert the rest of the line below the cursor.
" Mnemonic: Elevate characters from below line
inoremap <M-e> <Esc>jly$hkpa

" Insert the rest of the line above the cursor.
" Mnemonic:  Y depicts a funnel, through which the above line's characters pour onto the current line.
inoremap <M-y> <Esc>kly$hjpa


inoremap <C-a> <esc>I
inoremap <C-e> <esc>A

inoremap II <Esc>I
inoremap AA <Esc>A
inoremap OO <Esc>O
inoremap CC <Esc>C
inoremap SS <Esc>S
inoremap DD <Esc>dd
inoremap UU <Esc>u

inoremap <M-d> <C-o>dw


" }}}

" Command line mode shortcuts {{{

" provide hjkl movements in Command-line mode via the <Alt> modifier key
cnoremap <M-h> <Left>
cnoremap <M-j> <Down>
cnoremap <M-k> <Up>
cnoremap <M-l> <Right>

cnoremap <C-a> <home>
cnoremap <C-e> <end>

" Normal mode command(s) go… --v <-- here
cnoremap <expr> <M-h> &cedit. 'h' .'<C-c>'
cnoremap <expr> <M-j> &cedit. 'j' .'<C-c>'
cnoremap <expr> <M-k> &cedit. 'k' .'<C-c>'
cnoremap <expr> <M-l> &cedit. 'l' .'<C-c>'

cnoremap <expr> <M-b> &cedit. 'b' .'<C-c>'
cnoremap <expr> <M-w> &cedit. 'w' .'<C-c>'

" }}}

" }}}


" Operators -------------------------------------------------------------- {{{

" Shortcut for [] {{{

onoremap ir i[
onoremap ar a[
vnoremap ir i[
vnoremap ar a[

" }}}
" Next and Last {{{
"
" Motion for "next/last object".  "Last" here means "previous", not "final".
" Unfortunately the "p" motion was already taken for paragraphs.
"
" Next acts on the next object of the given type, last acts on the previous
" object of the given type.  These don't necessarily have to be in the current
" line.
"
" Currently works for (, [, {, and their shortcuts b, r, B. 
"
" Next kind of works for ' and " as long as there are no escaped versions of
" them in the string (TODO: fix that).  Last is currently broken for quotes
" (TODO: fix that).
"
" Some examples (C marks cursor positions, V means visually selected):
"
" din'  -> delete in next single quotes                foo = bar('spam')
"                                                      C
"                                                      foo = bar('')
"                                                                C
"
" canb  -> change around next parens                   foo = bar('spam')
"                                                      C
"                                                      foo = bar
"                                                               C
"
" vin"  -> select inside next double quotes            print "hello ", name
"                                                       C
"                                                      print "hello ", name
"                                                             VVVVVV

onoremap an :<c-u>call <SID>NextTextObject('a', '/')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', '/')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', '/')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', '/')<cr>

onoremap al :<c-u>call <SID>NextTextObject('a', '?')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', '?')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', '?')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i', '?')<cr>


function! s:NextTextObject(motion, dir)
    let c = nr2char(getchar())
    let d = ''

    if c ==# "b" || c ==# "(" || c ==# ")"
        let c = "("
    elseif c ==# "B" || c ==# "{" || c ==# "}"
        let c = "{"
    elseif c ==# "r" || c ==# "[" || c ==# "]"
        let c = "["
    elseif c ==# "'"
        let c = "'"
    elseif c ==# '"'
        let c = '"'
    else
        return
    endif

    " Find the next opening-whatever.
    execute "normal! " . a:dir . c . "\<cr>"

    if a:motion ==# 'a'
        " If we're doing an 'around' method, we just need to select around it
        " and we can bail out to Vim.
        execute "normal! va" . c
    else
        " Otherwise we're looking at an 'inside' motion.  Unfortunately these
        " get tricky when you're dealing with an empty set of delimiters because
        " Vim does the wrong thing when you say vi(.

        let open = ''
        let close = ''

        if c ==# "(" 
            let open = "("
            let close = ")"
        elseif c ==# "{"
            let open = "{"
            let close = "}"
        elseif c ==# "["
            let open = "\\["
            let close = "\\]"
        elseif c ==# "'"
            let open = "'"
            let close = "'"
        elseif c ==# '"'
            let open = '"'
            let close = '"'
        endif

        " We'll start at the current delimiter.
        let start_pos = getpos('.')
        let start_l = start_pos[1]
        let start_c = start_pos[2]

        " Then we'll find it's matching end delimiter.
        if c ==# "'" || c ==# '"'
            " searchpairpos() doesn't work for quotes, because fuck me.
            let end_pos = searchpos(open)
        else
            let end_pos = searchpairpos(open, '', close)
        endif

        let end_l = end_pos[0]
        let end_c = end_pos[1]

        call setpos('.', start_pos)

        if start_l == end_l && start_c == (end_c - 1)
            " We're in an empty set of delimiters.  We'll append an "x"
            " character and select that so most Vim commands will do something
            " sane.  v is gonna be weird, and so is y.  Oh well.
            execute "normal! ax\<esc>\<left>"
            execute "normal! vi" . c
        elseif start_l == end_l && start_c == (end_c - 2)
            " We're on a set of delimiters that contain a single, non-newline
            " character.  We can just select that and we're done.
            execute "normal! vi" . c
        else
            " Otherwise these delimiters contain something.  But we're still not
            " sure Vim's gonna work, because if they contain nothing but
            " newlines Vim still does the wrong thing.  So we'll manually select
            " the guts ourselves.
            let whichwrap = &whichwrap
            set whichwrap+=h,l

            execute "normal! va" . c . "hol"

            let &whichwrap = whichwrap
        endif
    endif
endfunction

" }}}
" Numbers {{{

" Motion for numbers.  Great for CSS.  Lets you do things like this:
"
" margin-top: 200px; -> daN -> margin-top: px;
"              ^                          ^
" TODO: Handle floats.

onoremap N :<c-u>call <SID>NumberTextObject(0)<cr>
xnoremap N :<c-u>call <SID>NumberTextObject(0)<cr>
onoremap aN :<c-u>call <SID>NumberTextObject(1)<cr>
xnoremap aN :<c-u>call <SID>NumberTextObject(1)<cr>
onoremap iN :<c-u>call <SID>NumberTextObject(1)<cr>
xnoremap iN :<c-u>call <SID>NumberTextObject(1)<cr>

function! s:NumberTextObject(whole)
    normal! v

    while getline('.')[col('.')] =~# '\v[0-9]'
        normal! l
    endwhile

    if a:whole
        normal! o

        while col('.') > 1 && getline('.')[col('.') - 2] =~# '\v[0-9]'
            normal! h
        endwhile
    endif
endfunction

" }}}

" }}}


" Autocommands ----------------------------------------------------------- {{{

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass 

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Search  for help with  `K`
  autocmd FileType vim let &keywordprg=':help'
augroup END

" }}}


" Abbreviations ---------------------------------------------------------- {{{
iabbrev the the

" }}}


" Status line ------------------------------------------------------------ {{{

set statusline=
set statusline+=%<%f\ %h%m%r             " filename and flags
" set statusline+=%{fugitive#statusline()} " git info
set statusline+=%=                       " alignment separator
set statusline+=[%{&ft}]                 " filetype
set statusline+=%-14.([%l/%L],%c%V%)     " cursor info

" }}}


" Searching and movement ------------------------------------------------- {{{

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

set ignorecase
set smartcase
set incsearch
set showmatch
set matchtime=3
set hlsearch
set gdefault

" keep more context when scrolling off the end of a buffer
set scrolloff=3

set sidescroll=1
set sidescrolloff=10

set virtualedit+=block

noremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>

" Made D behave
nnoremap D d$

" Don't move on *
nnoremap * *<c-o>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

" gi already moves to "last place you exited insert mode", so we'll map gI to
" something similar: move to last change
nnoremap gI `.

" Fix linewise visual selection of various text objects
nnoremap VV V
nnoremap Vit vitVkoj
nnoremap Vat vatV
nnoremap Vab vabV
nnoremap VaB vaBV

" Directional Keys {{{

noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Easy buffer navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap <leader>v <C-w>v
nnoremap <leader><leader> <c-^>

" }}}

" Visual Mode */# from Scrooloose {{{

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

" }}}

" }}}


" Working with files and dirs -------------------------------------------- {{{

" easy expansion of active file direcotry
cnoremap %% <C-R>=expand('%:h').'/'<CR>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" }}}

" Folding ---------------------------------------------------------------- {{{

set foldlevelstart=0

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

" "Focus" the current line.  Basically:
"
" 1. Close all folds.
" 2. Open just the folds containing the current line.
" 3. Move the line to a little bit (15 lines) above the center of the screen.
" 4. Pulse the cursor line.  My eyes are bad.
"
" This mapping wipes out the z mark, which I never use.
"
" I use :sus for the rare times I want to actually background Vim.
nnoremap <leader>p mzzMzvzz15<c-e>`z:Pulse<cr>

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '.' . repeat(" ",fillcharcount) . foldedlinecount . '.' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}

" Mini-plugins ----------------------------------------------------------- {{{
" Stuff that should probably be broken out into plugins, but hasn't proved to be
" worth the time to do so just yet.

" Ack motions {{{

" Motions to Ack for things.  Works with pretty much everything, including:
"
"   w, W, e, E, b, B, t*, f*, i*, a*, and custom text objects
"
" Awesome.
"
" Note: If the text covered by a motion contains a newline it won't work.  Ack
" searches line-by-line.

nnoremap <silent> <leader>A :set opfunc=<SID>AckMotion<CR>g@
xnoremap <silent> <leader>A :<C-U>call <SID>AckMotion(visualmode())<CR>

nnoremap <bs> :Ack! '\b<c-r><c-w>\b'<cr>
xnoremap <silent> <bs> :<C-U>call <SID>AckMotion(visualmode())<CR>

function! s:CopyMotionForType(type)
    if a:type ==# 'v'
        silent execute "normal! `<" . a:type . "`>y"
    elseif a:type ==# 'char'
        silent execute "normal! `[v`]y"
    endif
endfunction

function! s:AckMotion(type) abort
    let reg_save = @@

    call s:CopyMotionForType(a:type)

    execute "normal! :Ack! --literal " . shellescape(@@) . "\<cr>"

    let @@ = reg_save
endfunction

" }}}
" Pulse Line {{{

function! s:Pulse() " {{{
    let current_window = winnr()
    windo set nocursorline
    execute current_window . 'wincmd w'
    setlocal cursorline

    redir => old_hi
        silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    let steps = 9
    let width = 1
    let start = width
    let end = steps * width
    let color = 233

    for i in range(start, end, width)
        execute "hi CursorLine ctermbg=" . (color + i)
        redraw
        sleep 6m
    endfor
    for i in range(end, start, -1 * width)
        execute "hi CursorLine ctermbg=" . (color + i)
        redraw
        sleep 6m
    endfor

    execute 'hi ' . old_hi
endfunction " }}}
command! -nargs=0 Pulse call s:Pulse()

" }}}
" Indent Guides {{{

let g:indentguides_state = 0
function! IndentGuides() " {{{
    if g:indentguides_state
        let g:indentguides_state = 0
        2match None
    else
        let g:indentguides_state = 1
        execute '2match IndentGuides /\%(\_^\s*\)\@<=\%(\%'.(0*&sw+1).'v\|\%'.(1*&sw+1).'v\|\%'.(2*&sw+1).'v\|\%'.(3*&sw+1).'v\|\%'.(4*&sw+1).'v\|\%'.(5*&sw+1).'v\|\%'.(6*&sw+1).'v\|\%'.(7*&sw+1).'v\)\s/'
    endif
endfunction " }}}
hi def IndentGuides guibg=#303030
nnoremap <leader>I :call IndentGuides()<cr>

" }}}

" Create dir on save if not exitsts {{{
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction

augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" }}}

" Add breakpoint line
nmap <leader>bp :call system('echo ' . @% . ':' . line('.') . '>> dbg.txt')<cr>

" }}}

" }}}

" Plugins ---------------------------------------------------------------- {{{

" Clam {{{

nnoremap ! :Clam<space>
vnoremap ! :ClamVisual<space>
let g:clam_autoreturn = 1
let g:clam_debug = 1

" }}}
" Gundo {{{

nnoremap <F5> :GundoToggle<CR>

let g:gundo_debug = 1
let g:gundo_preview_bottom = 1
let g:gundo_tree_statusline = "Gundo"
let g:gundo_preview_statusline = "Gundo Preview"

" }}}
" Linediff {{{

vnoremap <leader>l :Linediff<cr>
nnoremap <leader>L :LinediffReset<cr>

" }}}
" Ctrl-P {{{

let g:ctrlp_jump_to_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_split_window = 0
let g:ctrlp_max_height = 20
let g:ctrlp_extensions = ['tag']

let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_map = '<leader>.'

let g:ctrlp_prompt_mappings = {
\ 'PrtSelectMove("j")':   ['<c-j>', '<down>', '<s-tab>'],
\ 'PrtSelectMove("k")':   ['<c-k>', '<up>', '<tab>'],
\ 'PrtHistory(-1)':       ['<c-n>'],
\ 'PrtHistory(1)':        ['<c-p>'],
\ 'ToggleFocus()':        ['<c-tab>'],
\ }

let g:ctrlp_custom_ignore = {
\ 'dir':  '\v[\/]\.(git|hg|svn)$',
\ 'file': '\v\.(py[cod]|so)$',
\ }

" }}}
" Vimux {{{
noremap <localleader>vp :VimuxPromptCommand<cr>

function! VimuxSlime()
    call VimuxSendText(@v)
    call VimuxSendKeys("Enter")
endfunction

" If text is selected, save it in the v buffer and send that buffer it to tmux
vnoremap <localleader>vs "vy :call VimuxSlime()<cr>

" Select current paragraph and send it to tmux
nnoremap <localleader>vs vip"vy :call VimuxSlime()<cr>

let g:VimuxHeight = "50"
let g:VimuxOrientation = "h"
" }}}
" Tagbar {{{
nnoremap <silent> <F9> :TagbarToggle<CR>
" }}}
" Ag {{{
let g:ackprg = 'ag --nogroup --nocolor --column'
" }}}
" Easytags {{{
" ensure it checks the project specific tags file
let g:easytags_dynamic_files = 1
" store global tags in language specific files
let g:easytags_by_filetype = '~/.vim/tags' 
" " configure easytags to run ctags after saving the buffer
let g:easytags_events = ['BufWritePost']
" }}}
" Vim-pipe {{{
autocmd FileType sql let b:vimpipe_filetype="postgresql"
" }}}

" }}}


" Languages -------------------------------------------------------------- {{{

" Python ----------------------------------------------------------------- {{{
" Python-mode
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode_rope = 0

" Documentation
let g:pymode_doc = 0

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = ["pyflakes", "pep8"]
" Auto check on save
let g:pymode_lint_on_write = 0
let g:pymode_lint_ignore = "E201,E202,E203,E221,E231,E251,E252,E261,E265,E302,E501,E126,E127,E128,W"
au FileType python nnoremap <silent><leader>ch <esc>:PymodeLint<cr>

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>b'
let g:pymode_breakpoint_cmd = 'import ipdb; ipdb.set_trace()  # XXX BREAKPOINT'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

" Jedi
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 0


" QTPY
let g:qtpy_shell_command = "DJANGO_SETTINGS_MODULE=server.settings.test ./manage.py test"
let g:qtpy_class_delimiter = "."
let g:qtpy_method_delimiter = "."

au FileType python nnoremap <silent><leader>tm <esc>:w <bar> QTPY method<cr>
au FileType python nnoremap <silent><leader>tf <esc>:w <bar> QTPY file<cr>
au FileType python nnoremap <silent><leader>tc <esc>:w <bar> QTPY class<cr>
au FileType python nnoremap <silent><leader>tmv <esc>:w <bar> QTPY method verbose<cr>
au FileType python nnoremap <silent><leader>tfv <esc>:w <bar> QTPY file verbose<cr>
au FileType python nnoremap <silent><leader>tcv <esc>:w <bar> QTPY class verbose<cr>
au FileType python nnoremap <silent><leader>ts :w <bar> QTPY session<cr>
" }}}

" Javascript ------------------------------------------------------------- {{{
nnoremap <leader>d :TernDef<cr>
nnoremap <leader>k :TernDoc<cr>
nnoremap <leader>y :TernType<cr>
nnoremap <leader>f :TernRefs<cr>
nnoremap <leader>r :TernRename<cr>

autocmd Filetype javascript setlocal ts=4 sts=4 sw=4

" }}}

" CSS -------------------------------------------------------------------- {{{

autocmd Filetype css setlocal ts=4 sts=4 sw=4

" }}}

" LESS ------------------------------------------------------------------- {{{

autocmd Filetype less setlocal ts=4 sts=4 sw=4

" }}}

" html ------------------------------------------------------------------- {{{

autocmd Filetype html setlocal ts=4 sts=4 sw=4

" }}}

" htmldjango ------------------------------------------------------------- {{{

autocmd Filetype htmldjango setlocal ts=4 sts=4 sw=4

" }}}

" haskell    ------------------------------------------------------------- {{{

function! ReloadGHCi()
    call VimuxSendText(":reload")
    call VimuxSendKeys("Enter")
endfunction

autocmd Filetype haskell nnoremap <leader>r :w <bar> call ReloadGHCi()<cr>

" }}}

" racket    ------------------------------------------------------------- {{{

autocmd BufReadPost *.rkt,*.rktl set filetype=scheme
autocmd filetype lisp,scheme,art setlocal equalprg=scmindent.rkt

" }}}

" JSON ------------------------------------------------------------------ {{{

autocmd Filetype json setlocal ts=2 sts=2 sw=2

" }}}

" }}}
