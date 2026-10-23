import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  static const List<Locale> supportedLocales = <Locale>[Locale('vi')];

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
      <String>['vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
