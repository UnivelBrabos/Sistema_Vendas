// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartStore on _CartStoreBase, Store {
  late final _$cartItemsAtom =
      Atom(name: '_CartStoreBase.cartItems', context: context);

  @override
  ObservableList<Map<String, dynamic>> get cartItems {
    _$cartItemsAtom.reportRead();
    return super.cartItems;
  }

  @override
  set cartItems(ObservableList<Map<String, dynamic>> value) {
    _$cartItemsAtom.reportWrite(value, super.cartItems, () {
      super.cartItems = value;
    });
  }

  late final _$vendaConcluidaAtom =
      Atom(name: '_CartStoreBase.vendaConcluida', context: context);

  @override
  bool get vendaConcluida {
    _$vendaConcluidaAtom.reportRead();
    return super.vendaConcluida;
  }

  @override
  set vendaConcluida(bool value) {
    _$vendaConcluidaAtom.reportWrite(value, super.vendaConcluida, () {
      super.vendaConcluida = value;
    });
  }

  late final _$isSubmittingAtom =
      Atom(name: '_CartStoreBase.isSubmitting', context: context);

  @override
  bool get isSubmitting {
    _$isSubmittingAtom.reportRead();
    return super.isSubmitting;
  }

  @override
  set isSubmitting(bool value) {
    _$isSubmittingAtom.reportWrite(value, super.isSubmitting, () {
      super.isSubmitting = value;
    });
  }

  late final _$concluirVendaAsyncAction =
      AsyncAction('_CartStoreBase.concluirVenda', context: context);

  @override
  Future<String?> concluirVenda(String clienteId) {
    return _$concluirVendaAsyncAction.run(() => super.concluirVenda(clienteId));
  }

  late final _$_CartStoreBaseActionController =
      ActionController(name: '_CartStoreBase', context: context);

  @override
  void addItem(Map<String, dynamic> product, int quantity) {
    final _$actionInfo = _$_CartStoreBaseActionController.startAction(
        name: '_CartStoreBase.addItem');
    try {
      return super.addItem(product, quantity);
    } finally {
      _$_CartStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItem(Map<String, dynamic> product) {
    final _$actionInfo = _$_CartStoreBaseActionController.startAction(
        name: '_CartStoreBase.removeItem');
    try {
      return super.removeItem(product);
    } finally {
      _$_CartStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCart() {
    final _$actionInfo = _$_CartStoreBaseActionController.startAction(
        name: '_CartStoreBase.clearCart');
    try {
      return super.clearCart();
    } finally {
      _$_CartStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetVendaFlag() {
    final _$actionInfo = _$_CartStoreBaseActionController.startAction(
        name: '_CartStoreBase.resetVendaFlag');
    try {
      return super.resetVendaFlag();
    } finally {
      _$_CartStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cartItems: ${cartItems},
vendaConcluida: ${vendaConcluida},
isSubmitting: ${isSubmitting}
    ''';
  }
}
