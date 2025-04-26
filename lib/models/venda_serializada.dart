import 'package:trabalho_vendas_univel/models/cliente_model.dart';
import 'package:trabalho_vendas_univel/models/itens_venda_model.dart';
import 'package:trabalho_vendas_univel/models/venda_model.dart';

class VendaSerializada {
  final List<ClienteModel> clientes;
  final VendaModel venda;
  final List<ItensVendaModel> itensVenda;

  VendaSerializada({
    required this.clientes,
    required this.venda,
    required this.itensVenda,
  });

  Map<String, dynamic> toJson() {
    return {
      'Clientes': {
        'data': clientes.map((c) => c.toJson()).toList(),
        'count': null,
      },
      'Venda': venda.toJson(),
      'ItensVenda': itensVenda.map((i) => i.toJson()).toList(),
    };
  }
}
