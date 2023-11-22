## **Flutter Version**

Flutter 3.13.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision ead455963c (8 weeks ago) • 2023-09-26 18:28:17 -0700
Engine • revision a794cf2681
Tools • Dart 3.1.3 • DevTools 2.25.0

---

## **Run & Build**

#### **Run:**

```
flutter run --flavor=production
flutter run --flavor=staging
```

#### **Build APK:**

```
flutter build apk --split-per-abi --release --flavor=production
flutter build apk --split-per-abi --release --flavor=staging

---

## **Icon & Splash Screen**
#### __Generate New App Icon:__
```sh
dart run flutter_launcher_icons
```

#### __Generate New Splash Screen:__
```sh
dart run flutter_native_splash:create
```

---

• Filter movies by genres.
• Sort movies by latest release date.
• Show movie details (movie name, release date, overview, trailers, etc)
• View pager to show movie poster (vertical scroll direction)