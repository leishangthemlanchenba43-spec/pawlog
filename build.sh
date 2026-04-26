#!/bin/bash
set -e

PACKAGE_ID="com.lanchenba.pawlog"
APP_NAME="PawLog - Cat Care"
LAUNCHER_NAME="PawLog"
PWA_HOST="leishangthemlanchenba43-spec.github.io"
PWA_URL="https://leishangthemlanchenba43-spec.github.io/pawlog/"
MANIFEST_URL="https://leishangthemlanchenba43-spec.github.io/pawlog/manifest.json"
ICON_URL="https://leishangthemlanchenba43-spec.github.io/pawlog/icon-512.png"
KEYSTORE_PASSWORD="${KEYSTORE_PASSWORD:-PawLogPaw1234567}"
KEY_PASSWORD="${KEY_PASSWORD:-PawLogPaw1234567}"

mkdir -p ~/pawlog-build
cd ~/pawlog-build
echo "Working in: $(pwd)"

if [ -f "android.keystore" ]; then
  echo "Keystore exists, reusing."
elif [ -n "$KEYSTORE_BASE64" ]; then
  echo "Restoring keystore from env var..."
  echo "$KEYSTORE_BASE64" | base64 -d > android.keystore
else
  echo "Generating NEW keystore..."
  keytool -genkeypair \
    -keystore android.keystore -alias android \
    -keyalg RSA -keysize 2048 -validity 36500 \
    -storepass "$KEYSTORE_PASSWORD" -keypass "$KEY_PASSWORD" \
    -dname "CN=Lanchenba, OU=PawLog, O=PawLog, L=Imphal, ST=Manipur, C=IN"
  base64 -w 0 android.keystore > keystore.base64.txt
fi

if ! command -v bubblewrap &> /dev/null; then
  echo "Installing Bubblewrap..."
  npm install -g @bubblewrap/cli
fi

cat > twa-manifest.json <<EOF
{
  "packageId": "$PACKAGE_ID",
  "host": "$PWA_HOST",
  "name": "$APP_NAME",
  "launcherName": "$LAUNCHER_NAME",
  "display": "standalone",
  "themeColor": "#FF6B9D",
  "themeColorDark": "#1a1a1a",
  "navigationColor": "#FF6B9D",
  "navigationColorDark": "#1a1a1a",
  "navigationDividerColor": "#FF6B9D",
  "navigationDividerColorDark": "#1a1a1a",
  "backgroundColor": "#FFF5F8",
  "enableNotifications": true,
  "startUrl": "/pawlog/",
  "iconUrl": "$ICON_URL",
  "maskableIconUrl": "$ICON_URL",
  "monochromeIconUrl": null,
  "shortcuts": [],
  "generatorApp": "bubblewrap-cli",
  "webManifestUrl": "$MANIFEST_URL",
  "fallbackType": "customtabs",
  "features": {"locationDelegation": {"enabled": false}, "playBilling": {"enabled": false}},
  "alphaDependencies": {"enabled": false},
  "enableSiteSettingsShortcut": true,
  "isChromeOSOnly": false,
  "isMetaQuest": false,
  "fullScopeUrl": "$PWA_URL",
  "minSdkVersion": 23,
  "orientation": "default",
  "fingerprints": [],
  "additionalTrustedOrigins": [],
  "retainedBundles": [],
  "appVersionName": "1.0.0",
  "appVersion": 1,
  "signingKey": {"path": "$(pwd)/android.keystore", "alias": "android"}
}
EOF

echo "Running bubblewrap init..."
yes "n" | bubblewrap init --manifest "$MANIFEST_URL" --directory . --skipPwaValidation || true

# Re-write twa-manifest after init may have overwritten
cat > twa-manifest.json <<EOF
{
  "packageId": "$PACKAGE_ID",
  "host": "$PWA_HOST",
  "name": "$APP_NAME",
  "launcherName": "$LAUNCHER_NAME",
  "display": "standalone",
  "themeColor": "#FF6B9D",
  "themeColorDark": "#1a1a1a",
  "navigationColor": "#FF6B9D",
  "navigationColorDark": "#1a1a1a",
  "navigationDividerColor": "#FF6B9D",
  "navigationDividerColorDark": "#1a1a1a",
  "backgroundColor": "#FFF5F8",
  "enableNotifications": true,
  "startUrl": "/pawlog/",
  "iconUrl": "$ICON_URL",
  "maskableIconUrl": "$ICON_URL",
  "monochromeIconUrl": null,
  "shortcuts": [],
  "generatorApp": "bubblewrap-cli",
  "webManifestUrl": "$MANIFEST_URL",
  "fallbackType": "customtabs",
  "features": {"locationDelegation": {"enabled": false}, "playBilling": {"enabled": false}},
  "alphaDependencies": {"enabled": false},
  "enableSiteSettingsShortcut": true,
  "isChromeOSOnly": false,
  "isMetaQuest": false,
  "fullScopeUrl": "$PWA_URL",
  "minSdkVersion": 23,
  "orientation": "default",
  "fingerprints": [],
  "additionalTrustedOrigins": [],
  "retainedBundles": [],
  "appVersionName": "1.0.0",
  "appVersion": 1,
  "signingKey": {"path": "$(pwd)/android.keystore", "alias": "android"}
}
EOF

echo "Building AAB and APK..."
printf "%s\n%s\n" "$KEYSTORE_PASSWORD" "$KEY_PASSWORD" | bubblewrap build --skipPwaValidation --signingKeyPath ./android.keystore --signingKeyAlias android

SHA256=$(keytool -list -v -keystore android.keystore -alias android -storepass "$KEYSTORE_PASSWORD" 2>/dev/null | grep "SHA256:" | head -1 | awk '{print $2}')

cat > assetlinks.json <<EOF
[{"relation":["delegate_permission/common.handle_all_urls"],"target":{"namespace":"android_app","package_name":"$PACKAGE_ID","sha256_cert_fingerprints":["$SHA256"]}}]
EOF

echo ""
echo "==== BUILD COMPLETE ===="
ls -lah ~/pawlog-build/
echo "SHA-256: $SHA256"
