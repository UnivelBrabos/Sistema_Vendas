import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../repository/venda_repository.dart';

part 'venda_store.g.dart';

class VendaStore = _VendaStoreBase with _$VendaStore;

abstract class _VendaStoreBase with Store {
  final VendaRepository _repo = VendaRepository();

  @observable
  ObservableList<Map<String, dynamic>> vendas = ObservableList<Map<String, dynamic>>();

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchVendasPorVendedor(int idVendedor) async {
    isLoading = true;
    try {
      final all = await _repo.fetchAllVendas();
      final filtradas = all.where((v) => (v['id_vendedor'] as num).toInt() == idVendedor).toList();
      vendas = ObservableList.of(filtradas);
    } catch (e) {
      debugPrint('Erro ao buscar vendas: $e');
    } finally {
      isLoading = false;
    }
  }
}
