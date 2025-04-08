class VendaModel {
  final int idVendedor;
  final int idCliente;
  final String formaPagamento;
  final double total;
  final DateTime dataVenda;

  VendaModel({
    required this.idVendedor,
    required this.idCliente,
    required this.formaPagamento,
    required this.total,
    required this.dataVenda,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_vendedor': idVendedor,
      'id_cliente': idCliente,
      'forma_pagamento': formaPagamento,
      'total': total,
      'data_venda': dataVenda.toIso8601String(),
    };
  }
}
