import 'package:flutter_modular/flutter_modular.dart';
import 'home_page.dart';

class HomeModule extends Module {
  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      '/',
      child: (_, args) => HomePage(email: args.data as String),
    ),
  ];
}
