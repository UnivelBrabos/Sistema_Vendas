import 'package:flutter_modular/flutter_modular.dart';
import 'cart_page.dart';

class CartModule extends Module {
  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      '/',
      child: (_, args) {
        final data = args.data;
        if (data is String) {
          return CartPage(email: data);
        }
        final map = data as Map<String, dynamic>;
        return CartPage(email: map['email'] as String);
      },
    ),
  ];
}
