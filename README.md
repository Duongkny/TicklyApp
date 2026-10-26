# Tickly

Ứng dụng Flutter quản lý công việc, sử dụng Firebase Authentication, Firestore và BLoC.

## Chạy bản phát triển

```sh
flutter pub get
flutter run --flavor development
```

Trên Windows, dùng lệnh sau để Flutter ghi tệp tạm vào ổ chứa dự án thay vì ổ C:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\flutter-local.ps1
```

Mặc định lệnh chạy flavor `development`. Có thể truyền lệnh khác:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\flutter-local.ps1 build apk --debug --flavor development
```

VS Code: chọn **Tickly Development** rồi nhấn F5. Cả hai cấu hình chạy đã đặt `TEMP`/`TMP` vào `.dart_tool/tickly-temp`; tác vụ trước khi chạy tự tạo lại thư mục sau `flutter clean`. Nếu dùng Android Studio, chạy script trong Terminal hoặc đặt hai biến môi trường tương tự trong cấu hình chạy. Script và cấu hình chạy dùng `E:/GradleCache/tickly` cho Gradle, `E:/FlutterTemp` cho Java; không thay đổi biến môi trường toàn hệ thống. Đường dẫn này dành cho máy Windows hiện tại và cần chỉnh nếu chuyển dự án sang máy khác.

Cần cấu hình Firebase và `.env.development` tương ứng với flavor. Giữ nguyên cấu hình Firebase hiện có của dự án.

## Giao diện và chức năng

- Giới thiệu, đăng nhập, đăng ký có họ tên, tiếp tục với Google, quên mật khẩu và xác minh email bằng tiếng Việt và tiếng Anh.
- Điều hướng dưới: Công việc, Danh mục, Thống kê, Cài đặt.
- Bộ lọc Tất cả / Hôm nay / Sắp tới dựa trên hạn công việc; tìm kiếm và lọc danh mục qua biểu tượng tìm kiếm; sắp xếp công việc.
- Tạo, sửa, xóa, hoàn thành công việc và lịch nhắc sử dụng các BLoC hiện có.
- Danh mục có số lượng công việc; nhấn danh mục để xem danh sách tương ứng.
- Thống kê tổng quan, biểu đồ hoàn thành 7/30 ngày, biểu đồ phân bố danh mục, bao gồm công việc chưa phân loại.
- Cài đặt họ tên, gửi email đổi mật khẩu, đăng xuất, chủ đề sáng/tối/hệ thống và bật/tắt lịch nhắc. Chủ đề và lựa chọn nhắc nhở được lưu trên thiết bị.
- Màu tím pastel theo bảng thiết kế, typography Inter qua google_fonts, component Material 3.

## Kiểm tra

```sh
dart analyze --fatal-infos
flutter test --concurrency=1
flutter build bundle --debug
```

Kiểm thử sử dụng dữ liệu giả lập, không ghi dữ liệu Firebase. Bao gồm ranh giới bộ lọc ngày, thống kê, điều hướng giới thiệu, checkbox, danh mục trống và chuyển tab sáng/tối.

## Phạm vi cần kiểm tra trên thiết bị

- Đăng nhập Google, gửi/xác minh email và CRUD Firestore cần kiểm thử bằng tài khoản phát triển thật.
- Quyền thông báo, lịch nhắc và hành vi khi ứng dụng đóng cần kiểm thử trên Android thật.
- Chưa tích hợp Apple Sign-In; cần cấu hình Apple/Firebase riêng trước khi thêm phương thức này.
- Hình giới thiệu hiện được dựng bằng widget Flutter; chưa sử dụng hình nhân vật gốc trong bản thiết kế.
- Font Inter dùng cơ chế tải/cache của google_fonts; nên đóng gói font kèm ứng dụng trước khi phát hành để bảo đảm lần chạy đầu ngoại tuyến.
- Build bundle kiểm tra mã Dart và tài nguyên; không thay thế kiểm tra APK, ký phát hành hoặc kiểm thử thiết bị.

## Ngôn ngữ / Localization

Ứng dụng hỗ trợ **Tiếng Việt (`vi`)** và **English (`en`)**. Đổi tại **Cài đặt → Ngôn ngữ**; lựa chọn được lưu trên thiết bị và khôi phục khi mở lại ứng dụng. Ngôn ngữ áp dụng cho giao diện, lỗi biểu mẫu và nội dung nhắc việc mới/cập nhật. Nội dung công việc và tên danh mục do người dùng nhập không được dịch tự động.

- Chuỗi gốc: `lib/l10n/app_vi.arb`; bản tiếng Anh: `lib/l10n/app_en.arb`.
- Widget dùng `context.loc`; không viết trực tiếp văn bản hiển thị trong Dart.
- Chuỗi có biến dùng placeholder trong ARB; số lượng tiếng Anh dùng ICU plural.
- Mã không có BuildContext (BLoC, validators, notifications) dùng `AppStrings.current` theo ngôn ngữ đã khôi phục.
- Sau khi sửa ARB, chạy `flutter gen-l10n`. Không chỉnh sửa các tệp được sinh trong `lib/l10n/output`.
- Trên Windows, có thể chạy qua script dùng ổ E: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\flutter-local.ps1 gen-l10n`.

### Lỗi `compressDevelopmentDebugAssets`: hết dung lượng

Flutter, Java và Gradle có các vị trí ghi tệp khác nhau. Trên máy này đã đặt `TEMP`/`TMP`, `GRADLE_USER_HOME=E:/GradleCache/tickly` và `java.io.tmpdir=E:/FlutterTemp` cho script, VS Code và cấu hình Android Studio `main.dart`. JVM của Gradle cũng dùng thư mục tạm trên E thông qua `android/gradle.properties`.

Đóng phiên chạy cũ, mở lại IDE và chạy bằng cấu hình đã cập nhật, hoặc dùng `scripts/flutter-local.ps1`. Không cần nâng cấp hàng loạt package để xử lý lỗi hết dung lượng. Cấu hình này không xóa cache cũ trên C; ổ hệ thống vẫn cần dung lượng trống cho Windows và IDE.

### Lỗi Gradle `The settings are not yet available for build`

Đã tắt tái sử dụng Gradle daemon và configuration cache trong `android/gradle.properties` để chạy bằng tiến trình mới và tránh lỗi báo cáo trước khi settings được nạp. Script và cấu hình IDE đặt `ANDROID_USER_HOME` vào `.dart_tool/android-user-home` trên ổ E, tránh ghi vào `C:\.android`. Script giữ lại debug keystore hiện có trong `%USERPROFILE%\.android` nếu có để không đổi chữ ký bản debug.

Build kiểm tra: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\flutter-local.ps1 build apk --debug --flavor development --target-platform android-arm64`.
Đường dẫn output Gradle được cố định tương đối từ thư mục `android` bằng `projectDirectory.dir("../build")`, tương ứng `tickly/build`, để Flutter tìm đúng APK.
