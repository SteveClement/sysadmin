#!/bin/sh
# run as root - ports tree needed
cd /usr/ports/ports-mgmt/portconf && make install clean
pkg_add -r subversion python gmake automake19 libtool
pkg_delete subversion-\*
# if this fails: portsnap fetch extract

mkdir /var/db/ports/python26
mkdir /var/db/ports/libiconv
mkdir /var/db/ports/subversion

cat << EOF > /var/db/ports/python26/options
_OPTIONS_READ=python26-2.6.4
WITH_THREADS=true
WITHOUT_HUGE_STACK_SIZE=true
WITHOUT_SEM=true
WITHOUT_PTH=true
WITH_UCS4=true
WITH_PYMALLOC=true
WITH_IPV6=true
WITHOUT_FPECTL=true
EOF

cat << EOF > /var/db/ports/libiconv/options
_OPTIONS_READ=libiconv-1.11_1
WITH_EXTRA_ENCODINGS=true
WITHOUT_EXTRA_PATCHES=true
EOF

cat << EOF > /var/db/ports/subversion/options
_OPTIONS_READ=subversion-1.6.11_3
WITHOUT_MOD_DAV_SVN=true
WITHOUT_MOD_DONTDOTHAT=true
WITH_NEON=true
WITHOUT_SERF=true
WITHOUT_SASL=true
WITH_BDB=true
WITHOUT_ASVN=true
WITHOUT_MAINTAINER_DEBUG=true
WITHOUT_SVNSERVE_WRAPPER=true
WITHOUT_SVNAUTHZ_VALIDATE=true
WITHOUT_STATIC=true
WITHOUT_GNOME_KEYRING=true
WITHOUT_BOOK=true
EOF

echo "devel/subversion: WITHOUT_MOD_DAV_SVN|WITHOUT_APACHE2_APR" >> /usr/local/etc/ports.conf
echo "devel/apr-svn: APR_UTIL_WITH_BERKELEY_DB=yes" >> /usr/local/etc/ports.conf
cd /usr/ports/devel/subversion && make install clean 
