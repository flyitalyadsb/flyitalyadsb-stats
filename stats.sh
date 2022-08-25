#!/bin/bash
TMP=/tmp/graphs1090
if ! command -v git; then
    apt-get update
    apt-get install -y git
fi
rm -rf "$TMP"
set -e
git clone https://github.com/wiedehopf/graphs1090.git "$TMP"
echo "Installing Graphs1090"
cd "$TMP"
bash install.sh
TMP=/tmp/flyitalyadsb-stats-git
rm -rf "$TMP"
set -e
git clone https://github.com/flyitalyadsb/flyitalyadsb-stats.git "$TMP"
cd "$TMP"
echo "Installing Stats Package"
bash install.sh
