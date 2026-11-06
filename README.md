# 🏡 HomeLove

**HomeLove** – Ứng dụng kết nối và chia sẻ những khoảnh khắc dành cho các cặp đôi.

## 1. Requirements

Cài đặt các công cụ cần thiết:

- Flutter SDK
- Dart SDK
- Android Studio
- Visual Studio Code
- Git

Kiểm tra môi trường:

```bash
flutter doctor
```

## 2. Clone Project

```bash
git clone https://github.com/HUBT-Innovation-Tech/home_love_app.git

cd home_love_app
```

Cài đặt dependencies:

```bash
flutter pub get
```

## 3. Firebase Configuration

Cài đặt FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

Đăng nhập Firebase:

```bash
firebase login
```

Cấu hình Firebase cho từng môi trường:

**Development:**

```bash
flutterfire configure --project=home-love-dev --platforms=android --out=lib/src/core/firebase/firebase_options_dev.dart
```

**Production:**

```bash
flutterfire configure --project=home-love-prod --platforms=android --out=lib/src/core/firebase/firebase_options_prod.dart
```

Đặt các file cấu hình Firebase tương ứng vào:

```text
lib/src/core/firebase/
├── firebase_options_dev.dart
└── firebase_options_prod.dart
```

Đồng thời thêm `google-services.json` tương ứng vào thư mục Android flavor:

```text
android/app/src/
├── development/google-services.json
└── production/google-services.json
```

## 4. Generate Hive Adapters

Sau khi cài đặt dependencies, chạy:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 5. Dependency Injection

Generate các file Dependency Injection:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 6. Run Application

Chạy môi trường Development:

```bash
flutter run --flavor development --dart-define=ENV=development
```

Chạy môi trường Production:

```bash
flutter run --flavor production --dart-define=ENV=production
```

## 7. Build APK

**Development:**

```bash
flutter build apk --flavor development --dart-define=ENV=development
```

**Production:**

```bash
flutter build apk --release --flavor production --dart-define=ENV=production
```

## 8. Troubleshooting

Nếu gặp lỗi trong quá trình cài đặt:

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Kiểm tra lại cấu hình Firebase, Flutter SDK và Android SDK nếu ứng dụng không thể khởi chạy.
