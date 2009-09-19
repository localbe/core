#!/bin/sh
[ "$BASH" ] || exec bash $0 "$@"
#
# $Id$
#

# ---------------------------------------------------------------
# Copyright 2003 Przemyslaw Czerpak <druzus@polbox.com>
# simple script to build binaries .tgz from Harbour sources
#
# See COPYING for licensing terms.
# ---------------------------------------------------------------

cd `dirname $0`
. bin/hb-func.sh

name="harbour"
hb_ver=`get_hbver`
hb_verstat=`get_hbverstat`
hb_platform=`get_hbplatform`
[ "${hb_verstat}" = "" ] || hb_ver="${hb_ver}-${hb_verstat}"
[ "${hb_platform}" = "" ] || hb_platform="-${hb_platform}${HB_BUILDSUF}"
[ "${HB_XBUILD}" = "" ] || hb_platform="-${HB_XBUILD}"
hb_archfile="${name}-${hb_ver}${hb_platform}.bin.tar.gz"
# disabled self extracting shell envelop
hb_instfile="${name}-${hb_ver}${hb_platform}.inst.sh"
hb_pref="hb"
hb_sysdir="yes"

[ -z "$HB_INSTALL_PREFIX" ] && [ -n "$PREFIX" ] && export HB_INSTALL_PREFIX="$PREFIX"

if [ -z "$TMPDIR" ]; then TMPDIR="/tmp"; fi
HB_INST_PREF="$TMPDIR/$name.bin.$USER.$$"

if [ -z "$HB_PLATFORM" ]; then
    if [ "$OSTYPE" = "msdosdjgpp" ]; then
        hb_plat="dos"
    else
        hb_plat=`uname -s | tr -d "[-]" | tr '[A-Z]' '[a-z]' 2>/dev/null`
        case "$hb_plat" in
            *windows*|*mingw32*|msys*) hb_plat="win" ;;
            *os/2*)                    hb_plat="os2" ;;
            *dos)                      hb_plat="dos" ;;
            *bsd)                      hb_plat="bsd" ;;
        esac
    fi
    export HB_PLATFORM="$hb_plat"
fi

ETC="/etc"

# Select the platform-specific installation prefix and ownership
HB_INSTALL_OWNER=root
case "$HB_PLATFORM" in
    darwin)
        [ -z "$HB_INSTALL_PREFIX" ] && HB_INSTALL_PREFIX="/usr/local"
        HB_INSTALL_GROUP=wheel
        ETC="/private/etc"
        ;;
    linux)
        [ -z "$HB_INSTALL_PREFIX" ] && HB_INSTALL_PREFIX="/usr"
        HB_INSTALL_GROUP=root
        ;;
    sunos)
        [ -z "$HB_INSTALL_PREFIX" ] && HB_INSTALL_PREFIX="/usr"
        HB_INSTALL_GROUP=root
        ;;
    win)
        [ -z "$HB_INSTALL_PREFIX" ] && HB_INSTALL_PREFIX="/usr/local"
        HB_INSTALL_GROUP=0
        hb_sysdir="no"
        hb_instfile=""
        ;;
    dos)
        [ -z "$HB_INSTALL_PREFIX" ] && HB_INSTALL_PREFIX="/${name}"
        HB_INSTALL_GROUP=root
        hb_sysdir="no"
        hb_instfile=""
        hb_archfile="${name}.tgz"
        HB_INST_PREF="$TMPDIR/hb-$$"
        ;;
    *)
        [ -z "$HB_INSTALL_PREFIX" ] && HB_INSTALL_PREFIX="/usr/local"
        HB_INSTALL_GROUP=wheel
        ;;
esac

# Select the platform-specific command names
MAKE=make
TAR=tar
hb_gnutar=yes
if gtar --version >/dev/null 2>&1; then
   TAR=gtar
elif ! tar --version >/dev/null 2>&1; then
   hb_gnutar=no
   echo "Warning!!! Cannot find GNU TAR"
fi
if gmake --version >/dev/null 2>&1; then
   MAKE=gmake
elif ! make --version >/dev/null 2>&1; then
   echo "Warning!!! Cannot find GNU MAKE"
fi

# build
umask 022
$MAKE clean
$MAKE
# install
rm -fR "${HB_INST_PREF}"
$MAKE -i install

if [ "${hb_sysdir}" = "yes" ]; then

    mkdir -p $HB_INST_PREF$ETC/harbour
    cp -f source/rtl/gtcrs/hb-charmap.def $HB_INST_PREF$ETC/harbour/hb-charmap.def
    chmod 644 $HB_INST_PREF$ETC/harbour/hb-charmap.def

    cat > $HB_INST_PREF$ETC/harbour.cfg <<EOF
CC=${HB_CCPREFIX}gcc
CFLAGS=-c -I$_DEFAULT_INC_DIR
VERBOSE=YES
DELTMP=YES
EOF

fi

CURDIR=$(pwd)
if [ $hb_gnutar = yes ]; then
    (cd "${HB_INST_PREF}"; $TAR czvf "${CURDIR}/${hb_archfile}" --owner=${HB_INSTALL_OWNER} --group=${HB_INSTALL_GROUP} .)
    UNTAR_OPT=xvpf
else
    (cd "${HB_INST_PREF}"; $TAR covf - . | gzip > "${CURDIR}/${hb_archfile}")
    UNTAR_OPT=xvf
fi
rm -fR "${HB_INST_PREF}"

if [ -n "${hb_instfile}" ]; then

   if [ "${HB_PLATFORM}" = linux ]; then
      DO_LDCONFIG="&& ldconfig"
   else
      DO_LDCONFIG=""
   fi
   # In the generated script use tar instead of $TAR because we can't be sure
   # if $TAR exists in the installation environment
   size=`wc -c "${hb_archfile}"|(read size file; echo $size)`
   cat > "${hb_instfile}" <<EOF
#!/bin/sh
[ "\$BASH" ] || exec bash \`which \$0\` \${1+"\$@"}
if [ "\$1" = "--extract" ]; then
    tail -c $size "\$0" > "${hb_archfile}"
    exit
fi
if [ \`id -u\` != 0 ]; then
    echo "This package has to be installed from root account."
    exit 1
fi
echo "Do you want to install ${name} (y/n)"
read ASK
if [ "\${ASK}" != "y" ] && [ "\${ASK}" != "Y" ]; then
    exit 1
fi
(tail -c $size "\$0" | gzip -cd | (cd /;tar ${UNTAR_OPT} -)) ${DO_LDCONFIG}
exit \$?
HB_INST_EOF
EOF
    cat "${hb_archfile}" >> "${hb_instfile}"
    chmod +x "${hb_instfile}"
    rm -f "${hb_archfile}"

fi
