import 'package:flutter_modular/flutter_modular.dart';
import 'home_page.dart';
import 'home_controller.dart';

class HomeModule extends Module {
  @override
  List<Bind<Object>> get binds => [
    Bind.factory((i) => HomeController()),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (_, __) => HomePage()),
  ];
}
