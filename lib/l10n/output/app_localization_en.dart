// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localization.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Tickly';

  @override
  String get commonEmail => 'Email';

  @override
  String get commonPassword => 'Password';

  @override
  String get commonConfirmPassword => 'Confirm password';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSubmit => 'Confirm';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonSuccess => 'Success';

  @override
  String get commonError => 'Error';

  @override
  String get commonOr => 'OR';

  @override
  String get signInTitle => 'Welcome back!';

  @override
  String get signInDescription => 'Sign in to keep managing your tasks.';

  @override
  String get signInEmailHint => 'name@example.com';

  @override
  String get signInPasswordHint => 'Enter your password';

  @override
  String get signInButton => 'Sign in';

  @override
  String get signInLoading => 'Signing in...';

  @override
  String get signInForgotPassword => 'Forgot password?';

  @override
  String get signInNoAccount => 'Don\'t have an account?';

  @override
  String get signInSignUp => 'Sign up';

  @override
  String get signInWithGoogle => 'Continue with Google';

  @override
  String get signInSuccess => 'Signed in successfully';

  @override
  String get signInFailure => 'Couldn\'t sign in. Please try again.';

  @override
  String get signInInvalidCredentials => 'Incorrect email or password.';

  @override
  String get signUpTitle => 'Create an account';

  @override
  String get signUpDescription => 'Join Tickly and start organizing your day.';

  @override
  String get signUpEmailHint => 'name@example.com';

  @override
  String get signUpPasswordHint => 'At least 8 characters';

  @override
  String get signUpConfirmPasswordHint => 'Re-enter your password';

  @override
  String get signUpButton => 'Create account';

  @override
  String get signUpLoading => 'Creating account...';

  @override
  String get signUpAlreadyHaveAccount => 'Already have an account?';

  @override
  String get signUpSignIn => 'Sign in';

  @override
  String get signUpSuccess => 'Account created successfully';

  @override
  String get signUpFailure =>
      'Couldn\'t create your account. Please try again.';

  @override
  String get signUpEmailAlreadyInUse => 'This email is already in use.';

  @override
  String get signUpWeakPassword => 'The password is too weak.';

  @override
  String get signUpPasswordMismatch => 'Passwords don\'t match.';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get forgotPasswordHeading => 'Forgot your password?';

  @override
  String get forgotPasswordDescription =>
      'Enter your email to receive a password reset link.';

  @override
  String get forgotPasswordEmailLabel => 'Email address';

  @override
  String get forgotPasswordEmailHint => 'name@example.com';

  @override
  String get forgotPasswordSendButton => 'Send reset email';

  @override
  String get forgotPasswordSending => 'Sending email...';

  @override
  String get forgotPasswordBackToSignIn => 'Back to sign in';

  @override
  String get forgotPasswordSuccess =>
      'If this email belongs to an account, you\'ll receive a password reset link.';

  @override
  String get forgotPasswordFailure =>
      'Couldn\'t send the reset email. Please try again.';

  @override
  String get forgotPasswordCheckInbox =>
      'Please check your inbox or spam folder.';

  @override
  String get forgotPasswordEmailSentTitle => 'Check your email';

  @override
  String get forgotPasswordEmailSentDescription =>
      'Open the email and follow the link to create a new password.';

  @override
  String get verifyEmailTitle => 'Verify email';

  @override
  String get verifyEmailHeading => 'Verify your email address';

  @override
  String get verifyEmailSentTo => 'We\'ve sent a verification link to';

  @override
  String get verifyEmailDescription =>
      'Open your inbox and follow the verification link. Then return to Tickly to finish.';

  @override
  String get verifyEmailCheckButton => 'I\'ve verified my email';

  @override
  String get verifyEmailChecking => 'Checking...';

  @override
  String get verifyEmailResendButton => 'Resend verification email';

  @override
  String get verifyEmailResending => 'Resending...';

  @override
  String get verifyEmailSignOut => 'Sign out / Use another account';

  @override
  String get verifyEmailSuccess => 'Email verified successfully!';

  @override
  String get verifyEmailNotVerified =>
      'Your email hasn\'t been verified. Please follow the link in your inbox.';

  @override
  String get verifyEmailResendSuccess =>
      'Verification requested. Please check your email.';

  @override
  String get verifyEmailResendFailure =>
      'Couldn\'t resend the verification email.';

  @override
  String get verifyEmailCheckFailure =>
      'Couldn\'t check email verification status.';

  @override
  String get verifyEmailExpired =>
      'The verification link has expired or is invalid.';

  @override
  String get googleSignInSuccess => 'Signed in with Google';

  @override
  String get googleSignInFailure => 'Couldn\'t sign in with Google.';

  @override
  String get googleSignInCancelled => 'Google sign-in cancelled.';

  @override
  String get validationRequired => 'Please fill out this field';

  @override
  String get validationEmailRequired => 'Please enter your email';

  @override
  String get validationEmailInvalid => 'Enter a valid email address';

  @override
  String get validationPasswordRequired => 'Please enter your password';

  @override
  String get validationPasswordMinLength =>
      'Password must contain at least 8 characters';

  @override
  String get validationConfirmPasswordRequired =>
      'Please confirm your password';

  @override
  String get validationPasswordMismatch => 'Passwords don\'t match';

  @override
  String get validationNameRequired => 'Please enter your name';

  @override
  String get validationPhoneRequired => 'Please enter your phone number';

  @override
  String get validationPhoneInvalid => 'Enter a valid phone number';

  @override
  String get validationDateRequired => 'Please select your date of birth';

  @override
  String get validationDateInvalid => 'Enter a valid date of birth';

  @override
  String get authUserNotFound => 'Account not found.';

  @override
  String get authUserDisabled => 'This account has been disabled.';

  @override
  String get authTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get authNetworkError =>
      'Connection error. Please check your internet connection.';

  @override
  String get authSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get authEmailNotVerified =>
      'Please verify your email before continuing.';

  @override
  String get authUnknownError => 'Something went wrong. Please try again.';

  @override
  String get homeTitle => 'Home';

  @override
  String get homeWelcome => 'Welcome to Tickly!';

  @override
  String get homeDescription => 'Start organizing your tasks.';

  @override
  String get homeSignOut => 'Sign out';

  @override
  String get homeSignOutSuccess => 'Signed out successfully';

  @override
  String get taskReminders => 'Task reminders';

  @override
  String get reminderChannelDescription => 'Task reminders from Tickly';

  @override
  String get reminderTestBody => 'Test notification is working!';

  @override
  String get actionFailed => 'Something went wrong. Please try again.';

  @override
  String get authCheckFailed => 'Couldn\'t check sign-in status';

  @override
  String get welcomeGoodDay => 'A day well spent';

  @override
  String get welcomeDescription =>
      'Organize your tasks simply and clearly with Tickly.';

  @override
  String get welcomeStart => 'Get started';

  @override
  String get accountLoadFailed => 'Couldn\'t load account information.';

  @override
  String get fullName => 'Full name';

  @override
  String get emailAddressFallback => 'your email address';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get calendarTitle => 'Task calendar';

  @override
  String get today => 'Today';

  @override
  String get calendarMonth => 'Month';

  @override
  String get calendarWeek => 'Week';

  @override
  String get noTasksDue => 'No tasks due';

  @override
  String get categoryTooLarge =>
      'This category contains too many tasks to delete at once.';

  @override
  String get categoryLoadFailed => 'Couldn\'t load categories';

  @override
  String get connectionFailed => 'Couldn\'t connect. Please try again.';

  @override
  String get categoryCreateFailed => 'Couldn\'t create the category.';

  @override
  String get categoryUpdateFailed => 'Couldn\'t update the category.';

  @override
  String get categoryDeleteFailed => 'Couldn\'t delete the category.';

  @override
  String get signInRequired => 'Please sign in';

  @override
  String get categoryDeleteTitle => 'Delete category?';

  @override
  String get commonDelete => 'Delete';

  @override
  String get categoryEdit => 'Edit category';

  @override
  String get categoryDelete => 'Delete category';

  @override
  String get categoryEmptyTitle => 'No categories yet';

  @override
  String get categoryEmptyDescription =>
      'Create your first category to keep tasks organized.';

  @override
  String get categoryCreate => 'Create category';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get categoryAdd => 'Add category';

  @override
  String get categoryCreated => 'Category created';

  @override
  String get categoryUpdated => 'Category updated';

  @override
  String get categoryDeleted => 'Category deleted';

  @override
  String get actionSuccess => 'Done';

  @override
  String get allTasks => 'All tasks';

  @override
  String get filterAll => 'All';

  @override
  String get uncategorized => 'Uncategorized';

  @override
  String get categoryName => 'Category name';

  @override
  String get categoryNameHint => 'e.g. Study';

  @override
  String get categoryNameRequired => 'Please enter a category name';

  @override
  String get chooseColor => 'Choose color';

  @override
  String get commonSave => 'Save';

  @override
  String get categoriesLoading => 'Loading categories...';

  @override
  String get categoryNone => 'No category';

  @override
  String get searchAndFilter => 'Search and filter';

  @override
  String get accountTitle => 'Account';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get taskUpdateFailed => 'Couldn\'t update the task';

  @override
  String get taskLoadFailed => 'Couldn\'t load tasks';

  @override
  String get tasksEmptyTitle => 'No tasks yet';

  @override
  String get tasksEmptyDescription => 'Add your first task!';

  @override
  String get taskCreate => 'Create task';

  @override
  String get yourTasks => 'Your tasks';

  @override
  String get categoriesUnavailable =>
      'Couldn\'t load categories. Showing available tasks.';

  @override
  String get noMatchingTasks => 'No matching tasks';

  @override
  String get notificationPermissionHint =>
      'Please allow notifications for Tickly in your phone settings.';

  @override
  String get reminderUpdateFailed =>
      'Couldn\'t update reminders. Please try again.';

  @override
  String get profileTitle => 'Personal information';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get profileUpdateFailed =>
      'Couldn\'t update your profile. Please try again.';

  @override
  String get changePassword => 'Change password';

  @override
  String get sendLink => 'Send link';

  @override
  String get resetLinkSent => 'Link sent. Please check your email.';

  @override
  String get emailSendFailed => 'Couldn\'t send the email. Please try again.';

  @override
  String get signOutTitle => 'Sign out?';

  @override
  String get signOutConfirmation => 'Would you like to sign out of Tickly?';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get defaultUserName => 'Tickly user';

  @override
  String get applicationTitle => 'Application';

  @override
  String get languageTitle => 'Language';

  @override
  String get aboutTitle => 'About';

  @override
  String get appDescription =>
      'Simple task management to help you focus on what matters each day.';

  @override
  String get statisticsPageTitle => 'Task statistics';

  @override
  String get statisticsLoadFailed => 'Couldn\'t load statistics';

  @override
  String get categoryStatisticsFailed =>
      'Couldn\'t load the category breakdown. Please try again in Categories.';

  @override
  String get categoryStatisticsTitle => 'Tasks by category';

  @override
  String get statisticsTotal => 'total';

  @override
  String get categoryStatisticsEmpty =>
      'Add tasks to see the category breakdown.';

  @override
  String get completionPerformance => 'Completion performance';

  @override
  String get completionByDay => 'Tasks completed each day';

  @override
  String get periodSevenDays => '7 days';

  @override
  String get periodThirtyDays => '30 days';

  @override
  String get completionEmpty => 'No tasks completed during this period';

  @override
  String get statisticsOverview => 'Task overview';

  @override
  String get statisticsTotalTasks => 'Total tasks';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get completionProgress => 'Completion progress';

  @override
  String get taskCreated => 'Task created';

  @override
  String get taskCreateFailed => 'Couldn\'t create the task';

  @override
  String get taskUpdated => 'Task updated';

  @override
  String get taskStatusUpdated => 'Task status updated';

  @override
  String get taskToggleFailed => 'Couldn\'t change task status.';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get taskDeleteFailed => 'Couldn\'t delete the task';

  @override
  String get reminderMustBeFuture => 'Reminder time must be in the future';

  @override
  String get categoryNotConfirmed => 'Couldn\'t verify the selected category';

  @override
  String get categoryNoLongerExists => 'The selected category no longer exists';

  @override
  String get taskTitleLabel => 'Task title';

  @override
  String get taskTitleHint => 'e.g. Study Flutter BLoC';

  @override
  String get taskTitleRequired => 'Please enter a task title';

  @override
  String get taskDescriptionLabel => 'Description';

  @override
  String get taskDescriptionHint => 'Enter a task description...';

  @override
  String get priorityTitle => 'Priority';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get dueDateTime => 'Due date and time';

  @override
  String get notSelected => 'Not selected';

  @override
  String get reminderNotSet => 'No reminder set';

  @override
  String get removeReminder => 'Remove reminder';

  @override
  String get newReminderMustBeFuture =>
      'The new reminder time must be in the future';

  @override
  String get taskEdit => 'Edit task';

  @override
  String get removeDueDate => 'Remove due date';

  @override
  String get commonSaving => 'Saving...';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get taskDeleteTitle => 'Delete task?';

  @override
  String get categoryNotFound => 'Category not found';

  @override
  String get taskDetails => 'Task details';

  @override
  String get taskNotFound => 'Task not found';

  @override
  String get commonEdit => 'Edit';

  @override
  String get taskNoDescription => 'No description';

  @override
  String get markCompleted => 'Mark as completed';

  @override
  String get taskIsCompleted => 'This task is completed';

  @override
  String get taskIsPending => 'This task is pending';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get notSet => 'Not set';

  @override
  String get dueDate => 'Due date';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get createdDate => 'Created';

  @override
  String get lastUpdated => 'Last updated';

  @override
  String get sortNewest => 'Newest first';

  @override
  String get sortOldest => 'Oldest first';

  @override
  String get sortPriorityHigh => 'Highest priority';

  @override
  String get sortPriorityLow => 'Lowest priority';

  @override
  String get sortDueSoon => 'Earliest due date';

  @override
  String get sortDueLate => 'Latest due date';

  @override
  String get sortTasks => 'Sort tasks';

  @override
  String get taskSearchHint => 'Search tasks...';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get validationNumberInvalid => 'Please enter a valid number';

  @override
  String get validationPositiveInteger => 'Please enter a positive integer';

  @override
  String get validationOtp => 'Please enter a 6-digit code';

  @override
  String get inputDateOfBirth => 'Date of birth';

  @override
  String get inputNumber => 'Number';

  @override
  String get welcomeHeadline => 'Turn plans into\ndaily progress';

  @override
  String get taskDeleteConfirmation =>
      'Are you sure you want to delete this task?\n\nThis cannot be undone.';

  @override
  String taskCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
    );
    return '$_temp0';
  }

  @override
  String completedTaskCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks completed',
      one: '1 task completed',
    );
    return '$_temp0';
  }

  @override
  String completionCount(int completed, int total) {
    return '$completed/$total completed';
  }

  @override
  String categoryDeleteConfirmation(String name) {
    return 'Delete \"$name\"?\n\nIts tasks will be kept and moved to \"Uncategorized\".';
  }

  @override
  String resetPasswordConfirmation(String email) {
    return 'Send a password reset link to $email?';
  }

  @override
  String reminderBody(String title) {
    return 'Time for: $title';
  }

  @override
  String categoryChartSummary(int tasks, int categories) {
    String _temp0 = intl.Intl.pluralLogic(
      tasks,
      locale: localeName,
      other: '$tasks tasks',
      one: '1 task',
    );
    String _temp1 = intl.Intl.pluralLogic(
      categories,
      locale: localeName,
      other: '$categories categories',
      one: '1 category',
    );
    return '$_temp0 in $_temp1';
  }

  @override
  String overdueAt(String time) {
    return 'Overdue · $time';
  }

  @override
  String dueAt(String time) {
    return 'Due: $time';
  }

  @override
  String calendarDate(String date) {
    return '$date';
  }
}
