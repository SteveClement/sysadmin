#!/bin/sh
# run as root - ports tree needed
portsnap fetch extract
cd /usr/ports/ports-mgmt/portconf && make install clean
pkg install git python gmake automake libtool
pkg delete git-\*

# The following are needed for bootstrap of git
mkdir /var/db/ports/devel_bison
mkdir /var/db/ports/devel_boehm-gc
mkdir /var/db/ports/devel_gettext-tools
mkdir /var/db/ports/devel_git
mkdir /var/db/ports/devel_libatomic_ops
mkdir /var/db/ports/misc_getopt
mkdir /var/db/ports/misc_help2man
mkdir /var/db/ports/print_texinfo
mkdir /var/db/ports/security_libgcrypt
mkdir /var/db/ports/security_libgpg-error
mkdir /var/db/ports/shells_bash
mkdir /var/db/ports/textproc_docbook-xsl
mkdir /var/db/ports/textproc_libxml2
mkdir /var/db/ports/textproc_libxslt
mkdir /var/db/ports/textproc_xmlcatmgr
mkdir /var/db/ports/textproc_xmlto
mkdir /var/db/ports/www_w3m

## Update 1
cat << EOF > /var/db/ports/devel_git/options
_OPTIONS_READ=git-2.11.0_3
_FILE_COMPLETE_OPTIONS_LIST=CONTRIB CURL CVS GITWEB GUI HTMLDOCS ICONV NLS P4 PCRE PERL SEND_EMAIL SUBTREE SVN
OPTIONS_FILE_SET+=CONTRIB
OPTIONS_FILE_SET+=CURL
OPTIONS_FILE_SET+=CVS
OPTIONS_FILE_UNSET+=GITWEB
OPTIONS_FILE_UNSET+=GUI
OPTIONS_FILE_UNSET+=HTMLDOCS
OPTIONS_FILE_SET+=ICONV
OPTIONS_FILE_SET+=NLS
OPTIONS_FILE_SET+=P4
OPTIONS_FILE_SET+=PCRE
OPTIONS_FILE_SET+=PERL
OPTIONS_FILE_SET+=SEND_EMAIL
OPTIONS_FILE_SET+=SUBTREE
OPTIONS_FILE_UNSET+=SVN
EOF

## Update 2
cat << EOF > /var/db/ports/textproc_xmlto/options
_OPTIONS_READ=xmlto-0.0.28
_FILE_COMPLETE_OPTIONS_LIST=DOCS DBLATEX FOP PASSIVETEX
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_UNSET+=DBLATEX
OPTIONS_FILE_UNSET+=FOP
OPTIONS_FILE_UNSET+=PASSIVETEX
EOF

## Update 3
cat << EOF > /var/db/ports/shells_bash/options
_OPTIONS_READ=bash-4.4.5
_FILE_COMPLETE_OPTIONS_LIST=COLONBREAKSWORDS DOCS HELP NLS STATIC SYSLOG
OPTIONS_FILE_SET+=COLONBREAKSWORDS
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_SET+=HELP
OPTIONS_FILE_SET+=NLS
OPTIONS_FILE_UNSET+=STATIC
OPTIONS_FILE_UNSET+=SYSLOG
EOF

# Update 4
cat << EOF > /var/db/ports/devel_bison/options
_OPTIONS_READ=bison-2.7.1,1
_FILE_COMPLETE_OPTIONS_LIST=EXAMPLES NLS
OPTIONS_FILE_SET+=EXAMPLES
OPTIONS_FILE_SET+=NLS
EOF

# Update 5
cat << EOF > /var/db/ports/devel_gettext-tools/options
_OPTIONS_READ=gettext-tools-0.19.8.1
_FILE_COMPLETE_OPTIONS_LIST=DOCS THREADS
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_SET+=THREADS
EOF

# Update 6
cat << EOF > /var/db/ports/misc_getopt/options
_OPTIONS_READ=getopt-1.1.6
_FILE_COMPLETE_OPTIONS_LIST=DOCS NLS
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_SET+=NLS
EOF

# Update 7
cat << EOF > /var/db/ports/misc_help2man/options
_OPTIONS_READ=help2man-1.47.4
_FILE_COMPLETE_OPTIONS_LIST=NLS
OPTIONS_FILE_SET+=NLS
EOF

# Update 8
cat << EOF > /var/db/ports/textproc_libxml2/options
_OPTIONS_READ=libxml2-2.9.4
_FILE_COMPLETE_OPTIONS_LIST=MEM_DEBUG SCHEMA THREADS THREAD_ALLOC VALID XMLLINT_HIST
OPTIONS_FILE_UNSET+=MEM_DEBUG
OPTIONS_FILE_SET+=SCHEMA
OPTIONS_FILE_SET+=THREADS
OPTIONS_FILE_UNSET+=THREAD_ALLOC
OPTIONS_FILE_SET+=VALID
OPTIONS_FILE_UNSET+=XMLLINT_HIST
EOF

# Update 9
cat << EOF > /var/db/ports/textproc_libxslt/options
_OPTIONS_READ=libxslt-1.1.29
_FILE_COMPLETE_OPTIONS_LIST=CRYPTO MEM_DEBUG
OPTIONS_FILE_SET+=CRYPTO
OPTIONS_FILE_UNSET+=MEM_DEBUG
EOF

# Update 10
cat << EOF > /var/db/ports/security_libgcrypt/options
_OPTIONS_READ=libgcrypt-1.7.3
_FILE_COMPLETE_OPTIONS_LIST=DOCS
OPTIONS_FILE_SET+=DOCS
EOF

# Update 11
cat << EOF > /var/db/ports/security_libgpg-error/options
_OPTIONS_READ=libgpg-error-1.25
_FILE_COMPLETE_OPTIONS_LIST=DOCS NLS
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_SET+=NLS
EOF

# Update 12
cat << EOF > /var/db/ports/textproc_docbook-xsl/options
_OPTIONS_READ=docbook-xsl-1.76.1_3
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

# Update 13
cat << EOF > /var/db/ports/textproc_xmlcatmgr/options
_OPTIONS_READ=xmlcatmgr-2.2_2
_FILE_COMPLETE_OPTIONS_LIST=DOCS
OPTIONS_FILE_SET+=DOCS
EOF

# Update 14
cat << EOF > /var/db/ports/www_w3m/options
_OPTIONS_READ=w3m-0.5.3_6
_FILE_COMPLETE_OPTIONS_LIST=DOCS INLINE_IMAGE JAPANESE KEY_LYNX
OPTIONS_FILE_SET+=DOCS
OPTIONS_FILE_UNSET+=INLINE_IMAGE
OPTIONS_FILE_UNSET+=JAPANESE
OPTIONS_FILE_UNSET+=KEY_LYNX
EOF

# Update 15
cat << EOF > /var/db/ports/devel_boehm-gc/options
_OPTIONS_READ=boehm-gc-7.6.0
_FILE_COMPLETE_OPTIONS_LIST=DEBUG DOCS
OPTIONS_FILE_UNSET+=DEBUG
OPTIONS_FILE_SET+=DOCS
EOF

# Update 16
cat << EOF > /var/db/ports/print_texinfo/options
_OPTIONS_READ=texinfo-6.1.20160425,1
_FILE_COMPLETE_OPTIONS_LIST=NLS
OPTIONS_FILE_SET+=NLS
EOF

# Update 17
cat << EOF > /var/db/ports/devel_libatomic_ops/options
_OPTIONS_READ=libatomic_ops-7.4.4
_FILE_COMPLETE_OPTIONS_LIST=DOCS
OPTIONS_FILE_SET+=DOCS
EOF

echo "devel/subversion: WITHOUT_MOD_DAV_SVN|WITHOUT_APACHE2_APR" >> /usr/local/etc/ports.conf
echo "devel/apr-svn: APR_UTIL_WITH_BERKELEY_DB=yes" >> /usr/local/etc/ports.conf

cd /usr/ports/devel/git && make install clean
