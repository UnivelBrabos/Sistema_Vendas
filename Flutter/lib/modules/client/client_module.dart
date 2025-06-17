import 'package:flutter_modular/flutter_modular.dart';
import 'client_selection_page.dart';

class ClientModule extends Module {
  @override
  List<ModularRoute> get routes => [
    ChildRoute('/', child: (_, __) => const ClientSelectionPage()),
  ];
}
