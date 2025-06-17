import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

import '../../store/settings_store.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Modular.get<SettingsStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Observer(builder: (_) {
        return ListView(
          children: [
            SwitchListTile(
              title: const Text('Tema Escuro'),
              secondary: const Icon(Icons.brightness_6),
              value: settings.isDarkMode,
              onChanged: (v) => settings.setDarkMode(v),
            ),
            SwitchListTile(
              title: const Text('Notificações'),
              secondary: const Icon(Icons.notifications),
              value: settings.notificationsEnabled,
              onChanged: (v) => settings.setNotificationsEnabled(v),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.cleaning_services),
              title: const Text('Limpar Cache'),
              onTap: () {
                // TODO: implementar limpeza de cache/local storage
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache limpo!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre'),
              subtitle: const Text('v1.0.0'),
              onTap: () {
                // TODO: navegar para tela Sobre/Política
              },
            ),
          ],
        );
      }),
    );
  }
}
