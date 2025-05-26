import 'package:flutter_modular/flutter_modular.dart';
import 'home_page.dart';

class HomeModule extends Module {
  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      '/',
      child: (_, args) {
        final data = args.data as Map<String, dynamic>? ?? {};
        return HomePage(
          email: data['email'] as String? ?? '',
        );
      },
    ),
  ];
}
