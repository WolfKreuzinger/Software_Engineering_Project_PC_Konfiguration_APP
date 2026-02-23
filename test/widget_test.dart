import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:software_engineering_project_pc_konfiguration_app/app.dart';

class _FakeFirebasePlatform extends FirebasePlatform {
  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return _FakeFirebaseAppPlatform(name);
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return _FakeFirebaseAppPlatform(name ?? defaultFirebaseAppName);
  }

  @override
  List<FirebaseAppPlatform> get apps => [_FakeFirebaseAppPlatform(defaultFirebaseAppName)];
}

class _FakeFirebaseAppPlatform extends FirebaseAppPlatform {
  _FakeFirebaseAppPlatform(String name) : super(name, const FirebaseOptions(apiKey: 'x', appId: 'x', messagingSenderId: 'x', projectId: 'x'));
}

class _FakeAuthPlatform extends FirebaseAuthPlatform {
  _FakeAuthPlatform() : super();

  @override
  Stream<UserPlatform?> authStateChanges() => const Stream.empty();

  @override
  UserPlatform? get currentUser => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    FirebasePlatform.instance = _FakeFirebasePlatform();
    FirebaseAuthPlatform.instance = _FakeAuthPlatform();
  });

  testWidgets('App smoke test', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();
    expect(find.text('BuildMyPC'), findsWidgets);
  });
}
