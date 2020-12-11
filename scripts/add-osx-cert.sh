#!/usr/bin/env sh

KEY_CHAIN=build.keychain
CERTIFICATE_P12=certificate.p12

echo "Recreate the certificate from the secure environment variable"
echo $CERTIFICATE_OSX_P12 | base64 --decode > $CERTIFICATE_P12

echo "security create-keychain"
security create-keychain -p jenkins $KEY_CHAIN
echo "security list-keychains"
# security list-keychains -s login.keychain build.keychain
security list-keychains -s build.keychain
echo "security default-keychain"
security default-keychain -s $KEY_CHAIN
echo "security unlock-keychain"
security unlock-keychain -p jenkins $KEY_CHAIN
echo "security import"
security import $CERTIFICATE_P12 -k $KEY_CHAIN -P "" -T /usr/bin/codesign;
echo "security find-identity"
security find-identity -v
echo "security set-key-partition-list"
security set-key-partition-list -S apple-tool:,apple:,codesign:, -s -k jenkins $KEY_CHAIN

# Remove certs
rm -fr *.p12
