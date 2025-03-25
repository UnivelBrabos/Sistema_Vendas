import 'package:flutter_modular/flutter_modular.dart';
import 'cart_page.dart';
import 'cart_controller.dart';

class CartModule extends Module {
  @override
  List<Bind<Object>> get binds => [
    Bind.factory((i) => CartController()),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (_, __) => const CartPage()),
  ];
}
