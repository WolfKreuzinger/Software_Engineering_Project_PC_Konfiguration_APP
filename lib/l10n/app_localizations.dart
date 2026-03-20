import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @navHome.
  ///
  /// In de, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navConfigure.
  ///
  /// In de, this message translates to:
  /// **'Konfigurieren'**
  String get navConfigure;

  /// No description provided for @navSettings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get navSettings;

  /// No description provided for @navDashboard.
  ///
  /// In de, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navComponents.
  ///
  /// In de, this message translates to:
  /// **'Komponenten'**
  String get navComponents;

  /// No description provided for @homeWelcome.
  ///
  /// In de, this message translates to:
  /// **'Willkommen bei BuildMyPC'**
  String get homeWelcome;

  /// No description provided for @homeSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Plane, konfiguriere und baue deinen Traum-PC.'**
  String get homeSubtitle;

  /// No description provided for @homeConfigureButton.
  ///
  /// In de, this message translates to:
  /// **'PC konfigurieren'**
  String get homeConfigureButton;

  /// No description provided for @homeLoginButton.
  ///
  /// In de, this message translates to:
  /// **'Anmelden / Registrieren'**
  String get homeLoginButton;

  /// No description provided for @authTagline.
  ///
  /// In de, this message translates to:
  /// **'Forge your ultimate battlestation'**
  String get authTagline;

  /// No description provided for @authEmailLabel.
  ///
  /// In de, this message translates to:
  /// **'E-Mail-Adresse'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In de, this message translates to:
  /// **'name@beispiel.de'**
  String get authEmailHint;

  /// No description provided for @authEmailRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte E-Mail eingeben.'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In de, this message translates to:
  /// **'Ungültige E-Mail.'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordLabel.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get authPasswordLabel;

  /// No description provided for @authForgot.
  ///
  /// In de, this message translates to:
  /// **'Vergessen?'**
  String get authForgot;

  /// No description provided for @authPasswordRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte Passwort eingeben.'**
  String get authPasswordRequired;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In de, this message translates to:
  /// **'Mind. 8 Zeichen, 1 Sonderzeichen, 1 Großbuchstabe und 1 Zahl.'**
  String get authPasswordMinLength;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In de, this message translates to:
  /// **'Passwort bestätigen'**
  String get authConfirmPasswordHint;

  /// No description provided for @authConfirmPasswordRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte Passwort bestätigen.'**
  String get authConfirmPasswordRequired;

  /// No description provided for @authPasswordMismatch.
  ///
  /// In de, this message translates to:
  /// **'Passwörter stimmen nicht überein.'**
  String get authPasswordMismatch;

  /// No description provided for @authEnterApp.
  ///
  /// In de, this message translates to:
  /// **'Enter BuildMyPC'**
  String get authEnterApp;

  /// No description provided for @authCreateAccount.
  ///
  /// In de, this message translates to:
  /// **'Konto erstellen'**
  String get authCreateAccount;

  /// No description provided for @authOrConnect.
  ///
  /// In de, this message translates to:
  /// **'ODER VERBINDEN MIT'**
  String get authOrConnect;

  /// No description provided for @authGuest.
  ///
  /// In de, this message translates to:
  /// **'Als Gast fortfahren →'**
  String get authGuest;

  /// No description provided for @authTermsAgreement.
  ///
  /// In de, this message translates to:
  /// **'Mit der Anmeldung stimmst du unseren '**
  String get authTermsAgreement;

  /// No description provided for @authTermsLink.
  ///
  /// In de, this message translates to:
  /// **'Nutzungsbedingungen'**
  String get authTermsLink;

  /// No description provided for @authLoginSuccess.
  ///
  /// In de, this message translates to:
  /// **'Login erfolgreich'**
  String get authLoginSuccess;

  /// No description provided for @authRegisterSuccess.
  ///
  /// In de, this message translates to:
  /// **'Registrierung erfolgreich'**
  String get authRegisterSuccess;

  /// No description provided for @authGoogleSuccess.
  ///
  /// In de, this message translates to:
  /// **'Google Login erfolgreich'**
  String get authGoogleSuccess;

  /// No description provided for @authGuestSuccess.
  ///
  /// In de, this message translates to:
  /// **'Als Gast fortgefahren'**
  String get authGuestSuccess;

  /// No description provided for @authForgotPasswordValid.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib oben eine gültige E-Mail ein.'**
  String get authForgotPasswordValid;

  /// No description provided for @authForgotPasswordSent.
  ///
  /// In de, this message translates to:
  /// **'Wenn ein Konto existiert, wurde eine E-Mail gesendet.'**
  String get authForgotPasswordSent;

  /// No description provided for @authResetRequiredAfterFailedLogins.
  ///
  /// In de, this message translates to:
  /// **'Zu viele falsche Passwortversuche. Bitte nutze \"Vergessen?\", um dein Passwort zurückzusetzen.'**
  String get authResetRequiredAfterFailedLogins;

  /// No description provided for @authLogin.
  ///
  /// In de, this message translates to:
  /// **'Anmelden'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In de, this message translates to:
  /// **'Registrieren'**
  String get authRegister;

  /// No description provided for @configureTitle.
  ///
  /// In de, this message translates to:
  /// **'PC konfigurieren'**
  String get configureTitle;

  /// No description provided for @configurePlaceholder.
  ///
  /// In de, this message translates to:
  /// **'Hier kommt euer Wizard / Konfigurator rein.'**
  String get configurePlaceholder;

  /// No description provided for @configureBuildTitle.
  ///
  /// In de, this message translates to:
  /// **'PC-Konfigurator'**
  String get configureBuildTitle;

  /// No description provided for @configureBuildProgress.
  ///
  /// In de, this message translates to:
  /// **'Build-Fortschritt'**
  String get configureBuildProgress;

  /// No description provided for @configurePartsCount.
  ///
  /// In de, this message translates to:
  /// **'{done} / {total} Teile'**
  String configurePartsCount(int done, int total);

  /// No description provided for @configureTotalPrice.
  ///
  /// In de, this message translates to:
  /// **'Gesamtpreis'**
  String get configureTotalPrice;

  /// No description provided for @configureEstimatedWattage.
  ///
  /// In de, this message translates to:
  /// **'Geschätzter Verbrauch'**
  String get configureEstimatedWattage;

  /// No description provided for @configureAddToBuilds.
  ///
  /// In de, this message translates to:
  /// **'ZU BUILDS HINZUFÜGEN'**
  String get configureAddToBuilds;

  /// No description provided for @configureChoose.
  ///
  /// In de, this message translates to:
  /// **'Auswählen'**
  String get configureChoose;

  /// No description provided for @configureChange.
  ///
  /// In de, this message translates to:
  /// **'Ändern'**
  String get configureChange;

  /// No description provided for @configureRemove.
  ///
  /// In de, this message translates to:
  /// **'Entfernen'**
  String get configureRemove;

  /// No description provided for @configureCatCpu.
  ///
  /// In de, this message translates to:
  /// **'Prozessor (CPU)'**
  String get configureCatCpu;

  /// No description provided for @configureCatCpuCooler.
  ///
  /// In de, this message translates to:
  /// **'CPU-Kühler'**
  String get configureCatCpuCooler;

  /// No description provided for @configureCatThermalPaste.
  ///
  /// In de, this message translates to:
  /// **'Wärmeleitpaste'**
  String get configureCatThermalPaste;

  /// No description provided for @configureCatMotherboard.
  ///
  /// In de, this message translates to:
  /// **'Mainboard'**
  String get configureCatMotherboard;

  /// No description provided for @configureCatRam.
  ///
  /// In de, this message translates to:
  /// **'Arbeitsspeicher (RAM)'**
  String get configureCatRam;

  /// No description provided for @configureCatGpu.
  ///
  /// In de, this message translates to:
  /// **'Grafikkarte (GPU)'**
  String get configureCatGpu;

  /// No description provided for @configureCatStorage.
  ///
  /// In de, this message translates to:
  /// **'Speicher (SSD / HDD)'**
  String get configureCatStorage;

  /// No description provided for @configureCatCase.
  ///
  /// In de, this message translates to:
  /// **'Gehäuse'**
  String get configureCatCase;

  /// No description provided for @configureCatCaseFans.
  ///
  /// In de, this message translates to:
  /// **'Gehäuselüfter'**
  String get configureCatCaseFans;

  /// No description provided for @configureCatFanController.
  ///
  /// In de, this message translates to:
  /// **'Lüftersteuerung'**
  String get configureCatFanController;

  /// No description provided for @configureCatCaseAccessories.
  ///
  /// In de, this message translates to:
  /// **'Gehäuse-Zubehör'**
  String get configureCatCaseAccessories;

  /// No description provided for @configureCatPsu.
  ///
  /// In de, this message translates to:
  /// **'Netzteil (PSU)'**
  String get configureCatPsu;

  /// No description provided for @configureCatWifi.
  ///
  /// In de, this message translates to:
  /// **'WLAN-Karte'**
  String get configureCatWifi;

  /// No description provided for @configureCatEthernet.
  ///
  /// In de, this message translates to:
  /// **'LAN-Karte'**
  String get configureCatEthernet;

  /// No description provided for @configureCatSoundCard.
  ///
  /// In de, this message translates to:
  /// **'Soundkarte'**
  String get configureCatSoundCard;

  /// No description provided for @configureCatOpticalDrive.
  ///
  /// In de, this message translates to:
  /// **'Optisches Laufwerk'**
  String get configureCatOpticalDrive;

  /// No description provided for @configureCatExternalHdd.
  ///
  /// In de, this message translates to:
  /// **'Externe Festplatte'**
  String get configureCatExternalHdd;

  /// No description provided for @configureCatUps.
  ///
  /// In de, this message translates to:
  /// **'USV'**
  String get configureCatUps;

  /// No description provided for @configureCatOs.
  ///
  /// In de, this message translates to:
  /// **'Betriebssystem'**
  String get configureCatOs;

  /// No description provided for @configureChooseCpu.
  ///
  /// In de, this message translates to:
  /// **'CPU auswählen'**
  String get configureChooseCpu;

  /// No description provided for @configureChooseCpuCooler.
  ///
  /// In de, this message translates to:
  /// **'CPU-Kühler auswählen'**
  String get configureChooseCpuCooler;

  /// No description provided for @configureChooseThermalPaste.
  ///
  /// In de, this message translates to:
  /// **'Wärmeleitpaste auswählen'**
  String get configureChooseThermalPaste;

  /// No description provided for @configureChooseMotherboard.
  ///
  /// In de, this message translates to:
  /// **'Mainboard auswählen'**
  String get configureChooseMotherboard;

  /// No description provided for @configureChooseRam.
  ///
  /// In de, this message translates to:
  /// **'RAM auswählen'**
  String get configureChooseRam;

  /// No description provided for @configureChooseGpu.
  ///
  /// In de, this message translates to:
  /// **'Grafikkarte auswählen'**
  String get configureChooseGpu;

  /// No description provided for @configureChooseStorage.
  ///
  /// In de, this message translates to:
  /// **'Speicher auswählen'**
  String get configureChooseStorage;

  /// No description provided for @configureChooseCase.
  ///
  /// In de, this message translates to:
  /// **'Gehäuse auswählen'**
  String get configureChooseCase;

  /// No description provided for @configureChooseCaseFans.
  ///
  /// In de, this message translates to:
  /// **'Gehäuselüfter auswählen'**
  String get configureChooseCaseFans;

  /// No description provided for @configureChooseFanController.
  ///
  /// In de, this message translates to:
  /// **'Lüftersteuerung auswählen'**
  String get configureChooseFanController;

  /// No description provided for @configureChooseCaseAccessories.
  ///
  /// In de, this message translates to:
  /// **'Zubehör auswählen'**
  String get configureChooseCaseAccessories;

  /// No description provided for @configureChoosePsu.
  ///
  /// In de, this message translates to:
  /// **'Netzteil auswählen'**
  String get configureChoosePsu;

  /// No description provided for @configureChooseWifi.
  ///
  /// In de, this message translates to:
  /// **'WLAN-Karte auswählen'**
  String get configureChooseWifi;

  /// No description provided for @configureChooseEthernet.
  ///
  /// In de, this message translates to:
  /// **'LAN-Karte auswählen'**
  String get configureChooseEthernet;

  /// No description provided for @configureChooseSoundCard.
  ///
  /// In de, this message translates to:
  /// **'Soundkarte auswählen'**
  String get configureChooseSoundCard;

  /// No description provided for @configureChooseOpticalDrive.
  ///
  /// In de, this message translates to:
  /// **'Optisches Laufwerk auswählen'**
  String get configureChooseOpticalDrive;

  /// No description provided for @configureChooseExternalHdd.
  ///
  /// In de, this message translates to:
  /// **'Externe Festplatte auswählen'**
  String get configureChooseExternalHdd;

  /// No description provided for @configureChooseUps.
  ///
  /// In de, this message translates to:
  /// **'USV auswählen'**
  String get configureChooseUps;

  /// No description provided for @configureChooseOs.
  ///
  /// In de, this message translates to:
  /// **'Betriebssystem auswählen'**
  String get configureChooseOs;

  /// No description provided for @partsTitle.
  ///
  /// In de, this message translates to:
  /// **'Komponenten'**
  String get partsTitle;

  /// No description provided for @partsPlaceholder.
  ///
  /// In de, this message translates to:
  /// **'Hier kommt eure Komponenten-Suche/Filterliste rein.'**
  String get partsPlaceholder;

  /// No description provided for @dashboardMyBuilds.
  ///
  /// In de, this message translates to:
  /// **'Meine Builds'**
  String get dashboardMyBuilds;

  /// No description provided for @dashboardViewAll.
  ///
  /// In de, this message translates to:
  /// **'Alle ansehen'**
  String get dashboardViewAll;

  /// No description provided for @settingsAppearance.
  ///
  /// In de, this message translates to:
  /// **'Darstellung'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get settingsLanguage;

  /// No description provided for @settingsAccountSecurity.
  ///
  /// In de, this message translates to:
  /// **'Konto & Sicherheit'**
  String get settingsAccountSecurity;

  /// No description provided for @settingsLegalSupport.
  ///
  /// In de, this message translates to:
  /// **'Rechtliches & Support'**
  String get settingsLegalSupport;

  /// No description provided for @settingsTheme.
  ///
  /// In de, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsLight.
  ///
  /// In de, this message translates to:
  /// **'Hell'**
  String get settingsLight;

  /// No description provided for @settingsDark.
  ///
  /// In de, this message translates to:
  /// **'Dunkel'**
  String get settingsDark;

  /// No description provided for @settingsGerman.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get settingsGerman;

  /// No description provided for @settingsEnglish.
  ///
  /// In de, this message translates to:
  /// **'English'**
  String get settingsEnglish;

  /// No description provided for @settingsGuest.
  ///
  /// In de, this message translates to:
  /// **'Gast'**
  String get settingsGuest;

  /// No description provided for @settingsNotLoggedIn.
  ///
  /// In de, this message translates to:
  /// **'Nicht eingeloggt'**
  String get settingsNotLoggedIn;

  /// No description provided for @settingsEdit.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get settingsEdit;

  /// No description provided for @settingsLogin.
  ///
  /// In de, this message translates to:
  /// **'Login'**
  String get settingsLogin;

  /// No description provided for @settingsChangePassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort ändern'**
  String get settingsChangePassword;

  /// No description provided for @settingsSignOut.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get settingsSignOut;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In de, this message translates to:
  /// **'Datenschutzerklärung'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfService.
  ///
  /// In de, this message translates to:
  /// **'Nutzungsbedingungen'**
  String get settingsTermsOfService;

  /// No description provided for @settingsContactSupport.
  ///
  /// In de, this message translates to:
  /// **'Support kontaktieren'**
  String get settingsContactSupport;

  /// No description provided for @settingsEditProfile.
  ///
  /// In de, this message translates to:
  /// **'Profil bearbeiten'**
  String get settingsEditProfile;

  /// No description provided for @settingsDisplayName.
  ///
  /// In de, this message translates to:
  /// **'Anzeigename'**
  String get settingsDisplayName;

  /// No description provided for @settingsEmail.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get settingsEmail;

  /// No description provided for @settingsSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get settingsSave;

  /// No description provided for @settingsResetPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort zurücksetzen'**
  String get settingsResetPassword;

  /// No description provided for @settingsCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get settingsCancel;

  /// No description provided for @settingsSendEmail.
  ///
  /// In de, this message translates to:
  /// **'E-Mail senden'**
  String get settingsSendEmail;

  /// No description provided for @settingsPasswordResetSent.
  ///
  /// In de, this message translates to:
  /// **'Passwort-Reset-E-Mail wurde gesendet.'**
  String get settingsPasswordResetSent;

  /// No description provided for @settingsError.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get settingsError;

  /// No description provided for @settingsGoogleAccountNote.
  ///
  /// In de, this message translates to:
  /// **'Dein Konto ist mit Google verknüpft.\nBitte verwalte dein Passwort über dein Google-Konto.'**
  String get settingsGoogleAccountNote;

  /// No description provided for @settingsPasswordResetBody.
  ///
  /// In de, this message translates to:
  /// **'Wir senden eine E-Mail zum Zurücksetzen des Passworts an:\n\n{email}'**
  String settingsPasswordResetBody(String email);

  /// No description provided for @resetPasswordTitle.
  ///
  /// In de, this message translates to:
  /// **'Neues Passwort festlegen'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Mind. 8 Zeichen, 1 Sonderzeichen, 1 Großbuchstabe und 1 Zahl.'**
  String get resetPasswordSubtitle;

  /// No description provided for @resetPasswordSave.
  ///
  /// In de, this message translates to:
  /// **'Passwort speichern'**
  String get resetPasswordSave;

  /// No description provided for @resetPasswordSuccessTitle.
  ///
  /// In de, this message translates to:
  /// **'Passwort geändert!'**
  String get resetPasswordSuccessTitle;

  /// No description provided for @resetPasswordSuccessBody.
  ///
  /// In de, this message translates to:
  /// **'Dein Passwort wurde erfolgreich zurückgesetzt. Du kannst dich jetzt anmelden.'**
  String get resetPasswordSuccessBody;

  /// No description provided for @resetPasswordGoToLogin.
  ///
  /// In de, this message translates to:
  /// **'Zum Login'**
  String get resetPasswordGoToLogin;

  /// No description provided for @settingsCurrentPassword.
  ///
  /// In de, this message translates to:
  /// **'Aktuelles Passwort'**
  String get settingsCurrentPassword;

  /// No description provided for @settingsNewPassword.
  ///
  /// In de, this message translates to:
  /// **'Neues Passwort'**
  String get settingsNewPassword;

  /// No description provided for @settingsCurrentPasswordRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte aktuelles Passwort eingeben.'**
  String get settingsCurrentPasswordRequired;

  /// No description provided for @settingsPasswordChanged.
  ///
  /// In de, this message translates to:
  /// **'Passwort erfolgreich geändert.'**
  String get settingsPasswordChanged;

  /// No description provided for @settingsVersion.
  ///
  /// In de, this message translates to:
  /// **'BuildMyPC v1.0.0'**
  String get settingsVersion;

  /// No description provided for @supportTitle.
  ///
  /// In de, this message translates to:
  /// **'Support kontaktieren'**
  String get supportTitle;

  /// No description provided for @supportInfoBanner.
  ///
  /// In de, this message translates to:
  /// **'Deine Anfrage wird über deinen E-Mail-Client an unser Team weitergeleitet.'**
  String get supportInfoBanner;

  /// No description provided for @supportSubjectLabel.
  ///
  /// In de, this message translates to:
  /// **'Betreff'**
  String get supportSubjectLabel;

  /// No description provided for @supportSubjectRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte einen Betreff auswählen'**
  String get supportSubjectRequired;

  /// No description provided for @supportSubjectBug.
  ///
  /// In de, this message translates to:
  /// **'Bug melden'**
  String get supportSubjectBug;

  /// No description provided for @supportSubjectFeature.
  ///
  /// In de, this message translates to:
  /// **'Feature-Anfrage'**
  String get supportSubjectFeature;

  /// No description provided for @supportSubjectGeneral.
  ///
  /// In de, this message translates to:
  /// **'Allgemeine Anfrage'**
  String get supportSubjectGeneral;

  /// No description provided for @supportSubjectFeedback.
  ///
  /// In de, this message translates to:
  /// **'Feedback'**
  String get supportSubjectFeedback;

  /// No description provided for @supportMessageLabel.
  ///
  /// In de, this message translates to:
  /// **'Nachricht'**
  String get supportMessageLabel;

  /// No description provided for @supportMessageRequired.
  ///
  /// In de, this message translates to:
  /// **'Bitte eine Nachricht eingeben'**
  String get supportMessageRequired;

  /// No description provided for @supportSendButton.
  ///
  /// In de, this message translates to:
  /// **'Anfrage senden'**
  String get supportSendButton;

  /// No description provided for @supportReplyNote.
  ///
  /// In de, this message translates to:
  /// **'Antworten werden an deine registrierte E-Mail-Adresse gesendet.'**
  String get supportReplyNote;

  /// No description provided for @supportNoEmailClient.
  ///
  /// In de, this message translates to:
  /// **'Kein E-Mail-Client gefunden. Bitte sende eine E-Mail an buildmypc@gmx.de.'**
  String get supportNoEmailClient;

  /// No description provided for @supportEmailError.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Öffnen des E-Mail-Clients: {error}'**
  String supportEmailError(String error);

  /// No description provided for @privacyTitle.
  ///
  /// In de, this message translates to:
  /// **'Datenschutzerklärung'**
  String get privacyTitle;

  /// No description provided for @privacySection1Title.
  ///
  /// In de, this message translates to:
  /// **'1. Verantwortlicher'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Body.
  ///
  /// In de, this message translates to:
  /// **'Verantwortlich für die Datenverarbeitung in der App BuildMyPC ist das Entwicklerteam des Software-Engineering-Projekts. Kontakt: buildmypc@gmx.de'**
  String get privacySection1Body;

  /// No description provided for @privacySection2Title.
  ///
  /// In de, this message translates to:
  /// **'2. Erhobene Daten'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Body.
  ///
  /// In de, this message translates to:
  /// **'Bei der Nutzung der App werden folgende Daten verarbeitet:\n\n• E-Mail-Adresse und Anzeigename (bei Registrierung oder Google-Anmeldung)\n• Anonym gespeicherte Nutzungsdaten zur Verbesserung der App\n• Erstellte PC-Konfigurationen (nur wenn eingeloggt)'**
  String get privacySection2Body;

  /// No description provided for @privacySection3Title.
  ///
  /// In de, this message translates to:
  /// **'3. Authentifizierung'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Body.
  ///
  /// In de, this message translates to:
  /// **'Die App nutzt Firebase Authentication von Google LLC für die Benutzeranmeldung. Bei Verwendung der Google-Anmeldung gelten zusätzlich die Datenschutzbestimmungen von Google (policies.google.com/privacy).\n\nDeine Anmeldedaten werden ausschließlich über sichere Firebase-Dienste übertragen und gespeichert.'**
  String get privacySection3Body;

  /// No description provided for @privacySection4Title.
  ///
  /// In de, this message translates to:
  /// **'4. Datenspeicherung'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Body.
  ///
  /// In de, this message translates to:
  /// **'Nutzerdaten werden in Google Firebase (Cloud Firestore) gespeichert. Die Server befinden sich in der EU. Firebase ist zertifiziert nach ISO 27001 und SOC 2/3.\n\nDaten werden so lange gespeichert, wie ein aktives Konto besteht. Nach Kontolöschung werden alle personenbezogenen Daten innerhalb von 30 Tagen entfernt.'**
  String get privacySection4Body;

  /// No description provided for @privacySection5Title.
  ///
  /// In de, this message translates to:
  /// **'5. Weitergabe von Daten'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Body.
  ///
  /// In de, this message translates to:
  /// **'Deine Daten werden nicht an Dritte weitergegeben, mit Ausnahme der zur App-Funktion notwendigen Firebase-Dienste (Google LLC).'**
  String get privacySection5Body;

  /// No description provided for @privacySection6Title.
  ///
  /// In de, this message translates to:
  /// **'6. Deine Rechte'**
  String get privacySection6Title;

  /// No description provided for @privacySection6Body.
  ///
  /// In de, this message translates to:
  /// **'Du hast das Recht auf:\n\n• Auskunft über gespeicherte Daten\n• Berichtigung unrichtiger Daten\n• Löschung deines Kontos und aller damit verbundenen Daten\n• Einschränkung der Verarbeitung\n• Datenübertragbarkeit\n\nZur Ausübung deiner Rechte wende dich an: buildmypc@gmx.de'**
  String get privacySection6Body;

  /// No description provided for @privacySection7Title.
  ///
  /// In de, this message translates to:
  /// **'7. Änderungen'**
  String get privacySection7Title;

  /// No description provided for @privacySection7Body.
  ///
  /// In de, this message translates to:
  /// **'Wir behalten uns vor, diese Datenschutzerklärung bei Bedarf anzupassen. Die jeweils aktuelle Version ist in der App einsehbar.'**
  String get privacySection7Body;

  /// No description provided for @privacyDate.
  ///
  /// In de, this message translates to:
  /// **'Stand: Februar 2026'**
  String get privacyDate;

  /// No description provided for @termsTitle.
  ///
  /// In de, this message translates to:
  /// **'Nutzungsbedingungen'**
  String get termsTitle;

  /// No description provided for @termsSection1Title.
  ///
  /// In de, this message translates to:
  /// **'1. Geltungsbereich'**
  String get termsSection1Title;

  /// No description provided for @termsSection1Body.
  ///
  /// In de, this message translates to:
  /// **'Diese Nutzungsbedingungen gelten für die Verwendung der App BuildMyPC. Mit der Nutzung der App erklärst du dich mit diesen Bedingungen einverstanden.'**
  String get termsSection1Body;

  /// No description provided for @termsSection2Title.
  ///
  /// In de, this message translates to:
  /// **'2. Leistungsbeschreibung'**
  String get termsSection2Title;

  /// No description provided for @termsSection2Body.
  ///
  /// In de, this message translates to:
  /// **'BuildMyPC ist eine App zur Unterstützung bei der Planung und Konfiguration von PC-Systemen. Die App stellt Informationen zu Hardware-Komponenten bereit und ermöglicht das Erstellen von PC-Konfigurationen.\n\nDie App wird im Rahmen eines universitären Software-Engineering-Projekts entwickelt und bereitgestellt.'**
  String get termsSection2Body;

  /// No description provided for @termsSection3Title.
  ///
  /// In de, this message translates to:
  /// **'3. Nutzerkonto'**
  String get termsSection3Title;

  /// No description provided for @termsSection3Body.
  ///
  /// In de, this message translates to:
  /// **'Für bestimmte Funktionen ist eine Registrierung erforderlich. Du bist verpflichtet, deine Zugangsdaten vertraulich zu behandeln und uns unverzüglich zu informieren, falls du einen Missbrauch deines Kontos feststellst.\n\nJede Person darf nur ein Konto anlegen. Das Konto ist nicht übertragbar.'**
  String get termsSection3Body;

  /// No description provided for @termsSection4Title.
  ///
  /// In de, this message translates to:
  /// **'4. Nutzungsrechte'**
  String get termsSection4Title;

  /// No description provided for @termsSection4Body.
  ///
  /// In de, this message translates to:
  /// **'Die App darf ausschließlich für private und nicht-kommerzielle Zwecke genutzt werden. Es ist nicht gestattet, die App zu kopieren, zu modifizieren, zu verbreiten oder für kommerzielle Zwecke zu nutzen.'**
  String get termsSection4Body;

  /// No description provided for @termsSection5Title.
  ///
  /// In de, this message translates to:
  /// **'5. Verfügbarkeit'**
  String get termsSection5Title;

  /// No description provided for @termsSection5Body.
  ///
  /// In de, this message translates to:
  /// **'Wir bemühen uns um eine möglichst hohe Verfügbarkeit der App, übernehmen jedoch keine Garantie für eine unterbrechungsfreie Nutzung. Wartungsarbeiten und technische Störungen können die Verfügbarkeit zeitweise einschränken.'**
  String get termsSection5Body;

  /// No description provided for @termsSection6Title.
  ///
  /// In de, this message translates to:
  /// **'6. Haftungsausschluss'**
  String get termsSection6Title;

  /// No description provided for @termsSection6Body.
  ///
  /// In de, this message translates to:
  /// **'Die in der App bereitgestellten Informationen zu Hardware-Komponenten und Preisen sind ohne Gewähr. Wir übernehmen keine Haftung für die Richtigkeit, Vollständigkeit oder Aktualität der Angaben.\n\nKaufentscheidungen liegen allein in der Verantwortung des Nutzers.'**
  String get termsSection6Body;

  /// No description provided for @termsSection7Title.
  ///
  /// In de, this message translates to:
  /// **'7. Änderungen'**
  String get termsSection7Title;

  /// No description provided for @termsSection7Body.
  ///
  /// In de, this message translates to:
  /// **'Wir behalten uns das Recht vor, diese Nutzungsbedingungen jederzeit zu ändern. Über wesentliche Änderungen werden registrierte Nutzer informiert. Die fortgesetzte Nutzung der App gilt als Zustimmung zu den geänderten Bedingungen.'**
  String get termsSection7Body;

  /// No description provided for @termsSection8Title.
  ///
  /// In de, this message translates to:
  /// **'8. Kontakt'**
  String get termsSection8Title;

  /// No description provided for @termsSection8Body.
  ///
  /// In de, this message translates to:
  /// **'Bei Fragen zu diesen Nutzungsbedingungen wende dich an:\nbuildmypc@gmx.de'**
  String get termsSection8Body;

  /// No description provided for @termsDate.
  ///
  /// In de, this message translates to:
  /// **'Stand: Februar 2026'**
  String get termsDate;

  /// No description provided for @compatibilityOk.
  ///
  /// In de, this message translates to:
  /// **'KOMPATIBILITÄT: OK'**
  String get compatibilityOk;

  /// No description provided for @compatibilityWarning.
  ///
  /// In de, this message translates to:
  /// **'KOMPATIBILITÄTS-WARNUNG'**
  String get compatibilityWarning;

  /// No description provided for @compatibilityError.
  ///
  /// In de, this message translates to:
  /// **'KOMPATIBILITÄTSFEHLER'**
  String get compatibilityError;

  /// No description provided for @compatibilityViewDetails.
  ///
  /// In de, this message translates to:
  /// **'DETAILS'**
  String get compatibilityViewDetails;

  /// No description provided for @compatibilityDetails.
  ///
  /// In de, this message translates to:
  /// **'Kompatibilitäts-Details'**
  String get compatibilityDetails;

  /// No description provided for @compatibilityNoIssues.
  ///
  /// In de, this message translates to:
  /// **'Alle geprüften Komponenten sind kompatibel.'**
  String get compatibilityNoIssues;

  /// No description provided for @commonDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get commonDelete;

  /// No description provided for @commonRename.
  ///
  /// In de, this message translates to:
  /// **'Umbenennen'**
  String get commonRename;

  /// No description provided for @commonDuplicate.
  ///
  /// In de, this message translates to:
  /// **'Duplizieren'**
  String get commonDuplicate;

  /// No description provided for @commonView.
  ///
  /// In de, this message translates to:
  /// **'Ansehen'**
  String get commonView;

  /// No description provided for @commonApply.
  ///
  /// In de, this message translates to:
  /// **'Anwenden'**
  String get commonApply;

  /// No description provided for @commonAdd.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get commonAdd;

  /// No description provided for @commonYes.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In de, this message translates to:
  /// **'Nein'**
  String get commonNo;

  /// No description provided for @buildDialogEditTitle.
  ///
  /// In de, this message translates to:
  /// **'Build bearbeiten'**
  String get buildDialogEditTitle;

  /// No description provided for @buildDialogNameHint.
  ///
  /// In de, this message translates to:
  /// **'Build-Name'**
  String get buildDialogNameHint;

  /// No description provided for @buildDialogCoverLabel.
  ///
  /// In de, this message translates to:
  /// **'Cover-Bild (optional)'**
  String get buildDialogCoverLabel;

  /// No description provided for @buildDialogDuplicateTitle.
  ///
  /// In de, this message translates to:
  /// **'Build duplizieren'**
  String get buildDialogDuplicateTitle;

  /// No description provided for @buildDialogDuplicateNameHint.
  ///
  /// In de, this message translates to:
  /// **'Name des Duplikats'**
  String get buildDialogDuplicateNameHint;

  /// No description provided for @buildDialogNameRequired.
  ///
  /// In de, this message translates to:
  /// **'Name darf nicht leer sein'**
  String get buildDialogNameRequired;

  /// No description provided for @buildDialogCopyOf.
  ///
  /// In de, this message translates to:
  /// **'Kopie von {title}'**
  String buildDialogCopyOf(String title);

  /// No description provided for @buildDialogDeleteTitle.
  ///
  /// In de, this message translates to:
  /// **'Build löschen'**
  String get buildDialogDeleteTitle;

  /// No description provided for @buildDialogDeleteContent.
  ///
  /// In de, this message translates to:
  /// **'\"{title}\" dauerhaft löschen?'**
  String buildDialogDeleteContent(String title);

  /// No description provided for @buildDialogSaved.
  ///
  /// In de, this message translates to:
  /// **'\"{title}\" wurde gespeichert.'**
  String buildDialogSaved(String title);

  /// No description provided for @buildDialogDuplicateError.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Duplizieren: {error}'**
  String buildDialogDuplicateError(String error);

  /// No description provided for @buildsNoBuilds.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Builds gespeichert'**
  String get buildsNoBuilds;

  /// No description provided for @buildsStartNew.
  ///
  /// In de, this message translates to:
  /// **'Neuen Build starten'**
  String get buildsStartNew;

  /// No description provided for @buildsSignInPrompt.
  ///
  /// In de, this message translates to:
  /// **'Anmelden, um deine Builds zu sehen.'**
  String get buildsSignInPrompt;

  /// No description provided for @myBuildsTitle.
  ///
  /// In de, this message translates to:
  /// **'Meine Builds'**
  String get myBuildsTitle;

  /// No description provided for @myBuildsSearchHint.
  ///
  /// In de, this message translates to:
  /// **'Builds durchsuchen…'**
  String get myBuildsSearchHint;

  /// No description provided for @myBuildsFilters.
  ///
  /// In de, this message translates to:
  /// **'Filter'**
  String get myBuildsFilters;

  /// No description provided for @myBuildsFilterAll.
  ///
  /// In de, this message translates to:
  /// **'Alle Builds'**
  String get myBuildsFilterAll;

  /// No description provided for @myBuildsFilterCompleted.
  ///
  /// In de, this message translates to:
  /// **'Abgeschlossen'**
  String get myBuildsFilterCompleted;

  /// No description provided for @myBuildsFilterInProgress.
  ///
  /// In de, this message translates to:
  /// **'In Bearbeitung'**
  String get myBuildsFilterInProgress;

  /// No description provided for @myBuildsFilterImported.
  ///
  /// In de, this message translates to:
  /// **'Importiert'**
  String get myBuildsFilterImported;

  /// No description provided for @buildStatusCompleted.
  ///
  /// In de, this message translates to:
  /// **'ABGESCHLOSSEN'**
  String get buildStatusCompleted;

  /// No description provided for @buildStatusDraft.
  ///
  /// In de, this message translates to:
  /// **'ENTWURF'**
  String get buildStatusDraft;

  /// No description provided for @buildStatusArchived.
  ///
  /// In de, this message translates to:
  /// **'ARCHIVIERT'**
  String get buildStatusArchived;

  /// No description provided for @buildStatusInProgress.
  ///
  /// In de, this message translates to:
  /// **'IN BEARBEITUNG'**
  String get buildStatusInProgress;

  /// No description provided for @buildStatusImported.
  ///
  /// In de, this message translates to:
  /// **'IMPORTIERT'**
  String get buildStatusImported;

  /// No description provided for @buildCardEstimatedCost.
  ///
  /// In de, this message translates to:
  /// **'GESCHÄTZTE KOSTEN'**
  String get buildCardEstimatedCost;

  /// No description provided for @buildCardProgress.
  ///
  /// In de, this message translates to:
  /// **'FORTSCHRITT'**
  String get buildCardProgress;

  /// No description provided for @buildCardShare.
  ///
  /// In de, this message translates to:
  /// **'Teilen'**
  String get buildCardShare;

  /// No description provided for @buildCardMore.
  ///
  /// In de, this message translates to:
  /// **'Mehr'**
  String get buildCardMore;

  /// No description provided for @templateTitle.
  ///
  /// In de, this message translates to:
  /// **'Build-Vorlagen'**
  String get templateTitle;

  /// No description provided for @templateDescription.
  ///
  /// In de, this message translates to:
  /// **'Wähle eine Vorlage als Ausgangspunkt für dein Build. Alle Komponenten können anschließend frei angepasst werden.'**
  String get templateDescription;

  /// No description provided for @templateBudgetGamingTagline.
  ///
  /// In de, this message translates to:
  /// **'Maximale Performance für kleines Budget'**
  String get templateBudgetGamingTagline;

  /// No description provided for @templateHighEndGamingTagline.
  ///
  /// In de, this message translates to:
  /// **'Kompromisslose Performance für 4K & 144 Hz'**
  String get templateHighEndGamingTagline;

  /// No description provided for @templateOfficeTagline.
  ///
  /// In de, this message translates to:
  /// **'Zuverlässig und effizient für den Büroalltag'**
  String get templateOfficeTagline;

  /// No description provided for @templateWorkstationTagline.
  ///
  /// In de, this message translates to:
  /// **'Professionelle Leistung für anspruchsvolle Aufgaben'**
  String get templateWorkstationTagline;

  /// No description provided for @templateMiniItxTagline.
  ///
  /// In de, this message translates to:
  /// **'Maximale Leistung im kleinsten Formfaktor'**
  String get templateMiniItxTagline;

  /// No description provided for @templateSilentTagline.
  ///
  /// In de, this message translates to:
  /// **'Leise wie eine Bibliothek – maximaler Komfort'**
  String get templateSilentTagline;

  /// No description provided for @sharedLinkCopied.
  ///
  /// In de, this message translates to:
  /// **'Link kopiert!'**
  String get sharedLinkCopied;

  /// No description provided for @sharedBuildNotFound.
  ///
  /// In de, this message translates to:
  /// **'Build nicht gefunden'**
  String get sharedBuildNotFound;

  /// No description provided for @sharedBuildNotFoundDesc.
  ///
  /// In de, this message translates to:
  /// **'Dieser Link ist ungültig oder wurde noch nicht geteilt.'**
  String get sharedBuildNotFoundDesc;

  /// No description provided for @shareTitle.
  ///
  /// In de, this message translates to:
  /// **'Build teilen'**
  String get shareTitle;

  /// No description provided for @shareReadOnly.
  ///
  /// In de, this message translates to:
  /// **'Nur ansehen'**
  String get shareReadOnly;

  /// No description provided for @shareGenerating.
  ///
  /// In de, this message translates to:
  /// **'Link wird generiert…'**
  String get shareGenerating;

  /// No description provided for @shareGeneratingError.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Generieren'**
  String get shareGeneratingError;

  /// No description provided for @shareCopy.
  ///
  /// In de, this message translates to:
  /// **'Kopieren'**
  String get shareCopy;

  /// No description provided for @shareDirectSection.
  ///
  /// In de, this message translates to:
  /// **'DIREKT TEILEN'**
  String get shareDirectSection;

  /// No description provided for @shareInstagramCopied.
  ///
  /// In de, this message translates to:
  /// **'Link kopiert – füge ihn in Instagram DM ein.'**
  String get shareInstagramCopied;

  /// No description provided for @shareCouldNotOpen.
  ///
  /// In de, this message translates to:
  /// **'Konnte nicht geöffnet werden.'**
  String get shareCouldNotOpen;

  /// No description provided for @shareMessageText.
  ///
  /// In de, this message translates to:
  /// **'Schau dir meinen PC-Build \"{title}\" an: {url}'**
  String shareMessageText(String title, String url);

  /// No description provided for @shareEmailSubject.
  ///
  /// In de, this message translates to:
  /// **'BuildMyPC – {title}'**
  String shareEmailSubject(String title);

  /// No description provided for @partsSearchHint.
  ///
  /// In de, this message translates to:
  /// **'Teile suchen'**
  String get partsSearchHint;

  /// No description provided for @partsProductsFound.
  ///
  /// In de, this message translates to:
  /// **'{count} Produkte gefunden'**
  String partsProductsFound(int count);

  /// No description provided for @partsNoProductsFound.
  ///
  /// In de, this message translates to:
  /// **'0 Produkte gefunden'**
  String get partsNoProductsFound;

  /// No description provided for @partsComponentType.
  ///
  /// In de, this message translates to:
  /// **'Komponententyp'**
  String get partsComponentType;

  /// No description provided for @partsSpecs.
  ///
  /// In de, this message translates to:
  /// **'Spezifikationen'**
  String get partsSpecs;

  /// No description provided for @partsSort.
  ///
  /// In de, this message translates to:
  /// **'Sortierung'**
  String get partsSort;

  /// No description provided for @partsOrder.
  ///
  /// In de, this message translates to:
  /// **'Reihenfolge'**
  String get partsOrder;

  /// No description provided for @partsNoData.
  ///
  /// In de, this message translates to:
  /// **'Keine Daten geladen'**
  String get partsNoData;

  /// No description provided for @partsNoDataSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Keine Teile in einer Kollektion gefunden.'**
  String get partsNoDataSubtitle;

  /// No description provided for @partsNoResults.
  ///
  /// In de, this message translates to:
  /// **'Keine Ergebnisse'**
  String get partsNoResults;

  /// No description provided for @partsNoResultsSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Filter oder Suche anpassen.'**
  String get partsNoResultsSubtitle;

  /// No description provided for @partsLoadMore.
  ///
  /// In de, this message translates to:
  /// **'Mehr laden'**
  String get partsLoadMore;

  /// No description provided for @partsAddToConfig.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get partsAddToConfig;

  /// No description provided for @partsNoSpecs.
  ///
  /// In de, this message translates to:
  /// **'Keine Spezifikationen verfügbar.'**
  String get partsNoSpecs;

  /// No description provided for @partsDataCompleteness.
  ///
  /// In de, this message translates to:
  /// **'Datenvollständigkeit'**
  String get partsDataCompleteness;

  /// No description provided for @partsDataCompletenessHint.
  ///
  /// In de, this message translates to:
  /// **'Komponenten nach Vollständigkeit der Spezifikationsdaten filtern'**
  String get partsDataCompletenessHint;

  /// No description provided for @partsShowAll.
  ///
  /// In de, this message translates to:
  /// **'Alle anzeigen'**
  String get partsShowAll;

  /// No description provided for @partsCompatibilityOnly.
  ///
  /// In de, this message translates to:
  /// **'Kompatibilität'**
  String get partsCompatibilityOnly;

  /// No description provided for @partsAllComponents.
  ///
  /// In de, this message translates to:
  /// **'Alle Komponenten'**
  String get partsAllComponents;

  /// No description provided for @partsSortPriceLowToHigh.
  ///
  /// In de, this message translates to:
  /// **'Preis: Aufsteigend'**
  String get partsSortPriceLowToHigh;

  /// No description provided for @partsSortPriceHighToLow.
  ///
  /// In de, this message translates to:
  /// **'Preis: Absteigend'**
  String get partsSortPriceHighToLow;

  /// No description provided for @partsSortNameAtoZ.
  ///
  /// In de, this message translates to:
  /// **'Name: A bis Z'**
  String get partsSortNameAtoZ;

  /// No description provided for @partsPriceRange.
  ///
  /// In de, this message translates to:
  /// **'Preisbereich'**
  String get partsPriceRange;

  /// No description provided for @configureSelectComponent.
  ///
  /// In de, this message translates to:
  /// **'Mindestens eine Komponente auswählen, um den Build zu speichern.'**
  String get configureSelectComponent;

  /// No description provided for @configureSignInPrompt.
  ///
  /// In de, this message translates to:
  /// **'Bitte anmelden. Dein Build wird automatisch gespeichert.'**
  String get configureSignInPrompt;

  /// No description provided for @configureSaveBuildError.
  ///
  /// In de, this message translates to:
  /// **'Build konnte nicht gespeichert werden: {error}'**
  String configureSaveBuildError(String error);

  /// No description provided for @configureSaveBuildTitle.
  ///
  /// In de, this message translates to:
  /// **'Build speichern'**
  String get configureSaveBuildTitle;

  /// No description provided for @configureSaving.
  ///
  /// In de, this message translates to:
  /// **'WIRD GESPEICHERT...'**
  String get configureSaving;

  /// No description provided for @configureAddToMyBuilds.
  ///
  /// In de, this message translates to:
  /// **'ZU MEINEN BUILDS'**
  String get configureAddToMyBuilds;

  /// No description provided for @configureMissingData.
  ///
  /// In de, this message translates to:
  /// **'{slot}: Fehlende Daten – {fields}'**
  String configureMissingData(String slot, String fields);

  /// No description provided for @configureMissingDataTooltip.
  ///
  /// In de, this message translates to:
  /// **'Fehlende Daten: {fields}'**
  String configureMissingDataTooltip(String fields);

  /// No description provided for @configureAdd.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get configureAdd;

  /// No description provided for @configureExtras.
  ///
  /// In de, this message translates to:
  /// **'EXTRAS'**
  String get configureExtras;

  /// No description provided for @configureSelectedCount.
  ///
  /// In de, this message translates to:
  /// **'{count} ausgewählt'**
  String configureSelectedCount(int count);

  /// No description provided for @configureImportedFrom.
  ///
  /// In de, this message translates to:
  /// **'{title} von {author}'**
  String configureImportedFrom(String title, String author);

  /// No description provided for @compatIncompatible.
  ///
  /// In de, this message translates to:
  /// **'Inkompatibel'**
  String get compatIncompatible;

  /// No description provided for @compatSingleError.
  ///
  /// In de, this message translates to:
  /// **'1 kritischer Fehler'**
  String get compatSingleError;

  /// No description provided for @compatMultipleErrors.
  ///
  /// In de, this message translates to:
  /// **'{count} kritische Fehler'**
  String compatMultipleErrors(int count);

  /// No description provided for @compatSingleWarning.
  ///
  /// In de, this message translates to:
  /// **'1 Warnung erkannt'**
  String get compatSingleWarning;

  /// No description provided for @compatMultipleWarnings.
  ///
  /// In de, this message translates to:
  /// **'{count} Warnungen erkannt'**
  String compatMultipleWarnings(int count);

  /// No description provided for @compatWarning.
  ///
  /// In de, this message translates to:
  /// **'Warnung'**
  String get compatWarning;

  /// No description provided for @compatCompatible.
  ///
  /// In de, this message translates to:
  /// **'Kompatibel'**
  String get compatCompatible;

  /// No description provided for @compatAllCompatible.
  ///
  /// In de, this message translates to:
  /// **'Alle Komponenten sind kompatibel'**
  String get compatAllCompatible;

  /// No description provided for @compatOverallStatus.
  ///
  /// In de, this message translates to:
  /// **'GESAMTSTATUS'**
  String get compatOverallStatus;

  /// No description provided for @guidedCardHeader.
  ///
  /// In de, this message translates to:
  /// **'BUILD-VORLAGEN'**
  String get guidedCardHeader;

  /// No description provided for @guidedCardDescription.
  ///
  /// In de, this message translates to:
  /// **'Starte mit einer vorkonfigurierten Vorlage – Budget Gaming, Office, High-End oder Workstation.'**
  String get guidedCardDescription;

  /// No description provided for @guidedCardButton.
  ///
  /// In de, this message translates to:
  /// **'Vorlage auswählen'**
  String get guidedCardButton;

  /// No description provided for @startNewBuildTitle.
  ///
  /// In de, this message translates to:
  /// **'Neuen Build starten'**
  String get startNewBuildTitle;

  /// No description provided for @startNewBuildSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Manuell · Teileauswahl'**
  String get startNewBuildSubtitle;

  /// No description provided for @partsSpecsReset.
  ///
  /// In de, this message translates to:
  /// **'Zurücksetzen'**
  String get partsSpecsReset;

  /// No description provided for @partsSpecsAny.
  ///
  /// In de, this message translates to:
  /// **'Beliebig'**
  String get partsSpecsAny;

  /// No description provided for @specLabelSize.
  ///
  /// In de, this message translates to:
  /// **'Größe'**
  String get specLabelSize;

  /// No description provided for @specLabelAirflow.
  ///
  /// In de, this message translates to:
  /// **'Luftdurchsatz'**
  String get specLabelAirflow;

  /// No description provided for @specLabelChannels.
  ///
  /// In de, this message translates to:
  /// **'Kanäle'**
  String get specLabelChannels;

  /// No description provided for @specLabelChannelWattage.
  ///
  /// In de, this message translates to:
  /// **'Kanalleistung'**
  String get specLabelChannelWattage;

  /// No description provided for @specLabelMemory.
  ///
  /// In de, this message translates to:
  /// **'VRAM'**
  String get specLabelMemory;

  /// No description provided for @specLabelEfficiency.
  ///
  /// In de, this message translates to:
  /// **'Effizienz'**
  String get specLabelEfficiency;

  /// No description provided for @specLabelBluRayRead.
  ///
  /// In de, this message translates to:
  /// **'Blu-ray (Lesen)'**
  String get specLabelBluRayRead;

  /// No description provided for @specLabelBluRayWrite.
  ///
  /// In de, this message translates to:
  /// **'Blu-ray (Schreiben)'**
  String get specLabelBluRayWrite;

  /// No description provided for @specLabelDvdRead.
  ///
  /// In de, this message translates to:
  /// **'DVD (Lesen)'**
  String get specLabelDvdRead;

  /// No description provided for @specLabelDvdWrite.
  ///
  /// In de, this message translates to:
  /// **'DVD (Schreiben)'**
  String get specLabelDvdWrite;

  /// No description provided for @specLabelCdRead.
  ///
  /// In de, this message translates to:
  /// **'CD (Lesen)'**
  String get specLabelCdRead;

  /// No description provided for @specLabelCdWrite.
  ///
  /// In de, this message translates to:
  /// **'CD (Schreiben)'**
  String get specLabelCdWrite;

  /// No description provided for @specLabelMode.
  ///
  /// In de, this message translates to:
  /// **'Modus'**
  String get specLabelMode;

  /// No description provided for @specLabelCapacityVa.
  ///
  /// In de, this message translates to:
  /// **'Kapazität (VA)'**
  String get specLabelCapacityVa;

  /// No description provided for @specLabelCapacityW.
  ///
  /// In de, this message translates to:
  /// **'Kapazität (W)'**
  String get specLabelCapacityW;

  /// No description provided for @specLabelProtocol.
  ///
  /// In de, this message translates to:
  /// **'Protokoll'**
  String get specLabelProtocol;

  /// No description provided for @specLabelSampleRate.
  ///
  /// In de, this message translates to:
  /// **'Abtastrate'**
  String get specLabelSampleRate;

  /// No description provided for @specLabelSnr.
  ///
  /// In de, this message translates to:
  /// **'Rauschabstand'**
  String get specLabelSnr;

  /// No description provided for @specLabelDigitalAudio.
  ///
  /// In de, this message translates to:
  /// **'Digital-Audio'**
  String get specLabelDigitalAudio;

  /// No description provided for @specLabelAmount.
  ///
  /// In de, this message translates to:
  /// **'Menge'**
  String get specLabelAmount;

  /// No description provided for @specLabelInternal35Bays.
  ///
  /// In de, this message translates to:
  /// **'Interne 3,5\"-Schächte'**
  String get specLabelInternal35Bays;

  /// No description provided for @partsTypeCpuCooler.
  ///
  /// In de, this message translates to:
  /// **'CPU-Kühler'**
  String get partsTypeCpuCooler;

  /// No description provided for @partsTypeStorage.
  ///
  /// In de, this message translates to:
  /// **'Speicher'**
  String get partsTypeStorage;

  /// No description provided for @partsTypePowerSupply.
  ///
  /// In de, this message translates to:
  /// **'Netzteil'**
  String get partsTypePowerSupply;

  /// No description provided for @partsTypeCase.
  ///
  /// In de, this message translates to:
  /// **'Gehäuse'**
  String get partsTypeCase;

  /// No description provided for @partsTypeCaseFan.
  ///
  /// In de, this message translates to:
  /// **'Gehäuselüfter'**
  String get partsTypeCaseFan;

  /// No description provided for @partsTypeEthernetCard.
  ///
  /// In de, this message translates to:
  /// **'LAN-Karte'**
  String get partsTypeEthernetCard;

  /// No description provided for @partsTypeWifiCard.
  ///
  /// In de, this message translates to:
  /// **'WLAN-Karte'**
  String get partsTypeWifiCard;

  /// No description provided for @partsTypeSoundCard.
  ///
  /// In de, this message translates to:
  /// **'Soundkarte'**
  String get partsTypeSoundCard;

  /// No description provided for @partsTypeOpticalDrive.
  ///
  /// In de, this message translates to:
  /// **'Optisches Laufwerk'**
  String get partsTypeOpticalDrive;

  /// No description provided for @partsTypeFanController.
  ///
  /// In de, this message translates to:
  /// **'Lüftersteuerung'**
  String get partsTypeFanController;

  /// No description provided for @partsTypeThermalPaste.
  ///
  /// In de, this message translates to:
  /// **'Wärmeleitpaste'**
  String get partsTypeThermalPaste;

  /// No description provided for @partsTypeExternalStorage.
  ///
  /// In de, this message translates to:
  /// **'Externe Festplatte'**
  String get partsTypeExternalStorage;

  /// No description provided for @partsTypeUps.
  ///
  /// In de, this message translates to:
  /// **'USV'**
  String get partsTypeUps;

  /// No description provided for @partsTypeCaseAccessory.
  ///
  /// In de, this message translates to:
  /// **'Gehäuse-Zubehör'**
  String get partsTypeCaseAccessory;

  /// No description provided for @specLabelBrand.
  ///
  /// In de, this message translates to:
  /// **'Marke'**
  String get specLabelBrand;

  /// No description provided for @specLabelCoreCount.
  ///
  /// In de, this message translates to:
  /// **'Kernanzahl'**
  String get specLabelCoreCount;

  /// No description provided for @specLabelCoreClock.
  ///
  /// In de, this message translates to:
  /// **'Kerntakt'**
  String get specLabelCoreClock;

  /// No description provided for @specLabelBoostClock.
  ///
  /// In de, this message translates to:
  /// **'Boost-Takt'**
  String get specLabelBoostClock;

  /// No description provided for @specLabelMicroarchitecture.
  ///
  /// In de, this message translates to:
  /// **'Mikroarchitektur'**
  String get specLabelMicroarchitecture;

  /// No description provided for @specLabelIntegratedGraphics.
  ///
  /// In de, this message translates to:
  /// **'Integrierte Grafik'**
  String get specLabelIntegratedGraphics;

  /// No description provided for @specLabelChipset.
  ///
  /// In de, this message translates to:
  /// **'Chipsatz'**
  String get specLabelChipset;

  /// No description provided for @specLabelColor.
  ///
  /// In de, this message translates to:
  /// **'Farbe'**
  String get specLabelColor;

  /// No description provided for @specLabelVram.
  ///
  /// In de, this message translates to:
  /// **'VRAM'**
  String get specLabelVram;

  /// No description provided for @specLabelLength.
  ///
  /// In de, this message translates to:
  /// **'Länge'**
  String get specLabelLength;

  /// No description provided for @specLabelDdrGeneration.
  ///
  /// In de, this message translates to:
  /// **'DDR-Generation'**
  String get specLabelDdrGeneration;

  /// No description provided for @specLabelModules.
  ///
  /// In de, this message translates to:
  /// **'Module'**
  String get specLabelModules;

  /// No description provided for @specLabelModuleSize.
  ///
  /// In de, this message translates to:
  /// **'Modulkapazität'**
  String get specLabelModuleSize;

  /// No description provided for @specLabelSpeed.
  ///
  /// In de, this message translates to:
  /// **'Takt'**
  String get specLabelSpeed;

  /// No description provided for @specLabelCasLatency.
  ///
  /// In de, this message translates to:
  /// **'CAS-Latenz'**
  String get specLabelCasLatency;

  /// No description provided for @specLabelFirstWordLatency.
  ///
  /// In de, this message translates to:
  /// **'Erste-Wort-Latenz'**
  String get specLabelFirstWordLatency;

  /// No description provided for @specLabelPricePerGb.
  ///
  /// In de, this message translates to:
  /// **'Preis / GB'**
  String get specLabelPricePerGb;

  /// No description provided for @specLabelCapacity.
  ///
  /// In de, this message translates to:
  /// **'Kapazität'**
  String get specLabelCapacity;

  /// No description provided for @specLabelFormFactor.
  ///
  /// In de, this message translates to:
  /// **'Formfaktor'**
  String get specLabelFormFactor;

  /// No description provided for @specLabelInterface.
  ///
  /// In de, this message translates to:
  /// **'Schnittstelle'**
  String get specLabelInterface;

  /// No description provided for @specLabelSocket.
  ///
  /// In de, this message translates to:
  /// **'Sockel'**
  String get specLabelSocket;

  /// No description provided for @specLabelMaxMemory.
  ///
  /// In de, this message translates to:
  /// **'Max. Arbeitsspeicher'**
  String get specLabelMaxMemory;

  /// No description provided for @specLabelMemorySlots.
  ///
  /// In de, this message translates to:
  /// **'Speichersteckplätze'**
  String get specLabelMemorySlots;

  /// No description provided for @specLabelType.
  ///
  /// In de, this message translates to:
  /// **'Typ'**
  String get specLabelType;

  /// No description provided for @specLabelWattage.
  ///
  /// In de, this message translates to:
  /// **'Leistung'**
  String get specLabelWattage;

  /// No description provided for @specLabelEfficiencyCertification.
  ///
  /// In de, this message translates to:
  /// **'Effizienz-Zertifizierung'**
  String get specLabelEfficiencyCertification;

  /// No description provided for @specLabelNoiseLevel.
  ///
  /// In de, this message translates to:
  /// **'Lautstärke'**
  String get specLabelNoiseLevel;

  /// No description provided for @specLabelRpm.
  ///
  /// In de, this message translates to:
  /// **'U/min'**
  String get specLabelRpm;

  /// No description provided for @specLabelSidePanel.
  ///
  /// In de, this message translates to:
  /// **'Seitenblende'**
  String get specLabelSidePanel;

  /// No description provided for @specLabelIncludedPsu.
  ///
  /// In de, this message translates to:
  /// **'Enthaltenes Netzteil'**
  String get specLabelIncludedPsu;

  /// No description provided for @specLabelExternalVolume.
  ///
  /// In de, this message translates to:
  /// **'Externes Volumen'**
  String get specLabelExternalVolume;

  /// No description provided for @specLabelBays35.
  ///
  /// In de, this message translates to:
  /// **'3,5\"-Schächte'**
  String get specLabelBays35;

  /// No description provided for @compatPowerLoad.
  ///
  /// In de, this message translates to:
  /// **'{percent}% Auslastung'**
  String compatPowerLoad(int percent);

  /// No description provided for @compatPowerBuffer.
  ///
  /// In de, this message translates to:
  /// **'{watts}W Puffer'**
  String compatPowerBuffer(int watts);

  /// No description provided for @compatPowerInsufficient.
  ///
  /// In de, this message translates to:
  /// **'{watts}W zu wenig'**
  String compatPowerInsufficient(int watts);

  /// No description provided for @compatCriticalErrors.
  ///
  /// In de, this message translates to:
  /// **'Kritische Fehler'**
  String get compatCriticalErrors;

  /// No description provided for @compatWarnings.
  ///
  /// In de, this message translates to:
  /// **'Warnungen'**
  String get compatWarnings;

  /// No description provided for @compatMissingRequiredParts.
  ///
  /// In de, this message translates to:
  /// **'Fehlende Pflichtteile: {parts}.'**
  String compatMissingRequiredParts(String parts);

  /// No description provided for @compatSocketMismatch.
  ///
  /// In de, this message translates to:
  /// **'Der Sockel des Prozessors ({cpuSocket}) passt nicht zum Mainboard ({mbSocket}).'**
  String compatSocketMismatch(String cpuSocket, String mbSocket);

  /// No description provided for @compatSocketOk.
  ///
  /// In de, this message translates to:
  /// **'Prozessor und Mainboard sind sockelkompatibel ({socket}).'**
  String compatSocketOk(String socket);

  /// No description provided for @compatDdr5Required.
  ///
  /// In de, this message translates to:
  /// **'Das Mainboard ({socket}) unterstützt nur DDR5-RAM – ausgewählt ist DDR{ddrGen}.'**
  String compatDdr5Required(String socket, int ddrGen);

  /// No description provided for @compatDdr4Required.
  ///
  /// In de, this message translates to:
  /// **'Das Mainboard ({socket}) unterstützt nur DDR4-RAM – ausgewählt ist DDR{ddrGen}.'**
  String compatDdr4Required(String socket, int ddrGen);

  /// No description provided for @compatRamOk.
  ///
  /// In de, this message translates to:
  /// **'Arbeitsspeicher (DDR{ddrGen}) ist mit dem Mainboard kompatibel.'**
  String compatRamOk(int ddrGen);

  /// No description provided for @compatFormFactorIncompatible.
  ///
  /// In de, this message translates to:
  /// **'Das Gehäuse unterstützt den Formfaktor des Mainboards ({formFactor}) nicht.'**
  String compatFormFactorIncompatible(String formFactor);

  /// No description provided for @compatFormFactorOk.
  ///
  /// In de, this message translates to:
  /// **'Das Mainboard ({formFactor}) ist mit dem Gehäuse kompatibel.'**
  String compatFormFactorOk(String formFactor);

  /// No description provided for @compatPsuInsufficient.
  ///
  /// In de, this message translates to:
  /// **'Das Netzteil ({psuW}W) reicht für den geschätzten Verbrauch (~{estimatedW}W) nicht aus.'**
  String compatPsuInsufficient(int psuW, int estimatedW);

  /// No description provided for @compatPsuLowBuffer.
  ///
  /// In de, this message translates to:
  /// **'Netzteil-Puffer gering: {psuW}W für ~{estimatedW}W Verbrauch – empfohlen sind mind. 20% Reserve.'**
  String compatPsuLowBuffer(int psuW, int estimatedW);

  /// No description provided for @compatPsuAdequate.
  ///
  /// In de, this message translates to:
  /// **'Das Netzteil ({psuW}W) hat ausreichend Reserve für den geschätzten Verbrauch (~{estimatedW}W).'**
  String compatPsuAdequate(int psuW, int estimatedW);

  /// No description provided for @compatBiosUpdateAmd.
  ///
  /// In de, this message translates to:
  /// **'Ryzen 9000 auf Nicht-X870-Board: möglicherweise ist ein BIOS-Update nötig, bevor der Prozessor erkannt wird.'**
  String get compatBiosUpdateAmd;

  /// No description provided for @compatBiosUpdateIntel.
  ///
  /// In de, this message translates to:
  /// **'Intel 14. Gen auf 600er-Board: BIOS-Update erforderlich, bevor der Prozessor erkannt wird.'**
  String get compatBiosUpdateIntel;

  /// No description provided for @compatXmpRequired.
  ///
  /// In de, this message translates to:
  /// **'RAM läuft mit {ramMhz}MHz über dem JEDEC-Standard ({jedecMhz}MHz) – XMP/EXPO muss im BIOS aktiviert werden.'**
  String compatXmpRequired(int ramMhz, int jedecMhz);

  /// No description provided for @compatDdr5BudgetBoard.
  ///
  /// In de, this message translates to:
  /// **'DDR5 auf Einstiegs-Board: Bei hohen Taktraten kann es zu Stabilitätsproblemen kommen – QVL-Liste des Mainboards prüfen.'**
  String get compatDdr5BudgetBoard;

  /// No description provided for @compatTooManyRamSticks.
  ///
  /// In de, this message translates to:
  /// **'{totalSticks} RAM-Riegel ausgewählt, das Mainboard unterstützt jedoch nur {maxSlots} Steckplätze.'**
  String compatTooManyRamSticks(int totalSticks, int maxSlots);

  /// No description provided for @compatRamSlotsOk.
  ///
  /// In de, this message translates to:
  /// **'Die {totalSticks} gewählten RAM-Riegel passen in die {maxSlots} Steckplätze des Mainboards.'**
  String compatRamSlotsOk(int totalSticks, int maxSlots);
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
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
