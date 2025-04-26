class ClienteModel {
  final int idCliente;
  final String nome;
  final String cnpj;
  final String telefone;
  final String endereco;
  final String email;

  ClienteModel({
    required this.idCliente,
    required this.nome,
    required this.cnpj,
    required this.telefone,
    required this.endereco,
    required this.email,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      idCliente: json['id_cliente'] as int,
      nome: json['nome'] as String,
      cnpj: json['cnpj'] as String,
      telefone: json['telefone'] as String,
      endereco: json['endereco'] as String,
      email: (json['email'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_cliente': idCliente,
      'nome': nome,
      'cnpj': cnpj,
      'telefone': telefone,
      'endereco': endereco,
      'email': email,
    };
  }
}
