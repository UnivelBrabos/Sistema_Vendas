import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../repository/itens_venda_repository.dart';

part 'itens_venda_store.g.dart';

class ItensVendaStore = _ItensVendaStoreBase with _$ItensVendaStore;

abstract class _ItensVendaStoreBase with Store {
  final ItensVendaRepository _repo = ItensVendaRepository();

  @observable
  ObservableList<Map<String, dynamic>> itens = ObservableList<Map<String, dynamic>>();

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchItens(int idVenda) async {
    isLoading = true;
    try {
      final lista = await _repo.fetchItensPorVenda(idVenda);
      itens = ObservableList.of(lista);
    } catch (e) {
      debugPrint('Erro ao buscar itens de venda: $e');
    } finally {
      isLoading = false;
    }
  }
}
