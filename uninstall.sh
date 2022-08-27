#!/bin/bash
set -x
IPATH=/usr/local/share/flyitalyadsb-stats/

systemctl disable --now flyitalyadsb-stats.service

rm -f /etc/systemd/system/flyitalyadsb-stats.service
rm -rf $IPATH

rm /usr/local/bin/flyitalyadsb-showurl

set +x

echo -----
echo "flyitalyadsb-stats have been uninstalled!"
