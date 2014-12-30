#!/bin/sh
# run as root - ports tree needed
cd /usr/ports/ports-mgmt/portconf && make install clean
pkg install git python gmake automake14 libtool
pkg delete git-\*
##pkg_delete \*-freebsd-doc-\*
##pkg_add -r en-freebsd-doc fr-freebsd-doc de-freebsd-doc
# if this fails: portsnap fetch extract

mkdir /var/db/ports/python27
mkdir /var/db/ports/libiconv
mkdir /var/db/ports/git
mkdir /var/db/ports/lang_perl5.16
mkdir /var/db/ports/curl
mkdir /var/db/ports/ca_root_nss
mkdir /var/db/ports/pcre

mkdir /var/db/ports/textproc_xmlto
mkdir /var/db/ports/shells_bash
mkdir /var/db/ports/devel_bison
mkdir /var/db/ports/devel_boehm-gc
mkdir /var/db/ports/textproc_libxml2
mkdir /var/db/ports/textproc_libxslt
mkdir /var/db/ports/textproc_docbook-xsl
mkdir /var/db/ports/textproc_xmlcatmgr
mkdir /var/db/ports/security_libgpg-error
mkdir /var/db/ports/www_w3m

cat << EOF > /var/db/ports/devel_boehm-gc/options
_OPTIONS_READ=boehm-gc-7.2e
_FILE_COMPLETE_OPTIONS_LIST=DEBUG DOCS
OPTIONS_FILE_UNSET+=DEBUG
OPTIONS_FILE_SET+=DOCS
EOF

cat << EOF > /var/db/ports/www_w3m/options
_OPTIONS_READ=w3m-0.5.3_2
_FILE_COMPLETE_OPTIONS_LIST=DOCS INLINE_IMAGE JAPANESE KEY_LYNX
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_UNSET+=INLINE_IMAGE
OPTIONS_FILE_UNSET+=JAPANESE
OPTIONS_FILE_UNSET+=KEY_LYNX
EOF

cat << EOF > /var/db/ports/textproc_xmlcatmgr/options
_OPTIONS_READ=xmlcatmgr-2.2
_FILE_COMPLETE_OPTIONS_LIST=DOCS
OPTIONS_FILE_SET+=DOCS
EOF

cat << EOF > /var/db/ports/textproc_docbook-xsl/options
_OPTIONS_READ=docbook-xsl-1.76.1_2
_FILE_COMPLETE_OPTIONS_LIST=DOCS ECLIPSE EPUB EXTENSIONS HIGHLIGHTING HTMLHELP JAVAHELP PROFILING ROUNDTRIP SLIDES TEMPLATE TESTS TOOLS WEBSITE XHTML11
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_SET+=ECLIPSE
OPTIONS_FILE_SET+=EPUB
OPTIONS_FILE_SET+=EXTENSIONS
OPTIONS_FILE_SET+=HIGHLIGHTING
OPTIONS_FILE_SET+=HTMLHELP
OPTIONS_FILE_SET+=JAVAHELP
OPTIONS_FILE_SET+=PROFILING
OPTIONS_FILE_SET+=ROUNDTRIP
OPTIONS_FILE_SET+=SLIDES
OPTIONS_FILE_SET+=TEMPLATE
OPTIONS_FILE_SET+=TESTS
OPTIONS_FILE_SET+=TOOLS
OPTIONS_FILE_SET+=WEBSITE
OPTIONS_FILE_SET+=XHTML11
EOF

cat << EOF > /var/db/ports/security_libgpg-error/options
_OPTIONS_READ=libgpg-error-1.12
_FILE_COMPLETE_OPTIONS_LIST=DOCS NLS
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_SET+=NLS
EOF

cat << EOF > /var/db/ports/textproc_libxslt/options
_OPTIONS_READ=libxslt-1.1.28_1
_FILE_COMPLETE_OPTIONS_LIST=CRYPTO MEM_DEBUG
OPTIONS_FILE_SET+=CRYPTO
OPTIONS_FILE_UNSET+=MEM_DEBUG
EOF

cat << EOF > /var/db/ports/textproc_libxml2/options
_OPTIONS_READ=libxml2-2.8.0_3
_FILE_COMPLETE_OPTIONS_LIST=MEM_DEBUG SCHEMA THREADS THREAD_ALLOC XMLLINT_HIST
OPTIONS_FILE_UNSET+=MEM_DEBUG
OPTIONS_FILE_SET+=SCHEMA
OPTIONS_FILE_SET+=THREADS
OPTIONS_FILE_UNSET+=THREAD_ALLOC
OPTIONS_FILE_UNSET+=XMLLINT_HIST
EOF

cat << EOF > /var/db/ports/devel_bison/options
_OPTIONS_READ=bison-2.7.1,1
_FILE_COMPLETE_OPTIONS_LIST=EXAMPLES NLS
OPTIONS_FILE_SET+=EXAMPLES
OPTIONS_FILE_SET+=NLS
EOF

cat << EOF > /var/db/ports/shells_bash/options
_OPTIONS_READ=bash-4.3.0_1
_FILE_COMPLETE_OPTIONS_LIST=COLONBREAKSWORDS DOCS HELP IMPLICITCD NLS STATIC SYSLOG
OPTIONS_FILE_SET+=COLONBREAKSWORDS
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_SET+=HELP
OPTIONS_FILE_SET+=IMPLICITCD
OPTIONS_FILE_SET+=NLS
OPTIONS_FILE_UNSET+=STATIC
OPTIONS_FILE_UNSET+=SYSLOG
EOF

cat << EOF > /var/db/ports/textproc_xmlto/options
_OPTIONS_READ=xmlto-0.0.25_2
_FILE_COMPLETE_OPTIONS_LIST= DBLATEX FOP PASSIVETEX
OPTIONS_FILE_UNSET+=DBLATEX
OPTIONS_FILE_UNSET+=FOP
OPTIONS_FILE_UNSET+=PASSIVETEX
EOF

cat << EOF > /var/db/ports/python27/options
_OPTIONS_READ=python27-2.7.3_6
_FILE_COMPLETE_OPTIONS_LIST=EXAMPLES FPECTL IPV6 NLS PTH PYMALLOC SEM THREADS UCS2 UCS4
OPTIONS_FILE_SET+=EXAMPLES
OPTIONS_FILE_UNSET+=FPECTL
OPTIONS_FILE_SET+=IPV6
OPTIONS_FILE_SET+=NLS
OPTIONS_FILE_UNSET+=PTH
OPTIONS_FILE_SET+=PYMALLOC
OPTIONS_FILE_UNSET+=SEM
OPTIONS_FILE_SET+=THREADS
OPTIONS_FILE_UNSET+=UCS2
OPTIONS_FILE_SET+=UCS4
EOF

cat << EOF > /var/db/ports/libiconv/options
_OPTIONS_READ=libiconv-1.14
_FILE_COMPLETE_OPTIONS_LIST=ENCODINGS PATCHES
OPTIONS_FILE_SET+=ENCODINGS
OPTIONS_FILE_UNSET+=PATCHES
EOF

cat << EOF > /var/db/ports/git/options
_OPTIONS_READ=git-1.8.1.1
_FILE_COMPLETE_OPTIONS_LIST=CONTRIB CURL CVS ETCSHELLS GITWEB GUI HTMLDOCS ICONV NLS P4 PERL SVN
OPTIONS_FILE_SET+=CONTRIB
OPTIONS_FILE_SET+=CURL
OPTIONS_FILE_SET+=CVS
OPTIONS_FILE_SET+=ETCSHELLS
OPTIONS_FILE_UNSET+=GITWEB
OPTIONS_FILE_UNSET+=GUI
OPTIONS_FILE_UNSET+=HTMLDOCS
OPTIONS_FILE_SET+=ICONV
OPTIONS_FILE_SET+=NLS
OPTIONS_FILE_SET+=P4
OPTIONS_FILE_SET+=PERL
OPTIONS_FILE_UNSET+=SVN
EOF

cat << EOF > /var/db/ports/lang_perl5.16/options
_FILE_COMPLETE_OPTIONS_LIST=DEBUG GDBM MULTIPLICITY PERL_64BITINT PERL_MALLOC PTHREAD SITECUSTOMIZE THREADS USE_PERL
OPTIONS_FILE_UNSET+=DEBUG
OPTIONS_FILE_UNSET+=GDBM
OPTIONS_FILE_UNSET+=MULTIPLICITY
OPTIONS_FILE_SET+=PERL_64BITINT
OPTIONS_FILE_UNSET+=PERL_MALLOC
OPTIONS_FILE_SET+=PTHREAD
OPTIONS_FILE_UNSET+=SITECUSTOMIZE
OPTIONS_FILE_UNSET+=THREADS
OPTIONS_FILE_SET+=USE_PERL
EOF

cat << EOF > /var/db/ports/curl/options
_OPTIONS_READ=curl-7.24.0
_FILE_COMPLETE_OPTIONS_LIST= CARES CURL_DEBUG GNUTLS IPV6 KERBEROS4 LDAP LDAPS LIBIDN LIBSSH2 NTLM OPENSSL CA_BUNDLE PROXY RTMP TRACKMEMORY
OPTIONS_FILE_UNSET+=CARES
OPTIONS_FILE_UNSET+=CURL_DEBUG
OPTIONS_FILE_UNSET+=GNUTLS
OPTIONS_FILE_SET+=IPV6
OPTIONS_FILE_UNSET+=KERBEROS4
OPTIONS_FILE_UNSET+=LDAP
OPTIONS_FILE_UNSET+=LDAPS
OPTIONS_FILE_SET+=LIBIDN
OPTIONS_FILE_UNSET+=LIBSSH2
OPTIONS_FILE_UNSET+=NTLM
OPTIONS_FILE_SET+=OPENSSL
OPTIONS_FILE_SET+=CA_BUNDLE
OPTIONS_FILE_SET+=PROXY
OPTIONS_FILE_UNSET+=RTMP
OPTIONS_FILE_UNSET+=TRACKMEMORY
EOF

cat << EOF > /var/db/ports/ca_root_nss/options
_OPTIONS_READ=ca_root_nss-3.14.1
_FILE_COMPLETE_OPTIONS_LIST=ETCSYMLINK
OPTIONS_FILE_UNSET+=ETCSYMLINK
EOF

cat << EOF > /var/db/ports/pcre/options
_OPTIONS_READ=pcre-8.31
_FILE_COMPLETE_OPTIONS_LIST=JIT
OPTIONS_FILE_SET+=JIT
EOF


echo "devel/subversion: WITHOUT_MOD_DAV_SVN|WITHOUT_APACHE2_APR" >> /usr/local/etc/ports.conf
echo "devel/apr-svn: APR_UTIL_WITH_BERKELEY_DB=yes" >> /usr/local/etc/ports.conf

cd /usr/ports/devel/git && make install clean 
