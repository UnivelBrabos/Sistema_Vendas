class ClienteModel {
  final int idCliente;
  final String nome;
  final String cnpj;
  final String telefone;
  final String endereco;

  ClienteModel({
    required this.idCliente,
    required this.nome,
    required this.cnpj,
    required this.telefone,
    required this.endereco,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      idCliente: json['id_cliente'],
      nome: json['nome'],
      cnpj: json['cnpj'],
      telefone: json['telefone'],
      endereco: json['endereco'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_cliente': idCliente,
      'nome': nome,
      'cnpj': cnpj,
      'telefone': telefone,
      'endereco': endereco,
    };
  }
}
