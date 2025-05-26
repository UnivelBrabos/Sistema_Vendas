import '../../models/venda_model.dart';
import '../../models/itens_venda_model.dart';
import '../../repository/venda_repository.dart';
import '../../repository/itens_venda_repository.dart';


class VendaController {
  final VendaRepository _vendaRepo = VendaRepository();
  final ItensVendaRepository _itemRepo  = ItensVendaRepository();

  VendaController(Object object);

  Future<void> salvarVenda({
    required int idVendedor,
    required int idCliente,
    required double total,
    required int desconto,
    required List<Map<String, dynamic>> items,
  }) async {
    final venda = VendaModel(
      idVendedor: idVendedor,
      idCliente:  idCliente,
      dataVenda:  DateTime.now(),
      total:      total,
      desconto:   desconto,
    );

    final saleId = await _vendaRepo.createVenda(venda);

    for (final item in items) {
      final iv = ItensVendaModel(
        idVenda:       saleId,
        idProduto:     item['id_produto'] as int,
        quantidade:    item['quantidade']  as int,
        quantidadeLote: item['quantidade'], 
        subtotal:      (item['subtotal']    as num).toDouble(),
      );
      await _itemRepo.insertItem(iv);
    }
  }
}
