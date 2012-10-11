" disable vi mode
set nocompatible

" load pathogen
call pathogen#infect()

" setup color schemes, light for macvim, dark for regular
syntax enable

if has('gui_running')
    set background=light
else
    set background=dark
endif

colorscheme solarized

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Trailing Whitespace
highlight ExtraWhitespace ctermbg=red
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/

"display tabs and trailing spaces
set list
set listchars=tab:▷⋅,nbsp:⋅

" file type detection stuff
if has("autocmd")

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
endif

" Ignored Files
let NERDTreeIgnore =  []

" Line Numbers
set number

" Visual Stuff
set ruler
set showmatch
set virtualedit=all

" Search
set hlsearch
set incsearch

" Swap
set nobackup
set nowritebackup
set noswapfile

" Thorfile, Rakefile, Puppetfile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Puppetfile,config.ru}    set ft=ruby

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" ctrlp.vim
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'

" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Show (partial) command in the status line
set showcmd

" VimClojure
let vimclojure#WantNailgun = 1
let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#ParenRainbow = 1
let g:vimclojure#DynamicHighlighting = 1
