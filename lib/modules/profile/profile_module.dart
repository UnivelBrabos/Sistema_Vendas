import 'package:flutter_modular/flutter_modular.dart';
import 'profile_page.dart';

class ProfileModule extends Module {
  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      '/', 
      child: (_, args) => ProfilePage(email: args.data),
    ),
  ];
}
