class VendaModel {
  final int idVendedor;
  final int idCliente;
  final DateTime dataVenda;
  final double total;
  final int desconto;

  VendaModel({
    required this.idVendedor,
    required this.idCliente,
    required this.dataVenda,
    required this.total,
    required this.desconto,
  });

  Map<String, dynamic> toJson() => {
        "id_vendedor": idVendedor,
        "id_cliente" : idCliente,
        "data_venda" : dataVenda.toIso8601String(),
        "total"      : total,
        "desconto"   : desconto,
      };
}
