#!/bin/bash

set -euo pipefail

# The script is called with a base64 encoded JSON string as argument and the path to the framework to sign

if [ $# -lt 2 ]; then
    echo "Usage: `basename $0` <base64 encoded JSON> <framework>"
    exit 1
fi

# Read p12 certificate from secret
# The secret containing the p12 certificate is a base64 encoded of the following JSON:
# {
#   "p12": "base64 encoded p12 certificate",
#   "password": "password",
#   "identity": "identity" # The name of the certificate in the keychain
# }
json=$(echo $1 | base64 --decode | jq -r)

CERTIFICATE=$(echo $json | jq -r '.p12')
CERTIFICATE_PASSWORD=$(echo $json | jq -r '.password')
SIGNING_IDENTITY=$(echo $json | jq -r '.identity')

CERTIFICATE_PATH="/tmp/certificate.p12"
KEYCHAIN_NAME="ios-build.keychain"

# Setup temporary keychain
echo $CERTIFICATE | base64 --decode -o $CERTIFICATE_PATH

security create-keychain -p temp $KEYCHAIN_NAME
security unlock -p temp $KEYCHAIN_NAME
security import $CERTIFICATE_PATH -k $KEYCHAIN_NAME -P $CERTIFICATE_PASSWORD -T /usr/bin/codesign
security set-key-partition-list -S apple-tool:,apple: -s -k temp $KEYCHAIN_NAME
security list-keychains -d user -s $KEYCHAIN_NAME

# Sign the framework
codesign --timestamp -s "$SIGNING_IDENTITY" "$2"

# Delete the temporary keychain
security delete-keychain $KEYCHAIN_NAME
rm -f $CERTIFICATE_PATH
