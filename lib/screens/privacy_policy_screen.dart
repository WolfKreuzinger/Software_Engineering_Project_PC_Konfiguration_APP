import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datenschutzerklärung'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        children: [
          _section(
            theme,
            '1. Verantwortlicher',
            'Verantwortlich für die Datenverarbeitung in der App BuildMyPC ist das '
                'Entwicklerteam des Software-Engineering-Projekts. Kontakt: '
                'luca.hansche@gmx.de',
          ),
          _section(
            theme,
            '2. Erhobene Daten',
            'Bei der Nutzung der App werden folgende Daten verarbeitet:\n\n'
                '• E-Mail-Adresse und Anzeigename (bei Registrierung oder Google-Anmeldung)\n'
                '• Anonym gespeicherte Nutzungsdaten zur Verbesserung der App\n'
                '• Erstellte PC-Konfigurationen (nur wenn eingeloggt)',
          ),
          _section(
            theme,
            '3. Authentifizierung',
            'Die App nutzt Firebase Authentication von Google LLC für die '
                'Benutzeranmeldung. Bei Verwendung der Google-Anmeldung gelten '
                'zusätzlich die Datenschutzbestimmungen von Google '
                '(policies.google.com/privacy).\n\n'
                'Deine Anmeldedaten werden ausschließlich über sichere '
                'Firebase-Dienste übertragen und gespeichert.',
          ),
          _section(
            theme,
            '4. Datenspeicherung',
            'Nutzerdaten werden in Google Firebase (Cloud Firestore) gespeichert. '
                'Die Server befinden sich in der EU. Firebase ist zertifiziert '
                'nach ISO 27001 und SOC 2/3.\n\n'
                'Daten werden so lange gespeichert, wie ein aktives Konto besteht. '
                'Nach Kontolöschung werden alle personenbezogenen Daten '
                'innerhalb von 30 Tagen entfernt.',
          ),
          _section(
            theme,
            '5. Weitergabe von Daten',
            'Deine Daten werden nicht an Dritte weitergegeben, mit Ausnahme der '
                'zur App-Funktion notwendigen Firebase-Dienste (Google LLC).',
          ),
          _section(
            theme,
            '6. Deine Rechte',
            'Du hast das Recht auf:\n\n'
                '• Auskunft über gespeicherte Daten\n'
                '• Berichtigung unrichtiger Daten\n'
                '• Löschung deines Kontos und aller damit verbundenen Daten\n'
                '• Einschränkung der Verarbeitung\n'
                '• Datenübertragbarkeit\n\n'
                'Zur Ausübung deiner Rechte wende dich an: luca.hansche@gmx.de',
          ),
          _section(
            theme,
            '7. Änderungen',
            'Wir behalten uns vor, diese Datenschutzerklärung bei Bedarf '
                'anzupassen. Die jeweils aktuelle Version ist in der App einsehbar.',
          ),
          const SizedBox(height: 8),
          Text(
            'Stand: Februar 2026',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(ThemeData theme, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
