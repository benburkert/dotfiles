set nocompatible          " disable vi mode
syntax enable
set encoding=utf8
set showcmd               " display incomplete commands
filetype plugin indent on " load file type plugins + indentation

" load pathogen
call pathogen#infect()

if has('gui_running')
    set background=light
else
    set background=dark
endif

"" Airline
set laststatus=2

"" Remaps
let mapleader =","
nnoremap <leader><leader> <c-^>
let maplocalleader = "\\"

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces
set expandtab                   " use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

" Trailing Whitespace
highlight ExtraWhitespace ctermbg=red
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/

"" Searching
set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capitol letter

"display tabs and trailing spaces
set list
set listchars=tab:\ \ ,nbsp:⋅

" Thorfile, Rakefile, Puppetfile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Puppetfile,config.ru}    set ft=ruby

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" file type detection stuff
if has("autocmd")

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab

  " C languages
  autocmd FileType c,cpp,cxx,h,hpp,go setlocal ts=4 sts=4 sw=4 noexpandtab

  " Go
  " autocmd FileType go autocmd BufWritePre <buffer> Fmt
  autocmd FileType go map <leader>b :!go build -i $(gopwd)/$(dirname %)<CR>
  autocmd FileType go map <leader>r :!go run $(gopwd)/$(dirname %)<CR>
  autocmd FileType go map <leader>tt :!echo -ne '\033]50;ClearScrollback\a' && go build -i $(gopwd)/$(dirname %) && go test $(gopwd)/$(dirname %)<CR>
  autocmd FileType go map <leader>tr :!echo -ne '\033]50;ClearScrollback\a' && go build -i -race $(gopwd)/$(dirname %) && go test -race -v $(gopwd)/$(dirname %)<CR>
  autocmd FileType go map <leader>tv :!echo -ne '\033]50;ClearScrollback\a' && go build -i $(gopwd)/$(dirname %) && go test -v $(gopwd)/$(dirname %)<CR>

  "autocmd FileType go map <leader>t :w<CR> :set makeprg=go\ test<CR> :make<CR>
  autocmd BufWritePost,FileWritePost *.go execute 'Lint' | cwindow
  " autocmd BufWritePost *.go silent! !ctags -R -f $(git rev-parse --show-toplevel)/.git/tags . &

  autocmd FileType go nmap <Leader>s <Plug>(go-implements)
  autocmd FileType go nmap <Leader>i <Plug>(go-info)
  autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
  autocmd FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
  autocmd FileType go nmap <Leader>ds <Plug>(go-def-split)
  autocmd FileType go nmap <Leader>dv <Plug>(go-def-vertical)
  autocmd FileType go nmap <Leader>e <Plug>(go-rename)
endif

" Line Numbers
set number

" Visual Stuff
set ruler
set showmatch
set virtualedit=all

" Swap
set nobackup
set nowritebackup
set noswapfile

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" Ctrlp.vim
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'

" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Ignore everything in .gitignore
let filename = '.gitignore'
if filereadable(filename)
  let igstring = ''
  for oline in readfile(filename)
    let line = substitute(oline, '\s|\n|\r', '', "g")
    if line =~ '^#' | con | endif
    if line == '' | con  | endif
    if line =~ '^!' | con  | endif
    if line =~ '/$' | let igstring .= "," . line . "*" | con | endif
    let igstring .= "," . line
  endfor
  let execstring = "set wildignore=".substitute(igstring, '^,', '', "g")
  execute execstring
endif

" Go.vim
let g:go_fmt_command = "goimports"
set rtp+=$GOPATH/src/github.com/golang/lint/misc/vim

" ctags
nmap <F8> :TagbarToggle<CR>
