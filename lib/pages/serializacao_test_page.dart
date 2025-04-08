import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trabalho_vendas_univel/models/cliente_model.dart';
import 'package:trabalho_vendas_univel/models/venda_model.dart';
import 'package:trabalho_vendas_univel/models/itens_venda_model.dart';
import 'package:trabalho_vendas_univel/models/venda_serializada.dart';

class SerializacaoTestPage extends StatelessWidget {
  const SerializacaoTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cria um exemplo de cliente
    final cliente = ClienteModel(
      idCliente: 6,
      nome: "Padaria Seu Silva",
      cnpj: "12.111.123/0001-01",
      telefone: "11966666666",
      endereco: "Rua A, 123",
    );

    // Cria um exemplo de venda
    final venda = VendaModel(
      idVendedor: 1,
      idCliente: cliente.idCliente,
      formaPagamento: "Pix",
      total: 150.0,
      dataVenda: DateTime.now(),
    );

    // Cria uma lista de itens de venda
    final itensVenda = [
      ItensVendaModel(idProduto: 101, quantidade: 2, subtotal: 50.0),
      ItensVendaModel(idProduto: 102, quantidade: 1, subtotal: 100.0),
    ];

    // Agrupa tudo na VendaSerializada
    final vendaSerializada = VendaSerializada(
      clientes: [cliente],
      venda: venda,
      itensVenda: itensVenda,
    );

    // Serializa para JSON com indentação
    final prettyJson = const JsonEncoder.withIndent('  ').convert(vendaSerializada.toJson());
    print("JSON gerado:\n$prettyJson");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teste de Serialização"),
      ),
      body: Center(
        child: Text(
          "Confira o console para ver o JSON formatado.",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
