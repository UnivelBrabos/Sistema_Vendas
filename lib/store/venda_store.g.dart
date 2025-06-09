// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venda_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VendaStore on _VendaStoreBase, Store {
  late final _$vendasAtom =
      Atom(name: '_VendaStoreBase.vendas', context: context);

  @override
  ObservableList<Map<String, dynamic>> get vendas {
    _$vendasAtom.reportRead();
    return super.vendas;
  }

  @override
  set vendas(ObservableList<Map<String, dynamic>> value) {
    _$vendasAtom.reportWrite(value, super.vendas, () {
      super.vendas = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_VendaStoreBase.isLoading', context: context);

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

  late final _$fetchVendasPorVendedorAsyncAction =
      AsyncAction('_VendaStoreBase.fetchVendasPorVendedor', context: context);

  @override
  Future<void> fetchVendasPorVendedor(int idVendedor) {
    return _$fetchVendasPorVendedorAsyncAction
        .run(() => super.fetchVendasPorVendedor(idVendedor));
  }

  @override
  String toString() {
    return '''
vendas: ${vendas},
isLoading: ${isLoading}
    ''';
  }
}
