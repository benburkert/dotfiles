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
