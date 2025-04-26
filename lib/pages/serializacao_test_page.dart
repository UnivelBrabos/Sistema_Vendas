// nao foi utilizado o arquivo serializacao_test_page.dart, mas foi mantido para fins de teste e aprendizado
// e para que o aluno possa entender como funciona a serializacao de objetos em dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trabalho_vendas_univel/models/cliente_model.dart';
import 'package:trabalho_vendas_univel/models/itens_venda_model.dart';
import 'package:trabalho_vendas_univel/models/venda_model.dart';
import 'package:trabalho_vendas_univel/models/venda_serializada.dart';

class SerializacaoTestPage extends StatelessWidget {
  const SerializacaoTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1) Exemplo de venda
    final venda = VendaModel(
      idVendedor: 1,
      idCliente: 1,
      total: 100.0,
      dataVenda: DateTime.now(),
      desconto: 0,
    );

    // 2) Exemplo de itens — repare nos parâmetros: idVenda, idProduto, quantidadeLote, subtotal
    final itens = [
      ItensVendaModel(
        idVenda: 0,          
        idProduto: 21,
        quantidadeLote: 2,
        subtotal: 2 * 8.5, quantidade: 2,       
      ),
    ];

    // 3) Exemplo de cliente
    final clientes = [
      ClienteModel(
        idCliente: 1,
        nome: 'Cliente Teste',
        email: 'teste@exemplo.com', cnpj: '', telefone: '', endereco: '',
      ),
    ];

    // 4) Serializa tudo junto
    final vs = VendaSerializada(
      clientes: clientes,
      venda: venda,
      itensVenda: itens,
    );
    final jsonStr = const JsonEncoder.withIndent('  ').convert(vs.toJson());

    return Scaffold(
      appBar: AppBar(title: const Text('Teste de Serialização')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Text(jsonStr)),
      ),
    );
  }
}
