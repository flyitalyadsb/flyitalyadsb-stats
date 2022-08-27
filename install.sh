#!/bin/bash

IPATH=/usr/local/share/flyitalyadsb-stats/
set -e

mkdir -p $IPATH

if ! id -u flyitalyadsb &>/dev/null
then
    adduser --system --home $IPATH --no-create-home --quiet flyitalyadsb >/dev/null || adduser --system --home-dir $IPATH --no-create-home flyitalyadsb
fi

function aptInstall() {
    if ! apt install -y --no-install-recommends --no-install-suggests "$@"; then
        apt update
        if ! apt install -y --no-install-recommends --no-install-suggests "$@"; then
            apt clean -y || true
            apt --fix-broken install -y || true
            apt install --no-install-recommends --no-install-suggests -y $packages
        fi
    fi
}

# commands used
COMMANDS="curl jq gzip host perl"
# corresponding packages
PACKAGES="curl jq gzip bind9-host perl bash-builtins"

install=0
if ! [[ -f /usr/lib/bash/sleep ]];
then
    install=1
fi
for CMD in $COMMANDS; do
    if ! command -v $CMD &>/dev/null; then
    install=1
    fi
done
if [[ $install == 1 ]]; then
    if command -v apt-get &>/dev/null; then
        aptInstall $PACKAGES || true
    elif command -v yum &>/dev/null; then
        yum install -y curl util-linux jq inotify-tools gzip bind-utils perl || true
    fi
fi

mkdir -p /usr/local/bin
chmod 755 flyitalyadsb-showurl
cp flyitalyadsb-showurl /usr/local/bin/flyitalyadsb-showurl

hash -r

cp json-status $IPATH
cp create-uuid.sh $IPATH
chmod +x $IPATH/json-status
chmod +x $IPATH/create-uuid.sh
cp uninstall.sh $IPATH

if [ -f /boot/flyitalyadsb-config.txt ] && ! [ -d /run/flyitalyadsb-feed ] && ! [ -f /etc/default/flyitalyadsb-stats ]
then
    echo "USE_OLD_PATH=1" > /etc/default/flyitalyadsb-stats
fi

# copy the service file
cp flyitalyadsb-stats.service /etc/systemd/system/flyitalyadsb-stats.service

# add flyitalyadsb user to video group for vcgencmd get_throttled if the system has that command and it works:
if vcgencmd get_throttled &>/dev/null; then
    adduser flyitalyadsb video
fi

# enable service
systemctl enable flyitalyadsb-stats.service


# exit success for chroot
if ischroot; then
    exit 0
fi

bash $IPATH/create-uuid.sh

# start service
systemctl restart flyitalyadsb-stats.service

# output uuid
echo "#####################################"
UUID_FILE="/boot/flyitalyadsb-uuid"
if ! [[ -f "$UUID_FILE" ]]; then
    UUID_FILE="/usr/local/share/flyitalyadsb/flyitalyadsb-uuid"
fi
source /etc/default/flyitalyadsb
SED=$(echo "$a" |sed -e 's$^$https://statistiche.flyitalyadsb.com/login?uuid=$' "$UUID_FILE")
cat "$UUID_FILE"
echo "#####################################"
echo $SED"&user="$UTENTE
echo "#####################################"
