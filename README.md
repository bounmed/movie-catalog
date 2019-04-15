# Movie catalog

🎬 Browse through movies from the YIFY api

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

## Todo
* Catch errors and display them for u good user experience
* Add in torrents different types, like web and bluray option, 3d etc
* Look in reviews for features
* Add tests

## Building
To build the **free** version: 
```
flutter build apk --release --flavor free -t lib/main.dart
```

To build the **pro** version
```dart
flutter build apk --release --flavor pro -t lib/main_pro.dart
```

**Explanation:** The `flavor` option makes sure that in Android the `build.gradle` is using the right build flavors (including different applicationId).
The `target` option (-t) makes sure we can use the different flavors in the dart code.

## Play Store
### Free
[https://play.google.com/store/apps/details?id=com.devrnt.moviecatalog](https://play.google.com/store/apps/details?id=com.devrnt.moviecatalog)
### Pro
[https://play.google.com/store/apps/details?id=com.devrnt.moviecatalog.pro](https://play.google.com/store/apps/details?id=com.devrnt.moviecatalog.pro)
