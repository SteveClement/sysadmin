#!/bin/sh
# run as root - ports tree needed
portsnap fetch extract
cd /usr/ports/ports-mgmt/portconf && make install clean
pkg install git python gmake automake14 libtool
pkg delete git-\*

mkdir /var/db/ports/lang_python27
mkdir /var/db/ports/devel_git
mkdir /var/db/ports/lang_perl5.18
mkdir /var/db/ports/ftp_curl
mkdir /var/db/ports/security_ca_root_nss
mkdir /var/db/ports/textproc_xmlto
mkdir /var/db/ports/shells_bash
mkdir /var/db/ports/devel_bison
mkdir /var/db/ports/devel_m4
mkdir /var/db/ports/devel_gettext-tools
mkdir /var/db/ports/misc_getopt
mkdir /var/db/ports/devel_gmake
mkdir /var/db/ports/security_libgcrypt
mkdir /var/db/ports/devel_libatomic
mkdir /var/db/ports/devel_libffi
mkdir /var/db/ports/security_p5-IO-Socket-SSL
mkdir /var/db/ports/security_p5-Net-SSLeay
mkdir /var/db/ports/security_p5-Authen-SASL
mkdir /var/db/ports/devel_cvsps
mkdir /var/db/ports/devel_boehm-gc
mkdir /var/db/ports/textproc_libxml2
mkdir /var/db/ports/textproc_libxslt
mkdir /var/db/ports/textproc_docbook-xsl
mkdir /var/db/ports/textproc_xmlcatmgr
mkdir /var/db/ports/security_libgpg-error
mkdir /var/db/ports/www_w3m
mkdir /var/db/ports/devel_libatomic_ops


cat << EOF >_OPTIONS_READ=libatomic_ops-7.4.0_1
_FILE_COMPLETE_OPTIONS_LIST=DOCS
OPTIONS_FILE_SET+=DOCS
EOF

cat << EOF > /var/db/ports/devel_m4/options
_OPTIONS_READ=m4-1.4.17_1,1
_FILE_COMPLETE_OPTIONS_LIST=EXAMPLES LIBSIGSEGV
OPTIONS_FILE_SET+=EXAMPLES
OPTIONS_FILE_UNSET+=LIBSIGSEGV
EOF

cat << EOF > /var/db/ports/devel_gettext-tools/options
_OPTIONS_READ=gettext-tools-0.19.3
_FILE_COMPLETE_OPTIONS_LIST=DOCS
OPTIONS_FILE_SET+=DOCS
EOF

cat << EOF > /var/db/ports/misc_getopt/options
_OPTIONS_READ=getopt-1.1.6
_FILE_COMPLETE_OPTIONS_LIST=DOCS NLS
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_SET+=NLS
EOF

cat << EOF > /var/db/ports/devel_gmake/options
_OPTIONS_READ=gmake-4.1_1
_FILE_COMPLETE_OPTIONS_LIST=NLS
OPTIONS_FILE_SET+=NLS
EOF

cat << EOF > /var/db/ports/security_libgcrypt/options
_OPTIONS_READ=libgcrypt-1.6.security_libgcrypt
_FILE_COMPLETE_OPTIONS_LIST=DOCS
OPTIONS_FILE_SET+=DOCS
EOF

cat << EOF > /var/db/ports/devel_libatomic/options
_OPTIONS_READ=libatomic_ops-7.4.0_1
_FILE_COMPLETE_OPTIONS_LIST=DOCS
OPTIONS_FILE_SET+=DOCS
EOF

cat << EOF > /var/db/ports/devel_libffi/options
_OPTIONS_READ=libffi-3.0.13_3
_FILE_COMPLETE_OPTIONS_LIST=TESTS
OPTIONS_FILE_UNSET+=TESTS
EOF

cat << EOF > /var/db/ports/security_p5-IO-Socket-SSL/options
_OPTIONS_READ=p5-IO-Socket-SSL-2.007
_FILE_COMPLETE_OPTIONS_LIST=EXAMPLES IDN IPV6
OPTIONS_FILE_SET+=EXAMPLES
OPTIONS_FILE_UNSET+=IDN
OPTIONS_FILE_SET+=IPV6
EOF

cat << EOF > /var/db/ports/security_p5-Net-SSLeay/options
_OPTIONS_READ=p5-Net-SSLeay-1.66_1
_FILE_COMPLETE_OPTIONS_LIST=EXAMPLES
OPTIONS_FILE_SET+=EXAMPLES
EOF

cat << EOF > /var/db/ports/security_p5-Authen-SASL/options
_OPTIONS_READ=p5-Authen-SASL-2.16_1
_FILE_COMPLETE_OPTIONS_LIST=KERBEROS
OPTIONS_FILE_SET+=KERBEROS
EOF

cat << EOF > /var/db/ports/devel_cvsps/options
_OPTIONS_READ=cvsps-2.1_1
_FILE_COMPLETE_OPTIONS_LIST=DOCS
OPTIONS_FILE_SET+=DOCS
EOF

cat << EOF > /var/db/ports/devel_boehm-gc/options
_OPTIONS_READ=boehm-gc-7.4.2_3
_FILE_COMPLETE_OPTIONS_LIST=DEBUG DOCS
OPTIONS_FILE_UNSET+=DEBUG
OPTIONS_FILE_SET+=DOCS
EOF

cat << EOF > /var/db/ports/www_w3m/options
_OPTIONS_READ=w3m-0.5.3_4
_FILE_COMPLETE_OPTIONS_LIST=DOCS INLINE_IMAGE JAPANESE KEY_LYNX
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_UNSET+=INLINE_IMAGE
OPTIONS_FILE_UNSET+=JAPANESE
OPTIONS_FILE_UNSET+=KEY_LYNX
EOF

cat << EOF > /var/db/ports/textproc_xmlcatmgr/options
_OPTIONS_READ=xmlcatmgr-2.2_2
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
_OPTIONS_READ=libgpg-error-1.17
_FILE_COMPLETE_OPTIONS_LIST=DOCS NLS
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_SET+=NLS
EOF

cat << EOF > /var/db/ports/textproc_libxslt/options
_OPTIONS_READ=libxslt-1.1.28_5
_FILE_COMPLETE_OPTIONS_LIST=CRYPTO MEM_DEBUG
OPTIONS_FILE_SET+=CRYPTO
OPTIONS_FILE_UNSET+=MEM_DEBUG
EOF

cat << EOF > /var/db/ports/textproc_libxml2/options
_OPTIONS_READ=libxml2-2.9.2_2
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
_OPTIONS_READ=bash-4.3.30_1
_FILE_COMPLETE_OPTIONS_LIST=COLONBREAKSWORDS DOCS HELP IMPLICITCD IMPORTFUNCTIONS NLS STATIC SYSLOG
OPTIONS_FILE_SET+=COLONBREAKSWORDS
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_SET+=HELP
OPTIONS_FILE_SET+=IMPLICITCD
OPTIONS_FILE_UNSET+=IMPORTFUNCTIONS
OPTIONS_FILE_SET+=NLS
OPTIONS_FILE_UNSET+=STATIC
OPTIONS_FILE_UNSET+=SYSLOG
EOF

cat << EOF > /var/db/ports/textproc_xmlto/options
_OPTIONS_READ=xmlto-0.0.26_2
_FILE_COMPLETE_OPTIONS_LIST=DOCS DBLATEX FOP PASSIVETEX
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_UNSET+=DBLATEX
OPTIONS_FILE_UNSET+=FOP
OPTIONS_FILE_UNSET+=PASSIVETEX
EOF

cat << EOF > /var/db/ports/lang_python27/options
_OPTIONS_READ=python27-2.7.9
_FILE_COMPLETE_OPTIONS_LIST=DEBUG IPV6 LIBFFI NLS PYMALLOC SEM THREADS UCS2 UCS4
OPTIONS_FILE_UNSET+=DEBUG
OPTIONS_FILE_SET+=IPV6
OPTIONS_FILE_SET+=LIBFFI
OPTIONS_FILE_SET+=NLS
OPTIONS_FILE_SET+=PYMALLOC
OPTIONS_FILE_SET+=SEM
OPTIONS_FILE_SET+=THREADS
OPTIONS_FILE_UNSET+=UCS2
OPTIONS_FILE_SET+=UCS4
EOF

cat << EOF > /var/db/ports/devel_git/options
_OPTIONS_READ=git-2.2.1
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

cat << EOF > /var/db/ports/lang_perl5.18/options
_OPTIONS_READ=perl5-5.18.4_11
_FILE_COMPLETE_OPTIONS_LIST=DEBUG GDBM MULTIPLICITY PERL_64BITINT PTHREAD SITECUSTOMIZE USE_PERL THREADS PERL_MALLOC
OPTIONS_FILE_UNSET+=DEBUG
OPTIONS_FILE_UNSET+=GDBM
OPTIONS_FILE_SET+=MULTIPLICITY
OPTIONS_FILE_SET+=PERL_64BITINT
OPTIONS_FILE_SET+=PTHREAD
OPTIONS_FILE_UNSET+=SITECUSTOMIZE
OPTIONS_FILE_SET+=USE_PERL
OPTIONS_FILE_SET+=THREADS
OPTIONS_FILE_UNSET+=PERL_MALLOC
EOF

cat << EOF > /var/db/ports/ftp_curl/options
_OPTIONS_READ=curl-7.39.0_1
_FILE_COMPLETE_OPTIONS_LIST=CA_BUNDLE COOKIES CURL_DEBUG DEBUG DOCS EXAMPLES HTTP2 IDN IPV6 LDAP LDAPS LIBSSH2 PROXY RTMP TLS_SRP GSSAPI_BASE HEIMDAL_PORT KRB5_PORT CARES THREADED_RESOLVER CYASSL GNUTLS NSS OPENSSL POLARSSL
OPTIONS_FILE_SET+=CA_BUNDLE
OPTIONS_FILE_SET+=COOKIES
OPTIONS_FILE_UNSET+=CURL_DEBUG
OPTIONS_FILE_UNSET+=DEBUG
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_SET+=EXAMPLES
OPTIONS_FILE_UNSET+=HTTP2
OPTIONS_FILE_UNSET+=IDN
OPTIONS_FILE_SET+=IPV6
OPTIONS_FILE_UNSET+=LDAP
OPTIONS_FILE_UNSET+=LDAPS
OPTIONS_FILE_UNSET+=LIBSSH2
OPTIONS_FILE_SET+=PROXY
OPTIONS_FILE_UNSET+=RTMP
OPTIONS_FILE_SET+=TLS_SRP
OPTIONS_FILE_SET+=GSSAPI_BASE
OPTIONS_FILE_UNSET+=HEIMDAL_PORT
OPTIONS_FILE_UNSET+=KRB5_PORT
OPTIONS_FILE_UNSET+=CARES
OPTIONS_FILE_SET+=THREADED_RESOLVER
OPTIONS_FILE_UNSET+=CYASSL
OPTIONS_FILE_UNSET+=GNUTLS
OPTIONS_FILE_UNSET+=NSS
OPTIONS_FILE_SET+=OPENSSL
OPTIONS_FILE_UNSET+=POLARSSL
EOF

cat << EOF > /var/db/ports/security_ca_root_nss/options
_OPTIONS_READ=ca_root_nss-3.17.3_1
_FILE_COMPLETE_OPTIONS_LIST=ETCSYMLINK
OPTIONS_FILE_UNSET+=ETCSYMLINK
EOF


cd /usr/ports/devel/git && make install clean