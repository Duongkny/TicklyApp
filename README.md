# Tickly — Ứng dụng quản lý công việc cá nhân

> Hướng dẫn dành cho thành viên mới: cài đặt môi trường, cấu hình Firebase, tạo mã nguồn tự động (Injectable / Hive CE), chạy và đóng gói ứng dụng Flutter trên Android.

## 1. Giới thiệu

**Tickly** là ứng dụng quản lý công việc cá nhân xây dựng bằng **Flutter**, **Firebase** và **Clean Architecture + BLoC**.

Các chức năng hiện có theo phạm vi dự án:

- **Tài khoản:** đăng ký (họ tên, email, mật khẩu), đăng nhập email/Google, xác minh email, quên mật khẩu, giữ phiên đăng nhập và đăng xuất.
- **Công việc:** tạo/xem/sửa/xóa, đánh dấu hoàn thành, mô tả, mức ưu tiên, danh mục, hạn hoàn thành, nhắc nhở.
- **Khám phá công việc:** tìm kiếm, lọc theo thời gian/danh mục, sắp xếp.
- **Danh mục:** tạo, đổi tên, chọn màu, xóa, xem công việc theo danh mục.
- **Calendar:** lịch tháng/tuần, chọn ngày, đánh dấu ngày có công việc.
- **Reminder:** thông báo Android, xin quyền, đặt/cập nhật/hủy lịch và kiểm tra thông báo thử nghiệm.
- **Statistics:** tổng quan công việc, tỷ lệ hoàn thành, biểu đồ 7/30 ngày và phân bố danh mục.
- **Cài đặt:** thông tin tài khoản, theme sáng/tối/hệ thống, ngôn ngữ Việt/Anh, tùy chọn ứng dụng.

### Công nghệ chính

| Thành phần | Công nghệ |
| --- | --- |
| Mobile | Flutter / Dart |
| State management | `flutter_bloc` |
| Architecture | Clean Architecture: `data` / `domain` / `presentation` |
| Dependency injection | `get_it` + `injectable` + `injectable_generator` |
| Backend / Auth | Firebase Authentication |
| Cloud database | Cloud Firestore |
| Dữ liệu và tùy chọn cục bộ | Hive CE (`hive_ce`, `hive_ce_flutter`) |
| Routing | `go_router` |
| Thông báo | `flutter_local_notifications`, `timezone`, `flutter_timezone`; dự án còn có `awesome_notifications` / `firebase_messaging` |
| Crash / Analytics | Firebase Crashlytics / Analytics |
| Android build | Gradle Kotlin DSL, JDK 17, flavors `development` / `production` |

## 2. Yêu cầu trước khi chạy

- Windows 10/11, VS Code (hoặc Android Studio).
- Flutter SDK tương thích với ràng buộc Dart trong `pubspec.yaml` (ở snapshot đã cung cấp: Dart `^3.12.2`). **Kiểm tra Flutter/Dart thực tế trước khi chạy**.
- Android SDK, Android SDK Command-line Tools, Android Platform Tools (`adb`), giấy phép Android SDK đã chấp nhận.
- **JDK 17** cho cấu hình Android hiện tại của dự án.
- Thiết bị Android bật *USB debugging* hoặc Android Emulator.
- Quyền truy cập Firebase project tương ứng nếu cần tạo/tải lại cấu hình.
- Kết nối Internet khi tải packages và sử dụng dịch vụ Firebase.

Kiểm tra môi trường bằng PowerShell:

```powershell
flutter --version
dart --version
flutter doctor -v
flutter doctor --android-licenses
adb devices
```

Nếu `flutter doctor` báo thiếu SDK, cmdline-tools hoặc licenses, hãy xử lý trước khi build.

## 3. Clone dự án và cài dependencies

```powershell
git clone <REPOSITORY_URL>
cd <THU_MUC_DU_AN>
flutter pub get
```

> Thay `<REPOSITORY_URL>` bằng repo chính thức của nhóm. Chạy toàn bộ lệnh từ thư mục có `pubspec.yaml`.

Để kiểm tra dependencies đã được nhận:

```powershell
flutter pub deps
flutter analyze
```

**Không** chạy `flutter pub upgrade --major-versions` chỉ để setup ban đầu: việc nâng major có thể phá tính tương thích với mã nguồn hiện tại.

## 4. Môi trường Development và Production

Dự án có hai Android flavors:

| Flavor | Tên dự kiến | Application ID | Mục đích |
| --- | --- | --- | --- |
| `development` | Tickly Dev | `com.tickly.app.dev` | Phát triển/kiểm thử |
| `production` | Tickly | `com.tickly.app` | Bản chính thức |

Các ID trên phản ánh cấu hình đã thảo luận; hãy đối chiếu **`android/app/build.gradle.kts`** của repo hiện tại. Không tự đổi `applicationId` sau khi đã đăng ký Firebase mà chưa cập nhật Firebase Android app.

### File môi trường `.env`

`pubspec.yaml` đang khai báo:

```yaml
flutter:
  generate: true
  uses-material-design: true
  assets:
    - .env.development
    - .env.production
```

Nếu clone repo không có các file `.env.*` (do `.gitignore`), hãy yêu cầu người quản lý cung cấp giá trị cấu hình hợp lệ, hoặc tạo chúng từ `.env.example` nếu repo có mẫu.

Mẫu **chỉ để minh họa** (tên khóa dựa trên `Environment` từng sử dụng, hãy đối chiếu mã nguồn):

```dotenv
# .env.development
API_URL=<DEVELOPMENT_API_URL_IF_USED>
IV_UTF8=<VALUE_IF_REQUIRED_BY_PROJECT>
```

```dotenv
# .env.production
API_URL=<PRODUCTION_API_URL_IF_USED>
IV_UTF8=<VALUE_IF_REQUIRED_BY_PROJECT>
```

**Cảnh báo quan trọng:** Nếu `Environment.initialize()` chọn `.env.production` bằng `kReleaseMode`, thì `flutter build apk --release --flavor development` cũng có thể tải `.env.production`. **Flavor và build mode là hai khái niệm khác nhau.** Trước khi phát hành, kiểm tra lại logic chọn `.env` trong mã nguồn và xác nhận ứng dụng đang kết nối đúng môi trường. Không giả định `--flavor` tự chuyển file `.env`.

Không commit mật khẩu, private key, service-account JSON hoặc các secret thực sự lên Git. `flutter_dotenv` đóng gói các file `.env` vào ứng dụng; vì vậy các giá trị trong đó **không được xem là bí mật an toàn trên client**.

## 5. Cấu hình Firebase (bắt buộc)

Tickly sử dụng các Firebase projects riêng cho từng môi trường. Theo cấu hình đã trao đổi trước đây:

- Development: **`tickly-dev-da871`**.
- Production: **`tickly-prod`**.

Kiểm tra tên/ID thực tế tại [Firebase Console](https://console.firebase.google.com/).

### 5.1 Cài Firebase CLI và FlutterFire CLI

Cài Firebase CLI theo [hướng dẫn chính thức](https://firebase.google.com/docs/cli) (cần Node.js nếu cài qua npm), sau đó:

```powershell
firebase --version
firebase login
dart pub global activate flutterfire_cli
flutterfire --version
```

Nếu PowerShell báo `flutterfire` không được nhận diện, thêm Pub Cache `bin` vào PATH của Windows (thường là `%LOCALAPPDATA%\Pub\Cache\bin`), mở Terminal mới rồi thử lại.

### 5.2 Kết nối Firebase Android theo flavor

Vào Firebase Console → chọn project → **Project settings → Your apps**. Mỗi project phải có Android app khớp với `applicationId`:

- Development: `com.tickly.app.dev`.
- Production: `com.tickly.app`.

Tải `google-services.json` tương ứng, đặt tại:

```text
android/app/src/
├── development/
│   └── google-services.json  # Firebase Development
└── production/
    └── google-services.json  # Firebase Production
```

**Không hoán đổi hai file**. Kiểm tra trường `package_name` trong `google-services.json` khớp với `applicationId` của flavor.

Nếu repo dùng FlutterFire options riêng, có thể tạo hoặc cập nhật bằng CLI:

```powershell
flutterfire configure --project=tickly-dev-da871 --platforms=android --android-package-name=com.tickly.app.dev --out=lib/src/core/firebase/firebase_options_dev.dart
flutterfire configure --project=tickly-prod --platforms=android --android-package-name=com.tickly.app --out=lib/src/core/firebase/firebase_options_prod.dart
```

> **Chỉ chạy khi cần tạo/cập nhật config**, và kiểm tra cú pháp CLI bằng `flutterfire configure --help` vì CLI có thể thay đổi. CLI có thể điều chỉnh Gradle/Android config; hãy xem `git diff` sau khi chạy để bảo đảm không làm lệch các flavor. Đường dẫn `lib/src/core/firebase/...` là gợi ý, cần khớp import thực tế trong repo.

Trong ứng dụng, Firebase phải được khởi tạo **trước `runApp()`**, dùng Firebase options đúng flavor (hoặc cấu hình native Android đã xác minh đúng). Ví dụ nguyên lý:

```dart
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: selectedFirebaseOptions, // Chọn đúng development / production
);
runApp(const App());
```

Đây là minh họa, **không dán nguyên** nếu `main.dart` đã khởi tạo Firebase. Cần bảo đảm không gọi `Firebase.initializeApp()` trùng lặp hoặc chọn nhầm project.

### 5.3 Bật các dịch vụ Firebase

Trong Firebase Console cho **từng project**:

1. **Authentication → Sign-in method**: bật Email/Password và Google nếu ứng dụng sử dụng.
2. **Firestore Database**: tạo database, chọn region phù hợp, triển khai **Security Rules của dự án** (không sử dụng `allow read, write: if true`).
3. **Analytics / Crashlytics**: kiểm tra cấu hình nếu dự án bật hai dịch vụ này.
4. **Cloud Messaging**: kiểm tra khi tính năng FCM được sử dụng. Nhắc việc cục bộ bằng `flutter_local_notifications` không yêu cầu FCM cho từng lịch Task.

Với Google Sign-In trên Android, cần đăng ký SHA-1/SHA-256 của certificate tương ứng (debug hoặc release), rồi cập nhật cấu hình Firebase khi cần. Có thể xem debug SHA bằng:

```powershell
cd android
.\gradlew.bat signingReport
cd ..
```

**Giữ an toàn keystore release và mật khẩu**. Không chia sẻ service-account private key.

### 5.4 Firestore collections và Rules

Cấu trúc dữ liệu chính:

```text
users/{uid}/
├── tasks/{taskId}
│   ├── userId, title, description, categoryId
│   ├── priority, status
│   ├── dueDate, reminderAt, completedAt
│   └── createdAt, updatedAt
└── categories/{categoryId}
    ├── userId, name, colorValue
    └── createdAt, updatedAt
```

`dueDate`, `reminderAt` và `completedAt` có thể `null`; các mốc thời gian sử dụng Firestore `Timestamp`. Khi thêm trường mới vào `TaskModel.toFirestore()`, phải kiểm tra Rules `hasOnly([...])`: từng có lỗi `PERMISSION_DENIED` vì thiếu `completedAt` trong danh sách trường cho phép.

Sau khi sửa Rules, nhấn **Publish** và kiểm thử tạo/sửa/xóa dưới tài khoản đã xác minh email. Đối với dữ liệu thử nghiệm, thao tác thực hiện trên project Development.

## 6. Generate Dependency Injection — GetIt + Injectable

Tickly sử dụng:

- `get_it`: container quản lý dependency.
- `injectable`: annotation như `@injectable`, `@lazySingleton`, `@module`.
- `injectable_generator` + `build_runner`: tạo file cấu hình đăng ký dependency.

**Sau khi clone repo hoặc thay đổi các annotation**, chạy từ thư mục gốc:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Nếu đang lập trình liên tục và muốn theo dõi thay đổi:

```powershell
dart run build_runner watch --delete-conflicting-outputs
```

Các file thường gặp (tên thực tế tùy mã nguồn):

```text
lib/src/core/injections/
├── injections.dart
├── injections.config.dart   # file generate — không tự viết tay
└── ...                      # register module / providers
```

Kiểm tra `main.dart` đã gọi hàm khởi tạo DI thực tế của dự án **trước khi dùng `getIt<T>()`**. Tên hàm có thể là `configureDependencies()`, `initDependencies()` hoặc tên khác: hãy tìm trong `injections.dart`, không đoán.

Nếu gặp `GetIt: Object/factory with type ... is not registered`:

1. Kiểm tra class có annotation đúng.
2. Kiểm tra `@module` cung cấp `FirebaseAuth`, `FirebaseFirestore`, Hive hoặc các service bắt buộc.
3. Chạy lại `build_runner`.
4. Đảm bảo hàm khởi tạo DI đã chạy trước khi tạo BLoC/router.

## 7. Generate Hive CE và khởi tạo dữ liệu cục bộ

Dependencies đang dùng:

```yaml
dependencies:
  hive_ce: ...
  hive_ce_flutter: ...
dev_dependencies:
  hive_ce_generator: ...
  build_runner: ...
```

Tickly dùng Hive CE cho dữ liệu hoặc tùy chọn ứng dụng lưu trên thiết bị. **Không lưu Firebase ID token/refresh token dưới dạng plain text trong Hive**; Firebase SDK tự quản lý phiên đăng nhập trên Android/iOS.

### 7.1 Chạy code generation

Nếu dự án có các class sử dụng adapter của Hive CE, dùng cùng lệnh generator:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Ví dụ file được tạo (chỉ khi dự án có cấu hình tương ứng):

```text
hive/
├── hive_adapters.dart
└── hive_adapters.g.dart
```

Hoặc `.g.dart` nằm cạnh model. **Không tự tạo các file `.g.dart`**; hãy kiểm tra comment `part` và annotation trong mã nguồn.

### 7.2 Khởi tạo Hive trước khi sử dụng

Mã minh họa:

```dart
WidgetsFlutterBinding.ensureInitialized();
await Hive.initFlutter();
// Đăng ký adapter được generate, nếu cấu trúc dự án yêu cầu.
// Mở các box mà ứng dụng cần trước khi truy cập.
```

Chỉ áp dụng nếu dự án chưa khởi tạo Hive ở `main.dart`/bootstrap. Không đăng ký adapter hai lần. Tên box, đường dẫn lưu và cách khởi tạo adapters phải dựa vào code thực tế, không cần tạo box mới chỉ để chạy chương trình.

## 8. Localization — Tiếng Việt / Tiếng Anh

Kiểm tra `l10n.yaml` (nếu repo có) và:

```yaml
flutter:
  generate: true
```

Sinh lại localization:

```powershell
flutter gen-l10n
```

Nếu xuất hiện lỗi về `generate: true`, kiểm tra vị trí khóa `generate` trong `pubspec.yaml`: nó phải nằm **bên dưới `flutter:`**, không phải khóa cấp cao nhất.

## 9. Chạy ứng dụng Android

**Lần đầu chạy**, thứ tự khuyến nghị:

```powershell
flutter doctor -v
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter devices
flutter run --flavor development -t lib/main.dart
```

Nếu có nhiều thiết bị, chọn ID từ `flutter devices`:

```powershell
flutter run --flavor development -t lib/main.dart -d <DEVICE_ID>
```

Chạy production trên thiết bị (chỉ khi Firebase Production đã cấu hình và được phép kiểm thử):

```powershell
flutter run --flavor production -t lib/main.dart
```

### Kiểm tra sau khi chạy

- Đăng ký/đăng nhập, Google Sign-In, xác minh email, đăng xuất.
- Tạo Task, sửa, xóa, đánh dấu hoàn thành.
- Firestore ghi đúng `createdAt`, `updatedAt`, `completedAt`.
- Category, Calendar, Statistics cập nhật theo Task.
- Reminder: xin quyền, đặt lịch, sửa/hủy lịch, thử khi app chạy nền.
- Theme Light/Dark/System và VI/EN được lưu sau khi mở lại app.

Lưu ý: Android có thể trì hoãn thông báo dùng `AndroidScheduleMode.inexactAllowWhileIdle`; lịch nhắc **không được bảo đảm đến đúng từng phút** trên mọi thiết bị.

## 10. Đóng gói APK / AAB

Chỉ build bản phát hành khi đã cấu hình release signing và xác minh môi trường Firebase/.env:

```powershell
# APK Development để kiểm thử
flutter build apk --release --flavor development -t lib/main.dart

# APK Production
flutter build apk --release --flavor production -t lib/main.dart

# AAB Production để phát hành Google Play
flutter build appbundle --release --flavor production -t lib/main.dart
```

Kiểm tra file đầu ra:

```powershell
Get-ChildItem build\app\outputs\flutter-apk -Filter *.apk
Get-ChildItem build\app\outputs\bundle -Recurse -Filter *.aab
```

Release APK/AAB có thể yêu cầu keystore riêng. Không commit `android/key.properties`, `*.jks`, `*.keystore`. Release signing có thể khác debug signing; hãy thêm SHA certificate tương ứng vào Firebase nếu Google Sign-In cần.

## 11. Lỗi thường gặp

| Triệu chứng | Kiểm tra / giải pháp |
| --- | --- |
| `flutterfire` not recognized | FlutterFire CLI đã activate chưa, Pub Cache `bin` đã vào PATH chưa. |
| `No matching client found for package name` | `applicationId` và `google-services.json` sai flavor. |
| Firebase kết nối nhầm môi trường | Kiểm tra `Firebase.initializeApp`, options thực tế, file native và logic `.env` (đặc biệt `kReleaseMode`). |
| Firestore `PERMISSION_DENIED` khi tạo Task | Kiểm tra đăng nhập, xác minh email, Rules `hasOnly`, trường `completedAt` và UID. |
| `injections.config.dart` không tồn tại | `dart run build_runner build --delete-conflicting-outputs`; kiểm tra annotation và `part`/import. |
| Hive adapter không được tạo | Kiểm tra `hive_ce_generator`, annotation/adapter registration và chạy build_runner. |
| `flutter gen-l10n` lỗi | Kiểm tra `flutter: generate: true` và `l10n.yaml`/ARB. |
| `FlutterFirebaseMessagingPlugin` cannot find symbol | Kiểm tra phiên bản package, `.dart_tool/package_config.json`, cache Pub, build Gradle; không sửa `GeneratedPluginRegistrant.java` thủ công. |
| Icon app chưa đổi | Generate icon cho đúng flavor `development`/`production`; kiểm tra `android/app/src/<flavor>/res` và cài bản build mới. |
| Google Sign-In lỗi trên bản release | Kiểm tra SHA-1/SHA-256 của release certificate và cấu hình Firebase Android app. |
| Gradle/JDK lỗi | `flutter doctor -v`, JDK 17 và Gradle/AGP tương thích; kiểm tra ổ đĩa/temp folder. |
| Reminder không đến đúng phút | Quyền thông báo, MIUI battery restrictions, alarm mode inexact và đồng bộ giờ nhắc. |

Khi cần chẩn đoán:

```powershell
flutter doctor -v
flutter analyze
flutter pub deps
flutter run --flavor development -t lib/main.dart -v
```

Chỉ chạy `flutter clean` khi thực sự gặp lỗi build/cache, không cần dùng trước mọi lần chạy.

## 12. Git và quy tắc bảo mật

- Không đẩy `.env.*` chứa cấu hình nội bộ nếu chính sách repo không cho phép; nên cung cấp `.env.example` không chứa secret.
- Không đẩy keystore, key.properties, service account credentials, token đăng nhập.
- `google-services.json` và `firebase_options.dart` chủ yếu chứa cấu hình Firebase client, **không phải service-account secret**; việc commit hay không phụ thuộc quy định của dự án. Luôn bảo vệ dữ liệu bằng Authentication + Firestore Rules.
- Với file sinh tự động (`*.g.dart`, `injections.config.dart`), tuân theo chính sách Git của nhóm và bảo đảm mọi thành viên có thể generate lại; đừng tùy tiện xóa file đang được dự án import.
- Trước khi mở Pull Request: `dart format .`, `flutter analyze`, chạy các test liên quan và thử flavor Development.

## 13. Checklist nhanh cho thành viên mới

- [ ] Clone repo, cài Flutter/Android SDK/JDK 17.
- [ ] `flutter doctor` không có lỗi Android blocker.
- [ ] `flutter pub get` thành công.
- [ ] Nhận đúng `.env.development` / `.env.production` (nếu cần).
- [ ] Firebase Android apps đúng `applicationId` và `google-services.json` đúng flavor.
- [ ] `Firebase.initializeApp` chọn đúng project khi chạy Development.
- [ ] Firebase Authentication / Firestore Rules đã được cấu hình cho project test.
- [ ] `dart run build_runner build --delete-conflicting-outputs` thành công.
- [ ] Hive CE initialization / generated adapters không lỗi.
- [ ] `flutter gen-l10n` thành công.
- [ ] `flutter run --flavor development -t lib/main.dart` chạy được.
- [ ] Đăng nhập và tạo một Task kiểm thử trên Firestore Development.
- [ ] Nhắc nhở Android và các màn Calendar/Statistics hoạt động.

## 14. Tài liệu tham khảo

- [Flutter — Install / setup](https://docs.flutter.dev/get-started/install)
- [Firebase — Add Firebase to Flutter](https://firebase.google.com/docs/flutter/setup)
- [Firebase — Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli)
- [Injectable](https://pub.dev/packages/injectable)
- [Hive CE](https://pub.dev/packages/hive_ce)
- [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons)

---

**Ghi chú bảo trì:** Các đường dẫn cụ thể tới `FirebaseOptions`, hàm bootstrap DI/Hive và URL Git chưa được cung cấp đầy đủ trong cuộc trò chuyện; README đánh dấu rõ điểm cần đối chiếu với repository, thay vì giả định những thành phần đó đã tồn tại. Cập nhật tài liệu này khi thay đổi flavors, Firebase project, model hoặc quy trình build.
