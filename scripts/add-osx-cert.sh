#!/usr/bin/env sh

KEY_CHAIN=build.keychain
CERTIFICATE_P12=certificate.p12

# Recreate the certificate from the secure environment variable
echo $CERTIFICATE_OSX_P12 | base64 --decode > $CERTIFICATE_P12

security create-keychain -p travis $KEY_CHAIN
security list-keychains -s login.keychain build.keychain
security default-keychain -s $KEY_CHAIN
security unlock-keychain -p travis $KEY_CHAIN
security import $CERTIFICATE_P12 -k $KEY_CHAIN -P "" -T /usr/bin/codesign;
security find-identity -v
security set-key-partition-list -S apple-tool:,apple:,codesign:, -s -k travis $KEY_CHAIN

# Remove certs
rm -fr *.p12
