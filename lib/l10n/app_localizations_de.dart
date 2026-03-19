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
  String get homeSubtitle => 'Plane, konfiguriere und baue deinen Traum-PC.';

  @override
  String get homeConfigureButton => 'PC konfigurieren';

  @override
  String get homeLoginButton => 'Anmelden / Registrieren';

  @override
  String get authTagline => 'Forge your ultimate battlestation';

  @override
  String get authEmailLabel => 'E-Mail-Adresse';

  @override
  String get authEmailHint => 'name@beispiel.de';

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
  String get authPasswordMinLength =>
      'Mind. 8 Zeichen, 1 Sonderzeichen, 1 Großbuchstabe und 1 Zahl.';

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
  String get authResetRequiredAfterFailedLogins =>
      'Zu viele falsche Passwortversuche. Bitte nutze \"Vergessen?\", um dein Passwort zurückzusetzen.';

  @override
  String get authLogin => 'Anmelden';

  @override
  String get authRegister => 'Registrieren';

  @override
  String get configureTitle => 'PC konfigurieren';

  @override
  String get configurePlaceholder =>
      'Hier kommt euer Wizard / Konfigurator rein.';

  @override
  String get configureBuildTitle => 'PC-Konfigurator';

  @override
  String get configureBuildProgress => 'Build-Fortschritt';

  @override
  String configurePartsCount(int done, int total) {
    return '$done / $total Teile';
  }

  @override
  String get configureTotalPrice => 'Gesamtpreis';

  @override
  String get configureEstimatedWattage => 'Geschätzter Verbrauch';

  @override
  String get configureAddToBuilds => 'ZU BUILDS HINZUFÜGEN';

  @override
  String get configureChoose => 'Auswählen';

  @override
  String get configureChange => 'Ändern';

  @override
  String get configureRemove => 'Entfernen';

  @override
  String get configureCatCpu => 'Prozessor (CPU)';

  @override
  String get configureCatCpuCooler => 'CPU-Kühler';

  @override
  String get configureCatThermalPaste => 'Wärmeleitpaste';

  @override
  String get configureCatMotherboard => 'Mainboard';

  @override
  String get configureCatRam => 'Arbeitsspeicher (RAM)';

  @override
  String get configureCatGpu => 'Grafikkarte (GPU)';

  @override
  String get configureCatStorage => 'Speicher (SSD / HDD)';

  @override
  String get configureCatCase => 'Gehäuse';

  @override
  String get configureCatCaseFans => 'Gehäuselüfter';

  @override
  String get configureCatFanController => 'Lüftersteuerung';

  @override
  String get configureCatCaseAccessories => 'Gehäuse-Zubehör';

  @override
  String get configureCatPsu => 'Netzteil (PSU)';

  @override
  String get configureCatWifi => 'WLAN-Karte';

  @override
  String get configureCatEthernet => 'LAN-Karte';

  @override
  String get configureCatSoundCard => 'Soundkarte';

  @override
  String get configureCatOpticalDrive => 'Optisches Laufwerk';

  @override
  String get configureCatExternalHdd => 'Externe Festplatte';

  @override
  String get configureCatUps => 'USV';

  @override
  String get configureCatOs => 'Betriebssystem';

  @override
  String get configureChooseCpu => 'CPU auswählen';

  @override
  String get configureChooseCpuCooler => 'CPU-Kühler auswählen';

  @override
  String get configureChooseThermalPaste => 'Wärmeleitpaste auswählen';

  @override
  String get configureChooseMotherboard => 'Mainboard auswählen';

  @override
  String get configureChooseRam => 'RAM auswählen';

  @override
  String get configureChooseGpu => 'Grafikkarte auswählen';

  @override
  String get configureChooseStorage => 'Speicher auswählen';

  @override
  String get configureChooseCase => 'Gehäuse auswählen';

  @override
  String get configureChooseCaseFans => 'Gehäuselüfter auswählen';

  @override
  String get configureChooseFanController => 'Lüftersteuerung auswählen';

  @override
  String get configureChooseCaseAccessories => 'Zubehör auswählen';

  @override
  String get configureChoosePsu => 'Netzteil auswählen';

  @override
  String get configureChooseWifi => 'WLAN-Karte auswählen';

  @override
  String get configureChooseEthernet => 'LAN-Karte auswählen';

  @override
  String get configureChooseSoundCard => 'Soundkarte auswählen';

  @override
  String get configureChooseOpticalDrive => 'Optisches Laufwerk auswählen';

  @override
  String get configureChooseExternalHdd => 'Externe Festplatte auswählen';

  @override
  String get configureChooseUps => 'USV auswählen';

  @override
  String get configureChooseOs => 'Betriebssystem auswählen';

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

  @override
  String get compatibilityOk => 'KOMPATIBILITÄT: OK';

  @override
  String get compatibilityWarning => 'KOMPATIBILITÄTS-WARNUNG';

  @override
  String get compatibilityError => 'KOMPATIBILITÄTSFEHLER';

  @override
  String get compatibilityViewDetails => 'DETAILS';

  @override
  String get compatibilityDetails => 'Kompatibilitäts-Details';

  @override
  String get compatibilityNoIssues =>
      'Alle geprüften Komponenten sind kompatibel.';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonRename => 'Umbenennen';

  @override
  String get commonDuplicate => 'Duplizieren';

  @override
  String get commonView => 'Ansehen';

  @override
  String get commonApply => 'Anwenden';

  @override
  String get commonAdd => 'Hinzufügen';

  @override
  String get commonYes => 'Ja';

  @override
  String get commonNo => 'Nein';

  @override
  String get buildDialogEditTitle => 'Build bearbeiten';

  @override
  String get buildDialogNameHint => 'Build-Name';

  @override
  String get buildDialogCoverLabel => 'Cover-Bild (optional)';

  @override
  String get buildDialogDuplicateTitle => 'Build duplizieren';

  @override
  String get buildDialogDuplicateNameHint => 'Name des Duplikats';

  @override
  String buildDialogCopyOf(String title) {
    return 'Kopie von $title';
  }

  @override
  String get buildDialogDeleteTitle => 'Build löschen';

  @override
  String buildDialogDeleteContent(String title) {
    return '\"$title\" dauerhaft löschen?';
  }

  @override
  String buildDialogSaved(String title) {
    return '\"$title\" wurde gespeichert.';
  }

  @override
  String buildDialogDuplicateError(String error) {
    return 'Fehler beim Duplizieren: $error';
  }

  @override
  String get buildsNoBuilds => 'Noch keine Builds gespeichert';

  @override
  String get buildsStartNew => 'Neuen Build starten';

  @override
  String get buildsSignInPrompt => 'Anmelden, um deine Builds zu sehen.';

  @override
  String get myBuildsTitle => 'Meine Builds';

  @override
  String get myBuildsSearchHint => 'Builds durchsuchen…';

  @override
  String get myBuildsFilters => 'Filter';

  @override
  String get myBuildsFilterAll => 'Alle Builds';

  @override
  String get myBuildsFilterCompleted => 'Abgeschlossen';

  @override
  String get myBuildsFilterInProgress => 'In Bearbeitung';

  @override
  String get myBuildsFilterImported => 'Importiert';

  @override
  String get buildStatusCompleted => 'ABGESCHLOSSEN';

  @override
  String get buildStatusDraft => 'ENTWURF';

  @override
  String get buildStatusArchived => 'ARCHIVIERT';

  @override
  String get buildStatusInProgress => 'IN BEARBEITUNG';

  @override
  String get buildStatusImported => 'IMPORTIERT';

  @override
  String get buildCardEstimatedCost => 'GESCHÄTZTE KOSTEN';

  @override
  String get buildCardProgress => 'FORTSCHRITT';

  @override
  String get buildCardShare => 'Teilen';

  @override
  String get buildCardMore => 'Mehr';

  @override
  String get templateTitle => 'Build-Vorlagen';

  @override
  String get templateDescription =>
      'Wähle eine Vorlage als Ausgangspunkt für dein Build. Alle Komponenten können anschließend frei angepasst werden.';

  @override
  String get templateBudgetGamingTagline =>
      'Maximale Performance für kleines Budget';

  @override
  String get templateHighEndGamingTagline =>
      'Kompromisslose Performance für 4K & 144 Hz';

  @override
  String get templateOfficeTagline =>
      'Zuverlässig und effizient für den Büroalltag';

  @override
  String get templateWorkstationTagline =>
      'Professionelle Leistung für anspruchsvolle Aufgaben';

  @override
  String get templateMiniItxTagline =>
      'Maximale Leistung im kleinsten Formfaktor';

  @override
  String get templateSilentTagline =>
      'Leise wie eine Bibliothek – maximaler Komfort';

  @override
  String get sharedLinkCopied => 'Link kopiert!';

  @override
  String get sharedBuildNotFound => 'Build nicht gefunden';

  @override
  String get sharedBuildNotFoundDesc =>
      'Dieser Link ist ungültig oder wurde noch nicht geteilt.';

  @override
  String get shareTitle => 'Build teilen';

  @override
  String get shareReadOnly => 'Nur ansehen';

  @override
  String get shareGenerating => 'Link wird generiert…';

  @override
  String get shareGeneratingError => 'Fehler beim Generieren';

  @override
  String get shareCopy => 'Kopieren';

  @override
  String get shareDirectSection => 'DIREKT TEILEN';

  @override
  String get shareInstagramCopied =>
      'Link kopiert – füge ihn in Instagram DM ein.';

  @override
  String get shareCouldNotOpen => 'Konnte nicht geöffnet werden.';

  @override
  String shareMessageText(String title, String url) {
    return 'Schau dir meinen PC-Build \"$title\" an: $url';
  }

  @override
  String shareEmailSubject(String title) {
    return 'BuildMyPC – $title';
  }

  @override
  String get partsSearchHint => 'Teile suchen';

  @override
  String partsProductsFound(int count) {
    return '$count Produkte gefunden';
  }

  @override
  String get partsNoProductsFound => '0 Produkte gefunden';

  @override
  String get partsComponentType => 'Komponententyp';

  @override
  String get partsSpecs => 'Spezifikationen';

  @override
  String get partsSort => 'Sortierung';

  @override
  String get partsOrder => 'Reihenfolge';

  @override
  String get partsNoData => 'Keine Daten geladen';

  @override
  String get partsNoDataSubtitle => 'Keine Teile in einer Kollektion gefunden.';

  @override
  String get partsNoResults => 'Keine Ergebnisse';

  @override
  String get partsNoResultsSubtitle => 'Filter oder Suche anpassen.';

  @override
  String get partsLoadMore => 'Mehr laden';

  @override
  String get partsAddToConfig => 'Hinzufügen';

  @override
  String get partsNoSpecs => 'Keine Spezifikationen verfügbar.';

  @override
  String get partsDataCompleteness => 'Datenvollständigkeit';

  @override
  String get partsDataCompletenessHint =>
      'Komponenten nach Vollständigkeit der Spezifikationsdaten filtern';

  @override
  String get partsShowAll => 'Alle anzeigen';

  @override
  String get partsCompatibilityOnly => 'Kompatibilität';

  @override
  String get partsAllComponents => 'Alle Komponenten';

  @override
  String get partsSortPriceLowToHigh => 'Preis: Aufsteigend';

  @override
  String get partsSortPriceHighToLow => 'Preis: Absteigend';

  @override
  String get partsSortNameAtoZ => 'Name: A bis Z';

  @override
  String get partsPriceRange => 'Preisbereich';

  @override
  String get configureSelectComponent =>
      'Mindestens eine Komponente auswählen, um den Build zu speichern.';

  @override
  String get configureSignInPrompt =>
      'Bitte anmelden. Dein Build wird automatisch gespeichert.';

  @override
  String configureSaveBuildError(String error) {
    return 'Build konnte nicht gespeichert werden: $error';
  }

  @override
  String get configureSaveBuildTitle => 'Build speichern';

  @override
  String get configureSaving => 'WIRD GESPEICHERT...';

  @override
  String get configureAddToMyBuilds => 'ZU MEINEN BUILDS';

  @override
  String configureMissingData(String slot, String fields) {
    return '$slot: Fehlende Daten – $fields';
  }

  @override
  String configureMissingDataTooltip(String fields) {
    return 'Fehlende Daten: $fields';
  }

  @override
  String get configureAdd => 'Hinzufügen';

  @override
  String get configureExtras => 'EXTRAS';

  @override
  String configureSelectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String configureImportedFrom(String title, String author) {
    return '$title von $author';
  }

  @override
  String get compatIncompatible => 'Inkompatibel';

  @override
  String get compatSingleError => '1 kritischer Fehler';

  @override
  String compatMultipleErrors(int count) {
    return '$count kritische Fehler';
  }

  @override
  String get compatSingleWarning => '1 Warnung erkannt';

  @override
  String compatMultipleWarnings(int count) {
    return '$count Warnungen erkannt';
  }

  @override
  String get compatWarning => 'Warnung';

  @override
  String get compatCompatible => 'Kompatibel';

  @override
  String get compatAllCompatible => 'Alle Komponenten sind kompatibel';

  @override
  String get compatOverallStatus => 'GESAMTSTATUS';

  @override
  String get guidedCardHeader => 'BUILD-VORLAGEN';

  @override
  String get guidedCardDescription =>
      'Starte mit einer vorkonfigurierten Vorlage – Budget Gaming, Office, High-End oder Workstation.';

  @override
  String get guidedCardButton => 'Vorlage auswählen';

  @override
  String get startNewBuildTitle => 'Neuen Build starten';

  @override
  String get startNewBuildSubtitle => 'Manuell · Teileauswahl';

  @override
  String get partsSpecsReset => 'Zurücksetzen';

  @override
  String get partsSpecsAny => 'Beliebig';

  @override
  String get specLabelSize => 'Größe';

  @override
  String get specLabelAirflow => 'Luftdurchsatz';

  @override
  String get specLabelChannels => 'Kanäle';

  @override
  String get specLabelChannelWattage => 'Kanalleistung';

  @override
  String get specLabelMemory => 'VRAM';

  @override
  String get specLabelEfficiency => 'Effizienz';

  @override
  String get specLabelBluRayRead => 'Blu-ray (Lesen)';

  @override
  String get specLabelBluRayWrite => 'Blu-ray (Schreiben)';

  @override
  String get specLabelDvdRead => 'DVD (Lesen)';

  @override
  String get specLabelDvdWrite => 'DVD (Schreiben)';

  @override
  String get specLabelCdRead => 'CD (Lesen)';

  @override
  String get specLabelCdWrite => 'CD (Schreiben)';

  @override
  String get specLabelMode => 'Modus';

  @override
  String get specLabelCapacityVa => 'Kapazität (VA)';

  @override
  String get specLabelCapacityW => 'Kapazität (W)';

  @override
  String get specLabelProtocol => 'Protokoll';

  @override
  String get specLabelSampleRate => 'Abtastrate';

  @override
  String get specLabelSnr => 'Rauschabstand';

  @override
  String get specLabelDigitalAudio => 'Digital-Audio';

  @override
  String get specLabelAmount => 'Menge';

  @override
  String get specLabelInternal35Bays => 'Interne 3,5\"-Schächte';

  @override
  String get partsTypeCpuCooler => 'CPU-Kühler';

  @override
  String get partsTypeStorage => 'Speicher';

  @override
  String get partsTypePowerSupply => 'Netzteil';

  @override
  String get partsTypeCase => 'Gehäuse';

  @override
  String get partsTypeCaseFan => 'Gehäuselüfter';

  @override
  String get partsTypeEthernetCard => 'LAN-Karte';

  @override
  String get partsTypeWifiCard => 'WLAN-Karte';

  @override
  String get partsTypeSoundCard => 'Soundkarte';

  @override
  String get partsTypeOpticalDrive => 'Optisches Laufwerk';

  @override
  String get partsTypeFanController => 'Lüftersteuerung';

  @override
  String get partsTypeThermalPaste => 'Wärmeleitpaste';

  @override
  String get partsTypeExternalStorage => 'Externe Festplatte';

  @override
  String get partsTypeUps => 'USV';

  @override
  String get partsTypeCaseAccessory => 'Gehäuse-Zubehör';

  @override
  String get specLabelBrand => 'Marke';

  @override
  String get specLabelCoreCount => 'Kernanzahl';

  @override
  String get specLabelCoreClock => 'Kerntakt';

  @override
  String get specLabelBoostClock => 'Boost-Takt';

  @override
  String get specLabelMicroarchitecture => 'Mikroarchitektur';

  @override
  String get specLabelIntegratedGraphics => 'Integrierte Grafik';

  @override
  String get specLabelChipset => 'Chipsatz';

  @override
  String get specLabelColor => 'Farbe';

  @override
  String get specLabelVram => 'VRAM';

  @override
  String get specLabelLength => 'Länge';

  @override
  String get specLabelDdrGeneration => 'DDR-Generation';

  @override
  String get specLabelModules => 'Module';

  @override
  String get specLabelModuleSize => 'Modulkapazität';

  @override
  String get specLabelSpeed => 'Takt';

  @override
  String get specLabelCasLatency => 'CAS-Latenz';

  @override
  String get specLabelFirstWordLatency => 'Erste-Wort-Latenz';

  @override
  String get specLabelPricePerGb => 'Preis / GB';

  @override
  String get specLabelCapacity => 'Kapazität';

  @override
  String get specLabelFormFactor => 'Formfaktor';

  @override
  String get specLabelInterface => 'Schnittstelle';

  @override
  String get specLabelSocket => 'Sockel';

  @override
  String get specLabelMaxMemory => 'Max. Arbeitsspeicher';

  @override
  String get specLabelMemorySlots => 'Speichersteckplätze';

  @override
  String get specLabelType => 'Typ';

  @override
  String get specLabelWattage => 'Leistung';

  @override
  String get specLabelEfficiencyCertification => 'Effizienz-Zertifizierung';

  @override
  String get specLabelNoiseLevel => 'Lautstärke';

  @override
  String get specLabelRpm => 'U/min';

  @override
  String get specLabelSidePanel => 'Seitenblende';

  @override
  String get specLabelIncludedPsu => 'Enthaltenes Netzteil';

  @override
  String get specLabelExternalVolume => 'Externes Volumen';

  @override
  String get specLabelBays35 => '3,5\"-Schächte';

  @override
  String compatPowerLoad(int percent) {
    return '$percent% Auslastung';
  }

  @override
  String compatPowerBuffer(int watts) {
    return '${watts}W Puffer';
  }

  @override
  String compatPowerInsufficient(int watts) {
    return '${watts}W zu wenig';
  }

  @override
  String get compatCriticalErrors => 'Kritische Fehler';

  @override
  String get compatWarnings => 'Warnungen';

  @override
  String compatMissingRequiredParts(String parts) {
    return 'Fehlende Pflichtteile: $parts.';
  }

  @override
  String compatSocketMismatch(String cpuSocket, String mbSocket) {
    return 'Der Sockel des Prozessors ($cpuSocket) passt nicht zum Mainboard ($mbSocket).';
  }

  @override
  String compatSocketOk(String socket) {
    return 'Prozessor und Mainboard sind sockelkompatibel ($socket).';
  }

  @override
  String compatDdr5Required(String socket, int ddrGen) {
    return 'Das Mainboard ($socket) unterstützt nur DDR5-RAM – ausgewählt ist DDR$ddrGen.';
  }

  @override
  String compatDdr4Required(String socket, int ddrGen) {
    return 'Das Mainboard ($socket) unterstützt nur DDR4-RAM – ausgewählt ist DDR$ddrGen.';
  }

  @override
  String compatRamOk(int ddrGen) {
    return 'Arbeitsspeicher (DDR$ddrGen) ist mit dem Mainboard kompatibel.';
  }

  @override
  String compatFormFactorIncompatible(String formFactor) {
    return 'Das Gehäuse unterstützt den Formfaktor des Mainboards ($formFactor) nicht.';
  }

  @override
  String compatFormFactorOk(String formFactor) {
    return 'Das Mainboard ($formFactor) ist mit dem Gehäuse kompatibel.';
  }

  @override
  String compatPsuInsufficient(int psuW, int estimatedW) {
    return 'Das Netzteil (${psuW}W) reicht für den geschätzten Verbrauch (~${estimatedW}W) nicht aus.';
  }

  @override
  String compatPsuLowBuffer(int psuW, int estimatedW) {
    return 'Netzteil-Puffer gering: ${psuW}W für ~${estimatedW}W Verbrauch – empfohlen sind mind. 20% Reserve.';
  }

  @override
  String compatPsuAdequate(int psuW, int estimatedW) {
    return 'Das Netzteil (${psuW}W) hat ausreichend Reserve für den geschätzten Verbrauch (~${estimatedW}W).';
  }

  @override
  String get compatBiosUpdateAmd =>
      'Ryzen 9000 auf Nicht-X870-Board: möglicherweise ist ein BIOS-Update nötig, bevor der Prozessor erkannt wird.';

  @override
  String get compatBiosUpdateIntel =>
      'Intel 14. Gen auf 600er-Board: BIOS-Update erforderlich, bevor der Prozessor erkannt wird.';

  @override
  String compatXmpRequired(int ramMhz, int jedecMhz) {
    return 'RAM läuft mit ${ramMhz}MHz über dem JEDEC-Standard (${jedecMhz}MHz) – XMP/EXPO muss im BIOS aktiviert werden.';
  }

  @override
  String get compatDdr5BudgetBoard =>
      'DDR5 auf Einstiegs-Board: Bei hohen Taktraten kann es zu Stabilitätsproblemen kommen – QVL-Liste des Mainboards prüfen.';

  @override
  String compatTooManyRamSticks(int totalSticks, int maxSlots) {
    return '$totalSticks RAM-Riegel ausgewählt, das Mainboard unterstützt jedoch nur $maxSlots Steckplätze.';
  }

  @override
  String compatRamSlotsOk(int totalSticks, int maxSlots) {
    return 'Die $totalSticks gewählten RAM-Riegel passen in die $maxSlots Steckplätze des Mainboards.';
  }
}
