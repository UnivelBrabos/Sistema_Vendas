import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trabalho_vendas_univel/models/cliente_model.dart';
import 'package:trabalho_vendas_univel/models/itens_venda_model.dart';
import 'package:trabalho_vendas_univel/models/venda_model.dart';
import 'package:trabalho_vendas_univel/models/venda_serializada.dart';

class SerializacaoTestPage extends StatelessWidget {
  const SerializacaoTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final venda = VendaModel(
      idVendedor: 1,
      idCliente: 1,
      dataVenda: DateTime.now(),
      total: 100.0,
      desconto: 0,
    );

    final itens = [
      ItensVendaModel(
        idVenda: venda.idVendedor,       
        idProduto: 21,
        quantidade: 2,
        quantidadeLote: 2,
        subtotal: 2 * 8.5,
      ),
    ];

    final clientes = [
      ClienteModel(
        idCliente: 1,
        nome: 'Cliente Teste',
        email: 'teste@exemplo.com',
        cnpj: '',
        telefone: '',
        endereco: '',
      ),
    ];

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
