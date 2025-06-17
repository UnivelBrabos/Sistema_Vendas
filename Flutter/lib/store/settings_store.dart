import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_store.g.dart';

class SettingsStore = _SettingsStoreBase with _$SettingsStore;

abstract class _SettingsStoreBase with Store {
  @observable
  bool isDarkMode = false;

  @observable
  bool notificationsEnabled = false;

  _SettingsStoreBase() {
    _loadPrefs();
  }

  @action
  Future<void> setDarkMode(bool v) async {
    isDarkMode = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', v);
  }

  @action
  Future<void> setNotificationsEnabled(bool v) async {
    notificationsEnabled = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', v);
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('darkMode') ?? false;
    notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
  }
}
