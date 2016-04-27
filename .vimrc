" Syntax highlighting
syn on
set syntax=on

" Indentation
filetype indent plugin on 
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
"set smartindent

" No sound bell
set visualbell

" Search
set incsearch
set ignorecase
set smartcase

" Match for prenthesis, brackets...
set showmatch

" Map auto complete of (, ', ", [, {
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
inoremap ' ''<Esc>i
inoremap " ""<Esc>i

" tab navigation
map <C-Right> :tabnext<CR>
map <C-Left> :tabprevious<CR>

" No line wrapping
set nowrap

" Display a ruler at the bottom of the screen
set ruler

" Highlight Python builtins methods and keywords
let python_highlight_builtins=1
"""""au FileType python syn keyword pythonDecorator True None False self
au FileType python inoremap <buffer> $main if __name__ == '__main__':<CR>main()<CR>
au FileType python inoremap <buffer> $coding # -*- coding: utf-8 -*-
au FileType python noremap <silent> <C-c> 0i#<esc>
au FileType python noremap <silent> <C-X> 0x<esc>
au FileType python vnoremap <silent> <C-c> :s/^/#<esc>
au FileType python vnoremap <silent> <C-X> :s/^#//<esc>
autocmd BufNewFile *.py 0put=\"#!/usr/bin/env python\"|
  \ 1put=\"\"|
  \ 2put=\"def main():\"|
  \ 3put=\"    pass\"|
  \ 4put=\"\"|
  \ 5put=\"if __name__ == '__main__':\"|
  \ 6put=\"    main()\"|
  \ 7put=\"\"|
  \ 4

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal fo-=t fo+=croql

" Automatically create the clean target of Makefiles
au FileType make inoremap <buffer> $clean TARGETS = <CR><CR><CR><CR>clean:<CR>rm -f $(TARGETS)<CR>



" Comments in c, c++ source files
au FileType c,cpp vnoremap <silent> <C-c> :s/^/\/\/<esc>

"colorscheme monokai

if has("gui_running")
    set guioptions=egmrt
    set columns=80
endif

"
" Set file type as a function of extension.
"

" cluster job files are shell
au BufRead,BufNewFile *.ll  set filetype=sh
au BufRead,BufNewFile *.ccc set filetype=sh
au BufRead,BufNewFile *.pbs set filetype=sh
au BufRead,BufNewFile *.slurm set filetype=sh

" .vmd files are tcl files
au BufRead,BufNewFile *.vmd set filetype=tcl

" README files are markdown files
au BufRead,BufNewFile README set filetype=markdown
