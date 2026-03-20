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
  String get authLogin => 'Login';

  @override
  String get authRegister => 'Register';

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
  String get resetPasswordTitle => 'Set new password';

  @override
  String get resetPasswordSubtitle =>
      'Min. 8 characters, 1 special character, 1 uppercase letter, and 1 number.';

  @override
  String get resetPasswordSave => 'Save password';

  @override
  String get resetPasswordSuccessTitle => 'Password changed!';

  @override
  String get resetPasswordSuccessBody =>
      'Your password has been reset successfully. You can now sign in.';

  @override
  String get resetPasswordGoToLogin => 'Go to login';

  @override
  String get settingsCurrentPassword => 'Current Password';

  @override
  String get settingsNewPassword => 'New Password';

  @override
  String get settingsCurrentPasswordRequired =>
      'Please enter your current password.';

  @override
  String get settingsPasswordChanged => 'Password changed successfully.';

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

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRename => 'Rename';

  @override
  String get commonDuplicate => 'Duplicate';

  @override
  String get commonView => 'View';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get buildDialogEditTitle => 'Edit Build';

  @override
  String get buildDialogNameHint => 'Build Name';

  @override
  String get buildDialogCoverLabel => 'Cover Image (optional)';

  @override
  String get buildDialogDuplicateTitle => 'Duplicate Build';

  @override
  String get buildDialogDuplicateNameHint => 'Name of Duplicate';

  @override
  String buildDialogCopyOf(String title) {
    return 'Copy of $title';
  }

  @override
  String get buildDialogDeleteTitle => 'Delete Build';

  @override
  String buildDialogDeleteContent(String title) {
    return 'Delete \"$title\" permanently?';
  }

  @override
  String buildDialogSaved(String title) {
    return '\"$title\" was saved.';
  }

  @override
  String buildDialogDuplicateError(String error) {
    return 'Error duplicating: $error';
  }

  @override
  String get buildsNoBuilds => 'No builds saved yet';

  @override
  String get buildsStartNew => 'Start new build';

  @override
  String get buildsSignInPrompt => 'Sign in to see your builds.';

  @override
  String get myBuildsTitle => 'My Builds';

  @override
  String get myBuildsSearchHint => 'Search your builds…';

  @override
  String get myBuildsFilters => 'Filters';

  @override
  String get myBuildsFilterAll => 'All builds';

  @override
  String get myBuildsFilterCompleted => 'Completed';

  @override
  String get myBuildsFilterInProgress => 'In Progress';

  @override
  String get myBuildsFilterImported => 'Imported';

  @override
  String get buildStatusCompleted => 'COMPLETED';

  @override
  String get buildStatusDraft => 'DRAFT';

  @override
  String get buildStatusArchived => 'ARCHIVED';

  @override
  String get buildStatusInProgress => 'IN PROGRESS';

  @override
  String get buildStatusImported => 'IMPORTED';

  @override
  String get buildCardEstimatedCost => 'ESTIMATED COST';

  @override
  String get buildCardProgress => 'PROGRESS';

  @override
  String get buildCardShare => 'Share';

  @override
  String get buildCardMore => 'More';

  @override
  String get templateTitle => 'Build Templates';

  @override
  String get templateDescription =>
      'Choose a template as a starting point for your build. All components can be freely adjusted afterwards.';

  @override
  String get templateBudgetGamingTagline =>
      'Maximum performance on a tight budget';

  @override
  String get templateHighEndGamingTagline =>
      'Uncompromising performance for 4K & 144 Hz';

  @override
  String get templateOfficeTagline =>
      'Reliable and efficient for everyday office use';

  @override
  String get templateWorkstationTagline =>
      'Professional power for demanding tasks';

  @override
  String get templateMiniItxTagline =>
      'Maximum performance in the smallest form factor';

  @override
  String get templateSilentTagline => 'Quiet as a library – maximum comfort';

  @override
  String get sharedLinkCopied => 'Link copied!';

  @override
  String get sharedBuildNotFound => 'Build not found';

  @override
  String get sharedBuildNotFoundDesc =>
      'This link is invalid or has not been shared yet.';

  @override
  String get shareTitle => 'Share Build';

  @override
  String get shareReadOnly => 'View only';

  @override
  String get shareGenerating => 'Generating link…';

  @override
  String get shareGeneratingError => 'Error generating';

  @override
  String get shareCopy => 'Copy';

  @override
  String get shareDirectSection => 'SHARE DIRECTLY';

  @override
  String get shareInstagramCopied =>
      'Link copied – paste it in an Instagram DM.';

  @override
  String get shareCouldNotOpen => 'Could not be opened.';

  @override
  String shareMessageText(String title, String url) {
    return 'Check out my PC build \"$title\": $url';
  }

  @override
  String shareEmailSubject(String title) {
    return 'BuildMyPC – $title';
  }

  @override
  String get partsSearchHint => 'Search parts';

  @override
  String partsProductsFound(int count) {
    return '$count Products Found';
  }

  @override
  String get partsNoProductsFound => '0 Products Found';

  @override
  String get partsComponentType => 'Component Type';

  @override
  String get partsSpecs => 'Specs';

  @override
  String get partsSort => 'Sort';

  @override
  String get partsOrder => 'Order';

  @override
  String get partsNoData => 'No data loaded';

  @override
  String get partsNoDataSubtitle => 'No parts found in any collection.';

  @override
  String get partsNoResults => 'No results';

  @override
  String get partsNoResultsSubtitle => 'Try adjusting filters or search.';

  @override
  String get partsLoadMore => 'Load More';

  @override
  String get partsAddToConfig => 'Add to Configuration';

  @override
  String get partsNoSpecs => 'No specs available.';

  @override
  String get partsDataCompleteness => 'Data Completeness';

  @override
  String get partsDataCompletenessHint =>
      'Filter components by completeness of spec data';

  @override
  String get partsShowAll => 'Show all';

  @override
  String get partsCompatibilityOnly => 'Compatibility';

  @override
  String get partsAllComponents => 'All Components';

  @override
  String get partsSortPriceLowToHigh => 'Price: Low to High';

  @override
  String get partsSortPriceHighToLow => 'Price: High to Low';

  @override
  String get partsSortNameAtoZ => 'Name: A to Z';

  @override
  String get partsPriceRange => 'Price Range';

  @override
  String get configureSelectComponent =>
      'Select at least one component to save a build.';

  @override
  String get configureSignInPrompt =>
      'Please sign in. Your build will be saved automatically.';

  @override
  String configureSaveBuildError(String error) {
    return 'Could not save build: $error';
  }

  @override
  String get configureSaveBuildTitle => 'Save Build';

  @override
  String get configureSaving => 'SAVING...';

  @override
  String get configureAddToMyBuilds => 'ADD TO MY BUILDS';

  @override
  String configureMissingData(String slot, String fields) {
    return '$slot: Missing Data – $fields';
  }

  @override
  String configureMissingDataTooltip(String fields) {
    return 'Missing Data: $fields';
  }

  @override
  String get configureAdd => 'Add';

  @override
  String get configureExtras => 'EXTRAS';

  @override
  String configureSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String configureImportedFrom(String title, String author) {
    return '$title by $author';
  }

  @override
  String get compatIncompatible => 'Incompatible';

  @override
  String get compatSingleError => '1 critical error';

  @override
  String compatMultipleErrors(int count) {
    return '$count critical errors';
  }

  @override
  String get compatSingleWarning => '1 warning detected';

  @override
  String compatMultipleWarnings(int count) {
    return '$count warnings detected';
  }

  @override
  String get compatWarning => 'Warning';

  @override
  String get compatCompatible => 'Compatible';

  @override
  String get compatAllCompatible => 'All components are compatible';

  @override
  String get compatOverallStatus => 'OVERALL STATUS';

  @override
  String get guidedCardHeader => 'BUILD TEMPLATES';

  @override
  String get guidedCardDescription =>
      'Start with a preconfigured template – Budget Gaming, Office, High-End or Workstation.';

  @override
  String get guidedCardButton => 'Choose Template';

  @override
  String get startNewBuildTitle => 'Start New Build';

  @override
  String get startNewBuildSubtitle => 'Manual · Component Selection';

  @override
  String get partsSpecsReset => 'Reset';

  @override
  String get partsSpecsAny => 'Any';

  @override
  String get specLabelSize => 'Size';

  @override
  String get specLabelAirflow => 'Airflow';

  @override
  String get specLabelChannels => 'Channels';

  @override
  String get specLabelChannelWattage => 'Channel Wattage';

  @override
  String get specLabelMemory => 'Memory';

  @override
  String get specLabelEfficiency => 'Efficiency';

  @override
  String get specLabelBluRayRead => 'Blu-ray Read';

  @override
  String get specLabelBluRayWrite => 'Blu-ray Write';

  @override
  String get specLabelDvdRead => 'DVD Read';

  @override
  String get specLabelDvdWrite => 'DVD Write';

  @override
  String get specLabelCdRead => 'CD Read';

  @override
  String get specLabelCdWrite => 'CD Write';

  @override
  String get specLabelMode => 'Mode';

  @override
  String get specLabelCapacityVa => 'Capacity (VA)';

  @override
  String get specLabelCapacityW => 'Capacity (W)';

  @override
  String get specLabelProtocol => 'Protocol';

  @override
  String get specLabelSampleRate => 'Sample Rate';

  @override
  String get specLabelSnr => 'SNR';

  @override
  String get specLabelDigitalAudio => 'Digital Audio';

  @override
  String get specLabelAmount => 'Amount';

  @override
  String get specLabelInternal35Bays => 'Internal 3.5\" Bays';

  @override
  String get partsTypeCpuCooler => 'CPU Cooler';

  @override
  String get partsTypeStorage => 'Storage';

  @override
  String get partsTypePowerSupply => 'Power Supply';

  @override
  String get partsTypeCase => 'Case';

  @override
  String get partsTypeCaseFan => 'Case Fan';

  @override
  String get partsTypeEthernetCard => 'Ethernet Card';

  @override
  String get partsTypeWifiCard => 'Wi-Fi Card';

  @override
  String get partsTypeSoundCard => 'Sound Card';

  @override
  String get partsTypeOpticalDrive => 'Optical Drive';

  @override
  String get partsTypeFanController => 'Fan Controller';

  @override
  String get partsTypeThermalPaste => 'Thermal Paste';

  @override
  String get partsTypeExternalStorage => 'External Storage';

  @override
  String get partsTypeUps => 'UPS';

  @override
  String get partsTypeCaseAccessory => 'Case Accessory';

  @override
  String get specLabelBrand => 'Brand';

  @override
  String get specLabelCoreCount => 'Core Count';

  @override
  String get specLabelCoreClock => 'Core Clock';

  @override
  String get specLabelBoostClock => 'Boost Clock';

  @override
  String get specLabelMicroarchitecture => 'Microarchitecture';

  @override
  String get specLabelIntegratedGraphics => 'Integrated Graphics';

  @override
  String get specLabelChipset => 'Chipset';

  @override
  String get specLabelColor => 'Color';

  @override
  String get specLabelVram => 'VRAM';

  @override
  String get specLabelLength => 'Length';

  @override
  String get specLabelDdrGeneration => 'DDR Generation';

  @override
  String get specLabelModules => 'Modules';

  @override
  String get specLabelModuleSize => 'Module Size';

  @override
  String get specLabelSpeed => 'Speed';

  @override
  String get specLabelCasLatency => 'CAS Latency';

  @override
  String get specLabelFirstWordLatency => 'First Word Latency';

  @override
  String get specLabelPricePerGb => 'Price / GB';

  @override
  String get specLabelCapacity => 'Capacity';

  @override
  String get specLabelFormFactor => 'Form Factor';

  @override
  String get specLabelInterface => 'Interface';

  @override
  String get specLabelSocket => 'Socket';

  @override
  String get specLabelMaxMemory => 'Max Memory';

  @override
  String get specLabelMemorySlots => 'Memory Slots';

  @override
  String get specLabelType => 'Type';

  @override
  String get specLabelWattage => 'Wattage';

  @override
  String get specLabelEfficiencyCertification => 'Efficiency Certification';

  @override
  String get specLabelNoiseLevel => 'Noise Level';

  @override
  String get specLabelRpm => 'RPM';

  @override
  String get specLabelSidePanel => 'Side Panel';

  @override
  String get specLabelIncludedPsu => 'Included PSU';

  @override
  String get specLabelExternalVolume => 'External Volume';

  @override
  String get specLabelBays35 => '3.5\" Bays';

  @override
  String compatPowerLoad(int percent) {
    return '$percent% Utilization';
  }

  @override
  String compatPowerBuffer(int watts) {
    return '${watts}W buffer';
  }

  @override
  String compatPowerInsufficient(int watts) {
    return '${watts}W too low';
  }

  @override
  String get compatCriticalErrors => 'Critical Errors';

  @override
  String get compatWarnings => 'Warnings';

  @override
  String compatMissingRequiredParts(String parts) {
    return 'Missing required components: $parts.';
  }

  @override
  String compatSocketMismatch(String cpuSocket, String mbSocket) {
    return 'Processor socket ($cpuSocket) is incompatible with the motherboard ($mbSocket).';
  }

  @override
  String compatSocketOk(String socket) {
    return 'Processor and motherboard have compatible sockets ($socket).';
  }

  @override
  String compatDdr5Required(String socket, int ddrGen) {
    return 'The motherboard ($socket) only supports DDR5 RAM – DDR$ddrGen is selected.';
  }

  @override
  String compatDdr4Required(String socket, int ddrGen) {
    return 'The motherboard ($socket) only supports DDR4 RAM – DDR$ddrGen is selected.';
  }

  @override
  String compatRamOk(int ddrGen) {
    return 'RAM (DDR$ddrGen) is compatible with the motherboard.';
  }

  @override
  String compatFormFactorIncompatible(String formFactor) {
    return 'The case does not support the motherboard’s form factor ($formFactor).';
  }

  @override
  String compatFormFactorOk(String formFactor) {
    return 'The motherboard ($formFactor) is compatible with the case.';
  }

  @override
  String compatPsuInsufficient(int psuW, int estimatedW) {
    return 'The power supply (${psuW}W) is insufficient for the estimated draw (~${estimatedW}W).';
  }

  @override
  String compatPsuLowBuffer(int psuW, int estimatedW) {
    return 'PSU buffer low: ${psuW}W for ~${estimatedW}W draw – at least 20% reserve recommended.';
  }

  @override
  String compatPsuAdequate(int psuW, int estimatedW) {
    return 'The power supply (${psuW}W) has adequate reserve for the estimated draw (~${estimatedW}W).';
  }

  @override
  String get compatBiosUpdateAmd =>
      'Ryzen 9000 on non-X870 board: a BIOS update may be required before the CPU is recognized.';

  @override
  String get compatBiosUpdateIntel =>
      'Intel 14th-gen on 600-series board: BIOS update required before the CPU is recognized.';

  @override
  String compatXmpRequired(int ramMhz, int jedecMhz) {
    return 'RAM running at ${ramMhz}MHz above JEDEC standard (${jedecMhz}MHz) – XMP/EXPO must be enabled in BIOS.';
  }

  @override
  String get compatDdr5BudgetBoard =>
      'DDR5 on budget board: stability issues may occur at high speeds – check the motherboard’s QVL list.';

  @override
  String compatTooManyRamSticks(int totalSticks, int maxSlots) {
    return '$totalSticks RAM sticks selected, but the motherboard only supports $maxSlots slots.';
  }

  @override
  String compatRamSlotsOk(int totalSticks, int maxSlots) {
    return 'The $totalSticks selected RAM sticks fit into the motherboard’s $maxSlots slots.';
  }
}
