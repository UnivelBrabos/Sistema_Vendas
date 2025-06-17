// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsStore on _SettingsStoreBase, Store {
  late final _$isDarkModeAtom =
      Atom(name: '_SettingsStoreBase.isDarkMode', context: context);

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  late final _$notificationsEnabledAtom =
      Atom(name: '_SettingsStoreBase.notificationsEnabled', context: context);

  @override
  bool get notificationsEnabled {
    _$notificationsEnabledAtom.reportRead();
    return super.notificationsEnabled;
  }

  @override
  set notificationsEnabled(bool value) {
    _$notificationsEnabledAtom.reportWrite(value, super.notificationsEnabled,
        () {
      super.notificationsEnabled = value;
    });
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('_SettingsStoreBase.setDarkMode', context: context);

  @override
  Future<void> setDarkMode(bool v) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(v));
  }

  late final _$setNotificationsEnabledAsyncAction = AsyncAction(
      '_SettingsStoreBase.setNotificationsEnabled',
      context: context);

  @override
  Future<void> setNotificationsEnabled(bool v) {
    return _$setNotificationsEnabledAsyncAction
        .run(() => super.setNotificationsEnabled(v));
  }

  @override
  String toString() {
    return '''
isDarkMode: ${isDarkMode},
notificationsEnabled: ${notificationsEnabled}
    ''';
  }
}
