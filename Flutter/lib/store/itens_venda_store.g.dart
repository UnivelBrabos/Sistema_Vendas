// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itens_venda_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ItensVendaStore on _ItensVendaStoreBase, Store {
  late final _$itensAtom =
      Atom(name: '_ItensVendaStoreBase.itens', context: context);

  @override
  ObservableList<Map<String, dynamic>> get itens {
    _$itensAtom.reportRead();
    return super.itens;
  }

  @override
  set itens(ObservableList<Map<String, dynamic>> value) {
    _$itensAtom.reportWrite(value, super.itens, () {
      super.itens = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ItensVendaStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$fetchItensAsyncAction =
      AsyncAction('_ItensVendaStoreBase.fetchItens', context: context);

  @override
  Future<void> fetchItens(int idVenda) {
    return _$fetchItensAsyncAction.run(() => super.fetchItens(idVenda));
  }

  @override
  String toString() {
    return '''
itens: ${itens},
isLoading: ${isLoading}
    ''';
  }
}
