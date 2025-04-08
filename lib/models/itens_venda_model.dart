class ItensVendaModel {
  final int idProduto;
  final int quantidade;
  final double subtotal;

  ItensVendaModel({
    required this.idProduto,
    required this.quantidade,
    required this.subtotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_produto': idProduto,
      'quantidade': quantidade,
      'subtotal': subtotal,
    };
  }
}
