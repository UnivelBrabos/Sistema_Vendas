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
      final idProd = item['id_produto'] as int;
      final qtd    = item['quantidade'] as int;
      final sub    = (item['subtotal'] as num).toDouble();

      final itemJson = {
        'id_venda'       : saleId,
        'id_produto'     : idProd,
        'quantidade'     : qtd,
        'quantidade_lote': qtd,
        'subtotal'       : sub,     
      };

      await _itemRepo.insertItem(itemJson);
    }
  }
}
