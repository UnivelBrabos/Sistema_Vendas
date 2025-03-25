import 'package:flutter_modular/flutter_modular.dart';

class AuthController {
  void login(String email, String password) {
    if (email == 'admin.teste@gmail.com' && password == 'admin123') {
      Modular.to.pushReplacementNamed('/home');
    } else {
      print('Credenciais inválidas');
    }
  }
}
