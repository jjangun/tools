" .vimrc
" Version: 00.01.01
" Author : Jinhwa Joung <jjangun@gmail.com>

" Basic vim settins {{{
set nocompatible

set foldmethod=marker
set number

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set smartindent
set autoindent

set ruler

syntax enable
set backspace=indent,eol,start
set encoding=utf-8
set fileencodings=utf-8,euc-kr
scriptencoding=utf-8

set fileformat=unix

set ignorecase
set incsearch
set history=1024

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Smart way to open a new tab
map <C-t> :tabnew <CR>
" }}}

" Vundle settings {{{
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'DoxygenToolkit.vim'

Plugin 'jjangun/gtags.vim'
Plugin 'mileszs/ack.vim'

Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'

Plugin 'tpope/vim-unimpaired'         " Easy way to navigate the quickfix list

Plugin 'easymotion/vim-easymotion'

Plugin 'Mark--karkat'

Plugin 'godlygeek/tabular'

Plugin 'tpope/vim-fugitive'

Plugin 'altercation/vim-colors-solarized'
Plugin 'flazz/vim-colorschemes'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" :PluginList       - likts configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" }}}

" YouCompleteMe {{{
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_show_diagnostics_ui = 1

let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_collect_identifiers_from_tags_files = 1

let g:ycm_global_ycm_extra_conf = '~/.tools/env/.ycm_extra_conf.py'

nnoremap <silent> <F3> : YcmForceCompileAndDiagnostics<CR>

nnoremap <leader>g :YcmCompleter GoTo<CR>
nnoremap <leader>gg :YcmCompleter GoToImprecise<CR>
nnoremap <leader>d :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>t :YcmCompleter GetType<CR>
nnoremap <leader>p :YcmCompleter GetParent<CR>
nnoremap <leader>f :YcmCompleter FixIt<CR>
" }}}

" Quickfix {{{
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nnoremap <silent> <F4> :call ToggleList("Location List", 'l')<CR>
nnoremap <silent> <F5> :call ToggleList("Quickfix List", 'c')<CR>
" }}}

" NERDTree settings {{{
nnoremap <silent> <F6> :NERDTreeToggle<CR>

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" }}}

" gnu global settings {{{
nmap <C-]> :GtagsCursor<CR>

let Gtags_Auto_Update=1
let Gtags_No_Auto_Jump=1
" }}}

" ack settings {{{
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

cnoreabbrev ag Ack!
nnoremap <leader>ag :Ack!<CR>
" }}}

" Tagbar settings {{{
nnoremap <silent> <F7> :TagbarToggle<CR>
let g:tagbar_sort = 0
" }}}

" ctrlp settings {{{
map <C-p> :CtrlPLastMode --dir<CR>

let g:ctrlp_cmd = 'CtrlP --dir'
let g:ctrlp_working_path_mode = 'ra'
" }}}

" airline settings {{{
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_buffers = 0

let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>= <Plug>AirlineSelectNextTab
" }}}

" vim-easymotion settings {{{
let g:EasyMotion_smartcase = 1

" Gif config
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
" }}}

" Color scheme {{{
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=0

colorscheme solarized
let g:airline_theme='badwolf'

" Column line 80 highlight {{{
set colorcolumn=+1
hi ColorColumn ctermbg=235
set colorcolumn=80
" }}}

" }}}

" Whitespace & EndingSpace Highlight {{{
highlight ExtraWhitespace ctermbg=darkred guibg=#382424
match ExtraWhitespace /\s\+$/
set list listchars=tab:»-,trail:-,extends:$,nbsp:=

" auto remove trailling space when save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    retab
    %s/\s\+$//ge
    call cursor(l, c)
endfun

autocmd FileType c,cpp,cs,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
" }}}

" DoxygenToolkit {{{
let g:DoxygenToolkit_authorName="Jinhwa Joung"
nnoremap <silent> <F8> :Dox<CR>
" }}}
