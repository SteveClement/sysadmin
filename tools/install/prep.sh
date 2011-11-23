#!/bin/sh
# run as root - ports tree needed
cd /usr/ports/ports-mgmt/portconf && make install clean
pkg_add -r git python gmake automake libtool
pkg_delete git-\*
pkg_delete \*-freebsd-doc-\*
pkg_add -r en-freebsd-doc fr-freebsd-doc de-freebsd-doc
# if this fails: portsnap fetch extract

mkdir /var/db/ports/python26
mkdir /var/db/ports/python27
mkdir /var/db/ports/libiconv
mkdir /var/db/ports/git

cat << EOF > /var/db/ports/python26/options
_OPTIONS_READ=python26-2.6.7_2
WITH_THREADS=true
WITHOUT_SEM=true
WITHOUT_PTH=true
WITH_UCS4=true
WITH_PYMALLOC=true
WITH_IPV6=true
WITHOUT_FPECTL=true
EOF

cat << EOF > /var/db/ports/python26/options
_OPTIONS_READ=python27-2.7.2_3
WITH_THREADS=true
WITHOUT_SEM=true
WITHOUT_PTH=true
WITH_UCS4=true
WITH_PYMALLOC=true
WITH_IPV6=true
WITHOUT_FPECTL=true
EOF

cat << EOF > /var/db/ports/libiconv/options
_OPTIONS_READ=libiconv-1.13.1_1
WITH_EXTRA_ENCODINGS=true
WITHOUT_EXTRA_PATCHES=true
EOF

cat << EOF > /var/db/ports/git/options
_OPTIONS_READ=git-1.7.7.2
WITHOUT_GUI=true
WITHOUT_SVN=true
WITHOUT_GITWEB=true
WITH_CONTRIB=true
WITH_P4=true
WITH_CVS=true
WITHOUT_HTMLDOCS=true
WITH_PERL=true
WITH_ICONV=true
WITH_CURL=true
WITH_ETCSHELLS=true
EOF

echo "devel/subversion: WITHOUT_MOD_DAV_SVN|WITHOUT_APACHE2_APR" >> /usr/local/etc/ports.conf
echo "devel/apr-svn: APR_UTIL_WITH_BERKELEY_DB=yes" >> /usr/local/etc/ports.conf
cd /usr/ports/devel/git && make install clean 
