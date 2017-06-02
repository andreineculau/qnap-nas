#!/usr/bin/env bash
set -euo pipefail

DIR=$(dirname $(readlink -f "$0"))
source ${DIR}/vars.sh

test -n "${STORAGE}"
test -n "${TC_IP}"
test -n "${TC_PASS}"

# ------------------------------------------------------------------------------

cat <<EOF >> ~/.profile
source ${DIR}/.profile
EOF

source ${DIR}/.profile

mkdir -p ${STORAGE}/.qpkg/autorun
ln -s ${DIR}/autorun.sh ${STORAGE}/.qpkg/autorun/autorun.sh

cat <<EOF >> /etc/config/qpkg.conf
[autorun]
Name = autorun
Version = 0.1
Author = neomilium
Date = 2001-01-01
Shell = ${STORAGE}/.qpkg/autorun/autorun.sh
Install_Path = ${STORAGE}/.qpkg/autorun
Enable = TRUE
EOF

# ------------------------------------------------------------------------------

cat ${DIR}/list.txt
cat ${DIR}/list.club.txt
read

# ------------------------------------------------------------------------------

test -f "/opt/Entware-ng.sh" || {
    cat <<EOF >&2
Install entware from store.qnapclub.eu, or manually:
$$ wget -O - http://pkg.entware.net/binaries/x86-64/installer/entware_install.sh | sh
EOF
    exit 1
}

opkg update
pkgs=(
    bash
    coreutils
    curl
    diffutils
    ffmpeg
    findutils
    git
    grep
    htop
    iftop
    iotop
    less
    mc
    mediainfo
    node
    python
    progress
    pv
    sed
    time
    unzip
    wget
    zile
)
for pkg in ${pkgs[*]}; do
    opkg list-installed | grep -q "^${pkg} -" || opkg install ${pkg}
done
