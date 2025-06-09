import '../../models/venda_model.dart';
import '../../repository/venda_repository.dart';
import '../../repository/itens_venda_repository.dart';

class VendaController {
  final VendaRepository _vendaRepo;
  final ItensVendaRepository _itemRepo;

  VendaController(this._vendaRepo, this._itemRepo);

  Future<void> salvarVenda({
    required int idVendedor,
    required int idCliente,
    required double total,
    required int desconto,
    required List<Map<String, dynamic>> items,
  }) async {
    final venda = VendaModel(
      idVendedor: idVendedor,
      idCliente: idCliente,
      dataVenda: DateTime.now(),
      total: total,
      desconto: desconto,
    );

    final saleId = await _vendaRepo.createVenda(venda);

    for (final item in items) {
      final itemJson = {
        'id_venda'       : saleId,
        'id_produto'     : item['id_produto'] as int,
        'quantidade'     : item['quantidade'] as int,
        'quantidade_lote': item['quantidade'] as int,
        'subtotal'       : (item['subtotal'] as num).toDouble(),
      };
      await _itemRepo.insertItem(itemJson);
    }
  }
}
