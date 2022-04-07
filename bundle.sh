#!/bin/sh

SKIP_INSTALL=0

KEY_STORE_PASS=rolix0416
KEY_PASS=rolix0416
AAB_PATH=./build/app/outputs/bundle/release/app-release.aab
APKS_PATH=./app.apks
KEY_STORE_PATH=./android/key.jks
KEY_ALIAS=key

# remove apks
rm $APKS_PATH

# generate apks
bundletool build-apks \
--bundle=${AAB_PATH} \
--output=${APKS_PATH} \
--ks=${KEY_STORE_PATH} \
--ks-pass=pass:${KEY_STORE_PASS} \
--ks-key-alias=${KEY_ALIAS} \
--key-pass=pass:${KEY_PASS}

# install device
bundletool install-apks --apks=${APKS_PATH}
