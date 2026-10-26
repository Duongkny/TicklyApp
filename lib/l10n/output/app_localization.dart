import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localization_en.dart';
import 'app_localization_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'output/app_localization.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In vi, this message translates to:
  /// **'Tickly'**
  String get appName;

  /// No description provided for @commonEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get commonEmail;

  /// No description provided for @commonPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get commonPassword;

  /// No description provided for @commonConfirmPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get commonConfirmPassword;

  /// No description provided for @commonContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get commonContinue;

  /// No description provided for @commonCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get commonCancel;

  /// No description provided for @commonBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get commonBack;

  /// No description provided for @commonSubmit.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get commonSubmit;

  /// No description provided for @commonRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get commonRetry;

  /// No description provided for @commonLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải...'**
  String get commonLoading;

  /// No description provided for @commonSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Thành công'**
  String get commonSuccess;

  /// No description provided for @commonError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi'**
  String get commonError;

  /// No description provided for @commonOr.
  ///
  /// In vi, this message translates to:
  /// **'HOẶC'**
  String get commonOr;

  /// No description provided for @signInTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng trở lại!'**
  String get signInTitle;

  /// No description provided for @signInDescription.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để tiếp tục quản lý công việc của bạn.'**
  String get signInDescription;

  /// No description provided for @signInEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'name@example.com'**
  String get signInEmailHint;

  /// No description provided for @signInPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu'**
  String get signInPasswordHint;

  /// No description provided for @signInButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get signInButton;

  /// No description provided for @signInLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang đăng nhập...'**
  String get signInLoading;

  /// No description provided for @signInForgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get signInForgotPassword;

  /// No description provided for @signInNoAccount.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có tài khoản?'**
  String get signInNoAccount;

  /// No description provided for @signInSignUp.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get signInSignUp;

  /// No description provided for @signInWithGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Google'**
  String get signInWithGoogle;

  /// No description provided for @signInSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thành công'**
  String get signInSuccess;

  /// No description provided for @signInFailure.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thất bại. Vui lòng thử lại.'**
  String get signInFailure;

  /// No description provided for @signInInvalidCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc mật khẩu không chính xác.'**
  String get signInInvalidCredentials;

  /// No description provided for @signUpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get signUpTitle;

  /// No description provided for @signUpDescription.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia Tickly và bắt đầu sắp xếp công việc mỗi ngày.'**
  String get signUpDescription;

  /// No description provided for @signUpEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'name@example.com'**
  String get signUpEmailHint;

  /// No description provided for @signUpPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Ít nhất 8 ký tự'**
  String get signUpPasswordHint;

  /// No description provided for @signUpConfirmPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại mật khẩu'**
  String get signUpConfirmPasswordHint;

  /// No description provided for @signUpButton.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get signUpButton;

  /// No description provided for @signUpLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tạo tài khoản...'**
  String get signUpLoading;

  /// No description provided for @signUpAlreadyHaveAccount.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã có tài khoản?'**
  String get signUpAlreadyHaveAccount;

  /// No description provided for @signUpSignIn.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get signUpSignIn;

  /// No description provided for @signUpSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thành công'**
  String get signUpSuccess;

  /// No description provided for @signUpFailure.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thất bại. Vui lòng thử lại.'**
  String get signUpFailure;

  /// No description provided for @signUpEmailAlreadyInUse.
  ///
  /// In vi, this message translates to:
  /// **'Email này đã được sử dụng.'**
  String get signUpEmailAlreadyInUse;

  /// No description provided for @signUpWeakPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu quá yếu.'**
  String get signUpWeakPassword;

  /// No description provided for @signUpPasswordMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận không khớp.'**
  String get signUpPasswordMismatch;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordHeading.
  ///
  /// In vi, this message translates to:
  /// **'Bạn quên mật khẩu?'**
  String get forgotPasswordHeading;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nhập địa chỉ email để nhận liên kết đặt lại mật khẩu.'**
  String get forgotPasswordDescription;

  /// No description provided for @forgotPasswordEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ email'**
  String get forgotPasswordEmailLabel;

  /// No description provided for @forgotPasswordEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'name@example.com'**
  String get forgotPasswordEmailHint;

  /// No description provided for @forgotPasswordSendButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi email đặt lại mật khẩu'**
  String get forgotPasswordSendButton;

  /// No description provided for @forgotPasswordSending.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi email...'**
  String get forgotPasswordSending;

  /// No description provided for @forgotPasswordBackToSignIn.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại đăng nhập'**
  String get forgotPasswordBackToSignIn;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Nếu email thuộc tài khoản hợp lệ, bạn sẽ nhận được liên kết đặt lại mật khẩu.'**
  String get forgotPasswordSuccess;

  /// No description provided for @forgotPasswordFailure.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi email đặt lại mật khẩu. Vui lòng thử lại.'**
  String get forgotPasswordFailure;

  /// No description provided for @forgotPasswordCheckInbox.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng kiểm tra hộp thư đến hoặc thư mục Spam.'**
  String get forgotPasswordCheckInbox;

  /// No description provided for @forgotPasswordEmailSentTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra email của bạn'**
  String get forgotPasswordEmailSentTitle;

  /// No description provided for @forgotPasswordEmailSentDescription.
  ///
  /// In vi, this message translates to:
  /// **'Hãy mở email và nhấn vào liên kết để tạo mật khẩu mới.'**
  String get forgotPasswordEmailSentDescription;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác minh email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailHeading.
  ///
  /// In vi, this message translates to:
  /// **'Xác minh địa chỉ email của bạn'**
  String get verifyEmailHeading;

  /// No description provided for @verifyEmailSentTo.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi đã gửi liên kết xác minh đến'**
  String get verifyEmailSentTo;

  /// No description provided for @verifyEmailDescription.
  ///
  /// In vi, this message translates to:
  /// **'Mở hộp thư và nhấn vào liên kết xác minh. Sau đó quay lại Tickly để hoàn tất.'**
  String get verifyEmailDescription;

  /// No description provided for @verifyEmailCheckButton.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đã xác minh'**
  String get verifyEmailCheckButton;

  /// No description provided for @verifyEmailChecking.
  ///
  /// In vi, this message translates to:
  /// **'Đang kiểm tra...'**
  String get verifyEmailChecking;

  /// No description provided for @verifyEmailResendButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại email xác minh'**
  String get verifyEmailResendButton;

  /// No description provided for @verifyEmailResending.
  ///
  /// In vi, this message translates to:
  /// **'Đang gửi lại...'**
  String get verifyEmailResending;

  /// No description provided for @verifyEmailSignOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất / Dùng tài khoản khác'**
  String get verifyEmailSignOut;

  /// No description provided for @verifyEmailSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Xác minh email thành công!'**
  String get verifyEmailSuccess;

  /// No description provided for @verifyEmailNotVerified.
  ///
  /// In vi, this message translates to:
  /// **'Email chưa được xác minh. Vui lòng nhấn vào liên kết trong hộp thư.'**
  String get verifyEmailNotVerified;

  /// No description provided for @verifyEmailResendSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu xác minh. Vui lòng kiểm tra email.'**
  String get verifyEmailResendSuccess;

  /// No description provided for @verifyEmailResendFailure.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi lại email xác minh.'**
  String get verifyEmailResendFailure;

  /// No description provided for @verifyEmailCheckFailure.
  ///
  /// In vi, this message translates to:
  /// **'Không thể kiểm tra trạng thái xác minh email.'**
  String get verifyEmailCheckFailure;

  /// No description provided for @verifyEmailExpired.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết xác minh đã hết hạn hoặc không hợp lệ.'**
  String get verifyEmailExpired;

  /// No description provided for @googleSignInSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập Google thành công'**
  String get googleSignInSuccess;

  /// No description provided for @googleSignInFailure.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đăng nhập bằng Google.'**
  String get googleSignInFailure;

  /// No description provided for @googleSignInCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy đăng nhập Google.'**
  String get googleSignInCancelled;

  /// No description provided for @validationRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập thông tin này'**
  String get validationRequired;

  /// No description provided for @validationEmailRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ email không hợp lệ'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải có ít nhất 8 ký tự'**
  String get validationPasswordMinLength;

  /// No description provided for @validationConfirmPasswordRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng xác nhận mật khẩu'**
  String get validationConfirmPasswordRequired;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận không khớp'**
  String get validationPasswordMismatch;

  /// No description provided for @validationNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập họ tên'**
  String get validationNameRequired;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số điện thoại'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại không hợp lệ'**
  String get validationPhoneInvalid;

  /// No description provided for @validationDateRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn ngày sinh'**
  String get validationDateRequired;

  /// No description provided for @validationDateInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh không hợp lệ'**
  String get validationDateInvalid;

  /// No description provided for @authUserNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy tài khoản.'**
  String get authUserNotFound;

  /// No description provided for @authUserDisabled.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản đã bị vô hiệu hóa.'**
  String get authUserDisabled;

  /// No description provided for @authTooManyRequests.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã thao tác quá nhiều lần. Vui lòng thử lại sau.'**
  String get authTooManyRequests;

  /// No description provided for @authNetworkError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi kết nối mạng. Vui lòng kiểm tra Internet.'**
  String get authNetworkError;

  /// No description provided for @authSessionExpired.
  ///
  /// In vi, this message translates to:
  /// **'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.'**
  String get authSessionExpired;

  /// No description provided for @authEmailNotVerified.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần xác minh email trước khi tiếp tục.'**
  String get authEmailNotVerified;

  /// No description provided for @authUnknownError.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi. Vui lòng thử lại.'**
  String get authUnknownError;

  /// No description provided for @homeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get homeTitle;

  /// No description provided for @homeWelcome.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng đến với Tickly!'**
  String get homeWelcome;

  /// No description provided for @homeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Hãy bắt đầu quản lý công việc của bạn.'**
  String get homeDescription;

  /// No description provided for @homeSignOut.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get homeSignOut;

  /// No description provided for @homeSignOutSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất thành công'**
  String get homeSignOutSuccess;

  /// No description provided for @taskReminders.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở công việc'**
  String get taskReminders;

  /// No description provided for @reminderChannelDescription.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo nhắc nhở từ Tickly'**
  String get reminderChannelDescription;

  /// No description provided for @reminderTestBody.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo thử nghiệm hoạt động!'**
  String get reminderTestBody;

  /// No description provided for @actionFailed.
  ///
  /// In vi, this message translates to:
  /// **'Thao tác không thành công. Vui lòng thử lại.'**
  String get actionFailed;

  /// No description provided for @authCheckFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể kiểm tra đăng nhập'**
  String get authCheckFailed;

  /// No description provided for @welcomeGoodDay.
  ///
  /// In vi, this message translates to:
  /// **'Một ngày thật tốt'**
  String get welcomeGoodDay;

  /// No description provided for @welcomeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý công việc đơn giản, hiệu quả và mạch lạc hơn với Tickly.'**
  String get welcomeDescription;

  /// No description provided for @welcomeStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get welcomeStart;

  /// No description provided for @accountLoadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lấy thông tin tài khoản.'**
  String get accountLoadFailed;

  /// No description provided for @fullName.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get fullName;

  /// No description provided for @emailAddressFallback.
  ///
  /// In vi, this message translates to:
  /// **'địa chỉ email của bạn'**
  String get emailAddressFallback;

  /// No description provided for @previous.
  ///
  /// In vi, this message translates to:
  /// **'Trước'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In vi, this message translates to:
  /// **'Sau'**
  String get next;

  /// No description provided for @calendarTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch công việc'**
  String get calendarTitle;

  /// No description provided for @today.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get today;

  /// No description provided for @calendarMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng'**
  String get calendarMonth;

  /// No description provided for @calendarWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần'**
  String get calendarWeek;

  /// No description provided for @noTasksDue.
  ///
  /// In vi, this message translates to:
  /// **'Không có công việc đến hạn'**
  String get noTasksDue;

  /// No description provided for @categoryTooLarge.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục có quá nhiều công việc. Không thể xóa trong một lần.'**
  String get categoryTooLarge;

  /// No description provided for @categoryLoadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh mục'**
  String get categoryLoadFailed;

  /// No description provided for @connectionFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể kết nối Firestore.'**
  String get connectionFailed;

  /// No description provided for @categoryCreateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tạo danh mục.'**
  String get categoryCreateFailed;

  /// No description provided for @categoryUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật danh mục.'**
  String get categoryUpdateFailed;

  /// No description provided for @categoryDeleteFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xóa danh mục.'**
  String get categoryDeleteFailed;

  /// No description provided for @signInRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đăng nhập'**
  String get signInRequired;

  /// No description provided for @categoryDeleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa danh mục?'**
  String get categoryDeleteTitle;

  /// No description provided for @commonDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get commonDelete;

  /// No description provided for @categoryEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa danh mục'**
  String get categoryEdit;

  /// No description provided for @categoryDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa danh mục'**
  String get categoryDelete;

  /// No description provided for @categoryEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có danh mục nào'**
  String get categoryEmptyTitle;

  /// No description provided for @categoryEmptyDescription.
  ///
  /// In vi, this message translates to:
  /// **'Hãy tạo danh mục đầu tiên để sắp xếp công việc dễ dàng hơn.'**
  String get categoryEmptyDescription;

  /// No description provided for @categoryCreate.
  ///
  /// In vi, this message translates to:
  /// **'Tạo danh mục'**
  String get categoryCreate;

  /// No description provided for @categoriesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get categoriesTitle;

  /// No description provided for @categoryAdd.
  ///
  /// In vi, this message translates to:
  /// **'Thêm danh mục'**
  String get categoryAdd;

  /// No description provided for @categoryCreated.
  ///
  /// In vi, this message translates to:
  /// **'Tạo danh mục thành công'**
  String get categoryCreated;

  /// No description provided for @categoryUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật danh mục thành công'**
  String get categoryUpdated;

  /// No description provided for @categoryDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Xóa danh mục thành công'**
  String get categoryDeleted;

  /// No description provided for @actionSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Thao tác thành công'**
  String get actionSuccess;

  /// No description provided for @allTasks.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả công việc'**
  String get allTasks;

  /// No description provided for @filterAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get filterAll;

  /// No description provided for @uncategorized.
  ///
  /// In vi, this message translates to:
  /// **'Chưa phân loại'**
  String get uncategorized;

  /// No description provided for @categoryName.
  ///
  /// In vi, this message translates to:
  /// **'Tên danh mục'**
  String get categoryName;

  /// No description provided for @categoryNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Học tập'**
  String get categoryNameHint;

  /// No description provided for @categoryNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên danh mục'**
  String get categoryNameRequired;

  /// No description provided for @chooseColor.
  ///
  /// In vi, this message translates to:
  /// **'Chọn màu'**
  String get chooseColor;

  /// No description provided for @commonSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get commonSave;

  /// No description provided for @categoriesLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải danh mục...'**
  String get categoriesLoading;

  /// No description provided for @categoryNone.
  ///
  /// In vi, this message translates to:
  /// **'Không có danh mục'**
  String get categoryNone;

  /// No description provided for @searchAndFilter.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm và lọc'**
  String get searchAndFilter;

  /// No description provided for @accountTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get accountTitle;

  /// No description provided for @tasksTitle.
  ///
  /// In vi, this message translates to:
  /// **'Công việc'**
  String get tasksTitle;

  /// No description provided for @statisticsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get statisticsTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsTitle;

  /// No description provided for @taskUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật công việc'**
  String get taskUpdateFailed;

  /// No description provided for @taskLoadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh sách công việc'**
  String get taskLoadFailed;

  /// No description provided for @tasksEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có công việc nào'**
  String get tasksEmptyTitle;

  /// No description provided for @tasksEmptyDescription.
  ///
  /// In vi, this message translates to:
  /// **'Hãy thêm công việc đầu tiên của bạn!'**
  String get tasksEmptyDescription;

  /// No description provided for @taskCreate.
  ///
  /// In vi, this message translates to:
  /// **'Tạo công việc'**
  String get taskCreate;

  /// No description provided for @yourTasks.
  ///
  /// In vi, this message translates to:
  /// **'Công việc của bạn'**
  String get yourTasks;

  /// No description provided for @categoriesUnavailable.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải danh mục; đang hiển thị công việc đã tải.'**
  String get categoriesUnavailable;

  /// No description provided for @noMatchingTasks.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy công việc phù hợp'**
  String get noMatchingTasks;

  /// No description provided for @notificationPermissionHint.
  ///
  /// In vi, this message translates to:
  /// **'Hãy cho phép thông báo cho Tickly trong cài đặt điện thoại.'**
  String get notificationPermissionHint;

  /// No description provided for @reminderUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật nhắc nhở. Vui lòng thử lại.'**
  String get reminderUpdateFailed;

  /// No description provided for @profileTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân'**
  String get profileTitle;

  /// No description provided for @profileUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật thông tin cá nhân'**
  String get profileUpdated;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể cập nhật thông tin. Vui lòng thử lại.'**
  String get profileUpdateFailed;

  /// No description provided for @changePassword.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get changePassword;

  /// No description provided for @sendLink.
  ///
  /// In vi, this message translates to:
  /// **'Gửi liên kết'**
  String get sendLink;

  /// No description provided for @resetLinkSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi liên kết. Vui lòng kiểm tra email.'**
  String get resetLinkSent;

  /// No description provided for @emailSendFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể gửi email. Vui lòng thử lại.'**
  String get emailSendFailed;

  /// No description provided for @signOutTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất?'**
  String get signOutTitle;

  /// No description provided for @signOutConfirmation.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có muốn đăng xuất khỏi Tickly?'**
  String get signOutConfirmation;

  /// No description provided for @themeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chủ đề'**
  String get themeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get themeDark;

  /// No description provided for @defaultUserName.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng Tickly'**
  String get defaultUserName;

  /// No description provided for @applicationTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng'**
  String get applicationTitle;

  /// No description provided for @languageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get languageTitle;

  /// No description provided for @aboutTitle.
  ///
  /// In vi, this message translates to:
  /// **'Về ứng dụng'**
  String get aboutTitle;

  /// No description provided for @appDescription.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý công việc đơn giản, giúp bạn tập trung vào những điều quan trọng mỗi ngày.'**
  String get appDescription;

  /// No description provided for @statisticsPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê công việc'**
  String get statisticsPageTitle;

  /// No description provided for @statisticsLoadFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải dữ liệu thống kê'**
  String get statisticsLoadFailed;

  /// No description provided for @categoryStatisticsFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tải phân bố danh mục. Vui lòng thử lại ở tab Danh mục.'**
  String get categoryStatisticsFailed;

  /// No description provided for @categoryStatisticsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Công việc theo danh mục'**
  String get categoryStatisticsTitle;

  /// No description provided for @statisticsTotal.
  ///
  /// In vi, this message translates to:
  /// **'tổng cộng'**
  String get statisticsTotal;

  /// No description provided for @categoryStatisticsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Thêm công việc để xem phân bố danh mục.'**
  String get categoryStatisticsEmpty;

  /// No description provided for @completionPerformance.
  ///
  /// In vi, this message translates to:
  /// **'Hiệu suất hoàn thành'**
  String get completionPerformance;

  /// No description provided for @completionByDay.
  ///
  /// In vi, this message translates to:
  /// **'Số công việc hoàn thành theo ngày'**
  String get completionByDay;

  /// No description provided for @periodSevenDays.
  ///
  /// In vi, this message translates to:
  /// **'7 ngày'**
  String get periodSevenDays;

  /// No description provided for @periodThirtyDays.
  ///
  /// In vi, this message translates to:
  /// **'30 ngày'**
  String get periodThirtyDays;

  /// No description provided for @completionEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có công việc hoàn thành trong khoảng thời gian này'**
  String get completionEmpty;

  /// No description provided for @statisticsOverview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan công việc'**
  String get statisticsOverview;

  /// No description provided for @statisticsTotalTasks.
  ///
  /// In vi, this message translates to:
  /// **'Tổng công việc'**
  String get statisticsTotalTasks;

  /// No description provided for @statusCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành'**
  String get statusCompleted;

  /// No description provided for @statusPending.
  ///
  /// In vi, this message translates to:
  /// **'Chưa hoàn thành'**
  String get statusPending;

  /// No description provided for @statusOverdue.
  ///
  /// In vi, this message translates to:
  /// **'Quá hạn'**
  String get statusOverdue;

  /// No description provided for @completionProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ hoàn thành'**
  String get completionProgress;

  /// No description provided for @taskCreated.
  ///
  /// In vi, this message translates to:
  /// **'Tạo công việc thành công'**
  String get taskCreated;

  /// No description provided for @taskCreateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tạo công việc'**
  String get taskCreateFailed;

  /// No description provided for @taskUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật công việc thành công'**
  String get taskUpdated;

  /// No description provided for @taskStatusUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật trạng thái công việc'**
  String get taskStatusUpdated;

  /// No description provided for @taskToggleFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đổi trạng thái công việc.'**
  String get taskToggleFailed;

  /// No description provided for @taskDeleted.
  ///
  /// In vi, this message translates to:
  /// **'Xóa công việc thành công'**
  String get taskDeleted;

  /// No description provided for @taskDeleteFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể xóa công việc'**
  String get taskDeleteFailed;

  /// No description provided for @reminderMustBeFuture.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian nhắc nhở phải ở tương lai'**
  String get reminderMustBeFuture;

  /// No description provided for @categoryNotConfirmed.
  ///
  /// In vi, this message translates to:
  /// **'Chưa thể xác nhận danh mục đã chọn'**
  String get categoryNotConfirmed;

  /// No description provided for @categoryNoLongerExists.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục đã chọn không còn tồn tại'**
  String get categoryNoLongerExists;

  /// No description provided for @taskTitleLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề công việc'**
  String get taskTitleLabel;

  /// No description provided for @taskTitleHint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Học Flutter BLoC'**
  String get taskTitleHint;

  /// No description provided for @taskTitleRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tiêu đề'**
  String get taskTitleRequired;

  /// No description provided for @taskDescriptionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get taskDescriptionLabel;

  /// No description provided for @taskDescriptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mô tả công việc...'**
  String get taskDescriptionHint;

  /// No description provided for @priorityTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mức độ ưu tiên'**
  String get priorityTitle;

  /// No description provided for @priorityLow.
  ///
  /// In vi, this message translates to:
  /// **'Thấp'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In vi, this message translates to:
  /// **'Vừa'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In vi, this message translates to:
  /// **'Cao'**
  String get priorityHigh;

  /// No description provided for @dueDateTime.
  ///
  /// In vi, this message translates to:
  /// **'Ngày và giờ hết hạn'**
  String get dueDateTime;

  /// No description provided for @notSelected.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chọn'**
  String get notSelected;

  /// No description provided for @reminderNotSet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đặt nhắc nhở'**
  String get reminderNotSet;

  /// No description provided for @removeReminder.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ nhắc nhở'**
  String get removeReminder;

  /// No description provided for @newReminderMustBeFuture.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian nhắc nhở mới phải ở tương lai'**
  String get newReminderMustBeFuture;

  /// No description provided for @taskEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa công việc'**
  String get taskEdit;

  /// No description provided for @removeDueDate.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ hạn hoàn thành'**
  String get removeDueDate;

  /// No description provided for @commonSaving.
  ///
  /// In vi, this message translates to:
  /// **'Đang lưu...'**
  String get commonSaving;

  /// No description provided for @saveChanges.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get saveChanges;

  /// No description provided for @taskDeleteTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa công việc?'**
  String get taskDeleteTitle;

  /// No description provided for @categoryNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy danh mục'**
  String get categoryNotFound;

  /// No description provided for @taskDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết công việc'**
  String get taskDetails;

  /// No description provided for @taskNotFound.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy công việc'**
  String get taskNotFound;

  /// No description provided for @commonEdit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get commonEdit;

  /// No description provided for @taskNoDescription.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có mô tả'**
  String get taskNoDescription;

  /// No description provided for @markCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu hoàn thành'**
  String get markCompleted;

  /// No description provided for @taskIsCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Công việc đã hoàn thành'**
  String get taskIsCompleted;

  /// No description provided for @taskIsPending.
  ///
  /// In vi, this message translates to:
  /// **'Công việc chưa hoàn thành'**
  String get taskIsPending;

  /// No description provided for @upcoming.
  ///
  /// In vi, this message translates to:
  /// **'Sắp tới'**
  String get upcoming;

  /// No description provided for @notSet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đặt'**
  String get notSet;

  /// No description provided for @dueDate.
  ///
  /// In vi, this message translates to:
  /// **'Hạn hoàn thành'**
  String get dueDate;

  /// No description provided for @reminderLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở'**
  String get reminderLabel;

  /// No description provided for @createdDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày tạo'**
  String get createdDate;

  /// No description provided for @lastUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật lần cuối'**
  String get lastUpdated;

  /// No description provided for @sortNewest.
  ///
  /// In vi, this message translates to:
  /// **'Mới nhất'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In vi, this message translates to:
  /// **'Cũ nhất'**
  String get sortOldest;

  /// No description provided for @sortPriorityHigh.
  ///
  /// In vi, this message translates to:
  /// **'Ưu tiên cao'**
  String get sortPriorityHigh;

  /// No description provided for @sortPriorityLow.
  ///
  /// In vi, this message translates to:
  /// **'Ưu tiên thấp'**
  String get sortPriorityLow;

  /// No description provided for @sortDueSoon.
  ///
  /// In vi, this message translates to:
  /// **'Hạn gần nhất'**
  String get sortDueSoon;

  /// No description provided for @sortDueLate.
  ///
  /// In vi, this message translates to:
  /// **'Hạn xa nhất'**
  String get sortDueLate;

  /// No description provided for @sortTasks.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp công việc'**
  String get sortTasks;

  /// No description provided for @taskSearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm công việc...'**
  String get taskSearchHint;

  /// No description provided for @clearSearch.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tìm kiếm'**
  String get clearSearch;

  /// No description provided for @validationNumberInvalid.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số hợp lệ'**
  String get validationNumberInvalid;

  /// No description provided for @validationPositiveInteger.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập số nguyên dương'**
  String get validationPositiveInteger;

  /// No description provided for @validationOtp.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mã gồm 6 chữ số'**
  String get validationOtp;

  /// No description provided for @inputDateOfBirth.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh'**
  String get inputDateOfBirth;

  /// No description provided for @inputNumber.
  ///
  /// In vi, this message translates to:
  /// **'Số'**
  String get inputNumber;

  /// No description provided for @welcomeHeadline.
  ///
  /// In vi, this message translates to:
  /// **'Biến kế hoạch thành\nhành động mỗi ngày'**
  String get welcomeHeadline;

  /// No description provided for @taskDeleteConfirmation.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa công việc này?\n\nCông việc sẽ bị xóa vĩnh viễn.'**
  String get taskDeleteConfirmation;

  /// No description provided for @taskCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} công việc'**
  String taskCount(int count);

  /// No description provided for @completedTaskCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} công việc đã hoàn thành'**
  String completedTaskCount(int count);

  /// No description provided for @completionCount.
  ///
  /// In vi, this message translates to:
  /// **'{completed}/{total} đã hoàn thành'**
  String completionCount(int completed, int total);

  /// No description provided for @categoryDeleteConfirmation.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn xóa \"{name}\"?\n\nCác công việc trong danh mục này sẽ được giữ lại và chuyển sang \"Chưa phân loại\".'**
  String categoryDeleteConfirmation(String name);

  /// No description provided for @resetPasswordConfirmation.
  ///
  /// In vi, this message translates to:
  /// **'Gửi liên kết đặt lại mật khẩu đến {email}?'**
  String resetPasswordConfirmation(String email);

  /// No description provided for @reminderBody.
  ///
  /// In vi, this message translates to:
  /// **'Đến giờ thực hiện: {title}'**
  String reminderBody(String title);

  /// No description provided for @categoryChartSummary.
  ///
  /// In vi, this message translates to:
  /// **'{tasks} công việc trong {categories} danh mục'**
  String categoryChartSummary(int tasks, int categories);

  /// No description provided for @overdueAt.
  ///
  /// In vi, this message translates to:
  /// **'Quá hạn · {time}'**
  String overdueAt(String time);

  /// No description provided for @dueAt.
  ///
  /// In vi, this message translates to:
  /// **'Hạn: {time}'**
  String dueAt(String time);

  /// No description provided for @calendarDate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {date}'**
  String calendarDate(String date);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
