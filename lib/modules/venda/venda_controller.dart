import 'package:trabalho_vendas_univel/models/itens_venda_model.dart';
import 'package:trabalho_vendas_univel/models/venda_model.dart';
import 'package:trabalho_vendas_univel/repository/venda_repository.dart';
import 'package:trabalho_vendas_univel/repository/itens_venda_repository.dart';

class VendaController {
  final VendaRepository _vendaRepo = VendaRepository();
  final ItensVendaRepository _itemRepo = ItensVendaRepository();

  /// Orquestra criação da venda e inserção dos itens.
  Future<void> emitirVenda({
    required VendaModel venda,
    required List<ItensVendaModel> itens,
  }) async {
    final saleId = await _vendaRepo.createVenda(venda);

    for (var item in itens) {
      final itemComVenda = ItensVendaModel(
        idVenda: saleId,
        idProduto: item.idProduto,
        quantidadeLote: item.quantidadeLote,
        subtotal: item.subtotal, quantidade: item.quantidade ?? 0,
      );
      await _itemRepo.insertItem(itemComVenda);
    }
  }

  salvarVenda({required int idVendedor, required int idCliente, required double total, required int desconto}) {}
}
