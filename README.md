# 🐾 PawLog — Cat Care Tracker

> A beautiful, offline-first Progressive Web App (PWA) for tracking your cat's health, feeding, and daily care — installable on Android via the Play Store.

![License](https://img.shields.io/badge/license-MIT-pink) ![Platform](https://img.shields.io/badge/platform-Android%20%7C%20Web-blue) ![Status](https://img.shields.io/badge/status-active-brightgreen)

## ✨ Features

- 🍽️ Feeding tracker with time logging
- 💊 Medication & vet appointment reminders
- ⚖️ Weight & health milestone tracking
- 📸 Cat profile with photo support
- 🌙 Dark mode support
- 📶 Fully offline-capable (PWA + Service Worker)
- 📱 Installable on Android (TWA via Play Store)

## 🚀 Live App

👉 [Open PawLog](https://leishangthemlanchenba43-spec.github.io/pawlog/)

## 📲 Android Build

This repo uses **Bubblewrap** (via Docker) + GitHub Actions to build a signed AAB/APK for Play Store submission.

### Prerequisites
- Add these GitHub Secrets to your repo:
  - `KEYSTORE_PASSWORD`
  - `KEY_PASSWORD`
  - `KEYSTORE_BASE64` (after first run)

### First-time build
1. Go to **Actions → Build PawLog Android (TWA)**
2. Set `regenerate_keystore` to `true`
3. Download the `keystore-base64-SAVE-AS-SECRET` artifact
4. Save its contents as the `KEYSTORE_BASE64` secret
5. Re-run with `regenerate_keystore = false` for all future builds

### Subsequent builds
- Just trigger the workflow — AAB and APK are uploaded as artifacts (90-day retention)

## 🔗 Digital Asset Links

After your first build, download the `assetlinks-and-fingerprint` artifact and host `assetlinks.json` at:
```
https://leishangthemlanchenba43-spec.github.io/.well-known/assetlinks.json
```

## 🛠️ Tech Stack

| Layer | Tech |
|---|---|
| Frontend | Vanilla HTML/CSS/JS |
| PWA | Web App Manifest + Service Worker |
| Android | Trusted Web Activity (TWA) via Bubblewrap |
| CI/CD | GitHub Actions + Docker |
| Hosting | GitHub Pages |

## 📁 Project Structure

```
pawlog/
├── index.html          # Main app (single file)
├── manifest.json       # PWA manifest
├── twa-manifest.json   # Bubblewrap TWA config
├── sw.js               # Service worker
├── icon-192.png        # App icon
├── icon-512.png        # App icon (large)
└── .github/
    └── workflows/
        └── build-apk.yml  # CI/CD pipeline
```

## 👨‍💻 Author

Built by [@leishangthemlanchenba43-spec](https://github.com/leishangthemlanchenba43-spec)

---

*Made with ❤️ for cat lovers everywhere*
