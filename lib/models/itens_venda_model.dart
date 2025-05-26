class ItensVendaModel {
  final int idVenda;
  final int idProduto;
  final int quantidade;
  final int quantidadeLote;
  final double subtotal;

  ItensVendaModel({
    required this.idVenda,
    required this.idProduto,
    required this.quantidade,
    required this.quantidadeLote,
    required this.subtotal,
  });

  Map<String, dynamic> toJson() => {
        "id_venda"       : idVenda,
        "id_produto"     : idProduto,
        "quantidade"     : quantidade,
        "quantidade_lote": quantidadeLote,
        "subtotal"       : subtotal,
      };
}
