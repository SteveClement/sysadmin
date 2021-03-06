" Vim syntax file
" Language:	Gentoo metadata.xml
" Author:	Ciaran McCreesh <ciaranm@gentoo.org>
" Copyright:	Copyright (c) 2004-2005 Ciaran McCreesh
" Licence:	You may redistribute this under the same terms as Vim itself
"
" Syntax highlighting for metadata.xml. Inherits from xml.vim.
"

if &compatible || v:version < 603
    finish
endif

if exists("b:current_syntax")
    finish
endif

runtime! syntax/xml.vim
unlet b:current_syntax

syn cluster xmlTagHook add=metadataElement
syn match metadataElement contained 'packages'
syn match metadataElement contained 'catmetadata'
syn match metadataElement contained 'pkgmetadata'
syn match metadataElement contained 'herd'
syn match metadataElement contained 'maintainer'
syn match metadataElement contained 'email'
syn match metadataElement contained 'name'
syn match metadataElement contained 'description'
syn match metadataElement contained 'longdescription'

hi def link metadataElement Keyword

let b:current_syntax = "gentoo-metadata"

