// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navConfigure => 'Konfigurieren';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navComponents => 'Komponenten';

  @override
  String get homeWelcome => 'Willkommen bei BuildMyPC';

  @override
  String get homeConfigureButton => 'PC konfigurieren';

  @override
  String get authTagline => 'Forge your ultimate battlestation';

  @override
  String get authEmailLabel => 'E-Mail-Adresse';

  @override
  String get authEmailHint => 'name@example.com';

  @override
  String get authEmailRequired => 'Bitte E-Mail eingeben.';

  @override
  String get authEmailInvalid => 'Ungültige E-Mail.';

  @override
  String get authPasswordLabel => 'Passwort';

  @override
  String get authForgot => 'Vergessen?';

  @override
  String get authPasswordRequired => 'Bitte Passwort eingeben.';

  @override
  String get authPasswordMinLength => 'Mind. 6 Zeichen.';

  @override
  String get authConfirmPasswordHint => 'Passwort bestätigen';

  @override
  String get authConfirmPasswordRequired => 'Bitte Passwort bestätigen.';

  @override
  String get authPasswordMismatch => 'Passwörter stimmen nicht überein.';

  @override
  String get authEnterApp => 'Enter BuildMyPC';

  @override
  String get authCreateAccount => 'Konto erstellen';

  @override
  String get authOrConnect => 'ODER VERBINDEN MIT';

  @override
  String get authGuest => 'Als Gast fortfahren →';

  @override
  String get authTermsAgreement => 'Mit der Anmeldung stimmst du unseren ';

  @override
  String get authTermsLink => 'Nutzungsbedingungen';

  @override
  String get authLoginSuccess => 'Login erfolgreich';

  @override
  String get authRegisterSuccess => 'Registrierung erfolgreich';

  @override
  String get authGoogleSuccess => 'Google Login erfolgreich';

  @override
  String get authGuestSuccess => 'Als Gast fortgefahren';

  @override
  String get authForgotPasswordValid =>
      'Bitte gib oben eine gültige E-Mail ein.';

  @override
  String get authForgotPasswordSent =>
      'Wenn ein Konto existiert, wurde eine E-Mail gesendet.';

  @override
  String get configureTitle => 'PC konfigurieren';

  @override
  String get configurePlaceholder =>
      'Hier kommt euer Wizard / Konfigurator rein.';

  @override
  String get partsTitle => 'Komponenten';

  @override
  String get partsPlaceholder =>
      'Hier kommt eure Komponenten-Suche/Filterliste rein.';

  @override
  String get dashboardMyBuilds => 'Meine Builds';

  @override
  String get dashboardViewAll => 'Alle ansehen';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsAccountSecurity => 'Konto & Sicherheit';

  @override
  String get settingsLegalSupport => 'Rechtliches & Support';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsLight => 'Hell';

  @override
  String get settingsDark => 'Dunkel';

  @override
  String get settingsGerman => 'Deutsch';

  @override
  String get settingsEnglish => 'English';

  @override
  String get settingsGuest => 'Gast';

  @override
  String get settingsNotLoggedIn => 'Nicht eingeloggt';

  @override
  String get settingsEdit => 'Bearbeiten';

  @override
  String get settingsLogin => 'Login';

  @override
  String get settingsChangePassword => 'Passwort ändern';

  @override
  String get settingsSignOut => 'Abmelden';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get settingsTermsOfService => 'Nutzungsbedingungen';

  @override
  String get settingsContactSupport => 'Support kontaktieren';

  @override
  String get settingsEditProfile => 'Profil bearbeiten';

  @override
  String get settingsDisplayName => 'Anzeigename';

  @override
  String get settingsEmail => 'E-Mail';

  @override
  String get settingsSave => 'Speichern';

  @override
  String get settingsResetPassword => 'Passwort zurücksetzen';

  @override
  String get settingsCancel => 'Abbrechen';

  @override
  String get settingsSendEmail => 'E-Mail senden';

  @override
  String get settingsPasswordResetSent =>
      'Passwort-Reset-E-Mail wurde gesendet.';

  @override
  String get settingsError => 'Fehler';

  @override
  String get settingsGoogleAccountNote =>
      'Dein Konto ist mit Google verknüpft.\nBitte verwalte dein Passwort über dein Google-Konto.';

  @override
  String settingsPasswordResetBody(String email) {
    return 'Wir senden eine E-Mail zum Zurücksetzen des Passworts an:\n\n$email';
  }

  @override
  String get settingsVersion => 'BuildMyPC v1.0.0';

  @override
  String get supportTitle => 'Support kontaktieren';

  @override
  String get supportInfoBanner =>
      'Deine Anfrage wird über deinen E-Mail-Client an unser Team weitergeleitet.';

  @override
  String get supportSubjectLabel => 'Betreff';

  @override
  String get supportSubjectRequired => 'Bitte einen Betreff auswählen';

  @override
  String get supportSubjectBug => 'Bug melden';

  @override
  String get supportSubjectFeature => 'Feature-Anfrage';

  @override
  String get supportSubjectGeneral => 'Allgemeine Anfrage';

  @override
  String get supportSubjectFeedback => 'Feedback';

  @override
  String get supportMessageLabel => 'Nachricht';

  @override
  String get supportMessageRequired => 'Bitte eine Nachricht eingeben';

  @override
  String get supportSendButton => 'Anfrage senden';

  @override
  String get supportReplyNote =>
      'Antworten werden an deine registrierte E-Mail-Adresse gesendet.';

  @override
  String get supportNoEmailClient =>
      'Kein E-Mail-Client gefunden. Bitte sende eine E-Mail an buildmypc@gmx.de.';

  @override
  String supportEmailError(String error) {
    return 'Fehler beim Öffnen des E-Mail-Clients: $error';
  }

  @override
  String get privacyTitle => 'Datenschutzerklärung';

  @override
  String get privacySection1Title => '1. Verantwortlicher';

  @override
  String get privacySection1Body =>
      'Verantwortlich für die Datenverarbeitung in der App BuildMyPC ist das Entwicklerteam des Software-Engineering-Projekts. Kontakt: buildmypc@gmx.de';

  @override
  String get privacySection2Title => '2. Erhobene Daten';

  @override
  String get privacySection2Body =>
      'Bei der Nutzung der App werden folgende Daten verarbeitet:\n\n• E-Mail-Adresse und Anzeigename (bei Registrierung oder Google-Anmeldung)\n• Anonym gespeicherte Nutzungsdaten zur Verbesserung der App\n• Erstellte PC-Konfigurationen (nur wenn eingeloggt)';

  @override
  String get privacySection3Title => '3. Authentifizierung';

  @override
  String get privacySection3Body =>
      'Die App nutzt Firebase Authentication von Google LLC für die Benutzeranmeldung. Bei Verwendung der Google-Anmeldung gelten zusätzlich die Datenschutzbestimmungen von Google (policies.google.com/privacy).\n\nDeine Anmeldedaten werden ausschließlich über sichere Firebase-Dienste übertragen und gespeichert.';

  @override
  String get privacySection4Title => '4. Datenspeicherung';

  @override
  String get privacySection4Body =>
      'Nutzerdaten werden in Google Firebase (Cloud Firestore) gespeichert. Die Server befinden sich in der EU. Firebase ist zertifiziert nach ISO 27001 und SOC 2/3.\n\nDaten werden so lange gespeichert, wie ein aktives Konto besteht. Nach Kontolöschung werden alle personenbezogenen Daten innerhalb von 30 Tagen entfernt.';

  @override
  String get privacySection5Title => '5. Weitergabe von Daten';

  @override
  String get privacySection5Body =>
      'Deine Daten werden nicht an Dritte weitergegeben, mit Ausnahme der zur App-Funktion notwendigen Firebase-Dienste (Google LLC).';

  @override
  String get privacySection6Title => '6. Deine Rechte';

  @override
  String get privacySection6Body =>
      'Du hast das Recht auf:\n\n• Auskunft über gespeicherte Daten\n• Berichtigung unrichtiger Daten\n• Löschung deines Kontos und aller damit verbundenen Daten\n• Einschränkung der Verarbeitung\n• Datenübertragbarkeit\n\nZur Ausübung deiner Rechte wende dich an: buildmypc@gmx.de';

  @override
  String get privacySection7Title => '7. Änderungen';

  @override
  String get privacySection7Body =>
      'Wir behalten uns vor, diese Datenschutzerklärung bei Bedarf anzupassen. Die jeweils aktuelle Version ist in der App einsehbar.';

  @override
  String get privacyDate => 'Stand: Februar 2026';

  @override
  String get termsTitle => 'Nutzungsbedingungen';

  @override
  String get termsSection1Title => '1. Geltungsbereich';

  @override
  String get termsSection1Body =>
      'Diese Nutzungsbedingungen gelten für die Verwendung der App BuildMyPC. Mit der Nutzung der App erklärst du dich mit diesen Bedingungen einverstanden.';

  @override
  String get termsSection2Title => '2. Leistungsbeschreibung';

  @override
  String get termsSection2Body =>
      'BuildMyPC ist eine App zur Unterstützung bei der Planung und Konfiguration von PC-Systemen. Die App stellt Informationen zu Hardware-Komponenten bereit und ermöglicht das Erstellen von PC-Konfigurationen.\n\nDie App wird im Rahmen eines universitären Software-Engineering-Projekts entwickelt und bereitgestellt.';

  @override
  String get termsSection3Title => '3. Nutzerkonto';

  @override
  String get termsSection3Body =>
      'Für bestimmte Funktionen ist eine Registrierung erforderlich. Du bist verpflichtet, deine Zugangsdaten vertraulich zu behandeln und uns unverzüglich zu informieren, falls du einen Missbrauch deines Kontos feststellst.\n\nJede Person darf nur ein Konto anlegen. Das Konto ist nicht übertragbar.';

  @override
  String get termsSection4Title => '4. Nutzungsrechte';

  @override
  String get termsSection4Body =>
      'Die App darf ausschließlich für private und nicht-kommerzielle Zwecke genutzt werden. Es ist nicht gestattet, die App zu kopieren, zu modifizieren, zu verbreiten oder für kommerzielle Zwecke zu nutzen.';

  @override
  String get termsSection5Title => '5. Verfügbarkeit';

  @override
  String get termsSection5Body =>
      'Wir bemühen uns um eine möglichst hohe Verfügbarkeit der App, übernehmen jedoch keine Garantie für eine unterbrechungsfreie Nutzung. Wartungsarbeiten und technische Störungen können die Verfügbarkeit zeitweise einschränken.';

  @override
  String get termsSection6Title => '6. Haftungsausschluss';

  @override
  String get termsSection6Body =>
      'Die in der App bereitgestellten Informationen zu Hardware-Komponenten und Preisen sind ohne Gewähr. Wir übernehmen keine Haftung für die Richtigkeit, Vollständigkeit oder Aktualität der Angaben.\n\nKaufentscheidungen liegen allein in der Verantwortung des Nutzers.';

  @override
  String get termsSection7Title => '7. Änderungen';

  @override
  String get termsSection7Body =>
      'Wir behalten uns das Recht vor, diese Nutzungsbedingungen jederzeit zu ändern. Über wesentliche Änderungen werden registrierte Nutzer informiert. Die fortgesetzte Nutzung der App gilt als Zustimmung zu den geänderten Bedingungen.';

  @override
  String get termsSection8Title => '8. Kontakt';

  @override
  String get termsSection8Body =>
      'Bei Fragen zu diesen Nutzungsbedingungen wende dich an:\nbuildmypc@gmx.de';

  @override
  String get termsDate => 'Stand: Februar 2026';
}
