import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';
import 'package:intl/intl.dart';

class SalesPage extends StatelessWidget {
  final String email;
  const SalesPage({Key? key, required this.email}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchSales() async {
    final response = await Supabase.instance.client
        .from('vendas')
        .select()
        .eq('email', email.trim().toLowerCase())
        .order('data_venda', ascending: false);
    return (response as List).cast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Vendas'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchSales(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(
                child: Text('Você ainda não realizou nenhuma venda.'));
          }
          final sales = snap.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sales.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final sale = sales[i];
              final date = DateTime.parse(sale['data_venda'] as String);
              final formattedDate =
                  DateFormat('dd/MM/yyyy – HH:mm').format(date);
              final total = sale['valor_total'] as num?;
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    'Venda em $formattedDate',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle:
                      Text('Total: R\$ ${total?.toStringAsFixed(2) ?? '0.00'}'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.primaryColor,
                  ),
                  onTap: () {
                    // Se tiver detalhes, navegue para detalhes da venda:
                    // Modular.to.pushNamed('/venda/details', arguments: sale);
                    //futuramente, implementar a navegação para detalhes da venda
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento!'),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

