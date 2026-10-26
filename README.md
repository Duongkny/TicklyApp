# Tickly — Ứng dụng quản lý công việc

Tickly là ứng dụng quản lý công việc (To-Do List) phát triển bằng **Flutter**, sử dụng **Firebase Authentication**, **Cloud Firestore** và **BLoC**, theo định hướng **Clean Architecture**. Ứng dụng hỗ trợ tạo và quản lý công việc, phân loại danh mục, lịch công việc, nhắc nhở cục bộ và thống kê tiến độ.

> Tài liệu này dựa trên cấu hình dự án Tickly đã trao đổi. Tên một số tệp cấu hình Firebase và tên entry point có thể cần đối chiếu với nhánh mã nguồn thực tế trước khi chạy.

## 1. Công nghệ sử dụng

| Thành phần | Công nghệ |
| --- | --- |
| Giao diện | Flutter, Dart, Material 3 (Light/Dark Theme) |
| Quản lý trạng thái | `flutter_bloc` |
| Điều hướng | `go_router` |
| Dependency Injection | `get_it`, `injectable` |
| Xác thực | Firebase Authentication (Email/Password, Google Sign-In) |
| Dữ liệu đám mây | Cloud Firestore |
| Lưu trữ cục bộ | Hive / Hive CE (nếu được sử dụng trong nhánh hiện tại) |
| Nhắc nhở | `flutter_local_notifications`, `timezone`, `flutter_timezone` |
| Biến môi trường | `flutter_dotenv` |
| Đa môi trường | Android flavors `development` và `production` |

## 2. Chức năng chính

- Đăng nhập, đăng ký, xác minh email, quên mật khẩu và ghi nhớ phiên đăng nhập bằng Firebase Auth.
- Tạo, chỉnh sửa, hoàn thành, xóa và tìm kiếm công việc; phân loại theo mức ưu tiên.
- Quản lý danh mục công việc (Category).
- Calendar: xem công việc theo ngày.
- Reminder: đặt giờ thông báo trên thiết bị Android.
- Statistics: tổng quan số công việc, tiến độ hoàn thành và biểu đồ theo thời gian (tùy phiên bản mã nguồn).
- Giao diện Material 3, hỗ trợ Light/Dark Mode.

## 3. Yêu cầu môi trường

Cài đặt các công cụ sau:

1. **Flutter SDK** và Dart đi kèm Flutter (dùng phiên bản tương thích với `pubspec.yaml`).
2. **Android Studio** hoặc VS Code với Flutter/Dart extensions.
3. **Android SDK**, thiết bị Android thật hoặc emulator.
4. **JDK 17** cho bản cấu hình Android hiện tại của Tickly.
5. **Git**.
6. Tài khoản Firebase có quyền truy cập dự án Firebase dùng cho môi trường phát triển.

Kiểm tra:

```powershell
flutter --version
flutter doctor -v
java -version
adb devices
```

> Nếu `flutter doctor` báo thiếu Android SDK licenses, chạy `flutter doctor --android-licenses` và chấp nhận các điều khoản cần thiết.

## 4. Tải mã nguồn và cài dependency

```powershell
git clone <REPOSITORY_URL>
cd tickly
flutter pub get
```

Nếu đã có mã nguồn thì chỉ cần mở thư mục gốc chứa `pubspec.yaml` và chạy:

```powershell
flutter pub get
```

**Không** chạy lệnh trong thư mục `android/` hoặc `lib/`; các lệnh Flutter bên dưới chạy tại thư mục gốc dự án.

## 5. Cấu hình biến môi trường

Dự án sử dụng hai tệp cấu hình:

```text
.env.development
.env.production
```

Nếu repository cung cấp `.env.example`, tạo các file tương ứng từ file mẫu:

```powershell
Copy-Item .env.example .env.development
Copy-Item .env.example .env.production
```

Ví dụ nội dung (chỉ là khóa mẫu theo cấu hình Tickly đã trao đổi):

```dotenv
API_URL=https://example.com
IV_UTF8=replace-with-your-development-value
```

Điền giá trị thực tế theo cấu hình dự án. **Không sao chép nguyên giá trị ví dụ để dùng như môi trường hoạt động.** Nếu nhánh hiện tại chỉ sử dụng Firebase mà không có REST API riêng, hãy kiểm tra lớp `Environment` xem `API_URL` còn bắt buộc hay không.

Kiểm tra trong `pubspec.yaml` đã khai báo assets cho các tệp `.env` mà ứng dụng cần load:

```yaml
flutter:
  assets:
    - .env.development
    - .env.production
```

> Không commit mật khẩu, service account, refresh token hoặc dữ liệu bí mật vào Git. Thêm các tệp `.env` chứa giá trị nhạy cảm vào `.gitignore` và giữ `.env.example` không chứa bí mật. Những giá trị được đóng gói trong app Flutter vẫn có thể bị trích xuất từ ứng dụng; không coi `.env` phía client là kho lưu bí mật an toàn.

## 6. Cấu hình Firebase

### 6.1. Tạo hoặc chọn Firebase project

- Mở [Firebase Console](https://console.firebase.google.com/).
- Chọn dự án Firebase cho Tickly Development (dự án đã dùng trong quá trình phát triển: `tickly-dev-da871`) hoặc dự án Production tương ứng.
- Bật **Authentication** và phương thức đăng nhập mà ứng dụng sử dụng, chẳng hạn **Email/Password** và **Google**.
- Tạo **Cloud Firestore** và triển khai Security Rules phù hợp với các collection Task và Category.

### 6.2. Kết nối Android application ID theo flavor

Trong Tickly, flavor Development đã được sử dụng với application ID:

```text
com.tickly.app.dev
```

Kiểm tra `android/app/build.gradle.kts` để xác nhận `applicationId` của Production và `applicationIdSuffix` của Development. **Mỗi application ID phải được đăng ký đúng với Firebase Android app tương ứng.**

Dựa trên cách dự án cấu hình Firebase, bạn có thể gặp một trong hai cách:

**Cách A — Google Services JSON theo flavor** (nếu Gradle đã cấu hình):

```text
android/app/src/development/google-services.json
android/app/src/production/google-services.json
```

**Cách B — Firebase Options qua FlutterFire CLI:**

```powershell
dart pub global activate flutterfire_cli
flutterfire configure
```

Sau đó xác nhận file Firebase Options được `main.dart` import và ứng dụng gọi `Firebase.initializeApp(...)` với lựa chọn cấu hình đúng flavor. **Không cấu hình tùy tiện cả hai cách nếu mã nguồn chưa hỗ trợ**; hãy đối chiếu `main.dart`, Gradle và các file Firebase hiện có.

Nếu đăng nhập Google, cần cấu hình SHA-1/SHA-256 và các yêu cầu OAuth tương ứng trong Firebase; có thể kiểm tra fingerprint debug bằng:

```powershell
cd android
.\gradlew signingReport
cd ..
```

### 6.3. Firestore Security Rules

Rules hiện tại của Tickly dùng đường dẫn:

```text
users/{userId}/tasks/{taskId}
users/{userId}/categories/{categoryId}
```

Với cấu hình đã thảo luận, người dùng phải đăng nhập, đúng UID và xác minh email để truy cập dữ liệu. Nếu bạn đã bổ sung `completedAt` vào Task, **Rules phải cho phép trường này** (nullable hoặc timestamp, theo nghiệp vụ).

Không thay Rules thành `allow read, write: if true` để khắc phục lỗi quyền truy cập.

## 7. Generate code (khi cần)

Nếu dự án sử dụng `injectable_generator`, chạy:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Chạy lại lệnh khi thêm/sửa annotation DI, model sinh code hoặc cấu hình generator. Sau đó xác nhận những tệp `*.config.dart` được tạo đúng vị trí mà code đang import.

Nếu dự án dùng Flutter localization (`l10n.yaml`, `app_*.arb`):

```powershell
flutter gen-l10n
```

Đảm bảo `pubspec.yaml` có:

```yaml
flutter:
  generate: true
```

Nếu nhánh hiện tại không dùng một trong các công cụ trên, bỏ qua bước tương ứng.

## 8. Chạy ứng dụng trên Android

### 8.1. Xem thiết bị

```powershell
flutter devices
```

### 8.2. Chạy môi trường Development

```powershell
flutter run --flavor development -t lib/main.dart
```

Nếu có nhiều thiết bị, chỉ định ID:

```powershell
flutter run --flavor development -t lib/main.dart -d <DEVICE_ID>
```

### 8.3. Chạy môi trường Production

```powershell
flutter run --flavor production -t lib/main.dart
```

> Chỉ chạy Production khi đã có cấu hình Firebase và `.env.production` hợp lệ. Trong cấu hình Tickly đã trao đổi, file môi trường được lựa chọn dựa trên `kReleaseMode` (debug → development, release → production), **không hoàn toàn dựa vào tên flavor**. Vì thế `flutter run --flavor production` ở chế độ debug có thể vẫn đọc `.env.development`. Để tránh nhầm môi trường, hãy đối chiếu lại logic trong `Environment.initialize()` trước khi test hoặc phát hành Production.

### 8.4. Hot Reload / Hot Restart

Trong Terminal đang chạy `flutter run`:

- Nhấn `r` để Hot Reload.
- Nhấn `R` để Hot Restart.
- Nhấn `q` để thoát.

## 9. Build APK / App Bundle

Build APK Development:

```powershell
flutter build apk --flavor development -t lib/main.dart --debug
```

Build APK Production (release):

```powershell
flutter build apk --flavor production -t lib/main.dart --release
```

Build Android App Bundle Production:

```powershell
flutter build appbundle --flavor production -t lib/main.dart --release
```

File được tạo trong `build/app/outputs/` (đường dẫn cụ thể tùy Flutter/Gradle và variant). Bản release muốn phát hành phải cấu hình ký ứng dụng (keystore/signing) đúng cách.

## 10. Kiểm tra trước khi chạy

- [ ] `flutter doctor -v` không còn lỗi nghiêm trọng.
- [ ] Đã chạy `flutter pub get`.
- [ ] File `.env.development` tồn tại và được khai báo trong `pubspec.yaml`.
- [ ] Firebase được khởi tạo trước khi dùng Firebase Auth/Firestore.
- [ ] Application ID của flavor trùng cấu hình Firebase Android app.
- [ ] Email/Password và/hoặc Google provider đã bật trong Firebase Authentication.
- [ ] Firestore Rules cho phép schema Task hiện tại, bao gồm `completedAt` nếu có.
- [ ] Các tệp generate (`injectable`, localization) đã được tạo khi cần.
- [ ] Thiết bị Android đã kết nối và được nhận diện qua `flutter devices`.
- [ ] Ứng dụng được cấp quyền thông báo nếu kiểm thử Reminder.

## 11. Lỗi thường gặp

| Lỗi / hiện tượng | Cách kiểm tra |
| --- | --- |
| `PERMISSION_DENIED: Missing or insufficient permissions` | Kiểm tra Firestore Rules, UID, email verification và các trường mới như `completedAt`. |
| `processDevelopmentDebugGoogleServices` thất bại | Kiểm tra `google-services.json`, application ID và vị trí file theo flavor. |
| `Cannot find ... injection.config.dart` | Chạy `dart run build_runner build --delete-conflicting-outputs`; kiểm tra tên file và import thực tế. |
| `flutter gen-l10n` không chạy | Kiểm tra `flutter: generate: true` và file `l10n.yaml`. |
| Java/Gradle/Kotlin build lỗi | Kiểm tra JDK 17, cấu hình Java/Kotlin trong Gradle và tính tương thích các version plugin. |
| Không thấy thông báo Reminder | Kiểm tra quyền thông báo, `reminderAt` là tương lai, lịch được Android tiếp nhận và hạn chế pin của MIUI. Lịch `inexactAllowWhileIdle` có thể đến trễ. |
| Tự vào Home sau khi mở ứng dụng | Đây là cơ chế duy trì phiên Firebase Auth; đăng xuất để quay lại màn Sign In. |
| `adb devices` không hiện máy | Kiểm tra USB debugging, quyền trust device và driver Android trên Windows. |

Để xem log Flutter trong khi chạy ứng dụng:

```powershell
flutter logs
```

Hoặc lọc log Android (Windows PowerShell):

```powershell
adb logcat -s flutter:I '*:S'
```

## 12. Kiến trúc dự án (tóm tắt)

```text
tickly/
├── android/
├── assets/                         # Nếu có
├── lib/
│   ├── main.dart
│   └── src/
│       ├── core/
│       │   ├── injections/
│       │   ├── notification/
│       │   ├── theme/
│       │   └── ...
│       ├── features/
│       │   ├── auth/
│       │   ├── tasks/
│       │   ├── categories/
│       │   ├── calendar/
│       │   ├── statistics/
│       │   └── main_wrapper/
│       └── router/
├── .env.example                    # Nên có
├── .env.development                # Tạo cục bộ
├── .env.production                 # Cấu hình theo môi trường
└── pubspec.yaml
```

Ở các feature có nghiệp vụ và nguồn dữ liệu riêng, kiến trúc thường chia thành `data/`, `domain/`, `presentation/`. Statistics ở giai đoạn hiện tại có thể tái sử dụng `TaskBloc` và dữ liệu Task để tính toán, tránh tải Firestore lần thứ hai.

## 13. Lưu ý bảo mật

- Không commit token, mật khẩu, tài khoản service hoặc private key vào repository.
- Firebase Auth SDK quản lý phiên đăng nhập; **không cần lưu Firebase ID Token thủ công vào Hive**.
- Không tắt Firestore Rules để thử tạo Task.
- Dữ liệu nhắc nhở lưu cục bộ trên thiết bị cần được dọn khi người dùng đăng xuất hoặc đổi tài khoản.
- Không đưa thông tin cá nhân, token hoặc toàn bộ response nhạy cảm vào log Production.

## 14. Kiểm tra chất lượng mã nguồn

```powershell
dart format lib
flutter analyze
flutter test
```

`flutter test` chỉ thành công khi các test hiện tại hợp lệ và đã khai báo đủ `dev_dependencies` cần thiết.

---

**Tickly** — Quản lý công việc đơn giản, giúp bạn tập trung vào những điều quan trọng mỗi ngày.
