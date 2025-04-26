class VendaModel {
  final int idVendedor;
  final int idCliente;
  final double total;
  final DateTime dataVenda;
  final int desconto;

  VendaModel({
    required this.idVendedor,
    required this.idCliente,
    required this.total,
    required this.dataVenda,
    required this.desconto,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_vendedor': idVendedor,
      'id_cliente': idCliente,
      'total': total,
      'data_venda': dataVenda.toIso8601String(),
      'desconto': desconto,
    };
  }
}
