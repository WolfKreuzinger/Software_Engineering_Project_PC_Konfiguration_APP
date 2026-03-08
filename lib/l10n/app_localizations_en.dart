// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navConfigure => 'Configure';

  @override
  String get navSettings => 'Settings';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navComponents => 'Components';

  @override
  String get homeWelcome => 'Welcome to BuildMyPC';

  @override
  String get homeSubtitle => 'Plan, configure and build your dream PC.';

  @override
  String get homeConfigureButton => 'Configure PC';

  @override
  String get homeLoginButton => 'Sign In / Register';

  @override
  String get authTagline => 'Forge your ultimate battlestation';

  @override
  String get authEmailLabel => 'Email Address';

  @override
  String get authEmailHint => 'name@example.com';

  @override
  String get authEmailRequired => 'Please enter your email.';

  @override
  String get authEmailInvalid => 'Invalid email.';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authForgot => 'Forgot?';

  @override
  String get authPasswordRequired => 'Please enter a password.';

  @override
  String get authPasswordMinLength =>
      'Min. 8 characters, 1 special character, 1 uppercase letter, and 1 number.';

  @override
  String get authConfirmPasswordHint => 'Confirm password';

  @override
  String get authConfirmPasswordRequired => 'Please confirm your password.';

  @override
  String get authPasswordMismatch => 'Passwords do not match.';

  @override
  String get authEnterApp => 'Enter BuildMyPC';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authOrConnect => 'OR CONNECT USING';

  @override
  String get authGuest => 'Continue as Guest →';

  @override
  String get authTermsAgreement => 'By signing in, you agree to our ';

  @override
  String get authTermsLink => 'Terms of Service';

  @override
  String get authLoginSuccess => 'Login successful';

  @override
  String get authRegisterSuccess => 'Registration successful';

  @override
  String get authGoogleSuccess => 'Google login successful';

  @override
  String get authGuestSuccess => 'Continued as guest';

  @override
  String get authForgotPasswordValid => 'Please enter a valid email above.';

  @override
  String get authForgotPasswordSent =>
      'If an account exists, an email has been sent.';

  @override
  String get authResetRequiredAfterFailedLogins =>
      'Too many incorrect password attempts. Please use \"Forgot?\" to reset your password.';

  @override
  String get configureTitle => 'Configure PC';

  @override
  String get configurePlaceholder => 'Your configurator wizard goes here.';

  @override
  String get configureBuildTitle => 'Custom PC Builder';

  @override
  String get configureBuildProgress => 'Build Progress';

  @override
  String configurePartsCount(int done, int total) {
    return '$done / $total Parts';
  }

  @override
  String get configureTotalPrice => 'Total Price';

  @override
  String get configureEstimatedWattage => 'Estimated Wattage';

  @override
  String get configureAddToBuilds => 'ADD TO BUILDS';

  @override
  String get configureChoose => 'Choose';

  @override
  String get configureChange => 'Change';

  @override
  String get configureRemove => 'Remove';

  @override
  String get configureCatCpu => 'Processor (CPU)';

  @override
  String get configureCatCpuCooler => 'CPU Cooler';

  @override
  String get configureCatThermalPaste => 'Thermal Paste';

  @override
  String get configureCatMotherboard => 'Motherboard';

  @override
  String get configureCatRam => 'Memory (RAM)';

  @override
  String get configureCatGpu => 'Graphics Card (GPU)';

  @override
  String get configureCatStorage => 'Storage (SSD / HDD)';

  @override
  String get configureCatCase => 'Case';

  @override
  String get configureCatCaseFans => 'Case Fans';

  @override
  String get configureCatFanController => 'Fan Controller';

  @override
  String get configureCatCaseAccessories => 'Case Accessories';

  @override
  String get configureCatPsu => 'Power Supply (PSU)';

  @override
  String get configureCatWifi => 'Wireless Network Card';

  @override
  String get configureCatEthernet => 'Wired Network Card';

  @override
  String get configureCatSoundCard => 'Sound Card';

  @override
  String get configureCatOpticalDrive => 'Optical Drive';

  @override
  String get configureCatExternalHdd => 'External Hard Drive';

  @override
  String get configureCatUps => 'UPS';

  @override
  String get configureCatOs => 'Operating System';

  @override
  String get configureChooseCpu => 'Choose a CPU';

  @override
  String get configureChooseCpuCooler => 'Choose a CPU Cooler';

  @override
  String get configureChooseThermalPaste => 'Choose Thermal Paste';

  @override
  String get configureChooseMotherboard => 'Choose a Motherboard';

  @override
  String get configureChooseRam => 'Choose RAM';

  @override
  String get configureChooseGpu => 'Choose a GPU';

  @override
  String get configureChooseStorage => 'Choose Storage';

  @override
  String get configureChooseCase => 'Choose a Case';

  @override
  String get configureChooseCaseFans => 'Choose Case Fans';

  @override
  String get configureChooseFanController => 'Choose a Fan Controller';

  @override
  String get configureChooseCaseAccessories => 'Choose Accessories';

  @override
  String get configureChoosePsu => 'Choose a Power Supply';

  @override
  String get configureChooseWifi => 'Choose Wi-Fi';

  @override
  String get configureChooseEthernet => 'Choose Ethernet';

  @override
  String get configureChooseSoundCard => 'Choose a Sound Card';

  @override
  String get configureChooseOpticalDrive => 'Choose an Optical Drive';

  @override
  String get configureChooseExternalHdd => 'Choose External Storage';

  @override
  String get configureChooseUps => 'Choose a UPS';

  @override
  String get configureChooseOs => 'Choose an OS';

  @override
  String get partsTitle => 'Components';

  @override
  String get partsPlaceholder => 'Your component search/filter list goes here.';

  @override
  String get dashboardMyBuilds => 'My Builds';

  @override
  String get dashboardViewAll => 'View All';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAccountSecurity => 'Account & Security';

  @override
  String get settingsLegalSupport => 'Legal & Support';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsLight => 'Light';

  @override
  String get settingsDark => 'Dark';

  @override
  String get settingsGerman => 'German';

  @override
  String get settingsEnglish => 'English';

  @override
  String get settingsGuest => 'Guest';

  @override
  String get settingsNotLoggedIn => 'Not logged in';

  @override
  String get settingsEdit => 'Edit';

  @override
  String get settingsLogin => 'Login';

  @override
  String get settingsChangePassword => 'Change Password';

  @override
  String get settingsSignOut => 'Sign Out';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTermsOfService => 'Terms of Service';

  @override
  String get settingsContactSupport => 'Contact Support';

  @override
  String get settingsEditProfile => 'Edit Profile';

  @override
  String get settingsDisplayName => 'Display name';

  @override
  String get settingsEmail => 'E-Mail';

  @override
  String get settingsSave => 'Save';

  @override
  String get settingsResetPassword => 'Reset Password';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsSendEmail => 'Send email';

  @override
  String get settingsPasswordResetSent => 'Password reset email sent.';

  @override
  String get settingsError => 'Error';

  @override
  String get settingsGoogleAccountNote =>
      'Your account is linked with Google.\nPlease manage your password via your Google account.';

  @override
  String settingsPasswordResetBody(String email) {
    return 'We will send a password reset email to:\n\n$email';
  }

  @override
  String get settingsVersion => 'BuildMyPC v1.0.0';

  @override
  String get supportTitle => 'Contact Support';

  @override
  String get supportInfoBanner =>
      'Your request will be forwarded to our team via your email client.';

  @override
  String get supportSubjectLabel => 'Subject';

  @override
  String get supportSubjectRequired => 'Please select a subject';

  @override
  String get supportSubjectBug => 'Report Bug';

  @override
  String get supportSubjectFeature => 'Feature Request';

  @override
  String get supportSubjectGeneral => 'General Inquiry';

  @override
  String get supportSubjectFeedback => 'Feedback';

  @override
  String get supportMessageLabel => 'Message';

  @override
  String get supportMessageRequired => 'Please enter a message';

  @override
  String get supportSendButton => 'Send Request';

  @override
  String get supportReplyNote =>
      'Replies will be sent to your registered email address.';

  @override
  String get supportNoEmailClient =>
      'No email client found. Please send an email to buildmypc@gmx.de.';

  @override
  String supportEmailError(String error) {
    return 'Error opening email client: $error';
  }

  @override
  String get privacyTitle => 'Privacy Policy';

  @override
  String get privacySection1Title => '1. Controller';

  @override
  String get privacySection1Body =>
      'The development team of the Software Engineering Project is responsible for data processing in the BuildMyPC app. Contact: buildmypc@gmx.de';

  @override
  String get privacySection2Title => '2. Collected Data';

  @override
  String get privacySection2Body =>
      'The following data is processed when using the app:\n\n• Email address and display name (upon registration or Google sign-in)\n• Anonymously stored usage data to improve the app\n• Created PC configurations (only when logged in)';

  @override
  String get privacySection3Title => '3. Authentication';

  @override
  String get privacySection3Body =>
      'The app uses Firebase Authentication by Google LLC for user sign-in. When using Google sign-in, Google\'s privacy policy also applies (policies.google.com/privacy).\n\nYour credentials are transmitted and stored exclusively through secure Firebase services.';

  @override
  String get privacySection4Title => '4. Data Storage';

  @override
  String get privacySection4Body =>
      'User data is stored in Google Firebase (Cloud Firestore). Servers are located in the EU. Firebase is certified to ISO 27001 and SOC 2/3.\n\nData is stored as long as an active account exists. After account deletion, all personal data will be removed within 30 days.';

  @override
  String get privacySection5Title => '5. Data Sharing';

  @override
  String get privacySection5Body =>
      'Your data will not be shared with third parties, except for the Firebase services (Google LLC) required for the app to function.';

  @override
  String get privacySection6Title => '6. Your Rights';

  @override
  String get privacySection6Body =>
      'You have the right to:\n\n• Access your stored data\n• Correct inaccurate data\n• Delete your account and all associated data\n• Restrict processing\n• Data portability\n\nTo exercise your rights, contact: buildmypc@gmx.de';

  @override
  String get privacySection7Title => '7. Changes';

  @override
  String get privacySection7Body =>
      'We reserve the right to update this privacy policy as needed. The current version is always available in the app.';

  @override
  String get privacyDate => 'Last updated: February 2026';

  @override
  String get termsTitle => 'Terms of Service';

  @override
  String get termsSection1Title => '1. Scope';

  @override
  String get termsSection1Body =>
      'These terms of service apply to the use of the BuildMyPC app. By using the app, you agree to these terms.';

  @override
  String get termsSection2Title => '2. Service Description';

  @override
  String get termsSection2Body =>
      'BuildMyPC is an app to support the planning and configuration of PC systems. The app provides information on hardware components and allows users to create PC configurations.\n\nThe app is developed and provided as part of a university Software Engineering project.';

  @override
  String get termsSection3Title => '3. User Account';

  @override
  String get termsSection3Body =>
      'Certain features require registration. You are obligated to keep your credentials confidential and notify us immediately if you detect misuse of your account.\n\nEach person may only create one account. Accounts are non-transferable.';

  @override
  String get termsSection4Title => '4. Usage Rights';

  @override
  String get termsSection4Body =>
      'The app may only be used for private and non-commercial purposes. Copying, modifying, distributing, or using the app for commercial purposes is not permitted.';

  @override
  String get termsSection5Title => '5. Availability';

  @override
  String get termsSection5Body =>
      'We strive for the highest possible availability of the app but do not guarantee uninterrupted use. Maintenance work and technical issues may temporarily limit availability.';

  @override
  String get termsSection6Title => '6. Disclaimer';

  @override
  String get termsSection6Body =>
      'The information on hardware components and prices provided in the app is without warranty. We accept no liability for the accuracy, completeness, or timeliness of the information.\n\nPurchase decisions are solely the responsibility of the user.';

  @override
  String get termsSection7Title => '7. Changes';

  @override
  String get termsSection7Body =>
      'We reserve the right to change these terms of service at any time. Registered users will be informed of significant changes. Continued use of the app constitutes acceptance of the changed terms.';

  @override
  String get termsSection8Title => '8. Contact';

  @override
  String get termsSection8Body =>
      'For questions about these terms of service, contact:\nbuildmypc@gmx.de';

  @override
  String get termsDate => 'Last updated: February 2026';

  @override
  String get compatibilityOk => 'COMPATIBILITY: OK';

  @override
  String get compatibilityWarning => 'COMPATIBILITY WARNING';

  @override
  String get compatibilityError => 'COMPATIBILITY ERROR';

  @override
  String get compatibilityViewDetails => 'DETAILS';

  @override
  String get compatibilityDetails => 'Compatibility Details';

  @override
  String get compatibilityNoIssues => 'All checked components are compatible.';
}
