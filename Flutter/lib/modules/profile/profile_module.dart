import 'package:flutter_modular/flutter_modular.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class ProfileModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (_, args) {
            final data = args.data as Map<String, dynamic>;
            return ProfilePage(
              email: data['email'] as String,
              fotoUrl: data['fotoUrl'] as String?,
            );
          },
        ),

        ChildRoute(
          '/settings',
          child: (_, __) => const SettingsPage(),
        ),
      ];
}
