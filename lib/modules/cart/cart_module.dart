import 'package:flutter_modular/flutter_modular.dart';
import 'cart_page.dart';

class CartModule extends Module {
  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      '/',
      child: (_, args) =>
          CartPage(email: args.data as String), 
    ),
  ];
}
