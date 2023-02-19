#!/bin/sh

set -e

PREV_DIR=$(pwd)
PACK_DIR=$(dirname -- "$0")
cd "$PACK_DIR"

TARGET="../Fugu15/Fugu15/bootstrap/basebin.tar"

if [ -d "basebin.tar" ]; then
	rm -rf "basebin.tar"
fi

if [ -d ".tmp/basebin" ]; then
	rm -rf ".tmp/basebin"
fi
mkdir -p ".tmp/basebin"

# jailbreakd

cd "jailbreakd"
make
cd -
cp "./jailbreakd/jailbreakd" ".tmp/basebin/jailbreakd"
cp "./jailbreakd/daemon.plist" ".tmp/basebin/jailbreakd.plist"

# kickstart

cd "kickstart"
make
cd -
cp "./kickstart/kickstart" ".tmp/basebin/kickstart"

# Create TrustCache, for basebinaries
trustcache create "./.tmp/basebin/basebin.tc" "./.tmp/basebin"

# Tar /tmp to basebin.tar
cd ".tmp"
# only works with procursus tar for whatever reason
DYLD_FALLBACK_LIBRARY_PATH=".." ../tar -cvf "../$TARGET" "./basebin" --owner=0 --group=0 
cd -

rm -rf ".tmp"

cd "$PREV_DIR"