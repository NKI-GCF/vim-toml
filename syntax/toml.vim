" Language:   TOML
" Maintainer: Caleb Spare <cespare@gmail.com>
" URL:        https://github.com/cespare/vim-toml
" LICENSE:    MIT

if exists("b:current_syntax")
  finish
endif

let b:current_syntax = "tomlfile"

syn match tomlEscape /\\[btnfr"/\\]/ display contained
syn match tomlEscape /\\u\x\{4}/ contained
syn match tomlEscape /\\U\x\{8}/ contained
hi def link tomlEscape SpecialChar

syn match tomlLineEscape /\\$/ contained
hi def link tomlLineEscape SpecialChar

highlight link inChanHL PreProc
highlight link outChanHL Statement

hi def link chanIdDef Identifier
syn match chanIdDef /\v\.\s*[[:alnum:]._-]+(\s*[=)"}])@=/ display

hi link inChanStart inChanHL
syn match inChanStart /\v((^|[,({])\s*)@<=\s*in(\s*\.)@=/ display

syn cluster inChan contains=inChanStart,chanIdDef

hi link outChanStart outChanHL
syn match outChanStart /\v([("]\s*)@<=\s*out(\s*\.)@=/ display

syn cluster outChan contains=outChanStart,chanIdDef

hi link refOutComp SpecialKey
syn match refOutComp /\v(out\s*\.\s*)@<=[[:alnum:]._-]+\s*(\s*\.)@=/ display

syn cluster refOutChan contains=outChanStart,refOutComp,chanIdDef

hi link refConfigStart SignColumn
syn match refConfigStart /\v([("]\s*)@<=\s*config(\s*\.)@=/ display

syn cluster refConfig contains=refConfigStart,chanIdDef



hi link subSingleQuote String
syn match subSingleQuote /\v(\/\s*,\s*)@<='([^'\\]*|(\\\\)*\\')+'(\s*,)@=/ display



hi link subRegExpContent Constant
syn match subRegExpContent +\v([^/\\]*|(\\\\)*\\\/)*+ display

"syn region innerParens oneline start=+(+ end=+)+ transparent contains=Normal
syn region subRegExp oneline matchgroup=Statement start=+\v(sub\(\s*)@<=/+ end=+\v/(\s*,)@=+ contains=subRegExpContent

syn region revolveAll oneline matchgroup=Special start=+all(\(out\s*\.\)\@=+ end=+)+ contains=refOutChan,refConfig
syn region revolveEach oneline matchgroup=Special start=+each(\(out\s*\.\)\@=+ end=+)+ contains=refOutChan,refConfig

syn region revolveSub oneline matchgroup=Special start=+sub(\(\s*\/\)\@=+ end=+)+ contains=subRegExp,subSingleQuote,inChan
hi link revolveSub Special

syn region revolveBasename oneline matchgroup=Special start=+basename(\(\s*in\s*\.\)\@=+ end=+)+ contains=inChan
hi link revolveBasename Special



syn region inChanQuote oneline matchgroup=String start=/\v(\=\s*)@<=\"/ skip=/\\\\\|\\"/ end=/"/ contains=revolveAll,revolveEach,refOutChan,refConfig
syn region outChanQuote oneline matchgroup=String start=/\v(\=\s*)@<=\"/ skip=/\\\\\|\\"/ end=/"/ contains=revolveSub,revolveBasename

syn region inChanDefine matchgroup=inChanHL start=/\v^\s*in(\s*\.)@=/ end=/$/ contains=inChan,inChanQuote
syn region outChanDefine matchgroup=outChanHL start=/\v^\s*out(\s*\.)@=/ end=/$/ contains=chanIdDef,outChanQuote


"syn region inChan matchgroup=inChanHL start=/\v^\s*in\.[^ ]+\s*\=\s*"$/ skip=/\\\\\|\\"/ end=/^"$/ contains=tomlEscape,inChannel

"syn region outChan matchgroup=outChanHL start=/\v^\s*out\.[^ ]+\s*\=\s*"$/ skip=/\\\\\|\\"/ end=/^"$/ contains=tomlEscape,revolveSub




" Basic strings
"syn region tomlString oneline start=/\v(^\s*(\in|out)\.[^' ]+\s*\=\s*)@<!"/ skip=/\\\\\|\\"/ end=/"/ contains=tomlEscape
" Multi-line basic strings
syn region tomlString start=/"""/ end=/"""/ contains=tomlEscape,tomlLineEscape
" Literal strings
"syn region tomlString oneline start=/\v(^\s*in\.[^' ]+\s*\=\s*)@<!'/ end=/'/
" Multi-line literal strings
syn region tomlString start=/'''/ end=/'''/
hi def link tomlString String

syn match tomlInteger /[+-]\=\<[1-9]\(_\=\d\)*\>/ display
syn match tomlInteger /[+-]\=\<0\>/ display
syn match tomlInteger /[+-]\=\<0x[[:xdigit:]]\(_\=[[:xdigit:]]\)*\>/ display
syn match tomlInteger /[+-]\=\<0o[0-7]\(_\=[0-7]\)*\>/ display
syn match tomlInteger /[+-]\=\<0b[01]\(_\=[01]\)*\>/ display
syn match tomlInteger /[+-]\=\<\(inf\|nan\)\>/ display
hi def link tomlInteger Number

syn match tomlFloat /[+-]\=\<\d\(_\=\d\)*\.\d\+\>/ display
syn match tomlFloat /[+-]\=\<\d\(_\=\d\)*\(\.\d\(_\=\d\)*\)\=[eE][+-]\=\d\(_\=\d\)*\>/ display
hi def link tomlFloat Float

syn match tomlBoolean /\<\%(true\|false\)\>/ display
hi def link tomlBoolean Boolean

" https://tools.ietf.org/html/rfc3339
syn match tomlDate /\d\{4\}-\d\{2\}-\d\{2\}/ display
syn match tomlDate /\d\{2\}:\d\{2\}:\d\{2\}\%(\.\d\+\)\?/ display
syn match tomlDate /\d\{4\}-\d\{2\}-\d\{2\}[T ]\d\{2\}:\d\{2\}:\d\{2\}\%(\.\d\+\)\?\%(Z\|[+-]\d\{2\}:\d\{2\}\)\?/ display
hi def link tomlDate Constant

syn match tomlKey /\v(^|[{,])\s*\zs(in\.|out\.)@![[:alnum:]._-]+\ze\s*\=/ display
hi def link tomlKey Identifier

syn region tomlKeyDq oneline start=/\v(^|[{,])\s*\zs"/ end=/"\ze\s*=/ contains=tomlEscape
hi def link tomlKeyDq Identifier

syn region tomlKeySq oneline start=/\v(^|[{,])\s*\zs'/ end=/'\ze\s*=/
hi def link tomlKeySq Identifier

" revolve: toml config
hi link tomlConfig SignColumn
syn match tomlConfig /^\s*\[\s*config\s*\]/ containedin=ALL contains=tomlConfig

" revolve placeholder contents

" revolve: toml placeholder
highlight link tomlPlaceholder SpecialKey
syn cluster tomlPH contains=tomlPlaceholder
syn match tomlPlaceholder contained "^\s*\[comp\.[^.]\+\]" containedin=ALL contains=@tomlPH
syn region tomlPlaceholder matchgroup=Title oneline start=/^\s*\[comp\.\@=/ end=/\]/ containedin=@tomlPH contains=@SpecialKey keepend

" generic toml
syn region tomlTable oneline start=/^\s*\[\(config\|comp\.\|\[\)\@!/ end=/\]/ contains=tomlKey,tomlKeyDq,tomlKeySq
hi def link tomlTable Title


syn region tomlTableArray oneline start=/^\s*\[\[/ end=/\]\]/ contains=tomlKey,tomlKeyDq,tomlKeySq
hi def link tomlTableArray Title

syn keyword tomlTodo TODO FIXME XXX BUG contained
hi def link tomlTodo Todo

syn match tomlComment /#.*/ contains=@Spell,tomlTodo
hi def link tomlComment Comment

syn sync minlines=500

highlight link inlineShellKeyword airline_term_bold

" inline shell script
let s:current_syntax = b:current_syntax
unlet b:current_syntax
syntax include @SH syntax/sh.vim
" redefine shComment, bash interprets placeholders as comment.
syn clear shComment

syn match shComment "^\s*\zs#\({\(in\|out\|config\)\.[^.}]\+}\)\@!.*$" containedin=@SH contains=@shCommentGroup
syn match shComment "\s\zs#\({\(in\|out\|config\)\.[^.}]\+}\)\@!.*$" containedin=@SH contains=@shCommentGroup
syn match shComment contained "#\({\(in\|out\|config\)\.[^.}]\+}\)\@!.*$" containedin=@SH contains=@shCommentGroup

syn match tomlPlaceholder contained "#{\(in\|out\|config\)\.[^.}]\+}" containedin=ALL contains=@tomlPH

syn region tomlPlaceholder matchgroup=Title oneline start=/#{\(in\|out\|config\)\./ end=/}/ containedin=@tomlPH contains=@SpecialKey keepend

let b:current_syntax = s:current_syntax
syntax region shLine matchgroup=inlineShellKeyword start=/\v^\s*command\s*\=\s*"""$/ end=/^"""$/ contains=@SH

let b:current_syntax = "toml"
