" Vim syntax file
" Language:	Gentoo make.conf Files
" Author:	Ciaran McCreesh <ciaranm@gentoo.org>
" Copyright:	Copyright (c) 2004-2005 Ciaran McCreesh
" Licence:	You may redistribute this under the same terms as Vim itself
"
" Syntax highlighting for Gentoo make.conf files. Needs vim 6.3 or later.
"

if &compatible || v:version < 603
    finish
endif

if exists("b:current_syntax")
  finish
endif

runtime syntax/gentoo-common.vim

syn cluster GentooMakeConfEC add=GentooMakeConfEUse,GentooMakeConfEAK,GentooMakeConfECFLAGS,GentooMakeConfEMAKEOPTS,GentooMakeConfECHOST,GentooMakeConfEFEATURES,GentooMakeConfEMISC,GentooMakeConfEMISCK,GentooMakeConfEMISCKE,GentooMakeConfEMISCN
syn region  GentooMakeConfE start=/^/ end=/$/ contains=@GentooMakeConfEC,GentooMakeConfComment

" MISC {{{
syn match   GentooMakeConfEMISC /[a-zA-Z0-9\-\_]\+\([^a-zA-Z0-9\-\_]\)\@=/ contained nextgroup=GentooMakeConfEMISCE skipwhite

syn match   GentooMakeConfEMISCE /=/ contained nextgroup=GentooMakeConfEMISCV,GentooMakeConfEMISCVNoQ skipwhite
syn region  GentooMakeConfEMISCV contained start=/"/ end=/"/ contains=GentooMakeConfEMISCIX
syn region  GentooMakeConfEMISCVNoQ contained start=/[^ "]/ end=/\s\|$/ contains=GentooMakeConfEMISCIX
syn match   GentooMakeConfEMISCIX /\\.\|\$\({[^}]\+}\|[a-zA-Z0-9\-\_]\+\)/ contained

" naughty
syn match   GentooMakeConfEMISCN /LDFLAGS\|ASFLAGS\|ARCH\|USERLAND/ contained nextgroup=GentooMakeConfEMISCE skipwhite
" known but not handled specially
syn match   GentooMakeConfEMISCK /GENTOO_MIRRORS\|SYNC\|PORTAGE_NICENESS\|PORTDIR_OVERLAY\|PORTAGE_GPG_DIR\|PORTAGE_GPG_KEY\|CONFIG_PROTECT_MASK\|CONFIG_PROTECT\|FETCHCOMMAND\|RESUMECOMMAND\|AUTOCLEAN\|BUILD_PREFIX\|CBUILD\|CLEAN_DELAY\|DISTDIR\|HTTP_PROXY\|FTP_PROXY\|NOCOLOR\|PKGDIR\|PORT_LOGDIR\|PORTAGE_BINHOST\|PORTAGE_TMPDIR\|PORTDIR\|ROOT\|RSYNC_EXCLUDEFROM\|RSYNC_RETRIES\|RSYNC_TIMEOUT\|RPMDIR\|USE_ORDER\|LINGUAS\|VIDEO_CARDS\|INPUT_DEVICES\|EXTRA_ECONF\|ALSA_CARDS\|PORTAGE_TMPFS/ contained nextgroup=GentooMakeConfEMISCE skipwhite
" common eclass stuff
syn match GentooMakeConfEMISCKE /EBEEP_IGNORE\|EPAUSE_IGNORE\|CHECKREQS_ACTION\|BREAKME\|ECHANGELOG_USER\|CCACHE_SIZE\|CCACHE_DIR\|DISTCC_DIR/ contained nextgroup=GentooMakeConfEMISCE skipwhite

hi def link GentooMakeConfEMISC       Keyword
hi def link GentooMakeConfEMISCK      Identifier
hi def link GentooMakeConfEMISCN      Error
hi def link GentooMakeConfEMISCKE     Special
hi def link GentooMakeConfEMISCV      String
hi def link GentooMakeConfEMISCVNoQ   Constant
hi def link GentooMakeConfEMISCIB     Error
hi def link GentooMakeConfEMISCIX     Preproc
" }}}

" USE {{{
syn keyword GentooMakeConfEUse USE contained nextgroup=GentooMakeConfEUseE skipwhite
syn match   GentooMakeConfEUseE /=/ contained nextgroup=GentooMakeConfEUseV skipwhite
syn cluster GentooMakeConfEUseIC add=GentooMakeConfEUseID,GentooMakeConfEUseIE,GentooMakeConfEUseIG,GentooMakeConfEUseIB,GentooMakeConfEUseIX
syn region  GentooMakeConfEUseV contained start=/"/ end=/"/ contains=@GentooMakeConfEUseIC
syn match   GentooMakeConfEUseIE /[a-zA-Z0-9\-_]\+/ contained
syn match   GentooMakeConfEUseID /-[a-zA-Z0-9\-_]\+/ contained
syn match   GentooMakeConfEUseIG /-\?@[a-zA-Z0-9\-\_]\+\|-\*/ contained
syn match   GentooMakeConfEUseIB /+@\?[a-zA-Z0-9\-_]\+/ contained
syn match   GentooMakeConfEUseIX /\\.\|\$\({[^}]\+}\|[a-zA-Z0-9\-\_]\+\)/ contained

hi def link GentooMakeConfEUse       Identifier
hi def link GentooMakeConfEUseV      String
hi def link GentooMakeConfEUseID     Keyword
hi def link GentooMakeConfEUseIE     Special
hi def link GentooMakeConfEUseIG     Preproc
hi def link GentooMakeConfEUseIB     Error
hi def link GentooMakeConfEUseIX     Preproc
" }}}

" ACCEPT_KEYWORDS {{{
syn match   GentooMakeConfEAK /ACCEPT_KEYWORDS/ contained nextgroup=GentooMakeConfEAKE skipwhite
syn match   GentooMakeConfEAKE /=/ contained nextgroup=GentooMakeConfEAKV skipwhite
syn cluster GentooMakeConfEAKIC add=GentooMakeConfEAKIS,GentooMakeConfEAKIU,GentooMakeConfEAKIB,GentooMakeConfEAKIX
syn region  GentooMakeConfEAKV contained start=/"/ end=/"/ contains=@GentooMakeConfEAKIC
" do not change keyword order!
syn match   GentooMakeConfEAKIS /alpha\|amd64\|arm\|hppa\|ia64\|m68k\|mips\|ppc-macos\|ppc64\|ppc\|s390\|sh\|sparc\|x86-obsd\|x86-fbsd\|x86/ contained
syn match   GentooMakeConfEAKIU /\~\(alpha\|amd64\|arm\|hppa\|ia64\|m68k\|mips\|ppc-macos\|ppc64\|ppc\|s390\|sh\|sparc\|x86-obsd\|x86-fbsd\|x86\)/ contained
syn match   GentooMakeConfEAKIB /-[a-zA-Z0-9\-\_]\+/ contained
syn match   GentooMakeConfEAKIX /\\.\|\$\({[^}]\+}\|[a-zA-Z0-9\-\_]\+\)/ contained

hi def link GentooMakeConfEAK       Identifier
hi def link GentooMakeConfEAKV      String
hi def link GentooMakeConfEAKIS     Keyword
hi def link GentooMakeConfEAKIU     Special
hi def link GentooMakeConfEAKIB     Error
hi def link GentooMakeConfEAKIX     Preproc
" }}}

" C*FLAGS {{{
syn match   GentooMakeConfECFLAGS /C\(XX\)\?FLAGS/ contained nextgroup=GentooMakeConfECFLAGSE skipwhite
syn match   GentooMakeConfECFLAGSE /=/ contained nextgroup=GentooMakeConfECFLAGSV,GentooMakeConfECFLAGSVNoQ skipwhite
syn cluster GentooMakeConfECFLAGSIC add=GentooMakeConfECFLAGSIB1,GentooMakeConfECFLAGSIB2,GentooMakeConfECFLAGSIB3,GentooMakeConfECFLAGSIX
syn region  GentooMakeConfECFLAGSV contained start=/"/ end=/"/ contains=@GentooMakeConfECFLAGSIC
syn match   GentooMakeConfECFLAGSIB1 /-ffast-math\|-freduce-all-givs\|-mfpmath=sse,387\|-DNDEBUG\|-s\([a-zA-Z0-9\-\_]\)\@!\|-Wno\S\+\|x86.\?64\|-mvis/ contained
syn match   GentooMakeConfECFLAGSIB2 /-[0o][123s]/ contained
syn match   GentooMakeConfECFLAGSIB3 /\%(-Os\|-fPIC\|-fpic\|-DPIC\)\%(\(=\%(k8\|opteron\|athlon64\|athlon-fx\).*\)\@<=\|\(.*=\%(k8\|opteron\|athlon64\|athlon-fx\)\)\@=\)/
syn match   GentooMakeConfECFLAGSIX /\\.\|\$\({[^}]\+}\|[a-zA-Z0-9\-\_]\+\)/ contained
syn region  GentooMakeConfECFLAGSVNoQ contained start=/[^ "]/ end=/\s\|$/ contains=GentooMakeConfECFLAGSIX

hi def link GentooMakeConfECFLAGS       Identifier
hi def link GentooMakeConfECFLAGSV      String
hi def link GentooMakeConfECFLAGSVNoQ   Constant
hi def link GentooMakeConfECFLAGSIB1    Error
hi def link GentooMakeConfECFLAGSIB2    Error
hi def link GentooMakeConfECFLAGSIB3    Error
hi def link GentooMakeConfECFLAGSIX     Preproc
" }}}

" MAKEOPTS {{{
syn match   GentooMakeConfEMAKEOPTS /MAKEOPTS/ contained nextgroup=GentooMakeConfEMAKEOPTSE skipwhite
syn match   GentooMakeConfEMAKEOPTSE /=/ contained nextgroup=GentooMakeConfEMAKEOPTSV skipwhite
syn cluster GentooMakeConfEMAKEOPTSIC add=GentooMakeConfEMAKEOPTSIB
syn region  GentooMakeConfEMAKEOPTSV contained start=/"/ end=/"/ contains=@GentooMakeConfEMAKEOPTSIC
syn match   GentooMakeConfEMAKEOPTSIB /-j \+[0-9]\+/ contained

hi def link GentooMakeConfEMAKEOPTS       Identifier
hi def link GentooMakeConfEMAKEOPTSV      String
hi def link GentooMakeConfEMAKEOPTSIB     Error
" }}}

" CHOST {{{
syn match   GentooMakeConfECHOST /CHOST/ contained nextgroup=GentooMakeConfECHOSTE skipwhite
syn match   GentooMakeConfECHOSTE /=/ contained nextgroup=GentooMakeConfECHOSTV,GentooMakeConfECHOSTVNoQ skipwhite
syn cluster GentooMakeConfECHOSTIC add=GentooMakeConfECHOSTIB
syn region  GentooMakeConfECHOSTV contained start=/"/ end=/"/ contains=@GentooMakeConfECHOSTIC
syn match   GentooMakeConfECHOSTIB /sparc\(-unknown-linux-gnu\)\@![^ ]\+/ contained
syn region  GentooMakeConfECHOSTVNoQ contained start=/[^ "]/ end=/\s\|$/ contains=GentooMakeConfECFLAGSIX

hi def link GentooMakeConfECHOST       Identifier
hi def link GentooMakeConfECHOSTV      String
hi def link GentooMakeConfECHOSTVNoQ   String
hi def link GentooMakeConfECHOSTIB     Error
" }}}

" FEATURES {{{
syn keyword GentooMakeConfEFEATURES FEATURES contained nextgroup=GentooMakeConfEFEATURESE skipwhite
syn match   GentooMakeConfEFEATURESE /=/ contained nextgroup=GentooMakeConfEFEATURESV skipwhite
syn cluster GentooMakeConfEFEATURESIC add=GentooMakeConfEFEATURESID,GentooMakeConfEFEATURESIE,GentooMakeConfEFEATURESIB,GentooMakeConfEFEATURESIX
syn region  GentooMakeConfEFEATURESV contained start=/"/ end=/"/ contains=@GentooMakeConfEFEATURESIC
syn match   GentooMakeConfEFEATURESIE /[a-zA-Z0-9\-_]\+/ contained
syn match   GentooMakeConfEFEATURESID /-[a-zA-Z0-9\-_]\+/ contained
syn match   GentooMakeConfEFEATURESIB /+[a-zA-Z0-9\-_]\+/ contained
syn match   GentooMakeConfEFEATURESIX /\\.\|\$\({[^}]\+}\|[a-zA-Z0-9\-\_]\+\)/ contained

hi def link GentooMakeConfEFEATURES       Identifier
hi def link GentooMakeConfEFEATURESV      String
hi def link GentooMakeConfEFEATURESID     Keyword
hi def link GentooMakeConfEFEATURESIE     Special
hi def link GentooMakeConfEFEATURESIG     Preproc
hi def link GentooMakeConfEFEATURESIB     Error
hi def link GentooMakeConfEFEATURESIX     Preproc
" }}}

syn region  GentooMakeConfComment start=/#/ end=/$/ contains=GentooBug

hi def link GentooMakeConfComment    Comment


let b:current_syntax = "gentoo-make-conf"

" vim: set foldmethod=marker : "
