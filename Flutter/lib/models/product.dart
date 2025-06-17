
class Product {
  final int idProduto;
  final String nome;
  final String descricao;
  final double preco;
  final int estoque;
  final int lote;
  final int categoriaProduto;

  Product({
    required this.idProduto,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.estoque,
    required this.lote,
    required this.categoriaProduto,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProduto: json['id_produto'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      preco: (json['preco'] as num).toDouble(),
      estoque: json['estoque'] as int,
      lote: json['lote'] as int,
      categoriaProduto: json['categoria_produto'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_produto': idProduto,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'estoque': estoque,
      'lote': lote,
      'categoria_produto': categoriaProduto,
    };
  }
}
