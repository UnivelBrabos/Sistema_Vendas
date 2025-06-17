// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProdutoStore on _ProdutoStoreBase, Store {
  late final _$produtosAtom =
      Atom(name: '_ProdutoStoreBase.produtos', context: context);

  @override
  ObservableList<Map<String, dynamic>> get produtos {
    _$produtosAtom.reportRead();
    return super.produtos;
  }

  @override
  set produtos(ObservableList<Map<String, dynamic>> value) {
    _$produtosAtom.reportWrite(value, super.produtos, () {
      super.produtos = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ProdutoStoreBase.isLoading', context: context);

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

  late final _$fetchProdutosAsyncAction =
      AsyncAction('_ProdutoStoreBase.fetchProdutos', context: context);

  @override
  Future<void> fetchProdutos() {
    return _$fetchProdutosAsyncAction.run(() => super.fetchProdutos());
  }

  late final _$decrementStockAsyncAction =
      AsyncAction('_ProdutoStoreBase.decrementStock', context: context);

  @override
  Future<void> decrementStock(int idProduto, int qty) {
    return _$decrementStockAsyncAction
        .run(() => super.decrementStock(idProduto, qty));
  }

  @override
  String toString() {
    return '''
produtos: ${produtos},
isLoading: ${isLoading}
    ''';
  }
}
